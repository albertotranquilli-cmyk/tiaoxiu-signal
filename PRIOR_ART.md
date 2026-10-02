# Prior-art check

Done on 2026-10-02 (Europe/Rome). Goal: find out whether anyone has already used mainland China's
**make-up workdays** (调休 / 补班: Saturdays or Sundays that are official working days only in
mainland China) as a natural experiment to measure how much of an open-source project's activity
runs on the mainland-China work calendar, or published anything close to it.

## What was searched

| Source | Queries (verbatim) | Result |
|---|---|---|
| Hacker News (hn.algolia.com API, all items and `tags=story`) | `chinese new year github`, `make-up workday`, `tiaoxiu`, `github activity holidays country`, `golden week github`, `infer contributor country github`, `open source china share contributors`, `Chinese developers open source share`, `make-up workday github`, `chinese new year github activity`, `github commits holidays country`, `make-up working day china weekend data`, `github innovation graph china` | Nothing relevant. Hits were off-topic (GFW attacks on GitHub, trade-war essays, Show HNs). The story-only searches returned 0 hits. |
| arXiv API (`export.arxiv.org`) | `all:GitHub AND all:holiday`, `all:GitHub AND all:"New Year"`, `all:"open source" AND all:geography AND all:contributors`, `all:"make-up" AND all:workday`, `all:GitHub AND all:country AND all:infer`, `all:"working time" AND all:developers AND all:China`, `all:"adjusted working days" OR all:"makeup workdays"` | Only Wachs et al. (2107.03200) and Rossi & Zacchiroli (2202.07278) came up; both are geography studies based on profile/e-mail/name data (below). |
| Semantic Scholar API, OpenAlex API | 6 + 8 queries (holiday / Chinese New Year / make-up workday / developer location) | Both rate-limited on the shared IP (HTTP 429 / "budget used up"); no results obtained. Replaced by Crossref + web search. |
| Crossref API | `Chinese New Year GitHub`, `adjusted working day China`, `calendar fingerprint attribution holidays` (+3 that errored) | Nothing relevant. |
| GitHub repo search (`gh search repos`) | `make-up workday github activity`, `chinese holiday github activity analysis`, `tiaoxiu`, `github activity chinese new year`, `github holidays country activity`, `make-up workday`, `chinese workday calendar activity analysis github events` | Only calendar/API utilities that *list* make-up workdays (holiday APIs, desktop calendars). No analysis that uses them as a measurement instrument. |
| Web search (general, scholarly, Chinese-language) | e.g. "GitHub activity drop Chinese New Year holiday infer developer country share repository"; "inferring geographic location of open source contributors from holidays commit activity paper"; "调休 GitHub 提交 数据分析 周末 补班"; "China adjusted holiday / make-up workdays natural experiment"; "APT attribution activity timestamps Chinese public holidays"; "threat actor activity on Chinese make-up working day"; "share of open source contributions from China Apache Software Foundation" | See closest prior art below. |

## Closest prior art and the delta

1. **Holiday dips in GitHub activity are known.** GitHub's *State of the Octoverse: breaks and
   holidays* (2018) shows activity slowing in China around Chinese New Year and Golden Week.
   Shen (2020/2023, *Does Working from Home Work? A Natural Experiment from Lockdowns*) plots a
   commit dip during Chinese New Year for users whose **self-reported location** was geocoded to
   China and neighbouring countries. Chen et al. (IEEE Software 2021, *Understanding the Working
   Time of Developers in IT Companies in China and the United States*) compare commits during and
   around holidays for companies already known to be Chinese or American.
   *Delta:* these works start from a known location and show that holidays matter. None of them
   uses **make-up workdays**, and none goes the other way, estimating a project's calendar
   composition from its activity alone. Holiday dips are also confounded: Spring Festival 2024 and
   2026 overlap Carnival, and in 2026 also US Presidents' Day. We show this below. A working
   Sunday that only mainland China observes has no such confounder.

2. **Developer geolocation.** Wachs et al. 2022 (*The Geography of Open Source Software*, arXiv
   2107.03200) use profile locations and e-mail suffixes. Rossi & Zacchiroli 2022 (*Geographic
   Diversity in Public Code Contributions*) use e-mail ccTLDs, name distributions and commit UTC
   offsets. Robles & González-Barahona 2006 (SourceForge) use e-mails and time zones. The
   *Organizational Artifacts of Code Development* paper (arXiv 2105.14637) labels repos as US or
   Chinese from geocoded contributor profiles. GitHub Innovation Graph publishes developer counts
   per economy, aggregated by country, not per project.
   *Delta:* all of these need **per-person attributes** (location strings, e-mails, names, commit
   time-zone offsets). Our estimator uses only per-repo daily counts of distinct active accounts
   from public events, plus the official Chinese calendar. It never looks at a user, and its
   target is a project-level quantity.

3. **Tools that use the tiaoxiu calendar as an input.** `code996` and similar tools (e.g.
   `git-fish-log`) take the make-up-workday calendar as given. They label days correctly when
   computing overtime for a team already assumed to be Chinese.
   *Delta:* there the calendar is a labelling input. Here it is the instrument for measurement,
   and we validate it.

4. **Threat-intelligence attribution.** Mandiant (APT41, UNC4841), PwC (APT10), Trellix (2025
   Kimsuky-linked campaign) and Lumen (Raptor Train) attribute *single actors* through UTC+8
   working hours, lunch breaks and pauses during Chinese holidays.
   *Delta:* those are qualitative, single-actor fingerprints. We found no report that uses
   make-up workdays. Our method is aggregate and quantitative, comes with placebo-based
   inference, and is applied to open-source ecosystems, never to individuals.

5. **Economics of China's holiday system.** There is literature on the 1995 two-day-weekend
   reform (Fang, Lin et al. 2024) and press coverage of tiaoxiu (CNA, CNN 2024). We found no study
   that uses make-up workdays as an identification device for online activity.

6. **Context numbers, not prior art for the method.** Kaiyuanshe's *2024 China Open Source
   Report* puts China at 7.2% of global contributors. A 2024 blog post (coss.fun) finds that more
   than half of new Apache incubator projects in 2018–2024 were initiated by developers living in
   China. GitHub Innovation Graph has China at 9.0% of developers in 2023Q1, falling to 5.9% in
   2026Q1.

**Conclusion:** we found no prior use of mainland-China make-up workdays as a natural experiment
for measuring the calendar (and so the approximate location) composition of online or
open-source activity. The closest work either starts from known locations (1, 2) or treats the
calendar as an input (3). Scholarly coverage is not exhaustive: Semantic Scholar and OpenAlex
were rate-limited during this check, and Google Scholar was not queried directly.
