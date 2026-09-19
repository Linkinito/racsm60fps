# Current parent checkpoint

- Project: Overcompensated V2 / UCES00420; Priority0 30->60 behavioral parity.
- Branch v2-research; session-start HEAD c13068d134e5139985349fa0194e829bc15a167d.
- Active task: research/tasks/pokitaru-player-clock-001.md; resumed by owner.
- NEW mission player-clock-a0-method-001 launched detached, launcher PID31876.
  Explorer=replay/clocks; Mapper=relocation/normalization; Skeptic=isolation.
  Completion not checked; no polling. Task research/tasks/player-clock-a0-method-001.md.
- Completed player-clock-001-support and infrastructure missions not restarted.

## Durable findings

Current PPSSPP file/debugger version v1.20.4; owner reports emulator updated.
Process PID3404: C:/Program Files/PPSSPP/PPSSPPWindows64.exe, no command-line
ISO/config arguments. Port60907 observed; rediscover next session.
Fresh read-only inspection-1789829201941 confirms original four core words through
memory.disasm replacements:false (U after relocation). Raw reads expose emulator
words at G/U. Candidate player address pair forms 0x09471640; identity UNKNOWN.
Simple code-base+0x5A838 interpretation remains SUPERSEDED; see prior parent review.

Owner identified ordinary save slot5 and full-name Europe PSN ISO (not copy.iso).
Direct ISO9660 read confirms LEVEL_01.PRX hash exactly matches reference:
d10a81d076fb44987a45314a020cda2f7e8b39f860b957911ca9365464676571.
This closes reference-versus-user-ISO identity, not whole vanilla/runtime proof.
ISO/exe/config hashes and method: provenance-20260919T144757Z/record.json + script.py.
Candidate Documents/PPSSPP/PSP/SYSTEM config has no UCES00420 per-game file;
active binding UNKNOWN. EnablePlugins false vs LoadPlugins true, FrameRate30,
InternalResolution10 require exact version/runtime interpretation.
15 ordinary-save files copied and hash-verified before/after; local snapshot in
a0-staging-20260919T144841Z/local/save-snapshot, manifest beside it. All five slots
copied without assuming DATA4 mapping. Original session not navigated or changed;
no emulator/config clone launched. On-disk save copy does not preserve unsaved RAM.
All paths above relative to research/live-tests/pokitaru/player-clock-001/.

## Hypotheses / unresolved gates

No controlled gameplay result, no new TESTED claim. Full loaded code/routes,
active config/plugins, isolated save lineage, replay support, player observables
and independent cadence remain gates. Worker rate predictions stay conditional;
full socle=D, B3=U+P. No hypothesis changed by filesystem provenance alone.

## NEXT ACTION

One compact future-session status check for player-clock-a0-method-001; read its
PARENT_HANDOFF first, then targeted sections only. Review version-specific
isolation/replay/normalization method. Build isolated config and working copy of
preserved saves, select identified ISO/slot5, prove active paths/plugins, cold boot
and verify normalized code. Validate clocks/player fields before three A0 trials,
then B0/B1. Do not poll repeatedly or restart completed workers.

## Exact next-session files

AGENTS.md -> CURRENT_STATE.md -> research/tasks/pokitaru-player-clock-001.md ->
research/live-tests/pokitaru/player-clock-001/a0-preparation.md ->
research/inbox/deepseek/missions/player-clock-a0-method-001/PARENT_HANDOFF.md
(if complete). Mission task: research/tasks/player-clock-a0-method-001.md.
Use research/EVIDENCE_INDEX.md for deeper evidence, not broad report rereads.
