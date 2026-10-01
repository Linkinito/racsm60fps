# 7. Blink twice too fast at 60 FPS

Goal: restore original blink timing (cursor, pickups, low-health, menus).

## Known

- INFERRED: blink phase is a per-call counter or float increment, so it runs 2x
  at 60 (same family as the other fixed-step defects in CURRENT_STATE).
- Legacy candidates (MIGRATION.md C6): static pause-cycle float candidates;
  the first extraction is SUPERSEDED and "not a validated blink patch".

## Unknown

Which blinks exist (menu cursor, health warning, collectibles, UI) and which
are delta-based (already fixed by C1) vs fixed-step.

## Approach

1. Catalogue each blink; time it A vs C with frame counter (frames per cycle).
2. For fixed-step ones: write-probe the phase counter; fix by halving the
   increment or doubling the period (targeted, per source), like `crab`.
3. Check whether menu blinks share one helper (likely: fix once).

## Acceptance

Blink period in seconds equal at A and C for every catalogued blink.
