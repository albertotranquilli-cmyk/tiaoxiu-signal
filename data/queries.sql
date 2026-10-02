-- a077bfc8d52edf66 2026-10-02T18:17:45+0200
SELECT repo_name,
  uniqExact(actor_login) AS actors, count() AS events,
  countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent')) AS titles,
  countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent') AND match(title,'\\p{Han}') AND NOT match(title,'[\\x{3040}-\\x{30FF}]')) AS t_zh,
  countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent') AND match(title,'[\\x{3040}-\\x{30FF}]')) AS t_ja,
  countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent') AND match(title,'\\p{Hangul}')) AS t_ko,
  countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent') AND match(title,'\\p{Cyrillic}')) AS t_ru
FROM github_events
WHERE created_at >= '2023-01-14 16:00:00' AND created_at < '2024-06-03 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
  AND repo_name IN (SELECT repo_name FROM github_events
 WHERE created_at >= '2023-01-14 16:00:00' AND created_at < '2024-06-03 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
 GROUP BY repo_name HAVING uniqExact(actor_login) >= 50 AND count() >= 5000)
GROUP BY repo_name ORDER BY repo_name
FORMAT TSVWithNames

-- 924e7b590989819a 2026-10-02T18:17:50+0200
SELECT repo_name, toDate(created_at + INTERVAL 8 HOUR) AS d, uniqExact(actor_login) AS actors, count() AS events
FROM github_events
WHERE created_at >= '2023-01-14 16:00:00' AND created_at < '2023-01-31 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
  AND repo_name IN (SELECT repo_name FROM github_events
 WHERE created_at >= '2023-01-14 16:00:00' AND created_at < '2024-06-03 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
 GROUP BY repo_name HAVING uniqExact(actor_login) >= 50 AND count() >= 5000)
GROUP BY repo_name, d
FORMAT TSVWithNames

-- d3715ff12e342e3c 2026-10-02T18:17:55+0200
SELECT repo_name, toDate(created_at + INTERVAL 8 HOUR) AS d, uniqExact(actor_login) AS actors, count() AS events
FROM github_events
WHERE created_at >= '2023-01-31 16:00:00' AND created_at < '2023-02-28 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
  AND repo_name IN (SELECT repo_name FROM github_events
 WHERE created_at >= '2023-01-14 16:00:00' AND created_at < '2024-06-03 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
 GROUP BY repo_name HAVING uniqExact(actor_login) >= 50 AND count() >= 5000)
GROUP BY repo_name, d
FORMAT TSVWithNames

-- 60d5088d5c08a3c6 2026-10-02T18:17:59+0200
SELECT repo_name, toDate(created_at + INTERVAL 8 HOUR) AS d, uniqExact(actor_login) AS actors, count() AS events
FROM github_events
WHERE created_at >= '2023-02-28 16:00:00' AND created_at < '2023-03-31 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
  AND repo_name IN (SELECT repo_name FROM github_events
 WHERE created_at >= '2023-01-14 16:00:00' AND created_at < '2024-06-03 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
 GROUP BY repo_name HAVING uniqExact(actor_login) >= 50 AND count() >= 5000)
GROUP BY repo_name, d
FORMAT TSVWithNames

-- af3c09dc60827612 2026-10-02T18:18:04+0200
SELECT repo_name, toDate(created_at + INTERVAL 8 HOUR) AS d, uniqExact(actor_login) AS actors, count() AS events
FROM github_events
WHERE created_at >= '2023-03-31 16:00:00' AND created_at < '2023-04-30 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
  AND repo_name IN (SELECT repo_name FROM github_events
 WHERE created_at >= '2023-01-14 16:00:00' AND created_at < '2024-06-03 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
 GROUP BY repo_name HAVING uniqExact(actor_login) >= 50 AND count() >= 5000)
GROUP BY repo_name, d
FORMAT TSVWithNames

-- bee7895d34b0fb0e 2026-10-02T18:18:09+0200
SELECT repo_name, toDate(created_at + INTERVAL 8 HOUR) AS d, uniqExact(actor_login) AS actors, count() AS events
FROM github_events
WHERE created_at >= '2023-04-30 16:00:00' AND created_at < '2023-05-31 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
  AND repo_name IN (SELECT repo_name FROM github_events
 WHERE created_at >= '2023-01-14 16:00:00' AND created_at < '2024-06-03 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
 GROUP BY repo_name HAVING uniqExact(actor_login) >= 50 AND count() >= 5000)
GROUP BY repo_name, d
FORMAT TSVWithNames

-- 5db2cf5f65391ee6 2026-10-02T18:18:14+0200
SELECT repo_name, toDate(created_at + INTERVAL 8 HOUR) AS d, uniqExact(actor_login) AS actors, count() AS events
FROM github_events
WHERE created_at >= '2023-05-31 16:00:00' AND created_at < '2023-06-30 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
  AND repo_name IN (SELECT repo_name FROM github_events
 WHERE created_at >= '2023-01-14 16:00:00' AND created_at < '2024-06-03 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
 GROUP BY repo_name HAVING uniqExact(actor_login) >= 50 AND count() >= 5000)
GROUP BY repo_name, d
FORMAT TSVWithNames

-- 641feac37132d9bb 2026-10-02T18:18:22+0200
SELECT repo_name, toDate(created_at + INTERVAL 8 HOUR) AS d, uniqExact(actor_login) AS actors, count() AS events
FROM github_events
WHERE created_at >= '2023-06-30 16:00:00' AND created_at < '2023-07-31 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
  AND repo_name IN (SELECT repo_name FROM github_events
 WHERE created_at >= '2023-01-14 16:00:00' AND created_at < '2024-06-03 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
 GROUP BY repo_name HAVING uniqExact(actor_login) >= 50 AND count() >= 5000)
GROUP BY repo_name, d
FORMAT TSVWithNames

-- d190b349f72165d5 2026-10-02T18:18:26+0200
SELECT repo_name, toDate(created_at + INTERVAL 8 HOUR) AS d, uniqExact(actor_login) AS actors, count() AS events
FROM github_events
WHERE created_at >= '2023-07-31 16:00:00' AND created_at < '2023-08-31 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
  AND repo_name IN (SELECT repo_name FROM github_events
 WHERE created_at >= '2023-01-14 16:00:00' AND created_at < '2024-06-03 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
 GROUP BY repo_name HAVING uniqExact(actor_login) >= 50 AND count() >= 5000)
GROUP BY repo_name, d
FORMAT TSVWithNames

-- f7216b391e66de1f 2026-10-02T18:18:31+0200
SELECT repo_name, toDate(created_at + INTERVAL 8 HOUR) AS d, uniqExact(actor_login) AS actors, count() AS events
FROM github_events
WHERE created_at >= '2023-08-31 16:00:00' AND created_at < '2023-09-30 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
  AND repo_name IN (SELECT repo_name FROM github_events
 WHERE created_at >= '2023-01-14 16:00:00' AND created_at < '2024-06-03 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
 GROUP BY repo_name HAVING uniqExact(actor_login) >= 50 AND count() >= 5000)
GROUP BY repo_name, d
FORMAT TSVWithNames

