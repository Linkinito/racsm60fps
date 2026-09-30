#!/usr/bin/env python3
"""Halve the waterfall particle launch speed (RAM arm, reversible).

Measured 2026-09-23: particles leave the waterfall with a launch speed of
[s3+0x30] = 60 units/s (the falling component measured live was -57.4/s =
60 * cos(17 deg), matching the emission angle). The particle animator moves
them `pos += vel` per frame and decrements their lifetime by 1 unit per frame,
so C1 runs both 2x fast. The lifetime decrement is handled by
halve-particle-timer.py; this tool halves the launch speed.

Target: 0x2D49E8 (Level01Waterfall parameter block +0x30), 60.0 -> 30.0.
Guarded, read-back, logged, reversible.
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
LOG = REPO / "research/live-tests/pokitaru/waterfall-002-20260923/particle-speed-arm.json"
TARGET = 0x09139D00 + 0x2D49E8
BEFORE = struct.unpack("<I", struct.pack("<f", 60.0))[0]
AFTER = struct.unpack("<I", struct.pack("<f", 30.0))[0]


def load_client():
    spec = importlib.util.spec_from_file_location("ppsspp_ws", CLIENT_PATH)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--mode", required=True, choices=("halve", "revert"))
    parser.add_argument("--port", type=int, default=60907)
    args = parser.parse_args()
    ws = load_client()

    class Writer(ws.DebuggerClient):
        def write_word(self, address, word):
            self.seq += 1
            ticket = "agent-%d" % self.seq
            self._send_frame(json.dumps({
                "event": "memory.write_u32", "ticket": ticket,
                "address": address, "value": word,
            }).encode())
            deadline = time.monotonic() + ws.REQUEST_TIMEOUT_S
            while True:
                reply = json.loads(self._recv_message())
                if reply.get("ticket") == ticket:
                    if reply.get("event") == "error":
                        raise ws.WsError(str(reply))
                    return reply
                if time.monotonic() > deadline:
                    raise ws.WsError("timeout waiting for memory.write_u32")

    client = Writer("127.0.0.1", args.port)
    client.connect()

    def read_word(address):
        reply = client.request("memory.read", {"address": address, "size": 4,
                                               "replacements": False})
        return int.from_bytes(base64.b64decode(reply.get("base64", ""))[:4], "little")

    record = {"utc": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
              "mode": args.mode, "writes": []}
    try:
        cpu = client.request("cpu.status")
        if cpu.get("stepping") or cpu.get("paused"):
            raise ws.WsError("CPU is paused or stepping")
        if client.request("cpu.breakpoint.list").get("breakpoints"):
            raise ws.WsError("breakpoints are active")
        expected = BEFORE if args.mode == "halve" else AFTER
        current = read_word(TARGET)
        if current != expected:
            raise ws.WsError("unexpected word at %#x: %#x (want %#x)"
                             % (TARGET, current, expected))
        target = AFTER if args.mode == "halve" else BEFORE
        client.write_word(TARGET, target)
        check = read_word(TARGET)
        if check != target:
            raise ws.WsError("readback failed at %#x: %#x" % (TARGET, check))
        record["writes"].append({"address": hex(TARGET),
                                 "before": hex(current), "after": hex(target)})
        record["result"] = "PASS"
    except Exception as error:
        record["result"] = "FAILED"
        record["error"] = str(error)
        raise
    finally:
        client.close()
        if record["result"] == "PASS":
            LOG.write_text(json.dumps(record, indent=1), encoding="utf-8")
        print(json.dumps({"result": record["result"], "mode": args.mode,
                          "writes": len(record["writes"]),
                          "log": str(LOG)}, sort_keys=True))


if __name__ == "__main__":
    main()
