# V1 parity inventory — Explorer evidence-discovery report

**Mission:** read-only inventory of framerate-dependent behaviour in legacy Overcompensated V1, for V2 revalidation.
**Worker role:** Explorer (evidence discovery).
**Date of investigation:** 2026-09-18. **Repository state:** working tree read; tag `legacy-60fps-pre-v2` present (`9d477f056b8c3353c7d108fd3ea8a5bc4e2ed2bd`, log shows it as the commit before V2 research began).
**No file was created, modified, moved or deleted; no emulator, patch, generator or script was executed.** All commands were file listing, text reads, `tar` entry reads on ZIPs, PowerShell `ConvertFrom-Json`, and CSV row counts.

---

## 1. Provenance anchors used

`L/` = `01-Travail-et-profil-PPSSPP/Overcompensated-Reprise-2026-09-14/`
`P45/` = `L/sources-v0.4.5/Size_Matters_wrapper_profiler_v0.4.5-prealpha_UCES00420/`
`P50/` = `L/sources-v0.5.0/Size_Matters_wrapper_dispatcher_v0.5.0-prealpha_UCES00420/`

Primary anchors verified by reading:

| Anchor | Content used | Notes |
|---|---|---|
| `L/archives-manifest.csv` | 16 archives with SHA-256 | confirms each archive is the versioned record |
| `L/history/index.json` + 7 `history/*.md` | 88 archived turns; conversations "Valider le patch 60 FPS", "Système PRX MIPS", "Analyse du projet 60 FPS", "Fix mouvement Ratchet", "Ajuster le FOV PS2" | historical statements, not validation |
| `L/archives/Pokitaru_60FPS_V1_two-builds.zip` | `README_Pokitaru_V1.md` (22-write table, 15 local JAL), two INIs | exact write words + PRX hash |
| `L/archives/Pokitaru_60FPS_profils_tests_prealpha_2026-08-06.zip` | 7 split INIs, `MATRICE_TESTS.md`, `VALIDATION_TECHNIQUE.md`, `patch_manifest.json` | static-only validation, explicitly so |
| `L/archives/RCSM_Kalidon_Passage_B_60FPS_Titanium_v0.1_UCES00420.zip` | 8-write socle block + `PATCH_MAP.csv` | exact words |
| `L/archives/Size_Matters_60FPS_GLOBAL_EXPERIENCE_v0.2.1-prealpha.1_UCES00420.zip` | `patch_manifest.json` (1.14 MB), `03_...EXPERIENCE...ini` (205 KB, per-mechanic comments), coverage CSV, corrective doc | the largest static mechanics catalogue |
| `L/archives/Overcompensated_v0.6.0_global_experimental_UCES00420.zip` | `README.md`, `sources/BINARY_AUDIT.json`, `sources/POLICY_RESOLUTION.json`, `patch.prx`, generated C | build/integration record |
| `P45/tables/wrapper_families.csv`, `wrapper_callsites.csv`, `object_descriptors.csv` | 59 families with static domain hypotheses, exact object descriptors | semantics mostly `INFERRED` |
| `L/trace-validation/*.csv` + `*.result.txt` | parser output for 7 captures | derived from `L/snapshot-original/PLUGINS/SizeMattersWrapperProfiler/trace_*.json` (raw JSON present, see §3.1) |
| `L/inventaire-2026-09-17/inventaire-manuelles.csv` (111 rows), `inventaire-plugin.csv` (1,425 rows), `INVENTAIRE_MEMOIRE.md` | manual vs automatic writes | exact before/after words |
| `L/metalis-global-audit/README.md`, `L/research-2026-09-16/metalis/README.md`, `combat-minigames-followup.md` | Metalis RVAs and negative findings | some semantics tentative |
| `L/research-2026-09-18-global/*` | `patch_ledger.csv` (1,470 data rows), `wrapper_ledger.csv` (493), `injected_caves.csv` (512), `audit-v063-pickup.csv` (45), `patch_audit_summary.json` (`live_validation=false`), `AUDIT_HISTORIQUE.md`, `iso_verification.json`, `RETRAIT_MENU.md` | static audit layer |
| `L/sessions/*`, `L/connection/*` | observations, status logs, experiment JSONs | one loaded session each |
| `L/research-2026-09-16/menus/RAPPORT.md`, `pause-blink-candidate.json` | pause-blink candidate (4 floats, unapplied) | static |
| `L/research-2026-09-16/render/README.md`, `L/history/6a919605-...md` | FOV 54.42° vertical, camera distance 5.0/height 1.14 vanilla; PS2 preset 9.0/1.90 | Priority-2 feature, not parity |

Versioned module hashes (single consistent reference set, from `research-2026-09-18-global/prx_hashes.csv` and `audit-historique-preuves.json`):

`LEVEL_01 d10a81d0…6571`, `LEVEL_02 0037689a…c8aa`, `LEVEL_03 4b6cf5e4…8b94`, `LEVEL_04 6896122a…dc37`, `LEVEL_05 af7474d3…bbbb`, `LEVEL_06 c7953cd3…c39c`, `LEVEL_07 40e236a8…233d`, `LEVEL_08 c6906ca8…d8a8`, `LEVEL_09 5674dd1a…6370`, `LEVEL_10 07f9010f…3772`, `LEVEL_15 cebd5b53…8e70a`, `LEVEL_21 0e7a7f7d…d706`, `LEVEL_22 be7ef863…8986`, `LEVEL_23 7c8a790e…f7561`, `LEVEL_24 a4e3f649…80bf`.

---

## 2. Status vocabulary and arm definitions

`A` = original 30 FPS, `B` = uncorrected 60 FPS (socle only, vanilla wrapper), `C` = candidate corrected 60 FPS.
Statuses are claim-scoped: `OBSERVED`, `INFERRED`, `CORROBORATED`, `TESTED`, `UNKNOWN`, `REJECTED`, `SUPERSEDED`.

Two counting rules are used and must not be conflated:

* **reported quantitative baseline** — a number appears in a historical report or chat, raw capture not located;
* **usable reproducible 30 FPS baseline** — number backed by an identified capture artifact (raw JSON/CSV/video with hash/session identity) in the repository.

`TESTED` is used only where a controlled or deterministic check has a recorded environment and result. It is never used for "the plugin wrote the word" or "the parser passed".

---

## 3. Corrections and verifications against the navigation inventory

These are the most important Explorer findings relative to `legacy-v1-inventory.md`.

**3.1 Kalidon raw captures: B is present in the repository, A is not. This also resolves 67,905 vs 87,570.**
The raw trace JSONs exist at `L/snapshot-original/PLUGINS/SizeMattersWrapperProfiler/trace_L03_*.json` (identical copies in `L/before-v060-detect/SizeMattersWrapperProfiler/`). I parsed them directly:

