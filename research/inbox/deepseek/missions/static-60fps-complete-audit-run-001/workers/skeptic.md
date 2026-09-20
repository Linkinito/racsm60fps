I have completed the audit. Writing up the report now.

## DeepSeek Skeptic — STATIC-60FPS-COMPLETE-AUDIT-001

Role: independent skeptical review. Runtime access: none (read-only file inspection only). All citations are repository-relative to `C:\Users\linki\Documents\PPSSPP\RAC_60FPS`.

Governance read first: `AGENTS.md`; `docs/methodology/EVIDENCE_LEVELS.md`; mission kit `SOURCE_PRIORITY.md`, `CONTEXT.md`, `MISSION.md`, `AGENTS.md`, `RUNBOOK.md`. Deep reads were bounded to `research/EVIDENCE_INDEX.md`, `research/v2/c1-residual-timing-atlas/*`, `research/inbox/deepseek/missions/timing-atlas-global-001/parent-review.md`, and the five prior-runtime reports named in SOURCE_PRIORITY Tier 5.

**Blocker (stated up front).** The sandbox is read-only and denied even a write to `%TEMP%`. I could not create `review/skeptic_class_verdicts.csv`, `review/candidate_risk_review.csv`, `review/conflicts.md`, `review/progress.json`, or `review/SKEPTIC_HANDOFF.md`. All findings are therefore delivered inline (section 7 gives machine-usable rows and progress JSON). No project file was modified; no candidate was applied; no runtime contact was made.

### 0. Independent verification I actually performed (primary, byte-level)

I did not accept the parent review's disassembly on trust. I parsed `02-Jeu-et-dumps/Data/BIN/LEVEL_01.PRX` myself (ELF header, program headers, little-endian word reads at `file = RVA + 0x74`).

