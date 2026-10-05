# PLAN.md — extend E1 with the 6 raw GH Archive make-up days

Status: 2026-10-05. Step 0 (this file + load_raw.py) done. Steps 1-4 are the work that turns E2 from sign-only into a second measured era.

## Why

RED_TEAM.md row 18: the ClickHouse playground has a gap 2024-06-05..2025-09-25. The raw GH Archive files on data.gharchive.org are complete for that window and contain 6 make-up workdays that E1 currently misses:

| China date | UTC window | Day |
|---|---|---|
| 2024-06-15 | 2024-06-14T16 .. 2024-06-15T16 | Sat |
| 2024-09-14 | 2024-09-13T16 .. 2024-09-14T16 | Sat |
| 2024-10-12 | 2024-10-11T16 .. 2024-10-12T16 | Sat |
| 2025-01-26 | 2025-01-25T16 .. 2025-01-26T16 | Sun |
| 2025-02-08 | 2025-02-07T16 .. 2025-02-08T16 | Sat |
| 2025-05-05 | 2025-05-04T16 .. 2025-05-05T16 | Mon |

Adding them extends E1 from 12 to 18 make-up days. That is the single highest-leverage change available: more days tighten the two-way CIs, give the <1% group a stronger sign test, and may make E2's 4 days informative enough to quote magnitudes instead of sign-only.

## Steps

### Step 0 — scaffolding (done)

- `src/load_raw.py`: downloads only the 144 hourly files for the 6 China days (~5-8 GB gzipped). Supports `--dry-run`. Skips files already present. No keys.
- This PLAN.md.

### Step 1 — download (run locally, not in CI)

```
python src/load_raw.py
```

Expect ~144 files under `data/raw/`, 100-400 MB each. Disk: ~8 GB free. This is a one-time cost; the files are content-addressed by hour and never need re-downloading.

Do NOT commit the raw files — they are huge and derived. `data/raw/` is in `.gitignore` (add it if missing). What gets committed is only the derived CSVs.

### Step 2 — extract the 6 days into the E1 panel

New script `src/extract_raw.py` (to write): stream each hourly JSON, keep only events in the 6 China-day windows, apply the same HUMAN bot filter and WORK event types as `extract.py`, and emit per-repo daily distinct-actor counts for those 6 days only. Append to `data/derived/daily_E1.csv.gz` (or write `data/derived/daily_E1_raw6.csv` and merge in analyze).

Key detail: the raw files use the same schema as the playground table (`actor.login`, `repo.name`, `type`, `created_at`, `payload` with `action` and `pull_request`/`issue` title fields), so the title-script logic from `extract.py` ports directly. The only new work is JSON streaming instead of SQL.

### Step 3 — re-run the analysis

`./run_all.sh` as-is will not see the new days (it reads the playground). Two options:

- (a) Minimal: a one-off `src/analyze_raw6.py` that loads the 6-day panel, runs the same estimator/placebo/two-way bootstrap as `analyze.py`, and writes `results/raw6.json`.
- (b) Cleaner: refactor `analyze.py` to accept an optional extra panel path. Prefer (a) for speed; (b) if this becomes a recurring pattern.

### Step 4 — update the paper

- PAPER.md section 2.1: E1 = 18 make-up days.
- RED_TEAM.md row 18: mark resolved, cite the new numbers.
- results/SUMMARY.md: regenerate.
- If the <1% group's 18-day sign test and CIs improve enough, consider whether E2 (4 days, degraded capture) can be quoted with magnitudes — probably still sign-only, but the combined E1+raw6 evidence gets stronger.

## Cost and risk

- Disk: ~8 GB one-time.
- Time: download ~1-2 hours on a decent line; extraction ~30-60 min streaming JSON; analysis minutes.
- Risk: low. The 6 days are independent of the playground data; if extraction disagrees with the playground on overlapping days it is a bug to fix, not a reason to drop.
- No keys, no paid services, fully reproducible.

## What this does NOT do

- It does not fix E2's capture loss (row 22) — that is a GH Archive-side problem, not ours.
- It does not add a Taiwan/HK control (row 4) — still <5 eligible repos.
- It does not resolve the holiday-proximity caveat for the <1% group (row 20) — more days help the sign test but the DiD design stays the same.
