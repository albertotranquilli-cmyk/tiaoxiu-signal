# README.md

# tiaoxiu-signal

**Finding**: Apache Software Foundation repos run at ~33% of weekday activity on Chinese make-up workdays (调休), despite only 1.3% of issue/PR titles being in Chinese.

## Headline numbers

- **s = 0.334** for ASF repos (panel of 71), CI [0.203, 0.464], z = 22.6 vs placebo
- **65%** for repos with >=1% Chinese-language titles
- **6%** for repos with <1% Chinese-language titles
- **Baidu/Alibaba: 59%** — the positive controls
- **AWS: -1%, Mozilla: 2%, DataDog: 0.9%, getsentry: 1.4%** — all near zero
- **Microsoft: 11%, Azure: 17%** — partial signal
- **78%** of ASF excess falls in Beijing office hours (09-19 CST) vs 37% of normal gap
- Top 10 repos contribute 62% of the signal; drop top 5 -> s = 0.229 (still high)
- Median single-repo s: 0.207

## Method

Natural experiment: Chinese make-up workdays shift work onto weekends. Measure weekday-vs-weekend activity gap on those dates vs ordinary weekends. Placebo dates, holdout repos, red team (26 attacks) all documented in-repo.

## Limits (declared)

- s measures calendar adherence, not nationality of contributors
- Signal is concentrated in the most active repos
- Phrase correctly: "~a third of the activity gap of the most active ASF repos follows the Chinese calendar"

## Files

- **SUMMARY.md** — one-page version of the numbers (for sharing)
- **POST.md** — ready-to-paste posts: X short, X thread (5 posts), Hacker News, LinkedIn
- **GIST.md** — gist-ready summary for public indexing
- **PAPER.md** — structured paper draft with abstract, method, results, red team table, limits

## Related

- audits: https://github.com/albertotranquilli-cmyk/audits
- bounty-ghostbuster: https://github.com/albertotranquilli-cmyk/bounty-ghostbuster
- cert-fingerprint (infrastructure substrate, in progress): https://github.com/albertotranquilli-cmyk/cert-fingerprint
- grok-archive (private lab): https://github.com/albertotranquilli-cmyk/grok-archive
