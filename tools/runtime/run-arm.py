#!/usr/bin/env python3
"""One measurement run: set the arm (A0/C1), optionally the FlamerGate gate, record, analyse.

Orchestrates existing tools so an A0 / C1 / C1+gate series is one command per
arm (the owner still reloads the savestate between arms):
  1. level-core.py --arm A0|C1 (three core words from the level map);
  2. optional flamer-gate.py --mode 0|1 --parity P (plugin memory only);
  3. recorder: sample-regions.py (breakpoint-free) or count-multi.py (one site);
  4. for sample recordings, analyze-samples.py with the given fields;
  5. optional restore to A0 (--restore-a0), and FlamerGate mode 0 if it was set.
Each step's command line and exit code go to <out>/run.json; recorder and
analysis outputs stay in <out>/ subdirectories.

Usage (Otto shield/health, C1 + gate):
  python tools/runtime/run-arm.py --map <levelmap.json> --arm C1 \
      --gate-manifest patches/experimental/flamer-gate/build/FG-v1/manifest.json --gate 1 --parity 1 \
      --recorder sample --region pvar=0x09DC2A00:0x800 --seconds 150 \
      --field st=0x18:u32 --field hp=0x24:f32 --field shield=0x30:f32 --state st --refill shield \
      --label C1G-otto --restore-a0 --out research/live-tests/quodrona/<dir>/c1g-otto
  (count recorder: --recorder count --site R=0x13ACD4:0x0160F809:regs=a0 --window-emu 20 --peek ...)
"""
import argparse
import json
import subprocess
import sys
import time
from pathlib import Path

REPO = Path(__file__).resolve().parents[2]
RT = REPO / "tools/runtime"


def main():
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument("--map", required=True, type=Path)
    ap.add_argument("--arm", required=True, choices=("A0", "C1"))
    ap.add_argument("--gate-manifest", type=Path)
    ap.add_argument("--gate", type=int, choices=(0, 1))
    ap.add_argument("--parity", type=int, choices=(0, 1), default=1)
    ap.add_argument("--recorder", required=True, choices=("sample", "count"))
    ap.add_argument("--region", action="append", default=[], help="sample: NAME=0xADDR:0xSIZE")
    ap.add_argument("--seconds", type=float, default=120.0)
    ap.add_argument("--interval", type=float, default=0.1)
    ap.add_argument("--field", action="append", default=[], help="analysis field on the first region")
    ap.add_argument("--state")
    ap.add_argument("--refill", action="append", default=[])
    ap.add_argument("--site", action="append", default=[], help="count: site spec (one site recommended)")
    ap.add_argument("--peek", action="append", default=[])
    ap.add_argument("--window-emu", type=float, default=20.0)
    ap.add_argument("--first-stop-timeout", type=float, default=120.0)
    ap.add_argument("--label", required=True)
    ap.add_argument("--note", default="")
    ap.add_argument("--restore-a0", action="store_true")
    ap.add_argument("--out", required=True, type=Path)
    a = ap.parse_args()
    if a.gate is not None and not a.gate_manifest:
        raise SystemExit("--gate needs --gate-manifest")
    if a.recorder == "sample" and not a.region:
        raise SystemExit("sample recorder needs --region")
    if a.recorder == "count" and not a.site:
        raise SystemExit("count recorder needs --site")
    a.out.mkdir(parents=True, exist_ok=False)
    py = sys.executable
    run = {"utc": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()), "label": a.label, "arm": a.arm,
           "gate": a.gate, "parity": a.parity, "steps": []}

    def step(name, cmd, required=True):
        r = subprocess.run([str(x) for x in cmd], cwd=REPO, text=True, capture_output=True)
        run["steps"].append({"name": name, "cmd": [str(x) for x in cmd], "exit": r.returncode,
                             "stdoutTail": r.stdout[-1500:], "stderrTail": r.stderr[-1500:]})
        print("[%s] exit %d" % (name, r.returncode))
        if r.returncode and required:
            raise RuntimeError("%s failed: %s" % (name, (r.stderr or r.stdout)[-500:]))
        return r

    gate_set = False
    try:
        step("arm", [py, RT / "level-core.py", "--map", a.map, "--arm", a.arm, "--out", a.out / "arm"])
        if a.gate is not None:
            step("gate", [py, RT / "flamer-gate.py", "--manifest", a.gate_manifest, "--map", a.map,
                          "--mode", a.gate, "--parity", a.parity, "--out", a.out / "gate"])
            gate_set = a.gate == 1
        note = "%s; arm %s; gate %s parity %s. %s" % (a.label, a.arm, a.gate, a.parity, a.note)
        if a.recorder == "sample":
            cmd = [py, RT / "sample-regions.py", "--map", a.map, "--interval", a.interval, "--seconds", a.seconds,
                   "--label", a.label, "--note", note, "--out", a.out / "record"]
            for r in a.region:
                cmd += ["--region", r]
            step("record", cmd)
            if a.field:
                region = a.region[0].split("=", 1)[0]
                cmd = [py, RT / "analyze-samples.py", "--samples", a.out / "record/samples.json", "--region", region,
                       "--json", a.out / "analysis.json"]
                for f in a.field:
                    cmd += ["--field", f]
                if a.state:
                    cmd += ["--state", a.state]
                for f in a.refill:
                    cmd += ["--refill", f]
                step("analyse", cmd)
        else:
            cmd = [py, RT / "count-multi.py", "--map", a.map, "--expect-state", a.arm, "--window-emu", a.window_emu,
                   "--first-stop-timeout", a.first_stop_timeout, "--label", a.label, "--note", note,
                   "--out", a.out / "record"]
            for s in a.site:
                cmd += ["--site", s]
            for p in a.peek:
                cmd += ["--peek", p]
            step("record", cmd)
    finally:
        if gate_set:
            step("gate-off", [py, RT / "flamer-gate.py", "--manifest", a.gate_manifest, "--mode", 0,
                              "--out", a.out / "gate-off"], required=False)
        if a.restore_a0:
            step("restore-a0", [py, RT / "level-core.py", "--map", a.map, "--arm", "A0", "--out", a.out / "restore"],
                 required=False)
        (a.out / "run.json").write_text(json.dumps(run, indent=1), encoding="utf-8")


if __name__ == "__main__":
    main()
