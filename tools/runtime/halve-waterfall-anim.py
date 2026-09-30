#!/usr/bin/env python3
"""Halve the waterfall animation paces (RAM arm, reversible).

Measured 2026-09-23 with a read watchpoint: the waterfall parameter block
(0x2D49B8, the Level01Waterfall class descriptor) is read every frame by the
animator at RVA 0xDED20. Its symmetric fields are:
  +0x20 / +0x24 : -/+10 deg (0.174533 rad)  interval limits
  +0x28 / +0x2C : -/+0.02                   paces
The paces drive per-frame angle/position advance, so they run 2x fast in C1.

This tool halves +0x28 and +0x2C only (the paces), keeping the interval limits.

Runtime targets: 0x0940E6E0 and 0x0940E6E4 (BASE 0x09139D00 + RVA 0x2D49B8).
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
LOG = REPO / "research/live-tests/pokitaru/waterfall-002-20260923/waterfall-anim-arm.json"
BASE = 0x09139D00
S3 = BASE + 0x2D49B8

BEFORE_NEG = struct.unpack("<I", struct.pack("<f", -0.02))[0]
AFTER_NEG = struct.unpack("<I", struct.pack("<f", -0.01))[0]
BEFORE_POS = struct.unpack("<I", struct.pack("<f", 0.02))[0]
AFTER_POS = struct.unpack("<I", struct.pack("<f", 0.01))[0]

WORDS = {
    S3 + 0x28: (BEFORE_NEG, AFTER_NEG),
    S3 + 0x2C: (BEFORE_POS, AFTER_POS),
}


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
        for address, (before, after) in WORDS.items():
            target = before if args.mode == "halve" else after
            current = read_word(address)
            if current != target:
                raise ws.WsError("unexpected word at %#x: %#x (want %#x)"
                                 % (address, current, target))
        for address, (before, after) in WORDS.items():
            target = after if args.mode == "halve" else before
            client.write_word(address, target)
            check = read_word(address)
            if check != target:
                raise ws.WsError("readback failed at %#x: %#x" % (address, check))
            record["writes"].append({"address": hex(address),
                                     "before": hex(before), "after": hex(after)})
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
