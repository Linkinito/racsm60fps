# Current parent checkpoint

* Project: Overcompensated V2 / UCES00420; Priority0 original30 -> faithful60.
* Branch: `v2-research`; last known checkpoint HEAD `b4fa4f90b175bce04f01eafeafbcb7a480da8615`.
* Active gameplay thread: `research/tasks/pokitaru-player-clock-001.md`.
* Latest static mission `player-clock-delta-producer-001`: WORKERS_COMPLETE / READY_FOR_PARENT and parent-accepted with corrections. No gameplay validation promoted.

## Routing

Deterministic script -> bounded read-only Luna -> external DeepSeek for mapping/provenance/falsification -> parent Sol/Astra for live PPSSPP experiments and causal arbitration.

DeepSeek remains read-only for runtime/gameplay research. No PPSSPP control or runtime memory writes.

## DeepSeek infrastructure

Worker launcher forces `deepseek-flash` / reasoning high.
Handoff target ~2000 chars/field; oversize is warning only.

Completed:
- `player-clock-live-evidence-002`: substantive research complete despite legacy packaging failure; do not rerun.
- `player-clock-consumer-map-001`: accepted static consumer/timing map.
- `player-clock-delta-producer-001`: accepted static delta-producer analysis.

Latest parent review:
`research/inbox/deepseek/missions/player-clock-delta-producer-001/parent-review.md`

## PLAYER-CLOCK current model

Live/static anchors:
- recorded `rcp1` base `0x09139D00`;
- state object address = `base + 0x337940`, yielding observed `0x09471640`;
- `0x2FB8C` outer player-update candidate;
- `0x360A4` once on normal path before substep loop;
- vanilla normal loop = 2 passes;
- historical B0 site `0x96650` removes conditional second `sceDisplayWaitVblankStart()`.

B0 -> 2x outer cadence remains UNTESTED.

### Delta producer correction

Correct call target:
`0x151E8 -> 0x88768`, NOT `0x884A4`.

`0x151E0/E4` construct vanilla `0x3D088889` (~1/30).
Delay slot `0x151EC` does `mtc1 a0,f20`.
Historical B1 changes only `0x151E0`, producing `0x3C888889` (~1/60).

`0x88768` immediately overwrites `a0`, never reads incoming delta, never touches
`f20`, and writes fixed profiler/min-tracker globals. Hidden B1 effect through
this callee is REJECTED.

The shared `f20` is forwarded to four consumers:
`0x87A84`, `0x6B7F4`, `0x2FFF0`, `0x6B618`.
Thus B1 changes one shared frame-delta mechanism with wider fan-out than the
player chain.

### Player-chain split domains

Inside `0x2FB8C`, vanilla `0x2FBBC` copies `f12 -> f20`.
Historical D doubles there, so the doubled scalar reaches:
- outer `0x360A4`;
- substep `0x39B74`;
- substep `0x1EBC4`.

Therefore `0x2FBBC` is too early for a clean split-domain design.

Candidate static architecture, NOT IMPLEMENTED:
- outer delta remains 1/60;
- loop becomes one pass;
- leave `0x2FC64` unchanged so `0x360A4` sees 1/60;
- reconstruct 1/30 only at substep call delay slots `0x2FCE8` and `0x2FCF4`.

### Critical +0x578 caveat

`0x360A4` writes `state+0x578 = delta * 30`.

With true outer 1/60, this becomes 0.5.
Its demonstrated readers (`0x328A0`, `0x42C04`) run per substep.

A0: 30 outer/s * 2 substeps * 1.0 = 60 units/s.
Naive split: 60 outer/s * 1 substep * 0.5 = 30 units/s.

Therefore a parity-preserving split must separately normalize `+0x578`
(e.g. candidate multiplier 60 or equivalent post-outer store). No patch choice
is approved before runtime evidence.

Substep domain is heterogeneous:
- incoming-delta consumer `0x32588`;
- indirect incoming-delta callback through `0x1EBC4`;
- hardcoded-1/60 consumers later in `0x39B74`;
- `+0x578`-driven consumers.

## Isolated PPSSPP lab

Path:
`research/live-tests/pokitaru/player-clock-001/isolated-20260919T150446Z/`

Historical PIDs/ports are stale; rediscover before use.
PPSSPP v1.20.4 isolated portable setup; preserve existing state.

