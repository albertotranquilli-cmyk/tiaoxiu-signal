# Draft posts (for the owner to publish himself; nothing has been posted)

## Hacker News

**Title:** Show HN: The weekends only China works reveal how much OSS runs on Beijing's calendar

**Text:**

To stretch public holidays, mainland China makes a few Saturdays and Sundays official working
days each year (调休, "make-up workdays"). No other country works those days. To time zones,
seasonality and Western holidays they are ordinary weekends. That makes each one a natural
experiment: if a GitHub repo's activity on that specific weekend day looks like a weekday, the
people doing the work keep the mainland-China work calendar.

I turned this into a simple estimator, the share of a repo's weekday-vs-weekend activity gap that
"switches on" on those days. I ran it on GH Archive (via the public ClickHouse playground) over
12 make-up days in 2023–24, for the ~3,600 most active public repos. It uses no personal data at
all: only daily counts of distinct active accounts per repo, plus the official calendar.

What came out:
- Repos with Chinese-language issue titles run at ~65% of a normal weekday on those weekends.
  On ordinary placebo weekends they are at 0%. Japanese-language repos (one time zone away, no
  make-up days) stay at about 0.
- 159 of the 289 repos with an individually significant signal have <1% Chinese titles. Text
  heuristics miss them.
- Repos flagged on the 2023 dates show the effect again on the 2024 dates, and again on the 2026
  dates.
- Pooled over its repos, the Apache Software Foundation scores about 0.33, although only 1.3% of
  its issue titles are in Chinese.

The repo has a red-team file with the things that did not work. The aggregate share for
English-only repos does not replicate in the shorter 2025–26 window (underpowered). The Korean
control is too noisy, and a Taiwan control was impossible. The score measures adherence to the
calendar, not nationality. All numbers regenerate from one script, with no keys or paid services.

Repo: <REPO_LINK>

## X (max ~270 chars; 265 counting the link as 23 chars, as X does)

China turns a few weekends a year into official workdays. On those days, GitHub repos with Chinese-language issues run at ~65% of a weekday (placebo weekends: 0%). Apache scores ~0.33 despite 1.3% Chinese text. Public data, no personal data: <REPO_LINK>
