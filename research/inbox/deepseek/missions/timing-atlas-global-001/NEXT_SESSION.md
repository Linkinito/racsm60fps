# Next session — timing atlas / PLAYER-CLOCK-001

2026-09-20 parent arbitration checkpoint. Branch v2-research; review-start HEAD
c038b38b5c3ea30bac37e987165b42fe500c68a1. Reverify HEAD; unrelated dirty files
were intentionally preserved. No runtime work or workers ran in this review.

## Minimal entry

Read root AGENTS.md, CURRENT_STATE.md, then
`research/live-tests/pokitaru/player-clock-001/NEXT_RUNTIME_GATE.md`.
Open this mission's parent-review.md only for a disputed claim; do not reread all
three reports routinely. They are complete and parent-arbitrated, not tasks to rerun.

First command **only when a subsequent session authorizes runtime work**:

```powershell
Get-Process PPSSPPWindows64 -ErrorAction SilentlyContinue | Select-Object Id,Path
```

Discover listeners by returned PID and match the existing isolated executable
path; do not assume a PID, port, loaded base or scene. If missing, stop rather than
create another instance. The first debugger requests are read-only version,
game.status, cpu.status and hle.module.list after ownership verification.

## Scientific state to preserve

Shared level delta -> player outer -> conditional normal two-pass loop is supported.
Gate=1/0/post1; only 0x39B74/0x1EBC4 receive the loop's explicit delta. +0x578
is dt*30 with both N-VEL and N-TIMER consumers: never globally force dt*60.
0x1517C is phase-table-associated, not proven to run once per display frame.
The limiter branch at 0x96648 skips the second wait on inequality, executes it on
equality. B0's real-time effect remains UNTESTED. Weapon manager has three
callers; count 0x2FCF0 for player-substep attribution.

Class atlas breadth (150 L01 / 534 names), local tracer rate support and candidate
0x6EBE4 entity pump are preserved; they do not prove global ownership/cadence.
Post-loop gate restoration proves no second LaserTracer dispatch. LEVEL_07 R60
hits and L03 platform/fluid ownership remain unresolved. PT_LOAD-aware mapping
is mandatory; restored LEVEL_02 is 0037689a... with loop2.

## Load-bearing unknowns and next test

Does B0 double shared level/player cadence in the same controlled scene? Are
observations complete and low-overhead? Does +0x574 slope track measured outer
frequency while +0x578 stays1 in B0? What are the limiter branch fractions and
independent VBlank deltas? Does exact restored A0 reproduce baseline?

Run only the standalone A0/B0/restored-A0 gate. Seven primary sites: 0x1517C,
0x2FB8C, 0x39B74, 0x2FCF0, 0x96490, 0x96648, 0x96650. Preserve current
checkpoint lineage, normal progression/cheat distinctions, relocated raw words,
source/config hashes, inputs and pause state. Existing JIT/logging coverage must
be validated; the plan does not claim a complete executable logger exists.
If the observer cannot meet the gate, persist the precise blocker; do not infer
cadence from stopped traces or display FPS. No broad static mission is needed.

After B0, restore the exact saved loaded word, never the raw PRX constant, verify
the restored control and STOP for interpretation. Only then queue elevator,
entity-manager, tracer gate/rate, one enemy, one projectile, camera and Kalidon
ownership work. No correction patch, new emulator build or instance follows
automatically from this checkpoint.
