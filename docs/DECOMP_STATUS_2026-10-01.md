# Targeted decompilation — status 2026-10-01

Static work only (no live test in this session). Evidence level: OBSERVED code
shapes, INFERRED timing roles, nothing measured. Decompiled code, databases and
listings stay local under `research/v2/decomp-candidates/_local/` (ignored);
committed summaries contain addresses, offsets, kinds and constants only
(`research/v2/decomp-summary/`).

## Pipeline (all on a guarded local copy of the owner's Ghidra project)

| Step | Script | Result |
|---|---|---|
| Copy | `Invoke-TimingPilot.ps1 -Mode copy` | `_local/20261001-mass/PokitaruMass20261001.gpr` |
| Seed + auto-analysis + reachable decompilation | `ghidra/MassDecompile.java` | 4604 seeded entries, 5044 functions, 1818 reachable decompiled |
| Names | `ghidra/AnnotateNames.java` | 496 functions named (`<Class>_Update`, `<Class>_slotN`, 27 `P_*` engine names) |
| Full module | `ghidra/DecompileAll.java` | 5045/5045 functions decompiled, 0 failures |
| Fixed-step scan | `scan-decompiled.py` + `fixed-step-report.py` | 100+ classes with candidates (`LEVEL01-FIXED-STEP-CANDIDATES.md`) |
| Particles | `particle-inventory.py` | 49 particle pool registrations via `0x8BA64(handle, id, animator, recordSize, ...)` |
| Frame timers | `frame-timers.py` | 21 classes / 23 integer timer fields with init durations |
| Patch sites | `ghidra/FindImmediates.java` + `timer-patch-spec.py` | x2 word-patch spec for Crab (45 sites), TrainingBot (9), Butterfly (2), LunaNPC (1) |

The scanner was validated against mechanisms already confirmed live (crab
counter `+0x60` vs `0x2CF3C8`, navigation `pos += disp`, waterfall animator
`life -1.0`, `pos += vel`, gravity, spin). It reports candidates, not proofs.

## Main findings

- **Crab state machine**: one countdown `pvar+0x60` drives eight states;
  durations are `rand % 45 + 45`, `% 60 + 30`, `% 60 + 90`, `% 60 + 120`,
  `% 30 + 90` and `4` frames (30 Hz). The live `27 -> 54` attack fix covers only
  one of them; the spec doubles all immediates (pending live test).
- **TrainingBot**: same pattern on `pvar+0x80` (30/60, 60/90 frames, threshold 53).
- **EnemyWave**: timer field `+0x15C` initialised in `0x137D9C` (the wave
  countdown earlier research could not find); details pending.
- **Crate debris** are particles: `Crate_slot3` (hit handler) -> `0x18CF88`
  spawns 2 pieces with per-frame random velocities (0.06 / 0.02) through
  `0x1A0278` into the pool registered by `CrateShared_Register` (`0x18CD24`);
  their animator is `0x1A05F0` (48-byte records: life -= params+0x28, vel *= drag,
  pos += vel, fixed rotation; swap-remove on death).
- **Particle system**: 49 pool types; all animators share one structure
  (emitter-instance list, fixed-size records, swap-remove, vertex output).
  A generic per-animator correction is realistic (field map per animator).
- **Blaster**: cooldown and shot timer are delta-based (`Blaster_Update(dt, ...)`,
  1.0 s / 0.5 s table) -> already correct under C1; `+0x40` is ammo, not a timer.
- **LaserTracer drain** (`0x145568`): accumulator `+0x114 += DAT_2D2D74` per call,
  drain `+0x68 += 1.5` past threshold `+0xA4 - 5.0`. `0x2D2D74` is 0 in the file
  (runtime-initialised): read it live, then halve.

## Added later in the session

- Displacement integrators (move `pos += param vector` with ground test):
  `0x2A8F0`, `0x2935C` (nav), `0x190D6C`, `0x191154`, `0x1913A4` (cows, Agent of Doom),
  `0x7248` (pickups) -> `research/v2/decomp-summary/level01-displacement-integrators.json`.
  IG-v11 adds register-transparent asm stubs that halve the vector (fixes `nav`, `nav2`, `cows`).
- `1/30` constants classified: 29 timer steps, 52 scale conversions, 27 other
  (`level01-frame-time-constants.json`); EnemyWave state 1 counts down by a literal
  `1/30` per update (state 2 uses the delta); Help and Teleporter timers likewise.
  Fix `frametimers` patches only the 29 timer steps.
- Scanner false positives: geometry (e.g. HutDoor bounding box `0x143DC8`) looks
  like accumulation; trust timers, 1/30 timer steps, thresholds, displacement
  integrators and particle animators first.
- Second-pass threshold search (`frame-thresholds.py` -> `level01-frame-thresholds.json`,
  43 functions) is too noisy for automatic patches: most small literals are state
  ids. Real candidates (e.g. TrainingBot 49/53 frames at `0x185150`) need dataflow review.
- Ready-to-test list and owner protocol: [FIX_CATALOGUE_2026-10-01.md](FIX_CATALOGUE_2026-10-01.md).

## Added in the follow-up session (IG-v12..v14)

- Telemetry: IG-v12 `ig_tel_pump` + `tools/runtime/fix-monitor.py` (per-update watches, rates
  per game second, A0 baseline comparison).
- `0x6C318` REJECTED as a step: `0x6C2B8` -> `0xF5624` copies the moby position into `out`,
  then offsets are added; `out` is an absolute point. `0x7248` REJECTED: look-at matrix
  builder used by ArmorPickup/TitaniumBolt cameras.
- Particle animators: crate debris `0x1A05F0` record (48 B): life, pos, params pointer, vel
  (x drag per call), unit vector rotated per call by a constant cos/sin pair; same instance
  structure as the waterfall. Generic half-step built (IG-v13, `particles-all`).
- Spawners: 53 callers of the pool allocator `0x8C86C(.., poolId, count)`; Level01Waterfall
  spawns every 2nd update through a parity counter (fixed: every 4th), counts are random
  per call. Other constant-count spawners not yet classified (density 2x at 60 Hz).
- Per-call phase steps with clamp/wrap: `research/scripts/phase-steps.py` ->
  `level01-phase-steps.json` (26 candidates, 24 patched as `phases`).
- Global frame counter `0x2AF28C` (+1 per frame in the level loop `0x13F0C`): 30+ users;
  periodic triggers/deadlines/windows redirected to a half-rate copy (`clock`,
  `clock-sites.py` -> `level01-clock-sites.json`); once-per-frame guards left alone.
- PathAnimal: `pos += fwd * speed` (speed per instance, moby+0x54 -> +4), facing lerp 0.1,
  fall `v += 1/90; y -= v` per call. BoltCrankBolt: `y -= DAT_2CE884` (runtime value) and
  `+0x70 -= 1.0` per call.

## Next

1. Live: `timer-patches.py --class Crab` (+ nav) and `--class TrainingBot`; IG-v10 particles.
2. LaserTracer: read `0x2D2D74` live, halve it, test ammo drain.
3. Extend frame-timer detection to non-`rand` durations and count-up thresholds;
   EnemyWave `0x15C`, HutDoor, MutantCow/MadCow, AgentOfDoom, PowerupAmmo/Health.
4. Particle animator field maps for all 49 pools -> generic particle fix.
