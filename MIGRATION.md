# V1 → V2 Migration

## Purpose

The V2 project is a structured reconstruction of the existing Overcompensated research.

It is not a clean-room restart and it is not permission to discard old work.

The V1 state is permanently preserved by the Git tag:

`legacy-60fps-pre-v2`

The migration process determines which historical findings can be:

- directly retained;
- revalidated;
- reinterpreted;
- superseded;
- rejected;
- archived for future investigation.

---

## Migration rule

The V1 preserves what we discovered.

The V2 contains what we can explain.

If legacy material cannot currently be understood, do not discard it.

Mark it as unresolved and preserve its location.

---

## Migration states

### NOT_REVIEWED

Legacy material has not yet been examined for V2.

### INVENTORIED

The item has been identified and its purpose is approximately known.

### NEEDS_REVALIDATION

The legacy result is useful but should be experimentally or analytically checked again.

### MIGRATED

The useful knowledge has been transferred into the V2 structure.

### SUPERSEDED

The original information remains historically useful but has been replaced by a better explanation or implementation.

### REJECTED

The original hypothesis was later demonstrated to be wrong.

### LEGACY_ONLY

The material is intentionally retained only in the historical tree.

Typical examples:
- temporary experiments;
- obsolete build outputs;
- redundant snapshots;
- intermediate tooling.

### UNRESOLVED

The material may contain useful information but its meaning is not yet sufficiently understood.

Do not delete unresolved material.

---

## Register basis and limits

This register reflects the V1 inventory and its critical review as of 18 September 2026:

- `research/inbox/legacy-v1-inventory.md` is a navigation map.
- `research/inbox/legacy-v1-inventory-review.md` takes precedence where it corrects or limits that map.
- The cited V1 files are the historical evidence. An archived report, generated dataset, or model statement is not independent gameplay validation.

`L/` below means `01-Travail-et-profil-PPSSPP/Overcompensated-Reprise-2026-09-14/`. `P45/` means `L/sources-v0.4.5/Size_Matters_wrapper_profiler_v0.4.5-prealpha_UCES00420/`. Both prefixes resolve to preserved historical files. Planned V2 homes are targets for later work, not files created by this register update.

**Migration state and technical evidence status are separate.** Each row states the evidence for a narrow claim and the item's migration state. `OBSERVED` for a historical report means its contents were recorded, not that its gameplay interpretation was reproduced. `TESTED` always names its scope. `SUPERSEDED` and `REJECTED` retain the older claim and its correction. No item is marked `MIGRATED` merely because it is listed here; no gameplay claim or patch has been promoted into V2 documentation.

| Validation scope | What it can establish | What it does not establish |
|---|---|---|
| Static/binary analysis | File words, generated table content, hashes, signatures and source-level branches. | Loaded memory state, execution path or gameplay effect. |
| Host test | Behavior of the code and inputs exercised by that harness. | PSP/PPSSPP execution or game behavior unless separately tested there. |
| Runtime memory check | The recorded words, redirects or plugin state in one identified loaded session. | Timing, damage, visual fidelity or behavior across levels. |
| Controlled gameplay comparison | A measured claim for the stated build, scene, baseline and repetitions. | Automatic validity for every module, weapon or game mode. |

## Ordered migration roadmap

1. **Module identity and binary provenance.** Establish versioned PRX/ISO hashes and module identities first. Resolve the `LEVEL_02.PRX` discrepancy before treating that reference as vanilla. Planned home: `research/` provenance records.
2. **RVA and relocation rules.** Document file offset, reference base, loaded base, relocated JAL words, and plugin-owned cave addresses separately. Historical absolute addresses are not reusable live addresses. Planned home: `docs/methodology/` and `research/functions/`.
3. **Wrapper, callsite, and family catalogs.** Preserve generation inputs, hashes, 493 callsites, 59 families, RA lookup and tentative ownership. An empty family-to-patch relation table is a gap, not proof of no relationship. Planned home: `research/functions/`.
4. **Trace provenance and missing evidence.** Link each derived stage report to its exact raw trace or record the absence; keep detect-only snapshots and cumulative Kalidon exports distinct. Planned home: `evidence/traces/`.
5. **Patch ledgers and manual experiments.** Retain version-specific static tables, the 111 manual write events, the 54 RVA records, the separate v0.6.1 live check, and cave transformations outside flat ledgers. Do not migrate corrections as gameplay fixes from write/readback alone. Planned home: `research/` and, only after validation, `patches/`.
6. **Negative results and rejected hypotheses.** Preserve the narrow WF-029 rollback, Giant Clank attribution reversal, save-space and skill-bit exclusions, menu extractor correction, and old CWCheat guard failure with their actual scope. Planned home: `research/rejected/` or `research/superseded/` when later documented.
7. **Explicit open debt.** Track 176 unmatched/non-unique Metalis transfers, uncertain semantic names, unmeasured gameplay behavior, missing captures, and version conflicts. Planned home: `research/` until a specific finding earns a system document.

