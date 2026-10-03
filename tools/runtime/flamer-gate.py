#!/usr/bin/env python3
"""Read (and, for FG-v1+, control) the FlamerGate plugin over the PPSSPP debugger.

Read-only by default: locates the resident FlamerGate module, reads fg_state
(and fg_ctl / fg_gate when the manifest lists them), decodes them and, with
--map, cross-checks located sites against a level map from level-sigmap.py.

Control (FG-v2; FG-v1 superseded): --mode 0|1 and/or --parity 0|1 write fg_ctl[0] / fg_ctl[5]
in the plugin's own memory (never game memory: the address must lie inside the
FlamerGate module), then wait up to --wait seconds for the plugin thread to
apply the request and report fg_ctl[1] (applied mode) and fg_ctl[2] (error).

--auto-phase (with --mode 1, level already in C1 core, fire held by the owner or
--hold): one temporary breakpoint at the bound callback entry; the level frame
counter F0 read at that first callback gives P = (F0+1) & 1 (GPT phase rule,
research/v2/otto-flamer-static-20261003/REPORT.md); the breakpoint is removed
before P is written. Apply right after switching to C1.

FG-v4/v5 extras: --extras MASK writes wg[0] (bit 0 LaserTracer flag + damage gates, bit 1
AgentsGlove lifetime step -0.5, bit 2 weapon delta x2 (FG-v5), bit 3 BlasterShot 30->60 (FG-v5)), applied by the plugin in C1 only, independently of --mode;
the phase is the same run parity (fg_ctl[5]). The decode shows sites, applied mask and counters.

Usage:
  python tools/runtime/flamer-gate.py --manifest patches/experimental/flamer-gate/build/FG-v1/manifest.json \
      [--map <levelmap.json>] [--mode 1 --parity 1] [--out <new dir>]
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
MAP_KEYS = {"update": "flamer.update", "latchSet": "flamer.latchSet", "callback": "flamer.callback",
            "latchClear": "flamer.latchClear", "query": "flamer.query", "queryCall": "flamer.queryCall"}
ERRORS = {0: "none", 1: "sites incomplete", 2: "frame counter not found", 3: "unexpected word at query call",
          4: "restore found a foreign word", 5: "level not in C1 core", 6: "unexpected word at latch clear",
          7: "hook did not survive cache invalidation (restored)", 8: "mod19 reach-store site missing or unexpected"}


WG_ERRORS = {0: "none", 1: "not C1", 2: "frame counter", 3: "laser sites", 4: "laser word",
             5: "agent sites", 6: "agent word", 7: "verify", 8: "restore found foreign word"}


def decode_wg(wg, base, lit=None):
    rva = lambda v: ("0x%X" % (v - base)) if v else None
    res = {"requested": wg[0], "applied": wg[1], "error": WG_ERRORS.get(wg[2], wg[2]), "applyCount": wg[3],
            "restoreCount": wg[4], "flagReaderRva": rva(wg[5]), "flagAddress": "0x%08X" % wg[6],
            "laserDamageRvas": [rva(x) for x in wg[7:7 + min(wg[11], 4)]], "laserDamageCount": wg[11],
            "agentStepRvas": [rva(wg[12]), rva(wg[13])], "flagRun": wg[14], "flagSkip": wg[15],
            "damageRun": wg[16], "damageSkip": wg[17], "runParity": wg[19], "flagParity": wg[23]}
    if lit is not None:
        res["literals"] = [{"rva": rva(lit[4 * k]), "orig": "0x%08X" % lit[4 * k + 1], "new": "0x%08X" % lit[4 * k + 2],
                            "bit": lit[4 * k + 3]} for k in range(min(wg[22], 16))]
    return res


def decode(man, w, ctl, gate, base, mod_addr):
    sites = man["sites"]
    n = len(sites)
    res = {"version": man["version"], "prxSha256": man["prxSha256"], "magicOk": w[0] == 0x30544746,
           "pluginVersion": w[1], "loops": w[2], "scans": w[3], "uid": w[4], "textAddr": "0x%08X" % w[5],
           "textSize": w[6], "rcp1Base": "0x%08X" % base,
           "status": {0: "idle", 1: "scanning", 2: "all sites unique", 3: "incomplete"}.get(w[7], w[7]),
           "sites": {}}
    for i, s in enumerate(sites):
        addr, cnt = w[8 + i], w[8 + n + i]
        res["sites"][s] = {"rva": ("0x%X" % (addr - base)) if addr else None, "matches": cnt}
    call = w[8 + 2 * n]
    res["sites"]["queryCall"] = {"rva": ("0x%X" % (call - base)) if call else None, "matches": w[9 + 2 * n]}
    if ctl is not None:
        res["ctl"] = {"requestedMode": ctl[0], "appliedMode": ctl[1], "error": ERRORS.get(ctl[2], ctl[2]),
                      "applyCount": ctl[3], "restoreCount": ctl[4], "runParity": ctl[5],
                      "frameCounterRva": ("0x%X" % (ctl[6] - base)) if ctl[6] else None,
                      "frameCounterUnique": bool(ctl[7])}
    if gate is not None:
        res["gate"] = {"enabled": gate[0], "runParity": gate[2], "target": "0x%08X" % gate[3],
                       "queryRun": gate[4], "querySkip": gate[5]}
        if len(gate) >= 10:
            res["gate"].update({"latchClear": gate[8], "latchRetain": gate[9]})
        if len(gate) >= 11:
            res["gate"].update({"reachRun": gate[6], "reachSkip": gate[7],
                                "reachSiteRva": ("0x%X" % (gate[10] - base)) if gate[10] else None})
        if len(gate) >= 23:
            rva = lambda v: ("0x%X" % (v - base)) if v else None
            res["companion"] = {"installed": bool(gate[22]), "damageSiteRva": rva(gate[18]), "ageSiteRva": rva(gate[19]),
                                "damageSkipTargetRva": rva(gate[20]), "ageSkipTargetRva": rva(gate[21]),
                                "damageRun": gate[12], "damageSkip": gate[13], "damageBypass": gate[14],
                                "ageRun": gate[15], "ageSkip": gate[16], "ageBypass": gate[17]}
    return res


def main():
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument("--manifest", required=True, type=Path)
    ap.add_argument("--map", type=Path)
    ap.add_argument("--mode", type=int, choices=(0, 1))
    ap.add_argument("--parity", type=int, choices=(0, 1))
    ap.add_argument("--auto-phase", action="store_true")
    ap.add_argument("--extras", type=int, choices=range(16), help="FG-v4/v5: wg[0] request mask")
    ap.add_argument("--hold", help="PSP button held while --auto-phase waits for a callback (e.g. circle)")
    ap.add_argument("--wait", type=float, default=2.0)
    ap.add_argument("--out", type=Path)
    ap.add_argument("--port", type=int, default=60907)
    a = ap.parse_args()
    man = json.loads(a.manifest.read_text(encoding="utf-8"))
    sym = man["symbols"]
    n = len(man["sites"])
    controllable = "fg_ctl" in sym and "fg_gate" in sym
    if (a.mode is not None or a.parity is not None) and not controllable:
        raise SystemExit("this build has no control block (FG-v0)")
    c = pg.Client("127.0.0.1", a.port)
    c.connect()
    writes = []
    try:
        mods = {m["name"]: m for m in c.request("hle.module.list")["modules"] if m.get("isActive")}
        if "FlamerGate" not in mods:
            raise SystemExit("FlamerGate not resident; modules: %s" % sorted(mods))
        fgm = mods["FlamerGate"]
        lo, hi = fgm["address"], fgm["address"] + fgm["size"]

        def addr_of(name):
            addr = lo + sym[name]
            if not lo <= addr < hi:
                raise SystemExit("%s outside the FlamerGate module" % name)
            return addr

        def read_all():
            w = c.read(addr_of("fg_state"), 8 + 2 * n + 2)
            ctl = c.read(addr_of("fg_ctl"), 8) if controllable else None
            gate = (c.read(addr_of("fg_gate"), 24 if "fg_dmg_hook" in sym else 12 if "fg_reach_hook" in sym
                           else 10 if "fg_clear_hook" in sym else 8) if controllable else None)
            return w, ctl, gate

        def read_wg():
            return c.read(addr_of("wg"), 24) if "wg" in sym else None

        def read_lit():
            return c.read(addr_of("wg_lit"), 64) if "wg_lit" in sym else None

        w, ctl, gate = read_all()
        if w[0] != 0x30544746:
            raise SystemExit("fg_state magic mismatch: manifest does not match the resident build")
        if a.auto_phase:
            if not controllable or a.parity is not None:
                raise SystemExit("--auto-phase needs a controllable build and excludes --parity")
            cb_addr = w[8 + man["sites"].index("callback")]
            fc_addr = ctl[6]
            if not cb_addr or not fc_addr:
                raise SystemExit("callback or frame counter not bound")
            if c.request("cpu.breakpoint.list").get("breakpoints"):
                raise SystemExit("breakpoints already active")
            if a.hold:
                c.raw_request({"event": "input.buttons.send", "buttons": {a.hold: True}})
            c.request("cpu.breakpoint.add", {"address": cb_addr, "enabled": True, "log": False})
            f0 = None
            try:
                deadline = time.monotonic() + 20
                while time.monotonic() < deadline:
                    st = c.request("cpu.status")
                    if st.get("stepping"):
                        if st.get("pc") != cb_addr:
                            raise SystemExit("unexpected stop at 0x%08X" % (st.get("pc") or 0))
                        f0 = c.read(fc_addr, 1)[0]
                        break
                    time.sleep(0.003)
            finally:
                c.request("cpu.breakpoint.remove", {"address": cb_addr})
                if c.request("cpu.status").get("stepping"):
                    c.request("cpu.resume", no_reply=True, delay_ms=20)
                if a.hold:
                    c.raw_request({"event": "input.buttons.send", "buttons": {a.hold: False}})
            if f0 is None:
                raise SystemExit("no callback within 20 s (fire not held?)")
            a.parity = (f0 + 1) & 1
            writes.append({"field": "autoPhase", "F0": f0, "P": a.parity})
        if controllable and (a.mode is not None or a.parity is not None):
            if a.parity is not None:
                c.write(addr_of("fg_ctl") + 4 * 5, a.parity)
                writes.append({"field": "fg_ctl[5] runParity", "value": a.parity})
            if a.mode is not None:
                c.write(addr_of("fg_ctl"), a.mode)
                writes.append({"field": "fg_ctl[0] requestedMode", "value": a.mode})
            deadline = time.monotonic() + a.wait
            while time.monotonic() < deadline:
                time.sleep(0.1)
                w, ctl, gate = read_all()
                if (a.mode is None or ctl[1] == a.mode or ctl[2]) and (a.parity is None or gate[2] == a.parity):
                    break
        if a.extras is not None:
            if "wg" not in sym:
                raise SystemExit("--extras needs an FG-v4 build")
            c.write(addr_of("wg"), a.extras)
            writes.append({"field": "wg[0] extrasRequested", "value": a.extras})
            deadline = time.monotonic() + a.wait
            while time.monotonic() < deadline:
                time.sleep(0.1)
                wgv = read_wg()
                if wgv[1] == a.extras or wgv[2]:
                    break
        wgv = read_wg()
        litv = read_lit()
        rcp1 = mods.get("rcp1", {})
    finally:
        c.close()
    res = decode(man, w, ctl, gate, rcp1.get("address", 0), lo)
    if wgv is not None:
        res["extras"] = decode_wg(wgv, rcp1.get("address", 0), litv)
    res["utc"] = time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime())
    res["writes"] = writes
    if a.map:
        m = json.loads(a.map.read_text(encoding="utf-8"))
        res["mapCheck"] = {s: (res["sites"][s]["rva"] or "").upper() == m["sites"][k].get("rva", "-").upper()
                           for s, k in MAP_KEYS.items()}
        if "ctl" in res and res["ctl"]["frameCounterRva"]:
            res["mapCheck"]["frameCounter"] = (res["ctl"]["frameCounterRva"].upper()
                                               == m["anchors"]["frameCounter"]["rva"].upper())
    if a.out:
        a.out.mkdir(parents=True, exist_ok=False)
        (a.out / "flamer-gate-status.json").write_text(json.dumps(res, indent=1), encoding="utf-8")
    print(json.dumps(res, indent=1))


if __name__ == "__main__":
    main()
