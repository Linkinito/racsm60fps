#!/usr/bin/env python3
"""NOP (or restore) the three waterfall emitter calls, live and reversible.

Ablation arm for the waterfall-003 identity question: with the calls removed,
any owner-visible water projection or mist fed by `0xDDC08` (sites
`0x151FCC`/`0x152024`) or `0xDEC9C` (`0x1520E0`) can no longer spawn. If the
visible effect does not change at all, those emitters are not the visible
channel. The `v0` return of all three calls is unused by the callers
(checked), so the NOP is behaviourally inert apart from the missing emission.

Guarded RAM arm: every word is read first and must match its expected image
(original for nop, zero for restore); each write is read back; on failure
everything written in this run is rolled back. JSON log written.

Targets (base+RVA, word):
  +0x151FCC  0x0E485E42 (jal 0xDDC08)  <-> 0x00000000
  +0x152024  0x0E485E42 (jal 0xDDC08)  <-> 0x00000000
  +0x1520E0  0x0E486267 (jal 0xDEC9C)  <-> 0x00000000

Usage:
  python tools/runtime/nop-emitter-calls.py --mode nop --expect-state C1 \
      --json-out research/live-tests/pokitaru/waterfall-003-20260926/emitter-nop-arm.json
  python tools/runtime/nop-emitter-calls.py --mode restore \
      --json-out research/live-tests/pokitaru/waterfall-003-20260926/emitter-nop-restore.json
"""

import argparse
import importlib.util
import json
from pathlib import Path
import time

REPO = Path(__file__).resolve().parents[2]
CLIENT_PATH = REPO / "research/live-tests/pokitaru/waterfall-001/ppsspp-ws.py"
EXPECTED_BASE = 0x09139D00
NOP = 0x00000000
TARGETS = [
    (0x151FCC, 0x0E485E42, "DDC08 @ 0x151FCC (cfg 0x2D4918)"),
    (0x152024, 0x0E485E42, "DDC08 @ 0x152024 (cfg 0x2D4968)"),
    (0x1520E0, 0x0E486267, "DEC9C @ 0x1520E0 (cfg 0x2D49B8)"),
]


def load_client():
    spec = importlib.util.spec_from_file_location("ppsspp_ws", CLIENT_PATH)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    module.ALLOWED |= {"memory.breakpoint.list"}
    return module


class Writer(load_client().DebuggerClient):
    """Client variant that may send memory.write_u32 (used only by this arm)."""

    def write_word(self, address, word):
        self.seq += 1
        ticket = "nop-%d" % self.seq
        self._send_frame(json.dumps({
            "event": "memory.write_u32", "ticket": ticket,
            "address": address, "value": word,
        }).encode())
        deadline = time.monotonic() + 15.0
        while True:
            reply = json.loads(self._recv_message())
            if reply.get("ticket") == ticket:
                if reply.get("event") == "error":
                    raise RuntimeError("write refused: %s" % json.dumps(reply))
                return reply
            if time.monotonic() > deadline:
                raise RuntimeError("write reply timeout")


def main():
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument("--mode", required=True, choices=("nop", "restore"))
    parser.add_argument("--expect-state", default=None)
    parser.add_argument("--json-out", required=True)
    parser.add_argument("--port", type=int, default=60907)
    args = parser.parse_args()
    ws = load_client()
    client = Writer("127.0.0.1", args.port)
    client.connect()
    record = {
        "utc": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
        "mode": args.mode,
        "tool": "nop-emitter-calls.py",
        "targets": [],
        "result": None,
    }
    written = []
    try:
        game = client.request("game.status").get("game", {})
        if game.get("id") != "UCES00420":
            raise RuntimeError("wrong game: %s" % game.get("id"))
        modules = client.request("hle.module.list").get("modules", [])
        active = [m for m in modules
                  if m.get("name") == "rcp1" and m.get("isActive")]
        if len(active) != 1:
            raise RuntimeError("active rcp1 count is %d" % len(active))
        base = active[0]["address"]
        record["base"] = "0x%08X" % base
        if base != EXPECTED_BASE:
            raise RuntimeError("module base 0x%08X does not match 0x%08X"
                               % (base, EXPECTED_BASE))
        record["stateBefore"] = ws.decode_state(client, base)["state"]
        if (args.expect_state
                and record["stateBefore"] != args.expect_state):
            raise RuntimeError("state is %s, expected %s"
                               % (record["stateBefore"], args.expect_state))
        if client.request("cpu.breakpoint.list").get("breakpoints"):
            raise RuntimeError("code breakpoints active")
        if client.request("memory.breakpoint.list").get("breakpoints"):
            raise RuntimeError("memory breakpoints active")
        plan = []
        for rva, original, label in TARGETS:
            address = base + rva
            current = ws.read_word(client, address)
            expected = original if args.mode == "nop" else NOP
            target = NOP if args.mode == "nop" else original
            record["targets"].append({
                "label": label, "rva": "0x%06X" % rva,
                "address": "0x%08X" % address,
                "observed": "0x%08X" % current,
                "expectedFrom": "0x%08X" % expected,
                "write": "0x%08X" % target,
            })
            if current != expected:
                raise RuntimeError("0x%08X is 0x%08X, expected 0x%08X"
                                   % (address, current, expected))
            plan.append((address, current, target))
        for address, original, target in plan:
            client.write_word(address, target)
            written.append((address, original))
            readback = ws.read_word(client, address)
            if readback != target:
                raise RuntimeError("read-back mismatch at 0x%08X: 0x%08X"
                                   % (address, readback))
        record["stateAfter"] = ws.decode_state(client, base)["state"]
        record["result"] = "PASS"
    except Exception as error:
        record["error"] = str(error)
        for address, original in written:
            try:
                client.write_word(address, original)
            except Exception:
                pass
        record["result"] = "FAILED"
        raise
    finally:
        client.close()
        out = Path(args.json_out)
        if not out.is_absolute():
            out = REPO / out
        out.parent.mkdir(parents=True, exist_ok=True)
        out.write_text(json.dumps(record, indent=1), encoding="utf-8")
        print(json.dumps({"result": record.get("result"),
                          "mode": record.get("mode"),
                          "stateBefore": record.get("stateBefore"),
                          "targets": [{"rva": t["rva"], "observed": t["observed"],
                                       "write": t["write"]}
                                      for t in record["targets"]],
                          "error": record.get("error"),
                          "out": str(out)}, sort_keys=True))


if __name__ == "__main__":
    main()
