#!/usr/bin/env python3
"""Halve per-instance butterfly animation/movement steps (RAM arm, reversible).

Chain measured live on 2026-09-23 (Butterfly update, RVA 0x122820):

  * movement    `position[obj+0x30..0x38] += direction[obj+0x20..0x28] * [s1+0x50]`
  * turn/steer  `direction[s1+0x20..0x28] += steer_vector * [s1+0x50]`  (same step)
  * flap phase  `phase[obj+0x70] += [s1+0x5C]`

Both the displacement and the turn rate scale with `[s1+0x50]`, the flap speed
with `[s1+0x5C]`; each is a static float per instance. Halving them restores the
A0 real-time rates of those channels when the frame rate doubles in C1.

Source of instances: a `raw-butterfly-*.json` transcript from
tools/runtime/watch-callback.py (unique a0 values).

Guards: object pointer, s1 pointer and current value are range-checked before
any write; every write is read back; the log keeps every active halved
(s1, field) pair and `--mode revert` restores all of them from that log.
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
LOG = REPO / "research/live-tests/pokitaru/waterfall-002-20260923/butterfly-step-arm.json"
FIELDS_LIMIT = {0x50: (0.001, 1.0), 0x5C: (0.001, 10.0)}


def load_client():
    spec = importlib.util.spec_from_file_location("ppsspp_ws", CLIENT_PATH)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--source", required=True,
                        help="watch-callback transcript with the a0 instances")
    parser.add_argument("--mode", required=True, choices=("halve", "revert"))
    parser.add_argument("--fields", default="0x5C",
                        help="comma-separated structure offsets, e.g. 0x50,0x5C")
    parser.add_argument("--port", type=int, default=60907)
    args = parser.parse_args()
    fields = [int(f, 0) for f in args.fields.split(",")]
    for field in fields:
        if field not in FIELDS_LIMIT:
            raise SystemExit("field %#x has no guard range" % field)
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

    def read(addr, size):
        reply = client.request("memory.read", {"address": addr, "size": size,
                                               "replacements": False})
        return base64.b64decode(reply.get("base64", ""))

    def f32(word):
        return struct.unpack("<f", struct.pack("<I", word))[0]

    def word_of(value):
        return struct.unpack("<I", struct.pack("<f", value))[0]

    log_records = {}
    if LOG.exists():
        previous = json.loads(LOG.read_text(encoding="utf-8"))
        for entry in previous.get("writes", []):
            log_records[(entry["s1"], entry.get("field", 0x5C))] = entry

    source = json.loads(Path(args.source).read_text(encoding="utf-8"))
    instances = sorted({s["a0"] for s in source["stops"]})
    record = {"utc": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
              "mode": args.mode, "source": str(args.source), "fields": fields,
              "newWrites": []}

    if args.mode == "revert":
        # current value is the logged "after"; write back the logged "before"
        plan = [(s1, field, entry["after"], entry["before"])
                for (s1, field), entry in log_records.items()]
    else:
        plan = []
        for a0 in instances:
            s1 = struct.unpack("<I", read(a0 + 0x54, 4))[0]
            if not (0x09000000 <= s1 <= 0x0A000000):
                raise ws.WsError("s1 out of range for 0x%08X: 0x%08X" % (a0, s1))
            for field in fields:
                word = struct.unpack("<I", read(s1 + field, 4))[0]
                value = f32(word)
                lo, hi = FIELDS_LIMIT[field]
                if value == 0.0:
                    continue  # dormant instance: nothing to halve
                if not (lo <= value <= hi):
                    raise ws.WsError("value out of range at s1=%#x+%#x: %r"
                                     % (s1, field, value))
                plan.append((s1, field, word, word_of(value / 2.0)))

    try:
        cpu = client.request("cpu.status")
        if cpu.get("stepping") or cpu.get("paused"):
            raise ws.WsError("CPU is paused or stepping")
        if client.request("cpu.breakpoint.list").get("breakpoints"):
            raise ws.WsError("breakpoints are active")
        for s1, field, before, after in plan:
            current = struct.unpack("<I", read(s1 + field, 4))[0]
            if current != before:
                raise ws.WsError("unexpected value at s1=%#x+%#x: %#x (want %#x)"
                                 % (s1, field, current, before))
            client.write_word(s1 + field, after)
            check = struct.unpack("<I", read(s1 + field, 4))[0]
            if check != after:
                raise ws.WsError("readback failed at s1=%#x+%#x: %#x"
                                 % (s1, field, check))
        record["result"] = "PASS"
    except Exception as error:
        record["result"] = "FAILED"
        record["error"] = str(error)
        raise
    finally:
        client.close()
        if record["result"] == "PASS":
            if args.mode == "halve":
                for s1, field, before, after in plan:
                    log_records[(s1, field)] = {
                        "s1": s1, "field": field, "before": before, "after": after,
                        "beforeFloat": f32(before), "afterFloat": f32(after),
                    }
            else:
                for s1, field, _, _ in plan:
                    log_records.pop((s1, field), None)
            record["writes"] = [log_records[key] for key in
                                sorted(log_records, key=lambda k: (k[1], k[0]))]
            LOG.write_text(json.dumps(record, indent=1), encoding="utf-8")
        print(json.dumps({"result": record["result"], "mode": args.mode,
                          "fields": ["0x%X" % f for f in fields],
                          "written": len(plan),
                          "logEntries": len(log_records),
                          "log": str(LOG)}, sort_keys=True))


if __name__ == "__main__":
    main()
