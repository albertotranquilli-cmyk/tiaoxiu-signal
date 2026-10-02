"""Step 4b: the only per-entity table that is committed: organisations with >= 10 eligible repos
(large institutions/companies), plus two openly China-headquartered large companies used as
known-positive validation cases. Per-repo estimates stay local (results/ is regenerated)."""
import os
import pandas as pd
from analyze import RES

VALIDATION_ALLOWLIST = {"PaddlePaddle", "alibaba"}  # Baidu's and Alibaba's GitHub orgs
EXCLUDE = {"mate-academy"}  # coding-school org: course-scheduled activity, not a workforce; kept out of the public table


def main():
    keep = set()
    for era in ("E1", "E2"):
        o = pd.read_csv(os.path.join(RES, f"orgs_{era}.csv"))
        if era == "E1":
            keep = set(o.org[((o.repos >= 10) | o.org.isin(VALIDATION_ALLOWLIST)) & ~o.org.isin(EXCLUDE)])
        pub = o[o.org.isin(keep)]  # E2: same organisations as E1 (replication), whatever their E2 repo count
        pub.to_csv(os.path.join(RES, f"orgs_{era}_public.csv"), index=False, float_format="%.4g")
        print(era); print(pub.to_string(index=False))


if __name__ == "__main__":
    main()