-- 83c1b8eedcc1ed88 2026-10-02T18:18:36+0200
SELECT repo_name, toDate(created_at + INTERVAL 8 HOUR) AS d, uniqExact(actor_login) AS actors, count() AS events
FROM github_events
WHERE created_at >= '2023-09-30 16:00:00' AND created_at < '2023-10-31 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
  AND repo_name IN (SELECT repo_name FROM github_events
 WHERE created_at >= '2023-01-14 16:00:00' AND created_at < '2024-06-03 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
 GROUP BY repo_name HAVING uniqExact(actor_login) >= 50 AND count() >= 5000)
GROUP BY repo_name, d
FORMAT TSVWithNames

-- 31db7db60ec513c8 2026-10-02T18:18:40+0200
SELECT repo_name, toDate(created_at + INTERVAL 8 HOUR) AS d, uniqExact(actor_login) AS actors, count() AS events
FROM github_events
WHERE created_at >= '2023-10-31 16:00:00' AND created_at < '2023-11-30 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
  AND repo_name IN (SELECT repo_name FROM github_events
 WHERE created_at >= '2023-01-14 16:00:00' AND created_at < '2024-06-03 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
 GROUP BY repo_name HAVING uniqExact(actor_login) >= 50 AND count() >= 5000)
GROUP BY repo_name, d
FORMAT TSVWithNames

-- c88e32114513e843 2026-10-02T18:18:45+0200
SELECT repo_name, toDate(created_at + INTERVAL 8 HOUR) AS d, uniqExact(actor_login) AS actors, count() AS events
FROM github_events
WHERE created_at >= '2023-11-30 16:00:00' AND created_at < '2023-12-31 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
  AND repo_name IN (SELECT repo_name FROM github_events
 WHERE created_at >= '2023-01-14 16:00:00' AND created_at < '2024-06-03 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
 GROUP BY repo_name HAVING uniqExact(actor_login) >= 50 AND count() >= 5000)
GROUP BY repo_name, d
FORMAT TSVWithNames

-- d871bf11589da702 2026-10-02T18:18:50+0200
SELECT repo_name, toDate(created_at + INTERVAL 8 HOUR) AS d, uniqExact(actor_login) AS actors, count() AS events
FROM github_events
WHERE created_at >= '2023-12-31 16:00:00' AND created_at < '2024-01-31 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
  AND repo_name IN (SELECT repo_name FROM github_events
 WHERE created_at >= '2023-01-14 16:00:00' AND created_at < '2024-06-03 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
 GROUP BY repo_name HAVING uniqExact(actor_login) >= 50 AND count() >= 5000)
GROUP BY repo_name, d
FORMAT TSVWithNames

-- 7f3fea02a6ea5f57 2026-10-02T18:19:06+0200
SELECT repo_name, toDate(created_at + INTERVAL 8 HOUR) AS d, uniqExact(actor_login) AS actors, count() AS events
FROM github_events
WHERE created_at >= '2024-01-31 16:00:00' AND created_at < '2024-02-29 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
  AND repo_name IN (SELECT repo_name FROM github_events
 WHERE created_at >= '2023-01-14 16:00:00' AND created_at < '2024-06-03 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
 GROUP BY repo_name HAVING uniqExact(actor_login) >= 50 AND count() >= 5000)
GROUP BY repo_name, d
FORMAT TSVWithNames

-- bbbd930332aaf9c3 2026-10-02T18:19:14+0200
SELECT repo_name, toDate(created_at + INTERVAL 8 HOUR) AS d, uniqExact(actor_login) AS actors, count() AS events
FROM github_events
WHERE created_at >= '2024-02-29 16:00:00' AND created_at < '2024-03-31 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
  AND repo_name IN (SELECT repo_name FROM github_events
 WHERE created_at >= '2023-01-14 16:00:00' AND created_at < '2024-06-03 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
 GROUP BY repo_name HAVING uniqExact(actor_login) >= 50 AND count() >= 5000)
GROUP BY repo_name, d
FORMAT TSVWithNames

-- c0169dedfb95709a 2026-10-02T18:19:30+0200
SELECT repo_name, toDate(created_at + INTERVAL 8 HOUR) AS d, uniqExact(actor_login) AS actors, count() AS events
FROM github_events
WHERE created_at >= '2024-03-31 16:00:00' AND created_at < '2024-04-30 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
  AND repo_name IN (SELECT repo_name FROM github_events
 WHERE created_at >= '2023-01-14 16:00:00' AND created_at < '2024-06-03 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
 GROUP BY repo_name HAVING uniqExact(actor_login) >= 50 AND count() >= 5000)
GROUP BY repo_name, d
FORMAT TSVWithNames

-- 05c677dc69b68eed 2026-10-02T18:19:52+0200
SELECT repo_name, toDate(created_at + INTERVAL 8 HOUR) AS d, uniqExact(actor_login) AS actors, count() AS events
FROM github_events
WHERE created_at >= '2024-04-30 16:00:00' AND created_at < '2024-05-31 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
  AND repo_name IN (SELECT repo_name FROM github_events
 WHERE created_at >= '2023-01-14 16:00:00' AND created_at < '2024-06-03 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
 GROUP BY repo_name HAVING uniqExact(actor_login) >= 50 AND count() >= 5000)
GROUP BY repo_name, d
FORMAT TSVWithNames

-- 3343aa19de459815 2026-10-02T18:19:59+0200
SELECT repo_name, toDate(created_at + INTERVAL 8 HOUR) AS d, uniqExact(actor_login) AS actors, count() AS events
FROM github_events
WHERE created_at >= '2024-05-31 16:00:00' AND created_at < '2024-06-03 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
  AND repo_name IN (SELECT repo_name FROM github_events
 WHERE created_at >= '2023-01-14 16:00:00' AND created_at < '2024-06-03 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
 GROUP BY repo_name HAVING uniqExact(actor_login) >= 50 AND count() >= 5000)
GROUP BY repo_name, d
FORMAT TSVWithNames

-- 30574013ed9363ff 2026-10-02T18:20:17+0200
SELECT repo_name,
  uniqExact(actor_login) AS actors, count() AS events,
  countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent')) AS titles,
  countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent') AND match(title,'\\p{Han}') AND NOT match(title,'[\\x{3040}-\\x{30FF}]')) AS t_zh,
  countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent') AND match(title,'[\\x{3040}-\\x{30FF}]')) AS t_ja,
  countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent') AND match(title,'\\p{Hangul}')) AS t_ko,
  countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent') AND match(title,'\\p{Cyrillic}')) AS t_ru
FROM github_events
WHERE created_at >= '2025-10-15 16:00:00' AND created_at < '2026-07-01 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
  AND repo_name IN (SELECT repo_name FROM github_events
 WHERE created_at >= '2025-10-15 16:00:00' AND created_at < '2026-07-01 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
 GROUP BY repo_name HAVING uniqExact(actor_login) >= 50 AND count() >= 2500)
GROUP BY repo_name ORDER BY repo_name
FORMAT TSVWithNames

