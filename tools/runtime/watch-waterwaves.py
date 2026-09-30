#!/usr/bin/env python3
"""Watch the WaterWaves update (base+0x188AAC) in the live UCES00420 module.

Per true stop, records the PPSSPP tick, the two module globals at
base+0x2D9700/+0x04 (the accumulator pair the update adds its f12 delta to),
and registers ra, a0-a3, t0-t9 and f12. One temporary `log:false` breakpoint;
read-only otherwise (cpu.status / cpu.getAllRegs / memory.read). The four
guard words are decoded before and after the run.

Usage:
  python tools/runtime/watch-waterwaves.py --expect-state A0 --out \
      research/live-tests/pokitaru/waterfall-003-20260926/raw-waterwaves-c1-188aac.json
"""

import argparse
import base64
import importlib.util
import json
from pathlib import Path
import struct
import time

REPO = Path(__file__).resolve().parents[2]
CLIENT_PATH = REPO / "research/live-tests/pokitaru/waterfall-001/ppsspp-ws.py"
TICK_HZ = 222_000_000
UPDATE_RVA = 0x188AAC
GLOBALS_RVA = 0x2D9700
REGS_WANT = (["ra", "a0", "a1", "a2", "a3"]
             + ["t%d" % index for index in range(10)] + ["f12"])


def load_client():
    spec = importlib.util.spec_from_file_location("ppsspp_ws", CLIENT_PATH)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def main():
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument("--window-emu", type=float, default=6.0)
    parser.add_argument("--max-stops", type=int, default=800)
    parser.add_argument("--first-stop-timeout", type=float, default=15.0)
    parser.add_argument("--resume-delay-ms", type=int, default=10)
    parser.add_argument("--expect-state", default=None)
    parser.add_argument("--out", required=True)
    parser.add_argument("--port", type=int, default=60907)
    args = parser.parse_args()
    ws = load_client()
    client = ws.DebuggerClient("127.0.0.1", args.port)
    client.connect()
    record = {
        "utc": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
        "label": "waterwaves-%s" % UPDATE_RVA.__format__("x"),
        "client": "watch-waterwaves.py",
        "tickHz": TICK_HZ,
        "updateRva": "0x%06X" % UPDATE_RVA,
        "stops": [],
        "result": None,
    }
    added = False
    address = None
    try:
        game = client.request("game.status").get("game", {})
        if game.get("id") != "UCES00420":
            raise ws.WsError("wrong game: %s" % game.get("id"))
        modules = client.request("hle.module.list").get("modules", [])
        active = [m for m in modules
                  if m.get("name") == "rcp1" and m.get("isActive")]
        if len(active) != 1:
            raise ws.WsError("active rcp1 count is %d" % len(active))
        base = active[0]["address"]
        record["module"] = {"name": "rcp1", "base": "0x%08X" % base,
                            "size": active[0].get("size")}
        address = base + UPDATE_RVA
        record["address"] = "0x%08X" % address
        cpu = client.request("cpu.status")
        if cpu.get("stepping") or cpu.get("paused"):
            raise ws.WsError("CPU is paused or stepping")
        if client.request("game.status").get("paused"):
            raise ws.WsError("game is paused")
        if client.request("cpu.breakpoint.list").get("breakpoints"):
            raise ws.WsError("breakpoints already active")
        record["stateBefore"] = ws.decode_state(client, base)
        if (args.expect_state
                and record["stateBefore"]["state"] != args.expect_state):
            raise ws.WsError("state is %s, expected %s"
                             % (record["stateBefore"]["state"],
                                args.expect_state))
        if ws.read_word(client, address) != 0x27BDFFE0:
            raise ws.WsError("unexpected prologue at 0x%08X" % address)
        globals_address = base + GLOBALS_RVA
        record["globals"] = {"A": "0x%08X" % globals_address,
                             "B": "0x%08X" % (globals_address + 4)}
        client.request("cpu.breakpoint.add",
                       {"address": address, "enabled": True, "log": False})
        added = True
        wall_start = time.monotonic()
        first_tick = None
        last_tick = None
        end_reason = None
        while True:
            status = client.request("cpu.status")
            if status.get("stepping"):
                tick = status.get("ticks")
                if first_tick is None:
                    first_tick = tick
                last_tick = tick
                registers = {}
                for category in client.request(
                        "cpu.getAllRegs").get("categories", []):
                    for name, value in zip(category.get("registerNames", []),
                                           category.get("uintValues", [])):
                        registers[name.lower()] = value
                memory = client.request(
                    "memory.read",
                    {"address": globals_address, "size": 8,
                     "replacements": False})
                globals_raw = struct.unpack(
                    "<2I", base64.b64decode(memory.get("base64", "")))
                stop = {"tick": tick, "pc": status.get("pc"),
                        "globalA": globals_raw[0], "globalB": globals_raw[1]}
                for name in REGS_WANT:
                    stop[name] = registers.get(name)
                record["stops"].append(stop)
                client.request("cpu.resume", no_reply=True,
                               delay_ms=args.resume_delay_ms)
                if len(record["stops"]) >= args.max_stops:
                    end_reason = "maxStops"
                    break
                if (last_tick - first_tick) / TICK_HZ >= args.window_emu:
                    end_reason = "window"
                    break
            else:
                if (first_tick is None
                        and time.monotonic() - wall_start
                        > args.first_stop_timeout):
                    end_reason = "noFirstStop"
                    break
                time.sleep(0.005)
        client.request("cpu.breakpoint.remove", {"address": address})
        added = False
        status = client.request("cpu.status")
        if status.get("stepping"):
            client.request("cpu.resume", no_reply=True, delay_ms=50)
        record["breakpointsAfter"] = client.request(
            "cpu.breakpoint.list").get("breakpoints", [])
        record["stateAfter"] = ws.decode_state(client, base)
        stops = record["stops"]
        count = len(stops)
        emu_seconds = 0.0
        if count >= 2:
            emu_seconds = (last_tick - first_tick) / TICK_HZ
        record["window"] = {
            "targetEmuSeconds": args.window_emu,
            "emuSeconds": emu_seconds,
            "wallSeconds": time.monotonic() - wall_start,
            "stopCount": count,
            "ratePerEmuSecond": ((count - 1) / emu_seconds
                                 if count >= 2 and emu_seconds > 0 else None),
            "absent": count == 0,
            "endReason": end_reason,
        }
        record["result"] = "PASS"
    except Exception as error:
        record["result"] = "FAILED"
        record["error"] = str(error)
        raise
    finally:
        if added:
            try:
                client.request("cpu.breakpoint.remove", {"address": address})
                if client.request("cpu.status").get("stepping"):
                    client.request("cpu.resume", no_reply=True, delay_ms=50)
            except Exception:
                pass
        client.close()
        out = Path(args.out)
        if not out.is_absolute():
            out = REPO / out
        out.parent.mkdir(parents=True, exist_ok=True)
        out.write_text(json.dumps(record, indent=1), encoding="utf-8")
        window = record.get("window") or {}
        print(json.dumps({
            "result": record.get("result"),
            "stops": window.get("stopCount"),
            "emuSeconds": round(window.get("emuSeconds", 0.0), 3),
            "ratePerEmuSecond": (round(window["ratePerEmuSecond"], 3)
                                 if window.get("ratePerEmuSecond") else None),
            "endReason": window.get("endReason"),
            "stateBefore": (record.get("stateBefore") or {}).get("state"),
            "stateAfter": (record.get("stateAfter") or {}).get("state"),
            "out": str(out),
        }, sort_keys=True))


if __name__ == "__main__":
    main()
