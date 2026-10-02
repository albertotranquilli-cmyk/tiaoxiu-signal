"""Step 4c (red-team follow-up): two mechanism checks on E1, using extra aggregate queries.

A. Hour-of-day profile (Asia/Shanghai hours) of the make-up-day excess and of the normal
   weekday-weekend gap, in actor-hours (distinct accounts per repo per hour). The per-date weights
   reproduce the estimator's sum_m (A_m - E_m) and sum_m (W_m - E_m) exactly at hourly resolution.
B. Day-boundary sensitivity: the same daily estimator with UTC calendar days instead of
   Asia/Shanghai days.
Writes results/mechanism.json (group-level only).
"""
import json, os, gzip, csv
import numpy as np, pandas as pd
from ch import rows
from core import (panel, load_repos, event_terms, share, MAKEUP, ref_days, DER, dt)
from extract import ERAS, WORK, HUMAN, months, sel
from placebo import placebo_matrix
from analyze import RES, group_stats

OFFICE = set(range(9, 19))  # 09:00-18:59 CST


def date_weights(cols, events=None):
    """Global per-date weights such that sum_d w(d) x_d = sum_m (A_m - E_m) [excess] or sum_m (W_m - E_m) [gap]."""
    wex, wgap = {}, {}
    for m in (events or MAKEUP):
        if m not in cols:
            continue
        R = ref_days(m, cols)
        wk = [d for d in R if d.weekday() < 5]; we = [d for d in R if d.weekday() == m.weekday()]
        if len(wk) < 5 or len(we) < 2:
            continue
        wex[m] = wex.get(m, 0) + 1.0
        for d in we:
            wex[d] = wex.get(d, 0) - 1.0 / len(we); wgap[d] = wgap.get(d, 0) - 1.0 / len(we)
        for d in wk:
            wgap[d] = wgap.get(d, 0) + 1.0 / len(wk)
    return wex, wgap


def hourly(era="E1", events=None):
    M = panel(era); cols = list(M.columns)
    wex, wgap = date_weights(cols, events)
    dates = sorted(set(wex) | set(wgap))
    dl = ",".join(f"toDate('{d}')" for d in dates)
    ex = ",".join(f"{wex.get(d, 0.0):.10f}" for d in dates); gp = ",".join(f"{wgap.get(d, 0.0):.10f}" for d in dates)
    a, b, _ = ERAS[era]
    out = []
    for s, e in months(a, b):
        out += rows(f"""
SELECT repo_name, h, sum(a * transform(d, [{dl}], [{ex}], 0.)) AS excess, sum(a * transform(d, [{dl}], [{gp}], 0.)) AS gap
FROM (SELECT repo_name, toDate(created_at + INTERVAL 8 HOUR) AS d, toHour(created_at + INTERVAL 8 HOUR) AS h, uniqExact(actor_login) AS a
      FROM github_events
      WHERE created_at >= '{s}' AND created_at < '{e}' AND event_type IN {WORK} AND {HUMAN}
        AND toDate(created_at + INTERVAL 8 HOUR) IN [{dl}]
        AND repo_name IN ({sel(era)})
      GROUP BY repo_name, d, h)
GROUP BY repo_name, h""")
    df = pd.DataFrame(out); df["h"] = df.h.astype(int); df["excess"] = df.excess.astype(float); df["gap"] = df.gap.astype(float)
    return df.groupby(["repo_name", "h"])[["excess", "gap"]].sum().reset_index()


def utc_panel(era="E1"):
    a, b, _ = ERAS[era]
    out, hrs = [], []
    for s, e in months(a, b):
        out += rows(f"""
SELECT repo_name, toDate(created_at) AS d, uniqExact(actor_login) AS actors
FROM github_events
WHERE created_at >= '{s}' AND created_at < '{e}' AND event_type IN {WORK} AND {HUMAN}
  AND repo_name IN ({sel(era)})
GROUP BY repo_name, d""")
        hrs += rows(f"""
SELECT toDate(created_at) AS d, uniqExact(toStartOfHour(created_at)) AS hours
FROM github_events WHERE created_at >= '{s}' AND created_at < '{e}' GROUP BY d""")
    df = pd.DataFrame(out); df["d"] = pd.to_datetime(df.d).dt.date; df["actors"] = df.actors.astype(int)
    hh = pd.DataFrame(hrs); hh["d"] = pd.to_datetime(hh.d).dt.date; hh["hours"] = hh.hours.astype(int)
    full = set(hh.groupby("d").hours.sum().loc[lambda x: x >= 24].index)
    lo, hi = dt.date.fromisoformat(a[:10]) + dt.timedelta(days=1), dt.date.fromisoformat(b[:10]) - dt.timedelta(days=1)
    days = sorted(d for d in set(df.d) if d in full and lo <= d <= hi)  # drop the two partial edge days
    return df.pivot_table(index="repo_name", columns="d", values="actors", aggfunc="sum").reindex(columns=days).fillna(0)