-- d11e1f5644e788a6 2026-10-02T18:20:20+0200
SELECT repo_name, toDate(created_at + INTERVAL 8 HOUR) AS d, uniqExact(actor_login) AS actors, count() AS events
FROM github_events
WHERE created_at >= '2025-10-15 16:00:00' AND created_at < '2025-10-31 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
  AND repo_name IN (SELECT repo_name FROM github_events
 WHERE created_at >= '2025-10-15 16:00:00' AND created_at < '2026-07-01 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
 GROUP BY repo_name HAVING uniqExact(actor_login) >= 50 AND count() >= 2500)
GROUP BY repo_name, d
FORMAT TSVWithNames

-- 8a32ba6e6a6154f6 2026-10-02T18:20:26+0200
SELECT repo_name, toDate(created_at + INTERVAL 8 HOUR) AS d, uniqExact(actor_login) AS actors, count() AS events
FROM github_events
WHERE created_at >= '2025-10-31 16:00:00' AND created_at < '2025-11-30 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
  AND repo_name IN (SELECT repo_name FROM github_events
 WHERE created_at >= '2025-10-15 16:00:00' AND created_at < '2026-07-01 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
 GROUP BY repo_name HAVING uniqExact(actor_login) >= 50 AND count() >= 2500)
GROUP BY repo_name, d
FORMAT TSVWithNames

-- ab05da821526f5f8 2026-10-02T18:20:29+0200
SELECT repo_name, toDate(created_at + INTERVAL 8 HOUR) AS d, uniqExact(actor_login) AS actors, count() AS events
FROM github_events
WHERE created_at >= '2025-11-30 16:00:00' AND created_at < '2025-12-31 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
  AND repo_name IN (SELECT repo_name FROM github_events
 WHERE created_at >= '2025-10-15 16:00:00' AND created_at < '2026-07-01 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
 GROUP BY repo_name HAVING uniqExact(actor_login) >= 50 AND count() >= 2500)
GROUP BY repo_name, d
FORMAT TSVWithNames

-- d3d8ff3ef655e86f 2026-10-02T18:20:32+0200
SELECT repo_name, toDate(created_at + INTERVAL 8 HOUR) AS d, uniqExact(actor_login) AS actors, count() AS events
FROM github_events
WHERE created_at >= '2025-12-31 16:00:00' AND created_at < '2026-01-31 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
  AND repo_name IN (SELECT repo_name FROM github_events
 WHERE created_at >= '2025-10-15 16:00:00' AND created_at < '2026-07-01 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
 GROUP BY repo_name HAVING uniqExact(actor_login) >= 50 AND count() >= 2500)
GROUP BY repo_name, d
FORMAT TSVWithNames

-- 8f407d08624fa40c 2026-10-02T18:20:35+0200
SELECT repo_name, toDate(created_at + INTERVAL 8 HOUR) AS d, uniqExact(actor_login) AS actors, count() AS events
FROM github_events
WHERE created_at >= '2026-01-31 16:00:00' AND created_at < '2026-02-28 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
  AND repo_name IN (SELECT repo_name FROM github_events
 WHERE created_at >= '2025-10-15 16:00:00' AND created_at < '2026-07-01 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
 GROUP BY repo_name HAVING uniqExact(actor_login) >= 50 AND count() >= 2500)
GROUP BY repo_name, d
FORMAT TSVWithNames

-- bf90aeb1bea1a42e 2026-10-02T18:20:41+0200
SELECT repo_name, toDate(created_at + INTERVAL 8 HOUR) AS d, uniqExact(actor_login) AS actors, count() AS events
FROM github_events
WHERE created_at >= '2026-02-28 16:00:00' AND created_at < '2026-03-31 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
  AND repo_name IN (SELECT repo_name FROM github_events
 WHERE created_at >= '2025-10-15 16:00:00' AND created_at < '2026-07-01 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
 GROUP BY repo_name HAVING uniqExact(actor_login) >= 50 AND count() >= 2500)
GROUP BY repo_name, d
FORMAT TSVWithNames

-- 2528964968b67afe 2026-10-02T18:20:44+0200
SELECT repo_name, toDate(created_at + INTERVAL 8 HOUR) AS d, uniqExact(actor_login) AS actors, count() AS events
FROM github_events
WHERE created_at >= '2026-03-31 16:00:00' AND created_at < '2026-04-30 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
  AND repo_name IN (SELECT repo_name FROM github_events
 WHERE created_at >= '2025-10-15 16:00:00' AND created_at < '2026-07-01 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
 GROUP BY repo_name HAVING uniqExact(actor_login) >= 50 AND count() >= 2500)
GROUP BY repo_name, d
FORMAT TSVWithNames

-- ee522a084ba47d72 2026-10-02T18:20:47+0200
SELECT repo_name, toDate(created_at + INTERVAL 8 HOUR) AS d, uniqExact(actor_login) AS actors, count() AS events
FROM github_events
WHERE created_at >= '2026-04-30 16:00:00' AND created_at < '2026-05-31 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
  AND repo_name IN (SELECT repo_name FROM github_events
 WHERE created_at >= '2025-10-15 16:00:00' AND created_at < '2026-07-01 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
 GROUP BY repo_name HAVING uniqExact(actor_login) >= 50 AND count() >= 2500)
GROUP BY repo_name, d
FORMAT TSVWithNames

-- 010ad4f3e0946eb4 2026-10-02T18:20:50+0200
SELECT repo_name, toDate(created_at + INTERVAL 8 HOUR) AS d, uniqExact(actor_login) AS actors, count() AS events
FROM github_events
WHERE created_at >= '2026-05-31 16:00:00' AND created_at < '2026-06-30 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
  AND repo_name IN (SELECT repo_name FROM github_events
 WHERE created_at >= '2025-10-15 16:00:00' AND created_at < '2026-07-01 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
 GROUP BY repo_name HAVING uniqExact(actor_login) >= 50 AND count() >= 2500)
GROUP BY repo_name, d
FORMAT TSVWithNames

-- ff422a4f84d7b2ac 2026-10-02T18:20:53+0200
SELECT repo_name, toDate(created_at + INTERVAL 8 HOUR) AS d, uniqExact(actor_login) AS actors, count() AS events
FROM github_events
WHERE created_at >= '2026-06-30 16:00:00' AND created_at < '2026-07-01 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
  AND repo_name IN (SELECT repo_name FROM github_events
 WHERE created_at >= '2025-10-15 16:00:00' AND created_at < '2026-07-01 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
 GROUP BY repo_name HAVING uniqExact(actor_login) >= 50 AND count() >= 2500)
GROUP BY repo_name, d
FORMAT TSVWithNames

-- 28e98622a1720d71 2026-10-02T18:20:56+0200
SELECT toDate(created_at + INTERVAL 8 HOUR) AS d, uniqExact(actor_login) AS actors, count() AS events,
       uniqExact(toStartOfHour(created_at)) AS hours
FROM github_events
WHERE created_at >= '2023-01-14 16:00:00' AND created_at < '2023-01-31 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
GROUP BY d ORDER BY d
FORMAT TSVWithNames

-- bcdd9d5b49fcc85b 2026-10-02T18:20:57+0200
SELECT toDate(created_at + INTERVAL 8 HOUR) AS d, uniqExact(actor_login) AS actors, count() AS events,
       uniqExact(toStartOfHour(created_at)) AS hours