| Raw file | module | samples | installed | active entries | total hits | families above zero |
|---|---|---:|---:|---:|---:|---|
| `trace_L03_0001.json` | LEVEL_03 | 1826–5632 | 33 | 3 | 19,287 | WF-013 12,822; WF-014 6,465 |
| `trace_L03_0003.json` | LEVEL_03 | 15526–16785 | 33 | 3 | 2,006 | WF-013 1,334; WF-014 672 |
| `trace_L03_0004.json` | LEVEL_03 | 16805–58573 | 33 | 8 | **87,570** | WF-013 64,258; WF-014 10,474; WF-044 7,325; WF-002 2,585; WF-058 1,943; WF-016 985 |
| `trace_L03_0005.json` | LEVEL_03 | 16805–58764 | 33 | 8 | 87,570 | identical to 0004, cumulative |
| `trace_L22_0002.json` | LEVEL_22 | 5646–15513 | 0 | 0 | 0 | none (detect-only) |
| `trace_L04_0002.json` | LEVEL_04 | 10929–13501 | 0 | 0 | 0 | none |
| `trace_L01_0001.json` | LEVEL_01 | 1237–10908 | 0 | 0 | 0 | none |

All four use `runtime_base=0x09141D00`, `delta=32768`, plugin `0.4.5-prealpha`, schema `rcsm-wrapper-trace/4`. `L/trace-validation/*.csv` totals match these JSONs exactly (verified: 19,287 / 2,006 / 87,570 / 87,570).

Consequences: the **B (60 FPS) raw capture is preserved**; the **A (30 FPS) raw capture, the 14:44 video and 67,905/72,039 totals are only reported in `history/6a86dce7-...md` (lines ~4090-4230, 4383-4460, 4560-4580)**. 67,905 = first vanilla playthrough (reported row totals WF-013 51,762 + WF-014 8,774 + WF-002 2,848 + WF-016 952 + WF-044 1,624 + WF-058 1,945); 72,039 = second video-synchronised vanilla playthrough (2,866 + 69,173); 87,570 = B. They are three different sessions, not contradictory measurements of one run.

**3.2 v0.6.1 167/167 + 36/36.** Confirmed where the critical review said: arrays live in `L/connection/dev061-integration-1789598570306.json` (`scope="read-only integration check; not gameplay validation"`), not in `L/development-v0.6.1/LIVE_VALIDATION.json`. `status.log` corroborates `static_writes=160` for Metalis (167 entries − 7 CONTINUOUS).

**3.3 Profiler stage 02/03.** `P45/POKITARU_STAGE02_RESULT.md` and `RYLLUS_STAGE03_RESULT.md` are the only located sources; I found no raw stage-02/03 trace JSON in `P45/`, the profiler ZIPs or elsewhere. `L/trace-validation/trace_L01_0001.result.txt` is 0 installed / 0 hits and is not a substitute.

**3.4 LEVEL_02 hash discrepancy is real.** `research-2026-09-18-global/iso_verification.json`: ISO `LEVEL_02.PRX` `811d9ba8…ea62` vs reference `0037689a…c8aa`; 14/15 modules match. Reference is used by the generators (`VALIDATION_TECHNIQUE.md` states Ryllus was built from `LEVEL_02_clean.PRX`, itself derived from a RAM dump per `Pokitaru...zip/README`). Cause `UNKNOWN`. Neither copy should be treated as unquestioned vanilla.

**3.5 Minor.** `patch_ledger.csv` has 1,471 lines = 1,470 data rows (matches `patch_audit_summary.json`); `wrapper_ledger.csv` 494 lines = 493 callsites; `injected_caves.csv` 513 lines = 512 cave words. `P45/tables/family_patch_relations.csv` has a header and zero rows.

---

## 4. Candidate parity items

### 4.1 Base timing, global policy, transitions

| ID | Domain / level / module | Mechanic or symptom | Provenance | A (30 FPS) | B (uncorrected 60) | C (historical corrected) | Historical status / address | Evidence status | Measurement quality / contradiction | Recommended A/B/C test; priority; dependencies; shared cause |
|---|---|---|---|---|---|---|---|---|---|---|
| VPI-001 | base timing / all solo modules | Remove one of two VBlank waits → cadence 30→60 | `Pokitaru...two-builds.zip::README_Pokitaru_V1.md` (word `0x0D0350`/Kalidon `0x0D800C`), `RCSM_Kalidon...zip::PATCH_MAP.csv` | derived only: 21,466 transitions, 21,281 two-VBlank = 99.138 % (reported, `history:4158-4460`) | raw B: 36,700/36,921 one-VBlank = 99.401 % (`snapshot-original/.../trace_L03_0004.json`) | not measured (C never gameplay-tested) | applied in CWCheat B build; in plugin tables (`patch_ledger.csv` layer 1) | B `TESTED` (cadence, this run); A `OBSERVED`-in-report only; C `UNKNOWN` | raw B present; A raw absent; socle ≠ parity | A/B/C cadence + object duration on fixed save; P0; depends on the B raw + a re-captured A | 
| VPI-002 | base timing | general delta `1/30→1/60` (`lui` word `3C043D08→3C043C88`) | `Pokitaru...README`, `Kalidon PATCH_MAP.csv`, `patch_ledger.csv` | not measured | not measured | not measured | applied | `OBSERVED` static; gameplay effect `UNKNOWN` | no A/B/C gameplay measurement | freeze one object whose code is known to consume this delta; P0 | 
| VPI-003 | player | player sub-step `2→1` (`2A240002→2A240001`) | same | not measured | not measured | not measured | applied | `INFERRED` (code), `UNKNOWN` gameplay | this is the assumed cause of WF-002's self-compensation | A/B/C jump/distance; P0; shared with VPI-028 | 
| VPI-004 | player physics | local physics compensation `46006506→460C6500` | same | not measured | not measured | not measured | applied | `INFERRED` | semantics of the float/instruction not decoded here | A/B/C on flat ground, slope, water; P0 | 
| VPI-005 | camera | camera step `+1/30→+1/60`, `−1/30→−1/60` | same | not measured | not measured | not measured | applied | `INFERRED` | camera also Priority-2 feature (VPI-072) | measure camera settle time after a forced rotation; P1 | 
| VPI-006 | base timing (obsolete) | full unlock `0x091BC350 → NOP`: gameplay ×2, loading ×3 | `history/6a85799c-...md` | n/a | observed historically | n/a | `SUPERSEDED`/`REJECTED` for reuse; also documented as an incomplete 2016-era unlock | `OBSERVED` historical statement | not in the final socle | keep as negative reference; do not re-test as a fix | 
| VPI-007 | loading / frontend | native loading screens run ~20 FPS; VBlank/FMV/frontend are separate domains | `history/6a85799c-...md` (public "form" section); `sessions/plantage-.../RAPPORT.md` (user observation) | reported 20 FPS | "stays 20 FPS" (user) | must remain untouched | policy statement, not a patch | `OBSERVED` historical only | no measurement | verify loading cadence is unchanged by the patch; P1; guard-rail | 
| VPI-008 | multiplayer | `LEVEL_16`–`LEVEL_20` do not contain the three central simulation signatures | `history/6a85799c-...md` | n/a | n/a | excluded by design (v0.2.1 "never patched") | no patch | `OBSERVED` static claim | not re-verified at binary level here | confirm by signature scan before any MP work; P3 | 
| VPI-009 | 30/60 toggle | requested/applied/pending; `frame_rate applied=30 requested=30 … game_writes=0` | `L/development-v0.6.1/sources/profiler/src/psp_plugin_runtime.c`; `sessions/plantage-.../status.log` | n/a | n/a | mode acknowledged by plugin | compiled, enabled at times, never gameplay-parity tested | `OBSERVED` plugin state; actual cadence `UNKNOWN` | no independent timing | verify real cadence + no residual writes after 30 request; P0-adjacent (needed for A arms) | 
| VPI-010 | wrapper policy (global) | v0.6.0 policy: 119 ONE_PASS / 374 TWO_PASS / 168 custom-fallback of 493 callsites | `Overcompensated_v0.6.0...zip::sources/POLICY_RESOLUTION.json` | n/a | n/a | candidate policy | static policy only, `ppsspp_gameplay_tested=false` in `BINARY_AUDIT.json` | `OBSERVED` static candidate | not a validated correction | do not treat as validated; base for family-level tests |

