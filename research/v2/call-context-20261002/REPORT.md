# Call-context map and delta dataflow — LEVEL_01 (2026-10-02)

Work plan items O1, O2, O3 (partial O4) of docs/WORK_PLAN_2026-10-02.md. Static only: no emulator,
no live test. Evidence levels per docs/methodology/EVIDENCE_LEVELS.md.

## Method and provenance

- Tool: `research/scripts/call-contexts.py` (sha256 `9211af38…d4fa`; the output records methodSha256).
- Inputs: vanilla LEVEL_01.PRX (sha256 `d10a81d0…6571`, checked by the tool), local Ghidra mass
  corpus `_local/20261001-mass/all/index.json` (5045 functions), class table
  `research/v2/class-table/level01-classes.json`, particle pools, curated live edges
  `research/v2/decomp-summary/level01-observed-indirect-edges.json` (one edge: 0x1F2D0 -> Blaster_Update).
- Output: `research/v2/decomp-summary/level01-call-contexts.json` (sha256 `d596061e…3226`), one row
  per function: regions, readsF12, dtEntry, dt use sites, dt passed to callees, indirect calls with/without
  dt, stores of dt into struct fields, 1/30 sites, function pointers materialised / found in data.
- Analysis: direct `jal` graph re-derived from bytes (13464 edges; Ghidra lists differ for 3
  functions). Regions by BFS from roots: main update direct callees, player substep body (7 calls at
  0x2FCB0..0x2FD04), pump-1 class updates, other class slots, particle animators, pump 2, player wrapper.
  Delta taint: per-function CFG dataflow (basic blocks, delay slots, branch-likely, switch jr), FPU
  registers, GPR copies, stack slots; seeded by 0x3D088889 in the main update; propagated only to
  callees that really read f12 (used, stored, forwarded); pump-1 indirect call feeds class updates.
- Limits (documented in the tool): VFPU not followed; reloads of a delta stored in a struct field are
  listed (`dtFieldStores`) but not chased; switch targets approximated; indirect targets incomplete;
  region labels over-approximate through shared helpers. Rows are INFERRED candidates for review.

## Findings

### F1. Where the frame delta goes (OBSERVED code, INFERRED dataflow)

The main update 0x1517C passes the delta (f12) to only four callees: 0x87A84 (UV/texture scroll list,
`+0x94 += +0x9C * dt` with wrap: delta-based), pump 1 0x6B7F4 (class updates via jalr 0x6B9B8),
P_Player_UpdateWrapper 0x2FFF0, and 0x6B618 (-> 0x78550 -> 0x76684/0x76BCC, delta consumers near the
animation code). No global holds the delta in LEVEL_01 (dtGlobals empty). Everything else in the frame
is per call.

### F2. Most entity logic ignores the delta

Only 27 of 150 class updates read f12: Acidbomb, AgentController, AgentsLaser, BeeMineGlove, Blaster,
BlitzGun, Bombglove, ClankPack, DropshipB, DropshipLaser, EnemyController, EnemyWave, Hypershot,
Lvl3Elevator, Mootator, PowerupAmmo, RatchetShipAnimation, RynoRocket, ShakeyBush, Sharkagator,
SharkagatorFin, SuckCannonComet, SuckCannonCometTie, TMRobotTorsoB, Teleporter, TorsoAShot, WaterWaves.
The other 123 advance per call (2x at 60 Hz unless the class is driven elsewhere).

Contradiction with the earlier static profile (`level01-class-verdicts.json`): 53 classes have
"delta shapes" but their update never receives the delta, including 7 with verdict DELTA
(CrabObjectController, FogMoby, HeadShrapnel, Level01SkyController, SetCamera, TorsoShrapnel,
TrainingBotShrapnel). The old scanner took `x += DAT_xxx` for a delta. Example: Level01SkyController
adds DAT 0x2D47D8 (0.000556, sole user) to the sky angle per call -> sky turns 2x in C1. Those 53
classes need re-review as domain 2. Earlier DELTA verdicts are SUPERSEDED as evidence of correctness.

### F3. Domain 8 inventory (player substep loop)

A0: body runs twice per 30 Hz frame, each call gets the full frame delta. C1: once per 60 Hz frame.
Per-call code in the body therefore runs 60 calls/s in both (correct after C1); delta consumers get
half the time in C1. Delta flows inside the body:

| Path | Consumer | Fixed by |
|---|---|---|
| 0x2FCE8 -> 0x39B74 -> 0x32588 | player timers +0xA00, +0xA08, +0xA0C, +0xA14, +0xA18 -= dt | `substepdt` |
| 0x39B74 -> 0x31E68 -> jalr 0x31EF4 | weapon callbacks player+0x990 / +0x994 (dt in f12), gated by 0x95C&0x20 | `substepdt` |
| 0x2FCF4 -> P_Player_WeaponUpdate -> jalr 0x1F2D0 | equipped weapon update (group+0x1C), Blaster OBSERVED | `weapondt` |
| P_Player_WeaponUpdate -> 0x1DF5C | delta consumer | `weapondt` |
| field +0x578 = dt x 30 (0x360A4, once per frame) | 0x42C04 gun-pose countdowns +0x9D4/+0x9D8 (10.0) -= +0x578; 0x328A0 velocity / +0x578; 0x59D04 speed / +0x578 | `framescale` (new) |

