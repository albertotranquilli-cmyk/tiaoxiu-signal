# tiaoxiu-signal — numbers (gist-ready)

Source: https://github.com/albertotranquilli-cmyk/tiaoxiu-signal
Method: make-up workdays (调休) as natural experiments on GH Archive data.

## Headline results (E1: 2023-01-15 .. 2024-06-03, 12 make-up days)

- Repos with ≥1% Chinese issue/PR titles (186 repos): calendar-swap share **s = 0.652** [0.52, 0.77]. On make-up days they behave like ~2/3 of a normal weekday.
- Repos with <1% Chinese titles (3,395 repos): s = 0.062 [0.046, 0.082]. Uplift positive on 12 of 12 make-up days (sign test p = 0.0002).
- Repos with zero Chinese titles (2,711): s = 0.033 [0.021, 0.048].
- Japanese-language control (14 repos, UTC+9, no make-up days): s = −0.032 [−0.101, 0.044] — no movement.
- Mostly-Simplified-Chinese control panel (283 repos): s = 0.739 [0.696, 0.785].

## Organisations (pooled over eligible repos)

- **Apache Software Foundation** (71 repos): s = **0.33** [0.20, 0.46] — despite only 1.3% of titles in Chinese. Median repo: 0.21. Top-5-repos-removed: 0.23.
- Baidu PaddlePaddle: 0.59. Alibaba: 0.59.
- AWS: −0.01. Mozilla: 0.02. getsentry: 0.01. DataDog: 0.01. UK HMCTS: 0.01.
- Microsoft: 0.11. Azure SDK org: 0.17. OpenShift: 0.11.
- Kubernetes: 0.12 (CI includes 0). PyTorch: 0.10 (CI includes 0).

## Mechanism

- 78% of the <1%-Chinese-group excess lands in Beijing office hours (09:00–19:00 CST), vs 37% of their normal weekday–weekend gap. Lunch-hour dip at 12:00.
- Out-of-sample: repos flagged in 2023 score s = 0.581 on 2024 make-up days. In 2026 the 40 flagged repos are again positive (z = 10 vs placebos).

## What it measures

s = fraction of a repo's weekday-over-weekend activity gap that switches on when only mainland China works. It measures **calendar adherence**, not nationality or location. No personal data leaves the database.

## Reproduce

```bash
git clone https://github.com/albertotranquilli-cmyk/tiaoxiu-signal.git
cd tiaoxiu-signal
./run_all.sh   # python3 + internet, no keys, tens of minutes on cold cache
cat results/SUMMARY.md
```

## Limits (short)

- Day boundary at Asia/Shanghai midnight; UTC days change Western-repo scale.
- Make-up days border Chinese holidays; up to ~half the <1% signal may be proximity.
- 2025–26 data (E2) has degraded GH Archive capture — sign only, no magnitudes.
- Full red team: RED_TEAM.md in the repo.