FROM github_events
WHERE created_at >= '2023-01-31 16:00:00' AND created_at < '2023-02-28 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
GROUP BY d ORDER BY d
FORMAT TSVWithNames

-- 98fe63f4f28bab13 2026-10-02T18:20:57+0200
SELECT toDate(created_at + INTERVAL 8 HOUR) AS d, uniqExact(actor_login) AS actors, count() AS events,
       uniqExact(toStartOfHour(created_at)) AS hours
FROM github_events
WHERE created_at >= '2023-02-28 16:00:00' AND created_at < '2023-03-31 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
GROUP BY d ORDER BY d
FORMAT TSVWithNames

-- 7573fba323a6169c 2026-10-02T18:20:58+0200
SELECT toDate(created_at + INTERVAL 8 HOUR) AS d, uniqExact(actor_login) AS actors, count() AS events,
       uniqExact(toStartOfHour(created_at)) AS hours
FROM github_events
WHERE created_at >= '2023-03-31 16:00:00' AND created_at < '2023-04-30 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
GROUP BY d ORDER BY d
FORMAT TSVWithNames

-- 80533a0e34e42f90 2026-10-02T18:20:58+0200
SELECT toDate(created_at + INTERVAL 8 HOUR) AS d, uniqExact(actor_login) AS actors, count() AS events,
       uniqExact(toStartOfHour(created_at)) AS hours
FROM github_events
WHERE created_at >= '2023-04-30 16:00:00' AND created_at < '2023-05-31 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
GROUP BY d ORDER BY d
FORMAT TSVWithNames

-- bdfe444268f8a8ce 2026-10-02T18:20:59+0200
SELECT toDate(created_at + INTERVAL 8 HOUR) AS d, uniqExact(actor_login) AS actors, count() AS events,
       uniqExact(toStartOfHour(created_at)) AS hours
FROM github_events
WHERE created_at >= '2023-05-31 16:00:00' AND created_at < '2023-06-30 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
GROUP BY d ORDER BY d
FORMAT TSVWithNames

-- c27ed334b8c78981 2026-10-02T18:21:00+0200
SELECT toDate(created_at + INTERVAL 8 HOUR) AS d, uniqExact(actor_login) AS actors, count() AS events,
       uniqExact(toStartOfHour(created_at)) AS hours
FROM github_events
WHERE created_at >= '2023-06-30 16:00:00' AND created_at < '2023-07-31 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
GROUP BY d ORDER BY d
FORMAT TSVWithNames

-- 201706fb44db5959 2026-10-02T18:21:00+0200
SELECT toDate(created_at + INTERVAL 8 HOUR) AS d, uniqExact(actor_login) AS actors, count() AS events,
       uniqExact(toStartOfHour(created_at)) AS hours
FROM github_events
WHERE created_at >= '2023-07-31 16:00:00' AND created_at < '2023-08-31 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
GROUP BY d ORDER BY d
FORMAT TSVWithNames

-- 7f3467ce094b90be 2026-10-02T18:21:01+0200
SELECT toDate(created_at + INTERVAL 8 HOUR) AS d, uniqExact(actor_login) AS actors, count() AS events,
       uniqExact(toStartOfHour(created_at)) AS hours
FROM github_events
WHERE created_at >= '2023-08-31 16:00:00' AND created_at < '2023-09-30 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
GROUP BY d ORDER BY d
FORMAT TSVWithNames

-- 6d297725a24239fb 2026-10-02T18:21:01+0200
SELECT toDate(created_at + INTERVAL 8 HOUR) AS d, uniqExact(actor_login) AS actors, count() AS events,
       uniqExact(toStartOfHour(created_at)) AS hours
FROM github_events
WHERE created_at >= '2023-09-30 16:00:00' AND created_at < '2023-10-31 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
GROUP BY d ORDER BY d
FORMAT TSVWithNames

-- ae02661733345e74 2026-10-02T18:21:02+0200
SELECT toDate(created_at + INTERVAL 8 HOUR) AS d, uniqExact(actor_login) AS actors, count() AS events,
       uniqExact(toStartOfHour(created_at)) AS hours
FROM github_events
WHERE created_at >= '2023-10-31 16:00:00' AND created_at < '2023-11-30 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
GROUP BY d ORDER BY d
FORMAT TSVWithNames

-- df845496102a67cd 2026-10-02T18:21:03+0200
SELECT toDate(created_at + INTERVAL 8 HOUR) AS d, uniqExact(actor_login) AS actors, count() AS events,
       uniqExact(toStartOfHour(created_at)) AS hours
FROM github_events
WHERE created_at >= '2023-11-30 16:00:00' AND created_at < '2023-12-31 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
GROUP BY d ORDER BY d
FORMAT TSVWithNames

-- de879b8484e6afa6 2026-10-02T18:21:03+0200
SELECT toDate(created_at + INTERVAL 8 HOUR) AS d, uniqExact(actor_login) AS actors, count() AS events,
       uniqExact(toStartOfHour(created_at)) AS hours
FROM github_events
WHERE created_at >= '2023-12-31 16:00:00' AND created_at < '2024-01-31 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
GROUP BY d ORDER BY d
FORMAT TSVWithNames

-- f2820356b0875047 2026-10-02T18:21:04+0200
SELECT toDate(created_at + INTERVAL 8 HOUR) AS d, uniqExact(actor_login) AS actors, count() AS events,
       uniqExact(toStartOfHour(created_at)) AS hours
FROM github_events
WHERE created_at >= '2024-01-31 16:00:00' AND created_at < '2024-02-29 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
GROUP BY d ORDER BY d
FORMAT TSVWithNames

-- 0a4d96782ee4db73 2026-10-02T18:21:05+0200
SELECT toDate(created_at + INTERVAL 8 HOUR) AS d, uniqExact(actor_login) AS actors, count() AS events,
       uniqExact(toStartOfHour(created_at)) AS hours
FROM github_events
WHERE created_at >= '2024-02-29 16:00:00' AND created_at < '2024-03-31 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
GROUP BY d ORDER BY d
FORMAT TSVWithNames

-- bf5583f09a3c038e 2026-10-02T18:21:05+0200
SELECT toDate(created_at + INTERVAL 8 HOUR) AS d, uniqExact(actor_login) AS actors, count() AS events,
       uniqExact(toStartOfHour(created_at)) AS hours
FROM github_events
WHERE created_at >= '2024-03-31 16:00:00' AND created_at < '2024-04-30 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
GROUP BY d ORDER BY d
FORMAT TSVWithNames

-- f0bfd16da59ba1b8 2026-10-02T18:21:06+0200
SELECT toDate(created_at + INTERVAL 8 HOUR) AS d, uniqExact(actor_login) AS actors, count() AS events,
       uniqExact(toStartOfHour(created_at)) AS hours
FROM github_events
WHERE created_at >= '2024-04-30 16:00:00' AND created_at < '2024-05-31 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
GROUP BY d ORDER BY d
FORMAT TSVWithNames