P_Player_TimingFields 0x360A4 runs once per frame outside the loop; its accumulators (+0x570..+0x58C
+= dt) are correct in C1. Its +0x570 = fmod(+0x570, 1/60) + dt suggests a 60 Hz design for the
substeps (INFERRED).

### F4. Existing fixes applied in the wrong context (INFERRED, high confidence)

- `frametimers`: 10 of 29 sites are 1/30 steps inside functions reached only from the substep body
  (0x3C88C called directly by the loop; 0x44ED8, 0x4A4F0, 0x570F0 through substep-only chains; no
  pointer or data references). They already run 60 calls/s in A0 and C1; patching makes them 2x slow.
  0x4A4F0 case 4 counts down player timer +0x138 by 1/30 and only then sets 0x95C |= 0x22 (fire-enable
  bit 0x20). Removed from the group in tools/runtime/fixes.py (keys kept).
- `phases`: constant 0x2B0E70, sole user 0x56A04 substep-only. Removed from the group.
- `spawn`: one substep-only spawner (0xD9838) and 11 shared ones: the throttle may halve a player-side
  emitter wrongly. Not changed; listed as risk.
- `rynorate` (24 -> 48): if Ryno_Update runs through the weapon call like the Blaster, its -1.0 per call
  is already 60/s and rynorate would halve refire. Probe first (comment added).

Consequence for the 2026-10-02 session: if `frametimers` was active during the `weapondt` Blaster
test, the slowed +0x138 fire-enable timer could have masked the cooldown fix. The session log does not
state the fix set for that measurement (UNKNOWN).

### F5. Blaster mechanism (O3) and predictions

Blaster_Update (0x116A00) fires when all hold: refire cooldown pvar+4 == 0 (`-= dt` per call; reload
from table 0x2CDD90 = 1.0 / 0.5 s by upgrade, in Blaster_UseAmmo 0x1168A0), player 0x95C & 0x20,
gun state moby+0x45 in {0, 4} (set to 4 on a single shot, so refire is allowed in the shot state),
pad +0xD4 & 0x2000. A0 gap 0.25 s = 0.5 s reload consumed at 2 s per second (INFERRED consistent with
the measurements); C1 0.5 s. Predictions (each falsifiable with the ammo meter, clean boot):

| Test (C1 + ...) | Prediction | If wrong |
|---|---|---|
| nothing | 2.0 shots/s (measured) | — |
| `weapondt` only, no other fix | ~4 shots/s (cooldown limiter restored) | another substep delta consumer limits (test `domain8`) |
| `frametimers` (old 29-site group) only | <= 2.0 shots/s, slower in states using +0x138 | +0x138 path not on the standing-fire path |
| `substepdt` only | 2.0 (cooldown still binds) | cooldown is not the binding limiter |
| `domain8` (weapondt+substepdt+framescale) | ~4.2 shots/s, gun pose timing like A0 | substep model incomplete |
| Ryno probe A0 vs C1 | same refire duration if Ryno runs in the substep | Ryno is updated per frame -> rynorate valid |

### F6. Per-particle callbacks (O4 inventory)

Particle records allocated through 0x7E410 / 0x7E570 / 0x7E6C0 receive a callback pointer. 16 callbacks,
none reads the delta (all per call, 2x in C1):

| Callback | Spawner | Owner classes (reverse call graph, depth <= 6) |
|---|---|---|
| 0x65758, 0x65A6C | 0x6539C | Teleporter |
| 0x65D78 | 0x65228 | Teleporter |
| 0x13B20C | 0x13B5F8 | Flamethrower |
| 0x15E8C8 | 0x15E600 | Polarizer |
| 0xC5CA8 | 0xC5B10 | AgentsRocket, DropshipB, ExplosiveBee, PowerupHealth, TMRobotTorsoB |
| 0xC68B8 | 0xC66E0 | Acidbomb, HeadShrapnel, TMRobotHeadB, TorsoAShot, TorsoShrapnel, TrainingBot |
| 0xC71D8 | 0xC6F40 | BlitzGun |
| 0xC75A4 | 0xC73F0 | Blaster, BlasterAkimbo, PowerupHealth, Wrench |
| 0xC7984 | 0xC7AF0 | HeadShrapnel, TorsoShrapnel, TrainingBot(Shrapnel) |
| 0xC9ED8 | 0xC9CC0 | Acidbomb, BlitzGunShot |
| 0xCA9A8 | 0xCA0A4 | Acidbomb, Flamethrower |
| 0xCD7A0 | 0xCD61C | CrabShrapnel |
| 0xCDBC0 | 0xCD838 | AgentOfDoom, BeeMine, Fire |
| 0xCE09C, 0xCE640 | 0xCD9A8, 0xCE504 | Fire |

