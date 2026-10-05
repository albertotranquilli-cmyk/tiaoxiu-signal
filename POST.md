# tiaoxiu-signal — post pronti per la pubblicazione

## X — short (max 280 caratteri)

Apache repos run at ~33% of weekday activity on Chinese make-up workdays — despite only 1.3% of titles being in Chinese. 65% for repos with ≥1% Chinese titles, 6% for <1%. AWS/Mozilla near zero. https://github.com/albertotranquilli-cmyk/tiaoxiu-signal

## X — thread (5 post)

1/ Apache Software Foundation repos run at about a third of their weekday activity on Chinese make-up workdays (调休). Despite only 1.3% of issue/PR titles being in Chinese.

2/ The split is stark: repos with ≥1% Chinese-language titles show 65% adherence. Repos with <1% show 6%. Baidu and Alibaba — the obvious controls — sit at 59%.

3/ Western controls are flat: AWS −1%, Mozilla 2%, DataDog 0.9%, getsentry 1.4%. Microsoft 11%, Azure 17% — partial signal, worth investigating.

4/ 78% of the ASF excess falls in Beijing office hours (09–19 CST) vs 37% of the normal weekday-weekend gap. The signal is not just calendar-shaped, it's hour-shaped.

5/ Method: natural experiment on 6 make-up dates, placebo controls, 26-attack red team, all in-repo. s = 0.334, CI [0.203, 0.464], z = 22.6. https://github.com/albertotranquilli-cmyk/tiaoxiu-signal

## Hacker News

Title: Apache repos show 33% activity drop on Chinese make-up workdays (s=0.334, red-teamed)
URL: https://github.com/albertotranquilli-cmyk/tiaoxiu-signal
Text: We measured weekday-vs-weekend activity gaps on 6 Chinese make-up workdays (调休) across 71 ASF repos. s = 0.334 (CI 0.203–0.464), z = 22.6 vs placebo. Repos with ≥1% Chinese titles: 65%. <1%: 6%. Baidu/Alibaba 59%. AWS/Mozilla near zero. 78% of excess in Beijing office hours. 26-attack red team documented. Limits declared in-repo.

## LinkedIn

New research: Chinese make-up workdays (调休) shift ~a third of Apache Software Foundation repo activity onto weekends — measurable from public data, no personal information touched. s = 0.334 across 71 repos, with 65% adherence for repos that have ≥1% Chinese-language titles vs 6% for those below 1%. Western controls (AWS, Mozilla, DataDog) sit near zero; Baidu and Alibaba at 59%. 78% of the excess falls in Beijing office hours. Full method, red team (26 attacks), and declared limits: https://github.com/albertotranquilli-cmyk/tiaoxiu-signal
