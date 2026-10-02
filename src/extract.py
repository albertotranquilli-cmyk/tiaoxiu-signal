"""Step 1: pull per-repo daily activity + per-repo title-script counts from the public
ClickHouse playground copy of GH Archive (table default.github_events).

Outputs (small, derived, committed):
  data/derived/repos_{era}.csv          selected repositories and their script shares
  data/derived/daily_{era}.csv.gz       repo x China-calendar-day distinct human actors/events
  data/derived/global_daily.csv         GitHub-wide distinct human actors per China day + hours of coverage
"""
import csv, gzip, os, datetime as dt
from ch import rows, ROOT

WORK = "('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent')"
HUMAN = ("actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), "
         "'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')")
# Eras = contiguous stretches of complete data in the playground table (UTC bounds).
ERAS = {
    "E1": ("2023-01-14 16:00:00", "2024-06-03 16:00:00", 5000),  # China dates 2023-01-15 .. 2024-06-03
    "E2": ("2025-10-15 16:00:00", "2026-07-01 16:00:00", 2500),  # China dates 2025-10-16 .. 2026-07-01
}
MIN_ACTORS = 50
OUT = os.path.join(ROOT, "data", "derived")


def sel(era):
    a, b, n = ERAS[era]
    return f"""SELECT repo_name FROM github_events
 WHERE created_at >= '{a}' AND created_at < '{b}' AND event_type IN {WORK} AND {HUMAN}
 GROUP BY repo_name HAVING uniqExact(actor_login) >= {MIN_ACTORS} AND count() >= {n}"""


def months(a, b):
    s = dt.datetime.fromisoformat(a); e = dt.datetime.fromisoformat(b)
    cur = s
    while cur < e:
        nxt = (cur.replace(day=1) + dt.timedelta(days=32)).replace(day=1, hour=16)  # month edge at 16:00 UTC = China midnight
        nxt = nxt - dt.timedelta(days=1)  # last day of month 16:00 UTC -> China midnight of the 1st
        if nxt <= cur:
            nxt = (nxt + dt.timedelta(days=32)).replace(day=1, hour=16) - dt.timedelta(days=1)
        yield cur, min(nxt, e)
        cur = min(nxt, e)


def main():
    os.makedirs(OUT, exist_ok=True)
    for era, (a, b, n) in ERAS.items():
        # per-repo script shares of issue/PR titles (opened events only)
        r = rows(f"""
SELECT repo_name,
  uniqExact(actor_login) AS actors, count() AS events,
  countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent')) AS titles,
  countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent') AND match(title,'\\\\p{{Han}}') AND NOT match(title,'[\\\\x{{3040}}-\\\\x{{30FF}}]')) AS t_zh,
  countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent') AND match(title,'[\\\\x{{3040}}-\\\\x{{30FF}}]')) AS t_ja,
  countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent') AND match(title,'\\\\p{{Hangul}}')) AS t_ko,
  countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent') AND match(title,'\\\\p{{Cyrillic}}')) AS t_ru
FROM github_events
WHERE created_at >= '{a}' AND created_at < '{b}' AND event_type IN {WORK} AND {HUMAN}
  AND repo_name IN ({sel(era)})
GROUP BY repo_name ORDER BY repo_name""")
        with open(os.path.join(OUT, f"repos_{era}.csv"), "w", newline="") as f:
            w = csv.DictWriter(f, fieldnames=list(r[0].keys())); w.writeheader(); w.writerows(r)
        print(era, "repos:", len(r))
        # repo x China-day panel
        out = []
        for s, e in months(a, b):
            part = rows(f"""
SELECT repo_name, toDate(created_at + INTERVAL 8 HOUR) AS d, uniqExact(actor_login) AS actors, count() AS events
FROM github_events
WHERE created_at >= '{s}' AND created_at < '{e}' AND event_type IN {WORK} AND {HUMAN}
  AND repo_name IN ({sel(era)})
GROUP BY repo_name, d""")
            print(era, s, e, len(part))
            out += part
        with gzip.open(os.path.join(OUT, f"daily_{era}.csv.gz"), "wt", newline="") as f:
            w = csv.DictWriter(f, fieldnames=["repo_name", "d", "actors", "events"]); w.writeheader(); w.writerows(out)
    # GitHub-wide series (all repos), by China day
    g = []
    for era, (a, b, n) in ERAS.items():
        for s, e in months(a, b):
            g += rows(f"""
SELECT toDate(created_at + INTERVAL 8 HOUR) AS d, uniqExact(actor_login) AS actors, count() AS events,
       uniqExact(toStartOfHour(created_at)) AS hours
FROM github_events
WHERE created_at >= '{s}' AND created_at < '{e}' AND event_type IN {WORK} AND {HUMAN}
GROUP BY d ORDER BY d""")
    with open(os.path.join(OUT, "global_daily.csv"), "w", newline="") as f:
        w = csv.DictWriter(f, fieldnames=["d", "actors", "events", "hours"]); w.writeheader(); w.writerows(g)
    print("global days", len(g))




# --- Step 1b: simplified vs traditional Chinese title markers (negative control: Taiwan/HK do not
# follow the mainland make-up-workday calendar). Characters chosen as frequent, unambiguous pairs.
HANS = "这个们发开关会为与体来时对说过还没进现样请问题无单数据条件错误应该"  # simplified forms
HANT = "這個們發開關會為與體來時對說過還沒進現樣請問題無單數據條件錯誤應該"  # traditional forms
def hans_hant():
    s = "".join(c for c, t in zip(HANS, HANT) if c != t)
    t = "".join(t for c, t in zip(HANS, HANT) if c != t)
    return s, t


def main_script_variants():
    s, t = hans_hant()
    for era, (a, b, n) in ERAS.items():
        r = rows(f"""
SELECT repo_name,
  countIf(match(title, '[{s}]')) AS t_hans,
  countIf(match(title, '[{t}]')) AS t_hant
FROM github_events
WHERE created_at >= '{a}' AND created_at < '{b}' AND event_type IN ('IssuesEvent','PullRequestEvent') AND action='opened' AND {HUMAN}
  AND repo_name IN ({sel(era)})
GROUP BY repo_name ORDER BY repo_name""")
        with open(os.path.join(OUT, f"repos_{era}_hanvariant.csv"), "w", newline="") as f:
            w = csv.DictWriter(f, fieldnames=list(r[0].keys())); w.writeheader(); w.writerows(r)
        print(era, "variant rows", len(r))


if __name__ == "__main__":
    main()
    main_script_variants()