## Foundation and evidence register

| ID / existing material | Historical evidence | Technical evidence status | Migration state | Next action and boundary |
|---|---|---|---|---|
| F1 — Module corpus and hashes | `L/archives-manifest.csv`; `L/sources-v0.6.0/SHA256SUMS.txt`; `L/research-2026-09-18-global/static-inventory/vanilla-reference-manifest.json` | `OBSERVED`: versioned files and recorded hashes; reference identity must be tied to exact inputs. | `INVENTORIED` | Build a V2 provenance index. Do not equate a historical reference path or savestate with an original ISO module. |
| F2 — `LEVEL_02.PRX` mismatch | `L/research-2026-09-18-global/iso_verification.json`; `L/research-2026-09-18-global/verify_iso.py`; `L/CONTINUITE.md` | `OBSERVED`: one ISO comparison reports 14/15 matches; LEVEL_02 hashes begin `811d9ba8` (ISO) and `0037689a` (reference). Cause `UNKNOWN`. | `UNRESOLVED` | Determine provenance by a focused binary comparison before choosing a canonical LEVEL_02 reference. Do not label either copy clean solely from its filename. |
| F3 — RVA, relocation, and address rules | `L/research-2026-09-18-global/patch_ledger.csv`; `L/research-2026-09-18-global/AUDIT_HISTORIQUE.md`; `P45/profiler/module_fingerprints.csv` | `OBSERVED`: versioned RVA/file-offset and reference-word records; runtime words and plugin cave addresses can differ. | `INVENTORIED` | Document the address calculation and word categories with module identity. Do not use old absolute addresses as live coordinates or assign semantics from an address alone. |
| F4 — Wrapper and callsite corpus | `P45/tables/wrapper_callsites.csv`; `P45/tables/wrapper_families.csv`; `P45/tables/profiler_ra_lookup.csv`; `P45/tables/family_patch_relations.csv`; `P45/profiler/module_fingerprints.csv` | `OBSERVED`: 15 modules, 493 callsites, 59 families, 493 RA entries; patch-relation CSV has zero data rows. Family roles/ownership often `INFERRED`. | `INVENTORIED` | Preserve hashes and generation method; review callers/callees before semantic names. The catalog is not all frame-dependent code. |
| F5 — Profiler stage 02/03 traces | `P45/POKITARU_STAGE02_RESULT.md`; `P45/RYLLUS_STAGE03_RESULT.md`; `P45/profiler/IN_SITU_ANALYSIS_v0.4.3_STAGE02.json`; `P45/profiler/IN_SITU_ANALYSIS_v0.4.4_STAGE03.json` | `OBSERVED` in derived reports: 55/55 and 57/57 hooks, reported hits and VBlank histogram. Original raw stage captures/logs were not found in `P45/` or examined profiler ZIPs; historical instrumentation tests were not replayed. The 30 Hz interpretation is `INFERRED`. | `NEEDS_REVALIDATION` | Locate and hash raw captures or preserve a missing-primary-evidence flag. `L/trace-validation/trace_L01_0001.result.txt` is a separate detect-only trace, not a substitute. |
| F6 — Kalidon trace A/B provenance | `L/CONTINUITE.md`; `L/trace-validation/trace_L03_0004.result.txt`; `L/trace-validation/trace_L03_0005.result.txt`; `L/research-2026-09-18-global/AUDIT_HISTORIQUE.md` | `OBSERVED`: the two B parser results are cumulative at 87,570 hits; a separate historical account says 67,905. Original A video/full capture is missing from examined material. Gameplay parity `UNKNOWN`. | `NEEDS_REVALIDATION` | Identify runs and windows; preserve counts without adding exports or treating parser PASS as a gameplay test. |
| F7 — Generated patch and static datasets | `L/research-2026-09-18-global/patch_ledger.csv`; `L/research-2026-09-18-global/patch_audit_summary.json`; `L/research-2026-09-18-global/static-inventory/counts.json`; `L/research-2026-09-18-global/static-inventory/scan_static.py` | `OBSERVED`: 1,470 patch words, 493 wrapper calls, 512 cave words; scan reports 38,219 candidates and heuristic function boundaries. Audit has `live_validation=false`. | `INVENTORIED` | Record generator inputs/hashes and repair stale paths before any V2 regeneration. Candidates are not applied patches or validated function definitions. |
| F8 — Manual Metalis writes and 54 RVA entries | `L/inventaire-2026-09-17/inventaire-manuelles.csv`; `L/inventaire-2026-09-17/INVENTAIRE_MEMOIRE.md`; `L/development-v0.6.1/VALIDATION_SUMMARY.json` | `OBSERVED`: 111 write events, 54 module-RVA rows and a recorded static check of 54 added original words. Exact row-by-row manual-to-generated-to-binary linkage is not independently established here. | `NEEDS_REVALIDATION` | Join the 54 rows across their versioned tables; keep session/plugin addresses separate. Neither 111 events nor 54 entries prove gameplay corrections. |
| F9 — v0.6.1 live Metalis check | **Primary:** `L/connection/dev061-integration-1789598570306.json`. **Summary:** `L/development-v0.6.1/LIVE_VALIDATION.json`. | `TESTED` historically for read-only loaded-memory integration: 167/167 sites and 36/36 redirects passed in the primary capture. The summary does not contain those arrays; it says gameplay fidelity and actual 30 FPS transition were not tested that turn. | `INVENTORIED` | Preserve build/session identity and the primary JSON link. Do not describe the check as gameplay parity or as independent validation of all 54 manual experiments. |
| F10 — Static transfer and decompilation leads | `L/research-2026-09-18-global/metalis_transfers.csv`; `L/research-2026-09-18-global/metalis_transfer_gaps.csv`; `L/research-2026-09-18-global/static-inventory/scan_static.py`; `L/research-2026-09-16/menus/RAPPORT.md` | `OBSERVED`: 20 static transfer candidates and 176 absent/non-unique targets. Function boundaries, callback ownership, field meanings and symbol rebasing remain `INFERRED` or `UNKNOWN`. | `UNRESOLVED` | Carry positive and negative matches together; verify semantics before authoritative function, structure or game-global names. |
| F11 — Plugin FPS globals and 30 FPS acknowledgement | `L/development-v0.6.1/sources/profiler/src/psp_plugin_runtime.c`; `L/development-v0.6.1/README.md`; `L/sessions/plantage-clank-geant-20260917-2134/status.log` | `OBSERVED`: plugin globals `g_rcsm_requested_fps`, `g_rcsm_applied_fps`, `g_rcsm_fps_pending` and later `applied=30 requested=30` log lines. Actual displayed cadence and vanilla gameplay parity `UNKNOWN`. | `INVENTORIED` | Record these as plugin-owned, build-dependent symbols; verify real frame cadence separately. Do not promote them to game-global names. |
| F12 — Versioned implementation lineage | `L/archives/`; `P45/`; `L/sources-v0.5.0/`; `L/sources-v0.6.0/`; `L/development-v0.6.1/` through `L/development-v0.6.4-no-menu/`; `L/research-2026-09-18-global/RETRAIT_MENU.md` | `OBSERVED`: packaged variants, source, build and installation records exist. Host/static/build checks and game sessions have different scopes and dates. | `INVENTORIED` | Make a hash-based version/test matrix before comparing claims. A directory named “current” or an installed but disabled PRX is not proof of an active gameplay test. |

