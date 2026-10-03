#!/usr/bin/env python3
"""Map known LEVEL_01 (Pokitaru) code sites and data anchors onto another level module.

Level modules (rcp1) differ per planet, so RVAs from LEVEL_01 do not apply on
another level. This read-only tool captures masked code signatures around
named sites in the current module, then finds the same windows in another
level's module and derives the new RVAs and data addresses.

  capture   in LEVEL_01: read a word window around each site, record which
            words are relocation-dependent (jal/j targets, lui immediates and
            their paired low immediates) and every hi/lo data address formed
            in the window. Data anchors (player, frame counter, damage table,
            weapon table) get extra windows found by scanning for references.
  find      in the current level: read the module, locate each signature
            (masked compare, unique full match required), output a level map
            {site: rva} and {data anchor: rva} with match quality.

Signature packs contain game code words: they are written under a `_local/`
directory, which is ignored by Git and must never be published.
Read-only: memory.read and hle.module.list only.

Usage:
  python tools/runtime/level-sigmap.py capture --out research/live-tests/_local/sigpack-level01.json
  python tools/runtime/level-sigmap.py find --pack research/live-tests/_local/sigpack-level01.json \
      --out research/live-tests/<dir>/levelmap.json
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
PUMP_GATE_PATH = REPO / "tools/runtime/pump-gate.py"

# LEVEL_01 RVAs (sources: research/v2/damage-health-20261003/REPORT.md, tools/runtime/switch-module-state.py).
SITES = {
    "guard.wait": 0x96650, "guard.sharedDelta": 0x151E0, "guard.loopThreshold": 0x2FCFC,
    "guard.localScalar": 0x2FBBC, "main.pump2Call": 0x15338, "pump2": 0x6E6D4, "pump2.callbackJalr": 0x6ECE8,
    "flamer.update": 0x13B8F0, "flamer.latchSet": 0x13B914, "flamer.callback": 0x13C3D8,
    "flamer.latchClear": 0x13C434, "flamer.queryCall": 0x13C650, "flamer.query": 0x13CF14,
    "flamer.init": 0x13A964, "player.wrapper": 0x312AC, "player.hpDamage": 0x38540,
    "weapon.recordGet": 0x1F71C, "weapon.rankSet": 0x1F550,
}
ANCHORS = {"player": 0x337940, "frameCounter": 0x2AF28C, "damageTable": 0x2CB0CC, "weaponTable": 0x2AE95C}
BEFORE, AFTER = 12, 28
PAIR_LOW_OPS = {0x09, 0x0D, 0x20, 0x21, 0x23, 0x24, 0x25, 0x28, 0x29, 0x2B, 0x31, 0x39}  # addiu ori lb lh lw lbu lhu sb sh sw lwc1 swc1


def load_client():
    spec = importlib.util.spec_from_file_location("pump_gate", PUMP_GATE_PATH)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def simm(w):
    v = w & 0xFFFF
    return v - 0x10000 if v & 0x8000 else v


def analyse(words, base):
    """Return (mask per word, list of (index, absolute address) hi/lo pairs)."""
    masks, pairs, hi = [], [], {}
    for i, w in enumerate(words):
        op, rs, rt = w >> 26, (w >> 21) & 31, (w >> 16) & 31
        mask = 0xFFFFFFFF
        if op in (0x02, 0x03):
            mask = 0xFC000000
        elif op == 0x0F:
            mask = 0xFFFF0000
            hi[rt] = (i, (w & 0xFFFF) << 16)
        elif op in PAIR_LOW_OPS and rs in hi and i - hi[rs][0] <= 10:
            mask = 0xFFFF0000
            pairs.append((i, (hi[rs][1] + simm(w)) & 0xFFFFFFFF))
        if op in PAIR_LOW_OPS and op not in (0x28, 0x29, 0x2B, 0x39) and rt in hi and rt != rs:
            hi.pop(rt, None)  # destination overwritten
        masks.append(mask)
    return masks, pairs


def read_module(c, base, size, chunk=0x40000):
    data = bytearray()
    for off in range(0, size, chunk):
        n = min(chunk, size - off)
        r = c.request("memory.read", {"address": base + off, "size": n, "replacements": False})
        part = base64.b64decode(r["base64"])
        if len(part) != n:
            raise RuntimeError("short read at +0x%X" % off)
        data += part
    return bytes(data)


def words_of(blob):
    return list(struct.unpack("<%dI" % (len(blob) // 4), blob[: len(blob) // 4 * 4]))


def module_info(c):
    mods = [m for m in c.request("hle.module.list")["modules"] if m.get("isActive") and m["name"] == "rcp1"]
    if len(mods) != 1:
        raise RuntimeError("active rcp1 count %d" % len(mods))
    return mods[0]["address"], mods[0]["size"]


def window(all_words, rva):
    i = rva // 4
    return all_words[i - BEFORE: i + AFTER]


def cmd_capture(a, pg):
    c = pg.Client("127.0.0.1", a.port)
    c.connect()
    try:
        game = c.request("game.status")["game"]
        base, size = module_info(c)
        blob = read_module(c, base, size)
    finally:
        c.close()
    allw = words_of(blob)
    pack = {"utc": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()), "game": game,
            "source": {"base": "0x%08X" % base, "size": size, "sha256": hashlib.sha256(blob).hexdigest()},
            "before": BEFORE, "after": AFTER, "sites": {}, "anchors": {}}
    for name, rva in SITES.items():
        w = window(allw, rva)
        masks, pairs = analyse(w, base)
        pack["sites"][name] = {"rva": rva, "words": w, "masks": masks,
                               "pairs": [(i, (adr - base) & 0xFFFFFFFF) for i, adr in pairs]}
    # Data anchors: first windows whose hi/lo pairs hit the anchor exactly.
    code_end = min(len(allw), 0x1C0000 // 4)
    for aname, arva in ANCHORS.items():
        target = (base + arva) & 0xFFFFFFFF
        found = []
        for i in range(BEFORE, code_end - AFTER):
            w = allw[i]
            if w >> 26 in PAIR_LOW_OPS and (w & 0xFFFF) == (target & 0xFFFF):
                win = allw[i - BEFORE: i + AFTER]
                masks, pairs = analyse(win, base)
                if any(idx == BEFORE and adr == target for idx, adr in pairs):
                    found.append({"rva": i * 4, "words": win, "masks": masks,
                                  "pairs": [(k, (adr - base) & 0xFFFFFFFF) for k, adr in pairs]})
                    if len(found) >= a.anchor_refs:
                        break
        pack["anchors"][aname] = {"rva": arva, "refs": found}
    out = Path(a.out)
    if "_local" not in out.parts:
        raise SystemExit("signature packs contain game code: write under a _local/ directory")
    out.parent.mkdir(parents=True, exist_ok=True)
    out.write_text(json.dumps(pack), encoding="utf-8")
    print("captured %d sites, anchors %s -> %s" % (len(pack["sites"]),
          {k: len(v["refs"]) for k, v in pack["anchors"].items()}, out))


def match_at(allw, start, sig):
    words, masks = sig["words"], sig["masks"]
    if start < 0 or start + len(words) > len(allw):
        return 0
    return sum(1 for k, (w, m) in enumerate(zip(words, masks)) if (allw[start + k] & m) == (w & m))


def find_sig(allw, sig, counts):
    words, masks = sig["words"], sig["masks"]
    # Anchor: the fully specified word with the fewest occurrences in the target module.
    cands = [(counts.get(w, 0), k) for k, (w, m) in enumerate(zip(words, masks)) if m == 0xFFFFFFFF and w not in (0,)]
    if not cands:
        return []
    cands.sort()
    hits = {}
    for _, k in cands[:3]:
        w = words[k]
        for pos in counts.get(("pos", w), []):
            start = pos - k
            if start not in hits:
                hits[start] = match_at(allw, start, sig)
    return sorted(((s, sc) for s, sc in hits.items()), key=lambda x: -x[1])


def cmd_find(a, pg):
    pack = json.loads(Path(a.pack).read_text(encoding="utf-8"))
    c = pg.Client("127.0.0.1", a.port)
    c.connect()
    try:
        game = c.request("game.status")["game"]
        base, size = module_info(c)
        blob = read_module(c, base, size)
    finally:
        c.close()
    allw = words_of(blob)
    counts = {}
    for i, w in enumerate(allw):
        counts[w] = counts.get(w, 0) + 1
        if counts[w] <= 64:
            counts.setdefault(("pos", w), []).append(i)
    n = BEFORE + AFTER
    res = {"utc": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()), "game": game,
           "module": {"base": "0x%08X" % base, "size": size, "sha256": hashlib.sha256(blob).hexdigest()},
           "pack": {"path": a.pack, "sourceSha256": pack["source"]["sha256"]},
           "sites": {}, "anchors": {}, "words": {}}
    for name, sig in pack["sites"].items():
        hits = find_sig(allw, sig, counts)
        full = [s for s, sc in hits if sc == n]
        entry = {"pokitaruRva": "0x%X" % sig["rva"], "fullMatches": len(full),
                 "best": ["0x%X:%d/%d" % ((s + BEFORE) * 4, sc, n) for s, sc in hits[:3]]}
        if len(full) == 1:
            rva = (full[0] + BEFORE) * 4
            entry["rva"] = "0x%X" % rva
            res["words"][name] = "0x%08X" % allw[full[0] + BEFORE]
            _, pairs = analyse(allw[full[0]: full[0] + n], base)
            entry["dataMap"] = {"0x%X" % old: "0x%X" % ((adr - base) & 0xFFFFFFFF)
                                for (k, old), (k2, adr) in zip(sig["pairs"], pairs) if k == k2}
        res["sites"][name] = entry
    for aname, anc in pack["anchors"].items():
        votes = {}
        for ref in anc["refs"]:
            hits = find_sig(allw, ref, counts)
            full = [s for s, sc in hits if sc == n]
            if len(full) == 1:
                _, pairs = analyse(allw[full[0]: full[0] + n], base)
                for (k, old), (k2, adr) in zip(ref["pairs"], pairs):
                    if k == k2 == BEFORE and old == anc["rva"]:
                        v = (adr - base) & 0xFFFFFFFF
                        votes[v] = votes.get(v, 0) + 1
        res["anchors"][aname] = {"pokitaruRva": "0x%X" % anc["rva"], "refs": len(anc["refs"]),
                                 "votes": {"0x%X" % k: v for k, v in votes.items()},
                                 "rva": ("0x%X" % max(votes, key=votes.get)) if len(votes) == 1 else None}
    out = Path(a.out)
    out.parent.mkdir(parents=True, exist_ok=True)
    out.write_text(json.dumps(res, indent=1), encoding="utf-8")
    for name, e in res["sites"].items():
        print("%-22s %-8s full=%d %s" % (name, e.get("rva", "-"), e["fullMatches"], " ".join(e["best"][:2])))
    for name, e in res["anchors"].items():
        print("anchor %-15s %s votes=%s" % (name, e["rva"], e["votes"]))


def main():
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    sub = ap.add_subparsers(dest="cmd", required=True)
    p = sub.add_parser("capture")
    p.add_argument("--out", required=True)
    p.add_argument("--anchor-refs", type=int, default=3)
    p.add_argument("--port", type=int, default=60907)
    p = sub.add_parser("find")
    p.add_argument("--pack", required=True)
    p.add_argument("--out", required=True)
    p.add_argument("--port", type=int, default=60907)
    a = ap.parse_args()
    pg = load_client()
    {"capture": cmd_capture, "find": cmd_find}[a.cmd](a, pg)


if __name__ == "__main__":
    main()
