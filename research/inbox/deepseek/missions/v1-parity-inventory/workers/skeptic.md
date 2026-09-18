# DeepSeek Skeptic — Independent Challenge to the V1 Parity Inventory

**Artifact language:** English (persistent technical artifact, per `AGENTS.md`).
**Role:** independent skeptical review of the V1 parit- inventory mission (`research/tasks/v1-parity-inventory.md`). I did not inherit the Explorer/Mapper conclusions; I re-derived every recoverable claim from primary files.
**Mode:** read-only. No patch, no game file, no IP file, no V1 file was created, modified, moved, or deleted. No emulator/PPSSPP/parser was run. Only `Get-Content`, `Select-String`, `rg`, `Get-FileHash`, `Import-Csv`, and read-only `tar -t/-xO` were used.

**Path convention.** `L/` = `01-Travail-et-profil-PPSSPP/Overcompensated-Reprise-2026-09-14/`. `P45/` = `L/sources-v0.4.5/Size_Matters_wrapper_profiler_v0.4.5-prealpha_UCES00420/`. Absolute addresses are historical reference-session coordinates unless a module base and delta are stated.

---

## 0. Anchors I verified before judging anything

| Anchor | Result |
|---|---|
| `git rev-parse legacy-60fps-pre-v2` | `9d477f056b8c3353c7d108fd3ea8a5bc4e2ed2bd` — matches the inventory's claimed tag hash. Working branch `v2-research`. |
| `L/connection/dev061-integration-1789598570306.json` | 167 `sites` (all `pass=true`), 36 `callsites`, `scope = "read-only integration check; not gameplay validation"`, `base=152358144` (`0x0914CD00`), `pluginBase=144011520` (`0x08957100`). Primary arrays are here, **not** in `LIVE_VALIDATION.json`. |
| `L/development-v0.6.1/LIVE_VALIDATION.json` | Contains no site/callsite arrays — only a summary plus proof paths, `gameplay_fidelity=NOT_TESTED_THIS_TURN`, `actual_transition_to_30fps=NOT_TESTED`. Confirms the inventory-review correction. |
| `L/received-validation/audit.json` | 63 hash checks / 0 failures; 15/15 module sources matched; 8 policy simulations PASS; `"pspdev_rebuild": "not performed"`, `"host_c_suites": "not rerun"`. |
| `L/research-2026-09-18-global/iso_verification.json` | `copy.iso` 14/15; `LEVEL_02.PRX` `811d9ba8…` (non-match) vs reference `0037689a…`; the retail ISO is 15/15 with `0037689a…`. |
| `L/received-validation/audit.json` (module 2 block) | The expected `LEVEL_02` hash matches **only** `Data\BACKUP\BIN\LEVEL_02_clean.PRX`. `Data\BIN\LEVEL_02.PRX` and the `BIN.zip` entry do **not** match. |
| `P45/tables/*.csv` line counts | `wrapper_callsites` 493, `wrapper_families` 59, `wrapper_family_members` 267, `family_callees` 3990, `family_data_references` 972, `object_descriptors` 1927, `profiler_ra_lookup` 493, `family_patch_relations` 0 data rows. All inventory counts reproduce exactly. |
| `L/research-2026-09-18-global/patch_ledger.csv` | 1470 rows, all `reference_base = 0x09139D00`; `layers` {1:112, 2:1049, 4:222, 8:87}; 15 modules; **142 distinct `mechanic` strings**. |
| `L/research-2026-09-18-global/patch_audit_summary.json` | `patch_words_verified 1470`, `cave_words 512`, `metalis_transfer_candidates 20`, `live_validation false`. |
| `metalis_transfer_gaps.csv` / `audit-v063-pickup.csv` | 176 gap rows (`absent_or_not_unique; no transfer`); 45 pickup rows of which 27 have `same_as_metalis=False`; all 45 marked `static_only_not_gameplay`. |
| `L/sessions/plantage-clank-geant-20260917-2134/status.log` | Append-only multi-session log (oldest `start version=0.6.0-global-experimental.1`). The **exclusion line is absent here**; `module excluded key=LEVEL_15 index=15 reason=crash_reported_20260917` exists only at `L/development-v0.6.4-no-menu/backup-plugin-before-no-menu/status.log:87`. |
| Module deltas observed in logs | `+0x7000` (Pokitaru v0.4.3), `+0x8000` (Ryllus v0.4.4, Kalidon B), `+0x12000` (0.6.0 detect), `+0x13000` (0.6.1), `+0x20000` (0.6.2/0.6.3 crash session). No universal delta exists. |

---

## 1. Claims that survive scrutiny

