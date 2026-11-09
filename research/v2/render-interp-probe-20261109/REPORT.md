---
kind: measurement
title: "First read-only probe for render/logic separation (state C, Pokitaru slot 0)"
date: 2026-11-09
authors: ["Claude (Sonnet 5.5)"]
status: draft
evidence: [OBSERVED, UNKNOWN]
summary: "Counter, camera blocks, RNG and one crab entity sampled at ~80 ms; confirms 60 Hz logic writes in state C, does not yet answer whether rendering reads logic state directly."
systems: [timing, camera, interpolation]
levels: [Pokitaru]
variants: [C]
environment: "PPSSPP 1.20.4, savestate slot 0 (patched C memory, OC60-M2 active), rcp1 base 0x913CD00, tools/runtime/render-state-probe.py (read-only)"
supersedes: []
related: [research/v2/framerate-methods-20261006/EXTERNAL_AUDIT.md, research/live-tests/pokitaru/session-2026-09-30/SESSION-LOG.md]
---

# Why this probe

Earlier rejection of interpolation (InterpGate G/GI, 2026-09-30) blended the
`+0x30` position that the logic itself reads back, so it cannot say whether a
separate display copy is feasible. The open question is where rendering reads
moby/camera state. This probe only checks what changes per logic tick.

# Result (OBSERVED, one run, 60 samples, 4.98 emulated s, 80 ms spacing)

- Frame counter `0x2AF28C`: 1500 -> 1798, 59.8 per emulated second (state C, 60 Hz logic).
  4-10 ticks elapse between samples, so per-tick behavior is not resolved.
- Camera block `0x302FC4`: 12 of 16 words change in about every sample; block
  `0x369E40`: no word changes; block `0x369E80`: 13 of 16 words change. Roles of the
  blocks are not established here (view-matrix-like values only INFERRED).
- RNG word at `*(0x2DB90C)+0x58`: changes in 50 of 59 intervals.
- Crab entity `0x96F52F0` (slot-0 scenario): 10 of 32 words change.

# Limits / UNKNOWN

- State C only; a 30 Hz original (A) comparison needs a savestate under profile A
  (the slot-0 state holds patched memory, see abc-bench PROTOCOL).
- Polling cannot show whether the renderer reads these words after the logic finishes
  or before. That needs a read-breakpoint or a static trace of the display-list builder
  (one breakpoint at a time, GOTCHAS 7b, with a positive control).
- No parity or feasibility claim follows.

# Addendum: static render-side readers (INFERRED from local Ghidra decompilation)

Local decompiled C only (not published). `FUN_00071590` loops over a list of records
(`iVar9`), computes the squared distance `+0x30/+0x34/+0x38` minus a view position,
compares it with LOD radii at `+0x48`/`+0x50`, and calls draw function `FUN_000727d0`
passing the record pointer itself as `param_1`. `FUN_000727d0` builds the mesh
transform from `param_1` (position `+0x30` via `FUN_000f5540`, with camera block
`0x369E80`) and submits parts via `FUN_0007d978`. Reading: draw code takes the live
moby record and the live camera block, with no intermediate display copy seen in
these functions. This matches the layout in the findings doc (`+0x30` position),
but "iVar9 is a moby record" is INFERRED from offsets, not bound live. Other draw
paths (skinned limbs, particles, sky, HUD) were not read.

Consequence (INFERRED): a RT64-style interpolation here needs a new previous/current
copy of those records (or matrices) taken at tick end, and a hook that makes
`FUN_000727d0` (and sibling draw paths) read the blended copy. This is feasible in
principle for plain moby transforms but the 30 KB plugin budget and skinned
animation poses (not read) are the open cost. The earlier GI test failed because it
blended the live record that logic reads; a draw-only copy would avoid that.
Savestate note (owner, 2026-11-09): slots hold the patched C memory; an A baseline
needs a state made with profile A.

# Live binding of FUN_000727d0 (OBSERVED, 2026-11-09, state C, slot 0)

tools/runtime/count-calls.py, one temporary breakpoint at rcp1 RVA 0x727D0 (entry),
400 stops in 0.118 emulated s (about 3384 calls per emulated s, about 56 per 60 Hz
tick), PASS, breakpoint removed, state C before and after. Raw JSON stays in tmp/.

- `a0` takes 47 distinct values, all heap addresses (0x9728E28 ...); floats at
  `a0+0x30..0x38` of the sampled records are plausible world coordinates
  (e.g. 33.6, 2.2, 21.1), so the draw function does receive record pointers whose
  `+0x30` holds a world position: consistent with the static reading.
- Callers (ra, converted to RVA): 0x71AD0 (144 stops), 0x718F0 (112), 0x6F438 (96),
  others fewer. So several draw paths use this function, not only the loop read earlier.
- The crab entity 0x96F52F0 was not among the sampled `a0` values in this window
  (first 40 stops sampled, 47 pointers seen); not drawn through this function or
  not drawn in that window: UNKNOWN. Positive control for the breakpoint: it fired.
- Not shown: draw-after-update ordering within a tick, or whether the records are
  the same objects the logic updates (needs the crab/other moby bound via a0).

# Same record read by draw and updated by logic? (OBSERVED, 2026-11-09, second run)

Same breakpoint, 1500 stops in 0.55 emulated s, all `a0` sampled; then the 45
distinct `a0` addresses were re-read (`+0x30..0x38`, 80 ms spacing, 25 reads) with
no breakpoint set.

- 45 distinct records; the draw-time `+0x30` of 300/300 checked stops equals a later
  live read of the same address (the draw function reads the live record, not a copy).
