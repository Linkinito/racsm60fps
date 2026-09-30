#!/usr/bin/env python3
"""Half-step arm for the waterfall particle mover (animator base+0xDE23C).

Measured 2026-09-26 (waterfall-003): in C1 the animator runs 119.878/s
(59.941/s in A0) with identical per-call code, so every particle in the two
water pools advances 2x per real second. This arm skips every other animator
invocation per pool instance, so each instance updates 30/s in C1 = the A0
dynamics. Scratch registers t0/t1/t2 only; ra and s4 semantics preserved.

Sites (runtime words, base 0x09139D00 guarded):
  0xDE240  sw r20,88(sp)   0xAFB40058 -> 0x0E569480  (jal 0x095A5200)
  0xDE244  or t9,a0,zero   0x0080C825 -> 0x00000000  (nop delay slot)
The stub at 0x095A5200 flips a per-instance parity byte keyed by a0
((a0>>5)&0xFC; slots at 0x095A5100). Even: replay the two words, continue at
0xDE248. Odd: restore sp (+112), jump to the walker continuation 0x091C6E5C
(the guarded jalr at 0x8CE54 always returns there). Apply only in C1.

WARNING (2026-09-26): v1 FAILED - applying this killed the pool walk on the
first skip (the walker needs the animator's `v0`; jalr 0x8CE54 went dead and
the scene froze). Do not re-apply. Kept as evidence for the v2 design in
CURRENT_STATE.md.

Usage:
  apply-particle-halfstep.py --apply --expect-state C1 --json-out <path>
  apply-particle-halfstep.py --revert --json-out <path>
  apply-particle-halfstep.py --verify
"""

import argparse
import base64
import importlib.util
import json
from pathlib import Path
import time

REPO = Path(__file__).resolve().parents[2]
CLIENT_PATH = REPO / "research/live-tests/pokitaru/waterfall-001/ppsspp-ws.py"
BASE_EXPECTED = 0x09139D00
SITE_A = (0xDE240, 0xAFB40058, 0x0E569480)
SITE_B = (0xDE244, 0x0080C825, 0x00000000)
JALR_GUARD = (0x8CE54, 0x0100F809)
CAVE = 0x095A5200
SLOTS = 0x095A5100
SLOT_BYTES = 0x100
STUB = [
    0x00044942,  # srl t1,a0,5
    0x312900FC,  # andi t1,t1,0xFC
    0x3C08095A,  # lui t0,0x095A
    0x01094021,  # addu t0,t0,t1
    0x91090100,  # lbu t1,0x100(t0)
    0x39290001,  # xori t1,t1,1
    0xA1090100,  # sb t1,0x100(t0)
    0x11200005,  # beq t1,zero,+5
    0x00000000,  # nop
    0xAFB40058,  # sw r20,88(sp)   replay
    0x0080C825,  # or t9,a0,zero   replay
    0x03E00008,  # jr ra
    0x00000000,  # nop
    0x27BD0070,  # addiu sp,sp,112
    0x3C0A091C,  # lui t2,0x091C
    0x254A6E5C,  # addiu t2,t2,0x6E5C
    0x01400008,  # jr t2
    0x00000000,  # nop
]
CAVE_BYTES = len(STUB) * 4
FREE_SPAN = SLOT_BYTES + CAVE_BYTES + 0x48


def load_client():
    spec = importlib.util.spec_from_file_location("ppsspp_ws", CLIENT_PATH)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    module.ALLOWED |= {"memory.breakpoint.list"}
    return module


class Writer(load_client().DebuggerClient):
    def write_word(self, address, word):
        self.seq += 1
        ticket = "hs-%d" % self.seq
        self._send_frame(json.dumps({
            "event": "memory.write_u32", "ticket": ticket,
            "address": address, "value": word}).encode())
        deadline = time.monotonic() + 15.0
        while True:
            reply = json.loads(self._recv_message())
            if reply.get("ticket") == ticket:
                if reply.get("event") == "error":
                    raise RuntimeError("write refused: %s" % json.dumps(reply))
                return reply
            if time.monotonic() > deadline:
                raise RuntimeError("write reply timeout")


def read_bytes(client, address, size):
    response = client.request("memory.read",
                              {"address": address, "size": size,
                               "replacements": False})
    return base64.b64decode(response.get("base64", ""))