def main():
    X = {}
    r = load_repos("E1")
    Mcn = panel("E1"); A, W, E, used = event_terms(Mcn, MAKEUP, "makeup"); n, d = share(A, W, E, "makeup")
    rr = r.reindex(Mcn.index)
    el = pd.Series((d >= 10) & (rr.titles.values >= 30), index=Mcn.index)
    groups = {"zh<1%": el & (rr.zh < 0.01), "zh>=1%": el & (rr.zh >= 0.01), "zh=0": el & (rr.zh == 0)}
    # A. hourly profile
    hdf = hourly("E1")
    prof = {}
    for k, m in groups.items():
        g = hdf[hdf.repo_name.isin(m[m].index)].groupby("h")[["excess", "gap"]].sum().reindex(range(24), fill_value=0)
        prof[k] = {"excess_share_09_19_CST": float(g.excess[list(OFFICE)].sum() / g.excess.sum()),
                   "gap_share_09_19_CST": float(g.gap[list(OFFICE)].sum() / g.gap.sum()),
                   "s_inside_09_19": float(g.excess[list(OFFICE)].sum() / g.gap[list(OFFICE)].sum()),
                   "s_outside_09_19": float(g.excess[[h for h in range(24) if h not in OFFICE]].sum() / g.gap[[h for h in range(24) if h not in OFFICE]].sum()),
                   "excess_by_hour_CST": [round(float(x), 2) for x in g.excess.values],
                   "gap_by_hour_CST": [round(float(x), 2) for x in g.gap.values]}
    X["hour_of_day_CST"] = prof
    # A2. same profile for the ordinary partner day of the 5 make-up weekends where it is ordinary
    from core import OFF, WORK
    cols = set(Mcn.columns)
    partner = [m + dt.timedelta(days=(-1 if m.weekday() == 6 else 1)) for m in used]
    partner = [p for p in partner if p in cols and p not in OFF and p not in WORK]
    hp = hourly("E1", events=partner)
    pp = {"days": [str(x) for x in partner]}
    for k, m in groups.items():
        g = hp[hp.repo_name.isin(m[m].index)].groupby("h")[["excess", "gap"]].sum().reindex(range(24), fill_value=0)
        pp[k] = {"excess_inside_09_19_CST": float(g.excess[list(OFFICE)].sum()),
                 "excess_outside_09_19_CST": float(g.excess[[h for h in range(24) if h not in OFFICE]].sum()),
                 "s_inside_09_19": float(g.excess[list(OFFICE)].sum() / g.gap[list(OFFICE)].sum()),
                 "s_outside_09_19": float(g.excess[[h for h in range(24) if h not in OFFICE]].sum() / g.gap[[h for h in range(24) if h not in OFFICE]].sum())}
    X["partner_days_hour_of_day_CST"] = pp
    # B. UTC day boundary
    Mu = utc_panel("E1"); ru = r.reindex(Mu.index)
    A, W, E, usedu = event_terms(Mu, MAKEUP, "makeup"); nu, du = share(A, W, E, "makeup")
    PN, PD = placebo_matrix(Mu, usedu, "makeup", K=200, seed=9)
    elu = (du >= 10) & (ru.titles.values >= 30)
    X["utc_day_boundary"] = {k: {kk: vv for kk, vv in group_stats(elu & m, nu, du, PN, PD).items() if kk in ("repos", "s", "placebo_sd", "z_vs_placebo")}
                             for k, m in {"zh<1%": ru.zh.values < 0.01, "zh>=1%": ru.zh.values >= 0.01}.items()}
    X["utc_day_boundary"]["events"] = [str(x) for x in usedu]
    json.dump(X, open(os.path.join(RES, "mechanism.json"), "w"), indent=1)
    print(json.dumps({k: {kk: vv for kk, vv in v.items() if "by_hour" not in kk} for k, v in prof.items()}, indent=1))
    print(json.dumps(X["utc_day_boundary"], indent=1)); print(json.dumps(pp, indent=1))


if __name__ == "__main__":
    main()
