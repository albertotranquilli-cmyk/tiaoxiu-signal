"""Step 5: figures."""
import os
import numpy as np, pandas as pd
import matplotlib; matplotlib.use("Agg")
import matplotlib.pyplot as plt
from core import panel, load_repos, event_terms, share, MAKEUP, ROOT, dt, OFF
from analyze import FIG, RES


def main():
    import json
    R = json.load(open(os.path.join(RES, "results.json")))["E1"]["groups"]
    C = json.load(open(os.path.join(RES, "robustness.json")))["same_timezone_controls"]
    rows = [("<1% Chinese titles", R["zh<1%"]), (">=1% Chinese titles", R["zh>=1%"]),
            ("control panel: mostly\nSimplified Chinese", C["Chinese, Simplified-dominant >=30%"]),
            ("control panel: mostly\nJapanese (UTC+9)", C["Japanese (kana) >=30%"]),
            ("control panel: mostly\nKorean (UTC+9)", C["Korean (Hangul) >=30%"])]
    fig, ax = plt.subplots(figsize=(9, 4.2))
    x = np.arange(len(rows))
    ci = [g.get("ci95_two_way", g["ci95"]) for _, g in rows]  # two-way (repos x days) where available
    v = [g["s"] for _, g in rows]; lo = [g["s"] - c[0] for (_, g), c in zip(rows, ci)]; hi = [c[1] - g["s"] for (_, g), c in zip(rows, ci)]
    pl = [g["placebo_mean"] for _, g in rows]; pls = [2 * g["placebo_sd"] for _, g in rows]
    ax.bar(x - 0.18, v, 0.36, yerr=[lo, hi], color="tab:red", capsize=3, label="real make-up workdays (Sat/Sun)")
    ax.bar(x + 0.18, pl, 0.36, yerr=pls, color="lightgrey", capsize=3, label="placebo: ordinary matched weekends (mean, +-2 sd)")
    for xi, (_, g) in zip(x, rows):
        ax.text(xi - 0.18, max(g["s"], 0) + 0.04, f"n={g['repos']}", ha="center", fontsize=7)
    ax.set_xticks(x); ax.set_xticklabels([a for a, _ in rows], fontsize=8)
    ax.axhline(0, color="k", lw=.6); ax.axhline(1, color="grey", lw=.6, ls=":")
    ax.set_ylabel("calendar-swap share s\n0 = behaves like a weekend, 1 = like a weekday")
    ax.set_title("GitHub repos on the one weekend day that only mainland China works (12 days, 2023-01..2024-05)", fontsize=9)
    ax.legend(fontsize=8, loc="upper right"); ax.set_ylim(-0.3, 1.15)
    fig.text(0.01, 0.01, "95% CIs: two-way bootstrap (repos x days) for the first two groups; repos only for control panels. "
             "Korean control dominated by bootcamp repos (inconclusive).", fontsize=6.5, color="dimgrey")
    fig.tight_layout(rect=(0, 0.03, 1, 1))
    fig.savefig(os.path.join(FIG, "makeup_days_E1.png"), dpi=130)
    # org chart
    o = pd.read_csv(os.path.join(RES, "orgs_E1_public.csv")).sort_values("s")
    fig, ax = plt.subplots(figsize=(7.5, 0.28 * len(o) + 1))
    ax.errorbar(o.s, range(len(o)), xerr=[o.s - o.ci95_lo, o.ci95_hi - o.s], fmt="o", ms=4, color="k", ecolor="grey")
    ax.set_yticks(range(len(o))); ax.set_yticklabels([f"{a} ({n})" for a, n in zip(o.org, o.repos)], fontsize=8)
    ax.axvline(0, color="grey", lw=.6)
    ax.set_xlabel("calendar-swap share s (95% CI, two-way bootstrap over repos and make-up days)")
    ax.set_title("Share of the weekday-weekend activity gap that follows the mainland-China calendar,\nby GitHub org, 2023-01..2024-05 (calendar adherence, not a contributor share)", fontsize=8.5)
    fig.tight_layout(); fig.savefig(os.path.join(FIG, "orgs_E1.png"), dpi=130)


if __name__ == "__main__":
    main()
