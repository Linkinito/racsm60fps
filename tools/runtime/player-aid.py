#!/usr/bin/env python3
"""TEST AID (owner-requested 2026-10-03): survive boss tests on any level. Not a parity change.

Uses a level map from `level-sigmap.py find` to locate the player and the
weapon table on the running level.

  --invuln        set player+0x97C (post-hit suppression counter) to 0x7FFFFFFF once.
                  The player receiver rejects hits while it is nonzero
                  (research/v2/damage-health-20261003/REPORT.md); it decrements
                  per player substep, so one write lasts far beyond a session.
  --clear-invuln  set player+0x97C back to 0.
  --heal          set HP (+0x964) to max HP (+0x968).
  --ammo N        set the equipped weapon's ammo stock (weapon record +0x40) to N.
  --armor SET     equip an armor set for testing: writes the six equipped-slot bytes
                  (global 0x088C1BF4: [0] body, [1] helmet, [2,3] gloves, [4,5] boots;
                  brand ids 1 Wildfire, 2 Sludge Mk.9, 3 Crystallix, 4 Electroshock,
                  5 Mega-Bomb, 6 Hyperborean, 7 Chameleon) and the detected set id at
                  player+0x5C8 (read by the Wrench variant/powers). Ownership is not
                  changed. The armor menu refreshes visuals on the next equip.
                  Verified live 2026-10-03 (research/live-tests/quodrona/armor-001-20261003/).
  (no action)     read-only status.

Every write is read back; before/after values are recorded in <out>/player-aid.json.
Usage: python tools/runtime/player-aid.py --map <levelmap.json> --invuln --ammo 10000 --out <new dir>
"""

import argparse
import importlib.util
import json
import struct
import time
from pathlib import Path

REPO = Path(__file__).resolve().parents[2]
spec = importlib.util.spec_from_file_location("pump_gate", REPO / "tools/runtime/pump-gate.py")
pg = importlib.util.module_from_spec(spec)
spec.loader.exec_module(pg)

INVULN = 0x7FFFFFFF
ARMOR_SLOTS = 0x088C1BF4  # mcp global (save root 0x088C13C0 + 0x834), six bytes
# set id: (name, helmet, body, gloves, boots); ids/tuples from static inventory
# (research/v2/weapons-armor-inventory-20261003/REPORT.md, table 3), names from the owner-supplied wiki text.
ARMOR_SETS = {
    0: ("none", 0, 0, 0, 0), 1: ("wildfire", 1, 1, 1, 1), 2: ("sludge", 2, 2, 2, 2), 3: ("crystallix", 3, 3, 3, 3),
    4: ("electroshock", 4, 4, 4, 4), 5: ("megabomb", 5, 5, 5, 5), 6: ("hyperborean", 6, 6, 6, 6),
    7: ("chameleon", 7, 7, 7, 7), 8: ("firebomb", 5, 5, 1, 5), 9: ("shockcrystal", 4, 3, 3, 4),
    10: ("wildburst", 2, 1, 1, 1), 11: ("triplewave", 1, 4, 2, 4), 12: ("ice2", 3, 6, 6, 6), 13: ("stalker", 1, 7, 2, 7),
}


def armor_id(text):
    for k, v in ARMOR_SETS.items():
        if text.lower() in (str(k), v[0]):
            return k
    raise SystemExit("unknown armor set %r; choose from %s" % (text, ", ".join(v[0] for v in ARMOR_SETS.values())))


def f32(w):
    return round(struct.unpack("<f", struct.pack("<I", w))[0], 4)