### 4.2 Pokitaru (LEVEL_01) and Ryllus (LEVEL_02)

All 22 Pokitaru common writes are tabulated in `L/archives/Pokitaru_60FPS_V1_two-builds.zip::pokitaru_v1/README_Pokitaru_V1.md` (words + PRX hash `d10a81d0…6571`). No A/B/C gameplay measurement for any of them is recorded.

| ID | Domain / level / module | Mechanic or symptom | Provenance (address = reference base `0x09139D00`) | A | B | C | Historical status | Evidence status | Quality / contradiction | Test recommendation; priority; shared cause |
|---|---|---|---|---|---|---|---|---|---|---|
| VPI-011 | collectible / 01 | Titanium Bolt speed `0.24→0.12` (`0x09412308`), factor `2.0→1.0` (`0x092B548C`); Kalidon `0x09430A58`/`0x092D2DC4` | `README_Pokitaru_V1.md`; `Kalidon PATCH_MAP.csv` | not measured | not measured | Kalidon B: bolt visibly collected at 60 FPS (user) | applied | `OBSERVED` static + trial; timing `UNKNOWN` | no duration comparison; "collected" ≠ parity | trajectory/duration + pickup; P1; ties to VPI-051 | 
| VPI-012 | enemy / 01 | Crab pursuit speed ×0.5 (`0x09409028`), attack threshold 27→54 (`0x094090C8`) | `README_Pokitaru_V1.md` | not measured | not measured | candidate | applied | `INFERRED` | threshold is *increased*, not halved — note the unit | crab approach + attack cadence; P0; shared with VPI-023/024/031 | 
| VPI-013 | enemy / 01 | TrainingBot speed ×0.5 (`0x09412D18`); hitbox window `0x32→0x64`, `0x35→0x6A` (`0x092BF014`/`1C`) | same | not measured | not measured | candidate | applied | `OBSERVED` static | integer window widening is unexplained | calib. target dummies already proposed in `history:6a85799c`; P0 | 
| VPI-014 | enemy wave / 01 | EnemyWave delta `1/30→1/60` (`0x09271C5C`) | same | not measured | not measured | candidate | applied | `INFERRED` | not observed in a trace | wave spawn interval; P1 | 
| VPI-015 | moving object / 01 (+03/06/07/09/10 WF-016) | HutDoor open/close rate (`0x0940C5C0`; Kalidon `WF-016` 2 callsites) | `README_Pokitaru_V1.md`; `wrapper_families.csv` WF-016 `HutDoor` (forte); `trace_L03_0004` 985 hits | Kalidon: 952 hits over the A session (reported), cadence 2-VBlank | Kalidon raw: 985 hits, cadence 1-VBlank | not measured | applied (Pokitaru); Kalidon ONE_PASS candidate | `OBSERVED` cadence; duration `UNKNOWN` | "same total work in half the time" is inferred | complete open cycle timed from a fixed save; P0; cross-level variant of the same family | 
| VPI-016 | NPC path / 01 | Luna target speed `0x0940EBA0` | `README_Pokitaru_V1.md` | not measured | not measured | candidate | applied | `INFERRED` | WF-017 (LunaNPC/Sprout) unobserved on Ryllus | path-follow duration; P1 | 
| VPI-017 | door / 01 | Level01DoorTarget speed (`0x0940E1F0`; WF-046) | same; `wrapper_families.csv` WF-046 | not measured | not measured | candidate | applied | `INFERRED` | none | door cycle; P1 | 
| VPI-018 | door / 01 | TriggeredDoor profile-4 speed (`0x094132A8`; WF-019, second path unobserved) | same; `wrapper_families.csv` WF-019 "deuxième chemin" missing | not measured | not measured | candidate | applied | `INFERRED` | WF-019 second branch never exercised | cycle + second branch; P1 | 
| VPI-019 | vehicle / 01 | Level01Boat speed (`0x0940DFDC`; WF-036 3 callsites; also in WF-005 graph) | same; `wrapper_families.csv` WF-036 exact `Level01Boat` | not measured | not measured | candidate | applied | `INFERRED` | one object under two families — double-compensation risk | boat journey time; P0; shared with VPI-029/030 | 
| VPI-020 | enemy / 01 | TMRobotHeadB speed (`0x0941244C`; WF-030 exact `TMRobotHeadB_Update`, source path `.../MOBYS/TMRobotHeadB/TMRobotHeadB.cpp`) | same; `wrapper_families.csv` WF-030 | not measured | not measured | candidate | applied | `INFERRED` | never observed in a trace | acquisition/attack/recovery; P0 | 
| VPI-021 | vehicle / 01 | DropshipB init factor (`0x09269344`) + 6 direction/orientation callsites (`0x09268764…094C`) deliberately excluded from local build; WF-033 (6 pokitaru callsites), WF-047 | same; `wrapper_families.csv` WF-033/047 | not measured | not measured | candidate | 1 speed write applied; orientation writes static candidates | `OBSERVED` static | init-time values: level reload required | flight duration + orientation; P0 | 
| VPI-022 | elevator / 01 | Final elevator progression `0x092900E8` (`1/60` step) | `README_Pokitaru_V1.md` | not measured | not measured | candidate | applied | `INFERRED` | explicitly named as a Priority-0 example in PROJECT_GOALS | elevator duration; P0 | 
| VPI-023 | enemy navigation / 01 | Crabs that jump water→island fall back into water under the **global wrapper** build | `history/6a86dce7` (user report, line ~4720); `CONTINUITE.md` ("Sauts ratés avec ancien wrapper global") | no arc measured | no arc measured | not measured | global-wrapper variant only; Local-JAL reference | `OBSERVED` user symptom; cause `INFERRED` | one of the two explicit reasons the global wrapper is unsafe | dedicated A/B/C arc; P0; shared with VPI-012/024/029/030/031 | 
| VPI-024 | enemy instance / 01 | "Giant enemy crab" is an ordinary `Crab` with `scale = PVar+0x44 = 3.0` (58 Crab placements; one at 3.0) | `history/6a86dce7` (lines ~4790-4830) | not measured | not measured | not measured | identification only, no patch | `OBSERVED` in a historical dump | instance addresses are session-specific | jump from an earlier save; P1; shared with VPI-023 | 
| VPI-025 | bridge / 02 | `Level02ExpandableBridge` (WF-037, 3 callsites, middle branch missing) | `wrapper_families.csv`; `history:6a86dce7` line ~5370 | not measured | not measured | ONE_PASS candidate | proposed (Ryllus witness) | `INFERRED` | central branch never triggered | bridge extend/retract; P0 | 
| VPI-026 | moving object / 02＋09 | `MovedObject` (WF-053), `Level02Column` (WF-055), `Boulder` (WF-057) | `wrapper_families.csv` | not measured | not measured | ONE_PASS candidate | proposed | `INFERRED` | none | cycle + collision; P1 | 
| VPI-027 | player input (PPSSPP) | Ratchet stalls mid-air on analog diagonals; `AnalogIsCircular=True` fixes it | `history/6a959c3a-...md`; `CONTINUITE.md` | vanilla with option off = stalls; with option on = works (user) | n/a | config prerequisite | not a PRX patch; PPSSPP setting | `CORROBORATED` (user A/B + PPSSPP circle→square remap) | emulator configuration, not game code; single user | re-verify with the 60 FPS build and after level transitions; P1 | 
| VPI-028 | player / rail | WF-002 = player orientation/grindrail alignment; already self-compensated by sub-steps | `wrapper_families.csv` (owner `grindrail.cpp` inferred in `history`); Kalidon A 2,595 hits / 48.767 s vs B 2,585 / 46.55 s | reported 53.2 hits/s | raw 55.5 hits/s | — | `TWO_PASS` provisional; must not be forced ONE_PASS | `OBSERVED` counts in raw B, A reported; mechanism `INFERRED` | strongest "exception" evidence | re-measure on rail/treadmill scene; P0; shared with VPI-003 | 
| VPI-029 | actor AI | WF-013 = actor horizontal direction smoothing (43 parent objects: `Crab`, `Mungo`, `MungoDrone`, `TrainingBot`, …) | `wrapper_families.csv` WF-013; `history:6a86dce7` lines ~5040-5100 | not measured | raw B Kalidon 64,258 hits | ONE_PASS candidate | proposed | `INFERRED` semantics; `OBSERVED` counts | 2 callsites appear to be two axes executed together | per-object AI movement; P0; shares root with VPI-030/031 | 
| VPI-030 | actor AI | WF-014 = `navigate.cpp` approach/speed regulator; three mutually exclusive branches (flag `0x40`), thresholds 0.15/1.0/1/30 | `wrapper_families.csv` WF-014; `history:6a86dce7` lines ~5050-5080 | only branch 3 seen on Kalidon | raw B 10,474 hits | ONE_PASS candidate | proposed | `INFERRED`; branches 1-2 unobserved | do not choose a family policy from one branch | force the missing navigation states; P0 | 
| VPI-031 | crab AI | WF-021 = secondary navigation step used by `Crab` (state 16), collision-sensitive | `history:6a86dce7` lines ~4840-4870, 5030-5080 | not measured | not measured | ONE_PASS candidate | proposed | `INFERRED` | prime suspect for VPI-023 | isolate per family; P0 | 

