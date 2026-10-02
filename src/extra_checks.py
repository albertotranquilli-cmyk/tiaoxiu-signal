"""Step 4: within-era split-half holdout, weekend-ratio check, GitHub-wide estimate. Writes results/extra_checks.json."""
import json, os
import numpy as np, pandas as pd
from scipy.stats import spearmanr, norm, false_discovery_control
from core import panel, load_repos, event_terms, share, MAKEUP, DER, ROOT, dt
from placebo import placebo_matrix
from analyze import pooled, boot_ci, RES

X = {}


def per_repo(M, events, K=300, seed=11):
    A, W, E, used = event_terms(M, events, "makeup"); n, d = share(A, W, E, "makeup")
    PN, PD = placebo_matrix(M, used, "makeup", K=K, seed=seed)
    s = n / np.where(d > 0, d, np.nan); sp = PN / np.where(PD > 0, PD, np.nan)
    z = (s - np.nanmean(sp, 1)) / np.nanstd(sp, 1)
    return n, d, s, z, W.mean(1), E.mean(1)


def main():
    M = panel("E1"); r = load_repos("E1").reindex(M.index)
    ev23 = [m for m in MAKEUP if m.year == 2023]; ev24 = [m for m in MAKEUP if m.year == 2024 and m in set(M.columns)]
    n1, d1, s1, z1, W1, E1 = per_repo(M, ev23)
    n2, d2, s2, z2, W2, E2 = per_repo(M, ev24)
    el = (d1 >= 10) & (d2 >= 5) & (r.titles.values >= 30)
    p1 = norm.sf(np.nan_to_num(z1[el], nan=-99)); q1 = false_discovery_control(p1)
    flag = np.zeros(len(M), bool); flag[np.where(el)[0][(q1 < 0.05) & (s1[el] > 0.3)]] = True
    hid = flag & (r.zh.values < 0.01)
    X["split_half_2023_to_2024"] = {
        "events_2023": [str(x) for x in ev23], "events_2024": [str(x) for x in ev24],
        "repos": int(el.sum()), "spearman_s2023_vs_s2024": float(spearmanr(s1[el], s2[el]).statistic),
        "flagged_2023": int(flag.sum()), "flagged_2023_s_in_2024": pooled(n2[flag], d2[flag]), "ci95": boot_ci(n2[flag], d2[flag]),
        "flagged_2023_zh_lt_1pct": int(hid.sum()), "hidden_s_in_2024": pooled(n2[hid], d2[hid]), "hidden_ci95": boot_ci(n2[hid], d2[hid]),
        "not_flagged_s_in_2024": pooled(n2[el & ~flag], d2[el & ~flag]), "not_flagged_ci95": boot_ci(n2[el & ~flag], d2[el & ~flag]),
    }
    # weekend/weekday ratio by script group (tests the equal-weekend-ratio assumption)
    n, d, s, z, W, E = per_repo(M, MAKEUP, K=50)
    el = (d >= 10) & (r.titles.values >= 30)
    X["weekend_over_weekday_ratio"] = {k: float(np.median((E / W)[el & m])) for k, m in {
        "zh<1%": r.zh.values < 0.01, "zh>=20%": r.zh.values >= 0.2}.items()}
    # GitHub-wide (all public repos, all human work events) – context only
    g = pd.read_csv(os.path.join(DER, "global_daily.csv")); g["d"] = pd.to_datetime(g.d).dt.date
    g = g[g.hours >= 24].set_index("d")
    out = {}
    for era, (a, b) in {"E1": ("2023-01-15", "2024-06-03"), "E2": ("2025-10-16", "2026-07-01")}.items():
        gg = g[(g.index >= dt.date.fromisoformat(a)) & (g.index <= dt.date.fromisoformat(b))]
        G = pd.DataFrame([gg.actors.values], index=["github"], columns=list(gg.index))
        A, W, E, used = event_terms(G, MAKEUP, "makeup"); nn, dd = share(A, W, E, "makeup")
        PN, PD = placebo_matrix(G, used, "makeup", K=500, seed=5); pl = PN[0] / PD[0]
        out[era] = {"events": len(used), "s": float(nn[0] / dd[0]), "placebo_sd": float(pl.std()),
                    "p_perm": float((1 + (pl >= nn[0] / dd[0]).sum()) / 501)}
    X["github_wide_actor_days"] = out
    ig = pd.read_csv(os.path.join(ROOT, "data", "external", "ig_developers.csv"))
    ig = ig[ig.iso2_code != "EU"]; tot = ig.groupby(["year", "quarter"]).developers.sum()
    cn = ig[ig.iso2_code == "CN"].set_index(["year", "quarter"]).developers
    X["innovation_graph_CN_developer_share"] = {f"{y}Q{q}": round(float(v), 4) for (y, q), v in (cn / tot).items() if y >= 2023}
    json.dump(X, open(os.path.join(RES, "extra_checks.json"), "w"), indent=1)
    print(json.dumps(X, indent=1))


if __name__ == "__main__":
    main()
