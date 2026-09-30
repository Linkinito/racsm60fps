#!/usr/bin/env python3
"""Halve the water-wave rotation pace (RAM arm, reversible).

Measured 2026-09-23 with a write watchpoint: the wave animator (function
0xF7C54) is built each frame from a rotation matrix produced by 0xF4678 with
angle `[obj+0x30]` (0.01309 rad = pi/8 / 30). The source pace is
`[obj+0x24]` = 22.5 (degrees), and the per-frame angle is that pace divided by
30 - a 30 fps conversion - so the wave field rotates 2x fast in C1.

Wave object (measured): 0x096ED210.
Targets: [+0x24] 22.5 -> 11.25 and [+0x30] 0.01309 -> 0.006545.

Guarded: expected values read first, read-back after, log written, reversible.
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
LOG = REPO / "research/live-tests/pokitaru/waterfall-002-20260923/wave-rotation-arm.json"
OBJ = 0x096ED210
WORDS = {
    OBJ + 0x24: (0x41B40000, struct.unpack("<I", struct.pack("<f", 11.25))[0]),
    OBJ + 0x30: (0x3C567751, struct.unpack("<I", struct.pack("<f", 0.013090 / 2))[0]),
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