### 4.3 Kalidon (LEVEL_03) and Airboard side-modules

| ID | Domain / level / module | Mechanic | Provenance | A | B | C | Historical status | Evidence status | Quality | Test / priority / shared cause |
|---|---|---|---|---|---|---|---|---|---|---|
| VPI-032 | moving platform / 03 | `Lvl3Platform` `WF-044` (RVA `0x0015AAEC`; structure `fluidMoby/fluidPlane/fluidSpeed/fluidIdealHeight`) | `history:6a86dce7` lines ~4600-4700, 4900-4930; `wrapper_families.csv` WF-044 `recovered`, exact `Lvl3Platform` | 1,066 hits, 35.533 s window (reported, includes player traversal) | raw 7,325 hits, 122.250 s window, 1 hit/VBlank | ONE_PASS candidate, never applied in a measured C | proposed | `OBSERVED` counts; `INFERRED` causality | B window measures the player's traversal, not a platform cycle | platform cycle duration from fixed save; P0; separate from VPI-033 | 
| VPI-033 | hazard / 03 | acid rise ×2; `fluid height += fluidSpeed` executed once per update before WF-044, no delta (RVA `0x0015AA84-90`) | `history:6a86dce7` (user report line ~4600; code line ~4930); `CONTINUITE.md`; `OVERCOMPENSATED_VUE_ENSEMBLE.md` | not measured | user reports "acid rises twice as fast" | not measured | `CUSTOM` candidate (×0.5 on speed, or delta), never applied | `OBSERVED` user symptom; cause `INFERRED` from static code | no video/time; the strongest single-symptom lead in the reports | fixed-save elevator acid height over time; P0; independent of VPI-032 | 
| VPI-034 | scripted defeat / 03 | MungoDrone sequence `WF-058` (RVA `0x092A5FDC`; 184 active VBlanks, max 12 hits/VBlank) | `history:6a86dce7` lines ~4620-4680; raw `trace_L03_0004` = 1,943 hits | reported 6.100 s (A, video-synced) | raw-derived 3.050 s (184 VBlanks × 1/VBlank) | ONE_PASS or CUSTOM candidate, not applied | proposed | B `TESTED` (arithmetic from raw + 60 Hz sample unit); A `OBSERVED`-in-report; C `UNKNOWN` | raw A and video absent in repository; "6.10 vs 3.05" is a reported lead with incomplete raw provenance | re-shoot A and apply ONE_PASS as C; P0; **the cleanest discriminating test available** | 
| VPI-035 | Airboard / 22 (and 23) | LEVEL_22 = Kalidon Skyboard, 11 callsites; LEVEL_23 = 24 callsites; not instrumented during the passage | `history:6a86dce7` lines ~2006-2030, 4090-4120; `trace_L22_0002` raw = 0 installed/0 hits | course run 2:51.6 in the A video (reported) | no 60 FPS run | v0.2.1 static table: LEVEL_22 = 17 writes (2 weapons/7 breakables/3 FX); LEVEL_23 = 98 | static candidates only | `OBSERVED` detection and zero writes | **detect-only trace is not gameplay validation** | boost speed, lap timer, collisions, transitions; P1; shares CUSTOM_FX with VPI-084 | 
| VPI-036 | transitions / all | module demo/uninstall/reinstall across an Airboard excursion worked (33/33 → 0 → 33) | `trace_L03_0001/0003/0004` + `trace_L22_0002` + `trace_L04_0002`; `history:6a86dce7` | n/a | observed in B session | n/a | plugin mechanism | `OBSERVED` (traces) | no gameplay meaning | regression test, not a parity item; P1 | 

### 4.4 Metalis (LEVEL_04) — vehicles, arena, crates, debris, pickups

Sources: `L/inventaire-2026-09-17/inventaire-manuelles.csv` (111 rows), `INVENTAIRE_MEMOIRE.md`, `L/connection/*.json`, `L/metalis-global-audit/README.md`, `L/research-2026-09-16/metalis/README.md`, `L/development-v0.6.2-menu/.../psp_plugin_runtime.c`, `research-2026-09-18-global/audit-v063-pickup.csv`.

