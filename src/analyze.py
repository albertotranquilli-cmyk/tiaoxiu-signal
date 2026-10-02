"""Step 2: all estimates, controls, placebos, holdouts and robustness checks.
Writes results/results.json, results/*.csv and figures/*.png. Deterministic (fixed seeds)."""
import json, os, sys
import numpy as np, pandas as pd
from scipy.stats import spearmanr, norm, false_discovery_control
from core import (panel, load_repos, event_terms, share, MAKEUP, holiday_events, DER, ROOT, BLOCKED, dt)
from placebo import placebo_matrix

RES = os.path.join(ROOT, "results"); os.makedirs(RES, exist_ok=True)
FIG = os.path.join(ROOT, "figures"); os.makedirs(FIG, exist_ok=True)
K = 500
MIN_DEN, MIN_TITLES = 10, 30
OUT = {}


def pooled(num, den):
    return float(num.sum() / den.sum()) if den.sum() > 0 else float("nan")


def boot_ci(num, den, B=2000, seed=1):
    rng = np.random.default_rng(seed); n = len(num)
    if n == 0:
        return [float("nan")] * 2
    idx = rng.integers(0, n, (B, n))
    v = num[idx].sum(1) / den[idx].sum(1)
    return [float(np.percentile(v, 2.5)), float(np.percentile(v, 97.5))]


def boot_ci_2way(NE, DE, B=1000, seed=1):
    """Two-way (repos x event days) pairs bootstrap of sum(A-E)/sum(W-E). With only 12 (E1) or 4 (E2)
    make-up days, day-to-day variation is a large part of the uncertainty; a repo-only bootstrap ignores it."""
    rng = np.random.default_rng(seed); R, J = NE.shape
    if R == 0 or J == 0:
        return [float("nan")] * 2
    v = np.empty(B)
    for b in range(B):
        ri = rng.integers(0, R, R); dj = rng.integers(0, J, J)
        v[b] = NE[ri][:, dj].sum() / DE[ri][:, dj].sum()
    return [float(np.percentile(v, 2.5)), float(np.percentile(v, 97.5))]


TERMS = {}  # era -> (A-E, W-E) matrices, repos x make-up days
PLACEBO = {}  # era -> (PN, PD) placebo numerators/denominators, repos x K


def group_stats(mask, n, d, PN, PD, era=None):
    real = pooled(n[mask], d[mask]); pl = PN[mask].sum(0) / PD[mask].sum(0)
    extra = {}
    if era in TERMS:
        NE, DE = TERMS[era]
        extra["ci95_two_way"] = boot_ci_2way(NE[mask], DE[mask])
    return {"repos": int(mask.sum()), "s": real, "ci95": boot_ci(n[mask], d[mask]), **extra,
            "placebo_mean": float(pl.mean()), "placebo_sd": float(pl.std()),
            "z_vs_placebo": float((real - pl.mean()) / pl.std()) if pl.std() > 0 else None,
            "p_perm": float((1 + (pl >= real).sum()) / (1 + len(pl)))}


