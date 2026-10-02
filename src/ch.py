"""Tiny client for the public ClickHouse playground (https://play.clickhouse.com, user=play).

All raw query results are cached under data/raw/ keyed by a hash of the SQL text, so
re-running the pipeline is cheap and every number can be traced back to an exact query.
"""
import hashlib, os, time, urllib.request, io, csv

URL = "https://play.clickhouse.com/?user=play"
ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
CACHE = os.path.join(ROOT, "data", "raw")
SQL_LOG = os.path.join(ROOT, "data", "queries.sql")


def query(sql, fmt="TSVWithNames", retries=4, use_cache=True):
    sql = sql.strip() + f"\nFORMAT {fmt}"
    h = hashlib.sha1(sql.encode()).hexdigest()[:16]
    path = os.path.join(CACHE, h + ".tsv")
    os.makedirs(CACHE, exist_ok=True)
    if use_cache and os.path.exists(path):
        return open(path, encoding="utf-8").read()
    for i in range(retries):
        try:
            req = urllib.request.Request(URL, data=sql.encode(), method="POST")
            with urllib.request.urlopen(req, timeout=120) as r:
                txt = r.read().decode("utf-8")
            if txt.startswith("Code:") or "DB::Exception" in txt[:500]:
                raise RuntimeError(txt[:500])
            open(path, "w", encoding="utf-8").write(txt)
            with open(SQL_LOG, "a", encoding="utf-8") as f:
                f.write(f"-- {h} {time.strftime('%Y-%m-%dT%H:%M:%S%z')}\n{sql}\n\n")
            return txt
        except Exception as e:  # noqa
            print(f"  query failed ({i+1}/{retries}): {str(e)[:200]}")
            time.sleep(5 * (i + 1))
    raise RuntimeError("query failed permanently")


def rows(sql):
    txt = query(sql)
    rd = csv.reader(io.StringIO(txt), delimiter="\t", quoting=csv.QUOTE_NONE)
    hdr = next(rd)
    return [dict(zip(hdr, r)) for r in rd]