| ID | Domain | Mechanic / RVA (module LEVEL_04, ref hash `6896122a…dc37`) | Provenance | A | B | C | Status | Evidence | Quality | Test / priority / shared cause |
|---|---|---|---|---|---|---|---|---|---|---|
| VPI-037 | vehicle (player) | ClankSaw movement table RVA `0x2ECE98`-based (`+0` cap 0.2→0.1, `+4` reverse cap, `+0xC` accel, `+0x14` brake, `+0x18` coast) | `inventaire-manuelles.csv` rows; `clanksaw-movement-result.json` | not measured | not measured | values applied in memory, user "correct" | applied + readback, then integrated (7 of 7) | `TESTED` memory application; gameplay `OBSERVED` qualitative | no duration/distance | measure speed/stop distance; P0; shared with VPI-038 | 
| VPI-038 | vehicle (player) | ClankSaw angular step `+8` 0.0785398→0.0392699 | `clanksaw-rotation-result.json` | not measured | not measured | applied; user "correct" | applied + readback; integrated (1) | `TESTED` memory; qualitative gameplay | not merged | 2π rotation time; P0; shares cause with VPI-037 | 
| VPI-039 | enemy vehicle | Electro normal (`+0…+0x1C`) and Ram normal tables; Ram charge caps; Ram impulses | `arena-batch-result.json` 40 writes; `INVENTAIRE_MEMOIRE.md` | not measured | not measured | applied in memory | applied + readback (26 movement rows) | `TESTED` memory; gameplay `UNKNOWN` | user reported only that Clank was slowed and enemies/traps felt ~×2 before | enemy approach/charge timing; P0; shares table with VPI-037 | 
| VPI-040 | enemy AI timers | ClankSaw 2 float countdowns, EnemyElectro (×2), EnemyRam (×2) | `inventaire-manuelles.csv` | not measured | not measured | applied | applied + readback | `TESTED` memory only | some values differ by ~1e-7, i.e. not exactly halved — investigate | attack cadence; P0 | 
| VPI-041 | arena traps | `ObstacleSaw` cycle timer, `ObstacleVent` cycle timer, `ObstacleSpinningFloor` angular increment (0.2094→0.1047), Vent fade-in/out | `inventaire-manuelles.csv`; `metalis-global-audit/README.md` | not measured | not measured | applied | applied + readback | `TESTED` memory only; `metalis-global-audit` warns update callbacks are empty — logic lives in secondary callbacks | no trap period measured | trap period + contact damage; P0 | 
| VPI-042 | animation | saw extension/retraction divisors (`0.008072361→0.008072481`), active/recharge integer durations (RVA `0x2AB54` neighbourhood) | `inventaire-manuelles.csv` | not measured | not measured | applied | applied + readback | `TESTED` memory only | integer durations are session/state values | animation vs cooldown; P1 | 
| VPI-043 | crates | TeleporterHealth `0x13579C` and TeleporterPowerup `0x135CF0` secondary callbacks subtract 1 from object `+0x70`; shared emitter RVA `0x67060` adds `1/30` to `pvars+0x28` (candidate `1/60`) | `research-2026-09-16/metalis/README.md`; `resume-crates-result-*.json` 3 writes; `debris-collision-*.json` (user validated crate respawn delay + teleport animation) | not measured | not measured | applied | applied + readback; user favourable | `TESTED` memory; qualitative gameplay | explicit warning: do **not** also double the `30` multiplier at `0x1359C4/0x135F18` (would give ×4) | crate respawn delay + teleport duration; P0 | 
| VPI-044 | debris physics (generic) | shared integrator: half-step translation/gravity/duration cave; `+0x68` age `+1.0→+0.5`; return-to-state values | `history:6a86dce7` lines ~5249-5360; `experience v0.2.1` comments; `patch_ledger.csv` | not measured | not measured | static candidate, integrated in v0.2.1/v0.6.x | static; no A/B/C | `OBSERVED` static | addressed by v0.6 already; do not halve again | debris trajectory/lifetime/bounces; P0; shared with VPI-045/VPI-051 | 
| VPI-045 | debris collision | cave 7 word 34 `1.0→0.5` (plugin-injected instruction `lui a0,0x3F80`→`0x3F00`, address = cave7+0x88) | `research-2026-09-16/metalis/README.md` (arithmetic inconsistency: position advances 0.5 while `+0x34` countdown advances 1); `development-v0.6.2-menu/.../psp_plugin_runtime.c`; `AUDIT_HISTORIQUE.md` §3 | not measured | not measured | applied in memory (`debris-collision-...json`, user "looks normal"); Metalis-only in v0.6.2 | `INFERRED` arithmetic; integrated Metalis-only; v0.6.3 guard bug | **v0.6.3 template conflict** prevents Metalis arming (`CORROBORATED`, `AUDIT_HISTORIQUE.md` §1) | first-contact/bounce/last-debris timing; P0; shares cave with VPI-044 | 
| VPI-046 | pickups | Nano acquisition timer `0x1352FC` (−1→−0.5), Nano fade timer `0x1340A4`, pickup table `0x2E3544/54/58/5C/60` (initial speed, accel ×0.25, max speed ×0.5, steering `1−sqrt(1−α)`) | `pickup-collection-1789593231151.json`; `inventaire-manuelles.csv`; `AUDIT_HISTORIQUE.md` §2 | not measured | not measured | applied; user favourable | applied + readback; integrated (7 rows) | `TESTED` memory; qualitative gameplay | acceleration is ÷4 and steering uses a non-linear transform — naive ÷2 is wrong | pickup time-to-player, animation length, count/value; P0; see VPI-047 | 
| VPI-047 | pickups (cross-level) | v0.6.3 generalised the 5 constants to 9 modules: **27/45 values differ from the Metalis reference** | `research-2026-09-18-global/audit-v063-pickup.csv` (45 rows, all `static_only_not_gameplay`); `audit-historique-preuves.json` | not measured | not measured | static only | static generalisation; value identity `REJECTED` | `OBSERVED` mismatch | max speed ÷2, steering below cap 0.04, at-cap ÷4; LEVEL_08 table offset differs (`table-0x10` vs `table-0x14`) | per-module pickup measurement; P1; depends on VPI-046 | 
| VPI-048 | bolts (ordinary) | bolt state-0 timer `1.0→0.5`, effect interval `2→4`, state-1 denominator `15→30`, attraction linear/exponential increments | `experience v0.2.1` INI comments; `patch_ledger.csv` | not measured | not measured | static candidate in v0.2.1/v0.6.x | static | `OBSERVED` static | no gameplay test located | bolt projection + attraction; P1; shares integrator with VPI-044 | 
| VPI-049 | minigame vehicles | WF-028 (Clank torsos: `ClankSawTorso`, `ClankElectroTorso`, `ClankRamTorso`, `ClankSpikeTorso`) and WF-029 (12 vehicle classes) | `wrapper_families.csv` WF-028/029; `derby-controller-live.json` | not measured | not measured | WF-028 ONE_PASS; WF-029 TWO_PASS in v0.6.0 | one WF-029 ONE_PASS trial applied then rolled back same day | `REJECTED` as a complete vehicle fix (narrow); `OBSERVED` write/rollback | `wf029-apply/rollback-result.json` contain no speed/distance | re-test only with measurement; P1 | 
| VPI-050 | minigame controller | round/spawn/powerup controller, `DerbyPowerupHealth` (`0x1332FC`) etc. | `metalis-global-audit/README.md`; `combat-minigames-followup.md` | not measured | not measured | no patch | identification only | `UNKNOWN` | live controller had 3 `VehicleHusk` + 1 `EnemyRamTorso` at one instant | round duration/spawn cadence; P1 | 

### 4.5 Weapons, damage, melee (all modules that contain the classes)

Static catalogue: `L/archives/Size_Matters_60FPS_GLOBAL_EXPERIENCE_v0.2.1-prealpha.1_UCES00420.zip::03_...EXPERIENCE...ini` comments and `analysis/known_weapon_crosscheck.csv`; `L/supplemental-files/known_weapon_patch_candidates.csv` (170 rows, 13 systems); `class_priority_summary.csv` (145 rows with `FRAME_BASED_HIGH` labels). All of this is **static candidates only**; v0.2.1's own README says weapons are "validés statiquement" and 79 writes were "TEST".