## Historical corrections and negative-result register

| ID / narrow claim | Historical evidence | Technical evidence status | Migration state | Next action and boundary |
|---|---|---|---|---|
| C1 — Cave 7 integration and v0.6.3 guard | `L/inventaire-2026-09-17/INVENTAIRE_MEMOIRE.md`; `L/development-v0.6.2-menu/sources/profiler/src/psp_plugin_runtime.c`; `L/development-v0.6.3-generalisation/sources/profiler/generated/full_patch.generated.c`; `L/development-v0.6.3-generalisation/sources/profiler/src/psp_plugin_runtime.c`; `L/development-v0.6.4-no-menu/METALIS_CAVE_GUARD_VALIDATION.json` | `SUPERSEDED`: “not integrated” was outdated by v0.6.2's Metalis-only transform. `CORROBORATED`: v0.6.3 template is `0x3C043F00` while its guard requires `0x3C043F80`. `TESTED` only in the v0.6.4 host harness for the narrow old/new guard behavior. | `SUPERSEDED` | Preserve the version sequence and host result. v0.6.4's acceptance is not an in-game Metalis or 60 FPS gameplay test. |
| C2 — “Same Metalis pickup correction generalized” | `L/development-v0.6.3-generalisation/LISEZ_MOI.md`; `L/research-2026-09-18-global/audit-v063-pickup.csv` | `REJECTED` for value identity: 27/45 new entries differ from the Metalis reference. All 45 are marked static-only; their gameplay effect is `UNKNOWN`. | `REJECTED` | Keep the mismatching rows and exact version; determine cross-level behavior only in a later scoped study. No generalized fix is established. |
| C3 — Giant Clank LEVEL_15 write attribution | `L/sessions/plantage-clank-geant-20260917-2134/RAPPORT.md`; `L/sessions/plantage-clank-geant-20260917-2134/status.log`; `L/research-2026-09-18-global/AUDIT_HISTORIQUE.md` | `REJECTED` only for the claim that same-scene LEVEL_15 writes were necessary: a later exclusion trial still crashed. Root cause `UNKNOWN`; an exclusion is not a clean no-plugin run. | `REJECTED` | Preserve all three trials and the reversal; track clean-baseline attribution separately as `UNRESOLVED`. |
| C4 — Entire null save span is free | `L/research-2026-09-16/saves/README.md` and linked LEVEL_01 disassembly | `REJECTED`: a writer targets GameState `+0x534E0` within the proposed free region. Actual bounds and occupied bytes remain `UNKNOWN`. | `REJECTED` | Retain the negative result. Do not allocate the whole zero-filled span for new data. |
| C5 — Skill-point bits 25–47 are a contiguous free interval | `L/research-2026-09-16/saves/README.md`; its archived handoff and save inspection | `SUPERSEDED`: later analysis describes nibble groups with gaps. The exact safe allocation remains `UNKNOWN`. | `SUPERSEDED` | Preserve both interpretations; do not reserve bits 25–47 en bloc. |
| C6 — Early menu cycle-data float interpretation | `L/research-2026-09-16/menus/RAPPORT.md`; `L/research-2026-09-16/menus/cycle-data.py`; `L/research-2026-09-16/menus/finalize.py` | `SUPERSEDED`: the early extractor treated color words as float NaNs; the later extraction supplies the static pause-cycle candidates. Candidate gameplay effect `UNKNOWN`. | `SUPERSEDED` | Use the corrected extraction as a lead, not a validated blink patch or complete ABI map. |
| C7 — Inactive menu object in RAM | `L/development-v0.6.1/NEXT_MENU_STEP.md`; `L/connection/dev061-menu-readonly-1789598570147.json` | `OBSERVED` in the historical probe: stale screen-17 data remained while screen 3 was active. Presence alone does not show current ownership. | `INVENTORIED` | Require active-screen/state checks before interpreting a menu pointer or object. |
| C8 — WF-029 ONE_PASS as a complete vehicle fix | `L/connection/wf029-apply-result.json`; `L/connection/wf029-rollback-result.json`; `L/CONTINUITE.md` | `OBSERVED`: policy write and rollback; reported local failure is qualitative feedback, not measured speed/distance. | `REJECTED` | Preserve the narrow rollback and feedback; do not reject every possible WF-029 role or promote the trial to a controlled gameplay test. |
| C9 — v0.2.0 CWCheat `C` guard | `L/archives/Size_Matters_60FPS_GLOBAL_EXPERIENCE_v0.2.1-prealpha.1_UCES00420.zip::Size_Matters_60FPS_GLOBAL_EXPERIENCE_v0.2.1-prealpha.1_UCES00420/README.md` | `OBSERVED`: the historical README reports that the `C` guard stopped the block and was replaced by bounded `E` guards. Exact in-game effect was not independently replayed here. | `SUPERSEDED` | Keep the failed guard design with its version; do not infer that the replacement validated the entire gameplay table. |

