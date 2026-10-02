"""Step 0: download the two small public inputs at pinned commits.
- Mainland-China holiday / make-up-workday calendar: NateScarlet/holiday-cn (MIT), built from
  State Council General Office notices.
- GitHub Innovation Graph (CC0-1.0): economy-level developer counts, used only as context.
"""
import os, urllib.request, hashlib
from ch import ROOT

HOLIDAY_CN = "159faa58969f6a89ecc671dc04001837c4dca13e"
INNOVATION_GRAPH = "078fb62ee4395d321bec9f4f06694cca68f6b6cb"


def get(url, path):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with urllib.request.urlopen(url, timeout=60) as r:
        b = r.read()
    open(path, "wb").write(b)
    print(f"{hashlib.sha256(b).hexdigest()[:16]}  {path}  <- {url}")


def main():
    for y in (2023, 2024, 2025, 2026):
        get(f"https://raw.githubusercontent.com/NateScarlet/holiday-cn/{HOLIDAY_CN}/{y}.json",
            os.path.join(ROOT, "data", "calendar", f"holiday-cn-{y}.json"))
    get(f"https://raw.githubusercontent.com/github/innovationgraph/{INNOVATION_GRAPH}/data/developers.csv",
        os.path.join(ROOT, "data", "external", "ig_developers.csv"))


if __name__ == "__main__":
    main()
