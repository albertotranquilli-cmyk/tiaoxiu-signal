#!/usr/bin/env bash
# Regenerates every number in README.md / RED_TEAM.md from public sources.
# Needs: python3 (3.11+), internet access to play.clickhouse.com and raw.githubusercontent.com. No keys.
set -euo pipefail
cd "$(dirname "$0")"
[ -d .venv ] || python3 -m venv .venv
.venv/bin/pip install -q -r requirements.txt
cd src
../.venv/bin/python fetch_inputs.py        # calendar + Innovation Graph at pinned commits
../.venv/bin/python extract.py             # ~70 SQL queries to the public ClickHouse playground (cached in data/raw)
../.venv/bin/python extract_controls.py    # same-time-zone control panel
../.venv/bin/python analyze.py             # main estimates, placebo, holdout  -> results/results.json
../.venv/bin/python robustness.py          # red-team grid                     -> results/robustness.json
../.venv/bin/python extra_checks.py        # split-half holdout etc.           -> results/extra_checks.json
../.venv/bin/python publish_tables.py      # org tables (large orgs only)      -> results/orgs_*_public.csv
../.venv/bin/python figures.py             # figures/*.png
../.venv/bin/python summarize.py           # results/SUMMARY.md (the numbers quoted in README)