-- f349e28f8a5fd016 2026-10-02T18:21:07+0200
SELECT toDate(created_at + INTERVAL 8 HOUR) AS d, uniqExact(actor_login) AS actors, count() AS events,
       uniqExact(toStartOfHour(created_at)) AS hours
FROM github_events
WHERE created_at >= '2024-05-31 16:00:00' AND created_at < '2024-06-03 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
GROUP BY d ORDER BY d
FORMAT TSVWithNames

-- 29016aaf9c0705ea 2026-10-02T18:21:07+0200
SELECT toDate(created_at + INTERVAL 8 HOUR) AS d, uniqExact(actor_login) AS actors, count() AS events,
       uniqExact(toStartOfHour(created_at)) AS hours
FROM github_events
WHERE created_at >= '2025-10-15 16:00:00' AND created_at < '2025-10-31 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
GROUP BY d ORDER BY d
FORMAT TSVWithNames

-- bb5d741cf6086184 2026-10-02T18:21:08+0200
SELECT toDate(created_at + INTERVAL 8 HOUR) AS d, uniqExact(actor_login) AS actors, count() AS events,
       uniqExact(toStartOfHour(created_at)) AS hours
FROM github_events
WHERE created_at >= '2025-10-31 16:00:00' AND created_at < '2025-11-30 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
GROUP BY d ORDER BY d
FORMAT TSVWithNames

-- 4922f1e62de8cde9 2026-10-02T18:21:08+0200
SELECT toDate(created_at + INTERVAL 8 HOUR) AS d, uniqExact(actor_login) AS actors, count() AS events,
       uniqExact(toStartOfHour(created_at)) AS hours
FROM github_events
WHERE created_at >= '2025-11-30 16:00:00' AND created_at < '2025-12-31 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
GROUP BY d ORDER BY d
FORMAT TSVWithNames

-- 77f46f6679f82935 2026-10-02T18:21:09+0200
SELECT toDate(created_at + INTERVAL 8 HOUR) AS d, uniqExact(actor_login) AS actors, count() AS events,
       uniqExact(toStartOfHour(created_at)) AS hours
FROM github_events
WHERE created_at >= '2025-12-31 16:00:00' AND created_at < '2026-01-31 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
GROUP BY d ORDER BY d
FORMAT TSVWithNames

-- 9d2d27923fb1295a 2026-10-02T18:21:10+0200
SELECT toDate(created_at + INTERVAL 8 HOUR) AS d, uniqExact(actor_login) AS actors, count() AS events,
       uniqExact(toStartOfHour(created_at)) AS hours
FROM github_events
WHERE created_at >= '2026-01-31 16:00:00' AND created_at < '2026-02-28 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
GROUP BY d ORDER BY d
FORMAT TSVWithNames

-- e5c547bbdec40bb0 2026-10-02T18:21:10+0200
SELECT toDate(created_at + INTERVAL 8 HOUR) AS d, uniqExact(actor_login) AS actors, count() AS events,
       uniqExact(toStartOfHour(created_at)) AS hours
FROM github_events
WHERE created_at >= '2026-02-28 16:00:00' AND created_at < '2026-03-31 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
GROUP BY d ORDER BY d
FORMAT TSVWithNames

-- 1c34d768b332eb35 2026-10-02T18:21:11+0200
SELECT toDate(created_at + INTERVAL 8 HOUR) AS d, uniqExact(actor_login) AS actors, count() AS events,
       uniqExact(toStartOfHour(created_at)) AS hours
FROM github_events
WHERE created_at >= '2026-03-31 16:00:00' AND created_at < '2026-04-30 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
GROUP BY d ORDER BY d
FORMAT TSVWithNames

-- 52cfb6f438ab298a 2026-10-02T18:21:11+0200
SELECT toDate(created_at + INTERVAL 8 HOUR) AS d, uniqExact(actor_login) AS actors, count() AS events,
       uniqExact(toStartOfHour(created_at)) AS hours
FROM github_events
WHERE created_at >= '2026-04-30 16:00:00' AND created_at < '2026-05-31 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
GROUP BY d ORDER BY d
FORMAT TSVWithNames

-- e089d1552a3e6c38 2026-10-02T18:21:12+0200
SELECT toDate(created_at + INTERVAL 8 HOUR) AS d, uniqExact(actor_login) AS actors, count() AS events,
       uniqExact(toStartOfHour(created_at)) AS hours
FROM github_events
WHERE created_at >= '2026-05-31 16:00:00' AND created_at < '2026-06-30 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
GROUP BY d ORDER BY d
FORMAT TSVWithNames

-- 234c16e8b9701244 2026-10-02T18:21:12+0200
SELECT toDate(created_at + INTERVAL 8 HOUR) AS d, uniqExact(actor_login) AS actors, count() AS events,
       uniqExact(toStartOfHour(created_at)) AS hours
FROM github_events
WHERE created_at >= '2026-06-30 16:00:00' AND created_at < '2026-07-01 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
GROUP BY d ORDER BY d
FORMAT TSVWithNames

-- 44e534ef939baebf 2026-10-02T18:21:17+0200
SELECT repo_name,
  countIf(match(title, '[这个们发开关会为与体来时对说过还没进现样请问题无单数据条错误应该]')) AS t_hans,
  countIf(match(title, '[這個們發開關會為與體來時對說過還沒進現樣請問題無單數據條錯誤應該]')) AS t_hant
FROM github_events
WHERE created_at >= '2023-01-14 16:00:00' AND created_at < '2024-06-03 16:00:00' AND event_type IN ('IssuesEvent','PullRequestEvent') AND action='opened' AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
  AND repo_name IN (SELECT repo_name FROM github_events
 WHERE created_at >= '2023-01-14 16:00:00' AND created_at < '2024-06-03 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
 GROUP BY repo_name HAVING uniqExact(actor_login) >= 50 AND count() >= 5000)
GROUP BY repo_name ORDER BY repo_name
FORMAT TSVWithNames

-- 7ddca0d3308505cc 2026-10-02T18:21:20+0200
SELECT repo_name,
  countIf(match(title, '[这个们发开关会为与体来时对说过还没进现样请问题无单数据条错误应该]')) AS t_hans,
  countIf(match(title, '[這個們發開關會為與體來時對說過還沒進現樣請問題無單數據條錯誤應該]')) AS t_hant
FROM github_events
WHERE created_at >= '2025-10-15 16:00:00' AND created_at < '2026-07-01 16:00:00' AND event_type IN ('IssuesEvent','PullRequestEvent') AND action='opened' AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
  AND repo_name IN (SELECT repo_name FROM github_events
 WHERE created_at >= '2025-10-15 16:00:00' AND created_at < '2026-07-01 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
 GROUP BY repo_name HAVING uniqExact(actor_login) >= 50 AND count() >= 2500)
GROUP BY repo_name ORDER BY repo_name
FORMAT TSVWithNames