LEVEL_01 SHA256:
`d10a81d076fb44987a45314a020cda2f7e8b39f860b957911ca9365464676571`

## Next DeepSeek mission — cross-level timing domains

Mission ID: `timing-domains-crosslevel-001`
Task: `research/tasks/timing-domains-crosslevel-001.md`
Roles: `explorer`, `mapper`, `skeptic`
Policy: read-only static research; no PPSSPP control; no runtime memory writes.

Purpose:
- resolve `0x2B0208 -> 0x148CEC`;
- derive structural signatures from the Pokitaru timing model;
- scan ALL available level/gameplay modules for homologous delta/substep/frame-sync mechanisms;
- extend classification beyond the player to enemies, weapons, damage, hazards, platforms/elevators, moving geometry, camera, breakables, pickups, scripted transitions, animations and cosmetics;
- reconcile matches with the existing 493-callsite / 59-family wrapper corpus;
- cross-check known historical x2 symptoms without treating them as proof;
- determine which timing domains are level-local vs engine-global;
- produce a cross-level timing-domain taxonomy, candidate architecture implications, deterministic scanner specification and <=12 prioritized runtime tests.

This mission is broader by design, so Explorer is required.
Do not run another broad timing mission in parallel.
The parent-controlled player A0->B0 cadence experiment remains the highest-priority live test after this static mission.

## NEXT ACTION — parent-controlled A0 -> B0

No more broad static mission is required before this experiment.

A0:
1. rediscover isolated PID/port and verify `rcp1`;
2. calibrate ticks in one free-running session;
3. log-only count `base+0x2FB8C`;
4. count loop/substep (`base+0x2FCB0` or `base+0x2FCFC`);
5. optionally count `base+0x360A4`;
6. sample `state+0x574`, `+0x578`, `+0x570`, `+0xF8`, `+0x95C`;
7. use `+0x9D4/+0x9D8` if active.

B0:
1. save exact relocated runtime word at `base+0x96650`;
2. write NOP only;
3. repeat identical measurements;
4. restore exact saved word and verify;
5. STOP and interpret.

Primary discriminator:
- outer cadence ratio ~2 and `+0x574` slope ratio ~2 => B0 premise corroborated;
- cadence ratio ~1 => premise falsified for this state;
- cadence ratio ~2 but slope ~1 => re-map delta before further patching.



## 2026-09-20 — Ghidra timing reconstruction checkpoint

A targeted Ghidra pass on vanilla `LEVEL_01.PRX` materially refined the timing model.

Key parent-reviewed findings:

- `0x360A4` is a true outer delta-driven timing-field update and runs before the two-pass player loop.
- `player+0x578 = dt*30` is not a generic timer scalar. `0x328A0` uses it to normalize per-update displacement into a 30 Hz-reference velocity estimate.
- Therefore the former candidate global `dt*60` rewrite for `+0x578` is rejected.
- `0x42C04` reuses the same normalized field in timer-like countdowns, proving one producer can have consumers with different timing semantics.
- `0x32588` is a direct incoming-delta countdown family and supports a split-domain design where selected substep consumers may still need an A0-equivalent `1/30`.
- `0x39B74` mixes explicit delta, normalized delta, pure per-call counters, hard-coded `1/60`, and hard-coded `1/30` in one function.
- `0x1EBC4` is strongly identified as `Player_WeaponUpdate`; its indirect weapon callback receives current weapon in `a0` and `f20` in `f12`.
- The Flamethrower historical `3 -> 6` site is a pseudo-random modulo selector, not proven deterministic frame decimation. Its causal damage path remains unresolved.
- LaserTracer contains a local static `30.0f` rate and an initializer with explicit `rate == 60.0f` branches and damping-style coefficients. XRef geography confines the known consumers to the LaserTracer/tracer implementation region. The game-wide master-clock interpretation is superseded.
- A raw pointer at `0x2DD1F8` points to the LaserTracer/tracer timing initializer at `0x14CA70`, explaining the lack of a direct `jal`.
- Four `0x250`-byte configuration records beginning at `0x2D360C` are strongly indicated by the LaserTracer code.

Detailed note:
`research/v2/ghidra-timing-findings-2026-09-20.md`

Next broad mission:
`research/tasks/timing-atlas-global-001.md`

Immediate scientific runtime gate remains A0 -> B0 outer-cadence measurement before promoting a new player-clock patch.

