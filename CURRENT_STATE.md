# Current checkpoint - 2026-09-30

Priority 0: UCES00420 original30 -> faithful60 parity; experimental only.
Branch v2-research is local-only. Session-start HEAD verified: 39bca48;
Infrastructure: 74f6ef9; history rewritten on 2026-09-30.
Earlier chronology: research/live-tests/pokitaru/session-2026-09-30/SESSION-LOG.md.
This session: static Ghidra pilot only; no gameplay measurement/deployment.

## Latest recorded runtime environment

PPSSPP 1.20.4, Vulkan/RTX3060, FileLogging off; AMD start fault resolved by owner.
Only InterpGate IG-v9 enabled (passive until redirects); D1/D0/recorder off.
LEVEL_01 base 0x09139D00 without plugin, ~0x0916BD00-0x0916CD00 with it.
IG-v10 BUILT, NOT INSTALLED/TESTED. No PPSSPP change in this session.

## Durable findings (owner-observed unless stated)

Full original30/corrected60 gameplay parity UNKNOWN; visual acceptance is not
measured parity. C1 improves delta-based Ratchet/animation paths; remaining
fixed per-call defects mostly pump1 (0x15230->0x6B7F4, jalr0x6B9B8).
Rejected global D1/G1/G/GI/F1/H/I; animdisp0x6C318 PARKED (register freezes).
Targeted nav halves vector at0x2A8F0 via JAL sites0x29188/0x29334; Crab movement
accepted by owner, TMRobotHead/TorsoB/TrainingBot transfer untested. Crab attack
threshold0x2CF3C8 27->54 owner-accepted. Shrapnel0x191D7C half-step does not
correct crate debris. Player: seg1(+0x2DD108)+0x5A838; health f32+0x964.
Class table: research/v2/class-table/level01-classes.json, 150 descriptors,
67 configuration definitions; these do NOT prove runtime pvar layouts.

Particles: ablation bound0x15348->0x8CC18; update/draw coupled, no half-rate.
Walker jalr0x8CE54 dispatches pool animators; waterfall0xDE23C (life -1 per call),
others0x7E810/0xDE8A8 uncorrected. IG-v8/v9 flickered. Swap-remove at0xDE458..
0xDE484 breaks slot identity; IG-v10 only corrects live unchanged records using
constants+0x1C/+0x3C/+0x44. Its actual effect remains UNKNOWN until tested.

## Accepted targeted decompilation pilot

Active plan: docs/DECOMPILATION_PLAN.md. Evidence via research/EVIDENCE_INDEX.md
-> research/v2/targeted-decompilation-pilot-20260930/REPORT.md; method/hashes there.
Ghidra12.0.4 + installed Allegrex + Java26.0.1 work; existing source project
C:/Users/linki/SIZEMATTERS60FPS.gpr has canonical PRX hash, imageBase0,
54,806 APPLIED relocations, .cplinit0x2DD108, ZERO functions/instructions.
Accepted local copy: research/v2/decomp-candidates/_local/20260930r2/
PokitaruTiming20260930r2.gpr. TESTED: 150 descriptors/469 function-slot aliases,
10 decompiled functions; reopening confirms save, 36 initialized-block hashes
match source, no loaded-byte changes. Original PRX hash unchanged.
0x29188/0x29334 are JAL SITES, not function entries; first pseudo-functions
REJECTED, superseded first project preserved at _local/20260930/.
OBSERVED: 0x2A8F0 adds vector components to three fields without f12 scaling
in that addition. Upstream delta/units/eligibility UNKNOWN. Crab0x1254CC
increments indirect block+0x60 and compares threshold0x2CF3C8 (original27.0).
Counter resets/complete consumers UNKNOWN. Two P-code hits are candidates only;
no pvar types/signatures/full coverage/port/parity acceptance. Raw outputs ignored.

## 2026-10-01 mass decompilation and fix families (Claude, static only)

