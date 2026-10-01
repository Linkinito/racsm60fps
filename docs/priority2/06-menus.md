# 6. How every menu works

Goal: a complete map of all menus (frontend, pause, shop/vendor, weapon, map,
options, save/load, skill points, cheats, challenge mode, ...).

## Known

- Legacy leads (MIGRATION.md C6, rows 148): static pause-cycle candidates and
  menu prototype reports exist in the legacy archive. Early cycle-data
  extraction was SUPERSEDED (color words treated as float NaNs).
- FRONTEND is a separate module (ROADMAP: skip language/intro is a dev plugin).
- Menu timing is probably per-call stepped, i.e. subject to the 2x issue.

## Unknown

Menu state machines, input handling, rendering path, per-menu timing at 60.

## Approach

1. Extend `class-table.py` / `group-census.py` to the FRONTEND module and the
   pause-menu overlay: list menu classes and update callbacks.
2. For each menu: record entry, input handling function, draw function, timers
   (blink, scroll, transitions).
3. Output `research/v2/menus/MENU-MAP.md` (local, regenerate from script) plus
   a curated public summary: one table row per menu with entry function
   signature, state variable, timers, parity status (A/B/C).

## Acceptance

Each menu has: how reached, state variable, input path, timers list, A/B/C
speed comparison.
