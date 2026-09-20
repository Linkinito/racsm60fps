# PARENT HANDOFF — timing-atlas-global-001
MISSION: timing-atlas-global-001
STATUS: WORKERS_COMPLETE / READY_FOR_PARENT
Worker claims only. ESTABLISHED means worker-reported observations, not parent validation. Consensus is not validation.

## explorer
ESTABLISHED: OBSERVED L01 raw words: 0x151E0/E4=1/30, jal0x88768, 0x361C,+1/30 and 0x3634,-1/30, 0x3FF6C/0x4000C=1/60 add/sub pair; full-report S1
CORROBORATED: Class->+0xC update registry (L01 150 classes, +0xC anchors LaserTracer 0x148CEC, Flamethrower 0x13B8F0); 12/12 match: modules with LaserTracer have an R60 rate init; report S2/S4
INFERRED: Lvl3Elevator 0x1562DC stores (1.0/speed)*(1/30) used per call by 0x156710; LEVEL_03 0x15AA84 is field+=field add.s, owner Lvl3Platform 0x158A18; report S6
CONTRADICTIONS: Parent acid site 0x15AA84 resolves to Lvl3Platform+0xC, not Lvl3DeadlyFluid; LEVEL_15/21 same text size+class list, different hash; no class present in all 15 modules; report S6/S7
REJECTED: Global 60.0f=timing (only 1 of 9 L01 lui0x4270 sites is the rate compare); descriptor word<textEnd as pointer test (0x2B95/0x1018/0x1084 false positives); my first c.eq.s census; report S4/S7
UNKNOWN: Call cadence for every non-player callback; role of descriptor +0x4/+0x8/+0x30; whether 12 R60 initializers are identical; L15/L21 provenance; report S8
TOP HYPOTHESES: H1 timing splits into engine-global (frame sync, camera F30, F60 timers), player-local (outer/substep), and class-local (fixed-step movers, rate-aware tracers); report S3/S6/S9
BEST DISCRIMINATING TEST: A0/B0 log of Lvl3Elevator 0x156710 progress rate plus callback count per second; separates fixed-step per-call (C) from delta-driven (O/D) ownership; report S11
BLOCKERS: No disassembler/decompiler/Python in this worker sandbox; hashes quoted from MANIFESTE_SHA256.csv, not recomputed; no runtime access; report S0
FULL REPORT REQUIRED: yes: S2 class registry with 150 L01 name->RVA rows, S4 per-module R60 RVAs and constant census, S10 scanner filters; handoff cannot carry the tables
SOURCE: workers/explorer.md (hash in workers/explorer-handoff.json)

## mapper
ESTABLISHED: L01: 277 jalr/20458 jal; 0x1517C called only from 0x15AA8,0x15B18; limiter entry 0x96490 has single caller 0x94B38; L02 Data/BIN == clean 0037689a; report S1/S4
CORROBORATED: All 15 SP modules carry 30.0f and 60.0f .data constants, 244-318 jalr, 559-834 mov.s f12,f20; FRONTEND has 0/0/19/37; independent per-module ELF parse; report S3
INFERRED: obj+0x40 -> class descriptor; slot 0x1C = weapon update, 0x20 = most common method (26 sites); 0xF8-stride entity pump callbacks +0xD4/+0xDC/+0xE0; report S2/S5
CONTRADICTIONS: Prior 'six sceDisplay callsites' vs 13 jal sites into the stub section (7 into 0x1BF424); prior L02 contamination absent now (hash equals BACKUP clean); report S4
REJECTED: Unconditional 'second VBlank wait': 0x96650 is a catch-up wait taken only when vcount != stored+1; section-wide sceDisplay counting; literal 0x208 flag store portability; report S1.3/S3
UNKNOWN: Reader of .rodata state table 0x1C02C8; dispatcher loading 0x2D4158; runtime writer of 0x2D2C04; thread/loop relation of 0x94B38 vs 0x15A80; report S9
TOP HYPOTHESES: H1 whole level frame 0x1517C doubles at B0 (engine-global); H2 only player chain doubles; H3 gate/rate-aware paths exempt (0x2B0208, 0x14CA70); H4 elevator is per-call 1/30 step; report S6
BEST DISCRIMINATING TEST: Per-second counts of base+0x1517C, base+0x2FB8C, base+0x1EBC4, base+0x96490 in A0 vs B0; all four x2 => H1, player-only x2 => H2; report S7
BLOCKERS: Read-only mission, no runtime access; indirect dispatch owners unresolved for 0x148CEC/0x1C02C8; no Capstone/Python (ConstrainedLanguage) so scans are PowerShell byte patterns
FULL REPORT REQUIRED: yes: S1 dispatcher map (VBlank catch-up, 3-caller weapon path), S2 descriptor records, S3 homology table, S8 scanner spec, S9 cadence-unknowables
SOURCE: workers/mapper.md (hash in workers/mapper-handoff.json)

