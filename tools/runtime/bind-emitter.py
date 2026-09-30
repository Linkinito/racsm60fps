#!/usr/bin/env python3
"""Bind one waterfall emitter call to the memory it writes, in the live module.

At the callsite true stop: snapshot the candidate regions and arm write
watchpoints over them. Every write stop records the writing PC and registers.
At the return-address stop: read the watchpoint hit counters, disarm, diff the
regions against the snapshot, and close the emission. Repeat for N emissions.

Read-only apart from temporary breakpoints (one code stop per callsite and per
return address, plus the write watchpoints armed only between them). The four
guard words are decoded before and after the run.

Usage:
  python tools/runtime/bind-emitter.py --site 0x1520E0 --return 0x1520E8 \
      --region 0x09D8B000:0x15000 --region 0x0915C000:0x2000 \
      --region 0x09439F00:0x200 --region 0x09FCD080:0x80 \
      --region 0x0940E600:0x200 --region 0x096EF000:0xC000 \
      --emissions 2 --expect-state C1 \
      --out research/live-tests/pokitaru/waterfall-003-20260926/raw-bind-c1-1520e0.json
"""

import argparse
import base64
import hashlib
import importlib.util
import json
from pathlib import Path
import time

REPO = Path(__file__).resolve().parents[2]
CLIENT_PATH = REPO / "research/live-tests/pokitaru/waterfall-001/ppsspp-ws.py"
GPR_WANT = ["at", "v0", "v1", "a0", "a1", "a2", "a3",
            "t0", "t1", "t2", "t3", "t4", "t5", "t6", "t7", "t8", "t9",
            "s0", "s1", "s2", "s3", "s4", "s5", "s6", "s7", "ra", "sp", "fp"]
READ_CHUNK = 0x4000


def load_client():
    spec = importlib.util.spec_from_file_location("ppsspp_ws", CLIENT_PATH)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    module.ALLOWED |= {"memory.breakpoint.add", "memory.breakpoint.remove",
                       "memory.breakpoint.list"}
    return module


def parse_region(text):
    address, size = text.split(":")
    return int(address, 0), int(size, 0)


def flatten_regs(response):
    registers = {}
    for category in response.get("categories", []):
        for name, value in zip(category.get("registerNames", []),
                               category.get("uintValues", [])):
            registers[name.lower()] = value
    return registers


def pick_regs(registers):
    return {name: registers.get(name) for name in GPR_WANT}


def read_region(client, address, size):
    data = b""
    offset = 0
    while offset < size:
        chunk = min(READ_CHUNK, size - offset)
        response = client.request("memory.read",
                                  {"address": address + offset, "size": chunk,
                                   "replacements": False})
        blob = base64.b64decode(response.get("base64", ""))
        if len(blob) < chunk:
            raise RuntimeError("short read at 0x%08X" % (address + offset))
        data += blob
        offset += chunk
    return data


def diff_runs(before, after, limit=32):
    runs = []
    index = 0
    length = len(before)
    while index < length:
        if before[index] == after[index]:
            index += 1
            continue
        start = index
        while index < length and before[index] != after[index]:
            index += 1
        run_length = index - start
        runs.append({
            "offset": start,
            "length": run_length,
            "before": before[start:start + limit].hex(),
            "after": after[start:start + limit].hex(),
        })
    return runs