def repo_table(era, M, r, measure="actors"):
    A, W, E, used = event_terms(M, MAKEUP, "makeup"); n, d = share(A, W, E, "makeup")
    TERMS[era] = (A - E, W - E)
    PN, PD = placebo_matrix(M, used, "makeup", K=K, seed=0)
    PLACEBO[era] = (PN, PD)
    s = n / np.where(d > 0, d, np.nan); sp = PN / np.where(PD > 0, PD, np.nan)
    mu, sd = np.nanmean(sp, 1), np.nanstd(sp, 1)
    z = (s - mu) / sd
    H = holiday_events(M); A2, W2, E2, uh = event_terms(M, H, "holiday"); n2, d2 = share(A2, W2, E2, "holiday")
    t = pd.DataFrame({"num": n, "den": d, "s": s, "z": z, "W": W.mean(1), "E": E.mean(1),
                      "hol_num": n2, "hol_den": d2, "s_hol": n2 / np.where(d2 > 0, d2, np.nan)}, index=M.index)
    t = t.join(r[["actors", "events", "titles", "zh", "ja", "ko", "ru", "hans", "hant"]])
    t["eligible"] = (t.den >= MIN_DEN) & (t.titles >= MIN_TITLES)
    t["p"] = norm.sf(t.z.fillna(-99)); t["q"] = np.nan
    # empirical one-sided placebo p-value: the normal approximation is anticonservative for
    # ratio-of-small-counts statistics (red-team: ~1.8% of null draws below nominal p=0.01)
    t["p_emp"] = (1 + (sp >= s[:, None]).sum(1)) / (1 + sp.shape[1]); t["q_emp"] = np.nan
    el = t.eligible.values
    t.loc[el, "q"] = false_discovery_control(t.p.values[el])
    t.loc[el, "q_emp"] = false_discovery_control(t.p_emp.values[el])
    return t, used, uh, PN, PD