1. **Module corpus, counts, and family catalog.** 15 modules / 493 callsites / 59 families / 267 members / 3990 callees / 972 data refs / 1927 descriptors all reproduce from `P45/tables/`. `family_patch_relations.csv` genuinely has zero data rows (`UNKNOWN` linkage, not "no relationship"). Status `OBSERVED`.
2. **`patch_ledger.csv` is a static word table, not applied state.** Every row carries `validation = "historical; no new gameplay validation"` except 154 rows; `live_validation=false`. Status `OBSERVED`.
3. **v0.6.1 "167/167 + 36/36" is a loaded-memory integration result only.** Primary JSON verified; the summary file lacks the arrays and explicitly excludes gameplay. Status `TESTED` (historical, single loaded session, read-only) / `UNKNOWN` gameplay.
4. **The v0.6.3 Metalis cave guard is genuinely self-contradictory.** `L/development-v0.6.3-generalisation/sources/profiler/src/psp_plugin_runtime.c:885-888` requires `g_full_caves[i][34] == 0x3C043F80` for module 4 before writing `0x3C043F00`, while the generated template at `…/generated/full_patch.generated.c:11` already contains `0x3C043F00` at word 34. `prepare_full_patch` returns 0 for that module. Status `CORROBORATED` (source-level) for the defect; `UNKNOWN` in-game.
5. **The cave word is provably word 34 of a plugin-owned cave.** `connection/debris-collision-1789592905266.json`: `cave = 144079168` (`0x08967940`), changed address `144079304` = cave + `0x88` = cave + 34×4. `before 1006911360 (0x3C043F80)` → `after 1006911232 (0x3C043F00)`, i.e. `lui a0,0x3F80` (1.0f) → `lui a0,0x3F00` (0.5f). Arithmetic verified.
6. **The v0.6.3 cave value cannot explain the Giant Clank crash.** v0.6.2's template (`…-v0.6.2-menu/…/full_patch.generated.c:11`) still had word 34 = `0x3C043F80`, and the guard only touched module 4, so module 15 kept 1.0 in the second trial — which crashed anyway. The reported "cave word changed LEVEL_15" hypothesis therefore has two independent counter-indications. Status: hypothesis `REJECTED`.
7. **Kalidon `0004`/`0005` are one capture, not two.** `trace_L03_0004.csv` and `trace_L03_0005.csv` are byte-identical (`SHA-256 03F10AC4BECBCE85…`); both `.result.txt` are identical (`C9AD457D…`). The raw JSONs share `capture.start_sample=16805` and differ only in `reason` and `end_sample` (58573 vs 58764). This is *stronger* than "cumulative": re-exporting produced zero new hits. Status `OBSERVED`.
8. **The 87,570 figure is internally consistent but concentrated.** Summing the `hits` column of `trace_L03_0004.csv` gives exactly 87,570 across 8 non-zero callsites. But a symmetric WF-013 pair contributes 32,129 + 32,129 = 64,258 (73.4%) with identical `active_vblanks`, `gap_*` and `max_hits_per_vblank`. "87,570 hits" is not 87,570 distinct mechanics. Status `OBSERVED` counts; `INFERRED` duplication.
9. **Pokitaru V1 address model is documented and self-consistent.** `L/archives/Pokitaru_60FPS_V1_two-builds.zip::pokitaru_v1/README_Pokitaru_V1.md`: base `0x09139D00`, `file offset = 0x74 + (address − 0x09139D00)`, 22 common writes, 55 direct wrapper calls. This also explains the apparent `0x74` mismatch between `patch_ledger.rva` and `file_offset` and between `known_weapon_patch_candidates.csv.runtime_address` and `file_offset` — the weapon CSV column is misnamed, not conflicting: `0x09251E44 = 0x09139D00 + 0x118144`, and `0x118144 = 0x1181B8 − 0x74`.
10. **Manual Metalis ledger structure.** 111 rows / 7 experiment groups; exactly 54 rows carry a module RVA (47 "Caisses + reprise arène" + 7 "Collecte Nano/munitions"); statuses: 91 "perdu ; réintégré au plugin", 16 "perdu à la fermeture de PPSSPP", 2 "annulé le même jour", 2 "rollback confirmé". This reproduces the review's 54/47/7 breakdown independently.
11. **The metric namespace is incomplete: `LEVEL_16`–`LEVEL_20` are outside the wrapper corpus but inside the weapon data.** `supplemental-files/known_weapon_patch_candidates.csv` and `class_priority_summary.csv` list `LEVEL_16..19.PRX`; `L/sources-v0.6.0/README.md:31` states frontend and `LEVEL_16`–`LEVEL_20` are out of scope. Coverage asymmetry is real.
12. **The Giant Clank module identity is genuinely ambiguous.** `P45/profiler/module_fingerprints.csv` gives `LEVEL_15` and `LEVEL_21` the *same* anchor (`0x09148800`, word `0x45010006`) with `equivalent_profile_indices` pointing at each other; the crash log records `key=LEVEL_15 index=15 matches=2`. Both are 2,680,321 bytes with different SHA-256. Status `OBSERVED`.
13. **A qualitative-vs-quantitative separation is enforced in the artifacts themselves.** `debris-collision-…json` has `userValidated: ["crate respawn delay","teleport animation"]` and no numbers; `wf029-apply/rollback-result.json` contain only policy bytes and JAL words; `clanksaw-movement-result.json` (7 changes), `arena-batch-result.json` (40), `pickup-collection-…json` (7) contain `verified: true` read-backs only. This is exactly the "runtime memory success ≠ gameplay validation" boundary.

