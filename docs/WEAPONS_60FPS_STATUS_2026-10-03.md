# Weapons at 60 FPS — measured status, end of 2026-10-03

French summary: [fr/WEAPONS_60FPS_STATUS_2026-10-03.md](fr/WEAPONS_60FPS_STATUS_2026-10-03.md).
Earlier Flamethrower detail: [FLAMETHROWER_OTTO_2026-10-03.md](FLAMETHROWER_OTTO_2026-10-03.md).
All values: live PPSSPP 1.20.4, UCES00420. A0 = original 30 FPS, C1 = uncorrected
60 FPS core (three code words). Raw measurements stay on the local research branch.
"TESTED" below means measured for the stated scope only; nothing here is a
validated release yet.

## Flamethrower — FlamerGate FG-v3 (experimental plugin)

FG-v3 finds its sites by instruction patterns in any normal-family level module,
applies only in C1 and restores the original code otherwise. It runs the
damage query, the mod19 reach step and the deferred secondary damage (damage
and age) on one frame out of two, as A0 does.

| Check (boss Otto, Quodrona) | A0 | C1 + FG-v3 |
| --- | --- | --- |
| Damage per A0 frame of contact, V1 / V4 / V5 / V8+mods | 0.63 / 2.67 / 6.0 / 21.33 | same |
| Extra deferred tick per missed A0 frame (V8) | +4.67 | +4.67 |
| Direct-hit rate at equal distance and facing (V1) | e.g. 0.41 at 5 units | 0.41 |
| Fireball charge per A0 frame / fireball damage | +2 / 70 | +2 / 70 |

Also TESTED: FG-v3 binds and gates on Pokitaru after a level change; fireballs
on regular enemies never reach the deferred-damage hooks. Not run: ranks V2,
V3, V6, V7 (values only, owner decision); levels other than Quodrona/Pokitaru.
Minor open point: with one of the two phases the first deferred tick of a burst
lands one 60 FPS frame after the direct hit (same count and values).

## LaserTracer — defect found, fix built

C1 doubles both damage (5.0 -> 10.0 per A0 frame on Otto, V1) and ammo drain.
Two independent causes, each fixed in a debugger emulation on Quodrona:
the ammo countdown reads a "first player substep" flag that is always set at
60 FPS (gating that read to 30 Hz restores ammo), and the beam damage call runs
once per frame (gating that call to 30 Hz restores 5.0 per A0 frame). Neither
alone is enough. FG-v4 implements both (built, not yet run).

## Agents of Doom — lifetime fixed in emulation

Agent lifetime is a 900 counter decreased by 1 per agent update: 30 s in A0,
15 s in C1. Changing the step to 0.5 restored 30 s (TESTED on Quodrona).
FG-v4 implements it. Attack cadence, damage and the two mods are not measured.

## Acid Bomb Glove

Not measured yet.

## FG-v4 (experimental, built)

Adds the LaserTracer and Agents fixes as separately requested extras; the
Flamethrower part is unchanged. An offline census of the original level
modules finds every site uniquely in levels 01-10, 23 and 24.

## FG-v5 (experimental, built)

Turns the extras into a table of guarded code patches and adds two fixes first
measured on Pokitaru: the weapon update gets twice the C1 time step (A0 ran it
twice per frame; Blaster fire rate was halved at 60 FPS), and the BlasterShot
speed/lifetime formulas use 60 updates per second. An offline census places
both in every normal level module; level 02 (already one pass per frame) is
excluded from the time-step fix.

## Measurement notes

- Debugger code writes in PPSSPP may be ignored by already-compiled JIT
  blocks; the plugins invalidate the instruction cache after each write.
- Continuous large memory polling can hang the PPSSPP debugger; use
  breakpoints or small, slow reads.
