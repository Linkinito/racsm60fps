# 14. Draw distance for objects/enemies (reduce pop-in)

Goal: larger visibility distance for objects and enemies.

## Known

UNKNOWN. INFERRED: a distance-based activation/culling threshold per entity
class (spawn radius) and a render far plane; both could limit pop-in.

## Approach

1. Distinguish **activation** (entity logic spawns when near the player) from
   **render culling** (draw skipped beyond distance) from far-plane clipping.
2. Find thresholds: for an enemy, walk away until it vanishes; scan squared
   distance constants; compare with class table (research/v2/class-table).
3. Raise gradually; test cost: PSP-emulated game may spike CPU/GE load;
   measure frame time with frametime.py; verify enemy AI isn't activated early
   (parity/gameplay change: aggro trigger).

## Risks

Activation range changes gameplay (enemies engage from farther) => keep render
distance separate from activation distance; document each.
