# Draft posts — ready to publish

Status: drafts written 2026-10-05. Nothing has been posted yet.

## X — short (max 280 chars; link counts as 23)

China turns a few weekends a year into workdays. On those days GitHub repos with Chinese-language issues run at ~65% of a weekday (ordinary weekends: ~0%). It measures calendar adherence, not nationality. Aggregate public data only: https://github.com/albertotranquilli-cmyk/tiaoxiu-signal

## X — thread (5 posts)

1/ China turns a few weekends a year into official workdays (调休). No other country works those days. To time zones and Western holidays they are ordinary weekends — which makes each one a natural experiment for open source.

2/ I built an estimator: the share of a repo's weekday-vs-weekend activity gap that "switches on" on those make-up days. Ran it on GH Archive over 12 make-up days in 2023–24, ~3,600 most active public repos. Outputs contain no personal data — only per-repo daily counts.

3/ Repos with Chinese-language issue titles run at ~65% of a normal weekday on those weekends. On ordinary placebo weekends: ~0%. Japanese-language repos, one time zone away with no make-up days: also ~0.

4/ Repos with <1% Chinese titles show a smaller effect: ~6% [4.6–8.2%], positive on 12 of 12 days. 78% of that excess falls in Beijing office hours (09–19 CST), with a lunch-hour dip at 12:00.

5/ Pooled over its 71 most active repos, the Apache Software Foundation scores ~0.33 — although only 1.3% of its issue titles are in Chinese. Its 10 most influential repos supply 62% of that figure. Repo: https://github.com/albertotranquilli-cmyk/tiaoxiu-signal

## Hacker News

**Title:** Show HN: Using the weekends only mainland China works to measure OSS calendar adherence

**Text:**

To stretch public holidays, mainland China makes a few Saturdays and Sundays official working days each year (调休, "make-up workdays"). No other country works those days. To time zones, seasonality and Western holidays they are ordinary weekends. That makes each one a natural experiment: if a GitHub repo's activity on that specific weekend day looks like a weekday, part of its activity follows the mainland-China work calendar. That is calendar adherence, not nationality.

I turned this into a simple estimator, the share of a repo's weekday-vs-weekend activity gap that "switches on" on those days. I ran it on GH Archive (via the public ClickHouse playground) over 12 make-up days in 2023–24, for the ~3,600 most active public repos. The outputs contain no personal data: only per-repo daily counts of distinct active accounts, plus the official calendar.

What came out:
- Repos with Chinese-language issue titles run at ~65% of a normal weekday on those weekends. On ordinary placebo weekends they are at 0%. Japanese-language repos (one time zone away, no make-up days) stay at about 0.
- Repos with <1% Chinese titles show a much smaller effect: ~6% [4.6–8.2%], positive on 12 of 12 days. 140 of the 257 repos with an individually significant signal are in that group, and 70 have no Chinese titles at all, so title language alone does not identify calendar exposure. 78% of that group's make-up-day excess falls in Beijing office hours (09–19 CST), with a dip at the 12:00 lunch hour.
- Repos flagged on the 2023 dates show the effect again on the 2024 dates (0.58). They are still positive on the 2026 dates, though 2025–26 GH Archive data is heavily under-captured, so only the sign carries over.
- Pooled over its 71 most active repos, the Apache Software Foundation scores about 0.33, although only 1.3% of its issue titles are in Chinese. Its 10 most influential repos supply 62% of that figure (median repo: 0.21). It describes when the work happens, not who does it.

The repo has a red-team file with the things that did not work. For repos with <1% Chinese titles, the 2025–26 window is uninformative: 4 days, and GH Archive capture degrades sharply from mid-2025 (PR and comment events down 54–72%, PR titles empty). Make-up days always border a Chinese holiday, and up to about half of that group's 6% may be holiday proximity rather than the make-up day itself. Its scale also depends on where the day is cut (4.8% with UTC days). The Korean control is too noisy and was set aside after seeing it, and a Taiwan control was impossible. The score measures adherence to the calendar, not nationality. All numbers regenerate from one script, with no keys or paid services.

Repo: https://github.com/albertotranquilli-cmyk/tiaoxiu-signal

## LinkedIn

Most open-source risk analysis geolocates contributors. There's a simpler signal hiding in plain sight: China's make-up workdays.

A few times a year, mainland China turns a Saturday or Sunday into an official working day to pay for a longer holiday. No other country does this. To time zones and Western holidays, those days are ordinary weekends — which makes each one a natural experiment for measuring how much of a project's activity follows the mainland-China work calendar.

I built an estimator for this and ran it on GH Archive across 12 make-up days in 2023–24 (~3,600 most active public repos). Headline numbers:

- Repos with Chinese-language issue titles: ~65% of normal weekday activity on those days (placebo weekends: ~0%).
- Repos with <1% Chinese titles: ~6% [4.6–8.2%], positive on all 12 days. 78% of that excess lands in Beijing office hours.
- Apache Software Foundation (71 repos): ~0.33 — despite only 1.3% of issue titles in Chinese. Top-10 repos supply 62% of the figure.
- Known positives: Baidu PaddlePaddle 0.59, Alibaba 0.59. Near zero: AWS −0.01, Mozilla 0.02, DataDog 0.009.

It measures calendar adherence, not nationality or location. No personal data leaves the database. Full red team in the repo — the things that did not work are documented, including that up to half of the <1% group's signal may be holiday proximity.

https://github.com/albertotranquilli-cmyk/tiaoxiu-signal

## README blurb (drop-in for the top of README.md)

> **One-line result:** on China's make-up workdays, repos with Chinese-language titles run at ~65% of a weekday; the Apache Software Foundation's 71 most active repos score ~0.33 despite 1.3% Chinese titles. It measures calendar adherence, not nationality. No personal data. Reproduce with `./run_all.sh`.