---

## 2. Claims that are weak, unsupported, or contradicted

1. **"Kalidon B = 87,570 hits with 33 hooks, 8 active" as a comparable baseline.** It is one capture with an *instrumentation set of 8 active sites*, while the A-side reference is quoted with **13 active callsites and 69,173 hits** (`L/CONTINUITE.md:57` region) and `AUDIT_HISTORIQUE.md:82` quotes yet a third figure (**67,905 hits, 33 hooks, 8 active**). Three mutually inconsistent hit totals for "Kalidon", none of which is a gameplay outcome. A/B totals are not comparable across different active-callsite sets.
2. **"A/B/C" framing of Kalidon.** The Kalidon B package (`archives/RCSM_Kalidon_Passage_B_60FPS_Titanium_v0.1_UCES00420.zip`) already contains the minimal socle **plus camera plus Titanium Bolt**, and requires a specific delta `+0x8000`. B is therefore not "unmodified 60 FPS"; it is "socle 60 FPS without per-family corrections". Anyone reconciling inventories must not treat B as a pristine 60 FPS arm.
3. **Quantitative provenance of "6.10 s vs 3.05 s".** `L/history/6a86dce7-2998-83eb-bf81-229c2835c35d.md:4526-4531,4543-4552` is the primary source. The two numbers reproduce **exactly** as trace-derived arithmetic: 183 gap-1 intervals × 2 VBlanks ÷ 60 Hz = 6.100 s (A) and 183 × 1 VBlank ÷ 60 Hz = 3.050 s (B). They are not independent stopwatch or video-frame measurements; no raw video exists (attachments recorded only as "file contents were not included", e.g. lines 4483/4491). Status: reported `OBSERVED`, derivation `INFERRED`, raw capture `UNKNOWN`.
4. **"The video confirms the acceleration".** Per line 4552 the video is a qualitative confirmation of *visible* acceleration. It is not a timing instrument, and the file is not preserved. "VIDEO confirms" must not be promoted alongside the numeric claim.
5. **"WF-044 platform becomes 3.44× slower".** `AUDIT_HISTORIQUE.md`-level caution and the history itself (`:4537`) concede the 122.25 s figure measures the *player's traversal attempt*, not the mechanic. The B-side 122.25 s matches a video window (`04:05.983`→`06:08.233`), while the A-side 35.533 s equals 1066 hits × 2/60 s. The two arms use different measurement methods. Any "×3.44" or "duration" claim is currently unsupported.
6. **"WF-002 is already self-regulating / already compensated".** The A/B table (2,595 hits / 48.767 s vs 2,585 hits / 46.550 s) is a single pair with inconsistent internal derivation (2,595 × 2/60 = 86.5 s ≠ 48.767 s). This is a hypothesis, not a measured counter-example.
7. **"The Pokitaru/Ryllus stage 02/03 captures are reproducible baselines."** I hashed all 445 files under `snapshot-original/`, `before-v060-detect/`, `test-ready-v0.6.0-detect/`, `sources-v0.4.5/`, `sessions/`, `connection/`, `trace-validation/`, `archives/`, `received-validation/`, `supplemental-files/`, `inventaire-2026-09-17/`. **None** matches the five hashes recorded in `P45/profiler/IN_SITU_ANALYSIS_v0.4.3_STAGE02.json` (`status_prefix 45482c46…`, `status_complete 16cfdf4b…`, `pokitaru_manual 88abf7b3…`, `pokitaru_transition 0299c587…`, `ryllus_manual be1b30ac…`). The profiler ZIPs and the standalone stage-03 ZIP contain no `status*.log` or `trace*.json`. The "matching traces" claim rests on derived reports only.
8. **"55/57 hooks and 496,697 / 122,243 hits are validated".** These are derived-report numbers. The raw traces are absent (item 7), and the surviving near-namesake `trace_L01_0001.json` (snapshot, `EC4A7F28…`) is a **detect-only, 0-installed, 0-hit** capture (`trace_L01_0001.result.txt`). Status must be `OBSERVED in derived report` / `TESTED only if the missing raw trace is recovered`.
9. **"Ryllus 30 Hz at 98.724%" as a whole-game cadence.** It is an interval histogram over one configured subset of callsites; arithmetic is consistent (67,865/68,742) but the source trace is missing. Frame cadence of the *whole game* remains `INFERRED`.
10. **"Pokitaru and general delta tuning is understood".** The 22 writes in the Pokitaru V1 README include at least three classes of different nature — a `jal`→`nop` VBlank unlock, a `1/30`→`1/60` delta rewrite, and *opposite-direction* compensations (Crab attack threshold `27.0→54.0`, TrainingBot hitbox `50→100`). A "×2 threshold" is not the same mechanism as a "÷2 step". Treating all 22 as one socle hides that some are symptom compensations. Status: `OBSERVED` words / `INFERRED` causality.
11. **"v0.6.3 generalizes the Metalis pickup correction".** `audit-v063-pickup.csv`: 27/45 values differ. Worse, the reference experiment is not a scalar halving: `connection/pickup-collection-1789593231151.json` uses initial `0.1→0.05`, max speed `0.33333→0.16667`, but acceleration `0.06→0.015` (**quarter**) and steering `0.2→0.10557281` (= `1−sqrt(1−0.2)`). v0.6.3 applied plain halving. The generalization claim is `REJECTED`; the correct per-level transform is `UNKNOWN`.
12. **"Giant Clank crash: plugin writes excluded".** The third-trial exclusion line is *not* in the session's `status.log`; it lives in another folder's log (`development-v0.6.4-no-menu/backup-plugin-before-no-menu/status.log:87`). The `RAPPORT.md` claim that `status.log complet` was preserved in the session folder is inaccurate for trials 2–3. Additionally line 84 shows `LEVEL_07` still armed with 110 writes when trial 3 crashed — the plugin was far from absent.
13. **"Vanilla context exists for the crash".** `L/research-2026-09-18-global/vanilla-ppsspp.log` is a boot log only (PPSSPP banner, module-list HLE warnings, `UnitsPerMeter for UCES00420`). It contains no gameplay, no plugin, no crash. No no-plugin replay through the crash point exists in the examined material.
14. **"A 'clean' `LEVEL_02` anchor exists."** The research tooling's canonical level-2 reference is `Data\BACKUP\BIN\LEVEL_02_clean.PRX`; the shipped `Data\BIN\LEVEL_02.PRX` and the `BIN.zip` entry do not match it. Any Ryllus-linked claim inherits an unresolved provenance question, not merely a hash curiosity.
15. **"493 callsites / 59 families covers the frame-dependent game".** The catalog is calls to one shared wrapper. Independent timers, AI, weapon accumulators and secondary callbacks are demonstrably outside it (`AUDIT_HISTORIQUE.md:84`; `research-2026-09-16/metalis/README.md` lists secondary callbacks `0x13578C/0x135CE0`, `0x67060`, etc.). The static scan's own 37,341 out-of-family sites are not evidence of *additional mechanics* either.
16. **"The 38,219 candidates / 1,470 words / 1,425 plugin rows are patch counts".** They are heterogeneous evidence layers: generated static candidates; a generated word table; a plugin source table. Only 111 manual *write events* are known applied, and only 10 patch rows carry any gameplay-qualitative label.

