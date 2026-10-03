#!/usr/bin/env python3
"""Count and order executions of several rcp1 code addresses in one window.

Generalises count-calls.py to N sites. Each site is true-stopped by a
temporary `log:false` breakpoint; per stop the tool records the site label,
emulated tick, the LEVEL_01 main frame counter (module+0x2AF28C) and selected
registers, then resumes. Optional per-site byte reads at `reg+offset` capture
small state (e.g. a latch byte) at the moment of the stop.

Read-only for game state: it never writes memory, registers, savestates or
configuration. The only optional input action is `--hold BUTTON`, which holds
one PSP button through PPSSPP `input.buttons.send` for the window and releases
it afterwards (fire-button injection, as in ray-stats.py).

Guards (research/GOTCHAS.md): one debugger connection; module base resolved
per run; site words verified against --expect; refuses delay-slot sites
unless --allow-delay-slot; four state guard words decoded before and after;
rates reported in emulated seconds (222 MHz ticks) and per game frame.

Usage:
  python tools/runtime/count-multi.py --expect-state A0 --hold circle --window-emu 6 \
      --site U=0x13B8F0:0x27BDFFB0 --site L=0x13B914:0xA2320015:regs=s1,s2 \
      --site CB=0x13C3D8:0x27BDFEA0 --site CLR=0x13C434:0xA2000015 \
      --site Q=0x13C650:0x0E4A2705 --label A0-empty --out <new dir>
Site syntax: LABEL=RVA[:EXPECTED_WORD][:regs=r1,r2][:byte=reg+0xOFF]
--peek NAME=0xADDR[:SIZE] reads absolute bytes at every stop.
--gate-reg REG[=VALUE] (EXPERIMENT) at every stop on frames whose parity differs from the first
stop's frame, set REG to VALUE (default 0) before resuming (emulates a once-per-A0-frame gate at a branch on REG).
--refill 0xADDR:BELOW:VALUE (TEST AID) at every stop, writes u32 VALUE when the u32 at ADDR is
below BELOW (e.g. ammo after a savestate reload or weapon switch); each refill is recorded in the stop.
PPSSPP 1.20.4 (observed 2026-10-03): with several breakpoints listed, only the
last added one stopped. Run one site per window until that is understood.
"""

import argparse
import hashlib
import importlib.util
import json
import struct
import base64
import time
from collections import Counter
from pathlib import Path

REPO = Path(__file__).resolve().parents[2]
PUMP_GATE_PATH = REPO / "tools/runtime/pump-gate.py"
TICK_HZ = 222_000_000
FRAME_COUNTER_RVA = 0x2AF28C


def load_client():
    """pump-gate.Client: the policy-checked read-only client plus raw_request,
    used here only for the --hold input.buttons.send (as in ray-stats.py)."""
    spec = importlib.util.spec_from_file_location("pump_gate", PUMP_GATE_PATH)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def parse_site(text, levelmap=None):
    label, rest = text.split("=", 1)
    parts = rest.split(":")
    if parts[0].startswith("@"):
        if not levelmap:
            raise SystemExit("site %s uses a map name but no --map was given" % label)
        name = parts[0][1:]
        entry = levelmap["sites"].get(name, {})
        if "rva" not in entry:
            raise SystemExit("map has no unique rva for %s" % name)
        site = {"label": label, "rva": int(entry["rva"], 16), "expect": int(levelmap["words"][name], 16),
                "regs": [], "byte": None}
    else:
        site = {"label": label, "rva": int(parts[0], 0), "expect": None, "regs": [], "byte": None}
    for p in parts[1:]:
        if p.startswith("regs="):
            site["regs"] = [r.strip().lower() for r in p[5:].split(",") if r.strip()]
        elif p.startswith("byte="):
            reg, off = p[5:].split("+")
            site["byte"] = (reg.strip().lower(), int(off, 0))
        elif p:
            site["expect"] = int(p, 0)
    return site