- Only 1 of the 45 records changes position over about 2 s; 44 are static (scenery/props
  in the savestate scene). So only one case supports "draw reads a record logic is
  updating"; it was not identified (class/identity UNKNOWN).
- The crab (0x96F52F0) and nothing within 0x400 of it were drawn through this
  function in either run: animated/skinned characters probably use another draw path
  (INFERRED, unread). That path is the one interpolation would mostly need.
- Not tested: tick ordering (update then draw in the same tick), and any consumer of
  a previous-position field (none looked for).

Verdict, UNCHANGED level: draw reads live logic records (OBSERVED for static
mobys and one moving one); skinned character path UNKNOWN. A draw-only copy is
still the only design that avoids the GI failure; cost and skinned path remain open.

# Crab read-watch and the render-prep pass (OBSERVED live + INFERRED static, 2026-11-09)

New tool tools/runtime/read-watch.py (one temporary read memory breakpoint, removed after).
Watch on the crab entity `+0x30` (0x96F5320), 60 stops, state C:

- Four reader PCs, 15 stops each: 0x1356C0, 0x13589C, 0x135B10 (class-side code,
  functions 0x135654 / 0x1357C0 / 0x135A54, not read) and **0x6E8BC inside
  `P_GroupPump2` (function 0x6E6D4)**. The crab is therefore handled by the
  generic group pump 2, not by `FUN_000727d0`.
- Static reading of `P_GroupPump2` (local decompilation): for every live record
  (0x80-byte stride) it culls by squared distance from `+0x30..0x38` to the view
  position and by the LOD byte `+0x77`, sets/clears flags (`+0x64`, bit 0x200) and
  list links (`+0x4C`, `+0x50`), then for animated records (animation object pointer
  at `+0x48`) runs pose evaluation (`FUN_000769f4`, `FUN_000767b0`, `FUN_00076948`,
  `FUN_0006dde4`) and calls per-animation callbacks (`+0xD4`, `+0xDC`, `+0xE0` of the
  animation object) with the record as argument. The record starts with a 3x3 basis
  (floats 0..10) and position `+0x30` (INFERRED from the reads).
- Rates (count-calls, state C, 2.0 emulated s): `P_GroupPump2` 59.94 /s (121 calls),
  group pump 1 `0x6B7F4` 59.94 /s (121 calls). Both once per outer update, in
  lockstep. The 30 Hz original (A) was not measured here.

Consequence (INFERRED): the engine already has a separate render-preparation pass
(pump 2) after the logic pass (pump 1) that reads the live records. That is the
natural place for a blended copy. Open and decisive: whether the animation object's
callbacks and pose functions advance animation time (then running pump 2 twice per
logic tick would double animation speed) or only evaluate a pose at the current time
(then pump 2 can run at 60 Hz with blended inputs). UNKNOWN. Also unread:
class-side readers 0x1356C0/0x13589C/0x135B10 (could be logic or draw).

# Pose functions read no time step (INFERRED, static, 2026-11-09)

`FUN_00077098` (pose evaluation, called by `FUN_000767b0`), `FUN_000769f4`, `FUN_00076f64`,
`FUN_00076948`, `FUN_00077df4`: no 1/30 or 1/60 literal and no delta parameter in
the decompiled text (grep over the four small ones plus the first 70 lines of the
large one; the rest of `FUN_00077098`, 214 lines, only skimmed). `FUN_00077098` stamps
a cache entry with the frame counter (`piVar5[5] = DAT_002AF28C`) and walks channel
data from record/animation-object fields. Reading: pump 2 evaluates a pose from
stored animation state (not read here which logic function stores it), it does not
advance time itself. Not proven: the animation callbacks at `+0xD4/+0xDC/+0xE0` and
the class-side readers could still step state. A live test would run pump 2 twice
with unchanged records and compare pose outputs (UNKNOWN, not done).

# The "pump 2 twice" test already exists: E1 G1 (2026-09-30, owner-observed)

Re-reading session-2026-09-30/SESSION-LOG.md: profile G1 skipped group pump 1 every
second outer update (accumulated delta on the executed call) while pump 2, camera,
player and render stayed at 60 Hz, i.e. pump 2 ran on unchanged records every second
frame. Owner OBSERVED: overall game speed back to normal, strong judder, Blaster
cooldown longer, LaserTracer drain still 2x. Reading (INFERRED): re-running pump 2 /
pose evaluation on unchanged records did not visibly speed animations, matching the
static finding above. The judder is exactly what a blended copy would address; it
does not show per-animation numeric equality, and the "game speed normal" statement is
a whole-scene impression, not a measurement. I did not re-run G1: pump-gate.py refuses
when a plugin (Overcompensated60) is resident, and an A0/G1 run needs the unpatched
profile and a fresh savestate (owner-side change). Mode G (callback-level half rate)
failed for a different reason: pump 1 rebuilds per-frame lists that callbacks refill.
Whole-pump skipping (G1) does not.

Design implication (INFERRED, untested): prototype = G1 (pump 1 every 2nd outer
update) + a tick-end snapshot of record basis/position for each live record
(0x80-byte stride, floats 0..10 and +0x30..0x38) + on non-update frames blend
prev/cur into the record just before pump 2 and restore the true values afterwards.
Risks: boat platform/riding (GI failure) must not see the blended values (restore
before any logic reads), skinned poses use more than the basis (animation time/channel
state, not blended), and camera/player/projectile must be handled separately; code
size within the ~30 KB budget unknown.

# NEXT

Static: find the skinned character draw path (crab class draw callback) and the GE display-list builder's readers of moby `+0x30` and the
camera block (candidate function list from existing Ghidra data), then one
read-watch with a positive control to see whether they run after the pump update
in the same frame. Raw samples stay local (tmp/render-probe).