def main():
    tables = {}
    for era in ("E1", "E2"):
        M = panel(era); r = load_repos(era).reindex(M.index)
        t, used, uh, PN, PD = repo_table(era, M, r)
        tables[era] = (t, M)
        el = t.eligible.values; n, d = t.num.values, t.den.values
        e = {"repos_in_panel": int(len(t)), "eligible_repos": int(el.sum()), "panel_days": int(M.shape[1]),
             "makeup_events": [str(x) for x in used], "holiday_events": [str(x) for x in uh]}
        bins = [("zh<1%", t.zh < 0.01), ("zh 1-5%", (t.zh >= 0.01) & (t.zh < 0.05)), ("zh 5-20%", (t.zh >= 0.05) & (t.zh < 0.2)),
                ("zh>=20%", t.zh >= 0.2), ("zh>=1%", t.zh >= 0.01), ("all", t.zh >= 0),
                ("zh=0", t.zh == 0), ("0<zh<1%", (t.zh > 0) & (t.zh < 0.01))]
        e["groups"] = {k: group_stats(el & m.values, n, d, PN, PD, era=era) for k, m in bins}
        ok = t[t.eligible]
        e["spearman_s_vs_zh"] = float(spearmanr(ok.s, ok.zh).statistic)
        hh = ok.dropna(subset=["s_hol"])
        e["spearman_s_makeup_vs_s_holiday"] = float(spearmanr(hh.s, hh.s_hol).statistic)
        e["holiday_dip_by_group"] = {k: pooled(t.hol_num.values[el & m.values], t.hol_den.values[el & m.values]) for k, m in bins}
        e["bh_q05_repos"] = int((t.q < 0.05).sum())
        e["bh_q05_repos_zh_lt_1pct"] = int(((t.q < 0.05) & (t.zh < 0.01)).sum())
        e["bh_q05_repos_zh_ge_1pct"] = int(((t.q < 0.05) & (t.zh >= 0.01)).sum())
        e["bh_emp_q05_repos"] = int((t.q_emp < 0.05).sum())
        e["bh_emp_q05_repos_zh_lt_1pct"] = int(((t.q_emp < 0.05) & (t.zh < 0.01)).sum())
        e["bh_emp_q05_repos_zh_eq_0"] = int(((t.q_emp < 0.05) & (t.zh == 0)).sum())
        # equal-weekend-ratio translation: share of eligible repos' weekday actor-days on the PRC calendar
        OUT[era] = e
        t.to_csv(os.path.join(RES, f"repo_estimates_{era}.csv"), float_format="%.5g")
        # organisations (only orgs with >= 6 eligible repos are reported; these are large institutions)
        t2 = t[t.eligible].copy(); t2["org"] = [x.split("/")[0] for x in t2.index]
        pos = {x: i for i, x in enumerate(t.index)}
        rows = []
        for org, g in t2.groupby("org"):
            if len(g) < 6:
                continue
            ii = [pos[x] for x in g.index]
            pl = PN[ii].sum(0) / PD[ii].sum(0)
            s_ = pooled(g.num.values, g.den.values)
            NE, DE = TERMS[era]
            c2 = boot_ci_2way(NE[ii], DE[ii])
            gn = g.num.sort_values(ascending=False)
            top5 = set(gn.index[:5])
            rest = g[~g.index.isin(top5)]
            rows.append({"org": org, "repos": len(g), "s": s_, "ci95_lo": c2[0], "ci95_hi": c2[1],
                         "ci95_repo_only_lo": boot_ci(g.num.values, g.den.values)[0],
                         "ci95_repo_only_hi": boot_ci(g.num.values, g.den.values)[1], "z": (s_ - pl.mean()) / pl.std(),
                         "median_repo_s": float(g.s.median()),
                         "top10_share_of_numerator": float(gn.iloc[:10].sum() / gn.sum()) if gn.sum() > 0 else float("nan"),
                         "s_without_top5": pooled(rest.num.values, rest.den.values),
                         "zh_title_share": float((g.zh * g.titles).sum() / g.titles.sum()),
                         "repos_s_gt_0.5_and_q_lt_0.05": int(((g.s > 0.5) & (g.q < 0.05)).sum()), "den": g.den.sum()})
        pd.DataFrame(rows).sort_values("den", ascending=False).to_csv(os.path.join(RES, f"orgs_{era}.csv"), index=False, float_format="%.4g")
        print(era, json.dumps(e["groups"], indent=1)[:3000])

    # ---- temporal holdout: classify on E1, test on E2 (different repos' years, different days)
    t1, _ = tables["E1"]; t2, M2 = tables["E2"]
    common = t1.index[t1.eligible].intersection(t2.index[t2.den >= 5])
    h = {"common_repos": int(len(common))}
    a, b = t1.loc[common], t2.loc[common]
    h["spearman_E1_s_vs_E2_s"] = float(spearmanr(a.s, b.s).statistic)
    h["spearman_E1_s_vs_E2_holiday_dip"] = float(spearmanr(a.s, b.s_hol, nan_policy="omit").statistic)
    # flags use empirical placebo p-values (BH q_emp < 0.05) and s > 0.3
    fl = (a.q_emp < 0.05) & (a.s > 0.3)
    groups = {"E1 flagged (q_emp<0.05, s>0.3)": fl,
              "E1 flagged & zh<1%": fl & (a.zh < 0.01),
              "E1 not flagged": ~fl}
    pos2 = {x: i for i, x in enumerate(t2.index)}
    NE2, DE2 = TERMS["E2"]; PN2, PD2 = PLACEBO["E2"]
    h["note"] = "E2 is measured with degraded GH Archive capture and only 4 make-up days: sign only, magnitudes not comparable with E1"
    for k, m in groups.items():
        bb = b[m.values]
        ii = [pos2[x] for x in bb.index]
        pl = PN2[ii].sum(0) / PD2[ii].sum(0)
        e2s = pooled(bb.num.values, bb.den.values)
        h[k] = {"repos": int(m.sum()), "E1_s": pooled(a.num[m.values].values, a.den[m.values].values),
                "E2_s": e2s, "E2_s_ci95_two_way": boot_ci_2way(NE2[ii], DE2[ii]),
                "E2_placebo_sd": float(pl.std()), "E2_z_vs_placebo": float((e2s - pl.mean()) / pl.std()),
                "E2_holiday_dip": pooled(bb.hol_num.values, bb.hol_den.values),
                "E2_holiday_dip_ci95": boot_ci(bb.hol_num.values, bb.hol_den.values)}
    OUT["holdout_E1_to_E2"] = h
    print(json.dumps(h, indent=1))
    json.dump(OUT, open(os.path.join(RES, "results.json"), "w"), indent=1)


if __name__ == "__main__":
    main()
