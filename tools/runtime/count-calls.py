#!/usr/bin/env python3
"""Count executions of one rcp1 code address in the live UCES00420 module.

True-stop the address, read selected registers (and optionally a memory block
at one register) per stop, resume immediately, and remove the temporary
breakpoint afterwards. Read-only by construction: it adds exactly one
temporary `log:false` breakpoint and uses only cpu.status, cpu.getAllRegs and
memory.read. It never writes memory, registers, input, savestates or
configuration. The four guard words are decoded before and after the run, so
a capture cannot be silently attributed to the wrong arm.

Rates are computed in emulated seconds (PPSSPP ticks at the project's
222 MHz calibration), not wall seconds, because resumed-stop overhead
distorts wall time.

Usage:
  python tools/runtime/count-calls.py --rva 0x151FCC --expect-jal 0xDDC08 \
      --regs ra,a0,a1,v0 --sample-reg a0 --sample-size 80 --sample-first 5 \
      --window-emu 8 --expect-state A0 \
      --out research/live-tests/pokitaru/waterfall-003-20260926/raw-call-a0-151fcc.json
"""

import argparse
import hashlib
import importlib.util
import json
from pathlib import Path
import time

REPO = Path(__file__).resolve().parents[2]
CLIENT_PATH = REPO / "research/live-tests/pokitaru/waterfall-001/ppsspp-ws.py"
TICK_HZ = 222_000_000
DEFAULT_REGS = "ra,a0,a1,a2,a3,v0,v1,f12"


def load_client():
    spec = importlib.util.spec_from_file_location("ppsspp_ws", CLIENT_PATH)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def flatten_regs(response):
    registers = {}
    for category in response.get("categories", []):
        names = category.get("registerNames", [])
        values = category.get("uintValues", [])
        for name, value in zip(names, values):
            registers[name.lower()] = value
    return registers