The Teleporter callbacks are the best candidates for the teleporter animation the owner saw at 2x.
Waves (0x7E810 records), waterfall and crate debris use pool animators, not these callbacks. All
three callback animators (0x7E810, 0x7EDC0, 0x7F194) and 0x661FC are in the `particles-rate` pool list
(47 animators), so that mode already covers every callback at 30 Hz; `teleporterfx` must not be
combined with it (fixes.py now refuses the pair). Per-callback exact conversion is not attractive:
the bodies mix per-call gravity, life -1.0, cos/sin rotation pairs and packed-colour byte increments.

### F7. Water scroll lead

0x87A84 (main update, delta) is a delta-based UV scroller: anything it drives is correct in C1. The
waterfall water scroll still 2x (owner) therefore comes from another mechanism (EBOOT texture
animation, or a per-call writer outside LEVEL_01). INFERRED; GE debugger check still needed.

### F8. Literal 1/30 census re-audited with context

Tool `research/scripts/k30-context-audit.py` -> `research/v2/decomp-summary/level01-k30-context-audit.json`
(108 `lui 0x3D08` sites). Verdicts: 14 SUBSTEP_ALREADY_CORRECT (10 former `frametimers` timer steps + 4
"scale"), 14 DELTA_FUNCTION (likely unit conversions), 54 already in a fix group, 26 PER_CALL_CANDIDATE
still to review. The old "scale" label hid per-call rates: the owner-accepted camera sites and the
validated Lvl3Elevator initializer were "scale" too. Reviewed and added as candidates:

- `teleporterfx` (7 sites): Teleporter effect progress rate (1/30)/duration at spawn 0x6539C and in the
  record callbacks 0x65758/0x65A6C, step +0x54 (0x65228 -> 0x65D78), increment in 0x65D78, emitter rate
  0x650EC, animator 0x661FC. All per frame (pump 1 / particle walker), no delta.
- `groupfade` (8 sites): 0x6DF94, called only by pump 1, ramps four global fade channels 0x2B2A80..8C by
  0.5 x 1/30 per frame (2 s in A0, 1 s in C1); consumer 0x6DDE4 gates draw effect 0x784A4 on flag bits
  DAT_002af280+0x1900. Visible role UNKNOWN.
- `k30calls` (11 sites): PowerupAmmo/PowerupHealth state-1 pop motion `pos += v/30` (0x16013C via
  PowerupAmmo_Update state dispatch, no time accumulator; 0x1619C8), flying cars Directional/Orbit/Pathed
  speed x 1/30 (+ Pathed init), TieManipulator init per-call angle rates, BoltCrankCam (1/30)/DAT,
  Polarizer (1/30)/DAT, TripleWaveBeacon alpha step (255/t)/30.

Left for review: SharkagatorFin init (class reads the delta: pairing unknown), RatchetShipAnimation
0xDF7B8 (mixed with a `frames30` site), anonymous functions with no class owner, player-side mixed
contexts (0x39FD4, 0x6AA08).

### F9. TrainingBot generated timer list reviewed (O5)

All TrainingBot state functions are pump-1 only (per call, no delta). Of the 9 generated sites:
7 are genuine +0x80 duration reloads/compares (random `rand%30+60`, `rand%60+90` in 0x186164, `== 2`
event in 0x1853F0); 0x18456C `li a1,10` is the animation id passed to P_Anim_Start (REJECTED, same
failure as the Crab batch); 0x18531C doubles only the upper bound of the window `50 <= v < 53`
(0x185150), which would widen a 3-call window to 56 calls. Missed by the integer generator: the float
reload `rand*30.0+60.0` in 0x1844F0 (lui 0x41F0 at 0x184580, lui 0x4270 at 0x18459C) and the
hit-immunity countdown +0x7C = 15 set in TrainingBot_slot3 (0x18421C), decremented per call in
TrainingBot_Update: 0.5 s in A0, 0.25 s in C1 (hits accepted twice as often). Generated activation is
now refused (`timer-patches.py`, like Crab); reviewed recipe `tbtimers` (12 words, vanilla-verified)
added to fixes.py. Untested live.

## Changes made

- tools/runtime/fixes.py: `frametimers` group excludes the 10 substep sites; `phases` group excludes
  0x2B0E70; new candidates `framescale` (0x360E8 lui 0x41F0 -> 0x4270) and `skyrot` (0x2D47D8
  0x3A11A373 -> 0x3991A373), `teleporterfx`, `groupfade`, `k30calls`, `tbtimers`; alias `domain8`; timer-patches.py refuses the
  generated TrainingBot activation. Vanilla words
  verified against the PRX (0 mismatches). All untested live.

## Missing evidence / next

- Live: the prediction table above, clean boot, A0 baseline, ammo meter; record the exact fix set.
- Static: LunaNPC generated site (1) not yet reviewed; re-review the 53 "delta-shape" classes as domain 2; field-reload chasing (dt stored in
  struct fields, e.g. 0x32588, 0x87A84 +0x94); VFPU moves; the 26 remaining 1/30 PER_CALL_CANDIDATE
  sites; the other 13 per-particle callbacks (bodies use per-call `+=` without 1/30 literals).