## Gameplay and system-domain register

| Domain / existing material | Historical evidence | Technical evidence status | Migration state | Next action and boundary |
|---|---|---|---|---|
| Base timing and Pokitaru/Ryllus level edits | `L/archives/Pokitaru_60FPS_V1_two-builds.zip::pokitaru_v1/README_Pokitaru_V1.md`; `L/research-2026-09-18-global/patch_ledger.csv`; `L/history/6a85799c-3910-83ed-9eb6-d06abbec9590.md` | `OBSERVED`: historical VBlank, delta, substep and local-physics words and module-specific coordinates. Cross-level gameplay fidelity `UNKNOWN`. | `NEEDS_REVALIDATION` | Later document the exact baseline, changed words and measured 30/unpatched 60/patched 60 behavior in `docs/systems/timing/` and `docs/systems/levels/`. |
| Kalidon acid, platform and WF-058 / MungoDrone | `L/CONTINUITE.md`; `L/OVERCOMPENSATED_VUE_ENSEMBLE.md`; `L/history/6a86dce7-2998-83eb-bf81-229c2835c35d.md` | `OBSERVED` as historical reports: acid about twice as fast and WF-058 sequence about 6.10 s in A versus 3.05 s in B. WF-044 fluid-update causality and the 30/60 explanation are `INFERRED`; raw WF-058 measurement provenance remains incomplete. | `NEEDS_REVALIDATION` | Preserve the narrow numbers and candidate call paths in `docs/systems/levels/`; do not call ONE_PASS or any local change a validated fix. |
| Metalis vehicles, debris, crates and collection | `L/metalis-global-audit/README.md`; `L/research-2026-09-16/metalis/README.md`; `L/connection/clanksaw-movement-result.json`; `L/connection/arena-batch-result.json`; `L/connection/pickup-collection-1789593231151.json` | `OBSERVED`: recorded code sites, guarded writes/readbacks and qualitative feedback. Field roles and symptom causality are partly `INFERRED`; measured gameplay equivalence `UNKNOWN`. | `NEEDS_REVALIDATION` | Preserve separate experiment/version records; later compare duration, distance, hit/collision and pickup behavior against 30 FPS. |
| Weapons, damage, melee and animation | `L/supplemental-files/known_weapon_patch_candidates.csv`; `L/research-2026-09-18-global/weapons-gadgets/`; `L/research-2026-09-16/metalis/combat-minigames-followup.md`; `L/CONTINUITE.md` | `OBSERVED`: static candidates and user-reported Burner/melee symptoms. Damage accumulators, missile recoil ownership and cooldown semantics are `INFERRED` or `UNKNOWN`; no broad parity test is established. | `NEEDS_REVALIDATION` | Preserve candidate addresses and reports for `docs/systems/weapons/`; defer authoritative names and fixes until isolated damage/ammo/timing measurements. |
| Camera, menu timing and rendering | `L/OVERCOMPENSATED_VUE_ENSEMBLE.md`; `L/research-2026-09-16/menus/RAPPORT.md`; `L/research-2026-09-16/render/README.md`; `L/development-v0.6.2-menu/REPRISE_MENU.md` | `OBSERVED`: reported camera distance `9.0` and height `1.90`, static pause-cycle candidates, symbol matches and menu prototype reports. Blink cause, camera parity, menu persistence and visual effects remain `INFERRED` or `UNKNOWN`. | `NEEDS_REVALIDATION` | Keep camera, menu and PPSSPP rendering evidence distinct in their later system documents; do not present unapplied float candidates or a host build as a visual fix. |
| Input and second-stick prototype | `L/snapshot-original/RACSM_Controls/NOTES_TECHNIQUES_FR.md`; `L/snapshot-original/RACSM_Controls/source/main.c`; `L/CONTINUITE.md` | `OBSERVED`: v0.1 source and historical camera/input coordinates. Special-camera coverage, L2 latency and reported `AnalogIsCircular=True` gameplay effect remain `UNKNOWN` beyond user feedback. | `INVENTORIED` | Preserve prototype and tentative coordinates for `docs/systems/input/`; do not treat emulator input configuration as a game-code patch. |
| Giant Clank, Airboard and other special modules | `L/sources-v0.6.0/README.md`; `L/trace-validation/trace_L22_0002.result.txt`; `L/sessions/plantage-clank-geant-20260917-2134/RAPPORT.md` | `OBSERVED`: module coverage and a detect-only Airboard trace; specific 60 FPS gameplay and crash cause `UNKNOWN`. | `UNRESOLVED` | Record module identity and exclusions before any level-specific claim. A detect-only parser PASS is not Airboard gameplay validation. |
| Save format and potential decompilation anchors | `L/research-2026-09-16/saves/README.md`; `L/research-2026-09-18-global/static-inventory/`; `L/research-2026-09-16/menus/RAPPORT.md`; `L/research-2026-09-16/render/README.md` | `OBSERVED`: save blocks, static object/callback/pvar catalogs and symbol-bearing extracts. Structure-field meanings, callback ownership and symbol rebasing can remain `INFERRED` or `UNKNOWN`. | `INVENTORIED` | Preserve offsets and generation provenance in `research/`; verify semantics before assigning canonical engine or game-global names. |
| Unreviewed archival claims | `L/archives/` (including historical `.docx`); `L/history/` | `OBSERVED` existence; unique claims in unexamined files `UNKNOWN`. | `NOT_REVIEWED` | Inspect selectively when a concrete question requires them; do not promote archived conversation or document claims without source evidence. |
| Redundant historical build/toolchain copies | `L/toolchains/`; `L/development-v0.6.4-no-menu/backup-plugin-before-no-menu/` | `OBSERVED` preserved files; copies provide provenance and recovery, not independent validation. | `LEGACY_ONLY` | Preserve originals and hashes; document useful build knowledge rather than bulk-copying binaries into V2. |

