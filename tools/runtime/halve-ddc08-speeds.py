#!/usr/bin/env python3
"""Halve (or restore) the two DDC08 emitter speed fields, live and reversible.

Identity test for the owner-visible Pokitaru water projections
(2026-09-26 waterfall-003 session). If the visible droplets/mist slow down
when these f32 fields halve, the visible particles come from a `0xDDC08`
pool (config `0x2D4918` or `0x2D4968`) and the field pair is a real speed
lever. This tool never touches an ISO, a PRX file, input, or savestates.

Guarded RAM arm: all four words are read first and must match the expected
before-image (arm) or after-image (revert); every write is read back; on any
failure everything written in this run is rolled back to its observed value,
and the result is logged to JSON.

Targets (base+RVA, f32 bits):
  +0x2D494C  30.0 (0x41F00000) <-> 15.0 (0x41700000)
  +0x2D4950  45.0 (0x42340000) <-> 22.5 (0x41B40000)
  +0x2D499C  45.0 (0x42340000) <-> 22.5 (0x41B40000)
  +0x2D49A0  60.0 (0x42700000) <-> 30.0 (0x41F00000)

Usage:
  python tools/runtime/halve-ddc08-speeds.py --mode arm --expect-state C1 \
      --json-out research/live-tests/pokitaru/waterfall-003-20260926/ddc08-speed-arm.json
  python tools/runtime/halve-ddc08-speeds.py --mode revert \
      --json-out research/live-tests/pokitaru/waterfall-003-20260926/ddc08-speed-revert.json
"""

import argparse
import importlib.util
import json
from pathlib import Path
import time

REPO = Path(__file__).resolve().parents[2]
CLIENT_PATH = REPO / "research/live-tests/pokitaru/waterfall-001/ppsspp-ws.py"
EXPECTED_BASE = 0x09139D00
TARGETS = [
    # (rva, before_bits, after_bits, label)
    (0x2D494C, 0x41F00000, 0x41700000, "cfg 0x2D4918 +0x34: 30.0 -> 15.0"),
    (0x2D4950, 0x42340000, 0x41B40000, "cfg 0x2D4918 +0x38: 45.0 -> 22.5"),
    (0x2D499C, 0x42340000, 0x41B40000, "cfg 0x2D4968 +0x34: 45.0 -> 22.5"),
    (0x2D49A0, 0x42700000, 0x41F00000, "cfg 0x2D4968 +0x38: 60.0 -> 30.0"),
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
        ticket = "arm-%d" % self.seq
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
    parser.add_argument("--mode", required=True, choices=("arm", "revert"))
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
        "tool": "halve-ddc08-speeds.py",
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
        want_from = 0 if args.mode == "arm" else 1
        want_to = 1 if args.mode == "arm" else 0
        plan = []
        for rva, before, after, label in TARGETS:
            address = base + rva
            current = ws.read_word(client, address)
            expected = before if want_from == 0 else after
            target = after if want_from == 0 else before
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
