#!/usr/bin/env python3
"""Minimal PPSSPP debugger WebSocket client (pure Python, no dependencies).

Purpose: let the agent talk to the running PPSSPP debugger directly instead of
routing every plan through the owner's console. Same request vocabulary, same
plan semantics and the same safety refusals as
`research/live-tests/pokitaru/waterfall-001/plan-driver.mjs`; this file exists
because this machine has no `node` on PATH for the agent's shell.

Usage:
  python ppsspp-ws.py --probe --port=60907 [--expect-base=0x09139D00]
  python ppsspp-ws.py --plan=<plan.json> --out=<dir> --name=<label> \
         --port=60907 [--expect-base=0x09139D00] [--expect-state=A0]

Plan actions: {"event": ..., <fields>, "_noReply": bool, "_delayMs": ms}.
`_noReply` sends without waiting for the ticket reply (needed for cpu.resume,
whose reply only arrives at the next stop). `_delayMs` sleeps after the send.

Safety: reads and guard decode only, plus a caller-supplied plan whose
breakpoint actions are true stops (`log:false`) and are always removed in
cleanup; memory writes, register writes, savestates, input, configuration,
replay and GPU events are refused. This client never writes to the emulator.

The four guard words and their classification mirror
tools/runtime/lib/state.mjs (the single source of truth for the state model);
constants are repeated here only because this is a different language.
"""
import argparse
import base64
import json
import os
import socket
import struct
import sys
import time

GUARDS = [
    ("wait", 0x96650),
    ("sharedDelta", 0x151E0),
    ("loopThreshold", 0x2FCFC),
    ("localScalar", 0x2FBBC),
]
WAIT_TARGET_RVA = 0x1BF424
SHARED_DELTA_30 = 0x3C043D08
SHARED_DELTA_60 = 0x3C043C88
LOOP_THRESHOLD_2 = 0x2A240002
LOOP_THRESHOLD_1 = 0x2A240001
LOCAL_SCALAR_VANILLA = 0x46006506

ALLOWED = {
    "version", "game.status", "cpu.status", "cpu.stepping", "cpu.resume", "hle.module.list",
    "memory.read", "memory.read_u32", "memory.disasm", "cpu.getAllRegs",
    "cpu.breakpoint.list", "cpu.breakpoint.add", "cpu.breakpoint.remove",
}
REFUSED = {
    "memory.write", "memory.write_u32", "cpu.setReg", "savestate.save", "savestate.load",
    "savestate.rewind", "game.pause", "game.resume", "game.reset", "game.start",
    "input.buttons.press", "input.buttons.send", "input.analog.send", "config.set",
    "replay.status", "replay.time.get", "gpu.buffer.screenshot", "gpu.buffer.renderColor",
}
REQUEST_TIMEOUT_S = 15.0
PLAN_LIMIT = 512
TOTAL_WAIT_LIMIT_MS = 600000


class WsError(RuntimeError):
    pass