def is_branch_or_jump(word):
    op = word >> 26
    if op in (0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x14, 0x15, 0x16, 0x17):
        return True
    if op == 0x00 and (word & 0x3F) in (0x08, 0x09):
        return True
    if op == 0x01 and ((word >> 16) & 0x1F) in (0x00, 0x01, 0x02, 0x03, 0x10, 0x11, 0x12, 0x13):
        return True
    if op == 0x11 and ((word >> 21) & 0x1F) == 0x08:
        return True
    return False


def flatten_regs(response):
    registers = {}
    for category in response.get("categories", []):
        for name, value in zip(category.get("registerNames", []), category.get("uintValues", [])):
            registers[name.lower()] = value
    return registers


def main():
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument("--site", action="append", required=True)
    ap.add_argument("--window-emu", type=float, default=6.0, help="emulated seconds from first to last stop")
    ap.add_argument("--max-stops", type=int, default=4000)
    ap.add_argument("--wall-max", type=float, default=300.0)
    ap.add_argument("--first-stop-timeout", type=float, default=20.0)
    ap.add_argument("--resume-delay-ms", type=int, default=5)
    ap.add_argument("--hold", default=None, help="PSP button to hold during the window (e.g. circle)")
    ap.add_argument("--settle", type=float, default=1.0, help="wall seconds between hold start and arming")
    ap.add_argument("--peek", action="append", default=[],
                    help="NAME=0xADDR[:SIZE] bytes read at every stop (absolute address, default 1 byte)")
    ap.add_argument("--gate-reg", default=None,
                    help="experiment: zero this register at stops on off-parity frames (parity of the first stop)")
    ap.add_argument("--refill", action="append", default=[],
                    help="0xADDR:BELOW:VALUE test aid: write u32 VALUE at a stop when u32 at ADDR < BELOW")
    ap.add_argument("--map", type=Path, default=None,
                    help="level map from level-sigmap.py find: guard words, frame counter and @site names")
    ap.add_argument("--stop-f32-le", action="append", default=[],
                    help="NAME=VALUE: end when peek NAME (4-byte float) is <= VALUE (e.g. hp=0 for a boss death)")
    ap.add_argument("--stop-u32-eq", action="append", default=[],
                    help="NAME=VALUE: end when peek NAME (4-byte unsigned) equals VALUE (e.g. anim=19 for Otto's death)")
    ap.add_argument("--idle-timeout", type=float, default=0.0,
                    help="end when no stop occurs for this many wall seconds after the first stop (0 = off)")
    ap.add_argument("--allow-delay-slot", action="store_true")
    ap.add_argument("--expect-state", default=None)
    ap.add_argument("--label", required=True)
    ap.add_argument("--note", default="")
    ap.add_argument("--out", type=Path, required=True)
    ap.add_argument("--port", type=int, default=60907)
    a = ap.parse_args()
    a.out.mkdir(parents=True, exist_ok=False)
    levelmap = json.loads(a.map.read_text(encoding="utf-8")) if a.map else None
    sites = [parse_site(s, levelmap) for s in a.site]
    stop_rules = []
    for rule in a.stop_f32_le:
        name, val = rule.split("=", 1)
        stop_rules.append((name, "f32le", float(val)))
    for rule in a.stop_u32_eq:
        name, val = rule.split("=", 1)
        stop_rules.append((name, "u32eq", int(val, 0)))
    peeks = []
    for p in a.peek:
        name, rest = p.split("=", 1)
        addr, _, size = rest.partition(":")
        peeks.append((name, int(addr, 0), int(size or "1", 0)))
    refills = [tuple(int(x, 0) for x in r.split(":")) for r in a.refill]
    if any(len(r) != 3 for r in refills):
        raise SystemExit("--refill expects 0xADDR:BELOW:VALUE")
    if len({s["label"] for s in sites}) != len(sites):
        raise SystemExit("duplicate site label")
    pg = load_client()
    ws = pg.ws
    frame_rva = FRAME_COUNTER_RVA
    if levelmap:
        # Level-specific guard words and frame counter (decode_state reads ws.GUARDS / ws.WAIT_TARGET_RVA).
        mbase = int(levelmap["module"]["base"], 16)
        g = {k: int(levelmap["sites"]["guard." + k]["rva"], 16)
             for k in ("wait", "sharedDelta", "loopThreshold", "localScalar")}
        ws.GUARDS = [(k, g[k]) for k in ("wait", "sharedDelta", "loopThreshold", "localScalar")]
        wait_word = int(levelmap["words"]["guard.wait"], 16)
        wait_pc = mbase + g["wait"]
        ws.WAIT_TARGET_RVA = (((wait_pc + 4) & 0xF0000000) | ((wait_word & 0x03FFFFFF) << 2)) - mbase
        frame_rva = int(levelmap["anchors"]["frameCounter"]["rva"], 16)
    c = pg.Client("127.0.0.1", a.port)
    c.connect()

    def rd_word(addr):
        return ws.read_word(c, addr)

    gate_parity = None

    def set_reg(name, value):
        c.raw_request({"event": "cpu.setReg", "name": name, "value": value})

    def rd_byte(addr):
        r = c.request("memory.read", {"address": addr, "size": 1, "replacements": False})
        return base64.b64decode(r.get("base64", ""))[0]

    rec = {"utc": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()), "label": a.label, "note": a.note,
           "client": "count-multi.py", "methodSha256": hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
           "tickHz": TICK_HZ, "hold": a.hold, "peeks": a.peek, "refills": a.refill, "map": str(a.map) if a.map else None, "sites": [], "stops": [], "result": None}
    added, holding = [], False
    try:
        rec["identity"] = ws.identity(c, expect_state=a.expect_state)
        base = rec["identity"]["module"]["baseDecimal"]
        rec["modulesActive"] = [{"name": m["name"], "address": "0x%08X" % m["address"], "size": m.get("size")}
                                for m in c.request("hle.module.list")["modules"] if m.get("isActive")]
        if c.request("cpu.breakpoint.list").get("breakpoints"):
            raise ws.WsError("breakpoints already active")
        by_addr = {}
        for s in sites:
            addr = base + s["rva"]
            word, prev = rd_word(addr), rd_word(addr - 4)
            if s["expect"] is not None and word != s["expect"]:
                raise ws.WsError("site %s word 0x%08X != expected 0x%08X" % (s["label"], word, s["expect"]))
            if is_branch_or_jump(prev) and not a.allow_delay_slot:
                raise ws.WsError("site %s is in a delay slot (prev 0x%08X)" % (s["label"], prev))
            rec["sites"].append({"label": s["label"], "rva": "0x%06X" % s["rva"], "address": "0x%08X" % addr,
                                 "word": "0x%08X" % word, "prevWord": "0x%08X" % prev, "regs": s["regs"],
                                 "byte": ("%s+0x%X" % s["byte"]) if s["byte"] else None})
            by_addr[addr] = s
        if a.hold:
            c.raw_request({"event": "input.buttons.send", "buttons": {a.hold: True}})
            holding = True
            time.sleep(a.settle)
        if levelmap and "0x%08X" % base != levelmap["module"]["base"]:
            raise ws.WsError("module base differs from map: rebuild the map")
        fc_addr = base + frame_rva
        rec["frameBefore"] = rd_word(fc_addr)
        for addr in by_addr:
            c.request("cpu.breakpoint.add", {"address": addr, "enabled": True, "log": False})
            added.append(addr)
        wall0, first_tick, last_tick, end = time.monotonic(), None, None, None
        last_stop_wall = wall0
        while True:
            st = c.request("cpu.status")
            if st.get("stepping"):
                pc = st.get("pc")
                if pc not in by_addr:
                    raise ws.WsError("unexpected stop at 0x%08X" % (pc or 0))
                s = by_addr[pc]
                tick = st.get("ticks")
                first_tick = tick if first_tick is None else first_tick
                last_tick = tick
                stop = {"site": s["label"], "tick": tick, "frame": rd_word(fc_addr)}
                for name, paddr, psize in peeks:
                    r = c.request("memory.read", {"address": paddr, "size": psize, "replacements": False})
                    stop[name] = base64.b64decode(r.get("base64", "")).hex()
                if s["regs"] or s["byte"]:
                    regs = flatten_regs(c.request("cpu.getAllRegs"))
                    for r in s["regs"]:
                        stop[r] = regs.get(r)
                    if s["byte"]:
                        reg, off = s["byte"]
                        ptr = regs.get(reg) or 0
                        stop["byte"] = rd_byte(ptr + off) if ptr else None
                if a.gate_reg:
                    if gate_parity is None:
                        gate_parity = stop["frame"] & 1
                    if stop["frame"] & 1 != gate_parity:
                        reg, _, val = a.gate_reg.partition("=")
                        set_reg(reg, int(val or "0", 0))
                        stop["gated"] = 1
                for raddr, below, value in refills:
                    if rd_word(raddr) < below:
                        c.raw_request({"event": "memory.write_u32", "address": raddr, "value": value})
                        stop.setdefault("refill", []).append("0x%08X" % raddr)
                rec["stops"].append(stop)
                last_stop_wall = time.monotonic()
                c.request("cpu.resume", no_reply=True, delay_ms=a.resume_delay_ms)
                hit = []
                for n, kind, v in stop_rules:
                    if n not in stop:
                        continue
                    raw = bytes.fromhex(stop[n])[:4]
                    if (kind == "f32le" and struct.unpack("<f", raw)[0] <= v) or                        (kind == "u32eq" and struct.unpack("<I", raw)[0] == v):
                        hit.append(n)
                if hit:
                    end = "stopCondition:" + ",".join(hit)
                    break
                if len(rec["stops"]) >= a.max_stops:
                    end = "maxStops"
                    break
                if (last_tick - first_tick) / TICK_HZ >= a.window_emu:
                    end = "window"
                    break
            else:
                now = time.monotonic()
                if a.idle_timeout and first_tick is not None and now - last_stop_wall > a.idle_timeout:
                    end = "idle"
                    break
                if first_tick is None and now - wall0 > a.first_stop_timeout:
                    end = "noFirstStop"
                    break
                if now - wall0 > a.wall_max:
                    end = "wallTimeout"
                    break
                time.sleep(0.003)
    finally:
        for addr in added:
            try:
                c.request("cpu.breakpoint.remove", {"address": addr})
            except Exception:
                pass
        try:
            if c.request("cpu.status").get("stepping"):
                c.request("cpu.resume", no_reply=True, delay_ms=50)
        except Exception:
            pass
        if holding:
            try:
                c.raw_request({"event": "input.buttons.send", "buttons": {a.hold: False}})
            except Exception:
                pass
        try:
            rec["breakpointsAfter"] = c.request("cpu.breakpoint.list").get("breakpoints", [])
            if "identity" in rec:
                rec["stateAfter"] = ws.decode_state(c, rec["identity"]["module"]["baseDecimal"])["state"]
        except Exception as e:
            rec["cleanupError"] = str(e)
        c.close()
    stops = rec["stops"]
    counts = Counter(s["site"] for s in stops)
    emu = ((last_tick - first_tick) / TICK_HZ) if stops else 0.0
    frames = (stops[-1]["frame"] - stops[0]["frame"]) if stops else 0
    rec["result"] = {
        "endReason": end, "stops": len(stops), "emuSeconds": round(emu, 4), "frames": frames,
        "framesPerEmuSecond": round(frames / emu, 3) if emu else None,
        "counts": dict(counts),
        "perEmuSecond": {k: round(v / emu, 3) for k, v in counts.items()} if emu else {},
        "perFrame": {k: round(v / frames, 4) for k, v in counts.items()} if frames else {},
        "valid": (end == "window" or (end or "").startswith("stopCondition") or end == "idle") and rec.get("stateAfter") == rec["identity"]["state"]
                 and not rec.get("breakpointsAfter"),
    }
    (a.out / "count-multi.json").write_text(json.dumps(rec, indent=1), encoding="utf-8")
    print(json.dumps(rec["result"], indent=1))


if __name__ == "__main__":
    main()