- Module identity: `Data/BIN/LEVEL_01.PRX`, `Data/BACKUP/BIN/LEVEL_01.PRX`, `.../development-v0.6.3-generalisation/prx-reference/LEVEL_01.PRX` and `.../development-v0.6.1/verified-prx-inputs/LEVEL_01.PRX` are all byte-identical, `sha256 d10a81d076fb44987a45314a020cda2f7e8b39f860b957911ca9365464676571`. The live game file is therefore verified vanilla, which is what makes the static anchors below usable.
- PT_LOAD (my own parse): PH0 `p_offset=0x74 p_vaddr=0 p_filesz=p_memsz=0x2DD104 flags=5`; PH1 `p_offset=0x2DD178 p_vaddr=0x2DD108 p_filesz=0x1AC p_memsz=0x18E728 flags=6`. This reproduces the parent table exactly and independently re-confirms that `RVA+0x74` is a per-file fact for PH0 and not a universal rule (PH1's offset−vaddr is `0x70`), so the REJECTED status of universal `RVA+0x74` stands.
- Limiter block: `0x9662C=0x0C06FD09` (jal 0x1BF424), `0x96638=0x0C06FD0B` (jal 0x1BF42C), `0x96648=0x14440003` (bne v0,a0,+3 → 0x96658), `0x96660=0x10000003`, `0x96664=0xAE026E58` (sw v0,0x6E58(t6)). The equality-path second WAIT at `0x96650=0x0C06FD09` and the store address `0x96664` are reproduced, and Mapper's "catch-up wait" direction stays REJECTED.
- Shared delta: `0x151E0=0x3C043D08` (lui a0,0x3D08) + `0x151E4=0x34848889` (ori a0,a0,0x8889) builds exactly `0x3D088889` = 1/30; `0x151E8=0x0C0221DA` = jal 0x88768 with delay slot `0x151EC=0x4484A000` = mtc1 a0,f20. The `0x151E8 → 0x88768` pairing and the "0x884A4" rejection are confirmed.
- Player loop: `0x2FCA8=0x34110000` (s1=0), `0x2FCB0=0x2E240001` (sltiu a0,s1,1), `0x2FCB4=0xA2440208` (sb a0,0x208(s2), s2=lui 0x2B → **0x2B0208**), seven calls `0x353A4,0x32004,0x3BFF8,0x3C88C,0x32888,0x39B74,0x1EBC4`, `0x2FCF8=0x26310001`, `0x2FCFC=0x2A240002` (slti a0,s1,2), `0x2FD00=0x1480FFEB` (bne → loop head 0x2FCB0), then `0x2FD08=0x34040001` and `0x2FD0C=0xA2440208`. The gate sequence **1/0/1** and the C1 change `0x2A240002→0x2A240001` (one pass, gate 1) are confirmed.
- `0x2FBBC=0x46006506` decodes as `mov.s f20,f12`; the project's documented historical replacement is `add.s f20,f12,f12 = 0x460C6500` (`research/v2/pokitaru/player-clock-socle-map.md:14`). My decode reproduces the documented patched word exactly, which validates both the decoding method and the "x2 scalar" identity of this guard.
- LaserTracer: `DAT_0x2D2C04 = 0x41F00000` (30.0f) loaded by `lwc1` at `0x14CA7C`; the initializer writes derived constants into a module-global table at `0x2D2C08/0C/4C/88/90/94/A0`; `0x14CB08` builds 60.0f (`lui a0,0x4270`) and `0x14CB18=0x45000005` decodes as **bc1f** (rt bit 16 = 0) with imm 5 (target `0x14CB30`), selecting `0x3F376E98` (rate==60 path, `0x14CB20/24`) versus `0x3F036F4E`. This independently confirms the parent's correction of Explorer's "bc1t" claim.
- Runtime raw inputs: I recomputed `sha256` of `a0-20260920-owner-session/A0_2FCFC_STOP_60.json` = `8c7723446799a641372f92fe2c12ca6b7688cf352a2edd1db5bb11db2f1fd157` and `b0-20260920-owner-session/B0_2FCFC_STOP_60.json` = `60dca9836b5aafeb4f7c0ff60a76afebc817b669191f78fc7df3b2928624a059` — both match the reports. All four stop CSVs have 60 rows; A0/B0 alternate `1,2` exactly, C1 is `1` in all 60 rows. Waterfall summaries recompute consistently from ticks at 222 MHz (`222e6/7407274 = 29.9705 Hz`; `222e6/3703762 = 59.9391 Hz`; ratio 1.9999326, calibration-free).

### 1. Claims that survive scrutiny

1. **Limiter structure and B0 definition** — CORROBORATED (parent review + my own byte decode). The removed word is a real wait call; B0 = NOP at the loaded 0x96650 homolog. The block is gated and contains an equality branch, so B0 is not a guaranteed free-running 2× patch by construction.
2. **Player/shared-delta anchors** — CORROBORATED. 1/30 built at 0x151E0/E4, forwarded at 0x151E8→0x88768, two-pass loop with gate 1/0/1, threshold at 0x2FCFC, `mov.s f20,f12` guard at 0x2FBBC. All match `research/inbox/deepseek/missions/timing-atlas-global-001/parent-review.md` and are reproducible from the verified file.
3. **A0/B0 measured cadence in the tested Pokitaru scene** — OBSERVED, scope-limited. Complete-cycle `1.999967x` (ticks-based, dispersion ~0.25%). This is the strongest quantitative timing fact in the corpus and it is calibration-free.
4. **Waterfall A0/C1 doubling with unchanged per-call steps** — OBSERVED for this object/scene (`waterfall-001/a0-owner-session/A0_WATERFALL_REPORT.md`, `c1-owner-session/C1_WATERFALL_REPORT.md`; matching instance addresses `0x096F9E70 / 0x096EA600 / 0x09D100F0`). Per-call steps `-1/60`, `-1`, `-0.025` and the alternating `1/3` branch are unchanged; all measured internal periods halve.
5. **New derived fact (mine): the Waterfall callback is dispatched once per outer update, not per player substep.** Its A0 cadence (7,407,274 ticks) equals the A0 outer complete-cycle cadence (7,407,252 ticks); its C1 cadence (3,703,762) equals the C1 outer cadence (3,703,732). Therefore its residual is produced by the outer-cadence doubling that is already present in **B0**, and is *not* produced by C1's `slti 2→1`. Any roll-up that files it under "C1 residual / C1 threshold" is misattributed.
6. **Atlas internal consistency (500-level)** — the 12 exclusive family counts sum to 538; `movement_mode = PER_CALL_FIXED_STEP_CANDIDATE_SEMANTICS_UNKNOWN` is exactly the 200 rows of T4+T5+T6; `occurrence_count` matches the module list for all 538 rows; 1,927 class↔module pairs, 1,859 real `module:RVA` update entries, 68 pairs without a callback RVA. The generator (`build_atlas.py`) and source hashes are present.
7. **The three "CORROBORATED" anchors are construct-level, not behavior-level.** LaserTracer's rate/derived constants and rate branch, Lvl3Elevator's `(1/speed)*(1/30)` initializer store, Flamethrower's per-call counters are all anchored statically; none has a measured call cadence. The atlas itself says so.
8. **`0x2FBBC` guard semantics** — the guard is a valid byte-identity check for the historical ×2 hack, and it is vanilla (`0x46006506`) in A0, B1 and C1 as reported.

### 2. Claims that are weak, unsupported, or contradicted

1. **"538 structured corpus vs 534 canonical union = four-name scanner/alias drift."** Contradicted by the artifacts. The atlas covers 15 modules (M01–M10, M15, M21, M22, M23, M24) and its per-module class counts sum to **1,927**; the explorer-derived registry per-module counts (`timing-atlas-global-001/workers/explorer.md:74`) sum to **1,865** over the same 15 modules plus **2** for FRONTEND — i.e. **+62 class-module instances** and a **whole missing module (FRONTEND)**, not four names. `LevelMusic` (occurrence_count 15, family `U1`) is present in all 15 atlas modules, directly contradicting the accepted parent statement "No name is common to all 15 gameplay modules in that registry". Level-name labels (`Pokitaru`, `Ryllus`, …) come from the legacy `objects-by-level.csv` column consumed by `build_atlas.py:349`, not from independent verification. Consequence: the mission's "immutable 534-name register" **cannot be enumerated from the current repository**, so the mandatory per-role coverage accounting keyed to 534 is not reproducible.
2. **"CORROBORATED" label on the B0/A0 ≈2× triple.** The three ratios are 1.992 (logpoint count of the outer marker), 1.991 (+0x574 slope, host-timed), and 1.999967 (ticks-based true stop). A 0.4% spread is larger than the report's own dispersion; only the ticks-based value supports "≈exact 2×". Replace with "three independent routes support ~2×; only the true-stop route is precise."
3. **"B1/C1 `+0x574` slope ≈ A0."** The same sessions' own numbers imply slope = outer_rate × dt = 59.94/60 = 0.998983/s, but the measured values are 0.993774 (B1) and 0.994317 (C1) — a **0.5% deficit at ~17–25 σ** by the reports' own SDs. A0's own value (0.999877 vs 0.999020 predicted) is statistically fine. So the anomaly is specific to the B0/B1/C1 windows/observer, or it is real. It is currently the largest unexplained quantitative gap in the parity claim, and no document addresses it.
4. **All player-field measurements are host-timed with asynchronous endpoints** (`a0-20260920-owner-session/REPORT.md`: endpoints span 27–37 ms, not aligned to update boundaries; 10 s host windows). Error budget ≈ ±0.3–0.5%. Hence the current player-clock method **cannot resolve sub-0.5% parity differences**, and "restores A0 timing" is a bound, not an equality.
5. **Class-level C1 verdicts cannot be derived from family membership.** For a canonical class, C1's factor depends on the integration form, not on the T-bucket:
   - pure per-call work (no dt): A0 59.94 u/s, B0 119.9 (2×), B1 119.9 (2×), **C1 59.94 (correct)**;
   - dt-scaled integrator: A0 1.998, B0 1.998, B1 1.998, **C1 0.999 (0.5×, wrong)**;
   - N-VEL-style (divide by `dt*30`, then use per call): A0 59.94, B0 119.9 (2×), B1 239.8 (4×), **C1 119.9 (2×, wrong)**.
   All 200 T4/T5/T6 rows are, by the atlas's own column, `PER_CALL_FIXED_STEP_CANDIDATE_SEMANTICS_UNKNOWN`. A row that says "T5 ⇒ C1_EXPECTED_INCORRECT + candidate" would be unsupported.
6. **The machine-readable atlas's constant census is incomplete even for a runtime-verified class.** For `Level01Waterfall` the CSV's `selected_constant_values` is `0.0166666675;1`, but the runtime per-call step on `pvar+0x04` is `-0.025` and the companion table `FORMAL_TIMING_QUANTIFICATION.md:116–120` does list 0.025. The value exists in the module (raw word `0x3CCCCCCD` occurs 24×), just not in that callback window. A mapper consuming the CSV as canon will mis-enumerate per-call constants.
7. **"Waterfall visible animation is twice as fast in C1."** Not established: the reports explicitly record no pixel/feature correlation, and the fields are unnamed internal effect-phase counters. What is OBSERVED is halved internal periods.
8. **Absolute Hz and second-based periods** in the player/waterfall reports are conditional on the unverified 222.000 MHz tick calibration (the A0 report itself calls ticks "not microseconds"; no CPU clock was queried). Only ratios are calibration-free.
9. **A0 leg identity in the A0/B0 comparison.** A0 state identity is owner-declared and "no independent A0 guard-word read was made in that run"; the B0 guards were verified in a different capture. The ordering was single-shot A0→B0. The report's causal sentence (removed WAIT causes the doubling) is correctly labelled INFERRED, but it must not be promoted: it needs an in-run verified, repeated A0→B0→A0 sequence.
10. **`0x2FBBC` as "the local player scalar"** is a label over a byte guard, not a semantic identification; and **`+0x2B0208`** is treated in several roll-ups as the player/LaserTracer gate with no demonstrated reader (see §3).
11. **The 534/538 and family documents have drifted apart** across CSV/MD/JSON (0.025 case above; `family-summary.json` says "0 classes with a direct 30.0 site" while the accepted LaserTracer anchor *is* a 30.0f rate at `0x2D2C04` — reconcilable only via the atlas's own "not observed by this extractor" caveat). Any consumer that reads one artifact as canon will be wrong.
12. **Documentation conflict to preserve** (mission instruction): `research/checkpoints/2026-09-20/CURRENT_STATE_complete_2026-09-20.md` lines 75–76, 557, 760 say no valid A0/B0 cadence experiment has completed and the A0→B0 scheduling effect is UNTESTED. This is **stale for cadence** (superseded by `A0_B0_2FCFC_STOP_COMPARISON.md`, 60 hits/state, `1.999967x`) but **still correct for causality and for all-site/global scope**.

### 3. Alternative explanations

- **A1 (dispatch attribution).** The class-callback doubling observed for the Waterfall is fully explained by the B0 VBlank unlock. For any class dispatched once per outer update, the "C1 residual" is a *B0-inherited* residual; the loop-threshold change is irrelevant. Only substep-dispatched classes can be affected by C1's `slti` change.
- **A2 (same object, opposite direction).** For substep-dispatched classes the split can invert: a dt-scaled substep consumer is *correct* in B1 and *half-rate* in C1; a per-call substep consumer is *correct* in C1 and 2× in B0/B1. The mission's implicit "C1 is the wrong arm for the residuals" is only true for the first of these.
- **A3 (dead/intentional rate branch).** The LaserTracer rate==60 branch may be a supported engine configuration (i.e. the engine, not a hack, has a 60 Hz mode), in which case a correct 60 FPS port might *select* the 60 path instead of retuning fixed steps. This competes with "fixed per-call doubling = defect" and is currently UNKNOWN. Supporting detail: the derivation is executed once into a module-global table read by ≥9 other sites in the same module (mine, INFERRED — base-register provenance not verified per site at `0x147D24,0x147D54,0x147D64,0x147D88,0x147EA8,0x14815C,0x148998,0x148AA8,0x148EDC`), so the scope of any rate change is intra-subsystem, not per-instance.
- **A4 (measurement artifact).** The uniform ~0.3–0.5% `+0x574` deficit in B0/B1/C1 with a consistent A0 baseline is more parsimoniously explained by host pacing/observer overhead in those sessions than by accumulator physics.
- **A5 (extractor incompatibility).** The 538 vs 534 gap may be two incompatible extractors over different source files, not alias drift; the "level" names are legacy column values.
- **A6 (scope).** The Waterfall fields might drive purely presentational effect phases (RENDER_ONLY / non-gameplay presentation). Whether such objects are in scope for Priority 0 is an owner decision the mission currently leaves implicit.

### 4. Missing evidence

- A **B0-only class-callback** measurement (any outer-dispatched class). Nothing else can separate "B0-inherited" from "C1-specific".
- **Any** measured callback cadence for the other 537 canonical names — the entire class-level C1 verdict set is static-only.
- **Tick-based (not host-timed) slopes** for `+0x574/+0x578` per arm, synchronized to the stop site.
- In-run decoded guard verification for **both** legs of A0/B0 plus a repeated A0→B0→A0 ordering.
- Any measurement of the *substep* consumers: `0x32588` (`+0xA00..+A18`), `0x42C04`, `0x39B74` — the 0.5×/2× predictions are entirely unmeasured. Also unmeasured: weapon cadence, damage ticks, projectile lifetime, enemy locomotion/attacks, camera, elevators, vehicles, UI.
- Readers of `0x2B0208` outside LEVEL_01 (or confirmation that there are none) and any evidence connecting it to LaserTracer dispatch.
- Verification of module/level identity and per-module RVA equivalence for M02–M24 (never runtime-confirmed; FRONTEND absent from the atlas).
- The `222 MHz` calibration source; `sceDisplay` import NID resolution (still INFERRED per worker blocker).
- Pixel/visual correlation for the Waterfall fields; a materialized 534-name register.

### 5. Strongest falsification attempts (what I tried to break)

1. *"The C1 residual is caused by C1's loop change."* Falsified for an outer-dispatched object: Waterfall cadence equals outer cadence in both arms ⇒ B0-inherited. This *does not* falsify the doubling; it falsifies the attribution and therefore the mission's top-level framing.
2. *"The post-loop gate restoration proves another (LaserTracer) dispatch."* I scanned the whole first segment of LEVEL_01.PRX for every `lb/lbu/sb/sw` with `imm16=0x208` (9 sites). The only accesses to the global `0x2B0208` are the two `sb a0,0x208(s2)` at `0x2FCB4` and `0x2FD0C`. **There is no direct reader of the gate in LEVEL_01.** The claim survives only if the address is passed indirectly or read from another module — neither demonstrated. This strengthens the parent's rejection.
3. *"The atlas enumerates per-class constants."* Falsified for `Level01Waterfall` (0.025 missing from the CSV column but present in the MD table and observed at runtime).
4. *"538 and 534 describe the same register."* Falsified (62 module-instance delta, missing FRONTEND, LevelMusic universality).
5. *"B0 doubling is exactly 2.000×."* Only partially confirmed: 1.999967 (ticks) vs 1.991–1.992 (host-timed) — the exactness claim must be restricted to the ticks-based route.
6. *"A0/B0 comparison is self-verifying."* Falsified at the provenance level: no in-run A0 guard read, single ordering, no repeat.
7. *"The gate is a LaserTracer dispatch flag."* No direct reader found (see 2); additionally the seven loop callees do not include `0x148CEC`.

### 6. Best discriminating experiment

**Primary (runtime, owner authorization required; still read-only for the game):** a **B0-only** true-stop capture of an outer-dispatched class callback, with in-run decoded guard verification, then an immediate A0 repeat.

- State: B0 = NOP only at the loaded `0x96650` homolog; require decoded-in-run `0x151E0` vanilla (`lui 0x3D08`), `0x2FCFC = 0x2A240002`, `0x2FBBC = 0x46006506`.
- Site: `Level01Waterfall` M01 `+0x151D78` (runtime `0x0928BA78`), same scene/instance family as the A0/C1 pair.
- Capture: 24 true-stop hits; read the `object+0x70/+0x79` and `pvar+0x00/+0x04/+0x08/+0x10` words at each hit; report **cpu.ticks intervals only**.
- Decision: B0 ≈ 59.94 Hz with unchanged per-call steps ⇒ class residual is B0-inherited, and no C1-threshold-derived class patch is supportable; B0 ≈ 119.88 Hz ⇒ the callback is substep-dispatched and the C1 threshold is load-bearing for classes.
- Then repeat A0 to bound drift, and use the same run to take ticks-based `+0x574` deltas synchronized to the stop hits (closes the 0.5% anomaly).

**Static fallback (no runtime needed) — highest-value deliverable change:** require every mechanism row to carry a **DISPATCH_SITE** field (outer level update / player substep loop / independent class dispatch / unknown) with the caller chain that establishes it. Adding that one field to `timing_mechanisms.csv` converts the 200 T4–T6 names from an undecidable "wrong/right" verdict into the three well-defined cases in §2.5, and it is exactly the classification the current corpus is missing.

### 7. Deliverables that could not be persisted (and content for transcription)

Files that could not be written (read-only sandbox, writes denied):

```
reports\STATIC-60FPS-COMPLETE-AUDIT-001\review\skeptic_class_verdicts.csv
reports\STATIC-60FPS-COMPLETE-AUDIT-001\review\candidate_risk_review.csv
reports\STATIC-60FPS-COMPLETE-AUDIT-001\review\conflicts.md
reports\STATIC-60FPS-COMPLETE-AUDIT-001\review\progress.json
reports\STATIC-60FPS-COMPLETE-AUDIT-001\review\SKEPTIC_HANDOFF.md
```

`progress.json` content: `{"role":"skeptic","register_source":"research/v2/c1-residual-timing-atlas/c1-residual-timing-atlas.csv","register_names_expected":"534 (mission) / 538 (atlas; unreconciled)","canonical_rows_individually_vetted":9,"register_structure_audited":"yes","family_buckets_audited":"12/12","unexamined_by_skeptic":529,"status":"PARTIAL","next_shard":"none (blocked: read-only sandbox)","files_written":0}`

`skEPTIC-class verdict rows (only rows I can defend; everything else must stay UNEXAMINED, not complete)` — CSV header:

```
canonical_name,timing_relevance_verified,evidence_state,likely_mechanism_families,known_static_ambiguity,highest_risk_assumption,verdict_vs_atlas
```

| name | timing relevance | state | families | ambiguity | highest-risk assumption | verdict |
|---|---|---|---|---|---|---|
| LaserTracer | yes (rate table + rate==60 branch, my bytes) | CORROBORATED (construct) / UNKNOWN (cadence) | RATE_LOCAL, STEP_PER_CALL, CALL_FREQUENCY | no dispatch cadence; table shared by ≥9 sites | that local rate tracks the real dispatch rate | ACCEPT family, DISPUTE "CORROBORATED behavior" |
| Lvl3Elevator | yes (initializer `(1/speed)*(1/30)`) | CORROBORATED (construct) | STEP_PER_CALL, MOVEMENT_STEP | per-call cadence unmeasured; travel speed unnamed | that the stored step is a position delta | ACCEPT family, DISPUTE "corrected behavior" |
| Flamethrower | yes (per-call counters) | CORROBORATED (construct) | COUNTDOWN_PER_CALL, FIRE_RATE | damage path unresolved; `%3` = pseudo-random | that counters gate damage, not visuals | ACCEPT family, DISPUTE damage semantics |
| Level01Waterfall | yes (runtime) | OBSERVED (internal periods) | STEP_PER_CALL, CALL_FREQUENCY, ANIMATION_STEP | no visual correlation; 0.025 step absent from CSV | that fields are gameplay-visible | ACCEPT doubling; DISPUTE C1-specific attribution |
| Acidbomb | yes (signature) | OBSERVED signature / U | DT/STEP/MOVEMENT unknown | delta source unresolved | read-modify-write = timing | UNKNOWN |
| AcidbombEpoxy | unproven | U (refinement says no proven timing path) | CALL_FREQUENCY | depth-3 reachability ≠ execution | helper reachability = timing consumer | UNKNOWN |
| AgentController | plausible | OBSERVED signature / U | TIMER_TICKS, DISPATCH | integer RMW may be index/state | unit RMW = timer | UNKNOWN |
| AgentsGlove | plausible | INFERRED | FIRE_RATE, PROJECTILE_STEP | fixed constant meaning unknown | constant is temporal | UNKNOWN |
| Level01HelpManager | plausible | INFERRED | STEP_PER_CALL, TIMER_TICKS | 1/30 site may be one-shot | recurrent per call | UNKNOWN |

Family bucket accounting (structural ACCEPT, semantic UNKNOWN): T1 1, T2 1, T3 1, T4 8, T5 53, T6 139, T7 55, T8 21, T9 115, T10 80, T11 57, U1 7 = 538. Channel anchoring: only 3 classes have an anchored channel; 535 rows are `channel_separation_status = UNKNOWN`; name/category hints cover 174 rows and are triage aids only.

`candidate_risk_review.csv` (transcribable rows):

| candidate_scope | risk | reason | verdict |
|---|---|---|---|
| initializer `0x14CA70` or table `0x2D2Cxx` | HIGH | module-global derived-constant table; ≥9 inferred readers; rate-conditional coefficient choice | DISPUTE as "local" without consumer enumeration |
| `0x2FBBC` (`mov.s f20,f12`) | HIGH | historical ×2 scalar; already REJECTED as preferred architecture; vanilla in all arms | DISPUTE unless jointly measured with delta/pass changes |
| any T4/T5/T6-membership candidate (200 names) | HIGH | `PER_CALL_FIXED_STEP_CANDIDATE_SEMANTICS_UNKNOWN` for all 200 | DISPUTE as unsupported |
| any "halve dt consumers" candidate | MEDIUM | 0.5× is right only for dt-scaled consumers; 2× for N-VEL consumers | UNKNOWN pending dataflow |
| any candidate claiming C1-threshold benefit for outer-dispatched classes | HIGH | Waterfall shows outer-inherited doubling | DISPUTE |
| any gate-based fix around `0x2B0208` | HIGH | no direct reader in LEVEL_01 | DISPUTE |

`conflicts.md` (ordered): (1) 534 union vs 538 atlas, +62 instances, FRONTEND missing, LevelMusic universality; (2) `CURRENT_STATE_complete` lines 75–76/557/760 vs `A0_B0_2FCFC_STOP_COMPARISON.md`; (3) Waterfall CSV `selected_constant_values` vs `FORMAL_TIMING_QUANTIFICATION.md:116–120`; (4) `family-summary.json` "0 classes with direct 30.0 site" vs accepted LaserTracer 30.0f rate; (5) `+0x574` slope deficit vs model in B1/C1; (6) C1-specific vs B0-inherited residual framing.

**Bottom line for the parent.** The static foundations the mission relies on (limiter, shared delta, two-pass loop, gate, LaserTracer anchors, Waterfall per-call steps) are reproducible from a verified vanilla module and survive scrutiny. The *scope claims built on them* do not: the 534-name register is not reproducible, the C1 attribution of class residuals is wrong for outer-dispatched objects, all 200 "fixed-constant candidate" names are semantically undecided, and the player-field parity claim has an unexplained 0.5% systematic. Do not let the coverage gate (`UNEXAMINED = 0`) imply measurement: today only one class callback has ever been measured.

<!-- PARENT_HANDOFF_V1 -->
```json
{
  "established": "Primary bytes: LEVEL_01.PRX sha256 d10a81d0; words 0x96650=0C06FD09 0x151E0=3C043D08 0x2FCFC=2A240002 0x2FBBC=46006506; PT_LOAD0 off 74 vaddr 0; gate sb 1/0/1",
  "corroborated": "Waterfall A0 29.9705Hz == A0 outer 7407252 ticks; C1 59.9391Hz == C1 outer 3703732 ticks, so that callback runs once per outer update; scope Pokitaru A0/C1 only",
  "inferred": "C1 factor by consumer: per-call 1.0x ok, dt-scaled 0.5x, N-VEL-normalized 2.0x; outer-dispatched class residual is B0-inherited, not C1 threshold",
  "contradictions": "Atlas 538/15 modules vs 534 union: +62 module instances, FRONTEND missing, LevelMusic in 15 vs 'no name in all 15'; CSV omits 0.025; CURRENT_STATE L76 stale on A0/B0",
  "rejected": "No direct reader of gate 0x2B0208 in LEVEL_01 (imm=0x208 scan: 9 sites; only the two sb writers); supports rejecting post-loop-gate => LaserTracer dispatch",
  "unknown": "Dispatch site per class (only Waterfall known); B0 class cadence; 0.55% +0x574 parity gap; 222MHz calibration; readers of 0x2D2Cxx table; M02-M24 identities",
  "top_hypotheses": "H1 outer-dispatched residuals come from B0 VBlank unlock; H2 C1 halves substep dt consumers; H3 LaserTracer rate table is shared by >=9 module sites, rate-60 branch may be selectable",
  "best_discriminating_test": "B0-only true-stop cadence at M01+0x151D78 with in-run decoded guards and ticks-only field deltas: ~59.94Hz means B0-inherited, ~119.9Hz means substep-dispatched",
  "blockers": "Sandbox read-only: review/*.csv, conflicts.md, progress.json, SKEPTIC_HANDOFF.md could not be written (even TEMP denied); 529 of 538 names not individually vetted by me",
  "full_report_required": "yes: sections 1-7, esp. 0 (primary byte verification), 2 (register reconciliation, 0.5% anomaly), 4 (missing evidence), 6 (B0 class test + DISPATCH_SITE field)"
}
```
<!-- /PARENT_HANDOFF_V1 -->