def main():
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument("--rva", required=True, type=lambda x: int(x, 0))
    parser.add_argument("--expect-jal", type=lambda x: int(x, 0), default=None,
                        help="expected jal target rva at --rva (verified in RAM)")
    parser.add_argument("--regs", default=DEFAULT_REGS)
    parser.add_argument("--sample-reg", default=None)
    parser.add_argument("--sample-size", type=int, default=80)
    parser.add_argument("--sample-first", type=int, default=0)
    parser.add_argument("--window-emu", type=float, default=8.0,
                        help="emulated seconds from first to last stop")
    parser.add_argument("--max-stops", type=int, default=800)
    parser.add_argument("--wall-max", type=float, default=240.0)
    parser.add_argument("--first-stop-timeout", type=float, default=20.0)
    parser.add_argument("--resume-delay-ms", type=int, default=10)
    parser.add_argument("--expect-state", default=None)
    parser.add_argument("--label", default=None)
    parser.add_argument("--out", required=True)
    parser.add_argument("--port", type=int, default=60907)
    args = parser.parse_args()
    if Path(args.out).exists():
        raise RuntimeError("refusing to overwrite evidence")
    ws = load_client()
    client = ws.DebuggerClient("127.0.0.1", args.port)
    client.connect()
    regs_requested = [name.strip().lower() for name in args.regs.split(",")
                      if name.strip()]
    label = args.label or ("rva-%06x" % args.rva)
    record = {
        "utc": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
        "label": label,
        "client": "count-calls.py",
        "methodSha256": hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
        "tickHz": TICK_HZ,
        "rva": "0x%06X" % args.rva,
        "regsRequested": regs_requested,
        "sampleReg": args.sample_reg,
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
        address = base + args.rva
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
        word = ws.read_word(client, address)
        record["instructionWord"] = "0x%08X" % word
        if args.expect_jal is not None:
            expected = ws.jal_word(address, base + args.expect_jal)
            record["expectJal"] = "0x%06X" % args.expect_jal
            record["jalVerified"] = (word == expected)
            if word != expected:
                raise ws.WsError(
                    "instruction at 0x%08X is 0x%08X, expected jal to "
                    "base+0x%06X (0x%08X)"
                    % (address, word, args.expect_jal, expected))
        client.request("cpu.breakpoint.add",
                       {"address": address, "enabled": True, "log": False})
        added = True
        wall_start = time.monotonic()
        first_tick = None
        last_tick = None
        end_reason = None
        while True:
            status = client.request("cpu.status")
            now = time.monotonic()
            if status.get("stepping"):
                if status.get("pc") != address:
                    raise ws.WsError("unexpected CPU stop outside owned breakpoint")
                tick = status.get("ticks")
                if first_tick is None:
                    first_tick = tick
                last_tick = tick
                registers = flatten_regs(client.request("cpu.getAllRegs"))
                stop = {"tick": tick, "pc": status.get("pc")}
                for name in regs_requested:
                    stop[name] = registers.get(name)
                if (args.sample_reg and args.sample_first > 0
                        and len(record["stops"]) < args.sample_first):
                    sample_address = registers.get(args.sample_reg.lower())
                    if sample_address:
                        try:
                            memory = client.request(
                                "memory.read",
                                {"address": sample_address,
                                 "size": args.sample_size,
                                 "replacements": False})
                            stop["sample"] = {
                                "reg": args.sample_reg.lower(),
                                "address": "0x%08X" % sample_address,
                                "base64": memory.get("base64", ""),
                            }
                        except Exception as sample_error:
                            stop["sample"] = {
                                "reg": args.sample_reg.lower(),
                                "address": "0x%08X" % sample_address,
                                "error": str(sample_error),
                            }
                record["stops"].append(stop)
                client.request("cpu.resume", no_reply=True,
                               delay_ms=args.resume_delay_ms)
                if len(record["stops"]) >= args.max_stops:
                    end_reason = "maxStops"
                    break
                if ((last_tick - first_tick) / TICK_HZ >= args.window_emu):
                    end_reason = "window"
                    break
            else:
                if (first_tick is None
                        and now - wall_start > args.first_stop_timeout):
                    end_reason = "noFirstStop"
                    break
                if now - wall_start > args.wall_max:
                    end_reason = "wallTimeout"
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
        wall_seconds = time.monotonic() - wall_start
        stops = record["stops"]
        n = len(stops)
        emu_seconds = 0.0
        if n >= 2 and first_tick is not None and last_tick is not None:
            emu_seconds = (last_tick - first_tick) / TICK_HZ
        rate = None
        if n >= 2 and emu_seconds > 0:
            rate = (n - 1) / emu_seconds
        ra_values = sorted({stop.get("ra") for stop in stops
                            if stop.get("ra") is not None})
        record["window"] = {
            "targetEmuSeconds": args.window_emu,
            "emuSeconds": emu_seconds,
            "wallSeconds": wall_seconds,
            "stopCount": n,
            "ratePerEmuSecond": rate,
            "ratePerWallSecond": (n / wall_seconds) if wall_seconds > 0 else None,
            "absent": n == 0,
            "endReason": end_reason,
            "uniqueRa": ["0x%08X" % value for value in ra_values],
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
                status = client.request("cpu.status")
                if status.get("stepping"):
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
        rate = window.get("ratePerEmuSecond")
        summary = {
            "result": record.get("result"),
            "label": label,
            "stops": window.get("stopCount"),
            "emuSeconds": round(window.get("emuSeconds", 0.0), 3),
            "ratePerEmuSecond": (round(rate, 3) if rate is not None else None),
            "endReason": window.get("endReason"),
            "stateBefore": (record.get("stateBefore") or {}).get("state"),
            "stateAfter": (record.get("stateAfter") or {}).get("state"),
            "out": str(out),
        }
        print(json.dumps(summary, sort_keys=True))


if __name__ == "__main__":
    main()
