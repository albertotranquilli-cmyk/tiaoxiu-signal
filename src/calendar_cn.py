"""Calendar inputs.

Mainland-China public holidays and make-up workdays (调休 / 补班) come from the State Council
notices as packaged by https://github.com/NateScarlet/holiday-cn (raw JSON per year, vendored
under data/calendar/). A *make-up workday* is a Saturday or Sunday that is an official working
day in mainland China only.
"""
import json, os, datetime as dt
from ch import ROOT

CAL = os.path.join(ROOT, "data", "calendar")


def load_cn():
    off, work, name = set(), set(), {}
    for y in (2023, 2024, 2025, 2026):
        for x in json.load(open(os.path.join(CAL, f"holiday-cn-{y}.json")))["days"]:
            d = dt.date.fromisoformat(x["date"])
            (off if x["isOffDay"] else work).add(d)
            name[d] = x["name"]
    return off, work, name


# Non-Chinese holidays with large GitHub-wide effects; excluded from *reference* windows
# (never used as events). Western Christmas/New Year, Easter, May 1, US holidays, Diwali, Eid al-Fitr.
def _r(a, b):
    a, b = dt.date.fromisoformat(a), dt.date.fromisoformat(b)
    return {a + dt.timedelta(days=i) for i in range((b - a).days + 1)}

GLOBAL_HOLIDAYS = set().union(
    _r("2022-12-23", "2023-01-03"), _r("2023-12-22", "2024-01-02"), _r("2025-12-22", "2026-01-02"),
    {dt.date(2023, 4, 7), dt.date(2023, 4, 10), dt.date(2024, 3, 29), dt.date(2024, 4, 1),
     dt.date(2026, 4, 3), dt.date(2026, 4, 6)},                                   # Good Friday / Easter Monday
    {dt.date(2023, 5, 1), dt.date(2024, 5, 1), dt.date(2026, 5, 1)},             # May Day (many countries)
    {dt.date(2023, 5, 29), dt.date(2024, 5, 27), dt.date(2026, 5, 25),           # US Memorial Day
     dt.date(2023, 7, 4), dt.date(2023, 9, 4), dt.date(2023, 11, 23), dt.date(2023, 11, 24),
     dt.date(2025, 11, 27), dt.date(2025, 11, 28), dt.date(2024, 1, 15), dt.date(2026, 1, 19)},
    {dt.date(2023, 11, 12), dt.date(2023, 11, 13), dt.date(2025, 10, 20), dt.date(2025, 10, 21)},  # Diwali
    {dt.date(2023, 4, 21), dt.date(2024, 4, 10), dt.date(2026, 3, 20)},          # Eid al-Fitr
    {dt.date(2023, 2, 20), dt.date(2024, 2, 19), dt.date(2026, 2, 16)},          # US Presidents' Day
    {dt.date(2023, 2, 20), dt.date(2023, 2, 21), dt.date(2024, 2, 12), dt.date(2024, 2, 13),
     dt.date(2026, 2, 16), dt.date(2026, 2, 17)},                                # Carnival (Brazil etc.)
)
