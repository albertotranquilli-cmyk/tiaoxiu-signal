# tiaoxiu-signal — one-page summary

**What it measures:** how much open-source work follows mainland China's official work calendar, using China's "make-up workdays" (调休) as a natural experiment. No personal data — only public aggregate event counts.

**The headline finding (2023–2024, 12 make-up days, 4,473 repos):**

| group | repos | activity on make-up days (vs weekday) |
|---|---|---|
| repos with ≥1% Chinese issue/PR titles | 186 | **65%** [52%, 77%] |
| repos with <1% Chinese titles | 3,395 | 6% [4.6%, 8.2%] |
| Apache Software Foundation (71 repos) | — | **33%** [20%, 46%] — despite only 1.3% Chinese titles |
| Baidu PaddlePaddle / Alibaba | — | 59% each |
| AWS, Mozilla, getsentry, UK HMCTS | — | ~0% |

**Why it matters:** a project with a score near 0.5 loses roughly half its weekday activity during Spring Festival and Golden Week. Useful for release planning, dependency risk, and security-response expectations — without geocoding anyone.

**Method in one paragraph:** for each make-up day, compare activity in a ±21-day window against ordinary weekdays and ordinary weekends of the same weekday. The score is the fraction of the weekday-over-weekend gap that "switches on" when only mainland China goes to work. Validated with hundreds of placebo weekend sets, out-of-sample holdouts (2023 → 2024, and 2026), and red-teaming documented in RED_TEAM.md.

**Reproduce:** `./run_all.sh` — Python 3, no keys, no paid services, tens of minutes on a cold cache. Full results in results/SUMMARY.md.

**Limits (honest):** the score measures calendar adherence, not nationality. Up to about half of the small signal in non-Chinese repos may be holiday proximity rather than the make-up day itself. 2025–26 data is degraded (capture loss), so only signs are reported for that era.

Link: https://github.com/albertotranquilli-cmyk/tiaoxiu-signal