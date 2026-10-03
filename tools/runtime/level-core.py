#!/usr/bin/env python3
"""Switch the three core timing words (A0 <-> C1) on any level, from a level map.

Same three writes as tools/runtime/switch-module-state.py (owner authorization
2026-09-21 for these words), but the RVAs come from a level map produced by
`level-sigmap.py find` on the running level instead of fixed LEVEL_01 RVAs.

  wait          jal VBlank wait -> nop        (C1)  ; restored from the map's original word (A0)
  sharedDelta   lui a0,0x3D08 -> lui a0,0x3C88
  loopThreshold slti a0,s1,2  -> slti a0,s1,1

Guards: module base and size must equal the map's; every current word must be
the A0 or C1 value before anything is written; each write is read back;
already-correct words are not written. Read-only `--arm status`.

Usage: python tools/runtime/level-core.py --map <levelmap.json> --arm status|A0|C1 --out <new dir>
"""

import argparse
import importlib.util
import json
import time
from pathlib import Path

REPO = Path(__file__).resolve().parents[2]
spec = importlib.util.spec_from_file_location("pump_gate", REPO / "tools/runtime/pump-gate.py")
pg = importlib.util.module_from_spec(spec)
spec.loader.exec_module(pg)

DELTA_30, DELTA_60 = 0x3C043D08, 0x3C043C88
LOOP_2, LOOP_1 = 0x2A240002, 0x2A240001


def core_words(levelmap):
    sites, words = levelmap["sites"], levelmap["words"]
    wait_orig = int(words["guard.wait"], 16)
    if wait_orig >> 26 != 0x03:
        raise SystemExit("map wait word is not a jal: %s" % words["guard.wait"])
    return {
        "wait": (int(sites["guard.wait"]["rva"], 16), wait_orig, 0x00000000),
        "sharedDelta": (int(sites["guard.sharedDelta"]["rva"], 16), DELTA_30, DELTA_60),
        "loopThreshold": (int(sites["guard.loopThreshold"]["rva"], 16), LOOP_2, LOOP_1),
    }


def classify(cur, table):
    a0 = all(cur[k] == table[k][1] for k in table)
    c1 = all(cur[k] == table[k][2] for k in table)
    return "A0" if a0 else "C1" if c1 else "OTHER"


def main():
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument("--map", required=True, type=Path)
    ap.add_argument("--arm", required=True, choices=("status", "A0", "C1"))
    ap.add_argument("--out", required=True, type=Path)
    ap.add_argument("--port", type=int, default=60907)
    a = ap.parse_args()
    a.out.mkdir(parents=True, exist_ok=False)
    levelmap = json.loads(a.map.read_text(encoding="utf-8"))
    table = core_words(levelmap)
    rec = {"utc": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()), "arm": a.arm, "map": str(a.map),
           "writes": [], "result": None}
    c = pg.Client("127.0.0.1", a.port)
    c.connect()
    try:
        mods = [m for m in c.request("hle.module.list")["modules"] if m.get("isActive") and m["name"] == "rcp1"]
        if len(mods) != 1:
            raise SystemExit("active rcp1 count %d" % len(mods))
        base = mods[0]["address"]
        if "0x%08X" % base != levelmap["module"]["base"] or mods[0]["size"] != levelmap["module"]["size"]:
            raise SystemExit("module differs from map (level changed or reloaded): rebuild the map")
        cur = {k: c.read(base + rva, 1)[0] for k, (rva, _, _) in table.items()}
        rec["before"] = {k: "0x%08X" % v for k, v in cur.items()}
        rec["stateBefore"] = classify(cur, table)
        if rec["stateBefore"] == "OTHER":
            raise SystemExit("unexpected words, refusing: %s" % rec["before"])
        if a.arm != "status":
            col = 1 if a.arm == "A0" else 2
            for k, (rva, *vals) in table.items():
                if cur[k] != vals[col - 1]:
                    c.write(base + rva, vals[col - 1])  # pump-gate Client.write reads back
                    rec["writes"].append({"word": k, "rva": "0x%X" % rva,
                                          "from": "0x%08X" % cur[k], "to": "0x%08X" % vals[col - 1]})
            cur = {k: c.read(base + rva, 1)[0] for k, (rva, _, _) in table.items()}
        rec["stateAfter"] = classify(cur, table)
        f0 = c.read(base + int(levelmap["anchors"]["frameCounter"]["rva"], 16), 1)[0]
        t0 = time.perf_counter(); time.sleep(1.0)
        f1 = c.read(base + int(levelmap["anchors"]["frameCounter"]["rva"], 16), 1)[0]
        rec["framesPerWallSecond"] = round((f1 - f0) / (time.perf_counter() - t0), 2)
        rec["result"] = "OBSERVED" if a.arm == "status" else "APPLIED_NOT_GAMEPLAY_VALIDATED"
    finally:
        c.close()
    (a.out / "level-core.json").write_text(json.dumps(rec, indent=1), encoding="utf-8")
    print(json.dumps({k: rec[k] for k in ("stateBefore", "stateAfter", "writes", "framesPerWallSecond")}))


if __name__ == "__main__":
    main()
