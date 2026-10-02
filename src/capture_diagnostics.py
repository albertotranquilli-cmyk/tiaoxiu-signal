"""Step 4d: GH Archive capture diagnostics (GitHub-wide, aggregate only).

Answers: does the playground copy capture the same kinds of events in E2 as in E1? Writes
results/capture.json with, per era: mean human work events per weekday/weekend day by event type,
the hour-of-week profile flatness (coefficient of variation, max/min), weekend/weekday ratio, and
the share of opened-PR events with an empty title; plus the monthly series.
"""
import json, os
import numpy as np, pandas as pd
from ch import rows
from extract import ERAS, WORK, HUMAN, months
from analyze import RES


def main():
    per = []; titles = []
    for era, (a, b, _) in ERAS.items():
        for s, e in months(a, b):
            for x in rows(f"""
SELECT event_type, toDayOfWeek(created_at) AS dow, toHour(created_at) AS h, count() AS n
FROM github_events WHERE created_at >= '{s}' AND created_at < '{e}' AND event_type IN {WORK} AND {HUMAN}
GROUP BY event_type, dow, h"""):
                x.update(era=era, month=(s + pd.Timedelta(hours=8)).strftime("%Y-%m")); per.append(x)
            for x in rows(f"""
SELECT count() AS n, countIf(title = '') AS empty FROM github_events
WHERE created_at >= '{s}' AND created_at < '{e}' AND event_type = 'PullRequestEvent' AND action = 'opened'"""):
                x.update(era=era, month=(s + pd.Timedelta(hours=8)).strftime("%Y-%m")); titles.append(x)
    df = pd.DataFrame(per); df["n"] = df.n.astype(float); df["dow"] = df.dow.astype(int); df["h"] = df.h.astype(int)
    g = pd.read_csv(os.path.join(os.path.dirname(RES), "data", "derived", "global_daily.csv"))
    g["d"] = pd.to_datetime(g.d)
    out = {}
    for era in ERAS:
        x = df[df.era == era]
        # day counts (UTC weekdays) for per-day means
        a, b, _ = ERAS[era]
        days = pd.date_range(a[:10], b[:10], freq="D")[1:]
        nwd = int((days.dayofweek < 5).sum()); nwe = int((days.dayofweek >= 5).sum())
        wd = x[x.dow <= 5].groupby("event_type").n.sum() / nwd
        we = x[x.dow >= 6].groupby("event_type").n.sum() / nwe
        how = x.groupby(["dow", "h"]).n.sum()
        t = pd.DataFrame([r for r in titles if r["era"] == era]).astype({"n": float, "empty": float})
        out[era] = {"weekday_events_per_day_by_type": wd.round(0).to_dict(),
                    "weekend_over_weekday_by_type": (we / wd).round(3).to_dict(),
                    "weekend_over_weekday_all": float(we.sum() / wd.sum()),
                    "hour_of_week_cv": float(how.std() / how.mean()), "hour_of_week_max_over_min": float(how.max() / how.min()),
                    "pr_opened_empty_title_share": float(t["empty"].sum() / t["n"].sum())}
    out["E2_over_E1_weekday_events_by_type"] = {k: round(out["E2"]["weekday_events_per_day_by_type"][k] / v - 1, 3)
                                               for k, v in out["E1"]["weekday_events_per_day_by_type"].items()}
    m = df.groupby(["month", "event_type"]).n.sum().unstack()
    out["monthly_events_by_type"] = {k: {kk: int(vv) for kk, vv in v.items()} for k, v in m.T.to_dict().items()}
    out["monthly_pr_opened_empty_title_share"] = {r["month"]: round(float(r["empty"]) / max(float(r["n"]), 1), 4) for r in titles}
    json.dump(out, open(os.path.join(RES, "capture.json"), "w"), indent=1)
    print(json.dumps({k: v for k, v in out.items() if not k.startswith("monthly")}, indent=1))
    print(json.dumps(out["monthly_pr_opened_empty_title_share"]))


if __name__ == "__main__":
    main()