---

## 3. Alternative explanations the inventory should carry

- **A1 — "Quantitative parity problem" may be smaller than feared.** The only *clean* A/B signal in V1 (WF-058: same ~1,943–1,945 hits, same 184 active VBlanks, 183 inter-update intervals, one update per 2 VBlanks vs 1 VBlank) is fully explained by *one* mechanism: update cadence doubled while update content stayed identical. If that holds for other families, most "×2 symptoms" are cadence artifacts of a single VBlank-unlock, not per-mechanic bugs.
- **A2 — Conversely, some "fixes" may be wrong.** The Pokitaru `27.0→54.0` and `50→100` compensations *double* thresholds. If the underlying mechanism is "one update per 2 VBlanks", doubling a threshold changes behavior rather than restoring it. Alternative to "compensation": these may be compensating a *distance* or *hitbox* double-count in a different subsystem.
- **A3 — WF-044's "slower platform" may be a measurement artifact.** The B window measures the player's attempt; the A number is trace-derived. Alternative explanation: identical platform physics plus human retry time.
- **A4 — The Giant Clank crash may be emulator-side.** The failure is `0xc0000005` **inside `PPSSPPWindows64.exe` at offset 0x2cc9bf**, not in guest code; the same report lists two earlier `amdxc64.dll` GPU-driver crashes within the same hour, plus extreme settings (internal resolution 10×, multithreaded rendering, D3D11). Alternative: PPSSPP/JIT-cache invalidation on module reload, aggravated by `matches=2` module ambiguity.
- **A5 — LEVEL_15/LEVEL_21 ambiguity may be the real identity defect.** Two commercial modules with identical fingerprint anchors and identical size; a single `matches=2` resolution. Alternative to "LEVEL_15 profile is faulty": the resolver may arm the *sibling* module.
- **A6 — `LEVEL_02` mismatch may be a dump/region artifact.** The `copy.iso` is 944,957,440 bytes vs the retail ISO's 993,394,688 with different offsets for every level, so the differing `LEVEL_02` may reflect ripping/repacking rather than a modified module. Unresolved either way.
- **A7 — The menu/blink cause may not be per-call float steps.** The candidate (`RAPPORT.md`, unapplied floats at RVA `0x2CF7D0/…`) assumes call frequency doubles. Alternative: a different code path (13 callsites of `HUDFXCYCLE_Update` in Metalis) resets `+8` per frame; the `PAUSEMODE` states may simply be re-initialized.