-- dd9657ba3b839b70 2026-10-02T18:21:30+0200
SELECT repo_name, uniqExact(actor_login) AS actors, count() AS events,
  countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent')) AS titles,
  countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent') AND match(title,'\\p{Han}') AND NOT match(title,'[\\x{3040}-\\x{30FF}]')) AS t_zh,
  countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent') AND match(title,'[\\x{3040}-\\x{30FF}]')) AS t_ja,
  countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent') AND match(title,'\\p{Hangul}')) AS t_ko,
  countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent') AND match(title,'[这个们发开关会为与体来时对说过还没进现样请问题无单数据条错误应该]')) AS t_hans,
  countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent') AND match(title,'[這個們發開關會為與體來時對說過還沒進現樣請問題無單數據條錯誤應該]')) AS t_hant
FROM github_events
WHERE created_at >= '2023-01-14 16:00:00' AND created_at < '2024-06-03 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
  AND repo_name IN (SELECT repo_name FROM github_events
 WHERE created_at >= '2023-01-14 16:00:00' AND created_at < '2024-06-03 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
 GROUP BY repo_name
 HAVING uniqExact(actor_login) >= 20 AND count() >= 1500 AND countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent')) >= 50
   AND (countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent') AND match(title,'[\\x{3040}-\\x{30FF}]')) >= 0.3*countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent'))
     OR countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent') AND match(title,'\\p{Hangul}')) >= 0.3*countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent'))
     OR countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent') AND match(title,'\\p{Han}') AND NOT match(title,'[\\x{3040}-\\x{30FF}]')) >= 0.3*countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent'))))
GROUP BY repo_name ORDER BY repo_name
FORMAT TSVWithNames

-- e3e81a501acfafd1 2026-10-02T18:21:39+0200
SELECT repo_name, toDate(created_at + INTERVAL 8 HOUR) AS d, uniqExact(actor_login) AS actors, count() AS events
FROM github_events
WHERE created_at >= '2023-01-14 16:00:00' AND created_at < '2023-01-31 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
  AND repo_name IN (SELECT repo_name FROM github_events
 WHERE created_at >= '2023-01-14 16:00:00' AND created_at < '2024-06-03 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
 GROUP BY repo_name
 HAVING uniqExact(actor_login) >= 20 AND count() >= 1500 AND countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent')) >= 50
   AND (countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent') AND match(title,'[\\x{3040}-\\x{30FF}]')) >= 0.3*countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent'))
     OR countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent') AND match(title,'\\p{Hangul}')) >= 0.3*countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent'))
     OR countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent') AND match(title,'\\p{Han}') AND NOT match(title,'[\\x{3040}-\\x{30FF}]')) >= 0.3*countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent'))))
GROUP BY repo_name, d
FORMAT TSVWithNames

-- 2df1b1551e0d4e61 2026-10-02T18:21:47+0200
SELECT repo_name, toDate(created_at + INTERVAL 8 HOUR) AS d, uniqExact(actor_login) AS actors, count() AS events
FROM github_events
WHERE created_at >= '2023-01-31 16:00:00' AND created_at < '2023-02-28 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
  AND repo_name IN (SELECT repo_name FROM github_events
 WHERE created_at >= '2023-01-14 16:00:00' AND created_at < '2024-06-03 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
 GROUP BY repo_name
 HAVING uniqExact(actor_login) >= 20 AND count() >= 1500 AND countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent')) >= 50
   AND (countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent') AND match(title,'[\\x{3040}-\\x{30FF}]')) >= 0.3*countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent'))
     OR countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent') AND match(title,'\\p{Hangul}')) >= 0.3*countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent'))
     OR countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent') AND match(title,'\\p{Han}') AND NOT match(title,'[\\x{3040}-\\x{30FF}]')) >= 0.3*countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent'))))
GROUP BY repo_name, d
FORMAT TSVWithNames

-- 6d5f4dafb87ade7a 2026-10-02T18:21:56+0200
SELECT repo_name, toDate(created_at + INTERVAL 8 HOUR) AS d, uniqExact(actor_login) AS actors, count() AS events
FROM github_events
WHERE created_at >= '2023-02-28 16:00:00' AND created_at < '2023-03-31 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
  AND repo_name IN (SELECT repo_name FROM github_events
 WHERE created_at >= '2023-01-14 16:00:00' AND created_at < '2024-06-03 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
 GROUP BY repo_name
 HAVING uniqExact(actor_login) >= 20 AND count() >= 1500 AND countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent')) >= 50
   AND (countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent') AND match(title,'[\\x{3040}-\\x{30FF}]')) >= 0.3*countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent'))
     OR countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent') AND match(title,'\\p{Hangul}')) >= 0.3*countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent'))
     OR countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent') AND match(title,'\\p{Han}') AND NOT match(title,'[\\x{3040}-\\x{30FF}]')) >= 0.3*countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent'))))
GROUP BY repo_name, d
FORMAT TSVWithNames

-- e18df91270598a5e 2026-10-02T18:22:05+0200
SELECT repo_name, toDate(created_at + INTERVAL 8 HOUR) AS d, uniqExact(actor_login) AS actors, count() AS events
FROM github_events
WHERE created_at >= '2023-03-31 16:00:00' AND created_at < '2023-04-30 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
  AND repo_name IN (SELECT repo_name FROM github_events
 WHERE created_at >= '2023-01-14 16:00:00' AND created_at < '2024-06-03 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
 GROUP BY repo_name
 HAVING uniqExact(actor_login) >= 20 AND count() >= 1500 AND countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent')) >= 50
   AND (countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent') AND match(title,'[\\x{3040}-\\x{30FF}]')) >= 0.3*countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent'))
     OR countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent') AND match(title,'\\p{Hangul}')) >= 0.3*countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent'))
     OR countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent') AND match(title,'\\p{Han}') AND NOT match(title,'[\\x{3040}-\\x{30FF}]')) >= 0.3*countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent'))))
GROUP BY repo_name, d
FORMAT TSVWithNames

-- 00b1e64041b91810 2026-10-02T18:22:14+0200
SELECT repo_name, toDate(created_at + INTERVAL 8 HOUR) AS d, uniqExact(actor_login) AS actors, count() AS events
FROM github_events
WHERE created_at >= '2023-04-30 16:00:00' AND created_at < '2023-05-31 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
  AND repo_name IN (SELECT repo_name FROM github_events
 WHERE created_at >= '2023-01-14 16:00:00' AND created_at < '2024-06-03 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
 GROUP BY repo_name
 HAVING uniqExact(actor_login) >= 20 AND count() >= 1500 AND countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent')) >= 50
   AND (countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent') AND match(title,'[\\x{3040}-\\x{30FF}]')) >= 0.3*countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent'))
     OR countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent') AND match(title,'\\p{Hangul}')) >= 0.3*countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent'))
     OR countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent') AND match(title,'\\p{Han}') AND NOT match(title,'[\\x{3040}-\\x{30FF}]')) >= 0.3*countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent'))))
GROUP BY repo_name, d
FORMAT TSVWithNames

