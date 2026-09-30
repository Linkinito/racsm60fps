# LEVEL_03 Lvl3Elevator companion PRX experiment — 2026-09-23

Historical v3, restricted to LEVEL_03. The current builder now produces the
[five-module v4 candidate](GENERALIZED-COMPANION-PRX.md); the Kalidon runtime
results below apply to v3 only.

Status: **TESTED on one freshly initialized Kalidon instance; still experimental**. The owner
specified a companion PRX delivery route. No ISO or original game asset was
modified. The archived v0.6.4-no-menu companion source and installed legacy
binary remain unchanged.

## Bounded change

`build-companion-prx.py` hash-checks the archived C runtime, copies the
profiler project into ignored `build/`, and adds one LEVEL_03 timing descriptor
to the existing full-patch transaction. It targets runtime module base plus
RVA `0x153BF4`; exact original word `0x3C063D08` becomes `0x3C063C88` only
when the companion selects the 60 FPS path. The existing preflight, code cache
sync, write readback, rollback, health check and restore paths own the extra
entry. It rejects an overlapping site or exhausted entry capacity. The 30 FPS
selection performs a read-only preflight and installs no game write.

The experiment has its own plugin folder and log/config paths. Its
`RCSMProfiler.ini` requests `global_60fps`, `frame_rate=60`,
`allowed_module=3` (LEVEL_03), `full_layers=1` (base only), one stable 50 ms
poll, and the archived wrapper policy lists. The module's 33 wrapper callsites
remain subject to those policies (27 effective two-pass, 6 one-pass; 13 custom
policies fall back to two-pass). Thus a live ride under this plugin is **not**
automatically identical to the earlier three-word C1 RAM setup. The legacy
plugin still carries other base-layer behavior; this is a bounded experiment,
not a release parity claim.

## Build and checks

- Archived runtime SHA-256:
  `e6ebc8af1eae253af9721a4a61b8dffc8888d3258330c44f236cf451cd535b5f`.
  Overlay runtime SHA-256:
  `aa4326c39710bf37b708e73b120b4966f5d94ace564f2003a2f4f6200ca6635a`.
- Existing PSPDEV Windows toolchain compiled the isolated source with
  `-Wall -Wextra -Werror`. Experimental `patch.prx`: 81,422 bytes, SHA-256
  `9f316ed9348c36fb7911272b3f68f0ae71aebf2826df3bd50aacde686105745e`.
  The ignored `build/companion-overlay-manifest-v3.json` records inputs and
  outputs. Rebuild from a clean checkout with
  `python patches/experimental/lvl3-elevator-halfstep/build-companion-prx.py`.
- The archived PSP PRX validator passed 912 static/binary checks on the
  experimental binary. The policy-config validator passed for LEVEL_03 and
  33 armed callsites. Their ignored JSON outputs are
  `build/companion-overlay-validate-v3.json` and
  `build/companion-config-validation-v3.json`. These gates do not execute the
  game or prove the new descriptor runs early enough.
- The binary and two INI files were copied into a distinct installed folder,
  `C:/Users/linki/Documents/PPSSPP/PSP/PLUGINS/Lvl3ElevatorExperimental`.
  Installed binary SHA-256 matched the build. The original plugin folder was
  not overwritten. With PPSSPP closed, `EnablePlugins` was changed from False
  to True and the old profiler plugin's UCES00420 mapping from true to false.
  The ignored `build/plugin-activation-record.json` pins both original and
  active settings hashes for restoration after the live test.

## Runtime gate and limits

The owner's first restart loaded PPSSPP savestate slot 1: the plugin started
but did not arm, and the already-created elevator retained vanilla increment
`0x3C5A740F`. That is not a valid test of this initializer. The owner then
restarted, continued from a normal in-game save and returned to Kalidon
without a PPSSPP savestate. The plugin armed LEVEL_03 at relocated base
`0x0914CD00`; readback found the C1 words and initializer `0x3C063C88`.
The freshly bound instance had pvar increment `0x3BDA740F` without a direct
pvar write. Two complete rides measured 2.5473 s and 2.5021 s, near the
direction-matched A0 2.494–2.501 s reference. Full methods, raw captures,
hashes and limits are in the [live PRX report](../../../research/live-tests/kalidon/lvl3elevator-companion-PRX-REPORT.md).

After the owner closed PPSSPP, the original global plugin flag and old plugin
mapping were restored and the experimental plugin mapping disabled. PPSSPP's
other preferences were preserved. The one-instance result does not establish
animation, interaction, transition, trajectory or wider gameplay parity; the
candidate stays under `patches/experimental/`.

A later [matched A0/PRX owner session](../../../research/live-tests/kalidon/lvl3elevator-A0-PRX-visual-comparison-REPORT.md)
measured a complete direction-1 A0 ride at 2.497471 s and a fresh companion
ride at 2.541371 s, with identical sampled endpoints. The owner found A0
animation/arrival/interaction normal and perceived the PRX ride as the same
behavior, smoother. The 1.76% direction-1 timing gap persists across the
earlier and later captures; its cause remains UNKNOWN. The owner accepts
this small difference provisionally for this comparison because the
measurement protocol may contribute. It is not a game-wide tolerance or
validation. Plugin settings were restored afterward.
