"""Step 3: red-team checks. Writes results/robustness.json."""
import json, os, re
import numpy as np, pandas as pd
from scipy.stats import norm
from core import panel, load_repos, event_terms, share, MAKEUP, holiday_events, DER, ROOT, dt
from placebo import placebo_matrix
from analyze import pooled, boot_ci, group_stats, RES

R = {}


def est(M, events, kind="makeup", half=21):
    A, W, E, used = event_terms(M, events, kind, half); n, d = share(A, W, E, kind)
    return n, d, used


def groups_for(M, r, events=MAKEUP, half=21, min_den=10, K=200, mask_extra=None):
    n, d, used = est(M, events, "makeup", half)
    PN, PD = placebo_matrix(M, used, "makeup", K=K, seed=7)
    el = (d >= min_den) & (r.titles.values >= 30)
    if mask_extra is not None:
        el &= mask_extra
    out = {}
    for k, m in {"zh<1%": r.zh.values < 0.01, "zh>=1%": r.zh.values >= 0.01}.items():
        g = group_stats(el & m, n, d, PN, PD)
        out[k] = {"repos": g["repos"], "s": round(g["s"], 4), "z": round(g["z_vs_placebo"], 1)}
    ap = el & np.array([x.startswith("apache/") for x in M.index])
    out["apache"] = {"repos": int(ap.sum()), "s": round(pooled(n[ap], d[ap]), 4)}
    return out


