# 8. Custom menu with selectable boxes (checkboxes)

Goal: an in-game options page for Priority 2 features (FOV preset, right stick,
camera speed, draw distance, free camera, stats...).

## Design

- Config struct in plugin memory: N flags + a few numeric values; each box = 1
  bit or enum.
- Rendering: reuse the game's own text/UI draw helper (find in menu map, item 6)
  rather than raw GE commands; checkbox glyph = existing font characters.
- Input: shared input mailbox; navigate with d-pad, toggle with cross.
- Placement options: (a) new entry in the existing options menu (best, needs
  menu-table patch), (b) overlay opened by a button combo (e.g. L+R+Select),
  fewer game changes. Recommend (b) first, (a) later.
- Persistence: see item 10 (save).

## Unknown

Game UI draw API, font coverage, where the options menu table lives.

## Acceptance

Boxes toggle features live; state survives pause/level change; no effect when
all boxes are off (parity unchanged).
