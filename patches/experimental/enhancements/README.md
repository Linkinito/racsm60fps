# OCEnhance — optional camera and controls plugin

French: [README_FR.md](README_FR.md). Priority 2: separate from the 60 FPS parity patch, every
feature is off unless enabled in `ocenhance.ini`. Status: BUILT, NOT YET TESTED LIVE.

## Features

| Option (`ocenhance.ini`) | Effect |
|---|---|
| `right_stick = 1` | right analog stick turns the camera (horizontal and vertical), proportional to the stick |
| `deadzone`, `invert_x/y`, `sensitivity_x/y` | stick tuning (sensitivity 10..300 %) |
| `l2`, `r2` | PPSSPP "Dev-kit L2/R2" mapped to an existing PSP action (OFF by default) |
| `fov_deg` | vertical field of view in degrees (original 31.5) |
| `cam_distance`, `cam_height` | follow camera distance (original 5.0) and height (original 1.14) |

## Install

1. Build: `python patches/experimental/enhancements/build.py --name <new-name>` (local PSP SDK).
2. Copy `build/<name>/OCEnhance/` to `PSP/PLUGINS/OCEnhance/` (patch.prx, plugin.ini, ocenhance.ini).
3. In PPSSPP map the right stick ("Analog right stick") and, if wanted, Dev-kit L2/R2.

## How it works

Derived from RACSM Controls 0.1.0-poc (MIT, `../enhancements-controls`), rewritten without libc
(about 9 KB resident). A worker thread finds the loaded level module (`rcp1`) and patches it only if
the camera-input function and the controller update are found exactly once by signature (all
gameplay levels; FRONTEND is ignored). The view constants are found by the value pattern
FOV 0.5498 / near 1.0 / far 10000 with distance 5.0 at +0x30 and height 1.14 at +0x3C, unique in the
15 level modules checked. Details: [../../../docs/DECOMPILATION_FINDINGS.md](../../../docs/DECOMPILATION_FINDINGS.md).

Note: at 60 FPS the game's camera turn speed is doubled until the parity fix `camera` is applied;
the stick inherits that speed.
