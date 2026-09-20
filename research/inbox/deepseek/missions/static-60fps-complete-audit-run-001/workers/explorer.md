I completed a read-only Explorer bootstrap pass. The session's filesystem is read-only, so no `staging\explorer\` artifacts or `progress.json` could be created; everything below is the report content that should have gone into those files.

# EXPLORER REPORT — STATIC-60FPS-COMPLETE-AUDIT-001

Role: explorer. Runtime access: none. Repository writes: none (blocked by permissions).

## 0. Role status and hard blocker

- `reports\STATIC-60FPS-COMPLETE-AUDIT-001\staging\` does not exist. No Explorer-owned file was created.
- Write probe result: `Set-Content $env:TEMP\...` → `L'accès au chemin d'accès ... est refusé`. Sandbox is read-only, so `inventory_explorer.csv`, `implementation_instances_explorer.csv`, `discoveries_explorer.csv`, `shard_manifest.csv`, `progress.json`, `BOOTSTRAP_REVIEW_EXPLORER.md` and `EXPLORER_HANDOFF.md` were not written.
- Consequence: this session cannot persist shard rows. Coverage accounting is therefore `canonical names expected = 534 (asserted) / 538 (materialized); examined = bootstrap + targeted verification only; UNEXAMINED = full register`. Mission status under the stated completion gate is **PARTIAL**, not COMPLETE.
- Tooling actually available: PowerShell 5.1 in `ConstrainedLanguage`, `git`, `certutil`. Not available: `python`, `python3`, `node`, `objdump`, capstone, Ghidra, `Get-FileHash`, `Add-Type`, `[Convert]::ToInt64`, `[pscustomobject]` literal casts. Raw PRX bytes are readable but only by streaming the file (`Get-Content -Encoding Byte` has no `-Skip` in 5.1); each probe at offset ≥1.4 MB costs ~9-30 s.

## 1. Evidence found

### 1.1 Provenance of the binaries the audit depends on (OBSERVED)

The static corpus is not built from the in-repo `Data\BIN` copies but from `C:\Users\linki\Documents\PPSSPP\Overcompensated-Reprise-2026-09-14\development-v0.6.3-generalisation\prx-reference\`. I hashed the in-repo copies with `certutil` and compared to `vanilla-reference-manifest.json`: **15/15 SHA-256 match exactly** (modules 1-10, 15, 21, 22, 23, 24). Example: LEVEL_01 `d10a81d076fb4498...`, LEVEL_02 `0037689a92619796...`, LEVEL_15 `cebd5b53f4a7f0b4...`, LEVEL_21 `0e7a7f7d70a70e51...`.

So the atlas/scan evidence and the in-repo PRXs describe the same bytes. LEVEL_15 and LEVEL_21 have identical `.text` size and class lists but different hashes (`cebd5b53…` vs `0e7a7f7d…`); provenance of that delta remains UNKNOWN.

### 1.2 Corpus and implementation-instance baseline (OBSERVED)

From `static-inventory\counts.json`, `objects-by-level.csv`, `callbacks-by-level.csv`, `functions-by-level.csv`, `candidate-sites.csv`, `coverage-by-level.csv`:

- 15 modules/levels, 1927 object-module rows, 538 distinct object names, 5971 callbacks, 85452 heuristic functions, 38219 candidate sites.
- Candidate kinds: integer-unit RMW 6064; float RMW 14286; float multiplicative RMW 10873; float fixed-step RMW 3565; float constant-arithmetic store 3431; 37341 outside known wrapper families.
- Per-module (objects / callbacks / candidate sites): 1 Pokitaru 155/479/2897; 2 Ryllus 180/560/2960; 3 Kalidon 167/518/3055; 4 Metalis 171/535/2931; 5 Dreamtime 134/412/2744; 6 Medical Outpost Omega 137/423/2598; 7 Challax 168/522/2932; 8 Dayni Moon 217/686/3235; 9 Inside Clank 141/431/2608; 10 Quodrona 164/512/2792; 15 and 21 Giant Clank 10/30/1471 each; 22 Airboard-3 46/137/1670; 23 Airboard-6 104/319/2454; 24 High Impact Treehouse 123/377/2401.

### 1.3 Register reconciliation (this is the central Explorer finding)

The canonical 534-name union **is not materialized anywhere in the repository as a name list**. `CAMPAIGN_CONFIG.json` asserts `canonical_expected_names = 534`, `C1_RESIDUAL_TIMING_ATLAS.md`/`family-summary.json` assert 538 structured / 534 reviewed, and `timing-atlas-global-001\workers\explorer.md:74` asserts "Union = 534", but only the LEVEL_01 150-name subset is printed in that report; no union CSV/JSON exists (`rg --files -g "*union*" -g "*registry*" -g "*names*"` → nothing).

I reconstructed the register from the primary scan CSVs:

- Union of `objects-by-level.csv` names = **538**.
- Names whose ordinal-2 callback RVA is an exact function start in `functions-by-level.csv` = **531**.
- Names failing that guard = **7**: `Bolt`, `CrateChunk`, `CrateChunkController`, `CrateExplosive`, `CrateHealth`, `GrindrailController`, `LevelMusic` — identical to the atlas's `U1_NO_UPDATE_CALLBACK` list and to its "531/538 have at least one ordinal-2 callback" statement.
- Per-module ordinal-2-with-function-start counts: 150, 174, 160, 167, **128**, 130, **162**, **211**, 134, 158, 9, 9, 44, 103, 120.

`explorer.md:74` reports 150, 174, 160, 167, **130**, 130, **165**, **212**, 134, 158, 9, 9, 44, 103, 120 plus FRONTEND 2. Twelve of fifteen module counts reproduce exactly; LEVEL_05 (+2), LEVEL_07 (+3), LEVEL_08 (+1) do not. FRONTEND is not present in the 15-module structured inventory at all.

Therefore: 538 − 7 = 531, not 534; the "4-name drift" declared in the atlas is an under-specification (the real gap is 7 names versus the structured census, offset by an unstated number of FRONTEND/other-module names). **The membership of the mandatory 534-name register is UNKNOWN.** Practical recommendation: declare the materialized 538-name `c1-residual-timing-atlas.csv` the working register for all three roles, with the 7 `U1` names carried as explicit no-callback rows; re-deriving 534 requires re-running the timing-atlas-global-001 scanner, which is not reproducible from persisted artifacts (upstream `scan_static.py` needs Python + capstone + a sibling source tree).

### 1.4 PT_LOAD / RVA mapping (OBSERVED)

Direct ELF header and program-header decode of 16 PRXs (LEVEL_01, 02, 08, 15, 21, 23, 24, FRONTEND, …; `e_phnum = 2`):

- PT_LOAD0: `offset = 0x74`, `vaddr = 0`, flags R+X, size 0x1F4084-0x320404 depending on module.
- PT_LOAD1: `offset = vaddr + 0x70`, `vaddr = PT_LOAD0.size + 4`, flags R+W.

So "RVA + 0x74" is valid for the code/rodata/data segment covered by PT_LOAD0 (which is where every candidate-site RVA lives), and **wrong for PT_LOAD1**. This independently confirms the project's REJECTED claim that `+0x74` is a universal mapping.

### 1.5 LaserTracer / tracer timing dossier — direct vanilla-binary decode (OBSERVED)

I decoded raw little-endian MIPS from `Data\BIN\LEVEL_01.PRX` (file offset = RVA + 0x74). Anchors:

- `0x148CEC` (`LaserTracer_Update` per Ghidra note §10) is a real function `0x148CEC..0x149014`, first word `0x27BDFFC0`, and contains exactly **one** bounded candidate site: `float_fixed_step_read_modify_write` at `0x148E04`, `sub.s` on object field `+0x8` with constant `0x3F800000` (1.0). I.e. a per-call countdown of 1.0, not delta-scaled.
- `0x14CA70` lies inside function `0x14C474..0x14CC84` (2064 bytes, 3 float RMW candidates at 0x14C94C/95C/96C on fields +0x1bc/+0x1c0/+0x1c4, mirrored to +0x1f8/+0x1fc/+0x200, with a `jal 0xf5064`).
- Raw instruction trace 0x14CA70→0x14CC88 (all verified bytes):
  - `0x14CA70 lui r4,0x3F80` → 1.0f; `0x14CA7C lwc1 f16,0x2C04(r4)` with `lui r4,0x002D` → loads `0x2D2C04`.
  - `0x14CA80 div.s f13,f13,f16`; `0x14CA88 swc1 f13,0x2C08` → `dt = 1/rate` stored at 0x2D2C08; `0x14CA90 swc1 f16,0x2C0C` → rate copy at 0x2D2C0C.
  - `0x14CAA0 mul.s f12,f16,f12` with `0x3D888889` (1/15) → `rate/15` at 0x2D2C4C.
  - `0x14CAB8` `dt * 0x3F490FDB` (pi/2 ≈ 1.5708) → 0x2D2C88; `0x14CAD0` `dt * 0x3DB2B8C3` (≈0.087266 = 5°) → 0x2D2C90; `0x14CAE8` `dt * 0x3F060A92` (≈0.523599 = 30°) → 0x2D2C94; `0x14CAFC` `dt * 20.0f` → 0x2D2CA0.
  - `0x14CB08 lui r4,0x4270` → `0x42700000 = 60.0f`; `0x14CB10 c.eq.s f16,f14`; `0x14CB18 bc1f`; then two constant pairs selected by that branch: `0x3F036F4E` / `0x3F376E98` (damping20), later `0x3F036F4E` / `0x3E86F633` (damping40). Three such `c.eq.s rate,60.0f` + `bc1f` sequences exist in this window (0x14CB10, 0x14CB44, 0x14CBD4, plus 0x14CC0C).
  - `0x14CC5C mul.s f12,f13,f12` with `0x41400000` (12.0) → `dt*12`; `0x14CC6C swc1 f12,0x360C(r4)`; `0x14CC70 addiu r4,r4,0x360C`; `0x14CC74 swc1 f12,0x250(r4)`; `0x14CC78 swc1 f12,0x4A0(r4)`; `0x14CC7C jr $ra`; **`0x14CC80` (the return delay slot) `swc1 f12,0x6F0(r4)` → 0x2D3CFC**. This confirms Ghidra note §11's four config blocks at 0x2D360C / 0x2D385C / 0x2D3AAC / 0x2D3CFC, stride 0x250, and shows why a naive linear disassembler can miss the fourth (it is in a delay slot).
  - Data check: `0x2D2C04` (file 0x2D2C78) = bytes `00 00 F0 41` = `0x41F00000` = **30.0f**.
  - A second `jr $ra` follows at 0x14CC84, indicating at least one additional entry/exit path in this region.

This corroborates, at the byte level and on the vanilla reference bytes, the previously INFERRED/CORROBORATED LaserTracer claims (rate=30 data, `dt = 1/rate`, explicit `rate == 60.0f` branch with rate-dependent damping coefficients, four 0x250-stride config records). It also establishes a **mechanism split** that must not be collapsed: `RATE_LOCAL` init-derived globals in the 0x2D2Cxx/0x2D36xx region, versus `COUNTDOWN_PER_CALL` on `LaserTracer` field `+0x8` in the update itself.

### 1.6 Waterfall fixed-step control (OBSERVED static + PRIOR_RUNTIME)

`Level01Waterfall` (module 1, descriptor 0x2D48B8, callbacks 0x151AB4 / 0x151BEC / 0x151D78) update `0x151D78` candidate sites:

| kind | RVA | op | field | constant |
|---|---|---|---|---|
| integer_unit RMW | 0x151D9C | addiu | +0x79 | -1 |
| float fixed-step RMW | 0x151E7C | sub.s | +0x70 | -0.0166666675 (1/60, def 0x2D4890) |
| float constant store | 0x151E98 | add.s | — | +1.0 |
| float fixed-step RMW | 0x151EAC | sub.s | +0x4 | -0.0250000022 (1/40, def 0x2D4894) |
| float constant store | 0x151EC8 | add.s | — | +1.0 |
| float fixed-step RMW | 0x151FE4 | add.s | +0x0 | +1.0 (def 0x2D488C) |
| float constant store | 0x151FFC | sub.s | — | -1.0 |
| float RMW | 0x152038 | add.s | +0x8 | — |
| float constant store | 0x15204C | sub.s | — | -1.0 |

This is the static mechanism behind the matched A0/C1 runtime result: callback cadence 29.970540 Hz (A0) vs 59.939060 Hz (C1), ratio 1.9999326, with fixed per-call field steps unchanged. A linear per-call decrement such as `+0x70 -= 1/60` therefore advances exactly twice as fast in real time under C1. This is `C1_EXPECTED_INCORRECT` for the measured scene and the strongest concrete candidate class in the corpus, but the `+0x79` integer gate and the alternating branch must be modeled before proposing any per-call constant halving.

## 2. Provenance and file paths

Primary read:
- `AGENTS.md`, `docs\methodology\EVIDENCE_LEVELS.md`
- `research\inbox\deepseek\missions\STATIC-60FPS-COMPLETE-AUDIT-001\{SOURCE_PRIORITY,CONTEXT,MISSION,RUNBOOK,CAMPAIGN_CONFIG.json,INPUTS_NEEDED_FROM_PROJECT}.md`
- `research\EVIDENCE_INDEX.md`; `research\checkpoints\2026-09-20\CURRENT_STATE_complete_2026-09-20.md` (lines 76, 153-171, 269-296, 369, 419-435, 660-661, 760)
- `research\v2\c1-residual-timing-atlas\{c1-residual-timing-atlas.csv,C1_RESIDUAL_TIMING_ATLAS.md,family-summary.json}`
- `research\v2\ghidra-timing-findings-2026-09-20.md` §10, §11
- `research\inbox\deepseek\missions\timing-atlas-global-001\{workers\explorer.md:74,PARENT_HANDOFF.md,parent-review.md:174,256}`
- `01-Travail-et-profil-PPSSPP\Overcompensated-Reprise-2026-09-14\research-2026-09-18-global\static-inventory\{counts.json,objects-by-level.csv,callbacks-by-level.csv,functions-by-level.csv,candidate-sites.csv,coverage-by-level.csv,vanilla-reference-manifest.json}`
- `02-Jeu-et-dumps\Data\BIN\{LEVEL_01,02,08,15,21,23,24,FRONTEND}.PRX`
- PRIOR_RUNTIME (read-only): `research\live-tests\pokitaru\waterfall-001\a0-owner-session\A0_WATERFALL_REPORT.md`, `...\c1-owner-session\C1_WATERFALL_REPORT.md`, `research\live-tests\pokitaru\player-clock-001\A0_B0_2FCFC_STOP_COMPARISON.md`

Git HEAD at session start: `289964fac799ce88dc73bb904a5f44e8dc9c0de1`, worktree dirty (57 entries). No file was modified.

## 3. Historical observations

- CURRENT_STATE line 369 states "534 distinct class names across the scanned gameplay corpus"; line 76 and line 760 still state no valid A0/B0 cadence experiment has completed.
- EVIDENCE_INDEX 2026-09-20 entries post-date that prose: A0/B0 true-stop comparison at player callsite `+0x2FCFC` reports complete-cycle A0/B0 ratio `1.9999671809` and marks the older direct-callsite-cadence UNKNOWN as SUPERSEDED **for that Pokitaru scene only**; A0/C1 Waterfall reports 29.970540 Hz vs 59.939060 Hz (`1.9999326`).
- Preserved REJECTED/SUPERSEDED (all present in CURRENT_STATE/Ghidra note, none resurrected here): `0x151E8 → 0x884A4` (correct target `0x88768`); global `dt*30 → dt*60` (blocked by `0x328A0` normalization); forcing `player+0x578 = 1`; historical local player x2 scalar as clean architecture; `DAT_002D2C04` as game-wide master clock (SUPERSEDED, local tracer subsystem); Flamethrower `%3 → %6` frame decimation (SUPERSEDED — pseudo-random modulo; direct damage semantics REJECTED); bare loop-tail patterns as player-loop identifiers; universal `RVA + 0x74`; LaserTracer rate logic as a game clock; post-loop gate restoration as proof of a second dispatch.

## 4. Contradictions

1. 534 vs 538 vs 531: no persisted 534-name list; strict reconstruction yields 531; explorer.md per-module counts disagree with the structured inventory at LEVEL_05/07/08; FRONTEND (2 classes, per explorer.md) is outside the structured inventory. Preserve both; the register itself is UNKNOWN.
2. CURRENT_STATE's "no valid A0/B0 cadence experiment" vs newer dated EVIDENCE_INDEX A0/B0 result. Newer evidence applies only to the tested Pokitaru scene/callsite.
3. `explorer.md` guard wording ("require target ∈ [0x10000, .text_end) and ideally a known prologue") does not reproduce its own counts; the persisted `functions-by-level.csv` boundary set is heuristic ("prologues/JAL targets/relocated pointers/callbacks"), so "known function start" is itself not a fixed, reproducible predicate.
4. Atlas treats family membership as triage, but `master_inventory.csv` (Mapper-owned) is currently the empty template while `STATUS.md` says `NOT_STARTED` — no role has persisted rows, so no existing atlas classification is independently confirmed by this session.

## 5. Missing evidence

- No decompiler/disassembler/Python in this worker sandbox; function boundaries are heuristic; depth-3 reachability is not execution proof.
- No evidence of callback cadence for non-player classes; C1 dispatch ownership (outer tick vs player substep) unmeasured for all classes.
- Descriptor layout roles of `+0x4` / `+0x8` / `+0x30` remain UNKNOWN; false-positive pointer words are documented (0x2B95, 0x1018, 0x1084).
- No static writer identified for `0x2D2C04`; only the one reader at `0x14CA7C` is known, so whether C1 rewrites the rate to 60 at runtime is UNKNOWN.
- Owner of the indirect initializer pointer table entry at `0x002DD1F8 → 0x14CA70` is UNKNOWN; no `jal 0x14CA70` exists.
- Field semantics for T6/T7/T8 classes (fixed constants, float RMW, integer unit RMW) are UNKNOWN; `30`, `60`, `0.5`, `2.0`, `%3` presence proves nothing.
- LEVEL_15 vs LEVEL_21 hash delta provenance; LEVEL_02 contaminated-vs-vanilla distinction is documented but was not re-derived here.
- No runtime evidence exists for enemy cadence, weapon rate of fire, projectile lifetime, camera, or damage tick semantics; assigning `C1_EXPECTED_INCORRECT` to any of those is not supportable statically alone.

## 6. Open questions

1. Which exact 534 names constitute the mandatory register, and is the intended source the timing-atlas-global-001 scanner output (not persisted) or a 538-minus-7 union?
2. Does C1 change `0x2D2C04`, or does the tracer subsystem keep 30-based derived constants while its update is dispatched twice as often?
3. Is `LaserTracer_Update` field `+0x8` a lifetime counter, a state timer, or a rate gate? Which consumer reads `0x2D2C08`/`0x2D2C4C`/`0x2D3xxx`?
4. How do the `+0x79` integer gate and the alternating branch in `Level01Waterfall` interact with `+0x70 -= 1/60`? Does halving the per-call step preserve the gate semantics?
5. For each class, is the ordinal-2 callback inside or outside the corrected player substep under C1?

## 7. Recommended next evidence to collect

1. **Owner action to unblock the role machine**: either grant this worker a writable `reports\STATIC-60FPS-COMPLETE-AUDIT-001\staging\explorer\`, or run the audit through an in-repo PowerShell helper that persists rows. Without one of these, every role's shard output is lost at session end.
2. **Register decision**: freeze the canonical register as the 538-row `c1-residual-timing-atlas.csv` plus an explicit 7-name `U1` no-callback list, or re-run the timing-atlas-global-001 descriptor scan to persist a true 534-name union. Do not let three roles shard over three different registers.
3. Highest-value static next step: resolve the LaserTracer dataflow — find every reader of `0x2D2C08`, `0x2D2C0C`, `0x2D2C4C`, `0x2D2C88-0x2D2CB8`, `0x2D360C` family, and identify whether any C1 patch writes `0x2D2C04`.
4. Second: enumerate all `float_fixed_step_read_modify_write` sites whose constant is `1/60` or `1/30` in a *per-call* update callback reached from a class descriptor (the Waterfall pattern), and separate them from delta-driven consumers. That set is the concrete candidate pool for `CANDIDATE_STEP_HALF` / `CANDIDATE_UPDATE_DIV2` and is enumerable from `candidate-sites.csv` without a disassembler.
5. Third: PT_LOAD mapping must be derived per segment by any script that resolves data addresses in the 0x2D3xxx range (PT_LOAD1 rule `file = RVA + 0x70`), not by `+0x74`.

<!-- PARENT_HANDOFF_V1 -->
```json
{
  "established": "OBSERVED L01 PRX: 0x2D2C04=30.0f; 0x14CA70 init dt=1/rate + c.eq.s rate,60.0f; LaserTracer upd 0x148CEC only site +0x8-=1.0; 4 cfg blocks stride 0x250",
  "corroborated": "All 15 repo PRXs SHA-256 match vanilla-reference-manifest.json; 2 PT_LOADs per module: off=0x74 vaddr=0 and off=vaddr+0x70",
  "inferred": "TracerTiming_Init globals are computed once from rate=30.0 while LaserTracer_Update counts per call: split RATE_LOCAL + COUNTDOWN_PER_CALL; C1 effect UNKNOWN",
  "contradictions": "Atlas 538 names; strict ord2 function-start union=531 (7 U1); 534 never materialized; explorer.md L05/07/08=130/165/212 vs re-derived 128/162/211",
  "rejected": "Universal RVA+0x74 file mapping is false for PT_LOAD1 (off=vaddr+0x70); confirmed directly from ELF program headers",
  "unknown": "534 membership; per-class callback cadence; T6/T7/T8 field semantics; owner of 0x2DD1F8 init pointer; static writer of 0x2D2C04; L15 vs L21 hash delta",
  "top_hypotheses": "Per-call fixed-step consumers (Level01Waterfall +0x70-=1/60 at 0x151E7C) double in real time under C1 while tracer rate-derived constants stay 30-based",
  "best_discriminating_test": "A0/C1 true-stop count plus field +0x70 slope for one Level01Waterfall instance; A0/B0 gap already 1.999967x at +0x2FCFC",
  "blockers": "Session filesystem is read-only (write probe denied): no staging/explorer files or progress.json; no python/node/objdump/capstone/Add-Type",
  "full_report_required": "yes: sec 1.3 register reconciliation, sec 1.4 PT_LOAD, sec 1.5 LaserTracer raw decode, sec 1.6 Waterfall sites; handoff cannot carry tables"
}
```
<!-- /PARENT_HANDOFF_V1 -->