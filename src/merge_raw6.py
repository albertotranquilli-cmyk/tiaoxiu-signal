# merge_raw6.py — merge the 6 raw-GH-Archive make-up days into the E1 playground panel.
#
# Reads:  data/derived/daily_E1.csv.gz      (playground, from extract.py)
#         data/derived/daily_E1_raw6.csv  (raw files, from extract_raw.py)
# Writes: data/derived/daily_E1_merged.csv.gz
#
# On overlapping (repo, day) the raw6 value wins (raw files are the ground truth;
the playground is a copy that can lag). New days are appended. Then re-run
# analyze.py / robustness.py / extra_checks.py / summarize.py against the merged
# panel by pointing them at daily_E1_merged.csv.gz (or swap the filename).
# No keys. MIT.
import csv, gzip, os

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
DERIVED = os.path.join(ROOT, "data", "derived")


def load_gz(path):
    rows = []
    with gzip.open(path, "rt", newline="") as f:
        rows = list(csv.DictReader(f))
    return rows


def main():
    base_path = os.path.join(DERIVED, "daily_E1.csv.gz")
    raw_path = os.path.join(DERIVED, "daily_E1_raw6.csv")
    if not os.path.exists(base_path):
        print(f"missing {base_path} — run extract.py first")
        return
    if not os.path.exists(raw_path):
        print(f"missing {raw_path} — run extract_raw.py first")
        return
    base = {(r["repo_name"], r["d"]): r for r in load_gz(base_path)}
    raw = {(r["repo_name"], r["d"]): r for r in load_gz(raw_path) if False}
    # daily_E1_raw6.csv is plain csv, not gz
    with open(raw_path) as f:
        for r in csv.DictReader(f):
            raw[(r["repo_name"], r["d"])] = r
    # raw wins on overlap
    merged = dict(base)
    merged.update(raw)
    out_path = os.path.join(DERIVED, "daily_E1_merged.csv.gz")
    with gzip.open(out_path, "wt", newline="") as f:
        w = csv.DictWriter(f, fieldnames=["repo_name", "d", "actors", "events"])
        w.writeheader()
        for (repo, d), r in sorted(merged.items()):
            w.writerow({"repo_name": repo, "d": d, "actors": r["actors"], "events": r["events"]})
    n_new = len(set(raw) - set(base))
    n_overlap = len(set(raw) & set(base))
    print(f"wrote {out_path}")
    print(f"base rows: {len(base)}, raw6 rows: {len(raw)}, merged: {len(merged)}")
    print(f"new (repo,day) pairs: {n_new}, overlaps replaced by raw: {n_overlap}")


if __name__ == "__main__":
    main()
