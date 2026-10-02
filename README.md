# tiaoxiu-signal: measuring how much open-source work runs on mainland China's calendar, using the weekends only China works

Several times a year, mainland China turns a Saturday or Sunday into an official working day to
pay for a longer holiday. This is 调休 (*tiaoxiu*), and the day is a "make-up workday" (补班). No other
country works on those dates. Time zones, global seasonality and Western holidays treat them like
any other weekend. That makes each one a clean natural experiment: if a project's activity on that
specific weekend day looks like a weekday, the people doing that work keep the mainland-China
work calendar.

This repo turns that observation into an estimator. It runs the estimator on public GitHub event
data (GH Archive, via the public ClickHouse playground), validates it with placebos, controls and
out-of-sample holdouts, and red-teams it ([RED_TEAM.md](RED_TEAM.md)). It uses **no personal
data**: no profiles, locations, e-mails, names or commit time-zone offsets. The inputs are only
daily counts of distinct active accounts per repository, and the official calendar.

![make-up days](figures/makeup_days_E1.png)

## The estimator ("calendar-swap share", s)

For a repository, take a local window of ±21 days around each make-up day *m*, excluding Chinese
holidays ±2 days, other make-up days, major non-Chinese holidays and days with incomplete data.
In that window:

* W = mean daily **distinct human accounts** active on ordinary weekdays;
* E = the same on ordinary weekend days with the same weekday as *m*;
* A = the count on the make-up day itself.

```
s = Σ_m (A_m − E_m) / Σ_m (W_m − E_m)
```

s is the fraction of the repo's weekday-over-weekend gap that "switches on" when only mainland
China goes to work. A value of 0 means the day behaves like a normal weekend; 1 means it behaves
like a normal weekday. If every group of contributors has a similar weekend/weekday ratio, s is
roughly the share of the repo's weekday activity coming from people on the mainland-China work
calendar. That is an assumption; see [RED_TEAM.md](RED_TEAM.md) rows 15 and 17.

Inference uses **placebos**: the same estimator on hundreds of sets of ordinary weekend days,
matched on weekday. Group CIs are bootstrapped over repositories.

"Human" here means work events (push, PR, issue, comment, review) by accounts whose login does
not look like a bot.

## Data

* `default.github_events` on the public ClickHouse playground (`https://play.clickhouse.com/?user=play`),
  a copy of GH Archive. The playground copy has complete data for **2023-01-13..2024-06-04** and
  **2025-09-26..2026-07-02** (with a hole on 2025-10-09..14). This gives two eras:
  * **E1**: China dates 2023-01-15..2024-06-03, with **12 make-up days**;
  * **E2**: 2025-10-16..2026-07-01, with **4 make-up days**.
* Panel: every repo with ≥50 distinct human accounts and ≥5,000 human work events in E1 (4,473
  repos; ≥2,500 events in E2, 1,431 repos). The 3,581 E1 repos with a large enough weekday–weekend
  gap and ≥30 issue/PR titles are "eligible".
