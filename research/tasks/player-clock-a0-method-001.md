# PLAYER-CLOCK-A0-METHOD-001 — PPSSPP baseline instrumentation

Read-only external DeepSeek mission, distinct from completed player-clock-001-support.
Parent alone controls emulator. No debugger connections, launches, writes to game,
config, source or saves. Reports returned through the existing host mechanism.
Do not restart or repeat completed static gameplay research.

Question: how can the parent establish isolated, reproducible vanilla A0 and
independent player/outer/VBlank observations on the active PPSSPP version?
Last directly reported version is v1.20.4; owner says PPSSPP updated. Do not assume
this is globally latest or that older 1.19.3 findings apply unchanged.

Start: AGENTS.md; research/tasks/pokitaru-player-clock-001.md;
research/inbox/deepseek/missions/player-clock-001-support/parent-review.md.
Use research/EVIDENCE_INDEX.md for narrowly relevant evidence only.
Primary upstream: https://github.com/hrydgard/ppsspp (version-tagged source/docs).
If source unavailable, report exact missing evidence; do not infer API parameters
from strings alone. Record URLs/version/commit and exact symbols/lines inspected.

## Explorer scope: replay, debugger and independent clocks

Investigate native input replay/TAS support in 1.20.4 (not GPU replay), debugger
frame/VBlank/input synchronization APIs and their exact request/response schemas.
Determine available VBlank, emulated tick, outer-function entry counters and
low-overhead counting/breakpoint/logging mechanisms. Distinguish free-running
wall pacing from paused frame advance. Recommend minimal measurement protocol
with cleanup, limitations and overhead calibration. No emulator access.

## Mapper scope: ELF identity and replacement normalization

Inspect PPSSPP ELF/PSP relocation and debugger disassembly source. Resolve raw
r_info 0x00010005/0x00010006 at LEVEL_01 RVAs 0x30014/0x30018, segment bases
and link-time 0x5A838; explain observed 0x09471640 given code base 0x09139D00.
Source: research/v2/pokitaru/player-address-evidence.json and its verifier.
Determine reproducible read-only comparison of loaded code with ISO PRX, including
JIT/emuhack words, replacements:false, macro encodings, relocations, and protected
PRX extraction/decryption if needed. Identify exact byte ranges valid for identity
checks; do not claim selected-word matches establish whole vanilla state.

## Skeptic scope: isolation and provenance protocol

Inspect version-tagged command-line/memory-stick/config behavior: explicit config,
save roots, per-game settings, plugins, cheats, portable install and multiple
instances. Design minimal isolated cold-boot setup using COPIED ordinary save and
read-only original ISO. Parent must not navigate or overwrite original session.
State how to prove active paths and avoid wrong-config fallbacks, writes into
original save roots, shared debugger ports, input leakage and save contamination.
Critique the experiment gates and identify a short sufficient checklist; do not
inflate requirements unrelated to PLAYER-CLOCK-001. No live access.

## Output

Evidence-labelled English report with concrete recommendations, contradictions,
UNKNOWN and next discriminating checks. Append required PARENT_HANDOFF_V1 block
per host instructions. No gameplay TESTED claim. Stop after bounded scope; no
additional workers or broad historical inventory.