---

## 4. Missing evidence (raw artifacts, not interpretations)

| Missing artifact | Referenced where | Consequence |
|---|---|---|
| Profiler stage 02/03 raw traces + `status(7)/(8)/(9).log` (5 named SHA-256s) | `P45/profiler/IN_SITU_ANALYSIS_v0.4.3_STAGE02.json`, `…v0.4.4_STAGE03.json` | Pokitaru 496,697-hit and Ryllus 122,243-hit claims cannot be re-derived. |
| Kalidon A primary capture (13 active callsites, 69,173 hits) | `L/CONTINUITE.md` | No A arm for the only quantitative A/B lead. |
| Kalidon 67,905-hit capture identity | `AUDIT_HISTORIQUE.md:82` | Third unexplained total. |
| WF-058 / WF-044 / WF-016 / WF-002 A-side and B-side videos | `history/…c35d.md:4481-4491` (attachments not included) | Durations cannot be re-measured independently. |
| Weapon damage tables ("13 fiches d'armes, 215 lignes de dégâts, 100 niveaux") | `OVERCOMPENSATED_VUE_ENSEMBLE.md:249` | Weapon damage parity has no numeric reference at all (HTML not found). |
| Any 30 FPS measurement of: damage per hit, ammo consumption, cooldown, melee contact, laser/acid tick rate | whole tree | These domains are `UNKNOWN`, not "tested". |
| No-plugin Giant Clank replay | `RAPPORT.md:60-62`, `AUDIT_HISTORIQUE.md:66` | Crash attribution remains open. |
| Archive for dispatcher v0.5.0 / global v0.6.0 builds | `L/CONTINUITE.md` ("Manquants prioritaires") | v0.5.0/v0.6.0 in-game claims rest on text only. |
| `L/history/` attachments and original videos generally | `L/CONTINUITE.md` | All historical user-observation claims are single-source. |

---

## 5. Strongest falsification attempt (what I ran)

I attacked the **strongest numeric lead in V1** — "MungoDrone/WF-058: 6.10 s at 30 FPS vs 3.05 s at 60 FPS, same work, twice as fast" — using only primary artifacts:

1. Recovered the A/B table's primary source: `L/history/6a86dce7-2998-83eb-bf81-229c2835c35d.md:4526-4531`.
2. Recovered the B-side per-callsite data from the preserved raw trace (`trace_L03_0004.json`) and its derived CSV: WF-058 = 1,943 hits, 184 active VBlanks, 183 gap-1 intervals, max 12 hits/VBlank.
3. Recomputed the durations from that data: `183 × 2 / 60 = 6.100 s`, `183 × 1 / 60 = 3.050 s` — **exact** matches to the reported values.
4. Tested the alternative that the reported seconds were independently video-timed: no video exists; attachments are recorded as "contents were not included".
5. Tested the alternative that "0004 and 0005" corroborate the 87,570 total: they are byte-identical CSVs from one session with the same `start_sample`.

**Outcome.** The *cadence* claim (184 identical update steps, 2 VBlanks vs 1 VBlank per step) survives and is the best-supported A/B statement in V1. The *duration* claim does not survive as an independent measurement — it is arithmetic derived from the same trace, and it depends on (a) a true 60 Hz VBlank rate on both arms, (b) no dropped/duplicated VBlanks, (c) the A-side (13-active-callsite) capture being real, which I could not verify. Net status: `CORROBORATED` that WF-058's update count is cadence-limited in that configuration; `UNKNOWN` for the absolute duration as an independent measurement.

Falsification that would settle it: instrument the same scene at both rates with an *independent* clock (e.g. PPSSPP sound-timestamp or an external timer on a recorded AVI with a visible frame counter) and check 6.10 / 3.05 s to ±1 frame. If the measured A/B ratio is not 2.00, the VBlank-derived durations are wrong.

---

## 6. Best discriminating experiments (priority order)