def main():
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument("--map", required=True, type=Path)
    ap.add_argument("--invuln", action="store_true")
    ap.add_argument("--clear-invuln", action="store_true")
    ap.add_argument("--heal", action="store_true")
    ap.add_argument("--ammo", type=int)
    ap.add_argument("--armor")
    ap.add_argument("--out", required=True, type=Path)
    ap.add_argument("--port", type=int, default=60907)
    a = ap.parse_args()
    if a.invuln and a.clear_invuln:
        raise SystemExit("choose --invuln or --clear-invuln")
    a.out.mkdir(parents=True, exist_ok=False)
    m = json.loads(a.map.read_text(encoding="utf-8"))
    rec = {"utc": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()), "action": "TEST AID player",
           "map": str(a.map), "writes": []}
    c = pg.Client("127.0.0.1", a.port)
    c.connect()
    try:
        mods = [x for x in c.request("hle.module.list")["modules"] if x.get("isActive") and x["name"] == "rcp1"]
        if len(mods) != 1 or "0x%08X" % mods[0]["address"] != m["module"]["base"] \
                or mods[0]["size"] != m["module"]["size"]:
            raise SystemExit("module differs from map: rebuild the map")
        base = mods[0]["address"]
        pl = base + int(m["anchors"]["player"]["rva"], 16)
        wt = base + int(m["anchors"]["weaponTable"]["rva"], 16)

        def status():
            hp, hpmax = c.read(pl + 0x964, 2)
            f0 = c.read(pl + 0xF0, 1)[0]
            f0 = f0 - (1 << 32) if f0 & 0x80000000 else f0
            wid = c.read(pl + 0x998, 1)[0]
            rec_addr = wt + (wid + f0 + 1) * 0x58
            return {"player": "0x%08X" % pl, "hp": f32(hp), "hpMax": f32(hpmax),
                    "invuln97C": c.read(pl + 0x97C, 1)[0], "equipped": wid, "ownerF0": f0,
                    "armorSet": c.read(pl + 0x5C8, 1)[0],
                    "weaponRecord": "0x%08X" % rec_addr, "rank3C": c.read(rec_addr + 0x3C, 1)[0],
                    "ammo40": c.read(rec_addr + 0x40, 1)[0]}

        before = status()
        rec["before"] = before
        if not (0 < before["hpMax"] < 1e5) or not 0 <= before["equipped"] < 0x19:
            raise SystemExit("player fields implausible, refusing: %s" % before)

        def put(addr, value, label, live_counter=False):
            old = c.read(addr, 1)[0]
            if live_counter:
                # The game decrements this counter every substep: accept a small drift on read-back.
                c.raw_request({"event": "memory.write_u32", "address": addr, "value": value})
                back = c.read(addr, 1)[0]
                if not 0 <= value - back < 100000:
                    raise SystemExit("read-back 0x%08X too far from 0x%08X at 0x%08X" % (back, value, addr))
            else:
                c.write(addr, value)
            rec["writes"].append({"field": label, "address": "0x%08X" % addr,
                                  "before": "0x%08X" % old, "after": "0x%08X" % value})

        if a.invuln:
            put(pl + 0x97C, INVULN, "player+0x97C", live_counter=True)
        if a.clear_invuln:
            put(pl + 0x97C, 0, "player+0x97C")
        if a.heal:
            put(pl + 0x964, c.read(pl + 0x968, 1)[0], "player+0x964")
        if a.ammo is not None:
            put(int(before["weaponRecord"], 16) + 0x40, a.ammo, "weaponRecord+0x40")
        if a.armor is not None:
            sid = armor_id(a.armor)
            _, helm, body, glove, boot = ARMOR_SETS[sid]
            w0, w1 = c.read(ARMOR_SLOTS, 2)
            cur = [(w0 >> (8 * k)) & 0xFF for k in range(4)] + [(w1 >> (8 * k)) & 0xFF for k in range(2)]
            if any(x > 7 for x in cur) or cur[2] != cur[3] or cur[4] != cur[5]:
                raise SystemExit("armor slot bytes implausible, refusing: %s" % cur)
            put(ARMOR_SLOTS, body | helm << 8 | glove << 16 | glove << 24, "armorSlots[0..3]")
            put(ARMOR_SLOTS + 4, (w1 & 0xFFFF0000) | boot | boot << 8, "armorSlots[4..5]")
            put(pl + 0x5C8, sid, "player+0x5C8 set id")
            rec["armorSlotsBefore"] = cur
        rec["after"] = status()
    finally:
        c.close()
    (a.out / "player-aid.json").write_text(json.dumps(rec, indent=1), encoding="utf-8")
    print(json.dumps({"before": rec["before"], "after": rec["after"], "writes": len(rec["writes"])}, indent=1))


if __name__ == "__main__":
    main()