* Calendar: [NateScarlet/holiday-cn](https://github.com/NateScarlet/holiday-cn) (MIT), compiled
  from State Council notices, pinned at commit `159faa5`.
* Independent check signal: the share of a repo's opened issue/PR titles that contain Han
  characters and no Japanese kana ("Chinese titles"). It is never used by the estimator.
* Context only: GitHub Innovation Graph `developers.csv` (CC0), pinned at commit `078fb62`.

Every SQL statement that was run is in [`data/queries.sql`](data/queries.sql).

## Results (E1 unless stated; all numbers from `results/SUMMARY.md`)

**1. The signal is real and specific to the calendar.**

| group (E1) | repos | s on make-up days | placebo weekends |
|---|---|---|---|
| ≥1% Chinese titles | 186 | **0.652** [0.601, 0.699] | −0.001 ± 0.012 |
| <1% Chinese titles | 3,395 | **0.062** [0.053, 0.072] | +0.001 ± 0.012 |
| control panel: mostly Simplified-Chinese titles | 283 | 0.739 [0.696, 0.785] | −0.001 ± 0.017 |
| control panel: mostly Japanese titles (UTC+9, no make-up days) | 14 | −0.032 [−0.101, 0.044] | +0.000 ± 0.041 |

On ordinary weekends, Chinese-language repos look like everyone else's weekend. On the 12
make-up weekends they run at about two thirds of a normal weekday. Japanese-language repos, one
hour away, do not move.

**2. Most of the signal is invisible to text-based heuristics.** For repos with <1% Chinese
titles, the uplift is positive on **12 of 12** make-up days (sign test p = 0.0002). At the repo
level, 289 repos are individually significant (Benjamini–Hochberg q < 0.05), and **159 of them
have less than 1% Chinese titles**. These are English-language projects whose weekday rhythm
follows Beijing's calendar.

**3. It predicts the future (out-of-sample).**

* Split-half: repos flagged on the 7 make-up days of 2023 score **0.556** [0.50, 0.61] on the 5
  make-up days of 2024. The 106 flagged English-only repos score **0.414** [0.33, 0.50]. Unflagged
  repos score 0.040.
* Two years later: of the repos flagged in 2023–24 that are still in the 2025–26 panel, 42 score
  **0.623** [0.50, 0.73] on the 2026 make-up days. The 22 English-only ones score **0.481**
  [0.31, 0.63]. The 522 unflagged repos score −0.026.

**4. Organisations (pooled over each org's eligible repos; only orgs with ≥10 eligible repos,
plus two openly China-headquartered companies used as known positives).**

![orgs](figures/orgs_E1.png)

* **Apache Software Foundation** (71 repos): s = **0.33** [0.21, 0.46], although only **1.3%** of
  its issue/PR titles are in Chinese. E2 replication: 0.31 [0.01, 0.56] (21 repos). This agrees
  with independent counts that more than half of new Apache incubator projects in 2018–2024 were
  started by developers based in China.
* Known positives: Baidu's PaddlePaddle 0.59 [0.46, 0.67] and Alibaba 0.59 [0.50, 0.69].
* Near zero: AWS −0.01, DataDog 0.01, UK HM Courts & Tribunals Service 0.01, getsentry 0.01,
  Mozilla 0.02.
* In between: Microsoft's Azure SDK org 0.17 [0.12, 0.22] (E2: 0.30), Kubernetes 0.12, OpenShift
  0.11, PyTorch 0.10 (wide CI).

The full table is in `results/orgs_E1_public.csv` / `orgs_E2_public.csv`.

## Why it matters

* **A location-free census of who keeps a project running, with no PII.** Supply-chain and
  "bus-factor" analyses need to know where maintainers sit (time zones, holidays, regulation,
  sanctions or export-control exposure). Existing methods geocode people. This one only needs
  public aggregate counts and a calendar.
* **Operational planning.** A project with s ≈ 0.5 loses about half its weekday capacity during
  Spring Festival and Golden Week. That is useful for release timing, security response
  expectations and SLAs on dependencies.
* **The trick generalises.** Any jurisdiction-specific shift of working days, including bridge
  days and moved holidays in other countries, can be used as an instrument the same way.

## Honest limits (details in [RED_TEAM.md](RED_TEAM.md))

* s measures **adherence to the mainland-China official work calendar**, not nationality.
  Reading it as a share of contributors assumes similar weekend ratios. Even mostly-Chinese repos
  reach only about 0.74, so s is conservative.
* For English-only repos, the **aggregate** 6% does **not** replicate in E2 (0.017, CI includes 0).
  E2 has only 4 usable make-up days and a smaller panel. We make no trend claim.
* Controls: the Japanese control is clean but small (n=14). The Korean control is noisy and
  inconclusive (bootcamp repos). A Taiwan/Hong Kong control was not possible (too few repos).
* Per-repo estimates are noisy. We deliberately publish only group and organisation aggregates.
* The sample is the most active public repos only; private and enterprise work is invisible.
  Bots are filtered by login name.
* Source gaps: no data in the playground copy from June 2024 to September 2025. Raw GH Archive
  files could add 6 more make-up days.

## Reproduce

```bash
./run_all.sh          # python3 + internet; no keys, no paid services; ~10 minutes
cat results/SUMMARY.md
```

`run_all.sh` downloads the pinned calendar and Innovation Graph inputs. It then sends about 80
SQL queries to the public ClickHouse playground (cached in `data/raw/`, logged in
`data/queries.sql`), runs the analysis, placebos, holdouts and robustness grid, and regenerates
the figures and `results/SUMMARY.md`. Placebo draws use fixed seeds. Per-repo intermediate files
are written locally but intentionally not committed.

Layout: `src/ch.py` (query client), `src/extract*.py` (data pull), `src/core.py` (estimator),
`src/placebo.py`, `src/analyze.py`, `src/robustness.py`, `src/extra_checks.py`,
`src/publish_tables.py`, `src/figures.py`, `src/summarize.py`.

## License

MIT (code). Inputs remain under their own terms: GH Archive (public GitHub events), holiday-cn
(MIT), GitHub Innovation Graph (CC0-1.0).