def main():
    M = panel("E1"); r = load_repos("E1").reindex(M.index)
    # 1. window / threshold / measure grid
    R["grid"] = {}
    for half in (14, 21, 28):
        for md in (5, 10, 20, 40):
            R["grid"][f"half={half},min_den={md}"] = groups_for(M, r, half=half, min_den=md)
    Mev = panel("E1", measure="events")
    R["grid"]["measure=events (raw event counts)"] = groups_for(Mev, r, min_den=40)
    # 2. leave-one-event-out
    n, d, used = est(M, MAKEUP)
    R["leave_one_event_out"] = {}
    for u in used:
        R["leave_one_event_out"][str(u)] = groups_for(M, r, events=[x for x in used if x != u], K=100)
    # 3. Saturday-only vs Sunday-only make-up days
    R["saturday_only"] = groups_for(M, r, events=[x for x in used if x.weekday() == 5])
    R["sunday_only"] = groups_for(M, r, events=[x for x in used if x.weekday() == 6])
    # 4. per-event uplift (all eligible repos with zh>=1% / zh<1%)
    A, W, E, used = event_terms(M, used, "makeup")
    el = ((W - E).sum(1) >= 10) & (r.titles.values >= 30)
    pe = {}
    for j, u in enumerate(used):
        row = {}
        for k, m in {"zh<1%": r.zh.values < 0.01, "zh>=1%": r.zh.values >= 0.01}.items():
            mm = el & m
            row[k] = round(float((A[mm, j] - E[mm, j]).sum() / (W[mm, j] - E[mm, j]).sum()), 4)
        pe[str(u)] = row
    R["per_event"] = pe
    # 5. drop campaign/course/tutorial repos (event-driven schedules)
    pat = re.compile(r"hacktoberfest|first-contrib|bootcamp|course|precourse|lab|challenge|assignment|sprint|mission|campaign|workshop|tutorial|student|cs\d|homework|learn", re.I)
    keep = np.array([not pat.search(x) for x in M.index])
    R["drop_campaign_course_repos"] = groups_for(M, r, mask_extra=keep)
    R["drop_campaign_course_repos"]["dropped"] = int((~keep).sum())
    # 6. concentration: remove the 10 / 50 largest contributors to the zh<1% numerator
    n, d, used = est(M, MAKEUP)
    el = (d >= 10) & (r.titles.values >= 30) & (r.zh.values < 0.01)
    order = np.argsort(-np.where(el, n, -np.inf))
    conc = {}
    for drop in (0, 10, 50, 100):
        mm = el.copy(); mm[order[:drop]] = False
        conc[f"drop_top_{drop}"] = round(pooled(n[mm], d[mm]), 4)
    R["zh_lt_1pct_concentration"] = conc
    # 6b. near-date placebos (red-team): ordinary same-weekday days 7-21 days from each make-up day
    #     (same season, same holiday neighbourhood), and the ordinary partner day of the same weekend.
    from core import BLOCKED, OFF, WORK
    cols = set(M.columns)
    def nearest(m, sign):
        for k in (7, 14, 21):
            p = m + sign * dt.timedelta(days=k)
            if p in cols and p not in BLOCKED:
                return p
    near = sorted({p for m in used for p in (nearest(m, -1), nearest(m, 1)) if p})
    partner = [m + dt.timedelta(days=(-1 if m.weekday() == 6 else 1)) for m in used]
    partner = [p for p in partner if p in cols and p not in OFF and p not in WORK]
    R["near_date_placebo"] = groups_for(M, r, events=near); R["near_date_placebo"]["days"] = [str(x) for x in near]
    R["partner_day_placebo"] = groups_for(M, r, events=partner); R["partner_day_placebo"]["days"] = [str(x) for x in partner]
    # partner-day difference-in-differences on ONE common repo set (the main eligible set):
    # make-up days of those weekends minus their ordinary partner days
    pairs = [(m, m + dt.timedelta(days=(-1 if m.weekday() == 6 else 1))) for m in used]
    pairs = [(m, p) for m, p in pairs if p in cols and p not in OFF and p not in WORK]
    n0, d0, _ = est(M, MAKEUP); el0 = (d0 >= 10) & (r.titles.values >= 30)
    n1, d1, _ = est(M, [m for m, p in pairs]); n2, d2, _ = est(M, [p for m, p in pairs])
    did = {"pairs": [[str(m), str(p)] for m, p in pairs]}
    for k, msk in {"zh<1%": r.zh.values < 0.01, "zh>=1%": r.zh.values >= 0.01, "zh=0": r.zh.values == 0}.items():
        mm = el0 & msk
        a_, b_ = pooled(n1[mm], d1[mm]), pooled(n2[mm], d2[mm])
        did[k] = {"repos": int(mm.sum()), "makeup_days_of_these_weekends": round(a_, 4), "partner_days": round(b_, 4), "DiD": round(a_ - b_, 4)}
    R["partner_day_DiD_common_set"] = did
    # 7. same-time-zone negative controls (lower-threshold panel; mostly-Japanese/Korean/Traditional/Simplified titles)
    C = panel("E1", fname="controls_E1_daily.csv.gz")
    cr = pd.read_csv(os.path.join(DER, "controls_E1_repos.csv")).set_index("repo_name").reindex(C.index)
    t = cr.titles.clip(lower=1)
    lang = pd.Series("other", index=C.index)
    lang[(cr.t_ja / t) >= 0.3] = "Japanese (kana) >=30%"
    lang[(cr.t_ko / t) >= 0.3] = "Korean (Hangul) >=30%"
    zh = (cr.t_zh / t) >= 0.3
    lang[zh & (cr.t_hant > 2 * cr.t_hans) & (cr.t_hant >= 5)] = "Chinese, Traditional-dominant >=30%"
    lang[zh & (cr.t_hans > 2 * cr.t_hant) & (cr.t_hans >= 5)] = "Chinese, Simplified-dominant >=30%"
    n, d, used = est(C, MAKEUP)
    PN, PD = placebo_matrix(C, used, "makeup", K=500, seed=3)
    Hn, Hd, uh = est(C, holiday_events(C), "holiday")
    ctrl = {}
    for g in sorted(lang.unique()):
        m = (lang.values == g) & (d >= 5)
        gs = group_stats(m, n, d, PN, PD)
        gs["holiday_dip"] = pooled(Hn[m], Hd[m]); gs["holiday_dip_ci95"] = boot_ci(Hn[m], Hd[m])
        gs["weekend_to_weekday_ratio"] = float((d[m] >= 0).mean()) if False else None
        ctrl[g] = gs
    R["same_timezone_controls"] = ctrl
    json.dump(R, open(os.path.join(RES, "robustness.json"), "w"), indent=1)
    print(json.dumps(R, indent=1))


if __name__ == "__main__":
    main()
