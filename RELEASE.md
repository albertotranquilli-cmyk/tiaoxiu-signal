# Releasing tiaoxiu-signal

Tags are created from the CLI (the GitHub connector cannot push tags).

```bash
git checkout main && git pull
git tag -a v0.1.0 -m "v0.1.0: calendar-swap estimator, red team, CI"
git push origin v0.1.0
```

Then create the release on GitHub (or `gh release create v0.1.0`), so the repo has a pinned, citable version alongside CITATION.cff in audits.

## What v0.1 contains

- Estimator `s` (calendar-swap share) with two-way bootstrap CIs
- Placebos, split-half holdout, red-team grid (RED_TEAM.md)
- Mechanism: hour-of-day profile, UTC day-boundary check
- GH Archive capture diagnostics
- `./run_all.sh` full reproduction, no keys
- CI workflow: `.github/workflows/ci.yml` (runs run_all.sh weekly)
- Public numbers gist draft: GIST.md
