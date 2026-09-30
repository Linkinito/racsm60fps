#!/usr/bin/env python3
"""Measure per-real-second particle position advance (droplet slope) in situ.

Reads the waterfall pool region once per sample (single block read), then
extracts candidate slots (stride 0x10, covers the 0x50 and 0x40 record rings)
and keeps only slots whose median |d pos|/dt is droplet-like (5..500 units/s),
which rejects record-interior offsets (vel/rot fields move ~1 unit/s).

Objective A/B/C check for the water correction:
  A0 vanilla : C1 vanilla : C1 + waterfall-004  =  1 : 2 : 1.

Usage: measure-droplet-slope.py [--seconds 2.0] [--samples 8] [--json-out p]
"""
import argparse, base64, importlib.util, json, statistics, struct, time
from pathlib import Path

REPO = Path(__file__).resolve().parents[2]
CLIENT = REPO / "research/live-tests/pokitaru/waterfall-001/ppsspp-ws.py"
BASE = 0x09139D00
WINDOW = (0x09D9C000, 0x09DA8000)  # waterfall pool heap region (rings 0x50/0x40)
STRIDE = 0x10
SPEED_MIN, SPEED_MAX = 5.0, 500.0

spec = importlib.util.spec_from_file_location("ppsspp_ws", CLIENT)
ws = importlib.util.module_from_spec(spec); spec.loader.exec_module(ws)


def read_bytes(c, address, size):
    return base64.b64decode(c.request("memory.read",
        {"address": address, "size": size, "replacements": False}).get("base64", ""))


def f32(b, off):
    return struct.unpack("<f", b[off:off + 4])[0]


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--seconds", type=float, default=2.0)
    ap.add_argument("--samples", type=int, default=8)
    ap.add_argument("--json-out", default=None)
    args = ap.parse_args()
    c = ws.DebuggerClient("127.0.0.1", 60907); c.connect()
    rec = {"tool": "measure-droplet-slope.py",
           "utc": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime())}
    try:
        ident = ws.identity(c)
        rec["state"] = ident["state"]
        if ident["module"]["baseDecimal"] != BASE:
            raise RuntimeError("wrong module base")
        lo, hi = WINDOW
        size = hi - lo
        gap = args.seconds / max(1, args.samples - 1)
        samples = []
        for _ in range(args.samples):
            t0 = time.monotonic()
            samples.append((t0, read_bytes(c, lo, size)))
            time.sleep(max(0.0, gap - (time.monotonic() - t0)))
        per_slot = {}
        all_med = []
        for off in range(0, size - 0x50, STRIDE):
            speeds = []
            for (t0, b0), (t1, b1) in zip(samples, samples[1:]):
                dt = t1 - t0
                if dt <= 0 or len(b0) < off + 12 or len(b1) < off + 12:
                    continue
                d = sum((f32(b1, off + 4 * i) - f32(b0, off + 4 * i)) ** 2
                        for i in range(3)) ** 0.5
                if 0.001 < d < 200.0:
                    speeds.append(d / dt)
            if len(speeds) >= max(2, args.samples - 5):
                med = statistics.median(speeds)
                all_med.append(med)
                if SPEED_MIN <= med <= SPEED_MAX \
                        and len(speeds) >= max(4, args.samples - 3):
                    per_slot["0x%08X" % (lo + off)] = round(med, 2)
        rec["diag"] = {"offsetsWithIntervals": len(all_med),
                       "bestMedian": round(max(all_med), 2) if all_med else None}
        rec["slotCount"] = len(per_slot)
        rec["perSlot"] = per_slot
        rec["mean"] = round(statistics.mean(per_slot.values()), 2) if per_slot else None
        rec["result"] = "PASS"
    finally:
        c.close()
        if args.json_out:
            p = Path(args.json_out)
            if not p.is_absolute():
                p = REPO / p
            p.write_text(json.dumps(rec, indent=1), encoding="utf-8")
        print(json.dumps({k: rec.get(k) for k in
                          ("result", "state", "slotCount", "mean", "diag")}, sort_keys=True))


if __name__ == "__main__":
    main()
