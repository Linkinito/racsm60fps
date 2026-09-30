#!/usr/bin/env python3
"""Switch the live UCES00420 LEVEL_03 module between A0 and C1 in RAM.

This is a guarded experiment for the owner's 2026-09-23 Lvl3Elevator test.
It never changes a PRX file, savestate, player input, or arbitrary memory.
The address and before-word allowlist was derived from the tracked LEVEL_03
image and checked against the live PPSSPP v1.20.4 module before the first arm.
"""

import argparse
import importlib.util
import json
from pathlib import Path
import time

REPO = Path(__file__).resolve().parents[2]
CLIENT_PATH = REPO / "research/live-tests/pokitaru/waterfall-001/ppsspp-ws.py"
BASE = 0x09139D00
SIZE = 0x481B00
WORDS = {
    0x9630C: (0x0E4C35F2, 0x00000000),  # relocated second frame wait
    0x14FD4: (0x3C043D08, 0x3C043C88),  # shared 1/30 -> 1/60
    0x2E0A4: (0x2A240002, 0x2A240001),  # two player passes -> one
}
SIGNATURES = {
    0x2DF64: 0x46006506,  # untouched local scalar
    0x153F1C: 0x27BDFF20,  # Lvl3Elevator callback prologue
}


def load_client():
    spec = importlib.util.spec_from_file_location("ppsspp_ws", CLIENT_PATH)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--arm", required=True, choices=("A0", "C1"))
    parser.add_argument("--port", type=int, default=60907)
    parser.add_argument("--json-out")
    args = parser.parse_args()
    ws = load_client()

    class Writer(ws.DebuggerClient):
        def write_word(self, rva, value):
            if rva not in WORDS or value not in WORDS[rva]:
                raise ws.WsError(f"write refused outside LEVEL_03 allowlist: {rva:#x}")
            self.seq += 1
            ticket = f"agent-{self.seq}"
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
            raise ws.WsError(f"wrong game: {game.get('id')}")
        active = [m for m in client.request("hle.module.list").get("modules", [])
                  if m.get("name") == "rcp1" and m.get("isActive")]
        if len(active) != 1 or active[0].get("address") != BASE or active[0].get("size") != SIZE:
            raise ws.WsError(f"wrong active module: {active}")
        cpu = client.request("cpu.status")
        if cpu.get("stepping") or cpu.get("paused"):
            raise ws.WsError("CPU is paused or stepping")
        if client.request("cpu.breakpoint.list").get("breakpoints"):
            raise ws.WsError("breakpoints are active")
        for rva, expected in SIGNATURES.items():
            actual = ws.read_word(client, BASE + rva)
            if actual != expected:
                raise ws.WsError(f"signature mismatch at {rva:#x}: {actual:#x}")
        before = {rva: ws.read_word(client, BASE + rva) for rva in WORDS}
        for rva, actual in before.items():
            if actual not in WORDS[rva]:
                raise ws.WsError(f"unknown word at {rva:#x}: {actual:#x}")
        record["before"] = {hex(k): hex(v) for k, v in before.items()}
        for rva, pair in WORDS.items():
            target = pair[0 if args.arm == "A0" else 1]
            if before[rva] == target:
                continue
            client.write_word(rva, target)
            actual = ws.read_word(client, BASE + rva)
            if actual != target:
                raise ws.WsError(f"readback failed at {rva:#x}: {actual:#x}")
            changed.append((rva, before[rva], target))
            record["writes"].append({"rva": hex(rva), "before": hex(before[rva]),
                                      "after": hex(target)})
        after = {rva: ws.read_word(client, BASE + rva) for rva in WORDS}
        wanted = {rva: pair[0 if args.arm == "A0" else 1]
                  for rva, pair in WORDS.items()}
        if after != wanted:
            raise ws.WsError("final guard words differ from requested arm")
        record["after"] = {hex(k): hex(v) for k, v in after.items()}
        record["result"] = "PASS"
    except Exception as error:
        record["result"] = "FAILED"
        record["error"] = str(error)
        for rva, original, written in reversed(changed):
            # Restore only the exact word we wrote in the same live module.
            active = [m for m in client.request("hle.module.list").get("modules", [])
                      if m.get("name") == "rcp1" and m.get("isActive")]
            if len(active) != 1 or active[0].get("address") != BASE or active[0].get("size") != SIZE:
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
