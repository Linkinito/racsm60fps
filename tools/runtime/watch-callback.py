#!/usr/bin/env python3
"""Watch one callback in the live UCES00420 module: true-stop it N times and
record, per stop, the tick count and the a0 object's bytes.

Read-only by construction: it adds exactly one temporary `log:false` breakpoint,
reads `cpu.status` / `cpu.getAllRegs` / `memory.read`, resumes, then removes the
breakpoint and verifies the cleanup. It never writes memory, registers, input,
savestates or configuration.

The four guard words are read before and after the run and decoded to the
A0 / C1 / other state model, so a capture cannot be silently attributed to the
wrong arm.

Usage:
  python tools/runtime/watch-callback.py --rva 0x122820 --stops 16 \
      --out research/live-tests/.../raw-butterfly-c1.json
"""

import argparse
import base64
import importlib.util
import json
from pathlib import Path
import time

REPO = Path(__file__).resolve().parents[2]
CLIENT_PATH = REPO / "research/live-tests/pokitaru/waterfall-001/ppsspp-ws.py"
BASE = 0x09139D00
GUARDS = {
    "wait": (0x96650, 0x0E4BE449, 0x00000000),
    "sharedDelta": (0x151E0, 0x3C043D08, 0x3C043C88),
    "loopThreshold": (0x2FCFC, 0x2A240002, 0x2A240001),
    "localScalar": (0x2FBBC, 0x46006506, 0x46006506),
}


def load_client():
    spec = importlib.util.spec_from_file_location("ppsspp_ws", CLIENT_PATH)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def decode_state(ws, client):
    words = {}
    words["wait"] = ws.read_word(client, BASE + GUARDS["wait"][0])
    words["sharedDelta"] = ws.read_word(client, BASE + GUARDS["sharedDelta"][0])
    words["loopThreshold"] = ws.read_word(client, BASE + GUARDS["loopThreshold"][0])
    words["localScalar"] = ws.read_word(client, BASE + GUARDS["localScalar"][0])
    if words == {k: v[1] for k, v in GUARDS.items()}:
        state = "A0"
    elif (words["wait"] == 0x00000000
          and words["sharedDelta"] == 0x3C043C88
          and words["loopThreshold"] == 0x2A240001
          and words["localScalar"] == 0x46006506):
        state = "C1"
    elif words["wait"] == 0x00000000 and words["sharedDelta"] == 0x3C043D08:
        state = "B0"
    else:
        state = "OTHER"
    return {"state": state,
            "words": {k: "0x%08X" % v for k, v in words.items()}}


def main():
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument("--rva", required=True, type=lambda x: int(x, 0))
    parser.add_argument("--stops", type=int, default=16)
    parser.add_argument("--size", type=int, default=128)
    parser.add_argument("--delay-ms", type=int, default=150)
    parser.add_argument("--out", required=True)
    parser.add_argument("--port", type=int, default=60907)
    args = parser.parse_args()
    ws = load_client()
    client = ws.DebuggerClient("127.0.0.1", args.port)
    client.connect()
    address = BASE + args.rva
    record = {"utc": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
              "rva": "0x%06X" % args.rva, "address": "0x%08X" % address,
              "stops": []}
    added = False
    try:
        game = client.request("game.status").get("game", {})
        if game.get("id") != "UCES00420":
            raise ws.WsError("wrong game: %s" % game.get("id"))
        active = [m for m in client.request("hle.module.list").get("modules", [])
                  if m.get("name") == "rcp1" and m.get("isActive")]
        if len(active) != 1 or active[0].get("address") != BASE:
            raise ws.WsError("wrong active module: %s" % active)
        cpu = client.request("cpu.status")
        if cpu.get("stepping") or cpu.get("paused"):
            raise ws.WsError("CPU is paused or stepping")
        if client.request("cpu.breakpoint.list").get("breakpoints"):
            raise ws.WsError("breakpoints already active")
        record["stateBefore"] = decode_state(ws, client)
        client.request("cpu.breakpoint.add",
                       {"address": address, "enabled": True, "log": False})
        added = True
        time.sleep(0.8)
        for _ in range(args.stops):
            status = client.request("cpu.status")
            deadline = time.monotonic() + 5.0
            while not status.get("stepping"):
                if time.monotonic() > deadline:
                    raise ws.WsError("no stop within 5 s")
                time.sleep(0.05)
                status = client.request("cpu.status")
            regs = client.request("cpu.getAllRegs")
            category = regs["categories"][0]
            names = category["registerNames"]
            values = category["uintValues"]
            a0 = values[names.index("a0")]
            memory = client.request("memory.read",
                                    {"address": a0, "size": args.size,
                                     "replacements": False})
            blob = base64.b64decode(memory.get("base64", ""))
            record["stops"].append({
                "ticks": status.get("ticks"),
                "pc": status.get("pc"),
                "a0": a0,
                "base64": base64.b64encode(blob).decode(),
            })
            client.request("cpu.resume", no_reply=True, delay_ms=args.delay_ms)
        client.request("cpu.breakpoint.remove", {"address": address})
        added = False
        status = client.request("cpu.status")
        if status.get("stepping"):
            client.request("cpu.resume", no_reply=True, delay_ms=100)
        record["breakpointsAfter"] = client.request(
            "cpu.breakpoint.list").get("breakpoints", [])
        record["stateAfter"] = decode_state(ws, client)
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
                    client.request("cpu.resume", no_reply=True, delay_ms=100)
            except Exception:
                pass
        client.close()
        out = Path(args.out)
        if not out.is_absolute():
            out = REPO / out
        out.write_text(json.dumps(record, indent=1), encoding="utf-8")
        print(json.dumps({"result": record.get("result"),
                          "stops": len(record["stops"]),
                          "stateBefore": record.get("stateBefore", {}).get("state"),
                          "stateAfter": record.get("stateAfter", {}).get("state"),
                          "out": str(out)}, sort_keys=True))


if __name__ == "__main__":
    main()
