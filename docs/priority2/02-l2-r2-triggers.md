# 2. L2 / R2 triggers

Goal: use L2/R2 (emulator-mapped) for new actions, e.g. camera recenter,
weapon cycle, free-camera up/down.

## Known

- Nothing OBSERVED in this checkout. Legacy note: "L2 latency" was reported by
  the owner for the v0.1 prototype (UNKNOWN cause).
- PSP hardware has only L/R; L2/R2 exist only if PPSSPP maps extra buttons into
  guest-visible pad bits or reserved fields (INFERRED, verify in 1.20.4).

## Unknown

- Which pad bits/fields the emulator sets for L2/R2.
- Latency source (poll once per frame at 60 FPS vs. 30 FPS-era sampling).

## Approach

Share the input mailbox from item 1. Bind actions through a small table
(`action -> source -> mode: press/hold/toggle`) so the checkbox menu (item 8)
can rebind them. Avoid actions already bound by the game (L/R camera).

## Protocol

Press-and-release test with frame counter: log frames between host event and
guest-visible bit; must be <= 1 frame at 60 FPS.
