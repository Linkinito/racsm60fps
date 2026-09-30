#!/usr/bin/env python3
"""Probe which registered LEVEL_01 callbacks are live in the current scene.

For each (class, rva) entry of a scan list, this read-only tool adds ONE
temporary `log:false` breakpoint at base+rva, watches a short window, records
whether the CPU stopped (and how many times, plus the first stop tick), then
removes the breakpoint and resumes. It never writes memory, registers, input,
savestates or configuration.

Usage:
  python tools/runtime/probe-callbacks.py --list research/.../scan-list-level01.json \
      --wait 1.0 --out research/.../scan-level01-c1.json
"""

import argparse
import importlib.util
import json
from pathlib import Path
import time

REPO = Path(__file__).resolve().parents[2]
CLIENT_PATH = REPO / "research/live-tests/pokitaru/waterfall-001/ppsspp-ws.py"
BASE = 0x09139D00


def load_client():
    spec = importlib.util.spec_from_file_location("ppsspp_ws", CLIENT_PATH)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def main():
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument("--list", required=True)
    parser.add_argument("--wait", type=float, default=1.0,
                        help="observation window in seconds per callback")
    parser.add_argument("--out", required=True)
    parser.add_argument("--port", type=int, default=60907)
    args = parser.parse_args()
    ws = load_client()
    client = ws.DebuggerClient("127.0.0.1", args.port)
    client.connect()
    items = json.loads(Path(args.list).read_text(encoding="utf-8"))
    record = {"utc": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
              "waitSeconds": args.wait, "items": []}
    current = None
    try:
        game = client.request("game.status").get("game", {})
        if game.get("id") != "UCES00420":
            raise ws.WsError("wrong game: %s" % game.get("id"))
        if client.request("cpu.breakpoint.list").get("breakpoints"):
            raise ws.WsError("breakpoints already active")
        for item in items:
            address = BASE + int(item["rva"], 16)
            current = address
            client.request("cpu.breakpoint.add",
                           {"address": address, "enabled": True, "log": False})
            stops = 0
            first_tick = None
            deadline = time.monotonic() + args.wait
            while time.monotonic() < deadline:
                status = client.request("cpu.status")
                if status.get("stepping"):
                    stops += 1
                    if first_tick is None:
                        first_tick = status.get("ticks")
                    client.request("cpu.resume", no_reply=True, delay_ms=30)
                else:
                    time.sleep(0.03)
            client.request("cpu.breakpoint.remove", {"address": address})
            status = client.request("cpu.status")
            if status.get("stepping"):
                client.request("cpu.resume", no_reply=True, delay_ms=50)
            current = None
            record["items"].append({"class": item["class"], "rva": item["rva"],
                                    "stops": stops, "firstTick": first_tick})
            print("%-34s %-10s stops=%d" % (item["class"], item["rva"], stops),
                  flush=True)
        record["result"] = "PASS"
    except Exception as error:
        record["result"] = "FAILED"
        record["error"] = str(error)
        raise
    finally:
        if current is not None:
            try:
                client.request("cpu.breakpoint.remove", {"address": current})
                status = client.request("cpu.status")
                if status.get("stepping"):
                    client.request("cpu.resume", no_reply=True, delay_ms=50)
            except Exception:
                pass
        client.close()
        out = Path(args.out)
        if not out.is_absolute():
            out = REPO / out
        out.write_text(json.dumps(record, indent=1), encoding="utf-8")
        live = [i["class"] for i in record["items"] if i.get("stops")]
        print(json.dumps({"result": record.get("result"),
                          "probed": len(record["items"]),
                          "live": len(live),
                          "liveClasses": live,
                          "out": str(out)}, sort_keys=True))


if __name__ == "__main__":
    main()