def main():
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument("--site", required=True, type=lambda x: int(x, 0))
    parser.add_argument("--return", dest="return_rva", required=True,
                        type=lambda x: int(x, 0))
    parser.add_argument("--region", action="append", required=True)
    parser.add_argument("--emissions", type=int, default=2)
    parser.add_argument("--expect-jal", type=lambda x: int(x, 0), default=None)
    parser.add_argument("--expect-state", default=None)
    parser.add_argument("--stop-cap", type=int, default=400)
    parser.add_argument("--first-stop-timeout", type=float, default=20.0)
    parser.add_argument("--wall-max", type=float, default=240.0)
    parser.add_argument("--resume-delay-ms", type=int, default=10)
    parser.add_argument("--label", default=None)
    parser.add_argument("--out", required=True)
    parser.add_argument("--port", type=int, default=60907)
    args = parser.parse_args()
    regions = [parse_region(text) for text in args.region]
    ws = load_client()
    client = ws.DebuggerClient("127.0.0.1", args.port)
    client.connect()
    label = args.label or ("bind-%06x" % args.site)
    record = {
        "utc": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
        "label": label,
        "client": "bind-emitter.py",
        "siteRva": "0x%06X" % args.site,
        "returnRva": "0x%06X" % args.return_rva,
        "regions": [{"address": "0x%08X" % address, "size": size}
                    for address, size in regions],
        "emissions": [],
        "result": None,
    }
    code_armed = []
    mem_armed = []
    site_address = None
    return_address = None
    stop_count = 0
    end_reason = None

    def wait_for_stop(deadline):
        while time.monotonic() < deadline:
            status = client.request("cpu.status")
            if status.get("stepping"):
                return status
            time.sleep(0.005)
        return None

    def wait_running(timeout=0.05):
        deadline = time.monotonic() + timeout
        while time.monotonic() < deadline:
            if not client.request("cpu.status").get("stepping"):
                return True
            time.sleep(0.005)
        return False

    def resume():
        client.request("cpu.resume", no_reply=True,
                       delay_ms=args.resume_delay_ms)

    def arm_memory():
        armed = []
        for address, size in regions:
            client.request("memory.breakpoint.add", {
                "type": "memory", "address": address, "size": size,
                "read": False, "write": True, "change": False,
                "enabled": True, "log": False})
            armed.append((address, size))
        return armed

    def disarm_memory(armed):
        for address, size in armed:
            try:
                client.request("memory.breakpoint.remove",
                               {"address": address, "size": size})
            except Exception:
                pass

    def snapshot():
        shots = {}
        for address, size in regions:
            try:
                shots[address] = read_region(client, address, size)
            except Exception as error:
                shots[address] = None
                record.setdefault("snapshotErrors", []).append(
                    {"address": "0x%08X" % address, "error": str(error)})
        return shots

    try:
        game = client.request("game.status").get("game", {})
        if game.get("id") != "UCES00420":
            raise ws.WsError("wrong game: %s" % game.get("id"))
        modules = client.request("hle.module.list").get("modules", [])
        active = [m for m in modules
                  if m.get("name") == "rcp1" and m.get("isActive")]
        if len(active) != 1:
            raise ws.WsError("active rcp1 count is %d" % len(active))
        base = active[0]["address"]
        record["module"] = {"name": "rcp1", "base": "0x%08X" % base,
                            "size": active[0].get("size")}
        site_address = base + args.site
        return_address = base + args.return_rva
        cpu = client.request("cpu.status")
        if cpu.get("stepping") or cpu.get("paused"):
            raise ws.WsError("CPU is paused or stepping")
        if client.request("game.status").get("paused"):
            raise ws.WsError("game is paused")
        if client.request("cpu.breakpoint.list").get("breakpoints"):
            raise ws.WsError("code breakpoints already active")
        if client.request("memory.breakpoint.list").get("breakpoints"):
            raise ws.WsError("memory breakpoints already active")
        record["stateBefore"] = ws.decode_state(client, base)
        if (args.expect_state
                and record["stateBefore"]["state"] != args.expect_state):
            raise ws.WsError("state is %s, expected %s"
                             % (record["stateBefore"]["state"],
                                args.expect_state))
        if args.expect_jal is not None:
            word = ws.read_word(client, site_address)
            expected = ws.jal_word(site_address, base + args.expect_jal)
            if word != expected:
                raise ws.WsError("site 0x%08X is 0x%08X, not jal to 0x%06X"
                                 % (site_address, word, args.expect_jal))
            record["jalVerified"] = True
        # Same-block limitation (measured 2026-09-26): when two code
        # breakpoints share the instruction block containing the callsite
        # (the callsite and its return address are 8 bytes apart), only the
        # most recently added one triggers. Keep exactly one code breakpoint
        # listed at any time and alternate it: callsite while waiting for an
        # emission, return address while the call runs.
        client.request("cpu.breakpoint.add",
                       {"address": site_address, "enabled": True,
                        "log": False})
        code_armed = [site_address]

        wall_start = time.monotonic()
        current = None
        in_call = False
        while len(record["emissions"]) < args.emissions:
            if time.monotonic() - wall_start > args.wall_max:
                end_reason = "wallTimeout"
                break
            if stop_count > args.stop_cap:
                end_reason = "stopCap"
                break
            status = wait_for_stop(
                time.monotonic() + (args.first_stop_timeout
                                    if not record["emissions"]
                                    else 20.0))
            if status is None:
                end_reason = "noStop"
                break
            stop_count += 1
            pc = status.get("pc")
            tick = status.get("ticks")
            registers = flatten_regs(client.request("cpu.getAllRegs"))
            regs = pick_regs(registers)
            if not in_call:
                if pc != site_address:
                    record.setdefault("strays", []).append(
                        {"pc": pc, "ticks": tick, "phase": "waitSite"})
                    resume()
                    wait_running()
                    continue
                if mem_armed:
                    disarm_memory(mem_armed)
                    mem_armed = []
                current = {"siteTick": tick, "siteRegs": regs, "writes": [],
                           "snapshot": snapshot()}
                mem_armed = arm_memory()
                client.request("cpu.breakpoint.remove",
                               {"address": site_address})
                client.request("cpu.breakpoint.add",
                               {"address": return_address, "enabled": True,
                                "log": False})
                code_armed = [return_address]
                in_call = True
                resume()
                wait_running()
            elif pc != return_address:
                current["writes"].append({"pc": pc, "ticks": tick,
                                          "regs": regs})
                resume()
                wait_running()
            else:
                hits = client.request("memory.breakpoint.list").get(
                    "breakpoints", [])
                current["watchpointHits"] = [
                    {"address": "0x%08X" % bp.get("address", 0),
                     "size": bp.get("size"), "hits": bp.get("hits")}
                    for bp in hits]
                current["returnTick"] = tick
                current["returnRegs"] = regs
                after = snapshot()
                for address, size in regions:
                    before = current["snapshot"].get(address)
                    if before is None or after.get(address) is None:
                        continue
                    runs = diff_runs(before, after[address])
                    if runs:
                        current.setdefault("diffs", []).append({
                            "region": "0x%08X" % address,
                            "size": size,
                            "shaBefore": hashlib.sha256(before).hexdigest(),
                            "shaAfter": hashlib.sha256(after[address]).hexdigest(),
                            "runs": runs,
                        })
                current.pop("snapshot")
                record["emissions"].append(current)
                current = None
                disarm_memory(mem_armed)
                mem_armed = []
                client.request("cpu.breakpoint.remove",
                               {"address": return_address})
                code_armed = []
                in_call = False
                if len(record["emissions"]) >= args.emissions:
                    break
                client.request("cpu.breakpoint.add",
                               {"address": site_address, "enabled": True,
                                "log": False})
                code_armed = [site_address]
                resume()
                wait_running()
        record["endReason"] = end_reason
        record["stopCount"] = stop_count
        record["stateAfter"] = ws.decode_state(client, base)
        record["result"] = "PASS"
    except Exception as error:
        record["result"] = "FAILED"
        record["error"] = str(error)
        raise
    finally:
        disarm_memory(mem_armed)
        for address in code_armed:
            try:
                client.request("cpu.breakpoint.remove", {"address": address})
            except Exception:
                pass
        if client.request("cpu.status").get("stepping"):
            client.request("cpu.resume", no_reply=True, delay_ms=50)
        try:
            record["codeBreakpointsAfter"] = client.request(
                "cpu.breakpoint.list").get("breakpoints", [])
            record["memoryBreakpointsAfter"] = client.request(
                "memory.breakpoint.list").get("breakpoints", [])
        except Exception:
            pass
        client.close()
        out = Path(args.out)
        if not out.is_absolute():
            out = REPO / out
        out.parent.mkdir(parents=True, exist_ok=True)
        out.write_text(json.dumps(record, indent=1), encoding="utf-8")
        summary = {
            "result": record.get("result"),
            "label": label,
            "emissions": len(record["emissions"]),
            "writesPerEmission": [len(e.get("writes", []))
                                  for e in record["emissions"]],
            "diffRunsPerEmission": [sum(len(d.get("runs", []))
                                        for d in e.get("diffs", []))
                                    for e in record["emissions"]],
            "endReason": record.get("endReason"),
            "stateBefore": (record.get("stateBefore") or {}).get("state"),
            "stateAfter": (record.get("stateAfter") or {}).get("state"),
            "out": str(out),
        }
        print(json.dumps(summary, sort_keys=True))


if __name__ == "__main__":
    main()
