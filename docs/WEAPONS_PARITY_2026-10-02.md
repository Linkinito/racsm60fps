# Weapons at 60 FPS — measured parity status (2026-10-02)

French summary: [fr/ARMES_PARITE_2026-10-02.md](fr/ARMES_PARITE_2026-10-02.md).
Evidence: `research/live-tests/pokitaru/session-2026-10-02b/SESSION-LOG.md` (local research branch),
`research/v2/call-context-20261002/REPORT.md`. All values are live PPSSPP 1.20.4 measurements on
Pokitaru (UCES00420), single location, A0 = original 30 FPS, C1 = uncorrected 60 FPS.

## Results

| Weapon (id) | What | A0 | C1 | C1 + fixes | Fixes |
|---|---|---|---|---|---|
| Lacerators / Blaster (2) | cadence | 4.134 shots/s | 1.842 | **4.133** | `weapondt` |
| | projectile speed | 125.9 u/s | ~255 | **125.7** | `blastershot` |
| Ryno "TELT" (15) | cadence | 15.0 frames @30 Hz | 28 @60 Hz | **30.08 @60 Hz** | `animlat` (IG-v20) |
| | rocket speed / life | 23.97 u/s, 1.13 s | 47.8, 0.57 s | **23.94, 1.17 s** | `rynorocket` |
| Tremblator / BlitzGun (3) | cadence | 23.0 frames @30 Hz | 91 @60 Hz | **46.0 @60 Hz** | `weapondt` (+ `animlat`) |
| | shock wave life | 13 / 14 frames @30 Hz | ~7 | 23.4-24.5 @60 Hz (target 26/28) | in progress (IG-v24 island) |

Not yet measured: Bombglove (4), AgentsGlove (5), BeeMineGlove (6), ShieldCharger (7), ShockRocket (8),
CrossbowGun (9), Flamethrower (10), LaserTracer (11), SuckCannon (12), Mootator (13).

## Mechanisms found

1. **Player substep loop (domain 8).** The equipped weapon's update runs inside the player substep
   loop, which ran twice per 30 Hz frame with the full frame delta in the original. Delta-based weapon
   cooldowns therefore advanced 2/30 s per frame. `weapondt` gives the weapon call 2 x delta.
2. **PPSSPP JIT and delay slots.** A word written into a branch delay slot reads back correctly but is
   not executed until the branch itself is rewritten. `weapondt` had never been active before; the fix
   tool now rewrites the preceding branch after any delay-slot edit.
3. **Projectiles stepping per update.** BlasterShot and RynoRocket move a fixed distance and age once
   per update, so at 60 Hz they fly twice as fast and live half as long. The shot formulas contain a
   hard-coded 30 frames per second (`blastershot`: 30.0 -> 60.0 in speed and lifetime) or per-update data
   (`rynorocket`: speed / 2, life x 2, homing turn caps / 2).
4. **Animation end latency (`animlat`, plugin IG-v20).** The animation system raises an end flag on the
   first update past the end (strict comparison) and readers see it one update later: every non-looping
   animation end arrives 2 updates late, 2/30 s in the original and 2/60 s at 60 Hz. The Ryno refire
   waits for the player's 13/30 s shot animation. The plugin withholds the end flag of non-looping
   channels for 2 extra 60 Hz updates. Global effect (all non-looping animation ends), not yet reviewed
   visually outside weapons.
5. **Segmented rays.** The Tremblator shock wave uses a ray state machine (0x5FACC), a segment pool
   animator (0x60100) and ray particles (callback 0xC9ED8), all stepping per update with integer counts.
   Exact conversion runs this subsystem at 30 Hz ("30 Hz island", plugin IG-v24) while drawing at 60 Hz.

## Rejected or corrected

- `rynorate` (Ryno refire 24 -> 48 frames): REJECTED by measurement, the refire counter runs in the
  substep loop and is already correct; the residual came from animation latency.
- Ten `frametimers` sites and one `phases` site are in substep code that is already correct at 60 Hz
  (removed from the groups).
- Generated TrainingBot timer list quarantined (an animation id and a half-doubled window).

## Method notes

Tools (project-authored, read-only except the explicit fix and ammo test aid): `projectile-tracker.py`
(projectile lifetime, distance, speed, ammo cadence), `ryno-probe.py --lite` (frame-exact cadence),
`blaster-probe.py`, `ray-stats.py` (with fire-button injection), `set-ammo.py` (test aid). Polling must
be throttled (tight loops froze emulation) and the PPSSPP window must stay in the foreground (in the
background the game frame rate varied from 25 to 200 FPS and measurements were discarded).