## skeptic
ESTABLISHED: L01: 0x2FCB0=0x2E240001 sltiu r4,r17,1, stored 0x2FCB4 into 0x2B0208; jal 0x360A4 once at 0x2FC60; 0x328A0 computes 1.0/(+0x578) then stores velocity +0x28C/290/294.
CORROBORATED: LaserTracer 0x14CA70: dt=1/rate at 0x14CA80, c.eq.s rate,60.0f at 0x14CB10 (lui 0x4270 at 0x14CB08) picking 0x3F376E98/0x3F036F4E; DAT_2D2C04=30.0f; 0x2DD1F8=0x14CA70.
INFERRED: 0x1BF42C-return is compared with a stored counter (counter-query-like); 0x1BF424 is wait-like; camera 0x361C/3634 is rate*1/30 disguised delta; 0x39B74 1/60-per-substep implies ~60 substeps/s.
CONTRADICTIONS: REJECTED own prior skeptic claim: 0x2FCB0 dest is a0 not at, gate=1/0/1. Data/BIN/LEVEL_02.PRX now hashes 0037689a (clean) with slti imm=2: contamination not reproducible. LEVEL_15 vs 21 differ by only 14 bytes.
REJECTED: Single shared 1/30 producer (59-77 per-call stamped literals/module); RVA+0x74 as universal file mapping (fails above 0x2DD108); bare addiu/slti/bne tail as a player-loop discriminator (41 hits in LEVEL_01); corpus covering all timing calls.
UNKNOWN: B0 cadence effect (UNTESTED); identity of each of the 5 sceDisplay import stubs; whether NPC/projectile/camera/particle families share the outer cadence; 0x148CEC dispatch cadence; semantics of +0xA00..+0xA18, +0x9D4/+0x9D8, %3 damage path.
TOP HYPOTHESES: H1: limiter removal doubles outer cadence only if 0x96650 is a real wait, unproven. H2: post-loop gate makes 0x148CEC's block run 2x per outer call, so one-pass designs leave it 2x. H3: F30 sites split into disguised-delta vs embedded-step.
BEST DISCRIMINATING TEST: A0: count loop passes (base+0x2FCFC) and 0x39B74 calls/s; ~60/s with 2 passes confirms the 1/60-per-substep premise. Then compare 0x148CEC gated-block rate in A0 vs candidate C.
BLOCKERS: Static only, no runtime; sceDisplay import names absent from file so stub function identity stays INFERRED; no dispatcher resolved for the 0x2D4158 table; LEVEL_16-20 identity unverified.
FULL REPORT REQUIRED: yes: section 2 (byte-level rejection of the prior skeptic gate claim and the LEVEL_02 re-hash), section 7 (scanner mapping/pitfall spec), section 5-6 (falsification results and ranked runtime queue).
SOURCE: workers/skeptic.md (hash in workers/skeptic-handoff.json)

Machine counts, exit codes, timestamps and sizes: run get-deepseek-mission-status.ps1 -MissionId timing-atlas-global-001
