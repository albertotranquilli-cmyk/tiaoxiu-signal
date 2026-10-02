# Draft posts (for the owner to publish himself; nothing has been posted)

## Hacker News

**Title:** Show HN: Using the weekends only mainland China works to measure OSS calendar adherence

**Text:**

To stretch public holidays, mainland China makes a few Saturdays and Sundays official working
days each year (调休, "make-up workdays"). No other country works those days. To time zones,
seasonality and Western holidays they are ordinary weekends. That makes each one a natural
experiment: if a GitHub repo's activity on that specific weekend day looks like a weekday, part of
its activity follows the mainland-China work calendar. That is calendar adherence, not nationality.

I turned this into a simple estimator, the share of a repo's weekday-vs-weekend activity gap that
"switches on" on those days. I ran it on GH Archive (via the public ClickHouse playground) over
12 make-up days in 2023–24, for the ~3,600 most active public repos. The outputs contain no
personal data: only per-repo daily counts of distinct active accounts, plus the official calendar.

What came out:
- Repos with Chinese-language issue titles run at ~65% of a normal weekday on those weekends.
  On ordinary placebo weekends they are at 0%. Japanese-language repos (one time zone away, no
  make-up days) stay at about 0.
- Repos with <1% Chinese titles show a much smaller effect: ~6% [4.6–8.2%], positive on 12 of
  12 days. 140 of the 257 repos with an individually significant signal are in that group, and 70
  have no Chinese titles at all, so title language alone does not identify calendar exposure.
  78% of that group's make-up-day excess falls in Beijing office hours (09–19 CST), with a dip at
  the 12:00 lunch hour.
- Repos flagged on the 2023 dates show the effect again on the 2024 dates (0.58). They are still positive
  on the 2026 dates, though 2025–26 GH Archive data is heavily under-captured, so only the sign
  carries over.
- Pooled over its 71 most active repos, the Apache Software Foundation scores about 0.33,
  although only 1.3% of its issue titles are in Chinese. Its 10 most influential repos
  supply 62% of that figure (median repo: 0.21). It describes when the work happens, not who does it.

The repo has a red-team file with the things that did not work. For repos with <1% Chinese
titles, the 2025–26 window is uninformative: 4 days, and GH Archive capture degrades sharply from
mid-2025 (PR and comment events down 54–72%, PR titles empty). Make-up days always border a
Chinese holiday, and up to about half of that group's 6% may be holiday proximity rather than the
make-up day itself. Its scale also depends on where the day is cut (4.8% with UTC days). The
Korean control is too noisy and was set aside after seeing it, and a Taiwan control was
impossible. The score measures adherence to the
calendar, not nationality. All numbers regenerate from one script, with no keys or paid services.

Repo: <REPO_LINK>

## X (max ~270 chars; 256 counting the link as 23 chars, as X does)

China turns a few weekends a year into workdays. On those days GitHub repos with Chinese-language issues run at ~65% of a weekday (ordinary weekends: ~0%). It measures calendar adherence, not nationality. Aggregate public data only: <REPO_LINK>
