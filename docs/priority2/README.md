# Priority 2 workstreams (optional, separate from the 60 FPS parity patch)

Scope: owner request of 2026-10-01. Priority 0 (faithful 30 -> 60 FPS parity,
UCES00420) is unchanged; nothing here may be bundled into the parity patch
(PROJECT_GOALS.md, "Priority 2"). Every feature must ship as its own optional
plugin/cheat under `patches/experimental/`.

## Session constraint (blocker, stated honestly)

This documentation was written in a cloud container with **no game image, no
PPSSPP and no memory access**. No measurement was made. Every game-specific
claim below is therefore either quoted from repo evidence (with its source and
level) or `UNKNOWN`/`INFERRED`. Nothing is `TESTED`. Addresses are never
invented; each doc lists the probe that must produce them.

## Index

| # | Topic | Doc | Status |
|---|-------|-----|--------|
| 1 | Right stick | [01-right-stick.md](01-right-stick.md) | prototype history only |
| 2 | L2 / R2 | [02-l2-r2-triggers.md](02-l2-r2-triggers.md) | UNKNOWN |
| 3 | Camera speed | [03-camera-speed.md](03-camera-speed.md) | UNKNOWN |
| 4 | FOV / camera position | [04-fov-camera-position.md](04-fov-camera-position.md) | partial legacy values |
| 5 | Loading screens at 20 FPS | [05-loading-screens.md](05-loading-screens.md) | UNKNOWN cause |
| 6 | Menus (full map) | [06-menus.md](06-menus.md) | legacy leads |
| 7 | Blink 2x too fast | [07-blink-rate.md](07-blink-rate.md) | candidates SUPERSEDED/INFERRED |
| 8 | Custom checkbox menu | [08-checkbox-menu.md](08-checkbox-menu.md) | design |
| 9 | Debug menu | [09-debug-menu.md](09-debug-menu.md) | UNKNOWN |
| 10 | Statistics menu + save | [10-stats-and-save.md](10-stats-and-save.md) | design |
| 11 | New objectives / skill points | [11-new-objectives.md](11-new-objectives.md) | design |
| 12 | RetroAchievements | [12-retroachievements.md](12-retroachievements.md) | UNKNOWN |
| 13 | Free camera | [13-free-camera.md](13-free-camera.md) | design |
| 14 | Draw distance / pop-in | [14-draw-distance.md](14-draw-distance.md) | UNKNOWN |
| 15 | Miniturret Glove | [15-miniturret-glove.md](15-miniturret-glove.md) | UNKNOWN |

## Shared plumbing (applies to most items)

All items need the same three capabilities; build them once:

1. **Input hook**: read pad state (incl. extra axes) before the game consumes it
   (item 1, 2, 8, 13). One hook, one shared mailbox struct.
2. **Self-applying plugin** (already ROADMAP item 5): apply without the
   debugger, guarded by module identity as D1 did.
3. **Per-level porting by signature** (ROADMAP item 6): the engine is
   duplicated in each `LEVEL_xx.PRX`, so every address must be matched by
   function signature, not hard-coded to LEVEL_01.

Hard memory limit (observed 2026-09-30): more than two resident plugins crashed
Pokitaru loading (INFERRED memory pressure). Ship **one** combined Priority 2
plugin with feature flags rather than several plugins.

## Suggested order (by value / risk)

1. Menus + blink + loading screens (visible 60 FPS defects, may be parity items).
2. Input mailbox -> right stick -> L2/R2 -> camera speed -> FOV/position.
3. Free camera, draw distance.
4. Checkbox menu, stats, objectives (need save-format work).
5. Debug menu, RetroAchievements, Miniturret (existence checks first).

Items 5-7 can be parity defects (Priority 0) and should be triaged as such
before being treated as enhancements.

## Common experiment template

Each doc ends with a protocol. Record: PPSSPP version, backend, game
version (UCES00420), level, plugin build, method, raw numbers, hashes of any
local capture (captures stay local, see ../PUBLICATION_POLICY.md).
