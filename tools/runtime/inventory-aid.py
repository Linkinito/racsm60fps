#!/usr/bin/env python3
"""TEST AID (owner-requested 2026-10-03): read or reset weapon progression in the save inventory.

Two copies of each weapon record exist (OBSERVED live, 2026-10-03):
  save root 0x088C13C0 (mcp global) + 0x60C + (id-2)*0x18:
      +0 rank, +4 ammo, +8 XP, +0x0C..+0x0E owned mod bytes, +0x0F..+0x11 mod
      availability bytes, +0x14 owned flag; restored into the level copy at level load
      (static: restore 0x226F4, research/v2/weapons-armor-inventory-20261003/REPORT.md).
  level weapon table (map anchor weaponTable) + id*0x58 (owner variant -1):
      +0x3C rank, +0x40 ammo, +0x44 XP, +0x4C..+0x4E owned mods, +0x4F..+0x51 availability.

  (no action)        decode and print both copies for ids 2..15.
  --reset-v1 IDS     for each id (comma list or 'all'): rank 0, XP 0, owned mods 0 in BOTH
                     copies; ammo capped at the static rank-0 maximum. Availability bytes and
                     the owned flag are kept. Refuses when the two copies disagree on rank/mods.
  --max-all          every weapon at its highest declared rank (ids 2..13: 7 = V8 "Titan",
                     Ryno 3, MiniTurret 0), XP 0, every declared mod slot owned and
                     available, ammo at that rank's maximum, in BOTH copies.
Reload the level afterwards so models/parameters follow. Writes go to the save
area: saving the game in PPSSPP makes them permanent.

Usage: python tools/runtime/inventory-aid.py --map <levelmap.json> [--reset-v1 all] --out <new dir>
"""
import argparse
import base64
import importlib.util
import json
import time
from pathlib import Path

REPO = Path(__file__).resolve().parents[2]
spec = importlib.util.spec_from_file_location("pump_gate", REPO / "tools/runtime/pump-gate.py")
pg = importlib.util.module_from_spec(spec)
spec.loader.exec_module(pg)

SAVE_ROOT = 0x088C13C0
SAVE_WEAPONS = SAVE_ROOT + 0x60C
NAMES = {2: "Blaster/Lacerator", 3: "BlitzGun/Tremblator", 4: "BombGlove", 5: "AgentsGlove", 6: "BeeMineGlove",
         7: "ShieldCharger", 8: "ShockRocket", 9: "CrossbowGun", 10: "Flamethrower", 11: "LaserTracer",
         12: "SuckCannon", 13: "Mootator", 14: "MiniTurretGlove", 15: "Ryno/TELT"}
# Static rank-0 max ammo (inventory report, table 1); None = leave ammo unchanged.
# Static per-rank max ammo, declared max rank and declared mod-slot count (inventory report, table 1).
MAX_AMMO = {2: [60, 70, 80, 120, 120, 120, 120, 120], 3: [25, 25, 30, 30, 25, 25, 25, 25],
            4: [5, 7, 9, 10, 8, 8, 8, 8], 5: [6, 8, 10, 10, 10, 10, 10, 10], 6: [8, 8, 8, 8, 8, 8, 10, 12],
            7: [5] * 8, 8: [20, 20, 22, 22, 18, 20, 22, 24], 9: [8, 8, 10, 10, 8, 8, 8, 8],
            10: [60, 90, 90, 90, 90, 90, 90, 90], 11: [200, 200, 300, 300, 300, 300, 300, 300],
            12: [8, 10, 12, 16, 10, 12, 14, 16], 13: [0] * 8, 14: [30], 15: [30, 30, 40, 50]}
MOD_SLOTS = {2: 2, 3: 3, 4: 2, 5: 2, 6: 2, 7: 2, 8: 3, 9: 2, 10: 2, 11: 2, 12: 1, 13: 0, 14: 0, 15: 0}
MAX_AMMO_V1 = {2: 60, 3: 25, 4: 5, 5: 6, 6: 8, 7: 5, 8: 20, 9: 8, 10: 60, 11: 200, 12: 8, 13: None, 14: 30, 15: 30}


