#!/usr/bin/env python3
"""Halve the texture-animation step pairs in the live LEVEL_01 module (RAM arm).

Measured 2026-09-23: three animation structures hold `+4/30 / -4/30` step pairs
next to their phase accumulators (e.g. phase at 0x093F6584 advancing by 4/30 per
frame). In C1 (60 fps) those scrolls run at exactly 2x the A0 real-time rate;
halving the steps restores the A0 rate. Reversible via the log.

Guarded: every word is read first and must hold the expected before (or after)
value; every write is read back; the log records before/after per address.
"""

import argparse
import base64
import importlib.util
import json
from pathlib import Path
import time

REPO = Path(__file__).resolve().parents[2]
CLIENT_PATH = REPO / "research/live-tests/pokitaru/waterfall-001/ppsspp-ws.py"
LOG = REPO / "research/live-tests/pokitaru/waterfall-002-20260923/texture-anim-arm.json"

BEFORE = 0x3E088889   # +4/30
AFTER = 0x3D888889    # +2/30
BEFORE_NEG = 0xBE088889
AFTER_NEG = 0xBD888889

WORDS = {
    0x093F657C: (BEFORE, AFTER),
    0x093F6580: (BEFORE_NEG, AFTER_NEG),
    0x093F65C0: (BEFORE, AFTER),
    0x093F65C4: (BEFORE_NEG, AFTER_NEG),
    0x093F65F8: (BEFORE, AFTER),
    0x093F65FC: (BEFORE_NEG, AFTER_NEG),
}
PHASES = [0x093F6584, 0x093F65C8, 0x093F6600]


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
              "mode": args.mode, "writes": [], "phasesBefore": {}, "phasesAfter": {}}
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
        for phase in PHASES:
            record["phasesBefore"][hex(phase)] = read_word(phase)
        for address, (before, after) in WORDS.items():
            target = after if args.mode == "halve" else before
            client.write_word(address, target)
            check = read_word(address)
            if check != target:
                raise ws.WsError("readback failed at %#x: %#x" % (address, check))
            record["writes"].append({"address": hex(address),
                                     "before": hex(before), "after": hex(after)})
        for phase in PHASES:
            record["phasesAfter"][hex(phase)] = read_word(phase)
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
