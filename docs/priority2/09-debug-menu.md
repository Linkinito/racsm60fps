# 9. Debug menu in the game

Goal: find and re-enable a leftover developer menu if present.

## Known

Nothing in the repo (UNKNOWN). Many shipped games keep dead debug code.

## Approach (static + dynamic, local only)

1. String search in the modules for debug-like terms (e.g. "debug", "cheat",
   "warp", "level select", "god", "fps", "memcard"); results stay local
   (no string dumps in Git, PUBLICATION_POLICY).
2. For each hit, find its xrefs and whether any menu/input path reaches it.
3. If a code path exists but is unreachable: find the gating flag/branch and test
   by write-probe (set flag) before any patch.
4. Check the cheats directory conventions (cheats/eu|na) for existing entries.

## Acceptance

Either "no debug menu: evidence" (list of searched terms) or a reproducible
enable procedure with the exact flag/branch.
