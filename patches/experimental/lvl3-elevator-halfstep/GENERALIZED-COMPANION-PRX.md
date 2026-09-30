# Five-module Lvl3Elevator companion PRX candidate — 2026-09-23

Status: **experimental, statically checked; runtime tested only for the earlier
LEVEL_03-only PRX**. This is a companion PRX overlay. No ISO, original game
PRX, or savestate is modified by the build.

## Scope and mechanism

The v4 overlay extends the same half-increment initializer correction to all
five known `Lvl3Elevator` module copies:

| Game module | Initializer RVA | Wrapper callsites |
| --- | ---: | ---: |
| LEVEL_01.PRX | `0x1563E8` | 55 |
| LEVEL_02.PRX | `0x16B050` | 57 |
| LEVEL_03.PRX | `0x153BF4` | 33 |
| LEVEL_07.PRX | `0x166174` | 46 |
| LEVEL_24.PRX | `0x1367B8` | 23 |

The builder checks each reference PRX against its SHA-256 in `recipe.json`,
maps the executable ELF segment, and verifies the exact initializer and four
downstream context words. The runtime selects only these module indices in
`global_60fps` mode. For the selected module it adds one descriptor to the
existing full-patch transaction: expected `0x3C063D08`, replacement
`0x3C063C88`. The runtime checks the same four nearby instructions before
preflight. The existing transaction owns exact original-word preflight,
installation, code cache synchronization, readback, rollback and restore.
Modules outside the five-member allowlist receive no game patch from this
plugin. The original companion's base-layer and wrapper behavior remains
part of the selected modules; this is not a standalone one-word patch.

The package config uses `allowed_module=0` because the archived INI parser
accepts one module number or zero for unrestricted selection. The compiled C
allowlist narrows zero to the five indices above. Consequently the archived
config validator's aggregate 493-callsite result describes its **INI-only**
view, not the actual five-module gate. The per-module checks below confirm
the wrapper policy routes for each selected profile.

## Reproducible static checks

- `build-companion-prx.py` used the existing PSPDEV Windows toolchain with
  `-Wall -Wextra -Werror`. The generated source, binary, package and manifest
  are in ignored `build/` paths ending in `-v4`.
- PRX SHA-256:
  `0e3982d14926ed66eb8b4107bcfd7756d473fa2b2722468e8a5cf5a8ed778d39`
  (82,294 bytes). Generated runtime SHA-256:
  `2d39fc78e6ec4a5eb5ef8bcc57b9a477d6f58c9428ef25c61decb46669f9c738`.
- Archived `validate_prx.py`: PASS, 912 static/binary checks. This validator
  covers its 15-profile corpus; it does not assert the new C allowlist.
- Archived `validate_policy_config.py`: PASS separately with temporary
  `allowed_module` values 1, 2, 3, 7 and 24. Armed callsite counts were
  respectively 55, 57, 33, 46 and 23. Per-module JSON outputs are under
  ignored `build/config-validation-module-*.json`.
- The v4 generated C has the five-member gate in `prepare_patch_view` and
  the matching five-RVA switch in `prepare_full_patch`; both were compiled
  into the PRX. The reference-site verification and manifest bind the five
  offsets to their original game PRX hashes.
- With PPSSPP closed, the v4 PRX and config were installed in the existing
  experimental plugin folder. Installed hashes matched the package. The
  previous v3 PRX and INI files were copied to ignored
  `build/installed-before-v4/`. The experimental plugin's UCES00420 mapping
  remains `false`, and PPSSPP's global `EnablePlugins` remains `False`.

## Evidence boundary and next gate

The earlier LEVEL_03-only v3 companion was observed to arm on a freshly
initialized Kalidon instance after a normal in-game save. A direction-matched
A0/C1 comparison measured 2.497471/2.541371 seconds (1.76% difference),
with matching sampled endpoints. The owner saw the same animation, arrival
and interaction behavior, with smoother motion at 60 FPS, and accepts this
small difference provisionally for that comparison. See
[`COMPANION-PRX-EXPERIMENT.md`](COMPANION-PRX-EXPERIMENT.md) and the linked
live reports. These observations do not test the v4 binary or its four new
module routes.

The next runtime gate is a fresh initialization and readback in at least one
other listed module, followed by a complete ride and arrival/interaction
comparison against 30 FPS. Exercise the remaining listed modules and
transitions before any validated status. A PPSSPP savestate can restore an
already-created instance or interrupt plugin arming; use a normal in-game
save and re-entry for this initializer test. A larger defect would reopen the
timing model. The 1.76% Kalidon duration difference alone does not justify
another adjustment or define a game-wide tolerance.
