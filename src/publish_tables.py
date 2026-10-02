"""Step 4b: the only per-entity table (E1) that is committed: organisations with >= 10 eligible repos
(large institutions/companies), plus two openly China-headquartered large companies used as
known-positive validation cases. Per-repo estimates stay local (results/ is regenerated)."""
import os
import pandas as pd
from analyze import RES

VALIDATION_ALLOWLIST = {"PaddlePaddle", "alibaba"}  # Baidu's and Alibaba's GitHub orgs
EXCLUDE = {"mate-academy"}  # coding-school org: course-scheduled activity, not a workforce; kept out of the public table


def main():
    # E1 only. E2 (2025-26) organisation magnitudes are not published: GH Archive capture is degraded
    # and there are only 4 make-up days (see README "Honest limits").
    o = pd.read_csv(os.path.join(RES, "orgs_E1.csv"))
    pub = o[((o.repos >= 10) | o.org.isin(VALIDATION_ALLOWLIST)) & ~o.org.isin(EXCLUDE)]
    pub = pub.drop(columns=["repos_s_gt_0.5_and_q_lt_0.05", "top10_share_of_numerator"])
    pub.to_csv(os.path.join(RES, "orgs_E1_public.csv"), index=False, float_format="%.4g")
    stale = os.path.join(RES, "orgs_E2_public.csv")
    if os.path.exists(stale):
        os.remove(stale)
    print(pub.to_string(index=False))

if __name__ == "__main__":
    main()