1. **E1 — Base-mechanism discriminator (highest value).** Same scene, same inputs, three arms: (A) vanilla 30 FPS, (B) socle-only 60 FPS, (C) socle + ONE_PASS for exactly one family. Instrument two independent signals: (i) VBlank delta histogram per callsite, (ii) an independent wall clock (audio timestamp or video frame counter). *Discriminates* "single cadence mechanism (B already matches A in per-update work, only wall-clock halved)" from "per-family logic errors (B changes update content)". Any family whose per-update step count changes between A and B falsifies the single-mechanism hypothesis for that family. Do this first on WF-044 (Kalidon acid platform) and WF-058 (MungoDrone).
2. **E2 — Acid rise discriminator (Kalidon).** Measure fluid height vs time in A/B/C on the same segment with a fixed savestate, 5 repetitions, ≥3 samples/s from memory reads of the fluid variable (not video). Tests whether `WF-044` + direct `fluidHeight += fluidSpeed` is the cause, instead of assuming it.
3. **E3 — Vehicle parity (Metalis).** ClankSaw: distance travelled in 3 s, stop distance, turn rate, and time-to-max-speed, A vs B, ≥5 runs. The 2026-09-15 memory experiments provide the candidate constants but no outcome metric; this is the first time a number would exist.
4. **E4 — Pickup/bolt trajectory.** Nano + ammo: time-to-collect from fixed relative start, and max separation distance, A vs B. Note the quarter-step/steering transform, so the test must cover both `acceleration` and `steering`, not only max speed.
5. **E5 — Weapon damage/ammo (Burner, laser, rocket recoil).** Damage per second on a fixed enemy from a fixed save, ammo consumed per 5 s, and recoil displacement in one shot. Currently no numeric baseline exists for any of these, and `known_weapon_patch_candidates.csv` "validated on LEVEL_01" statuses mean signature only.
6. **E6 — Crash bisect with clean controls.** No-plugin replay through Challax → Giant Clank, recorded with dated config + hash, then plugin-armed replay, then plugin-armed-with-LEVEL_15/21-excluded — all three *with the same savestate and route log*, plus a distinct resolution/backend control (the report lists 10× internal resolution, multithreaded rendering, D3D11). Also resolve `LEVEL_15` vs `LEVEL_21` identity explicitly (dump the module's own header/hash at runtime).
7. **E7 — Menu/pause blink.** Count `HUDFXCYCLE_Update` calls per displayed frame in root pause and in one submenu, and measure the cursor blink period at 30 and 60 FPS on the same screen. Tests the "call frequency doubling" hypothesis before applying the four float candidates.

Every experiment must record: build hash, plugin config, delta, module index, savestate id, input log, repetition count, and the measurement instrument. Values that exist only as `verified: true` read-backs must not be reported as parity.

---

## 7. Candidate-item challenge table

Status column = my independent assessment of *the claim as it would be used by the parent*, not the artifact's self-label.

| ID | Item (domain / level) | Primary source | Status & skeptic verdict |
|---|---|---|---|
| VPI-S01 | Base VBlank unlock / delta / player substeps (all modules) | `L/archives/Pokitaru_60FPS_V1_two-builds.zip::README_Pokitaru_V1.md`; `patch_ledger.csv` (rows "Déverrouillage VBlank", "Delta général", "Sous-pas joueur", ×15 modules) | `OBSERVED` words; `INFERRED` that these are the base mechanism. Challenge: "socle" mixes 15+ distinct edits; A/B test E1 is required before calling it one cause. |
| VPI-S02 | Camera delta ±1/30→±1/60 (Pokitaru, all levels) | Pokitaru README; `patch_ledger.csv` 15×2 rows | `OBSERVED` static; `UNKNOWN` visual/gameplay parity. Camera "9.0/1.90" claims are user-judgment, not measurements. |
| VPI-S03 | Titanium Bolt speed/factor | Pokitaru README (`0x09412308`, `0x092B548C`); Kalidon B package (`vitesse 0,24→0,12`, `facteur 2,0→1,0`) | `OBSERVED`; `CORROBORATED` across two independent packages. Survives. Best candidate to validate first as a *reference correction*. |
| VPI-S04 | Player movement / crab jump & navigation | Pokitaru README (Crab pursuit `0x09409028`, threshold `0x094090C8`); `CONTINUITE.md` (crabs) | `OBSERVED` words; `UNKNOWN` symptom measurement. The `27.0→54.0` threshold is a suspicious doubling — test before propagating. |
| VPI-S05 | Kalidon acid rise (WF-044 / Lvl3Platform) | `CONTINUITE.md:74`; `OVERCOMPENSATED_VUE_ENSEMBLE.md:324`; `patch_ledger.csv` WF-044 | `OBSERVED` user report ("~×2"); `INFERRED` causality; "122.25 s vs 35.533 s" is methodologically mixed — do not cite as a duration. |
| VPI-S06 | MungoDrone sequence (WF-058) | `history/…c35d.md:4526-4552`; `trace_L03_0004.csv` row WF-058 | Best-supported A/B: identical 184 update steps, 2 vs 1 VBlank per step. Durations are derived, not measured. `CORROBORATED` cadence-only. |
| VPI-S07 | Doors (WF-016) | `history/…c35d.md:4530,4554-4558`; `trace_L03_0004.csv` (490+495 hits) | `OBSERVED` counts; "same work, half the time" `INFERRED`. Aggregates two callsites of possibly different doors. |
| VPI-S08 | WF-002 "already compensated" counter-example | `history/…c35d.md:4531,4560`; `trace_L03_0004.csv` WF-002 (2,585 hits / 2,585 active VBlanks) | `INFERRED`. The A-side 48.767 s is not self-consistent with a VBlank derivation; keep as hypothesis. |
| VPI-S09 | Metalis ClankSaw movement/rotation | `metal is-global-audit/README.md`; `connection/clanksaw-movement-result.json` (7), `clanksaw-rotation-result.json` (1) | `OBSERVED` writes + user "correct"; `UNKNOWN` distance/duration. Not a validation. |
| VPI-S10 | Metalis arena vehicles/traps (Electro/Ram/Saw/Vent/Floor) | `connection/arena-batch-result.json` (40 changes) | `OBSERVED` writes; `UNKNOWN` gameplay. The result file itself states damage cadence and full trap coverage "NOT validated". |
| VPI-S11 | Metalis debris collision (cave 7 word 34) | `connection/debris-collision-1789592905266.json`; `development-v0.6.4-no-menu/…/cave-overrides.json` | `OBSERVED` write + readback; `OBSERVED` qualitative user report; `UNKNOWN` measured lifetime/trajectory. The `0x3C043F80→0x3C043F00` semantics are `INFERRED` from MIPS `lui`. |
| VPI-S12 | Crates/teleport timers | `research-2026-09-16/metalis/README.md` (RVAs `0x13579C/0x135CF0`, `0x67060`) | `INFERRED` static; the README explicitly warns particles are separate. `UNKNOWN` timing. |
| VPI-S13 | Nano/ammo pickup collection | `connection/pickup-collection-1789593231151.json` (7 changes, incl. quarter-step accel + `1−sqrt(1−α)` steering) | `OBSERVED` values + user report. v0.6.3's plain halving is `REJECTED` as "same correction". |
| VPI-S14 | Weapon static candidate corpus (13 weapons) | `supplemental-files/known_weapon_patch_candidates.csv` (170 rows); `weapons-gadgets/*.asm` (L01 + L24 only) | `OBSERVED` static addresses; the extractor processes only modules 1 and 24 while the CSV spans 17 PRXs. Cross-module claims are signature-only. |
| VPI-S15 | Burner / Scorcher continuous damage | `CONTINUITE.md:79`; `patch_ledger.csv` (Incinérator rows ×12) | `OBSERVED` user "damage accelerated"; `UNKNOWN` damage/ammo numbers. `patch_ledger` `validation` = historical/no-validation. |
| VPI-S16 | Melee animation/impact alignment | `CONTINUITE.md:80`; `METALIS_TEST_PROTOCOL.md:54` | `OBSERVED` user report; no RVAs, no numbers. Domain-level coverage gap. |
| VPI-S17 | Rocket recoil (player AND enemies) | `research-2026-09-16/metalis/combat-minigames-followup.md:7` | `OBSERVED` user "too strong, also on player"; `INFERRED` path RVA `0x1932E4`. The README itself warns "no distance/duration measurement". |
| VPI-S18 | Pause-menu blink | `research-2026-09-16/menus/RAPPORT.md` (unapplied floats `0x2CF7D0/…`) | `INFERRED` cause from call-frequency; candidates explicitly "non appliqué". `UNKNOWN` in-game. Note the earlier float extraction is `SUPERSEDED`. |
| VPI-S19 | HUD / menu / frontend timing | `menus/RAPPORT.md`; `development-v0.6.2-menu/REPRISE_MENU.md` | Static function matches only; frontend is out of the v0.6.0 scope. `UNKNOWN`. |
| VPI-S20 | Airboard (LEVEL_22) | `trace-validation/trace_L22_0002.result.txt` (0 installed, 0 hits) | Detect-only. **No parity evidence exists.** Domain gap. |
| VPI-S21 | Giant Clank (LEVEL_15/21) | crash session logs; `module_fingerprints.csv` | `REJECTED` narrow LEVEL_15-write cause; `UNKNOWN` real cause; module identity ambiguous (`matches=2`). Domain gap. |
| VPI-S22 | Level transitions / loading screens | `RAPPORT.md` (user observation "loading screens stay at 20 fps"); `CONTINUITE.md` (native behavior warning) | `OBSERVED` user observation only; treated as native, not a regression. `UNKNOWN` quantitatively. |
| VPI-S23 | Minigames (robot throw / Lemmings-guidance) | `research-2026-09-16/metalis/combat-minigames-followup.md:3`; `connection/minigames-inventory-…json` | Inventory only; `UNKNOWN`. Domain gap. |
| VPI-S24 | Save format / free-space claims | `research-2026-09-16/saves/README.md` | `REJECTED` ("all free" span, contiguous skill bits). Not parity-dependent; keep as negative knowledge. |

Duplicate/collapse warnings for the parent: `WF-013/014/021` are three separate navigation/collision contexts (do not merge); `WF-016`'s two callsites and `WF-044`'s two-direction camera edits are pair-symmetric artifacts of one code path (do not count twice); `patch_ledger` rows with the same `mechanic` across modules are one mechanic, not N; `known_weapon_patch_candidates.csv` rows with "validated on LEVEL_01; signature identical" are one validated item plus N static extrapolations.

---

## 8. Counts and counting rules (auditable)

- **Generated static word rows:** 1470 (`patch_ledger.csv`) → **142 distinct `mechanic` strings** (counting rule: exact string equality of the French `mechanic` column; module multiplicity collapsed). If instead one groups by weapon/family prefix before "—", the corpus collapses to roughly 60–80 groups. Do not quote 1,470 as parity items.
- **Generated static candidate sites:** 38,219 (37,341 outside wrapper families) — explicitly labelled `STATIC_CANDIDATE_NOT_APPLIED_NOT_LIVE_VALIDATED`.
- **Candidate-but-not-applied fixes:** 1,470 static words (v0.6.3 audit), 1,425 plugin rows (v0.6.2 inventory), 512 cave words, 20 Metalis transfer candidates, 176 transfer gaps, 4 unapplied menu floats.
- **Changes known to have been applied in memory** (read-back verified, one build each): 111 manual write events across 7 experiments; of these 54 carry module RVAs (47 crates/arena + 7 collection); 91 recorded as "reintegrated into the plugin", 20 recorded as lost at PPSSPP close / cancelled / rolled back. Plugin-side static tables are not "applied changes" in the same sense as E1 evidence.
- **Read-only loaded-memory integration passes:** 1 (v0.6.1, 167/167 sites, 36/36 redirects) — not gameplay.
- **Quantitative 30 FPS baselines *reported*:** 1 lead set (Kalidon passage: WF-044, WF-058, WF-016, WF-002), plus instrumentation-only counts (Pokitaru 496,697 hits / 34 active; Ryllus 122,243 / 38; Kalidon A 69,173 / 13; Kalidon 67,905 / 8; Kalidon B 87,570 / 8).
- **Usable, reproducible 30 FPS **gameplay** baselines:** **0**. No preserved raw trace for the A arm, no preserved video, no memory-sampled outcome series, no repetition set (the Pokitaru `MATRICE_TESTS.md` *requests* five repetitions; no completed result sheet exists).
- **"Essentially unknown" domains** (credible lead, insufficient evidence to define a controlled comparison): Airboard, Giant Clank, minigames, melee, Burner/laser/acid tick rate, rocket recoil, energy-weapon cooldown, particles/VFX lifetimes, HUD/frontend timing, level transitions, `LEVEL_16`–`LEVEL_20`. Counting rule: a domain is listed once even if several candidate addresses exist; candidate count and domain count are kept separate.

---

## 9. Unresolved and possibly duplicate items (for parent reconciliation)

1. Three Kalidon totals (67,905 / 69,173 / 87,570) with only one preserved raw capture, and that capture duplicated as `0004`/`0005`.
2. `LEVEL_02` canonical reference: `LEVEL_02_clean.PRX` vs ISO `LEVEL_02.PRX` (cause `UNKNOWN`).
3. `LEVEL_15` vs `LEVEL_21` identity (identical anchor, `matches=2`).
4. Only 10 of 1470 patch rows carry any gameplay-qualitative label; which of those 10 have user evidence vs mere proximity is not recorded per row.
5. `family_patch_relations.csv` empty → no evidence-backed family↔patch linkage exists.
6. `known_weapon_patch_candidates.csv` `runtime_address` naming (it is a reference address, `base+RVA`), and the L01-only assembly extraction vs 17-PRX table scope.
7. `inventaire-manuelles.csv` "reintegrated into the plugin" is a static claim; no row-by-row join to the generated table was performed by anyone.
8. WF-029, WF-016, WF-044 all have "the fix is not the fix" notes in `OVERCOMPENSATED_VUE_ENSEMBLE.md:319-325` — keep the old trials.

---

## 10. Limits of this review

I did not run PPSSPP, the profiler, the trace parser, or any generator; I did not decompile the ISO modules; I did not extract the two `.docx` archives or `PRX_extracted_ASCII_strings.zip`. Claims about MIPS semantics (e.g. `0x3C043F80` = `lui a0,0x3F80`) are my reading of the encoding, corroborated by the Pokitaru README's independent `2.0→1.0` and the v0.6.4 `cave-overrides.json` `original/patched` integers. The hash sweep covered the 445 files under the directories listed in §2.7, not `toolchains/` or `analysis-deps/`; absence of a match there is strong but not absolute proof the captures never existed. Where I could not see raw evidence I recorded `UNKNOWN` rather than estimating.