# 12. Disappeared RetroAchievements

Goal: check whether the achievements that no longer trigger can be re-enabled.

## Known

UNKNOWN. Not documented in the repo. Likely candidates (INFERRED): triggers
reading memory addresses that moved because plugins relocate/alter state, or
that depend on the 30 FPS tick, or hardcore-mode restrictions disabling them
when cheats/plugins are active. None verified.

## Approach

1. Get the set definition (achievement list with memory conditions) from the
   RetroAchievements set for this game ID (public data, fetched by owner).
2. For each achievement: re-evaluate its address/condition against the current
   memory layout (note: LEVEL modules load at different bases, and InterpGate
   shifts them to ~0x0916BD00..CD00).
3. Check emulator side: RetroAchievements can refuse hardcore with
   patched memory/cheats (policy, not a bug).
4. Classify each: still valid / address moved / logic broken at 60 / disabled by
   policy.

## Note

Plugins that change memory layout are the likely cause; verify by running with
no plugins first.
