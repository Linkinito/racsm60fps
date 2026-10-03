#!/usr/bin/env python3
"""Sample memory regions at a fixed wall interval and record word changes (read-only).

No breakpoints: the game runs at normal speed, so timers (e.g. a boss shield
regeneration delay) can be measured. Each sample stores the emulated CPU tick,
the level frame counter (from a level map anchor, or --frame-addr) and only the
32-bit words that changed since the previous sample of that region.

One debugger connection; throttled (research/GOTCHAS.md entries 3 and 4).

Usage:
  python tools/runtime/sample-regions.py --map <levelmap.json> \
      --region pvar=0x09DC1A00:0x800 --region moby=0x09768F70:0x100 \
      --interval 0.1 --seconds 90 --label A0-otto --out <new dir>
"""

import argparse
import base64
import hashlib
import importlib.util
import json
import struct
import time
from pathlib import Path

REPO = Path(__file__).resolve().parents[2]
spec = importlib.util.spec_from_file_location("pump_gate", REPO / "tools/runtime/pump-gate.py")
pg = importlib.util.module_from_spec(spec)
spec.loader.exec_module(pg)


def main():
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument("--region", action="append", required=True, help="NAME=0xADDR:0xSIZE (size multiple of 4)")
    ap.add_argument("--map", type=Path)
    ap.add_argument("--frame-addr", type=lambda v: int(v, 0))
    ap.add_argument("--interval", type=float, default=0.1)
    ap.add_argument("--seconds", type=float, default=60.0)
    ap.add_argument("--label", required=True)
    ap.add_argument("--note", default="")
    ap.add_argument("--out", type=Path, required=True)
    ap.add_argument("--port", type=int, default=60907)
    a = ap.parse_args()
    a.out.mkdir(parents=True, exist_ok=False)
    regions = []
    for r in a.region:
        name, rest = r.split("=", 1)
        addr, size = rest.split(":")
        size = int(size, 0)
        if size % 4 or size > 0x4000:
            raise SystemExit("region size must be a multiple of 4 and <= 0x4000")
        regions.append((name, int(addr, 0), size))
    c = pg.Client("127.0.0.1", a.port)
    c.connect()
    rec = {"utc": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()), "label": a.label, "note": a.note,
           "client": "sample-regions.py", "methodSha256": hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
           "interval": a.interval, "regions": [{"name": n, "address": "0x%08X" % ad, "size": s} for n, ad, s in regions],
           "initial": {}, "samples": []}
    try:
        mods = [m for m in c.request("hle.module.list")["modules"] if m.get("isActive") and m["name"] == "rcp1"]
        base = mods[0]["address"]
        frame_addr = a.frame_addr
        if a.map:
            m = json.loads(a.map.read_text(encoding="utf-8"))
            if "0x%08X" % base != m["module"]["base"]:
                raise SystemExit("module differs from map")
            frame_addr = base + int(m["anchors"]["frameCounter"]["rva"], 16)
        rec["module"] = {"base": "0x%08X" % base, "size": mods[0]["size"]}
        rec["frameAddr"] = "0x%08X" % frame_addr if frame_addr else None
        prev = {}
        t0 = time.perf_counter()
        nxt = 0.0
        while True:
            now = time.perf_counter() - t0
            if now > a.seconds:
                break
            if now < nxt:
                time.sleep(min(0.01, nxt - now))
                continue
            nxt += a.interval
            tick = c.request("cpu.status").get("ticks")
            frame = c.read(frame_addr, 1)[0] if frame_addr else None
            sample = {"t": round(now, 3), "tick": tick, "frame": frame, "chg": {}}
            for name, addr, size in regions:
                r = c.request("memory.read", {"address": addr, "size": size, "replacements": False})
                words = struct.unpack("<%dI" % (size // 4), base64.b64decode(r["base64"]))
                if name not in prev:
                    rec["initial"][name] = ["%08X" % w for w in words]
                else:
                    ch = {"%X" % (4 * i): "%08X" % w for i, (w, p) in enumerate(zip(words, prev[name])) if w != p}
                    if ch:
                        sample["chg"][name] = ch
                prev[name] = words
            rec["samples"].append(sample)
    finally:
        c.close()
    (a.out / "samples.json").write_text(json.dumps(rec), encoding="utf-8")
    print("samples %d over %.1f s" % (len(rec["samples"]), rec["samples"][-1]["t"] if rec["samples"] else 0))


if __name__ == "__main__":
    main()
