"""Catch the instruction that writes a given word, using a PPSSPP memory
breakpoint (write, no log). Prints the stop PC and registers, then cleanly
removes the watchpoint and resumes. Read-only apart from the temporary
watchpoint.
"""
import importlib.util
import json
import sys
import time

CLIENT = "research/live-tests/pokitaru/waterfall-001/ppsspp-ws.py"
spec = importlib.util.spec_from_file_location("wsc", CLIENT)
wsc = importlib.util.module_from_spec(spec)
spec.loader.exec_module(wsc)
wsc.ALLOWED |= {"memory.breakpoint.add", "memory.breakpoint.remove",
                "memory.breakpoint.list"}

address = int(sys.argv[1], 0) if len(sys.argv) > 1 else 0x093F0284
size = int(sys.argv[2], 0) if len(sys.argv) > 2 else 4

client = wsc.DebuggerClient("127.0.0.1", 60907)
client.connect()

added = False
try:
    status = client.request("cpu.status")
    if status.get("stepping"):
        client.request("cpu.resume", no_reply=True, delay_ms=100)
    print("existing mem bps:", client.request("memory.breakpoint.list"))
    reply = client.request("memory.breakpoint.add", {
        "type": "memory", "address": address, "size": size,
        "read": False, "write": True, "change": False,
        "enabled": True, "log": False,
    })
    added = True
    print("add reply:", json.dumps(reply)[:200])
    deadline = time.monotonic() + 8.0
    hit = None
    while time.monotonic() < deadline:
        status = client.request("cpu.status")
        if status.get("stepping"):
            hit = status
            break
        time.sleep(0.05)
    if hit is None:
        print("no write observed in 8 s")
    else:
        print("STOP: pc=0x%08X ticks=%s" % (hit.get("pc"), hit.get("ticks")))
        regs = client.request("cpu.getAllRegs")
        cat = regs["categories"][0]
        names = cat["registerNames"]
        values = cat["uintValues"]
        for key in ("at", "v0", "v1", "a0", "a1", "a2", "a3", "t0", "t1", "t2",
                    "t3", "s0", "s1", "s2", "s3", "ra", "sp"):
            if key in names:
                print("   %-3s = 0x%08X" % (key, values[names.index(key)]))
    print("mem bp list:", json.dumps(client.request("memory.breakpoint.list"))[:300])
finally:
    if added:
        try:
            client.request("memory.breakpoint.remove", {"address": address, "size": size})
        except Exception as error:
            print("remove failed:", error)
    status = client.request("cpu.status")
    if status.get("stepping"):
        client.request("cpu.resume", no_reply=True, delay_ms=100)
    print("cleanup list:", json.dumps(client.request("memory.breakpoint.list"))[:200])
    client.close()