| ID | Weapon / system | Candidate change (example LEVEL_01) | Evidence status | Note |
|---|---|---|---|---|
| VPI-051 | Lacérator / Blaster | projectile age `+1→+0.5` (`0x09251E44`), speed divisor 30→60 (`0x09251870`) | `OBSERVED` static | projectile lifetime/range |
| VPI-052 | Tremblator / Concussion Gun | candidate `1.0→0.5` (`0x09255EF0`) — **abandoned**: range/impact/cadence already correct | `REJECTED` (historical) | preserve as negative finding (`history:6a85799c`) |
| VPI-053 | Sniper Mine | `−1→−0.5` (`0x09266B80`, `0x09267F08`), `1.0→0.5` (`0x092673A0/414`) | `INFERRED` | history claims "5 s = 300 updates" — derived, no in-game timing found |
| VPI-054 | Incinérator / Scorcher (= Burner) | accumulator `1.0→0.5`, secondary `−1.0→−0.5`, damage scan `ori a0,3→6` (`0x09275A58`) | `OBSERVED` user symptom (Mungo killed in one clip where vanilla needed a full one); `INFERRED` modulo explanation | strongest weapon symptom; no measured tick count |
| VPI-055 | Pisteur Laser / Laser Tracer (continuous) | `15→30`, `6→12` (`0x0940CAD4/D8`) + cave jump at `0x09282B04` | `OBSERVED` static | DPS vs number of hits vs ammo not separated |
| VPI-056 | Gant à Bombacide / Acid Bomb Glove | `add.s`→cave (`0x0924138C`) + `swc1`→nop; impact/puddle treated as two weapons | `OBSERVED` static | DoT rate + puddle duration + superposition |
| VPI-057 | Agents Ravageurs / Agents of Doom | four `lui` `−1.0→−0.5`, `1/30→1/60`, cave jump, floats 60→120 and 2.0→1.0 | `OBSERVED` static | 4 sub-routines WF-007–010 never triggered |
| VPI-058 | Gant Mine Abeille / Bee Mine Glove | `1.0→0.5`, `1/90→1/180`, angles halved, fade 17→8.5 | `OBSERVED` static | none |
| VPI-059 | Bovinator / Mootator | five `1/N` timers doubled (`0x0940F2D8…F4`) | `OBSERVED` static | none |
| VPI-060 | T.E.L.T. / R.Y.N.O. | four angle/speed constants halved | `OBSERVED` static | none |
| VPI-061 | Barrière Statique / Static Barrier | `−1→−0.5`, `1/30→1/60`, 120→240 | `OBSERVED` static | duration + tick count + total damage |
| VPI-062 | Roquette Éclair / Shock Rocket + recoil | many `3.0→1.5`, `π/40→π/80`, 60→120, 15→30; recoil routine RVA `0x1932E4` (argument from `0x2EC338`), direct XZ add RVAs `0x2AD84-0x2ADA8`, decay table `+0x1C` at `0x2ADB4` | `OBSERVED` user symptom (knockback too strong on **enemies and player**); `INFERRED` path | warning in `research-2026-09-16/metalis/README.md`: unchanged impulse **and** unchanged decay still halves the duration — "feels ×2" ≠ distance ×2 |
| VPI-063 | Aspiro-Canon / Suck Cannon | cave jump, `0.15→0.075`, `30→60` | `OBSERVED` static | none |
| VPI-064 | generic fire rate / cooldown / ammo | no per-weapon cooldown semantics documented outside tables | `UNKNOWN` | energy-weapon cooldown only a user suspicion ("seems twice as short") |
| VPI-065 | melee | enemy melee damage event desynchronised from animation | `OBSERVED` user report; cause `UNKNOWN`; no address found | `history:6a86dce7` line ~4856; requires an event/window fix, not ONE_PASS |
| VPI-066 | XP / weapon level-up FX | three visual phases patched (e.g. `0x09189190`, `0x091893FC`, `0x091897CC`) | `OBSERVED` static | XP gain itself never measured |

### 4.6 Camera, menu, HUD

| ID | Domain | Mechanic | Provenance | Status | Note |
|---|---|---|---|---|---|
| VPI-067 | camera (parity) | camera delta ±1/30→±1/60 (VPI-005) | socle tables | `INFERRED` | no settle-time measurement |
| VPI-068 | menu | pause cursor blink: `HUDFXCYCLE_Update` RVA `0xA6A34` (Metalis) adds `+0.2`/subtracts `+0.05` per call with no delta; 4 float candidates RVA `0x2CF7D0/D4/F8/FC` | `research-2026-09-16/menus/RAPPORT.md`; `pause-blink-candidate.json` (`status=static_candidate_not_applied`) | `OBSERVED` static; gameplay `UNKNOWN` | candidate never applied or tested; 13 callsites, first state also used at `0xB427C` |
| VPI-069 | camera (feature, not parity) | PS2 framing: vanilla FOV 54.42° vertical / 84.44° horizontal, distance 5.0, height 1.14; retained preset distance 9.0 / height 1.90 (Pokitaru `0x09417188/190`, Ryllus equivalents) | `history/6a919605-...md`; `CONTINUITE.md`; `render/README.md` | `OBSERVED` user visual validation on Pokitaru | **out of Priority-0 scope**; must not be mixed into parity patches |
| VPI-070 | HUD / menu / cutscene timing (broad) | no V1 measurement of HUD element timing, menu transition duration, subtitle/objective timing, cutscene pacing | — | `UNKNOWN` | explicit coverage gap |

### 4.7 Special modes and crash

| ID | Domain | Mechanic | Provenance | Status | Note |
|---|---|---|---|---|---|
| VPI-071 | Giant Clank / LEVEL_15 & 21 | profile contains 15 writes (socle + cave return, 6 callsites); arming it preceded a host PPSSPP crash (`0xC0000005`, offset `0x2cc9bf`) twice; with LEVEL_15 excluded the same crash occurred again | `sessions/plantage-clank-geant-20260917-2134/RAPPORT.md`; `status.log`; `AUDIT_HISTORIQUE.md` §4 | `OBSERVED` repeated crash; necessity of LEVEL_15 writes `REJECTED`; root cause `UNKNOWN` | v0.6.3 dev.2 excludes modules 15/21 from every correction, i.e. Giant Clank currently has **no 60 FPS parity at all** |
| VPI-072 | Airboard | see VPI-035 | — | detect-only | LEVEL_23 has 98 static writes but no gameplay run |
| VPI-073 | Bot flinger minigame | classes `ClankBotFlingerVehicle`, `EnemyBotFlingerVehicle`, `MicrobotToss/Goal/Teleporter`; movement routine RVA `0x2AB54` shared with vehicles | `combat-minigames-followup.md`; `metalis-global-audit/README.md` | `OBSERVED` class inventory; movement `INFERRED` | user reports "double speed" (throw-to-target) |
| VPI-074 | Microbot survival/guidance | `MicroBotSurvival`, `SurvivalBot/Spawner/Port/Teleport` | `combat-minigames-followup.md`; `minigames-inventory-20260916.json` | `OBSERVED` inventory | user reports "double speed" (Lemmings-like) |
| VPI-075 | particles / VFX | generic debris half-step; Agent shrapnel step; fire emission 2/3→1/3; teleporter timers A/B; Bee Mine fade; level-up phases; Agent shrapnel; cage/water/portal effects | `experience v0.2.1` comments; `patch_ledger.csv`; `history:6a86dce7` lines ~5380-5440 | `OBSERVED` static | emitters, UV scroll, rotation phases, particle lifetime largely `UNKNOWN`; explicit `CUSTOM_FX` bucket |
| VPI-076 | bosses | `LunaBoss` (WF-035/038/040/054), `OttoGiant`, `HeavyTorso01`, etc. | `wrapper_families.csv` | `INFERRED` only | no traces, no tests |
| VPI-077 | save / progression | skill-bit interval and "free" save span claims rejected/superseded; relation to 60 FPS timing `UNKNOWN` | `research-2026-09-16/saves/README.md`; `MIGRATION.md` C4/C5 | `REJECTED`/`SUPERSEDED` | not a framerate item, kept for provenance |