---

## Migration procedure

For each legacy item:

### 1. Locate

Record:
- source path;
- relevant files;
- relevant historical version;
- related scripts or outputs.

### 2. Understand

Determine:
- what question was being investigated;
- what result was reached;
- what evidence existed;
- whether the result was measured, inferred, or merely assumed.

### 3. Classify

Assign an evidence status using:

`docs/methodology/EVIDENCE_LEVELS.md`

### 4. Preserve provenance

Record where the information came from.

When useful include:
- legacy file path;
- commit/tag;
- original filename;
- hashes;
- original addresses;
- date of experiment.

### 5. Revalidate

Important gameplay or timing claims should normally be revalidated against a controlled 30 FPS / 60 FPS baseline.

### 6. Migrate

Move the intelligible result into the appropriate V2 documentation or research area.

Do not necessarily move the original file.

### 7. Link

The new documentation should point back to the relevant legacy evidence when possible.

### 8. Update this file

Change the migration state and note the V2 destination.

---

## Information that should survive migration

Preserve whenever useful:

- function addresses;
- module identities;
- call sites;
- return addresses;
- constants;
- memory offsets;
- structures;
- timing values;
- test measurements;
- traces;
- known regressions;
- failed patches;
- rejected hypotheses;
- old symbol names;
- tooling;
- scripts;
- build methodology;
- level-specific discoveries;
- weapon behavior;
- camera behavior;
- input behavior;
- unusual PPSSPP observations.