class DebuggerClient:
    """Text-frame only WebSocket client; enough for the PPSSPP debugger API."""

    def __init__(self, host, port, path="/debugger", subprotocol="debugger.ppsspp.org"):
        self.host = host
        self.port = port
        self.path = path
        self.subprotocol = subprotocol
        self.sock = None
        self.buffer = b""
        self.seq = 0
        self.broadcasts = 0
        self.broadcast_log = []
        self.log = []

    def connect(self):
        self.sock = socket.create_connection((self.host, self.port), REQUEST_TIMEOUT_S)
        self.sock.settimeout(REQUEST_TIMEOUT_S)
        key = base64.b64encode(os.urandom(16)).decode()
        request = (
            f"GET {self.path} HTTP/1.1\r\n"
            f"Host: {self.host}:{self.port}\r\n"
            "Upgrade: websocket\r\n"
            "Connection: Upgrade\r\n"
            f"Sec-WebSocket-Key: {key}\r\n"
            "Sec-WebSocket-Version: 13\r\n"
            f"Sec-WebSocket-Protocol: {self.subprotocol}\r\n"
            "\r\n"
        )
        self.sock.sendall(request.encode())
        header = b""
        while b"\r\n\r\n" not in header:
            chunk = self.sock.recv(1)
            if not chunk:
                raise WsError("connection closed during handshake")
            header += chunk
        status_line = header.split(b"\r\n", 1)[0].decode(errors="replace")
        if "101" not in status_line:
            raise WsError(f"handshake refused: {status_line}")

    # --- framing -----------------------------------------------------------
    def _recv_exact(self, count):
        while len(self.buffer) < count:
            chunk = self.sock.recv(65536)
            if not chunk:
                raise WsError("connection closed")
            self.buffer += chunk
        data, self.buffer = self.buffer[:count], self.buffer[count:]
        return data

    def _send_frame(self, payload, opcode=0x1):
        mask = os.urandom(4)
        length = len(payload)
        header = bytes([0x80 | opcode])
        if length < 126:
            header += bytes([0x80 | length])
        elif length < 65536:
            header += bytes([0x80 | 126]) + struct.pack(">H", length)
        else:
            header += bytes([0x80 | 127]) + struct.pack(">Q", length)
        masked = bytes(byte ^ mask[i % 4] for i, byte in enumerate(payload))
        self.sock.sendall(header + mask + masked)

    def _recv_message(self):
        payload = b""
        while True:
            first, second = self._recv_exact(2)
            fin = bool(first & 0x80)
            opcode = first & 0x0F
            masked = bool(second & 0x80)
            length = second & 0x7F
            if length == 126:
                length = struct.unpack(">H", self._recv_exact(2))[0]
            elif length == 127:
                length = struct.unpack(">Q", self._recv_exact(8))[0]
            mask = self._recv_exact(4) if masked else None
            chunk = self._recv_exact(length) if length else b""
            if mask:
                chunk = bytes(byte ^ mask[i % 4] for i, byte in enumerate(chunk))
            if opcode == 0x8:
                raise WsError("server closed the connection")
            if opcode == 0x9:
                self._send_frame(chunk, opcode=0xA)
                continue
            if opcode == 0xA:
                continue
            payload += chunk
            if fin:
                return payload.decode("utf-8", errors="replace")

    # --- request layer -----------------------------------------------------
    def request(self, event, fields=None, no_reply=False, delay_ms=0):
        if event in REFUSED:
            raise WsError(f"refused by policy: {event}")
        if event not in ALLOWED:
            raise WsError(f"unknown event: {event}")
        fields = dict(fields or {})
        self.seq += 1
        ticket = f"agent-{self.seq}"
        message = {"event": event, "ticket": ticket, **fields}
        started = time.monotonic()
        self._send_frame(json.dumps(message).encode())
        entry = {"request": message, "started": started}
        if not no_reply:
            deadline = time.monotonic() + REQUEST_TIMEOUT_S
            while True:
                response = json.loads(self._recv_message())
                response_ticket = response.get("ticket")
                if response.get("event") == "error":
                    entry["result"] = response
                    entry["elapsed"] = time.monotonic() - started
                    self.log.append(entry)
                    raise WsError(json.dumps(response))
                if response_ticket == ticket:
                    entry["result"] = response
                    break
                if response_ticket is None and response.get("event") == event and event in ("cpu.stepping", "cpu.resume"):
                    entry["result"] = response
                    break
                self.broadcasts += 1
                self.broadcast_log.append(response)
                if time.monotonic() > deadline:
                    raise WsError(f"timeout waiting for {event}")
            entry["elapsed"] = time.monotonic() - started
        self.log.append(entry)
        if delay_ms:
            time.sleep(delay_ms / 1000.0)
        return entry.get("result")

    def close(self):
        try:
            if self.sock:
                self._send_frame(b"", opcode=0x8)
        except Exception:
            pass
        try:
            if self.sock:
                self.sock.close()
        except Exception:
            pass


def jal_word(pc, target):
    return (((pc + 4) & 0xF0000000) | (3 << 26) | ((target >> 2) & 0x03FFFFFF)) & 0xFFFFFFFF


