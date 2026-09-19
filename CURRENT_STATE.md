# Current parent checkpoint

- Project: Overcompensated V2 / UCES00420; Priority0 30->60 behavioral parity.
- Branch: v2-research. Verified resume HEAD: 596800a4767b478f3b2c7237c80d35c458063981.
- PLAYER-CLOCK-001 explicitly resumed by owner on 2026-09-19.
- Active task: research/tasks/pokitaru-player-clock-001.md.
- Support mission completed; handoff read and targeted parent review recorded.
  No workers restarted. Infrastructure task remains complete.

## Durable findings

See support mission parent-review.md for arbitration and precise evidence.
Static verifier confirms player address operand has PSP relocation records.
Code-base+0x5A838 interpretation is SUPERSEDED in the four-change map.
Live read-only inspection: PPSSPP v1.20.4 / UCES00420, rcp1 at 0x09139D00;
relocated pair forms 0x09471640; Ratchet identity remains UNKNOWN.
Four decoded core words match reference originals (U JAL after relocation).
Raw memory.read_u32 exposed emulator words at G/U; memory.disasm with
replacements:false returned originals. Selected sites do not prove full vanilla.
Latest evidence: research/live-tests/pokitaru/player-clock-001/
inspection-1789828734941/record.json and script.mjs. Earlier attempts retained.
No input, pause/resume, breakpoint, state load or memory writes requested.

Owner reports normal boot from save, Pokitaru, vanilla. This updates prior scene
uncertainty as testimony, not independent A0 verification. Process observed at
C:/Program Files/PPSSPP/PPSSPPWindows64.exe, PID3404, port60907; rediscover on
resume. Process command-line query denied.

## Hypotheses / unresolved gates

No controlled gameplay result or new TESTED hypothesis. Mapper full-socle B3
label conflicts with task: use D; B3 remains U+P. Rate predictions are conditional.
Outside-loop counter divergence remains a prediction, not gameplay falsification.
Active ISO/hash, independent LEVEL_01 provenance, full routes/plugin/config,
save identity, player field semantics, replay and independent clocks remain to
verify. Active emulator is 1.20.4, not worker-inspected bundled 1.19.3.
WF-002/animation worker claims remain unreviewed until needed.

## NEXT ACTION

Identify active ISO/config read-only; verify ISO-extracted LEVEL_01 and active
routes/plugins. Preserve user session and establish isolated reproducible A0 from
normal-save/cold-boot lineage. Check native replay on 1.20.4, validate player
observables and independent cadence; then three A0 trials, short B0 and B1.
Do not rerun completed workers or infrastructure tests.

## Exact next-session files

AGENTS.md -> CURRENT_STATE.md -> research/tasks/pokitaru-player-clock-001.md ->
research/inbox/deepseek/missions/player-clock-001-support/parent-review.md ->
research/live-tests/pokitaru/player-clock-001/RESUME.md.
Use research/EVIDENCE_INDEX.md for deeper evidence. Static address evidence and
map live in research/v2/pokitaru/. Do not routinely reread full worker reports.
