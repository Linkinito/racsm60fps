# Roadmap

Priority 0 remains faithful 30 -> 60 FPS behaviour (see [../PROJECT_GOALS.md](../PROJECT_GOALS.md)).

Owner re-plan, 2026-10-05: move from exhaustive static census to a playable,
measured vertical slice. Static work is demand-driven (one blocking question at
a time). The previous ordering (particles, annotated Ghidra project, Pokitaru
enemies, weapons, then plugin/porting) is superseded by the steps below.

## Steps

1. **Game map (offline).** Module -> content map (10 planets, arenas, Skyboard,
   Giant Clank, High Impact Treehouse; GPT task) and a full relocation-masked
   function bytematch of every LEVEL module against LEVEL_01
   (`research/scripts/match-module-functions.py`, Claude). Output: per-module
   shared/variant/unique code, so a fix found once is ported by signature and
   static work targets unique functions only.
2. **Standalone plugin.** Apply C1 and accepted fixes at module load without the
   debugger, locating sites by signature (step 1) so it works on several modules.
   GPT prepares the fix inventory (sites, words, status, caveats).
3. **Pokitaru vertical slice.** Owner plays C, reports what looks wrong; Claude
   measures only those points (A0/C1/fix) and corrects them.
4. **Weapons then armor.** Base rank for every weapon, then V4 and each mod; armor
   powers after. One fix per shared code family.
5. **Effects, particles, enemies.** By animator family and shared enemy class,
   ordered by visibility in play.
6. **Rest of the game.** Normal planets first (shared structure), then special
   modules (arenas, Skyboard, Giant Clank, Treehouse: unique functions only),
   then LEVEL_02 (use the clean copy, GOTCHAS 7j) and LEVEL_15/21, then menus.
7. **Validation and release.** Measured fixes promoted to `patches/validated/`;
   curated public release with a per-system parity report.

Roles: Claude tools, live tests and A/B/C measurement; GPT targeted static
questions only (unique or blocking functions, never the same code twice);
DeepSeek only as backup.

## Later (optional, separate from the 60 FPS patch)

- Developer convenience: skip language menu and intro videos (FRONTEND module).
- Quality of life: second analog stick, L2/R2, wider FOV, new skill points.