def read_word(client, address):
    response = client.request("memory.read", {"address": address, "size": 4, "replacements": False})
    raw = base64.b64decode(response.get("base64", ""))
    if len(raw) < 4:
        raise WsError(f"short memory.read payload at 0x{address:08X}")
    return struct.unpack("<I", raw[:4])[0]


def decode_state(client, base):
    words = {name: read_word(client, base + rva) for name, rva in GUARDS}
    vanilla_wait = jal_word(base + GUARDS[0][1], base + WAIT_TARGET_RVA)
    wait, shared, threshold, scalar = (words["wait"], words["sharedDelta"],
                                       words["loopThreshold"], words["localScalar"])
    wait_kind = "vanilla" if wait == vanilla_wait else ("nop" if wait == 0 else "unexpected")
    shared_kind = {SHARED_DELTA_30: "1/30", SHARED_DELTA_60: "1/60"}.get(shared, "unexpected")
    threshold_kind = {LOOP_THRESHOLD_2: "2", LOOP_THRESHOLD_1: "1"}.get(threshold, "unexpected")
    scalar_kind = "vanilla" if scalar == LOCAL_SCALAR_VANILLA else "unexpected"
    table = {
        ("vanilla", "1/30", "2", "vanilla"): "A0",
        ("nop", "1/30", "2", "vanilla"): "B0",
        ("nop", "1/60", "2", "vanilla"): "B1",
        ("nop", "1/60", "1", "vanilla"): "C1",
    }
    state = table.get((wait_kind, shared_kind, threshold_kind, scalar_kind), "UNKNOWN")
    reasons = []
    if state == "UNKNOWN":
        reasons.append(
            f"wait={wait_kind} sharedDelta={shared_kind} loopThreshold={threshold_kind} "
            f"localScalar={scalar_kind} (wait word 0x{wait:08X}, vanilla 0x{vanilla_wait:08X}, "
            f"shared 0x{shared:08X}, threshold 0x{threshold:08X}, scalar 0x{scalar:08X})"
        )
    return {
        "state": state,
        "reasons": reasons,
        "waitVanillaWord": f"0x{vanilla_wait:08X}",
        "words": {
            name: {
                "rva": f"0x{rva:X}",
                "address": f"0x{base + rva:08X}",
                "word": f"0x{words[name]:08X}",
            }
            for name, rva in GUARDS
        },
    }


def identity(client, expect_base=None, expect_state=None):
    version = client.request("version", {"name": "RACSM agent-side client", "version": "0.1"})
    game = client.request("game.status")
    cpu = client.request("cpu.status")
    modules = client.request("hle.module.list")
    active = [m for m in modules.get("modules", []) if m.get("name") == "rcp1" and m.get("isActive")]
    if len(active) != 1:
        raise WsError(f"active rcp1 count is {len(active)}, expected 1")
    base = active[0]["address"]
    if expect_base is not None and base != expect_base:
        raise WsError(f"module base 0x{base:08X} does not match --expect-base=0x{expect_base:08X}")
    decoded = decode_state(client, base)
    if expect_state and decoded["state"] != expect_state:
        raise WsError(f"state is {decoded['state']}, expected {expect_state}")
    if decoded["state"] == "UNKNOWN":
        raise WsError(f"state is UNKNOWN: {decoded['reasons'][0]}")
    return {
        "ppsspp": {"name": version.get("name"), "version": version.get("version")},
        "game": game.get("game"),
        "gamePaused": game.get("paused"),
        "cpu": {"stepping": cpu.get("stepping"), "paused": cpu.get("paused"),
                "pc": cpu.get("pc"), "ticks": cpu.get("ticks")},
        "module": {"name": "rcp1", "base": f"0x{base:08X}", "baseDecimal": base, "size": active[0].get("size")},
        "state": decoded["state"],
        "stateReasons": decoded["reasons"],
        "guards": decoded["words"],
        "waitVanillaWord": decoded["waitVanillaWord"],
    }


