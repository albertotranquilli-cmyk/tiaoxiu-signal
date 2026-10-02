"""Core estimator: the "calendar-swap" share.

For a repository, let W = its mean daily distinct human actors on ordinary weekdays and
E = its mean on ordinary weekend days (same weekday as the event), both measured in a local
reference window around the event. On a mainland-China make-up workday (a Saturday/Sunday that
is an official working day only in mainland China) the repo shows A actors.

    s_makeup = sum_m (A_m - E_m) / sum_m (W_m - E_m)

is the fraction of the repo's weekday-over-weekend activity gap that "switches on" when only
mainland China goes to work. If every contributor group has the same weekend/weekday ratio, s
equals the share of weekday activity coming from people on the mainland-China work calendar.

The mirror-image estimator uses China-only holiday weekdays (H): s_holiday = sum(W-H)/sum(W-E).
"""
import gzip, os, datetime as dt
import numpy as np, pandas as pd
from ch import ROOT
from calendar_cn import load_cn, GLOBAL_HOLIDAYS

DER = os.path.join(ROOT, "data", "derived")
OFF, WORK, NAME = load_cn()
MAKEUP = sorted(d for d in WORK if d.weekday() >= 5)


def complete_days():
    g = pd.read_csv(os.path.join(DER, "global_daily.csv"))
    g["d"] = pd.to_datetime(g["d"]).dt.date
    return set(g.loc[g.hours >= 24, "d"])


def panel(era, measure="actors", fname=None):
    df = pd.read_csv(os.path.join(DER, fname or f"daily_{era}.csv.gz"))
    df["d"] = pd.to_datetime(df["d"]).dt.date
    comp = complete_days()
    days = sorted(d for d in set(df.d) if d in comp)
    M = df.pivot_table(index="repo_name", columns="d", values=measure, aggfunc="sum").reindex(columns=days).fillna(0)
    return M


def _blocked():
    """Days that may not be used as reference: China holidays +-2 days, make-up days, global holidays."""
    b = set(GLOBAL_HOLIDAYS) | set(WORK)
    for d in OFF:
        for k in range(-2, 3):
            b.add(d + dt.timedelta(days=k))
    return b

BLOCKED = _blocked()


def ref_days(m, days, half=21, extra_block=()):
    days = set(days)
    out = [m + dt.timedelta(days=k) for k in range(-half, half + 1) if k != 0]
    return [d for d in out if d in days and d not in BLOCKED and d not in extra_block]


def event_terms(M, events, kind, half=21):
    """Return (A, W, E) matrices (repos x events) for a list of event days.
    kind='makeup' : E = same-weekday weekend mean;  kind='holiday': E = all-weekend mean."""
    cols = list(M.columns); colset = set(cols)
    A, W, E, used = [], [], [], []
    for m in events:
        if m not in colset:
            continue
        R = ref_days(m, cols, half)
        wk = [d for d in R if d.weekday() < 5]
        if kind == "makeup":
            we = [d for d in R if d.weekday() == m.weekday()]
        else:
            we = [d for d in R if d.weekday() >= 5]
        if len(wk) < 5 or len(we) < 2:
            continue
        A.append(M[m].values); W.append(M[wk].mean(axis=1).values); E.append(M[we].mean(axis=1).values); used.append(m)
    return np.array(A).T, np.array(W).T, np.array(E).T, used


def share(A, W, E, kind):
    num = (A - E).sum(1) if kind == "makeup" else (W - A).sum(1)
    den = (W - E).sum(1)
    return num, den


def holiday_events(M):
    """China-only holiday weekdays: OFF days falling Mon-Fri, excluding New Year's Day (global)
    and any day that is also a global holiday."""
    return sorted(d for d in OFF if d.weekday() < 5 and NAME[d] != "元旦" and d not in GLOBAL_HOLIDAYS and d in set(M.columns))


def placebo_events(M, events, rng, kind="makeup"):
    """Ordinary weekend (or weekday) days matched on weekday to the real events, drawn from days
    that are not blocked; one placebo day per real event."""
    cols = [d for d in M.columns if d not in BLOCKED]
    out = []
    for m in events:
        pool = [d for d in cols if d.weekday() == m.weekday() and abs((d - m).days) > 7]
        out.append(pool[rng.integers(len(pool))])
    return out


def load_repos(era):
    r = pd.read_csv(os.path.join(DER, f"repos_{era}.csv")).set_index("repo_name")
    v = pd.read_csv(os.path.join(DER, f"repos_{era}_hanvariant.csv")).set_index("repo_name")
    r = r.join(v, how="left").fillna(0)
    t = r.titles.clip(lower=1)
    r["zh"] = r.t_zh / t; r["ja"] = r.t_ja / t; r["ko"] = r.t_ko / t; r["ru"] = r.t_ru / t
    r["hans"] = r.t_hans / t; r["hant"] = r.t_hant / t
    return r
