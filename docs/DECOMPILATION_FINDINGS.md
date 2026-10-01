# Decompilation findings — LEVEL_01 (Pokitaru), 60 FPS project

French version: [fr/TROUVAILLES_DECOMPILATION.md](fr/TROUVAILLES_DECOMPILATION.md).
Status of each item uses docs/methodology/EVIDENCE_LEVELS.md: OBSERVED (read in code or memory),
INFERRED (reasoned), TESTED/owner-accepted (seen live by the owner), REJECTED. Names are tentative.
Addresses are LEVEL_01 module offsets (RVA); at runtime add the module base. No game code is
published: decompiled C, databases and listings stay local (`research/v2/decomp-candidates/_local/`).

## 1. Method

- Ghidra 12.0.4 + Allegrex, headless, on a guarded local copy of the owner's project:
  5045/5045 functions decompiled (`MassDecompile.java`, `DecompileAll.java`), 496 automatic names from
  the class registration table (150 classes, slot 2 = pump-1 update), plus 133 hand-written
  annotations (`research/v2/decomp-summary/level01-annotations.json`, applied with
  `ghidra/ApplyAnnotations.java`).
- Deterministic scanners in `research/scripts/` turn code shapes into datasets (fixed steps, frame
  timers, 1/30 literals, x30 conversions, age counters, phase steps, clock users, springs). Each
  dataset carries its method hash and is regenerated, never edited by hand.
- Live checks via the PPSSPP WebSocket debugger; since 2026-10-01 a per-update telemetry hook in the
  InterpGate plugin measures rates per game second (`tools/runtime/fix-monitor.py`).

## 2. Why the game runs 2x too fast at 60 FPS

The game updates once per displayed frame. The shared delta (1/30 s) is read at `0x151E0` and
passed to the entity updates, but most gameplay code ignores it and steps by fixed amounts per call.
C1 (three words: drop the second VBlank wait `0x96650`, delta 1/30 -> 1/60 at `0x151E0`, player
substeps 2 -> 1 at `0x2FCFC`) gives 60 updates per second and fixes everything that uses the delta
(Ratchet, the animation system, the Blaster). Everything that adds a constant per update runs twice
as often. Global tricks (half-rate updates, interpolation, halving every changed float) were tested
and rejected (judder, broken interactions); the work is therefore targeted, family by family.

## 3. Engine structure (OBSERVED)

| Item | Address | Notes |
|---|---|---|
| Level loop | `0x13F0C` | `while state == -1 { counter 0x2AF28C++; per-frame 0x159DC }` |
| Main update | `0x1517C` | delta at `0x151E0`; pump 1 call `0x15230`; pump 2 `0x15338`; particles `0x15348` |
| Pump 1 | `0x6B7F4` | groups `*(0x2CA0D0)+0x34`, stride 0x50; records 0x80 bytes; callback `(f12 delta, a0 moby)` |
| Moby record | +0x30 pos, +0x54/+0x58 data pointers, +0x64 flags (bit 0 active), +0x70 age/timer, +0x76/+0x77 update/draw radius bytes | data pointer differs per class (crab +0x58, butterfly +0x54) |
| Player | segment 1 + 0x5A838 (module + 0x337940), health f32 +0x964 | |
| Particles | walker `0x8CC18`, animator call `jalr t0` at `0x8CE54`; pools `0x8BA64` (49); allocator `0x8C86C`/`0x8C8A8` -> `0x8C47C` | records swap-removed on death |
| Spring | `0xE290` `v = (t-x)k - v d; x += v` per call | wrappers `0xE35C`, `0xE4F4`, `0xE618`, `0xE67C`, `0xE768`, `0xE864` |
| Frame counter | `0x2AF28C` | +1 per frame; used as a clock by 30+ functions |
| Camera | input `0x3060`, yaw `0x35B0`, pitch `0x37AC`, follow-yaw `0x7740`, FOV reset `0xAD0` | per-call 1/30 literals |
| View constants | `0x2AA3C0` | FOV 0.5498, near 1.0, far 10000; +0x30 distance 5.0; +0x3C height 1.14 (same pattern in all 15 levels checked) |
| Controller | `0x75454` | `sceCtrlPeekBufferPositive` stub at +0x24 |

## 4. Fix families (tool: `tools/runtime/fixes.py`, catalogue: [FIX_CATALOGUE_2026-10-01.md](FIX_CATALOGUE_2026-10-01.md))

