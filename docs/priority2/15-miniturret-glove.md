# 15. Miniturret Glove (cut weapon) - only if assets still exist

Goal: check whether the cut weapon can be restored.

## Known

UNKNOWN. Owner states it was cut from the game; the repo has no evidence.

## Existence checklist (stop at first definitive NO)

1. Weapon table/entry remnants (name string, weapon id, ammo slot) in the
   modules (local string search; no dumps committed).
2. Model/animation/texture assets in the data archives (file names or hashes
   only; do not extract into Git).
3. Class in the live class table (research/v2/class-table) with update callback.
4. Localized text, shop/vendor entries.

If only code or text remains but models/animations are missing, record
"not restorable without new assets" and stop (owner accepted this outcome).
