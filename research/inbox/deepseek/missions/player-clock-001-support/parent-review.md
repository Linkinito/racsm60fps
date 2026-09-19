# PLAYER-CLOCK-001 support — bounded parent review

2026-09-19. Resume HEAD: `596800a4767b478f3b2c7237c80d35c458063981`.
PARENT_HANDOFF read first; no worker restarted. Scope: address provenance and A0
entry gates. Raw reports preserved; no full-review claim.

## Arbitration

- Explorer §1.8 disputes code-base+0x5A838. Parent independently checked reference
  SHA256, both PT_LOAD headers, instruction pair and PSP relocation records.
  See `research/v2/pokitaru/verify-player-address.py` and generated
  `player-address-evidence.json`. OBSERVED r_info: 0x00010005/0x00010006.
  Simple code-base rebasing is SUPERSEDED. Explorer's claim that stripped symbols
  prevent static resolution is not adopted: PSP segment relocation semantics
  remain to check; no impossibility was established.
- Mapper §10 calls the full socle B3, conflicting with the active task. Use task
  labels: B3=U+P, D=U+G+S+P. Its absolute rate table is conditional prediction.
- Skeptic §§6,8,11,12 reinforce independent-cadence and outside-loop gates.
  Its analytic falsification remains conditional on cadence, branch, resets and
  delta delivery. No gameplay hypothesis is newly rejected or promoted to TESTED.
- Explorer §1.9 inspected bundled 1.19.3; active debugger reports 1.20.4.
  String-search absence does not establish native replay unavailability.
- WF-002 caller chain and animation ownership claims are not adjudicated here.

## Read-only inspection

Evidence: `research/live-tests/pokitaru/player-clock-001/inspection-1789828734941/record.json`
and script snapshot/hash; entry point `inspect-code.mjs` in its parent directory.
Process observed: PID3404, `C:/Program Files/PPSSPP/PPSSPPWindows64.exe`;
netstat linked port60907 to that PID. Process command-line query denied.
Debugger: PPSSPP v1.20.4, UCES00420 1.00, active rcp1 at 0x09139D00.
Module name/address alone do not establish LEVEL_01 identity.

Owner reports normal boot from a save, Pokitaru, vanilla. This is testimony,
not full independent A0 verification. No savestate was loaded here.

OBSERVED via memory.disasm replacements:false: G=0x3C043D08, S=0x2A240002,
P=0x46006506, U=0x0E4BE449. U target 0x092F9124 equals reported base plus
file target RVA 0x1BF424. These selected words match reference originals after
relocation, but do not prove complete vanilla code, routes, plugins or state.
Raw memory.read_u32 returned 0x6829F14E/0x683BEDF6 at G/U; do not treat these
emulator representations as game patches. replacements:false on the raw endpoint
did not remove them.

Live pair 0x3C100947/0x26101640 forms 0x09471640, differing from code-base+
0x5A838 (0x09194538). Address formation OBSERVED; Ratchet identity UNKNOWN
until entry-register and controlled-motion correlation. No player fields sampled.

Earlier inspection-1789828618190 (raw-only) and inspection-1789828697967
(stopped at disassembly macro) retained. Their script hashes were recorded but
intermediate source snapshots were not retained; final snapshot is reproducible.
Final reader handles macro encoding arrays. None is a gameplay/cadence trial.
No input, pause/resume, breakpoint, state-load or memory-write requests issued.

## Next gate

Identify active ISO/config, verify ISO-extracted LEVEL_01 and routes/plugins,
preserve the current session, establish isolated reproducible A0 lineage. Check
native replay on 1.20.4 and validate player/clock observables. Then three A0 trials,
short B0 and informative B1 per task. No further worker run needed for this gate.