-- 0f9d3669e0a5337e 2026-10-02T18:22:23+0200
SELECT repo_name, toDate(created_at + INTERVAL 8 HOUR) AS d, uniqExact(actor_login) AS actors, count() AS events
FROM github_events
WHERE created_at >= '2023-05-31 16:00:00' AND created_at < '2023-06-30 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
  AND repo_name IN (SELECT repo_name FROM github_events
 WHERE created_at >= '2023-01-14 16:00:00' AND created_at < '2024-06-03 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
 GROUP BY repo_name
 HAVING uniqExact(actor_login) >= 20 AND count() >= 1500 AND countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent')) >= 50
   AND (countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent') AND match(title,'[\\x{3040}-\\x{30FF}]')) >= 0.3*countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent'))
     OR countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent') AND match(title,'\\p{Hangul}')) >= 0.3*countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent'))
     OR countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent') AND match(title,'\\p{Han}') AND NOT match(title,'[\\x{3040}-\\x{30FF}]')) >= 0.3*countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent'))))
GROUP BY repo_name, d
FORMAT TSVWithNames

-- 71257f01ee9327c4 2026-10-02T18:22:31+0200
SELECT repo_name, toDate(created_at + INTERVAL 8 HOUR) AS d, uniqExact(actor_login) AS actors, count() AS events
FROM github_events
WHERE created_at >= '2023-06-30 16:00:00' AND created_at < '2023-07-31 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
  AND repo_name IN (SELECT repo_name FROM github_events
 WHERE created_at >= '2023-01-14 16:00:00' AND created_at < '2024-06-03 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
 GROUP BY repo_name
 HAVING uniqExact(actor_login) >= 20 AND count() >= 1500 AND countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent')) >= 50
   AND (countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent') AND match(title,'[\\x{3040}-\\x{30FF}]')) >= 0.3*countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent'))
     OR countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent') AND match(title,'\\p{Hangul}')) >= 0.3*countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent'))
     OR countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent') AND match(title,'\\p{Han}') AND NOT match(title,'[\\x{3040}-\\x{30FF}]')) >= 0.3*countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent'))))
GROUP BY repo_name, d
FORMAT TSVWithNames

-- d4e532f1766cc29a 2026-10-02T18:22:40+0200
SELECT repo_name, toDate(created_at + INTERVAL 8 HOUR) AS d, uniqExact(actor_login) AS actors, count() AS events
FROM github_events
WHERE created_at >= '2023-07-31 16:00:00' AND created_at < '2023-08-31 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
  AND repo_name IN (SELECT repo_name FROM github_events
 WHERE created_at >= '2023-01-14 16:00:00' AND created_at < '2024-06-03 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
 GROUP BY repo_name
 HAVING uniqExact(actor_login) >= 20 AND count() >= 1500 AND countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent')) >= 50
   AND (countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent') AND match(title,'[\\x{3040}-\\x{30FF}]')) >= 0.3*countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent'))
     OR countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent') AND match(title,'\\p{Hangul}')) >= 0.3*countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent'))
     OR countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent') AND match(title,'\\p{Han}') AND NOT match(title,'[\\x{3040}-\\x{30FF}]')) >= 0.3*countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent'))))
GROUP BY repo_name, d
FORMAT TSVWithNames

-- 9ada1b08694c3add 2026-10-02T18:22:49+0200
SELECT repo_name, toDate(created_at + INTERVAL 8 HOUR) AS d, uniqExact(actor_login) AS actors, count() AS events
FROM github_events
WHERE created_at >= '2023-08-31 16:00:00' AND created_at < '2023-09-30 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
  AND repo_name IN (SELECT repo_name FROM github_events
 WHERE created_at >= '2023-01-14 16:00:00' AND created_at < '2024-06-03 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
 GROUP BY repo_name
 HAVING uniqExact(actor_login) >= 20 AND count() >= 1500 AND countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent')) >= 50
   AND (countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent') AND match(title,'[\\x{3040}-\\x{30FF}]')) >= 0.3*countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent'))
     OR countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent') AND match(title,'\\p{Hangul}')) >= 0.3*countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent'))
     OR countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent') AND match(title,'\\p{Han}') AND NOT match(title,'[\\x{3040}-\\x{30FF}]')) >= 0.3*countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent'))))
GROUP BY repo_name, d
FORMAT TSVWithNames

-- 3c2bf8f3f310a20b 2026-10-02T18:22:57+0200
SELECT repo_name, toDate(created_at + INTERVAL 8 HOUR) AS d, uniqExact(actor_login) AS actors, count() AS events
FROM github_events
WHERE created_at >= '2023-09-30 16:00:00' AND created_at < '2023-10-31 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
  AND repo_name IN (SELECT repo_name FROM github_events
 WHERE created_at >= '2023-01-14 16:00:00' AND created_at < '2024-06-03 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
 GROUP BY repo_name
 HAVING uniqExact(actor_login) >= 20 AND count() >= 1500 AND countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent')) >= 50
   AND (countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent') AND match(title,'[\\x{3040}-\\x{30FF}]')) >= 0.3*countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent'))
     OR countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent') AND match(title,'\\p{Hangul}')) >= 0.3*countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent'))
     OR countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent') AND match(title,'\\p{Han}') AND NOT match(title,'[\\x{3040}-\\x{30FF}]')) >= 0.3*countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent'))))
GROUP BY repo_name, d
FORMAT TSVWithNames

-- 61d90e9ca73b8933 2026-10-02T18:23:12+0200
SELECT repo_name, toDate(created_at + INTERVAL 8 HOUR) AS d, uniqExact(actor_login) AS actors, count() AS events
FROM github_events
WHERE created_at >= '2023-10-31 16:00:00' AND created_at < '2023-11-30 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
  AND repo_name IN (SELECT repo_name FROM github_events
 WHERE created_at >= '2023-01-14 16:00:00' AND created_at < '2024-06-03 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
 GROUP BY repo_name
 HAVING uniqExact(actor_login) >= 20 AND count() >= 1500 AND countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent')) >= 50
   AND (countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent') AND match(title,'[\\x{3040}-\\x{30FF}]')) >= 0.3*countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent'))
     OR countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent') AND match(title,'\\p{Hangul}')) >= 0.3*countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent'))
     OR countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent') AND match(title,'\\p{Han}') AND NOT match(title,'[\\x{3040}-\\x{30FF}]')) >= 0.3*countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent'))))
GROUP BY repo_name, d
FORMAT TSVWithNames

-- 50b9b5003e30af96 2026-10-02T18:23:21+0200
SELECT repo_name, toDate(created_at + INTERVAL 8 HOUR) AS d, uniqExact(actor_login) AS actors, count() AS events
FROM github_events
WHERE created_at >= '2023-11-30 16:00:00' AND created_at < '2023-12-31 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
  AND repo_name IN (SELECT repo_name FROM github_events
 WHERE created_at >= '2023-01-14 16:00:00' AND created_at < '2024-06-03 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
 GROUP BY repo_name
 HAVING uniqExact(actor_login) >= 20 AND count() >= 1500 AND countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent')) >= 50
   AND (countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent') AND match(title,'[\\x{3040}-\\x{30FF}]')) >= 0.3*countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent'))
     OR countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent') AND match(title,'\\p{Hangul}')) >= 0.3*countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent'))
     OR countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent') AND match(title,'\\p{Han}') AND NOT match(title,'[\\x{3040}-\\x{30FF}]')) >= 0.3*countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent'))))
