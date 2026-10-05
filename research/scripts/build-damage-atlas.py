#!/usr/bin/env python3
"""Generate project-authored damage-domain coverage and verify optional local evidence.

No extraction or matching. Raw export contents are never emitted publicly.
"""
import argparse
import hashlib
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
OUT = ROOT / "research/v2/damage-atlas-20261006"

# Explicit reviewed contracts, not a generated game-data inventory.
NAMES = ["sentinel", "Wrench", "Blaster", "BlitzGun", "BombGlove",
         "AgentsGlove", "BeeMineGlove", "ShieldCharger", "ShockRocket",
         "CrossbowGun", "Flamethrower", "LaserTracer", "SuckCannon",
         "Mootator", "MiniTurretGlove", "Ryno", "Hypershot", "Sproutomatic",
         "Polarizer", "PDA", "Shrinkray", "Boltgrabber", "Grindboots",
         "Mapomatic", "Boxbreaker"]
DOMAINS = [
    ("common_dispatch", "REPORT.md", "selected, zero-scalar and area delivery", "ABI and accepted counts"),
    ("ratchet", "REPORT.md", "ordered gates, HP, armor, type10 and suppression", "live boundary and group/source identity"),
    ("armor", "REPORT.md", "four-piece sum and fourteen offensive/passive combos", "child damage and passive cadence"),
    ("registered_receivers_level01", "REPORT.md", "nineteen non-null descriptor rows", "other modules and indirect group callbacks"),
    ("hazards", "REPORT.md", "surface, Fire, grind and Sharkagator routes", "scene scripts and upstream attack admission"),
    ("death_recovery", "REPORT.md", "distinct HP exhaustion and state requests", "actual death/checkpoint timing"),
    ("onfoot_clank", "CLANK_MINIGAMES.md", "active forwarding and alternate form", "constructor and state21 binding"),
    ("clank_bots", "CLANK_MINIGAMES.md", "scalar-independent state17 request", "lifecycle/controller consequence"),
    ("flinger", "CLANK_MINIGAMES.md", "magnitude conversion and local timer", "19AE0C consequence"),
    ("derby_torsos", "CLANK_MINIGAMES.md", "direct player HP and local admission", "armor/takeover and per-module cadence"),
    ("vehicle_ordnance", "CLANK_MINIGAMES.md", "mine event and missile impact/expiry", "193A84 and 1932E4 payload/filtering"),
    ("microbot", "CLANK_MINIGAMES.md", "controller boundary and toss fuse/blink", "full SurvivalBot and result/explosion"),
    ("giant_clank_combat", "CLANK_MINIGAMES.md", "local HP and rocket tuple/expiry", "upstream filters and launch/flight"),
    ("gcs_flight", "CLANK_MINIGAMES.md", "resource cap, replenishment and state request", "loss writers and virtual state3"),
    ("skyboard", "CLANK_MINIGAMES.md", "separate mine effect branches", "crash, respawn, sentry and boundary"),
    ("multiplayer", "CLANK_MINIGAMES.md", "distinct targets and original one-substep loop", "authority/team/receiver/turret semantics"),
]


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def write_json(path, value):
    path.write_text(json.dumps(value, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")


def verify_local():
    base = ROOT / "research/v2/decomp-candidates/_local/damage-atlas-20261006/level01-001"
    data = json.loads((base / "manifest.json").read_text(encoding="utf-8-sig"))
    assert data["mode"] == "READONLY_HEADLESS_DISCARD_REQUIRED"
    assert data["programSha256"] == "d10a81d076fb44987a45314a020cda2f7e8b39f860b957911ca9365464676571"
    assert data["initializedBefore"] == data["initializedAfter"]
    assert len(data["initializedBefore"]) == 52
    assert {f["rva"] for f in data["functions"]} == {"0x38540", "0x31b64", "0x4c2c0"}
    # Locate exports by their hashes, avoiding assumptions about filename casing.
    files = [p for p in base.rglob("*") if p.is_file() and p.name != "manifest.json"]
    hashes = {digest(p) for p in files}
    for row in data["functions"]:
        assert row["decompiled"]
        assert row["cSha256"] in hashes
        assert row["instructionsSha256"] in hashes
    recipe = ROOT / "research/scripts/ghidra/recipes/damage-atlas-level01-001.json"
    assert digest(recipe) == data["recipeSha256"]
    print("Local slice verified: 3 functions, 52 unchanged initialized blocks, all export hashes.")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--verify-local", action="store_true")
    args = parser.parse_args()
    reports = [OUT / f for f in ("REPORT.md", "WEAPONS.md", "CLANK_MINIGAMES.md", "COVERAGE.md", "METHOD.md")]
    for path in reports:
        assert path.is_file(), path
        assert path.read_text(encoding="utf-8-sig").startswith("---\n"), path
    weapons = []
    for ident, name in enumerate(NAMES):
        category = "sentinel" if ident == 0 else "active_gadget" if 16 <= ident <= 19 else "passive_equipment" if ident >= 20 else "combat_family"
        ranks = "0..7" if 2 <= ident <= 13 else "0..3" if ident == 15 else "0"
        weapons.append({"inventory_id": ident, "internal_label": name, "category": category,
                        "declared_rank_domain": ranks, "evidence": "OBSERVED",
                        "behavioral_parity": "UNKNOWN", "report": "WEAPONS.md"})
    write_json(OUT / "coverage.json", {
        "schema": 1, "date": "2026-10-06", "game": "UCES00420",
        "boundary": "Authored enumeration; not a whole-game completeness or parity claim",
        "inventory_entries": weapons, "registered_level01_receiver_rows": 19,
        "domains": [{"id": ident, "report": report, "observed_contract": closed,
                     "unresolved": gap, "behavioral_parity": "UNKNOWN"}
                    for ident, report, closed, gap in DOMAINS]})
    method_files = [ROOT / "research/scripts/build-damage-atlas.py",
                    ROOT / "research/scripts/ghidra/ExportDamageSlice.java"]
    method_files += sorted((ROOT / "research/scripts/ghidra/recipes").glob("damage-atlas-*.json"))
    method_files += [ROOT / "research/tasks/gpt-damage-atlas-20261006.md", OUT / "coverage.json"]
    write_json(OUT / "provenance.json", {
        "schema": 1, "date": "2026-10-06", "method": "hash reviewed project-authored UTF-8 inputs with canonical LF newlines",
        "files": [{"path": p.relative_to(ROOT).as_posix(), "sha256": hashlib.sha256(p.read_bytes().replace(b"\r\n", b"\n")).hexdigest()}
                  for p in reports + method_files]})
    if args.verify_local:
        verify_local()
    print("Authored coverage generated: 25 inventory entries, 16 mechanism domains.")


if __name__ == "__main__":
    main()
