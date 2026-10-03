#!/usr/bin/env python3
"""Analyse a sample-regions.py recording: state durations, field steps, refills (offline).

Replaces the ad-hoc Otto analyses of 2026-10-03 with one reproducible tool.
Fields are decoded from the change-encoded samples; the recording is cut at
the first savestate reload (frame counter going backwards) unless --no-cut.

Outputs (stdout and optional JSON):
  - frames per emulated second;
  - per state value: segment count, most common frame lengths, mean emulated s
    (complete segments only: first and last segments are excluded);
  - per numeric field: decrease step histogram (per sample), total decrease;
  - refill events for --refill fields (0 -> >0): frames and emulated seconds
    since the field reached 0.

Usage:
  python tools/runtime/analyze-samples.py --samples <dir>/samples.json --region pvar \
      --field st=0x18:u32 --field hp=0x24:f32 --field shield=0x30:f32 --state st \
      --refill shield --json <out.json>
"""
import argparse
import json
import struct
import sys
from collections import Counter, defaultdict
from pathlib import Path

TICK_HZ = 222_000_000


def parse_field(text):
    name, rest = text.split("=", 1)
    off, kind = rest.split(":")
    if kind not in ("u32", "s32", "f32"):
        raise SystemExit("field kind must be u32, s32 or f32")
    return name, int(off, 0), kind


def conv(word, kind):
    if kind == "f32":
        return struct.unpack("<f", struct.pack("<I", word))[0]
    if kind == "s32":
        return word - (1 << 32) if word & 0x80000000 else word
    return word


def rows_from(rec, region, fields):
    init = rec["initial"][region]
    cur = {name: int(init[off // 4], 16) for name, off, _ in fields}
    rows = []
    for s in rec["samples"]:
        chg = s["chg"].get(region, {})
        for name, off, _ in fields:
            h = chg.get("%X" % off)
            if h:
                cur[name] = int(h, 16)
        row = {"t": s["t"], "frame": s["frame"], "tick": s["tick"]}
        for name, _, kind in fields:
            row[name] = conv(cur[name], kind)
        rows.append(row)
    return rows


def cut_at_reload(rows):
    for i in range(1, len(rows)):
        if rows[i]["frame"] is not None and rows[i - 1]["frame"] is not None and rows[i]["frame"] < rows[i - 1]["frame"]:
            return rows[:i], i
    return rows, None


def analyse(rows, state, numeric, refills):
    out = {}
    if len(rows) >= 2 and rows[-1]["tick"] > rows[0]["tick"]:
        out["framesPerEmuSecond"] = round((rows[-1]["frame"] - rows[0]["frame"])
                                          / ((rows[-1]["tick"] - rows[0]["tick"]) / TICK_HZ), 3)
    if state:
        seg, start = defaultdict(list), None
        for a, b in zip(rows, rows[1:]):
            if b[state] != a[state]:
                if start is not None:
                    seg[a[state]].append((b["frame"] - start["frame"], (b["tick"] - start["tick"]) / TICK_HZ))
                start = b
        out["states"] = {str(k): {"segments": len(v), "frames": Counter(x[0] for x in v).most_common(3),
                                  "meanEmuS": round(sum(x[1] for x in v) / len(v), 3)}
                         for k, v in sorted(seg.items(), key=lambda kv: str(kv[0]))}
        out["sequence"] = []
        prev = None
        for r in rows:
            if r[state] != prev:
                out["sequence"].append({"t": r["t"], "frame": r["frame"], state: r[state],
                                        **{f: round(r[f], 3) for f in numeric}})
                prev = r[state]
    for f in numeric:
        steps = Counter(round(a[f] - b[f], 3) for a, b in zip(rows, rows[1:]) if b[f] < a[f])
        out.setdefault("fields", {})[f] = {"first": round(rows[0][f], 3), "last": round(rows[-1][f], 3),
                                           "totalDecrease": round(sum(k * v for k, v in steps.items()), 3),
                                           "decreaseSteps": steps.most_common(8)}
    for f in refills:
        ev, zero = [], None
        for a, b in zip(rows, rows[1:]):
            if a[f] > 0 and b[f] == 0:
                zero = b
            if a[f] == 0 and b[f] > 0 and zero is not None:
                ev.append({"t": b["t"], "frames": b["frame"] - zero["frame"],
                           "emuS": round((b["tick"] - zero["tick"]) / TICK_HZ, 3), "value": round(b[f], 3)})
                zero = None
        out.setdefault("refills", {})[f] = ev
    return out


def main():
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument("--samples", required=True, type=Path)
    ap.add_argument("--region", required=True)
    ap.add_argument("--field", action="append", required=True)
    ap.add_argument("--state")
    ap.add_argument("--refill", action="append", default=[])
    ap.add_argument("--no-cut", action="store_true")
    ap.add_argument("--json", type=Path)
    a = ap.parse_args()
    fields = [parse_field(f) for f in a.field]
    names = {n for n, _, _ in fields}
    for x in [a.state, *a.refill]:
        if x and x not in names:
            raise SystemExit("unknown field %s" % x)
    rec = json.loads(a.samples.read_text(encoding="utf-8"))
    rows = rows_from(rec, a.region, fields)
    cut = None
    if not a.no_cut:
        rows, cut = cut_at_reload(rows)
    numeric = [n for n, _, _ in fields if n != a.state]
    res = {"samples": str(a.samples), "label": rec.get("label"), "rows": len(rows), "cutAtSample": cut,
           **analyse(rows, a.state, numeric, a.refill)}
    if a.json:
        a.json.write_text(json.dumps(res, indent=1, default=str), encoding="utf-8")
    json.dump({k: v for k, v in res.items() if k != "sequence"}, sys.stdout, indent=1, default=str)
    print()


if __name__ == "__main__":
    main()