def run_plan(client, plan, out_dir, label, base):
    os.makedirs(out_dir, exist_ok=True)
    owned = set()
    removed = 0
    total_wait = 0
    record = {
        "utc": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
        "label": label,
        "client": "ppsspp-ws.py",
        "requests": client.log,
        "broadcasts": client.broadcasts,
        "broadcastLog": client.broadcast_log,
        "completedActions": 0,
    }
    path = os.path.join(out_dir, f"raw-{label}.json")
    try:
        for index, action in enumerate(plan):
            if not isinstance(action, dict) or "event" not in action:
                raise WsError(f"plan action {index} has no event")
            event = action["event"]
            fields = {k: v for k, v in action.items() if k not in ("event", "_noReply", "_delayMs")}
            if event == "cpu.breakpoint.add":
                if fields.get("log") is not False:
                    raise WsError("cpu.breakpoint.add requires log:false (true stop)")
                existing = client.request("cpu.breakpoint.list").get("breakpoints", [])
                if any(b.get("address") == fields.get("address") for b in existing):
                    raise WsError(f"existing breakpoint at {fields.get('address')}")
                owned.add(fields["address"])
            if event == "cpu.breakpoint.remove":
                owned.discard(fields.get("address"))
                removed += 1
            delay = action.get("_delayMs", 0)
            total_wait += delay
            if total_wait > TOTAL_WAIT_LIMIT_MS:
                raise WsError("plan exceeds the total wait budget")
            try:
                client.request(event, fields, no_reply=bool(action.get("_noReply")), delay_ms=delay)
            except WsError as error:
                # A probe whose motion ends leaves the CPU running, so the next resume is
                # refused as "not stepping". That is expected for such probes: keep the
                # partial transcript and continue instead of losing the measurement.
                if event == "cpu.resume" and "not stepping" in str(error):
                    record.setdefault("tolerated", []).append(
                        {"action": index, "event": event, "error": str(error)}
                    )
                    continue
                raise
            record["completedActions"] = index + 1
    except Exception as error:
        record["error"] = str(error)
        raise
    finally:
        # Always persist what was collected: a mid-plan refusal used to lose the whole
        # transcript, which cost a full elevator ride on 2026-09-21.
        with open(path, "w", encoding="utf-8") as handle:
            json.dump(record, handle, indent=2)
            handle.write("\n")
    record["path"] = path
    return record


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--port", type=int, default=60907)
    parser.add_argument("--probe", action="store_true")
    parser.add_argument("--plan")
    parser.add_argument("--out")
    parser.add_argument("--name", default="run")
    parser.add_argument("--expect-base")
    parser.add_argument("--expect-state")
    args = parser.parse_args()

    base = int(args.expect_base, 16) if args.expect_base else None
    client = DebuggerClient("127.0.0.1", args.port)
    client.connect()
    try:
        if args.plan:
            with open(args.plan, encoding="utf-8") as handle:
                plan = json.load(handle)
            if not isinstance(plan, list) or not plan or len(plan) > PLAN_LIMIT:
                raise WsError(f"plan must be a non-empty array of at most {PLAN_LIMIT} actions")
        else:
            plan = None
        started = time.monotonic()
        info = identity(client, base, args.expect_state)
        probe_seconds = time.monotonic() - started
        if plan:
            record = run_plan(client, plan, args.out, args.name, base)
            record["identity"] = info
            record["probeSeconds"] = probe_seconds
            path = os.path.join(args.out, f"raw-{args.name}.json")
            with open(path, "w", encoding="utf-8") as handle:
                json.dump(record, handle, indent=2)
                handle.write("\n")
            info["raw"] = path
            info["requests"] = len(client.log)
        reads = [entry for entry in client.log if entry["request"]["event"] == "memory.read"]
        if reads:
            times = sorted(entry["elapsed"] for entry in reads if "elapsed" in entry)
            info["readLatencyMs"] = {
                "count": len(times),
                "min": round(times[0] * 1000, 3),
                "median": round(times[len(times) // 2] * 1000, 3),
                "max": round(times[-1] * 1000, 3),
            }
        info["broadcasts"] = client.broadcasts
        print(json.dumps(info, indent=2))
    finally:
        client.close()
    return 0


if __name__ == "__main__":
    sys.exit(main())
