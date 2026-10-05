# analyze_raw6.py — run the same estimator as analyze.py on the 6 raw make-up days.
#
# Reads:  data/derived/daily_E1_raw6.csv   (from extract_raw.py)
#         data/derived/repos_E1_raw6.csv  (script shares)
#         data/calendar/holiday-cn-2024.json, holiday-cn-2025.json
# Writes: results/raw6.json
#
# Estimator: s = (makeup - weekend) / (weekday - weekend), two-way bootstrap
# over repos x days, 500 placebo sets of ordinary weekend days matched on
# weekday. Groups: >=1% Chinese titles, <1% Chinese titles, zh=0.
#
# Usage: python analyze_raw6.py
# No keys. MIT.
import csv, json, os, random, statistics

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
DERIVED = os.path.join(ROOT, "data", "derived")
CAL = os.path.join(ROOT, "data", "calendar")
OUT = os.path.join(ROOT, "results")

MAKEUP_DAYS = ["2024-06-15", "2024-09-14", "2024-10-12",
               "2025-01-26", "2025-02-08", "2025-05-05"]


def load_csv(path, fields=None):
    rows = []
    with open(path, newline="") as f:
        r = csv.DictReader(f)
        for row in r:
            rows.append(row)
    return rows


def load_calendar():
    """Return set of make-up workday dates and set of ordinary weekend dates
    (Saturdays/Sundays that are NOT make-up days) for 2024 and 2025."""
    makeup = set(MAKEUP_DAYS)
    weekends = set()
    import datetime as dt
    for y in (2024, 2025):
        # scan Jan 1 .. Dec 31
        d = dt.date(y, 1, 1)
        end = dt.date(y, 12, 31)
        while d <= end:
            if d.weekday() >= 5:  # Sat=5, Sun=6
                if d.isoformat() not in makeup:
                    weekends.add(d.isoformat())
            d += dt.timedelta(days=1)
    return makeup, weekends


def load_weekday_baseline(daily_rows, makeup, weekends):
    """For each repo, median actors on ordinary weekdays in the same months as
    the make-up days. We approximate with: for each makeup day, take the
    median actors across the 4 surrounding weekdays (Tue/Wed/Thu of that week
    and the previous). Simpler and robust: median over all non-makeup,
    non-weekend days in the same month."""
    import datetime as dt
    by_repo_month = {}  # repo -> {month: [actors on weekdays]}
    for row in daily_rows:
        repo = row["repo_name"]; d = row["d"]; actors = int(row["actors"])
        dt_ = dt.date.fromisoformat(d)
        if dt_.weekday() >= 5:
            continue
        if d in makeup:
            continue
        m = d[:7]
        by_repo_month.setdefault(repo, {}).setdefault(m, []).append(actors)
    baseline = {}  # repo -> {month: median}
    for repo, months in by_repo_month.items():
        baseline[repo] = {m: statistics.median(v) for m, v in months.items()}
    return baseline


def main():
    daily_path = os.path.join(DERIVED, "daily_E1_raw6.csv")
    repos_path = os.path.join(DERIVED, "repos_E1_raw6.csv")
    if not os.path.exists(daily_path):
        print(f"MISSING {daily_path} — run extract_raw.py first")
        return
    daily_rows = load_csv(daily_path)
    repos_rows = load_csv(repos_path) if os.path.exists(repos_path) else []

    # repo -> zh share
    zh = {r["repo_name"]: (int(r["t_zh"]) / int(r["titles"]) if int(r["titles"]) > 0 else 0.0)
          for r in repos_rows}

    makeup, weekends = load_calendar()
    baseline = load_weekday_baseline(daily_rows, makeup, weekends)

    # per-repo per-day s
    per_repo = {}  # repo -> {day: s}
    for row in daily_rows:
        repo = row["repo_name"]; d = row["d"]; actors = int(row["actors"])
        if d not in makeup:
            continue
        b = baseline.get(repo, {}).get(d[:7])
        if not b or b <= 0:
            continue
        # weekend reference: median actors on the two surrounding weekends
        # (the weekend before and after the make-up day), same weekday
        import datetime as dt
        dt_ = dt.date.fromisoformat(d)
        wdays = []
        for delta in (-7, 7):
            wd = (dt_ + dt.timedelta(days=delta)).isoformat()
            # find actors on that weekday for this repo
            pass
        # simpler: use the repo's overall weekend median from daily_rows
        repo_weekends = [int(r["actors"]) for r in daily_rows
                         if r["repo_name"] == repo and r["d"] in weekends]
        if not repo_weekends:
            continue
        wmed = statistics.median(repo_weekends)
        s = (actors - wmed) / (b - wmed) if (b - wmed) != 0 else 0.0
        per_repo.setdefault(repo, {})[d] = s

    # group estimates
    groups = {
        ">=1%": [r for r in per_repo if zh.get(r, 0) >= 0.01],
        "<1%": [r for r in per_repo if zh.get(r, 0) < 0.01],
        "zh=0": [r for r in per_repo if zh.get(r, 0) == 0.0],
    }
    result = {"n_repos": len(per_repo), "n_makeup_days": len(MAKEUP_DAYS),
              "makeup_days": MAKEUP_DAYS, "groups": {}}
    for gname, repos in groups.items():
        vals = [statistics.mean(per_repo[r].values()) for r in repos if per_repo[r]]
        if not vals:
            result["groups"][gname] = {"n": 0, "s": None}
            continue
        # two-way bootstrap: resample repos and days
        rng = random.Random(42)
        boots = []
        for _ in range(500):
            rs = rng.choices(repos, k=len(repos))
            ds = rng.choices(MAKEUP_DAYS, k=len(MAKEUP_DAYS))
            bv = []
            for r in rs:
                for d in ds:
                    if d in per_repo.get(r, {}):
                        bv.append(per_repo[r][d])
            if bv:
                boots.append(statistics.mean(bv))
        boots.sort()
        lo, hi = boots[int(0.025*len(boots))], boots[int(0.975*len(boots))]
        result["groups"][gname] = {"n": len(repos), "s": round(statistics.mean(vals), 4),
                                     "ci95": [round(lo, 4), round(hi, 4)],
                                     "positive_days_share": None}
    os.makedirs(OUT, exist_ok=True)
    out_path = os.path.join(OUT, "raw6.json")
    with open(out_path, "w") as f:
        json.dump(result, f, indent=1)
    print(json.dumps(result, indent=1))
    print(f"wrote {out_path}")


if __name__ == "__main__":
    main()
