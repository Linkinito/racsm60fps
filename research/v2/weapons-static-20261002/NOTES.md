# Remaining weapons — static notes and predictions (2026-10-02, end of session)

Static only (decompiled LEVEL_01, call-context map). INFERRED; every line below is a prediction to test
live with the weapons protocol (A0 vs C1 cadence with `ryno-probe.py --lite --weapon N`, projectiles with
`projectile-tracker.py --weapon N`, then fix and C1+fix).

## General rule (from the Blaster, Ryno and Tremblator measurements)

- The **equipped weapon's class update** is called from P_Player_WeaponUpdate inside the player substep
  loop (Blaster OBSERVED, jalr 0x1F2D0 -> group +0x1C). Per-call logic there already runs 60 calls/s in
  A0 and C1 (correct after C1). Delta-based logic needs `weapondt`. Anim-end gates need `animlat`.
- **Projectile / effect classes** are separate pump-1 entities updated once per frame: per-call motion,
  ages and counters are 2x fast at 60 Hz and need a fix (formula 30 -> 60, data x2 / /2, or a 30 Hz island).

## Per weapon

| Id | Weapon class (update) | Cooldown / gates (static) | Prediction C1 | Projectile class (update) | Projectile timing (static) | Prediction C1 |
|---|---|---|---|---|---|---|
| 4 | Bombglove (0x1217F4, reads dt) | +0x18 and +0x14 `-= dt` | cadence 2x slow -> `weapondt` | Acidbomb (0x107534, reads dt) | timers `-= dt` (+0x34, +0x0C); ray particles via 0xC9CC0 (callback 0xC9ED8, per call) | timers OK; rays 2x short (`raycb`) ; motion UNKNOWN |
| 5 | AgentsGlove (0x10FD58, no dt) | `+0x40 -= 1.0`, `+0x14 -= 1.0` per call; state 4 waits anim end (0x6AA08) | cadence ~OK, residual anim latency -> `animlat` | AgentOfDoom (0x1099BC, no dt) | age +0x70 `-= 1.0` per call | life 2x short -> x2 needed |
| 6 | BeeMineGlove (0x115990, reads dt) | +0x18, +0x14 `-= dt` | 2x slow -> `weapondt` | BeeMine (0x113E00, no dt) | state machine per call (age70 sites 0x115124/0x115224 belong to BeeMine functions) | timings 2x fast |
| 7 | ShieldCharger (0x16CB78, no dt) | `+0x1068 -= 1.0` per call | ~OK | ShieldChargerBolt (0x16F228) | segmented ray 0x5FACC + segments 0x60100 (same as Tremblator) | 2x short -> ray island |
| 8 | ShockRocket (0x16F954, no dt) | state 3 waits anim end; +4 accumulates a local | ~OK + `animlat` | ShockRocketShot (0x170B20, no dt) | age +0x70 `-= 1.0`, homing 0x1705E8 per call (age70 site 0x170B30) | fly 2x fast, live 2x short -> `rynorocket`-style fix |
| 9 | CrossbowGun (0x12B254, no dt) | +8 `+= DAT_2D061C` per call (charge/zoom) | ~OK | CrossbowShot (0x12CDEC) | segmented ray 0x5FACC; frames30 sites 0x12C8E8/0x12CA00/0x12CBCC in 0x12C01C | 2x short -> ray island; check frames30 context |
| 10 | Flamethrower (0x13B8F0, no dt) | +0x70 `+= 1.0` vs DAT_2D19A0 (emission period) per call | ~OK | NapalmBubble (0x15CCE0, no dt) | size/alpha `+= DAT` per call; existing `firerate` (0x2D1708) | bubbles 2x fast |
| 11 | LaserTracer (0x148CEC, no dt) | per-call filters DAT_2D2CA0..AC; drain 0x145568 (called from the weapon update) | ~OK; existing `laser2` (0x2D2D80) and `laseracc` may DOUBLE-correct (substep) | beam (no separate shot class) | 0x149828 (`laser1`, caller 0x14C474 indirect) context UNKNOWN | measure before using `laser` |
| 12 | SuckCannon (0x1762A8, no dt) | state/anim driven | ~OK + `animlat` | SuckCannonComet (0x19ADF4, reads dt) | age +0x70 `+= 1.0` per call vs DAT_2DA704 (age70 site 0x19AE58); motion `pos += v * f` | life 2x short; motion UNKNOWN |
| 13 | Mootator (0x15A364, reads dt) | +0x70 `-= dt`, reload DAT_2D5638 | 2x slow -> `weapondt` | (cow transformation, MutantCow) | displacement helpers `cows` fix exists | UNKNOWN |

## Cautions

- `age70` contains sites for BlasterShot, BlitzGunShot, RynoRocket, ShockRocketShot, SuckCannonComet and
  BeeMine. They are exclusive with the formula fixes (`blastershot`, `blitzshot`/`blitzhalf`, `rynorocket`).
  For each projectile prefer the measured formula fix and drop the age70 site.
- Segmented rays (Tremblator, Crossbow, ShieldCharger) share 0x5FACC / 0x60100: one validated island
  design should serve all three.
- `frames30` context check done: 0x11A1E0 (in 0x11A178, called only by BlitzGun_Update = substep) is
  already correct; the Crossbow sites 0x12C8E8/0x12CA00/0x12CBCC (in 0x12C01C, called by CrossbowGun_Update
  in the substep AND by CrossbowShot_Update in pump 1) are mixed-context. All four removed from the
  frames30 group in fixes.py (keys kept). The owner-accepted frames30 HUD sites are unaffected.
