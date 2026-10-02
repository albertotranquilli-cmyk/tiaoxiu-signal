"""Step 1c: a wider, lower-threshold panel of repositories whose issue/PR titles are mostly in
Japanese, Korean, traditional Chinese or simplified Chinese (era E1 only). Used for the
"same time zone, different calendar" negative controls: Japan (UTC+9), Korea (UTC+9) and
Taiwan/Hong Kong (UTC+8) do not observe mainland-China make-up workdays.

Outputs: data/derived/controls_E1_repos.csv, data/derived/controls_E1_daily.csv.gz
"""
import csv, gzip, os
from ch import rows
from extract import ERAS, WORK, HUMAN, OUT, months, hans_hant

HANS, HANT = hans_hant()
a, b, _ = ERAS["E1"]
TITLE = "action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent')"
SEL = f"""SELECT repo_name FROM github_events
 WHERE created_at >= '{a}' AND created_at < '{b}' AND event_type IN {WORK} AND {HUMAN}
 GROUP BY repo_name
 HAVING uniqExact(actor_login) >= 20 AND count() >= 1500 AND countIf({TITLE}) >= 50
   AND (countIf({TITLE} AND match(title,'[\\\\x{{3040}}-\\\\x{{30FF}}]')) >= 0.3*countIf({TITLE})
     OR countIf({TITLE} AND match(title,'\\\\p{{Hangul}}')) >= 0.3*countIf({TITLE})
     OR countIf({TITLE} AND match(title,'\\\\p{{Han}}') AND NOT match(title,'[\\\\x{{3040}}-\\\\x{{30FF}}]')) >= 0.3*countIf({TITLE}))"""


def main():
    r = rows(f"""
SELECT repo_name, uniqExact(actor_login) AS actors, count() AS events,
  countIf({TITLE}) AS titles,
  countIf({TITLE} AND match(title,'\\\\p{{Han}}') AND NOT match(title,'[\\\\x{{3040}}-\\\\x{{30FF}}]')) AS t_zh,
  countIf({TITLE} AND match(title,'[\\\\x{{3040}}-\\\\x{{30FF}}]')) AS t_ja,
  countIf({TITLE} AND match(title,'\\\\p{{Hangul}}')) AS t_ko,
  countIf({TITLE} AND match(title,'[{HANS}]')) AS t_hans,
  countIf({TITLE} AND match(title,'[{HANT}]')) AS t_hant
FROM github_events
WHERE created_at >= '{a}' AND created_at < '{b}' AND event_type IN {WORK} AND {HUMAN}
  AND repo_name IN ({SEL})
GROUP BY repo_name ORDER BY repo_name""")
    with open(os.path.join(OUT, "controls_E1_repos.csv"), "w", newline="") as f:
        w = csv.DictWriter(f, fieldnames=list(r[0].keys())); w.writeheader(); w.writerows(r)
    print("control repos", len(r))
    out = []
    for s, e in months(a, b):
        out += rows(f"""
SELECT repo_name, toDate(created_at + INTERVAL 8 HOUR) AS d, uniqExact(actor_login) AS actors, count() AS events
FROM github_events
WHERE created_at >= '{s}' AND created_at < '{e}' AND event_type IN {WORK} AND {HUMAN}
  AND repo_name IN ({SEL})
GROUP BY repo_name, d""")
    with gzip.open(os.path.join(OUT, "controls_E1_daily.csv.gz"), "wt", newline="") as f:
        w = csv.DictWriter(f, fieldnames=["repo_name", "d", "actors", "events"]); w.writeheader(); w.writerows(out)
    print("rows", len(out))


if __name__ == "__main__":
    main()
