# 3. Camera speed

Goal: configurable camera rotation/follow speed that matches 30 FPS feel at 60.

## Known

- INFERRED: the C1 fix (3 words) makes delta-based systems correct; the camera
  may or may not be delta-based. Not measured here.
- Legacy report (OBSERVED, `OVERCOMPENSATED_VUE_ENSEMBLE.md` via MIGRATION.md)
  discusses camera but gives no verified speed parity.

## Unknown

- Whether the camera follow/rotation is delta- or per-call-step-based.
- Location of rotation-rate and follow-lerp constants.

## Approach

1. First measure parity (A vs B vs C): rotate with left-stick/L-R for 2 s from a
   fixed pose, record yaw per second (value-scan on yaw float, `frametime.py`
   for pacing).
2. If B/C differ from A by 2x, it is a Priority 0 defect: fix with the targeted
   method (constant or half-step), not a user option.
3. Only then expose an optional speed multiplier (stored in the config struct
   of item 8).

## Acceptance

yaw/s at C within measurement noise of A for identical input.
