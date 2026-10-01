# 10. Statistics menu and save integration

Goal: stats page (kills, time, deaths, bolts, per-weapon use...) saved with the game.

## Known

- Player struct: seg1 base (+0x2DD108) + 0x5A838; health f32 +0x964 (OBSERVED,
  CURRENT_STATE, LEVEL_01 only; porting by signature needed).
- Save format and checksums: UNKNOWN. Save data never enters Git.

## Design options

A. Keep stats in the plugin, store in an **external sidecar file** next to the
   save (safest: never touches the original save format; works across saves via
   save slot id).
B. Extend the original save blob (needs format RE, free space, checksum fix;
   riskier; can corrupt saves).
Recommend A first.

## Approach

1. Counters: hook events (enemy death, bolt pickup, weapon fire) found via the
   class table / call-probe.
2. Display: through the checkbox-menu framework (item 8).
3. Persistence: sidecar via sceIo calls from the plugin, keyed by slot.

## Unknown

Which functions fire per event; sceIo availability inside the game context.