| Family | Mechanism found | Correction | Status |
|---|---|---|---|
| nav, nav2 | ground movers `0x2A8F0`, `0x2935C` add a per-call vector | asm stub halves the vector | owner-accepted (crabs) |
| crab, crabtimers | state timer data+0x60 (19 reload sites; attack threshold 27 at `0x2CF3C8`) and cooldown data+0x64 = trunc(helper x 15.0) | x2 / 30.0 | `crab` owner-accepted; generated `timer-patches` Crab batch REJECTED by the GPT-6 audit (10 non-timer sites incl. shared lifecycle flags `0x6A48C/0x6A4A8`); reviewed `crabtimers` untested |
| butterfly | speed/flap steps drawn at init (`0x2CEDA8..B4`), speed spring | halve, refit | owner-accepted (telemetry x1.00) |
| cows | three movers `0x190D6C/0x191154/0x1913A4` | asm stubs | untested |
| frametimers | 29 literal 1/30 timer steps (EnemyWave, Help, Teleporter, ...) | 1/60 | untested |
| frames30 | 17 seconds x 30.0 conversions | x 60.0 | untested |
| age70 | `+0x70 += 1.0` per call (projectiles, flying cars, bee mine) | 0.5 (11 sites) | untested |
| phases | 24 per-call fade/countdown/phase constants with clamp/wrap | halve | untested |
| clock | 21 lui/lw pairs in 16 users of the frame counter (triggers, deadlines, skill point window) | load a half-rate copy | untested |
| springs | 28 {k, d} structs of `0xE290` | 60 Hz refit on the step response | untested |
| particles / particles-all | 47 animators step per call | generic half-step with learned slot identity and unit-vector renormalisation | untested |
| spawn | emitters allocate a fixed count per update | continuous call sites keep half (IG-v15) | untested |
| waterfall | spawn parity `(n+1)&1` at `0x151EDC`, scroll steps | `&3`, halve | untested |
| firerate | Fire accumulator 0.667 per call | 0.333 | untested |
| pathanimals | `pos += fwd*speed` (stub `0x15DE70`), gravity 1/90 | halve speed, gravity /4, spring refit | untested |
| luna | jump step `0x2D4EA8` (arc solved per frame), idle timer | halve, x2 | untested |
| laser, laseracc, laserbeam | LaserTracer drain steps, beam fade 15/6 frames, texture scroll | halve / x2 | untested |
| elevator, boatfade, crank | elevator progress init, boat fade 1/15, crank bolt steps | 1/60, halve | untested |
| camera (other session) | 1/30 literals in camera code | 1/60 | untested |

Rejected after reading the code: `0x6C318` (computes an absolute attachment point; the freezes were
register use, not timing), `0x7248` (look-at matrix of pickup cameras), EnemyWave +0x15C (enemy count).
Global arms D1, G1, G, GI, F1, H, I: rejected live on 2026-09-30.

## 5. Plugins

- **InterpGate IG-v16f** (`patches/experimental/interp-gate`, 7.8 KB): passive helper used by
  `fixes.py` (asm stubs, particle/spawn wrappers, half-rate clock, telemetry). Built without libc
  and without a thread: IG-v15a (237 KB resident) coincided with a crash when loading Dayni Moon;
  with IG-v16f the level loads (owner-observed). `fixes.py` refuses to write if the loaded build
  differs (code signature) or if the level is not LEVEL_01 (module size).
- **OCEnhance** (`patches/experimental/enhancements`, about 9 KB): optional features, off unless set
  in `ocenhance.ini`: right stick camera, Dev-kit L2/R2 aliases, FOV, camera distance and height.
  Signature-gated per level (all levels), rewritten from the RACSM Controls POC. Not yet tested live.

## 6. Open items

- Port accepted families to the other levels by signature (only LEVEL_01 is mapped).
- Telemetry: count-up timer durations (crab +0x60) are not yet captured.
- 16 butterflies with another configuration (speed 0.025-0.04) were not adjusted live.
- Frame-counter stamps with unknown readers left on the game clock: `0x54EFC`, `0x77098`, `0x783B0`, `0x106698`.

## 7. Live session 2026-10-02 (summary)

Owner-accepted from a clean boot with telemetry: `crabtimers` (crab state durations x0.99, cooldown x1.00 vs A0),
`camera` including the negative caps, `frames30` for the HUD hide delay, `springs`, `spawn`, `butterfly`, and the
OCEnhance features (right stick yaw, vertical look by moving the per-frame default target pitch `0x2AA40C` together
with the pitch, R3 = game recentre `0x2C84` without crouching). Rejected: `particles-all` (colour corruption; motion of
debris/waves lives in per-particle callbacks). Open: Blaster fire rate is halved by C1 itself (A0 4.2 vs C1 2.0 shots/s,
measured); the cooldown is not the limiter (`weapondt` had no effect); next candidate is the other delta consumer of
the player substep loop, `0x39B74`. Still 2x: bolts flying to Ratchet, teleporter and help-box animations, waterfall
particles and water scroll, crate debris; Ryno fires too fast. Weapon ammo: inventory entry +0x40 from `0x1F71C`.
