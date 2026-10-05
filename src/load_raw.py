# load_raw.py — download GH Archive raw JSON files for the playground gap.
#
# The ClickHouse playground copy of GH Archive has no data from 2024-06-05 to
# 2025-09-25 (see RED_TEAM.md row 18). The raw files on data.gharchive.org are
# complete for that window and contain 6 more make-up workdays:
#   2024-06-15, 2024-09-14, 2024-10-12, 2025-01-26, 2025-02-08, 2025-05-05.
#
# This script downloads only the hours needed for those 6 China days
# (Asia/Shanghai midnight = 16:00 UTC the previous day, through 15:59 UTC).
# Each file is ~100-400 MB gzipped; total ~5-8 GB. It does NOT run the full
# analysis — that is a separate, heavier step (see PLAN.md).
#
# Usage: python load_raw.py [--dry-run]
# No keys, no paid services. MIT.
import argparse, gzip, json, os, sys, urllib.request

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
OUT = os.path.join(ROOT, "data", "raw")
BASE = "https://data.gharchive.org"

# (China date, UTC start hour inclusive, UTC end hour exclusive)
MAKEUP_UTC_WINDOWS = {
    "2024-06-15": ("2024-06-14T16", "2024-06-15T16"),  # Sat
    "2024-09-14": ("2024-09-13T16", "2024-09-14T16"),  # Sat
    "2024-10-12": ("2024-10-11T16", "2024-10-12T16"),  # Sat
    "2025-01-26": ("2025-01-25T16", "2025-01-26T16"),  # Sun
    "2025-02-08": ("2025-02-07T16", "2025-02-08T16"),  # Sat
    "2025-05-05": ("2025-05-04T16", "2025-05-05T16"),  # Mon
}


def hours(start, end):
    """Yield YYYY-MM-DD-HH strings from start (inclusive) to end (exclusive)."""
    import datetime as dt
    s = dt.datetime.fromisoformat(start)
    e = dt.datetime.fromisoformat(end)
    cur = s
    while cur < e:
        yield cur.strftime("%Y-%m-%d-%H")
        cur += dt.timedelta(hours=1)


def get(url, path):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    if os.path.exists(path) and os.path.getsize(path) > 0:
        print(f"skip  {path}  ({os.path.getsize(path)/1e6:.0f} MB)")
        return
    print(f"get   {url}")
    try:
        with urllib.request.urlopen(url, timeout=300) as r:
            b = r.read()
    except Exception as ex:
        print(f"FAIL  {url}  {ex}", file=sys.stderr)
        return
    with gzip.open(path, "wb") as f:
        f.write(b)
    print(f"saved {path}  ({os.path.getsize(path)/1e6:.0f} MB)")


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--dry-run", action="store_true")
    args = ap.parse_args()
    total = 0
    for day, (a, b) in MAKEUP_UTC_WINDOWS.items():
        for h in hours(a, b):
            url = f"{BASE}/{h}.json.gz"
            path = os.path.join(OUT, f"{h}.json.gz")
            total += 1
            if args.dry_run:
                print(url)
            else:
                get(url, path)
    print(f"windows: {len(MAKEUP_UTC_WINDOWS)} make-up days, {total} hourly files")


if __name__ == "main__":
    main()