def main():
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument("--map", required=True, type=Path)
    ap.add_argument("--reset-v1")
    ap.add_argument("--max-all", action="store_true")
    ap.add_argument("--out", required=True, type=Path)
    ap.add_argument("--port", type=int, default=60907)
    a = ap.parse_args()
    a.out.mkdir(parents=True, exist_ok=False)
    m = json.loads(a.map.read_text(encoding="utf-8"))
    rec = {"utc": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()), "action": "TEST AID inventory",
           "map": str(a.map), "writes": []}
    c = pg.Client("127.0.0.1", a.port)
    c.connect()
    try:
        mods = [x for x in c.request("hle.module.list")["modules"] if x.get("isActive") and x["name"] == "rcp1"]
        if len(mods) != 1 or "0x%08X" % mods[0]["address"] != m["module"]["base"]:
            raise SystemExit("module differs from map: rebuild the map")
        base = mods[0]["address"]
        wt = base + int(m["anchors"]["weaponTable"]["rva"], 16)

        def rbytes(addr, n):
            r = c.request("memory.read", {"address": addr, "size": n, "replacements": False})
            return list(base64.b64decode(r["base64"]))

        def decode():
            out = {}
            for wid in NAMES:
                s = SAVE_WEAPONS + (wid - 2) * 0x18
                sw = c.read(s, 3)
                sb = rbytes(s + 0x0C, 6)
                lr = wt + wid * 0x58
                lw = c.read(lr + 0x3C, 3)
                lb = rbytes(lr + 0x4C, 6)
                out[wid] = {"name": NAMES[wid], "save": {"addr": "0x%08X" % s, "rank": sw[0], "ammo": sw[1], "xp": sw[2],
                                                         "modsOwned": sb[:3], "modsAvail": sb[3:],
                                                         "owned": c.read(s + 0x14, 1)[0]},
                            "live": {"addr": "0x%08X" % lr, "rank": lw[0], "ammo": lw[1], "xp": lw[2],
                                     "modsOwned": lb[:3], "modsAvail": lb[3:]}}
            return out

        before = decode()
        rec["before"] = before
        if a.reset_v1:
            ids = list(NAMES) if a.reset_v1 == "all" else [int(x) for x in a.reset_v1.split(",")]
            for wid in ids:
                e = before[wid]
                if e["save"]["rank"] != e["live"]["rank"] or e["save"]["modsOwned"] != e["live"]["modsOwned"]:
                    raise SystemExit("id %d: save and live copies disagree, refusing: %s" % (wid, e))
                if e["live"]["rank"] > 7:
                    raise SystemExit("id %d: implausible rank" % wid)
            for wid in ids:
                e = before[wid]
                cap = MAX_AMMO_V1[wid]
                # (copy, rank address, offset of the owned-mod bytes from the rank field)
                for side, rank_a, mods_off in (("save", SAVE_WEAPONS + (wid - 2) * 0x18, 0x0C),
                                               ("live", wt + wid * 0x58 + 0x3C, 0x10)):
                    ammo_a, xp_a, mods_a = rank_a + 4, rank_a + 8, rank_a + mods_off
                    old = c.read(rank_a, 3)
                    c.write(rank_a, 0)
                    c.write(xp_a, 0)
                    if cap is not None and old[1] > cap:
                        c.write(ammo_a, cap)
                    # owned mod bytes are the first 3 bytes of an aligned word; keep the 4th (availability)
                    w = c.read(mods_a, 1)[0]
                    c.write(mods_a, w & 0xFF000000)
                    rec["writes"].append({"id": wid, "copy": side, "rankAddr": "0x%08X" % rank_a,
                                          "before": {"rank": old[0], "ammo": old[1], "xp": old[2], "modsWord": "0x%08X" % w},
                                          "ammoCap": cap})
            rec["after"] = decode()
        if a.max_all:
            if a.reset_v1:
                raise SystemExit("choose --reset-v1 or --max-all")
            for wid in NAMES:
                e = before[wid]
                if e["save"]["rank"] != e["live"]["rank"] or e["save"]["modsOwned"] != e["live"]["modsOwned"]:
                    raise SystemExit("id %d: save and live copies disagree, refusing: %s" % (wid, e))
            for wid in NAMES:
                rank = len(MAX_AMMO[wid]) - 1
                ammo = MAX_AMMO[wid][rank]
                n = MOD_SLOTS[wid]
                owned = sum(1 << (8 * k) for k in range(n))           # bytes 0..n-1 of the owned triple
                for side, rank_a, mods_off in (("save", SAVE_WEAPONS + (wid - 2) * 0x18, 0x0C),
                                               ("live", wt + wid * 0x58 + 0x3C, 0x10)):
                    mods_a = rank_a + mods_off
                    old = c.read(rank_a, 3)
                    w0, w1 = c.read(mods_a, 2)
                    c.write(rank_a, rank)
                    c.write(rank_a + 8, 0)
                    c.write(rank_a + 4, ammo)
                    # bytes: [o0 o1 o2 a0] [a1 a2 x x]; owned slots 0..n-1 and availability slots 0..n-1
                    nw0 = (w0 & ~0x00FFFFFF & 0xFFFFFFFF) | owned
                    if n >= 1:
                        nw0 |= 0x01000000
                    nw1 = w1
                    if n >= 2:
                        nw1 |= 0x01
                    if n >= 3:
                        nw1 |= 0x0100
                    c.write(mods_a, nw0)
                    c.write(mods_a + 4, nw1)
                    rec["writes"].append({"id": wid, "copy": side, "rank": rank, "ammo": ammo, "modSlots": n,
                                          "before": {"rank": old[0], "ammo": old[1], "xp": old[2],
                                                     "modsWords": ["0x%08X" % w0, "0x%08X" % w1]}})
            rec["after"] = decode()
    finally:
        c.close()
    (a.out / "inventory-aid.json").write_text(json.dumps(rec, indent=1), encoding="utf-8")
    for wid, e in (rec.get("after") or rec["before"]).items():
        print("%2d %-20s save r%d a%-4d xp%-6d mods%s | live r%d a%-4d xp%-6d mods%s" % (
            wid, e["name"], e["save"]["rank"], e["save"]["ammo"], e["save"]["xp"], e["save"]["modsOwned"],
            e["live"]["rank"], e["live"]["ammo"], e["live"]["xp"], e["live"]["modsOwned"]))


if __name__ == "__main__":
    main()
