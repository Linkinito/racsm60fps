# 1. Right stick

Goal: camera control with a second analog stick (emulator pad right stick).

## Known (repo evidence)

- OBSERVED (legacy, MIGRATION.md "Input and second-stick prototype"): a v0.1
  prototype `RACSM_Controls` existed (`source/main.c`, `NOTES_TECHNIQUES_FR.md`)
  with historical camera/input coordinates. Source lives only in tag
  `legacy-60fps-pre-v2` / owner archive, not in this checkout.
- Owner feedback (UNKNOWN beyond feedback): `AnalogIsCircular=True` reportedly
  changed the feel. Special-camera coverage (non-standard camera modules) unknown.
- The PSP has one analog nub; any right stick must come from the emulator
  exposing extra axes or from mapping the right stick onto existing inputs.

## Unknown / to verify

- How PPSSPP exposes the right stick to guest code (extra bytes in the
  `SceCtrlData` reserved area vs. mapped to buttons) in 1.20.4. INFERRED only.
- Where the game reads pad data and where the camera consumes yaw/pitch input.

## Approach

1. Hook the pad read (sceCtrl wrapper in the module, or a stub at the game's
   own pad-poll function found with `write-probe.py`/`call-probe.py`).
2. Find the camera yaw/pitch accumulators: nudge left stick with the game's
   camera in a known state, `value-scan.py` for the changing floats.
3. Add `right_stick * speed * dt` to those accumulators (dt-based, so it is
   correct at 60 FPS and independent of the parity fix).
4. Recover the legacy `RACSM_Controls` constants from the tag and mark them
   OBSERVED-legacy until re-measured.

## Protocol / acceptance

Fixed camera pose, push right stick fully for 2 s, record yaw delta; repeat at
A (30) and C (60): deltas must match. Check deadzone (no drift at rest), pause,
cutscenes, special cameras (Airboard, Giant Clank) do not break.