def main():
    parser = argparse.ArgumentParser(description="particle half-step arm")
    parser.add_argument("--apply", action="store_true")
    parser.add_argument("--revert", action="store_true")
    parser.add_argument("--verify", action="store_true")
    parser.add_argument("--expect-state", default=None)
    parser.add_argument("--json-out", default=None)
    parser.add_argument("--port", type=int, default=60907)
    args = parser.parse_args()
    if sum((args.apply, args.revert, args.verify)) != 1:
        parser.error("choose exactly one of --apply / --revert / --verify")
    mode = "apply" if args.apply else ("revert" if args.revert else "verify")
    ws = load_client()
    client = Writer("127.0.0.1", args.port)
    client.connect()
    record = {"utc": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
              "tool": "apply-particle-halfstep.py", "mode": mode,
              "stub": ["0x%08X" % word for word in STUB],
              "result": None}
    written = []
    try:
        game = client.request("game.status").get("game", {})
        if game.get("id") != "UCES00420":
            raise RuntimeError("wrong game: %s" % game.get("id"))
        active = [m for m in
                  client.request("hle.module.list").get("modules", [])
                  if m.get("name") == "rcp1" and m.get("isActive")]
        if len(active) != 1:
            raise RuntimeError("active rcp1 count %d" % len(active))
        base = active[0]["address"]
        if base != BASE_EXPECTED:
            raise RuntimeError("base 0x%08X != 0x%08X" % (base, BASE_EXPECTED))
        record["base"] = "0x%08X" % base
        record["state"] = ws.decode_state(client, base)["state"]
        if args.expect_state and record["state"] != args.expect_state:
            raise RuntimeError("state %s != %s"
                               % (record["state"], args.expect_state))
        if client.request("cpu.breakpoint.list").get("breakpoints"):
            raise RuntimeError("code breakpoints active")
        if client.request("memory.breakpoint.list").get("breakpoints"):
            raise RuntimeError("memory breakpoints active")
        addr_a, before_a, after_a = SITE_A
        addr_b, before_b, after_b = SITE_B
        word_a = ws.read_word(client, base + addr_a)
        word_b = ws.read_word(client, base + addr_b)
        jalr = ws.read_word(client, base + JALR_GUARD[0])
        record["observed"] = {"siteA": "0x%08X" % word_a,
                              "siteB": "0x%08X" % word_b,
                              "jalr": "0x%08X" % jalr}
        if jalr != JALR_GUARD[1]:
            raise RuntimeError("guard: 0x8CE54 is 0x%08X, not jalr t0" % jalr)
        if mode == "verify":
            if word_a == after_a and word_b == after_b:
                record["verdict"] = "APPLIED"
            elif word_a == before_a and word_b == before_b:
                record["verdict"] = "VANILLA"
            else:
                record["verdict"] = "OTHER"
            record["stubPresent"] = all(
                ws.read_word(client, CAVE + 4 * index) == word
                for index, word in enumerate(STUB))
            record["result"] = "PASS"
        elif mode == "apply":
            if word_a != before_a or word_b != before_b:
                raise RuntimeError("guard: site words not vanilla")
            if any(read_bytes(client, SLOTS, FREE_SPAN)):
                raise RuntimeError("guard: cave/region not zero")
            for index, word in enumerate(STUB):
                client.write_word(CAVE + 4 * index, word)
                written.append((CAVE + 4 * index, 0))
            client.write_word(base + addr_a, after_a)
            written.append((base + addr_a, before_a))
            client.write_word(base + addr_b, after_b)
            written.append((base + addr_b, before_b))
            for index, word in enumerate(STUB):
                if ws.read_word(client, CAVE + 4 * index) != word:
                    raise RuntimeError("stub read-back mismatch at 0x%08X"
                                       % (CAVE + 4 * index))
            if ws.read_word(client, base + addr_a) != after_a:
                raise RuntimeError("site A read-back mismatch")
            if ws.read_word(client, base + addr_b) != after_b:
                raise RuntimeError("site B read-back mismatch")
            record["result"] = "PASS"
        else:
            if word_a != after_a or word_b != after_b:
                raise RuntimeError("guard: patch not applied")
            for index, word in enumerate(STUB):
                if ws.read_word(client, CAVE + 4 * index) != word:
                    raise RuntimeError("guard: stub word %d differs" % index)
            client.write_word(base + addr_a, before_a)
            written.append((base + addr_a, after_a))
            client.write_word(base + addr_b, before_b)
            written.append((base + addr_b, after_b))
            for index in range(len(STUB)):
                client.write_word(CAVE + 4 * index, 0)
                written.append((CAVE + 4 * index, STUB[index]))
            slots = read_bytes(client, SLOTS, SLOT_BYTES)
            for offset in range(0, SLOT_BYTES, 4):
                word = int.from_bytes(slots[offset:offset + 4], "little")
                if word:
                    client.write_word(SLOTS + offset, 0)
                    written.append((SLOTS + offset, word))
            if ws.read_word(client, base + addr_a) != before_a:
                raise RuntimeError("revert read-back mismatch at site A")
            if ws.read_word(client, base + addr_b) != before_b:
                raise RuntimeError("revert read-back mismatch at site B")
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
        if args.json_out:
            out = Path(args.json_out)
            if not out.is_absolute():
                out = REPO / out
            out.parent.mkdir(parents=True, exist_ok=True)
            out.write_text(json.dumps(record, indent=1), encoding="utf-8")
        print(json.dumps({key: record.get(key) for key in
                          ("result", "mode", "state", "verdict",
                           "stubPresent", "observed", "error")},
                         sort_keys=True))


if __name__ == "__main__":
    main()