Local copy research/v2/decomp-candidates/_local/20261001-mass/ (5045/5045 functions).
Summaries (no code): research/v2/decomp-summary/; docs/DECOMP_STATUS_2026-10-01.md.
Fix list + test order + monitor protocol: docs/FIX_CATALOGUE_2026-10-01.md. INSTALLED
plugin: InterpGate IG-v16f lean (7.8 KB; Dayni Moon loads, IG-v15a crashed it); fixes.py
refuses a different loaded build. Live 2026-10-01: nav+nav2+crab+timer-patches Crab and
butterfly owner-accepted; session log research/live-tests/pokitaru/session-2026-10-01/.
Families (all untested): nav/nav2/cows (asm stubs), timer-patches Crab/TrainingBot,
frametimers, laser, frames30, age70, elevator, boatfade, particles/particles-all
(generic half-step, 47 animators), waterfall (spawn parity &1->&3, scroll), phases
(24 per-call fades/countdowns), clock (19 users of frame counter 0x2AF28C load a
half-rate copy; includes skill-point window 0xAC8: never also double 2760), pathanimals,
crank, laseracc, springs (0xE290 {k,d} refit, 28 sites), luna, spawn (allocator
throttle for continuous emitters), laserbeam; age70 now incl. Ryno/Blitz/BeeMine. Telemetry: --fix telemetry + tools/runtime/fix-monitor.py (rates per
game second, A0 baseline compare). REJECTED static: animdisp 0x6C318 (absolute point),
pickups 0x7248 (look-at matrix). LEVEL_01 static list closed; left
on game counter: 0x54EFC/0x77098/0x783B0/0x106698 stamps. EnemyWave +0x15C = enemy count.

## 2026-10-01 Priority-2 static survey (owner request; separable from parity)

Reports (local, unreviewed, inbox): research/inbox/camera-controls-static-20261001.md,
research/inbox/menus-debug-extras-static-20261001.md. FRONTEND.PRX decompiled
locally (_local/20261001-frontend, 893 functions). All INFERRED, none tested live.
Camera: no 2nd stick path (map right stick->L/R/dpad in PPSSPP, UNKNOWN if possible);
FOV const 0x2AA3C0; free cam = slot1 + selector 0x2AA3CC; cam speed has literal 1/30.
Loading screens: tools/runtime/loading-fps.py (4 EBOOT words) owner-observed 60FPS 1:1, stable.
InterpGate plugin.ini UCES00420 currently = false (owner testing without plugin; set true to restore).
PPSSPP crashed once loading Dayni Moon with InterpGate active (cause UNKNOWN).
Debug: unreachable DEV CHEATS level select (write 0xD to 0x21EDB4). Mini-Turret
Glove cut (stub only). 25 skill points, 23 free ids. Parity finds: L1 "train faster"
timer 2760 (0x173150/0x173214, fix 5520); save play time runs 2x at C1.
Blinking cause NOT found.
Built (untested): fixes.py --fix camera (cam speed 1/30->1/60); controls plugin imported to
patches/experimental/enhancements-controls (legacy RACSM_Controls, right stick + L2/R2). RetroAchievements: addresses listed, set UNKNOWN.

## Exact NEXT ACTION

1. Live, continue catalogue order: springs+spawn (crates), particles-all, waterfall,
   frametimers/phases/clock, then elevator/boat/pathanimals/laser. A0 baseline per place.
2. Tooling: plugin records count-up timer peaks (crab +0x60); guarded instance-edit tool
   (record offset from decompilation + value ranges) instead of ad-hoc scripts.
3. Promote/reject families from evidence; port accepted ones to other levels by signature.
Deferred work: docs/ROADMAP.md and prior session log.

Next-session files: AGENTS.md, this file, docs/DECOMPILATION_PLAN.md.
For the exact source question: EVIDENCE_INDEX -> accepted pilot REPORT/README;
selected r2 exports via its manifest. Scripts: research/scripts/ghidra/.
Live source only when needed: interp-gate/interp.c, tools/runtime/fixes.py.
