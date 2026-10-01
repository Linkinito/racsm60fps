# 5. Loading screens at 20 FPS instead of 60

Goal: loading screens animating/redrawing at the intended rate.

## Known

- Owner observation: loading screens run at ~20 FPS under the 60 FPS setup
  (OBSERVED by owner, not measured here).
- INFERRED: loading happens while the module streams data; the loader likely
  presents one frame per N I/O steps, not per vsync.

## Unknown

- Whether this is emulator I/O/timing (PPSSPP "fast memory", I/O timing,
  `sceDisplayWaitVblank` cadence), the 60 FPS patch (C1 words), or the original
  at 30 (A may also be low).

## Approach (decide cause first)

1. Measure A vs B vs C loading frame rate with `frametime.py` during a
   fixed load (same level, same savestate-free cold load).
2. Test PPSSPP settings: I/O timing method, "Simulate UMD slowness" off,
   frame skip off. If A is also ~20 FPS, it is an original behavior (not parity).
3. Find the loading screen's draw loop (the call that presents it) with
   `call-probe.py`; check whether presentation is per-I/O or per-vblank.
4. Only fix if C is slower than A; else document as original.

## Acceptance

Measured load-screen FPS table (A/B/C) with the same method.