---

## What should not automatically migrate

Do not copy into V2 simply because it exists:

- duplicate binaries;
- toolchains;
- savestates with no documented purpose;
- generated build outputs;
- redundant PRX copies;
- temporary logs;
- caches;
- external dependencies;
- obsolete working directories.

Important information from these items should be documented instead.

---

## Generated datasets

Historical generated inventories may remain frozen as V1 evidence.

For V2, document:

- generator script;
- input data;
- generation parameters;
- output format;
- SHA-256 where useful.

Prefer reproducible regeneration over manually maintained giant output files.

---

## Patch migration

Do not migrate an old patch merely because it worked.

For each patch establish:

- symptom addressed;
- original baseline;
- patched behavior;
- suspected mechanism;
- actual mechanism if known;
- side effects;
- whether a root-cause fix now exists.

Use the migration states defined above. A patch table, successful build, host test, or runtime write/readback can remain `INVENTORIED` or `NEEDS_REVALIDATION`; move a correction to `MIGRATED` only after its claim, scope, evidence and V2 destination have been reviewed. Preserve `SUPERSEDED`, `REJECTED` and `UNRESOLVED` outcomes explicitly.

---

## Research debt

Legacy discoveries that cannot yet be explained should be tracked explicitly. Current concrete debts are F2 (LEVEL_02 provenance), F5–F6 (missing or conflicting trace provenance), F8 (54-entry linkage), F10 (176 unmatched/non-unique transfers and tentative semantics), C2 (pickup behavior), C3 (Giant Clank root cause), and the gameplay-domain rows above. Resolve each against its cited source and a narrow question; do not hide it inside a broad “60 FPS fixed” status.

Research debt is preferable to pretending uncertainty does not exist.

---

## Migration completion criterion

The legacy project does not need to disappear.

Migration is considered sufficiently complete when:

- all important V1 discoveries are inventoried;
- validated behavior has a V2 home;
- unresolved material is explicitly tracked;
- rejected hypotheses are preserved;
- important tests are reproducible;
- future contributors no longer need to understand the entire historical folder structure to work effectively.

The V1 tag remains permanently available even after migration is complete.