GROUP BY repo_name, d
FORMAT TSVWithNames

-- b8bf96358fee1c7b 2026-10-02T18:23:29+0200
SELECT repo_name, toDate(created_at + INTERVAL 8 HOUR) AS d, uniqExact(actor_login) AS actors, count() AS events
FROM github_events
WHERE created_at >= '2023-12-31 16:00:00' AND created_at < '2024-01-31 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
  AND repo_name IN (SELECT repo_name FROM github_events
 WHERE created_at >= '2023-01-14 16:00:00' AND created_at < '2024-06-03 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
 GROUP BY repo_name
 HAVING uniqExact(actor_login) >= 20 AND count() >= 1500 AND countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent')) >= 50
   AND (countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent') AND match(title,'[\\x{3040}-\\x{30FF}]')) >= 0.3*countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent'))
     OR countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent') AND match(title,'\\p{Hangul}')) >= 0.3*countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent'))
     OR countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent') AND match(title,'\\p{Han}') AND NOT match(title,'[\\x{3040}-\\x{30FF}]')) >= 0.3*countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent'))))
GROUP BY repo_name, d
FORMAT TSVWithNames

-- 4939f8f8b0017c12 2026-10-02T18:23:38+0200
SELECT repo_name, toDate(created_at + INTERVAL 8 HOUR) AS d, uniqExact(actor_login) AS actors, count() AS events
FROM github_events
WHERE created_at >= '2024-01-31 16:00:00' AND created_at < '2024-02-29 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
  AND repo_name IN (SELECT repo_name FROM github_events
 WHERE created_at >= '2023-01-14 16:00:00' AND created_at < '2024-06-03 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
 GROUP BY repo_name
 HAVING uniqExact(actor_login) >= 20 AND count() >= 1500 AND countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent')) >= 50
   AND (countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent') AND match(title,'[\\x{3040}-\\x{30FF}]')) >= 0.3*countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent'))
     OR countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent') AND match(title,'\\p{Hangul}')) >= 0.3*countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent'))
     OR countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent') AND match(title,'\\p{Han}') AND NOT match(title,'[\\x{3040}-\\x{30FF}]')) >= 0.3*countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent'))))
GROUP BY repo_name, d
FORMAT TSVWithNames

-- 58820f026c7adff1 2026-10-02T18:23:46+0200
SELECT repo_name, toDate(created_at + INTERVAL 8 HOUR) AS d, uniqExact(actor_login) AS actors, count() AS events
FROM github_events
WHERE created_at >= '2024-02-29 16:00:00' AND created_at < '2024-03-31 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
  AND repo_name IN (SELECT repo_name FROM github_events
 WHERE created_at >= '2023-01-14 16:00:00' AND created_at < '2024-06-03 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
 GROUP BY repo_name
 HAVING uniqExact(actor_login) >= 20 AND count() >= 1500 AND countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent')) >= 50
   AND (countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent') AND match(title,'[\\x{3040}-\\x{30FF}]')) >= 0.3*countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent'))
     OR countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent') AND match(title,'\\p{Hangul}')) >= 0.3*countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent'))
     OR countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent') AND match(title,'\\p{Han}') AND NOT match(title,'[\\x{3040}-\\x{30FF}]')) >= 0.3*countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent'))))
GROUP BY repo_name, d
FORMAT TSVWithNames

-- ad18b1757fa7c3b2 2026-10-02T18:23:55+0200
SELECT repo_name, toDate(created_at + INTERVAL 8 HOUR) AS d, uniqExact(actor_login) AS actors, count() AS events
FROM github_events
WHERE created_at >= '2024-03-31 16:00:00' AND created_at < '2024-04-30 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
  AND repo_name IN (SELECT repo_name FROM github_events
 WHERE created_at >= '2023-01-14 16:00:00' AND created_at < '2024-06-03 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
 GROUP BY repo_name
 HAVING uniqExact(actor_login) >= 20 AND count() >= 1500 AND countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent')) >= 50
   AND (countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent') AND match(title,'[\\x{3040}-\\x{30FF}]')) >= 0.3*countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent'))
     OR countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent') AND match(title,'\\p{Hangul}')) >= 0.3*countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent'))
     OR countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent') AND match(title,'\\p{Han}') AND NOT match(title,'[\\x{3040}-\\x{30FF}]')) >= 0.3*countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent'))))
GROUP BY repo_name, d
FORMAT TSVWithNames

-- 4ffb5509a33448cf 2026-10-02T18:24:05+0200
SELECT repo_name, toDate(created_at + INTERVAL 8 HOUR) AS d, uniqExact(actor_login) AS actors, count() AS events
FROM github_events
WHERE created_at >= '2024-04-30 16:00:00' AND created_at < '2024-05-31 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
  AND repo_name IN (SELECT repo_name FROM github_events
 WHERE created_at >= '2023-01-14 16:00:00' AND created_at < '2024-06-03 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
 GROUP BY repo_name
 HAVING uniqExact(actor_login) >= 20 AND count() >= 1500 AND countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent')) >= 50
   AND (countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent') AND match(title,'[\\x{3040}-\\x{30FF}]')) >= 0.3*countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent'))
     OR countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent') AND match(title,'\\p{Hangul}')) >= 0.3*countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent'))
     OR countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent') AND match(title,'\\p{Han}') AND NOT match(title,'[\\x{3040}-\\x{30FF}]')) >= 0.3*countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent'))))
GROUP BY repo_name, d
FORMAT TSVWithNames

-- 2adb13e32e4bdd3d 2026-10-02T18:24:14+0200
SELECT repo_name, toDate(created_at + INTERVAL 8 HOUR) AS d, uniqExact(actor_login) AS actors, count() AS events
FROM github_events
WHERE created_at >= '2024-05-31 16:00:00' AND created_at < '2024-06-03 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
  AND repo_name IN (SELECT repo_name FROM github_events
 WHERE created_at >= '2023-01-14 16:00:00' AND created_at < '2024-06-03 16:00:00' AND event_type IN ('PushEvent','PullRequestEvent','IssuesEvent','IssueCommentEvent','PullRequestReviewEvent','PullRequestReviewCommentEvent') AND actor_login NOT LIKE '%[bot]' AND NOT match(lower(actor_login), 'bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate')
 GROUP BY repo_name
 HAVING uniqExact(actor_login) >= 20 AND count() >= 1500 AND countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent')) >= 50
   AND (countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent') AND match(title,'[\\x{3040}-\\x{30FF}]')) >= 0.3*countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent'))
     OR countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent') AND match(title,'\\p{Hangul}')) >= 0.3*countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent'))
     OR countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent') AND match(title,'\\p{Han}') AND NOT match(title,'[\\x{3040}-\\x{30FF}]')) >= 0.3*countIf(action='opened' AND event_type IN ('IssuesEvent','PullRequestEvent'))))
GROUP BY repo_name, d
FORMAT TSVWithNames

