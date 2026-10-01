# Why 60 FPS is hard in Size Matters

French version: [fr/POURQUOI_LE_60FPS_EST_DIFFICILE.md](fr/POURQUOI_LE_60FPS_EST_DIFFICILE.md).
Static analysis of LEVEL_01 (Pokitaru) plus live measurements (2026-09-30 .. 2026-10-02). Addresses are
LEVEL_01 module offsets. Evidence levels as in docs/methodology/EVIDENCE_LEVELS.md.

## Short answer

The game does not have one notion of time. It has at least **eight**, mixed in the same objects, and only
one of them (the delta passed to the entity updates) follows the frame rate. The original game runs at a
fixed 30 Hz, so the developers could write "per call" and "per second" interchangeably; going to 60 Hz
breaks every place where they relied on that. Worse, one domain (the player substep loop) already ran at
60 Hz in the original, with a *doubled* delta, so the same C1 change that fixes it for one kind of code
halves another kind.

## The time domains

| # | Domain | How time advances | At 60 FPS (C1) | Examples (OBSERVED) | Fix strategy |
|---|---|---|---|---|---|
| 1 | Delta-based | `x += rate * dt`, dt = 1/30 -> 1/60 | correct | Ratchet's animation system, Blaster cooldown in pump paths, DropshipB, Sharkagator | none (C1) |
| 2 | Fixed step per entity update | `x += k` once per pump-1 update | 2x fast | crab navigation `0x2A8F0`, butterflies, PathAnimal, Lvl3Elevator, boat fade, age `+0x70 += 1` | halve the step (data/stub), x2 durations |
| 3 | Integer frame timers | `t -= 1` per update, durations in 30 Hz frames | 2x fast | crab states (`crabtimers`), TrainingBot, LunaNPC idle, `frames30` (seconds x 30) | x2 reload values |
| 4 | Literal 1/30 per call | `t -= 0.0333` per call | 2x fast | EnemyWave, Help, teleporter emitter `0x64F9C`, camera `0x3060`/`0x35B0`/`0x37AC` (incl. the -1/30 caps) | 1/60 |
| 5 | Per-call smoothing (springs, lerps, damped filters) | `v = (t-x)k - vd; x += v` per call; camera: exact critically damped step with dt = 1/30 baked in (k = omega/30, e = exp(-omega/30)) | settles 2x fast | `0xE290` (turning of all NPCs, doors, cranks), 20 camera filters (`0xCA24`, `0x49A0`), follow gain 0.6 | refit k, d (`springs`); exact for the camera: k = omega/60, e = sqrt(e) (`camfilters`) |
| 6 | Global frame counter | `0x2AF28C` +1 per frame used as a clock | 2x fast | `& 3`/`% 5` triggers, deadlines, skill point "train faster" window | half-rate copy (`clock`) |
| 7 | Side systems with their own per-call physics | pools updated once per frame | 2x fast | particles (49 animators, some with per-particle callbacks), bolts and crate debris (`0x2832C`), effect pools (`0x93E60` lists) | half-rate update with full-rate drawing (`particles-rate`), half-step (`physstep`) |
| 8 | Player substep loop | in A0: 2 iterations per 30 Hz frame, each with the full frame delta (1/30) | fixed steps OK after C1 (`slti 2 -> 1`), but dt consumers get half: 1 x 1/60 instead of 2 x 1/30 | player timers `0x32588` (+0xA00..0xA18, idle animations), weapon updates (Blaster: A0 4.2 shots/s, C1 2.0 measured) | give the loop body 2 x dt (`weapondt`, `substepdt`), to be validated |

Plus engine-side items outside LEVEL_01 (EBOOT): loading screens (fixed by the other session's
`loading-fps`), probably level geometry texture scrolling (waterfall water still 2x; no writer found in
LEVEL_01).

## Why one global patch cannot work

- Halving every update (half-rate entities) restores speeds but judders and breaks interactions that
  sample input every frame (tested and rejected: G1, G, GI).
- Halving every changed float (H) corrupts non-float data (colours, flags) and misses integer timers.
- Doubling durations (I) breaks animation identifiers and flags that look like durations
  (the generated Crab batch: 10 of 29 sites were not timers).
- Domain 8 is the reverse of the others: it needs *more* time per call, not less.

## What it means for the patch

The working method is: classify each mechanism into one of the domains above, apply the matching
transform, measure with the telemetry (rates per game second vs an A0 baseline), and let the owner
validate visually. Domains 2-6 are mostly solved by data/instruction patches; domain 7 by wrappers in
the InterpGate plugin; domain 8 needs the delta doubling confirmed live. Each fix family is listed in
[FIX_CATALOGUE_2026-10-01.md](FIX_CATALOGUE_2026-10-01.md).
