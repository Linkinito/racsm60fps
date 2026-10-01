# 4. FOV and Ratchet camera position (closer to the PS2 games)

Goal: optional camera pose/FOV approximating the PS2 Ratchet games.

## Known

- OBSERVED (legacy, MIGRATION.md): reported default camera distance `9.0`,
  height `1.90`. Provenance: legacy reports; not re-measured in v2. Level of
  confidence: legacy-OBSERVED only. Does not say these are per-level or per-mode.
- PS2 reference values are NOT in the repo; do not assume any. Any "PS2-like"
  numbers must come from a documented measurement of the PS2 game (UNKNOWN).

## Unknown

- FOV storage (radians/degrees/projection matrix scale), per level or global.
- Whether camera distance/height are per-camera-mode data (probably) or code.
- PS2 target values and how to measure them objectively (screenshot comparison
  of Ratchet's screen size vs. frame height at the same pose).

## Approach

1. Locate: scan floats equal to 9.0 and 1.90 near camera object (value-scan.py),
   verify by write-probe (change and observe).
2. Locate FOV: change projection scale, confirm visual.
3. Provide presets in the checkbox menu: Original / PS2-like (target to define) /
   Custom (distance, height, FOV).
4. Re-check culling and pop-in (item 14): wider FOV shows more objects.

## Acceptance

Each preset reproducible by numbers; special cameras keep original behavior.
