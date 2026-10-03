# Flamethrower and Otto at 60 FPS — measured status (2026-10-03)

Later status (FG-v3 tested, LaserTracer/Agents): [WEAPONS_60FPS_STATUS_2026-10-03.md](WEAPONS_60FPS_STATUS_2026-10-03.md).

French summary: [fr/FLAMETHROWER_OTTO_2026-10-03.md](fr/FLAMETHROWER_OTTO_2026-10-03.md).
Evidence (local research branch): `research/live-tests/pokitaru/flamer-001-20261003/`,
`research/live-tests/quodrona/flamer-boss-001-20261003/`, `otto-health-001-20261003/`,
`otto-phase2-001-20261003/`, `otto-telt-001-20261003/`, `otto-floor-001-20261003/`,
`research/live-tests/pokitaru/flamer-gate-fg0-20261003/`.
All values: live PPSSPP 1.20.4, UCES00420. A0 = original 30 FPS, C1 = uncorrected 60 FPS
(three core words). No correction is validated yet.

## Flamethrower

| Quantity | A0 | C1 | Status |
| --- | --- | --- | --- |
| Weapon update calls | 60/s (2 per frame) | 60/s (1 per frame) | already equal |
| Ammo consumption | 4.00/s | 4.00/s | already equal |
| Damage-query calls (fire held) | 30/s | 60/s | **2x in C1** |
| Hits accepted on Otto (contact) | 30/s | 60/s | **2x in C1** |
| Damage per hit on Otto | 2.6667 | 2.6667 | equal |

Mechanism: in A0 the two weapon substeps per frame set one latch that the
animation callback consumes once per frame; in C1 the single substep's latch is
consumed every frame. Active level 3 (V4) uses damage row 0x44 (2.1333 before
the target's factor). Decision: keep per-hit damage, restore a 30 Hz query
cadence (halving damage would still double per-hit effects such as reactions
and the deferred secondary damage installed by accepted hits).
Candidate delivery: FlamerGate plugin (FG-v0 locator validated on Pokitaru and
Quodrona; FG-v2 two-hook gate per GPT design built, not yet tested). The release fireball (upgrade) is
a separate damage path, not yet measured.

## Otto (Quodrona boss)

- Shield 500, then health 5000. Measured 2.6667 per hit; the receiver has no
  multiplier (static), so this is INFERRED to include deferred secondary damage.
- The shield refills instantly after a vulnerable window: 6.9-8.0 s in A0,
  4.3-5.1 s in C1.
- Animation-ID durations (pvar+0x18; logical state is moby+0x45): 2, 3, 6
  (phase 1) and 13 (phase 2) count frames and run
  2x fast in C1; 5, 7, 8, 9, 12, 15, 17 are time-based.
- Phase 2 (no shield) begins below about 60-66% health (file constant ~0.66; owner saw ~60%), checked at a state
  transition. At zero health Otto passes through the angry animation
  (state 12, 2.4 s, unkillable) before dying.

## Next

Static confirmation of Otto's state units and the gate design (GPT), then
A0 / C1 / C1 + gate on Otto from the same savestate, then the coverage register
(`research/WEAPONS_ARMOR_COVERAGE.md`): every weapon level, mod and armor power.
