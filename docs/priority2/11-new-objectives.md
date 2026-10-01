# 11. New objectives / new skill points

Goal: add new skill points (and objectives) to the game.

## Known

UNKNOWN: how skill points are stored/evaluated (bitfield? table of conditions?
how many?), and how the UI lists them.

## Approach

1. Find the existing skill point table (names, conditions, counters) from the
   UI strings and the pause/skill-point menu (item 6).
2. Determine whether the table is data-driven (add rows) or code (hook).
3. New objectives can be implemented as plugin-side counters (item 10) with
   a UI entry; rewards should only be cosmetic/title to avoid altering the
   save/economy.
4. Keep these behind a feature flag; they are Priority 2.

## Risks

Save compatibility (flag bit count), localization (EU languages), UI space.
