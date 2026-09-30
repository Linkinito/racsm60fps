#!/usr/bin/env python3
"""Switch the live UCES00420 LEVEL_01 (Pokitaru) module between A0, C1 and the
waterfall-candidate arm, in RAM.

Guarded experiment for the owner's 2026-09-23 Pokitaru waterfall session. It
never changes a PRX file, savestate, player input, or arbitrary memory. The
allowlist covers exactly the three core timing words (tracked LEVEL_01 image,
verified live) plus the two waterfall-only constants coming from the offline
recipe candidate (`patches/experimental/waterfall-halfstep/`).

Modes:
  A0      restore all seven words to the vanilla values;
  C1      arm the core 60 Hz state (wait=0, delta=1/60, two passes -> one);
  C1WFC   C1 plus the waterfall half-step candidate
          (0x2D4890 1/60 -> 1/120, 0x2D4894 0.025 -> 0.0125);
  C1WFCB  C1WFC plus the butterfly rotation-cap candidate
          (0x2CED8C and 0x2CEDBC 0.1 -> 0.05; the shared WF-013 steering
          helper consumes these per-call rate limits).

Every write is preceded by a full read of the five words against the union of
known values, followed by a read-back, a final arm check, and an automatic
rollback of anything written in this run on failure.
"""

import argparse
import importlib.util
import json
from pathlib import Path
import time

REPO = Path(__file__).resolve().parents[2]
CLIENT_PATH = REPO / "research/live-tests/pokitaru/waterfall-001/ppsspp-ws.py"
BASE = 0x09139D00
SIZE = 0x46B900  # 4634880, live rcp1 for LEVEL_01

ARMS = {
    "A0": {
        0x96650: 0x0E4BE449,  # relocated first frame wait (RAM-resolved JAL)
        0x151E0: 0x3C043D08,  # shared delta 1/30
        0x2FCFC: 0x2A240002,  # two player passes
        0x2D4890: 0x3C888889,  # waterfall phase step 1/60
        0x2D4894: 0x3CCCCCCE,  # waterfall channel 0.025
        0x2CED8C: 0x3DCCCCCD,  # butterfly steer rate cap 0.1
        0x2CEDBC: 0x3DCCCCCD,  # butterfly steer rate cap 0.1 (second call)
    },
    "C1": {
        0x96650: 0x00000000,
        0x151E0: 0x3C043C88,
        0x2FCFC: 0x2A240001,
        0x2D4890: 0x3C888889,
        0x2D4894: 0x3CCCCCCE,
        0x2CED8C: 0x3DCCCCCD,
        0x2CEDBC: 0x3DCCCCCD,
    },
    "C1WFC": {
        0x96650: 0x00000000,
        0x151E0: 0x3C043C88,
        0x2FCFC: 0x2A240001,
        0x2D4890: 0x3C088889,
        0x2D4894: 0x3C4CCCCD,
        0x2CED8C: 0x3DCCCCCD,
        0x2CEDBC: 0x3DCCCCCD,
    },
    "C1WFCB": {
        0x96650: 0x00000000,
        0x151E0: 0x3C043C88,
        0x2FCFC: 0x2A240001,
        0x2D4890: 0x3C088889,
        0x2D4894: 0x3C4CCCCD,
        0x2CED8C: 0x3D4CCCCD,
        0x2CEDBC: 0x3D4CCCCD,
    },
}

SIGNATURES = {
    0x2FBBC: 0x46006506,   # untouched local scalar
    0x151D78: 0x27BDFF40,  # Level01Waterfall callback prologue
    0x122820: 0x27BDFF00,  # Butterfly callback prologue
}


def load_client():
    spec = importlib.util.spec_from_file_location("ppsspp_ws", CLIENT_PATH)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--arm", required=True, choices=tuple(ARMS))
    parser.add_argument("--port", type=int, default=60907)
    parser.add_argument("--json-out")
    args = parser.parse_args()
    ws = load_client()

    class Writer(ws.DebuggerClient):
        def write_word(self, rva, value):
            if rva not in ARMS["A0"]:
                raise ws.WsError("write refused outside LEVEL_01 allowlist: %#x" % rva)
            self.seq += 1
            ticket = "agent-%d" % self.seq
            self._send_frame(json.dumps({
                "event": "memory.write_u32", "ticket": ticket,
                "address": BASE + rva, "value": value,
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
    changed = []
    record = {"utc": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
              "arm": args.arm, "base": hex(BASE), "size": hex(SIZE), "writes": []}
    try:
        game = client.request("game.status").get("game", {})
        if game.get("id") != "UCES00420":
            raise ws.WsError("wrong game: %s" % game.get("id"))
        active = [m for m in client.request("hle.module.list").get("modules", [])
                  if m.get("name") == "rcp1" and m.get("isActive")]
        if len(active) != 1 or active[0].get("address") != BASE \
                or active[0].get("size") != SIZE:
            raise ws.WsError("wrong active module: %s" % active)
        cpu = client.request("cpu.status")
        if cpu.get("stepping") or cpu.get("paused"):
            raise ws.WsError("CPU is paused or stepping")
        if client.request("cpu.breakpoint.list").get("breakpoints"):
            raise ws.WsError("breakpoints are active")
        for rva, expected in SIGNATURES.items():
            actual = ws.read_word(client, BASE + rva)
            if actual != expected:
                raise ws.WsError("signature mismatch at %#x: %#x" % (rva, actual))
        allowed = {rva: {arm[rva] for arm in ARMS.values()} for rva in ARMS["A0"]}
        before = {rva: ws.read_word(client, BASE + rva) for rva in ARMS["A0"]}
        for rva, actual in before.items():
            if actual not in allowed[rva]:
                raise ws.WsError("unknown word at %#x: %#x" % (rva, actual))
        record["before"] = {hex(k): hex(v) for k, v in before.items()}
        target = ARMS[args.arm]
        for rva, want in target.items():
            if before[rva] == want:
                continue
            client.write_word(rva, want)
            actual = ws.read_word(client, BASE + rva)
            if actual != want:
                raise ws.WsError("readback failed at %#x: %#x" % (rva, actual))
            changed.append((rva, before[rva], want))
            record["writes"].append({"rva": hex(rva), "before": hex(before[rva]),
                                     "after": hex(want)})
        after = {rva: ws.read_word(client, BASE + rva) for rva in ARMS["A0"]}
        if after != target:
            raise ws.WsError("final guard words differ from requested arm")
        record["after"] = {hex(k): hex(v) for k, v in after.items()}
        record["result"] = "PASS"
    except Exception as error:
        record["result"] = "FAILED"
        record["error"] = str(error)
        for rva, original, written in reversed(changed):
            active = [m for m in client.request("hle.module.list").get("modules", [])
                      if m.get("name") == "rcp1" and m.get("isActive")]
            if len(active) != 1 or active[0].get("address") != BASE \
                    or active[0].get("size") != SIZE:
                break
            if ws.read_word(client, BASE + rva) == written:
                client.write_word(rva, original)
        raise
    finally:
        client.close()
        if args.json_out:
            out = Path(args.json_out)
            with out.open("x", encoding="utf-8") as handle:
                json.dump(record, handle, indent=2)
                handle.write("\n")
        print(json.dumps(record, sort_keys=True))


if __name__ == "__main__":
    main()
