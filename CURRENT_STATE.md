# Current parent checkpoint

Updated 2026-09-20. Priority0: UCES00420 original30 -> faithful60 parity.
Branch verified: v2-research. Review-start HEAD:
c038b38b5c3ea30bac37e987165b42fe500c68a1 (reverify on resume).

## Active mission and durable synthesis

research/tasks/timing-atlas-parent-review-001.md — parent arbitration/synthesis only.
All three timing-atlas-global-001 reports read; completion metadata: all exit0,
WORKERS_COMPLETE / READY_FOR_PARENT. No PPSSPP control, worker launch, patch or
binary edit in this review. Existing unrelated dirty files were preserved.

Canonical review:
research/inbox/deepseek/missions/timing-atlas-global-001/parent-review.md
Standalone next test:
research/live-tests/pokitaru/player-clock-001/NEXT_RUNTIME_GATE.md
Minimal resume:
research/inbox/deepseek/missions/timing-atlas-global-001/NEXT_SESSION.md

## Accepted architecture and corrections

- 0x1517C constructs one shared ~1/30 delta and fans out to 0x87A84, 0x6B7F4,
  0x2FFF0, 0x6B618. Target 0x151E8 -> 0x88768; hidden delta effect there rejected.
- Direct callers 0x15AA8/0x15B18 sit in a phase/state-table region referenced at
  .rodata 0x1C02C8. Table owner, thread and real-time dispatch cadence UNKNOWN.
- Player chain: 0x2FFF0 -> 0x2FB8C; normal path calls 0x360A4 before two passes.
  Gate is exactly 1 / 0 / post-loop 1. Only last two of seven loop callees receive
  explicit delta: 0x39B74 and 0x1EBC4.
- +0x578=dt*30 supports N-VEL (0x328A0 displacement division) and mixed N-TIMER
  (0x42C04). Global dt*60 rewrite REJECTED. Local scalar x2 at 0x2FBBC is too
  early because it also scales outer accumulators. No replacement patch approved.
- Tags: O/S/D/N-VEL/N-TIMER/C/F30/F60/R/E/V/H/U; heterogeneous even in 0x39B74.
- At 0x96648 bne skips 0x96650 when vcount != stored+1. Second wait is reached
  on equality: normal second VBlank wait, skipped when already late. Mapper's
  opposite 'catch-up wait' interpretation REJECTED. B0 cadence effect UNTESTED.
- Weapon 0x1EBC4 callers: 0x1E4E8,0x1E610,0x2FCF0. Count 0x2FCF0 for substep
  attribution. Weapon+0x40 -> descriptor+0x1C -> jalr; f12 carries scalar.
- LaserTracer local rate30/reciprocal/rate60 branch CORROBORATED; 12/12 module
  presence correspondence, LEVEL_07 three-hit anomaly unresolved. Gate reset
  does NOT prove second dispatch. Global-clock and twice-per-outer claims rejected.
- 0x6EBE4-region 0xF8 record walk is a promising entity-manager candidate;
  global Moby ownership and cadence UNKNOWN.
- Atlas preserves 150 L01 candidate class records / 534-name union. +0xC update
  role anchored for selected classes only; descriptor presence is not runtime use.
- L03 0x15AA84-region adds field+0x48 to field+0x34; Lvl3Platform association
  INFERRED from heuristic boundaries. Acid/fluid ownership unresolved.
- Universal RVA+0x74 REJECTED. Use containing file-backed PT_LOAD. L01 segment1
  uses RVA+0x70; 0x2DD1F8 -> file0x2DD268. Runtime relocation is separate.
- Current Data/BIN/LEVEL_02 vanilla hash:
  0037689a926197969231795c4d6b05980e5e94558394617b21e8b8bcd79bc8aa, loop2.
  Old 8b25dc88... manifest contamination is historical, not current baseline.

## NEXT ACTION

Parent review COMPLETE; documentation and bounded static checks passed. STOP here.
Next runtime-authorized session: execute NEXT_RUNTIME_GATE.md A0 -> B0 (NOP only
at loaded base+0x96650) -> exact saved-word restoration/control. Do not rerun
completed static missions. Seven primary counters, branch outcomes, independent
clock/observer calibration and +0x574 slope/+0x578 readouts are mandatory.
All-site doubling supports shared level scheduling in that scene, not proven
whole-game doubling. No A0/B0/C gameplay parity has been promoted by this review.

Existing isolated lab: research/live-tests/pokitaru/player-clock-001/isolated-20260919T150446Z/.
PID/port/scene/checkpoint lineage are stale and were NOT inspected this mission.
Rediscover before use; no new emulator instance. Prior normal/JIT probes are not
free-running wall-clock cadence evidence. Existing logger capability/coverage must
pass the gate; if unavailable, record precise tooling blocker instead of guessing.
