# extract_raw.py — stream the 6 raw GH Archive hourly files and build the
# per-repo daily panel for the 6 make-up days missing from the playground.
#
# Reads:  data/raw/YYYY-MM-DD-HH.json.gz  (from load_raw.py)
# Writes: data/derived/daily_E1_raw6.csv   (repo_name, d, actors, events)
#         data/derived/repos_E1_raw6.csv  (repo_name, actors, events, titles,
#                                          t_zh, t_ja, t_ko, t_ru)
#
# Same filters as extract.py: WORK event types, HUMAN bot filter, China-day
# cut at Asia/Shanghai midnight (UTC+8). Title-script logic ports directly.
# No keys, no paid services. MIT.
import csv, gzip, json, os, re, sys

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
RAW = os.path.join(ROOT, "data", "raw")
OUT = os.path.join(ROOT, "data", "derived")

WORK = {"PushEvent", "PullRequestEvent", "IssuesEvent", "IssueCommentEvent",
        "PullRequestReviewEvent", "PullRequestReviewCommentEvent"}

# actor_login filters from extract.py, expressed as regex on the login string
BOT_RE = re.compile(r"bot$|bot-|-bot|_bot|robot|jenkins|automation|dependabot|renovate", re.I)


def is_human(login):
    if "[bot]" in login:
        return False
    return BOT_RE.search(login) is None


def has_han(s):
    return bool(re.search(r"\p{Han}", s)) if s else False


def has_hira_kata(s):
    return bool(re.search(r"[\u3040-\u30FF]", s)) if s else False


def has_hangul(s):
    return bool(re.search(r"\p{Hangul}", s)) if s else False


def has_cyrillic(s):
    return bool(re.search(r"\p{Cyrillic}", s)) if s else False


def china_day(created_at):
    """Map an ISO-ish created_at to the Asia/Shanghai calendar date.
    created_at is UTC; China = UTC+8, so add 8 hours and take the date.
    """
    # GH Archive uses e.g. 2024-06-15T03:21:44Z
    from datetime import datetime, timedelta
    try:
        t = datetime.fromisoformat(created_at.replace("Z", "+00:00"))
    except Exception:
        return None
    return (t + timedelta(hours=8)).date().isoformat()


def title_of(ev):
    p = ev.get("payload") or {}
    if ev.get("type") in ("IssuesEvent", "PullRequestEvent") and p.get("action") == "opened":
        if ev["type"] == "PullRequestEvent":
            pr = p.get("pull_request") or {}
            return pr.get("title") or ""
        return p.get("issue", {}).get("title") or ""
    return None


def main():
    os.makedirs(OUT, exist_ok=True)
    daily = {}      # (repo, day) -> {actors: set, events: int}
    repos = {}      # repo -> {actors, events, titles, t_zh, t_ja, t_ko, t_ru}
    files = sorted(f for f in os.listdir(RAW) if f.endswith(".json.gz")) if os.path.isdir(RAW) else []
    if not files:
        print("no files in data/raw/ — run load_raw.py first", file=sys.stderr)
        sys.exit(1)
    for fn in files:
        path = os.path.join(RAW, fn)
        print(f"reading {fn}")
        with gzip.open(path, "rt", encoding="utf-8", errors="replace") as f:
            for line in f:
                line = line.strip()
                if not line:
                    continue
                try:
                    ev = json.loads(line)
                except Exception:
                    continue
                t = ev.get("type")
                if t not in WORK:
                    continue
                actor = ev.get("actor") or {}
                login = actor.get("login") or ""
                if not is_human(login):
                    continue
                repo = (ev.get("repo") or {}).get("name")
                if not repo:
                    continue
                d = china_day(ev.get("created_at") or "")
                if d is None:
                    continue
                key = (repo, d)
                if key not in daily:
                    daily[key] = {"actors": set(), "events": 0}
                daily[key]["actors"].add(login)
                daily[key]["events"] += 1
                # title-script counts (opened issues/PRs only)
                title = title_of(ev)
                if title is not None:
                    r = repos.setdefault(repo, {"actors": set(), "events": 0,
                                              "titles": 0, "t_zh": 0, "t_ja": 0,
                                              "t_ko": 0, "t_ru": 0})
                    r["titles"] += 1
                    if has_han(title) and not has_hira_kata(title):
                        r["t_zh"] += 1
                    if has_hira_kata(title):
                        r["t_ja"] += 1
                    if has_hangul(title):
                        r["t_ko"] += 1
                    if has_cyrillic(title):
                        r["t_ru"] += 1
                r = repos.setdefault(repo, {"actors": set(), "events": 0,
                                          "titles": 0, "t_zh": 0, "t_ja": 0,
                                          "t_ko": 0, "t_ru": 0})
                r["actors"].add(login)
                r["events"] += 1
    # write daily panel
    daily_path = os.path.join(OUT, "daily_E1_raw6.csv")
    with open(daily_path, "w", newline="") as f:
        w = csv.writer(f)
        w.writerow(["repo_name", "d", "actors", "events"])
        for (repo, d), v in sorted(daily.items()):
            w.writerow([repo, d, len(v["actors"]), v["events"]])
    print(f"wrote {daily_path}  ({len(daily)} repo-day rows)")
    # write repo panel
    repos_path = os.path.join(OUT, "repos_E1_raw6.csv")
    with open(repos_path, "w", newline="") as f:
        w = csv.DictWriter(f, fieldnames=["repo_name", "actors", "events", "titles",
                                          "t_zh", "t_ja", "t_ko", "t_ru"])
        w.writeheader()
        for repo, r in sorted(repos.items()):
            w.writerow({"repo_name": repo, "actors": len(r["actors"]),
                        "events": r["events"], "titles": r["titles"],
                        "t_zh": r["t_zh"], "t_ja": r["t_ja"],
                        "t_ko": r["t_ko"], "t_ru": r["t_ru"]})
    print(f"wrote {repos_path}  ({len(repos)} repos)")


if __name__ == "__main__":
    main()