---

## 5. Coverage domains with no usable evidence (explicit gaps)

These are recorded as gaps, not as items with invented content:

* HUD element timing; objective/dialogue cues; subtitle timing.
* Menu transition and pause-menu animation duration (only the cursor blink is addressed).
* Cutscenes / FMV pacing; level intro cameras; scripted camera lockouts.
* Audio timing (no artifact found at all).
* Save/load duration; death/respawn/checkpoint timing; level-start spawn behaviour.
* Boss AI phases (LunaBoss, OttoGiant, StoneIdol) and enemy AI acquisition/recovery delays generally.
* Dreamtime, Medical Outpost Omega, Challax, Dayni Moon, Inside Clank, Quadrona, HIG Treehouse level-specific mechanics (families WF-018/020/022/023/025/026/032/034/035/038/039/040/041/042/043/045/048/049/050/052/054/055/056/059 are never observed in any trace).
* Vehicles other than Metalis Clank vehicles and Airboard (FlyingCar, RiotCar, HappyRamVehicle, Lvl05Boat, DropshipC, RatchetShipAnimation).
* Invulnerability windows; status effects; enemy elemental reactions; hit-stop.
* XP / bolt economy as a timed system (only per-write candidates exist).
* Water/lava/other fluid mechanics outside Kalidon acid.
* Sniper scope / special cameras (listed as exclusions in the FOV work but never measured).
* Second-stick / L2 latency (V1 prototype; PPSSPP config, not game code — out of parity scope).
* Multiplayer LEVEL_16-20 (excluded by design).

---

## 6. Counting and reconciliation

**Distinct candidate parity items in this report: 77** (VPI-001…VPI-077).
Ambiguous / possibly duplicate items are listed in §8; if the five cross-level variants (VPI-015/016/017/018/025/029/030 apply in several modules) were collapsed to one item each, the count would drop to roughly 68, so **77 is the upper bound of the deduplicated-by-context count**.

**By class:**

* Base timing / global / transition: 10 (VPI-001…010).
* Pokitaru + Ryllus level objects and player-facing mechanics: 21 (VPI-011…031).
* Kalidon + Airboard: 5 (VPI-032…036).
* Metalis vehicles/arena/crates/debris/pickups: 14 (VPI-037…050).
* Weapons / damage / melee: 16 (VPI-051…066).
* Camera / menu / HUD: 4 (VPI-067…070).
* Special modes / VFX / crash / save: 7 (VPI-071…077).

**Measurement counts (reported vs usable):**

* Reported quantitative baseline (number in a report/chat, raw capture not located): 4 — Kalidon A totals (67,905 and 72,039), Kalidon A WF-058 6.10 s, Kalidon A WF-044 1,066 hits / 35.533 s, Airboard 2:51.6.
* Usable reproducible 30 FPS baseline: **0**. No artifact in the repository is verifiably an original 30 FPS capture with a controlled scene, save identity and repetition count. (The two profiler stage reports are derived; `trace_L01_0001` is detect-only.)
* Usable 60 FPS (uncorrected) baseline: **1 set** — Kalidon B raw traces `trace_L03_0001/0003/0004/0005.json`, plus the parser CSVs/results, from two identified sessions (both with the same socle cheat). Scope: cadence and per-family hit counts only.
* Corrected-60 gameplay (`C`) measurements: **0**. Every "C" claim in V1 is memory application, a build/integration result, or qualitative user feedback.
* Quantitative user-timing measurements: 0 (all user reports are qualitative or ordinal, except the reported video-derived Kalidon numbers).

**Historical candidate-fix counts (kept separate):**

* Proposed/static candidates, never applied: 38,219 static scalar sites (`static-inventory/counts.json`), of which 37,341 outside known wrapper families; 20 Metalis transfer candidates with 176 absent/non-unique gaps (`metalis_transfer_gaps.csv`, 176 data rows).
* Static patch words verified in a ledger: 1,470 (`patch_ledger.csv`); 493 wrapper calls; 512 injected cave words; 77 runtime-initialised constants.
* Policy candidates in v0.6.0: 119 ONE_PASS / 374 TWO_PASS / 168 custom-fallback callsites.
* Changes known applied at least once: v0.2.0/v0.2.1 CWCheat profiles (1,485 logical writes in the experience profile, 1,386 restore); v0.6.0 global profile (106 static writes on Metalis; 1,371 imported game writes overall); v0.6.1 (160 static writes, 167 entries, 36 redirects); v0.6.3 dev.1 (LEVEL_01 111, LEVEL_07 110, LEVEL_15 15); dev.2 (modules 15/21 excluded); v0.6.4 (installed, **disabled**).
* Manual applied-and-readback writes: 111 events across 7 experiments (54 carry module RVAs, 57 are policy/instance/session values).
* Gameplay-tested corrections: essentially none. The only gameplay-arm tests located are (a) Kalidon B socle cadence, (b) Metalis qualitative feedback on the manual writes, (c) the diagonal-stick PPSSPP option, (d) the Giant Clank crash trials.

---

## 7. Contradictions preserved

1. **Cave 7 chronology** — "not integrated" in `INVENTAIRE_MEMOIRE.md`/`ETAT_ACTUEL.md` vs its presence in `development-v0.6.2-menu/.../psp_plugin_runtime.c`; `SUPERSEDED` for v0.6.2, while the v0.6.3 generator/guard conflict is a separate defect (`CORROBORATED` in `AUDIT_HISTORIQUE.md` §1, host-tested in v0.6.4).
2. **Pickup generalisation** — "five constants halved" is wrong: acceleration is ÷4 and steering uses `1−sqrt(1−α)`; 27/45 rows differ (`audit-v063-pickup.csv`). Identity claim `REJECTED`.
3. **Giant Clank** — crash attributed to LEVEL_15 arming, then reproduced with LEVEL_15 excluded. Necessity `REJECTED`; cause `UNKNOWN`.
4. **WF-029 vs vehicle acceleration** — the ONE_PASS trial did not remove the acceleration and was rolled back; the rollback JSON contains no measurement.
5. **Kalidon totals** — 67,905 / 72,039 / 87,570 are three sessions; B raw is in the repository, A raw is not.
6. **"Current" version statements** — `ETAT_ACTUEL.md` (17 Sep, v0.6.3 dev.2 installed) vs `RETRAIT_MENU.md` (18 Sep, v0.6.4 installed but disabled). Time-separated states.
7. **30 FPS confirmation** — `frame_rate applied=30 requested=30 … game_writes=0` is plugin state; actual cadence and whole-memory vanilla identity `UNKNOWN`. The older "no memory check at all" is `SUPERSEDED` by preflight/route checks.
8. **Tremblator** — candidate abandoned because range/impact/cadence were already correct; a negative finding that must not be re-derived as a fix.
9. **Menu extractor** — the first `cycle-data.py` float interpretation was superseded by `finalize.py`; only the latter's four offsets should be used.

