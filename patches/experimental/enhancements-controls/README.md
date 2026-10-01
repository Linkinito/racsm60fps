# Enhancements: controls (Priority 2, optional, separable from parity)

Status: EXPERIMENTAL, imported 2026-10-01 from the legacy RACSM_Controls v0.1.0-poc
(`01-Travail-.../snapshot-original/RACSM_Controls`, unchanged source, MIT). Not rebuilt or
re-tested in this session. Parity patches do not depend on it.

What it does (OBSERVED in source): signature-gated hook of the common camera-input function
(LEVEL_01 RVA 0x3060) and controller update (0x75454). PPSSPP "Advanced PSP controls" right
stick (Rx/Ry) is converted into L/R and D-pad presses only during the camera call, scaled by
stick amplitude; Dev-kit L2/R2 (0x0400/0x0800) are stripped from the game's button mask and
optionally aliased to existing PSP buttons (`racsm_controls.ini`).

Static review (INFERRED, 2026-10-01):
- The game's own function 0x3060 reads the injected buttons only if camera flag
  0x2DD451 bit 2 (0x04) is set, so scripted cameras that clear it ignore the stick.
  Pitch additionally needs bit 3 (0x08), which the plugin forces during the call.
- Camera consumers 0x35B0 (yaw, needs state 0x2DD4C0==2) and 0x37AC (pitch, 0x2DD4D4==2)
  run per call with literal 1/30 steps. At C1 (once per frame) manual camera turns 2x too
  fast; the stick inherits that. Fix: `tools/runtime/fixes.py --fix camera` (3 `lui` words
  0x3D08 -> 0x3C88 at 0x308C, 0x361C, 0x37E0). STATIC_CANDIDATE, not tested live.

Next tests: (1) `--fix camera` with L/R alone vs original30 speed; (2) plugin with right stick
in free roam, aiming, turret, Clank, vehicles, a scripted sequence; (3) coexistence with
InterpGate (only plugin-load order/hook conflicts matter); (4) L2/R2 alias choice.