---

## 8. Missing evidence

* Original 30 FPS captures: Kalidon A video (1.3 GB, split into 3–4 MP4s in the chat, not in the repo), Kalidon A raw trace JSON (69,173/67,905 totals), Pokitaru/Ryllus/Kalidon videos, all user-reported "×2" clips.
* Profiler stage 02 (Pokitaru) and stage 03 (Ryllus) raw traces and `status(8).log`/`status(9).log`.
* Any in-game measurement of a **C** arm (candidate-corrected 60 FPS) for even one mechanic.
* Row-by-row join of the 54 RVA manual rows against versioned generated tables and the v0.6.1 live capture (the audit asserts 54/54 match but does not publish the join).
* Identity/reconciliation of the 4 "state values" excluded from the plugin (session velocity addresses `0x09CB3B00`, `…CC0`, `…4420`, `…4538`) — they are listed as `perdu ; reintegre au plugin` without a mapping.
* The `0x1352FC`/`0x1340A4`-style Metalis pickup timers were **not** generalised; no cross-module equivalents documented.
* Raw captures for the Airboard and Giant Clank modules (only detect traces exist).
* Any evidence for HUD, audio, cutscene, boss or save/load timing.
* Resolution of `LEVEL_02` provenance.
* Cause of the PPSSPP crash (`0x2cc9bf`) and of the `redirect_health_change` event ~20 s before the B recording.

---

## 9. Unresolved and possibly duplicate items

* **VPI-015/016/017/018/025** (doors and moving objects) and **VPI-029/030/031** (actor navigation) are family-level items that recur in several modules. They should stay separate per level/context because branch coverage differs, but the parent should treat them as one root-cause family each.
* **VPI-013 vs VPI-062** — both touch a "hitbox/window" concept; the TrainingBot integer window and the Shock Rocket timers may or may not share a mechanism: `UNKNOWN`.
* **VPI-044 vs VPI-045** — same cave, different arithmetic layer; unresolved whether one change explains the other.
* **VPI-032 vs VPI-033** — same object (`Lvl3Platform`), deliberately split because the platform's own movement and the acid addition are different code paths.
* **VPI-046 vs VPI-047 vs VPI-048** — three pickup/bolt items that may be one shared interpolation system; the acceleration/steering exponents suggest a shared non-linear transform.
* **VPI-054 vs VPI-055 vs VPI-056** — three continuous-damage items; the "one tick vs one hit event" question is common to all three and should be answered once with a shared instrumentation design.
* **VPI-028 vs VPI-003** — the WF-002 self-compensation explanation depends entirely on the unmeasured player sub-step change; if VPI-003 is wrong, VPI-028's policy reasoning collapses.
* **VPI-071 vs VPI-036** — the crash may be a module-identity/`matches=2` problem (`LEVEL_15 index=15 matches=2` in `status.log`) rather than a gameplay item.

---

## 10. Recommended next evidence to collect (priority-ordered, discriminating)

**P0 — these decide base-vs-local causality and are cheap with an existing save**

1. **Kalidon A re-shoot with the exact B save** (fixed save before `Lvl3Platform` and MungoDrone; same PRX `v0.4.5 stage04`; cheats off; full restart; video + trace; at least 2 repetitions). Captures: WF-044 platform cycle, acid height vs time, WF-058 defeat duration, WF-016 door cycle. This single session converts VPI-032/033/034/015 from "reported" to `TESTED` A arms.
2. **Kalidon C arm**: apply ONE_PASS only to WF-044 and WF-058 (the v0.5.0 dispatcher stage 05B mechanism is the ready tool), keep WF-002 TWO_PASS, and re-measure the same scenes. This is the first true A/B/C comparison the project can obtain.
3. **Acid custom fix test** independently of the wrapper policy (fluid-height add ×0.5 or delta-based), because VPI-033 is expected to survive a ONE_PASS change.
4. **Metalis isolated per-mechanic measurements** from a fixed save: ClankSaw speed/stop distance/rotation period; Electro/Ram approach and charge timing; one trap period; crate respawn delay; teleport duration; debris first-contact/bounce/last-fragment; Nano/ammo time-to-player. This turns 14 applied-but-unmeasured items into A/B/C data.
5. **Giant Clank clean baseline**: with the plugin fully disabled (`plugin.ini.desactive-pour-test`, cheats off, cold boot, original ISO), replay to the same crash point. Only this can separate plugin influence from emulator/backend. Then re-enable with modules 15/21 excluded.

**P1 — root-cause discovery**

6. **WF-002 / sub-step test**: force WF-002 to ONE_PASS on top of the socle and measure; this directly tests the VPI-003→VPI-028 compensation hypothesis.
7. **Crab protocol** (`history:6a86dce7` lines ~4870-4900 and 5030-5090): A; B with socle; then C1/C2/C3 with WF-013, WF-014, WF-021 individually ONE_PASS, 5 reps each, measuring apex height, horizontal distance and landing — this discriminates navigation, collision and impulse causes.
8. **Continuous-damage rig**: the TrainingBot HP-write breakpoint protocol already designed in `history/6a85799c` (assign large HP once; log old/new HP, caller PC, frame number). Use it for Burner, Laser, acid and puddle: number of damage applications, damage per application, cumulative damage at fixed real time, ammo spent, XP.
9. **Missile recoil**: watchpoint on enemy `state+0xC`, measure displacement/duration/impact count for player vs enemy paths (the "duration halves while distance stays" warning must be resolved).
10. **Melee**: breakpoint on the damage-application site, correlate with animation frame index; identify the vanilla contact window.
11. **Pause blink**: count `HUDFXCYCLE_Update` calls per frame in one pause screen, then apply the four floats as the C arm and measure the period at 30 and 60 FPS.
12. **Metalis cave 7 guard**: confirm the v0.6.4 idempotent guard actually arms Metalis in-game before any Metalis parity test.
13. **Generalised pickup**: pick one non-Metalis module and measure the 5 constants as A/B/C; the 27/45 mismatch means the current generalisation cannot be assumed correct.

**P2 — coverage**

14. Instrument Airboard `LEVEL_22`/`LEVEL_23` with an allowed-module list `3,22` or a dedicated stage, and record boost/lap/collision.
15. Observe the nine never-triggered WF families (WF-003 grindrail, WF-006 Polarizer, WF-007-010 Agents of Doom, WF-024 Skyboarder01, WF-030, WF-031) with the micro-protocols in `history:6a86dce7` lines ~5030-5070.
16. Record HUD/menu/cutscene timing, at least as a null reference, so the domain stops being a blank.

**Repository hygiene items the parent should decide on (not performed here)**

* Persist the identification result of §3.1 (B raw present, A raw absent, three distinct Kalidon totals) into the V2 trace provenance record.
* Record explicitly that no C-arm gameplay measurement exists for any mechanic; this is the single biggest gap for Priority 0.
* Keep the 27/45 pickup mismatch and the v0.6.3/v0.6.4 cave conflict as versioned, separate defects.