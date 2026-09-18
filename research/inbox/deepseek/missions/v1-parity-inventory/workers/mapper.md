# Overcompensated V2 — V1 Parity Inventory: DeepSeek Mapper Report

**Role:** structural reverse-engineering worker (DeepSeek Mapper).
**Mode:** read-only. No file was created, modified, extracted to disk, patched, or executed. Archive contents were streamed with `tar -xOf`; one attempt to create a temp directory under `%TEMP%` was refused by the read-only sandbox and changed nothing. All deterministic checks below were performed with `rg`, `Import-Csv`, `ConvertFrom-Json`, `tar`, and integer arithmetic only.

**Path convention.** `L/` = `01-Travail-et-profil-PPSSPP/Overcompensated-Reprise-2026-09-14/`. `P45/` = `L/sources-v0.4.5/Size_Matters_wrapper_profiler_v0.4.5-prealpha_UCES00420/`. `P50/` = `L/sources-v0.5.0/Size_Matters_wrapper_dispatcher_v0.5.0-prealpha_UCES00420/`. `REFBASE` = `0x09139D00`, the profiler reference base used by the whole corpus. **All addresses below are module RVAs or explicitly labelled reference-base addresses unless a session delta is named.** Historical absolute addresses are not live coordinates.

---

## 1. Provenance rules used, and what this report does not claim

- I re-read the mandatory framing files (`AGENTS.md`, `PROJECT_GOALS.md`, `MIGRATION.md`, `docs/methodology/EVIDENCE_LEVELS.md`, `research/inbox/legacy-v1-inventory.md`, `research/inbox/legacy-v1-inventory-review.md`, `tools/agents/MISSION_FAILSAFE.md`) and treated the critical review as authoritative where it corrects the navigation inventory.
- I went back to versioned primaries: the immutable archive ZIPs, `sources-v0.4.5/v0.5.0/v0.6.0`, `development-v0.6.1…v0.6.4-no-menu`, `research-2026-09-18-global/`, `inventaire-2026-09-17/`, `connection/`, `trace-validation/`, `sessions/`, and `P45/profiler/IN_SITU_ANALYSIS_v0.4.3_STAGE02.json` / `IN_SITU_ANALYSIS_v0.4.4_STAGE03.json`.
- I did **not** re-run the patch audit, the generator, PPSSPP, or any hook. Where I cite `PASS` values they are the **recorded** values of a historical check, not a reproduction by me. Where I performed my own deterministic recomputation (counts, joins of reference addresses, float/word comparisons, instruction-field decoding) I say so explicitly.
- No gameplay claim here is promoted to `TESTED` for parity. `TESTED` appears only where the scope is a recorded deterministic/host/memory-state check.
- No authoritative semantic function name is assigned from an address. Family names are legacy labels; object-descriptor names are legacy static strings.

---

## 2. Structural map

### 2.1 Module corpus and identity

| Module | Level | PRX SHA-256 (pinned reference) |
|---|---|---|
| 1 | Pokitaru | `d10a81d076fb44987a45314a020cda2f7e8b39f860b957911ca9365464676571` |
| 2 | Ryllus | `0037689a926197969231795c4d6b05980e5e94558394617b21e8b8bcd79bc8aa` |
| 3 | Kalidon | `4b6cf5e41ab9f3f30e182f15752a4d9d264904794ce568582fa78ad8177e8b94` |
| 4 | Metalis | `6896122ac19973e928303dc94c40fa309b5f06e5fef6ab14f624987035a4dc37` |
| 5 | Dreamtime | `af7474d3af87dd392717d45b2be30a3512ab5f6df3f449e1ac15ce9971a75bbb` |
| 6 | Medical Outpost Omega | `c7953cd34e82fbea8fca4125cd5f30581fa8450b858e454f83968b2cd0fec39c` |
| 7 | Challax | `40e236a82cce9be46044a06945dcd0e7aab754e91d1eb7bb75b8040101dc233d` |
| 8 | Dayni Moon | `c6906ca8805ec805063036429ecc86ce316efdd386641e87fc8c92dd90dad8a8` |
| 9 | Inside Clank | `5674dd1a09d43d0a35578a1252ce46035d6f64a139dc2660bb25a941f78e6370` |
| 10 | Quadrona/Quodrona | `07f9010f78cf6f49f8fdad0dbf89ce20375dff600183117605c3ebf231583772` |
| 15 | Giant Clank 4 | `cebd5b53f4a7f0b42cc7aec7f7e2e13749089a3dd630a3af1fcccaf81748e70a` |
| 21 | Giant Clank 7 | `0e7a7f7d70a70e51081b0471e257f50d3a86f987a5eae546b2a178d2190dd706` |
| 22 | Airboard 3 | `be7ef86357ee668bb1c194226e4cd2e55920a4f7f375952ffb494c0de5a78986` |
| 23 | Airboard 6 | `7c8a790eccf722cfd8e5a6e066d17300cf84c1f4068535a6575542229c0f7561` |
| 24 | HIG Treehouse | `a4e3f6496b3d2d238767fbb72b9db274dc5179dbe4d6f71eea2ce1fee22480bf` |

Sources: `L/research-2026-09-18-global/prx_hashes.csv`, `L/sources-v0.6.0/sources/BINARY_AUDIT.json`, `L/development-v0.6.3-generalisation/sources/profiler/generated/full_patch.generated.c`. `OBSERVED` (hash strings recorded and used by the generator assertions).

Structural facts worth carrying forward:

1. Modules **15 and 21 are declared equivalents** (`module_fingerprints.csv` → `equivalent_profile_indices` 15↔21) and share anchor `0x09148800 = 0x45010006`. A Giant Clank session log records `matches=2` before the LEVEL_15 arming (`L/sessions/plantage-clank-geant-20260917-2134/status.log:52`). Module identity for this pair is therefore **ambiguous by construction**, not merely unverified.
2. `REFBASE 0x09139D00` is shared by the corpus for all modules; per-session load deltas observed historically include `+0x6000`, `+0x7000`, `+0x8000` and `+0x12000`. I independently verified that the Kalidon B CWCheat packet's `reference_address` values map exactly onto the ledger's module-3 RVA + `REFBASE` (delta `+0x8000` in that session) for all 8 words — so the reference/RVA convention is internally consistent, and the CWCheat addresses in that packet are **session-specific relocated absos**, not RVAs.
3. `LEVEL_02.PRX` remains a provenance trap: `iso_verification.json` records 14/15 matches with ISO `811d9ba8…` vs reference/corpus `0037689a…`; `P45/tables/validation.csv` asserts `level2_clean_equals_bin_archive PASS` for `0037689a…`. The corpus copy is therefore the **"clean" copy**, which is not proven to be the ISO module. `UNKNOWN`.

### 2.2 Patch corpus: exact decomposition (deterministic recomputation)

The 18-September patch ledger is the *generated static patch table*, not a list of applied fixes. I recomputed its decomposition from `L/sources-v0.6.0/sources/provenance/experience_v021_manifest.json`, `L/development-v0.6.3-generalisation/sources/profiler/generated/full_patch.generated.c`, `audit_patch_sites.py`, and `patch_ledger.csv`:

| Layer (generator constant) | Manifest words | Ledger rows | Notes |
|---|---|---|---|
| `BASE = 1` | 60 | 60 | 4 words/module × 15 modules |
| `SOCLE = 1` | 52 | 52 | 2 or 4 words/module; no Titanium words in modules 15/21/22/24 |
| `WEAPONS = 2` | 1034 | 950 | 13 modules × 86 words minus 84 `cave_return` words |
| `BREAKABLES = 4` | 237 | 222 | 15 modules; minus 15 `cave_return` words |
| `PARTICLES = 8` | 87 | 87 | 3–8 words/module depending on module |
| `WRAPPER = 15` | 15 | **0** | one global-wrapper suppression per module, excluded from the flat ledger and replaced by per-callsite routing |
| **Total** | **1485** | **1371** | + 99 experimental extras (`54 + 45`) = **1470 ledger rows** |

- 99 manifest words of kind `cave_return` (84 weapons + 15 breakables) are **absent from the flat ledger by design** and are carried by plugin-owned cave storage.
- 15 legacy wrapper-suppression words are **absent by design** and replaced by the 493-callsite dispatcher (`BINARY_AUDIT.json`: `excluded_legacy_common_wrapper_writes=15`, `excluded_legacy_cave_returns_replaced_by_plugin_storage=99`).
- Confirmed by the recorded binary audit: `patch_words_verified=1470`, `wrapper_calls_verified=493`, `cave_words=512`, `live_validation=false`. `OBSERVED` (recorded deterministic host check); scope = generated table vs the 15 pinned reference PRXs. I did not re-run it.
- 77 of the 1470 rows carry `continuous=true` (`flags & 1`) and a file word of `0x00000000`: 7 per module for modules 1–10 and 24. These are runtime-initialised table entries (bolts/attraction) that the plugin writes only after the expected runtime value appears. `L/sources-v0.6.0/README.md` ("77 constantes initialisées à l'exécution", 100 ms poll). `OBSERVED`.

### 2.3 Wrapper corpus and dispatch policy

- 15 modules, **493 callsites**, **59 families**, 267 family members, 3990 callee rows, 972 data-reference rows, 1927 object descriptors (`P45/tables/`, recomputed in the critical review). `family_patch_relations.csv` has a header and **zero data rows** — the family→patch relation table is a real research gap.
- v0.6.0 resolution (`L/sources-v0.6.0/sources/POLICY_RESOLUTION.json`): `callsites=493`, `armed=493`, `two_pass=374`, `one_pass=119`, `custom_fallback=168`. `CUSTOM` is traced but **effectively routed to two-pass** in this version (`P50/DISPATCHER_SPEC.md` §2, §4).
- The 32 configured `one_pass_families` are exactly: WF-015, 016, 017, 019, 022, 023, 024, 025, 026, 027, 028, 030, 031, 032, 033, 036, 037, 039, 041, 042, 044, 045, 046, 047, 049, 050, 051, 053, 055, 056, 057, 058.
- The 13 `custom` families are WF-006…WF-012 (weapon/damage/vehicle-hit helpers) plus WF-035, WF-038, WF-040, WF-043, WF-052, WF-054. This means **weapon hit/tick/cooldown behaviour is deliberately not changed by the dispatcher**; only the separate `WEAPONS` constant layer touches weapon timing, and it does not touch damage accumulators.
- Family→object hints (`P45/tables/wrapper_families.csv`, `OBSERVED` static, semantics `INFERRED`): WF-013 = transversal actor helper incl. Crab/Mungo/MungoDrone; WF-014 = transversal helper (31 parent descriptors, "no exclusive association", evidence strength *faible*); WF-016 = `HutDoor` (exact descriptor, forte); WF-019 = `TriggeredDoor`; WF-036 = `Level01Boat`; WF-046 = `Level01DoorTarget`; WF-047 = `DropshipB`; WF-044 = `Lvl3Platform` (Kalidon, recovered, forte); WF-058 = `MungoDrone` (forte); WF-028 = Clank torsos (Saw/Ram/Electro/Spike); WF-029 = shared 12-vehicle helper ("no exclusive association"); WF-030 = `TMRobotHeadB` (symbolic name `TMRobotHeadB_Update` present); WF-032 = `BotFlinger`; WF-024 = `Skyboarder01`.
- Only **one** family carries a symbolic name (WF-030). Everything else is a descriptor-based hint.

### 2.4 Wrapper anatomy (runtime reference addresses, per module)

`P45/tables/wrapper_anatomy.csv`, one row per module, all sharing the same shape: wrapper entry word `0x27BDFFC0`, entry→helper delta `0x38`, helper→suppression-site delta `0x104`, suppression site `jal helper` → replaced by `nop` in the legacy global build. Example: module 1 entry `0x0914805C`, one-pass helper `0x09147F90`, suppression site `0x09148094`, `direct_caller_count=55`; module 3 entry `0x09148080`, helper `0x09147FB4`, `direct_caller_count=33`; module 4 entry `0x09147E54`, helper `0x09147D88`, `direct_caller_count=36`. `OBSERVED` static.

**Direct mapping for the Pokitaru local-JAL build:** the V1 archive's 15 local JAL rewrites map to families WF-014 (3 sites), WF-017 (3), WF-016 (2), WF-046 (1), WF-019 (2), WF-036 (3), WF-047 (1). In v0.6.0 I checked each of the 15 `$ra` values against `POLICY_RESOLUTION.json`: **12 are `one_pass`, and the 3 WF-014 sites stay `two_pass`** (`0x09162C90`, `0x09162CB4`, `0x09162CD8`). This is a concrete V1↔V0.6 policy divergence, not a duplication.

### 2.5 Per-module patch and policy table (recomputed)

| Level (module) | static writes | runtime constants | callsites | one-pass | two-pass | one-pass families |
|---|---|---|---|---|---|---|
| LEVEL_01 Pokitaru (1) | 106 | 7 | 55 | 27 | 28 | 015 016 017 019 027 030 031 033 036 046 047 051 |
| LEVEL_02 Ryllus (2) | 105 | 7 | 57 | 26 | 31 | 015 017 022 023 025 026 031 032 037 053 055 057 |
| LEVEL_03 Kalidon (3) | 105 | 7 | 33 | 6 | 27 | 015 016 024 044 058 |
| LEVEL_04 Metalis (4) | 106 | 7 | 36 | 8 | 28 | 015 023 025 026 028 030 |
| LEVEL_05 Dreamtime (5) | 103 | 7 | 40 | 11 | 29 | 017 022 027 050 056 |
| LEVEL_06 M.O. Omega (6) | 103 | 7 | 33 | 2 | 31 | 016 |
| LEVEL_07 Challax (7) | 105 | 7 | 46 | 14 | 32 | 015 016 017 019 022 039 042 045 049 |
| LEVEL_08 Dayni Moon (8) | 105 | 7 | 57 | 15 | 42 | 015 017 019 022 023 025 026 028 041 |
| LEVEL_09 Inside Clank (9) | 105 | 7 | 31 | 2 | 29 | 016 |
| LEVEL_10 Quadrona (10) | 105 | 7 | 35 | 4 | 31 | 016 019 |
| LEVEL_15 Giant Clank 4 | 15 | 0 | 6 | 0 | 6 | — |
| LEVEL_21 Giant Clank 7 | 15 | 0 | 6 | 0 | 6 | — |
| LEVEL_22 Airboard 3 | 17 | 0 | 11 | 1 | 10 | 024 |
| LEVEL_23 Airboard 6 | 98 | 0 | 24 | 2 | 22 | 015 024 |
| LEVEL_24 HIG Treehouse | 101→**108** | 7 | 23 | 1 | 22 | 015 |

Sources: `L/sources-v0.6.0/sources/COVERAGE.csv`, `POLICY_RESOLUTION.json`, `BINARY_AUDIT.json`. One discrepancy: `COVERAGE.csv` says 101 static writes for LEVEL_24 while `patch_audit_summary.json` counts 108; I did not resolve it (`UNKNOWN`, likely a version skew between the v0.6.0 coverage report and the v0.6.3 ledger). 29 callsites are only ever reachable in modules 1–10/22–24; the Giant Clank pair gets **no wrapper change at all**.

### 2.6 BASE/SOCLE word map (the 8-word core, per module)

Exact RVAs (module-qualified) — `L/research-2026-09-18-global/patch_ledger.csv`, layer 1:

| Module | VBlank unlock | general delta | player substeps | local physics | camera + | camera − | Ti factor | Ti speed |
|---|---|---|---|---|---|---|---|---|
| 1 | 0x96650 | 0x151E0 | 0x2FCFC | 0x2FBBC | 0x361C | 0x3634 | 0x17B78C | 0x2D8608 |
| 2 | 0x9C478 | 0x155E4 | 0x34160 | 0x34020 | 0x361C | 0x3634 | 0x19E5D4 | 0x2F2458 |
| 3 | 0x9630C | 0x14FD4 | 0x2E0A4 | 0x2DF64 | 0x365C | 0x3674 | 0x1910C4 | 0x2EED58 |
| 4 | 0x9A054 | 0x14E50 | 0x31004 | 0x30EC4 | 0x3430 | 0x3448 | 0x18A2D8 | 0x2EB678 |
| 5 | 0x952EC | 0x146E0 | 0x2DA08 | 0x2D8C8 | 0x361C | 0x3634 | 0x177CEC | 0x2C4498 |
| 6 | 0x9133C | 0x13E90 | 0x2CB6C | 0x2CA2C | 0x361C | 0x3634 | 0x171BA4 | 0x2C7210 |
| 7 | 0x98048 | 0x152E0 | 0x2FDF8 | 0x2FCB8 | 0x361C | 0x3634 | 0x1923F8 | 0x2E9D38 |
| 8 | 0x9F26C | 0x1575C | 0x34934 | 0x347F4 | 0x3678 | 0x3690 | 0x1B1DDC | 0x31B448 |
| 9 | 0x938B8 | 0x146F0 | 0x2C6B4 | 0x2C574 | 0x361C | 0x3634 | 0x171BB4 | 0x2C1D58 |
| 10 | 0x96F60 | 0x14958 | 0x2E760 | 0x2E620 | 0x33B4 | 0x33CC | 0x1888B4 | 0x2E0340 |
| 15 | 0x7D380 | 0x11DF4 | 0x25D7C | 0x25C3C | 0x3110 | 0x3128 | — | — |
| 21 | 0x7D380 | 0x11DF4 | 0x25D7C | 0x25C3C | 0x3110 | 0x3128 | — | — |
| 22 | 0x87F18 | 0x1239C | 0x26794 | 0x26654 | 0x33B8 | 0x33D0 | — | — |
| 23 | 0x8D720 | 0x13E70 | 0x294D4 | 0x29394 | 0x362C | 0x3644 | 0x160A18 | 0x2A8208 |
| 24 | 0x8FE1C | 0x138C4 | 0x29084 | 0x28F44 | 0x340C | 0x3424 | — | — |

Word deltas (identical in all modules):

- VBlank: `jal …` → `0x00000000`; the JAL target differs per module (m1 `0x0C06FD09`, m2 `0x0C07538B`, m3 `0x0C074EB2`, m15/21 `0x0C04BA28`).
- delta: `0x3C043D08` → `0x3C043C88` (1/30 → 1/60 constant pair `0x3D088889`→`0x3C888889`).
- substeps: `0x2A240002` → `0x2A240001` (`slti …,2` → `slti …,1`).
- local physics: `0x46006506` → `0x460C6500`. I decoded both by hand: `mov.s f10,f6` → `add.s f10,f6,f12`. **This is an opcode change, not a constant change** (`INFERRED` semantics: accumulate the halved dt instead of overwriting).
- camera ±: `0x3C043D08`→`0x3C043C88` and `0x3C04BD08`→`0x3C04BC88`.
- Titanium speed: `0x3E75C28F` (0.24) → `0x3DF5C28F` (0.12), a true halving.
- Titanium "factor": `0x3C044000` → `0x3C043F80`. **Label/numeric inconsistency:** the legacy label says "2,0 → 1,0", but the ratio of these two floats is ≈1.000015, not 2 (`OBSERVED` arithmetic on the two words). Treat every legacy label as a hypothesis, not a measurement.

### 2.7 Instruction-level mechanisms that matter (decoded by hand)

- **Debris/breakable integrator (layer 4, 15 modules, 6 core words each):**
  `0x27BDFFC0` (`addiu sp,sp,-64`) → plugin cave index 7 entry; `0xAFB00028` delay slot → NOP and reproduced inside the cave; `0x46107380` (`add.s f14,f7,f16`, vanilla gravity) → NOP; `0x46166300` (`add.s f12,f3,f22`) → `0x461C6300` (`add.s f12,f3,f28`); `0x46166301` (`sub.s f12,f3,f22`) → `0x461C6301` (`sub.s f12,f3,f28`). The cave loads `0x3F000000` (0.5) into f28 via `0x3C043F00` + `0x44846000`, which is exactly cave-7 word 34. **The "×0.5" halving is implemented by operand-register substitution plus a plugin-injected 0.5 constant**, so the flat PRX diff alone does not contain the 0.5. `OBSERVED` (words + field decode); semantic reading `INFERRED`.
- **Cave-7 word 34 conflict (verified by me):** in the v0.6.3 generated template, cave index 7 word 34 = `0x3C043F00`; `development-v0.6.3-generalisation/sources/profiler/src/psp_plugin_runtime.c:886` requires `g_full_caves[i][34] == 0x3C043F80` before writing `0x3C043F00`. So the v0.6.3 runtime **refuses** that branch on its own generated template. v0.6.4 accepts both (`METALIS_CAVE_GUARD_VALIDATION.json`, host-only). `OBSERVED`/`CORROBORATED` source conflict; `TESTED` only in the v0.6.4 host harness.
- **Weapon "-1 → -0.5" words** (`0x3C04BF80` → `0x3C04BF00`, `0x3C05BF80`→`0x3C05BF00`, `0x3C043F80`→`0x3C043F00`, `0x3C053F80`→`0x3C053F00`) are **LUI halves of constants**, i.e. the high half changes from `0xBF80` (≈-1.0 companion) to `0xBF00` (≈-0.5). Treating any of these as a standalone delta-time value is unsafe: the low half is not touched by the patch word and several were explicitly labelled "not a timer" in later analysis.
- **`ori a0,3` → `ori a0,6`** (Scorcher scan modulo): `0x34040003`→`0x34040006`. This is an integer modulus/subdivision, not a float. `OBSERVED` word; the "hit every 3rd vs 6th update" reading is `INFERRED`.

---

## 3. Candidate parity item register

Status vocabulary for the *patch* column: `proposed` (written down), `static` (in a generated table, verified against PRX words), `applied-mem` (written to a live session, read back), `gameplay-tested` (someone played it), `rejected/superseded`. Evidence column gives the claim-level status and scope. **A = original 30 FPS, B = uncorrected 60 FPS, C = candidate-corrected 60 FPS.**

### A. Global/base timing (shared mechanism, cross-level variants linked)

| ID | Mechanic (level/module) | Versioned words / RVA | Patch status | A / B / C | Evidence | Priority |
|---|---|---|---|---|---|---|
| VPI-001 | Outer loop cadence: second VBlank wait removed (all 15 modules) | `jal`→NOP, §2.6 | static, applied in every 60 build (CWCheat/plugin) | A: 99.138% of active transitions 2-VBlank apart (Kalidon); B: 99.401% 1-VBlank; C: n/a | `OBSERVED` historical instrumentation; `TESTED` scope = VBlank histogram in those two sessions; whole-game cadence `INFERRED` | P0 |
| VPI-002 | General delta constant 1/30→1/60 (all modules) | `0x3C043D08`→`0x3C043C88` | static | UNKNOWN gameplay A/B/C | `OBSERVED` words; effect `UNKNOWN` | P0 |
| VPI-003 | Player substep count 2→1 | `0x2A240002`→`0x2A240001` | static | UNKNOWN | `OBSERVED` word (`slti`); semantics `INFERRED` | P0 |
| VPI-004 | Player local physics: `mov.s`→`add.s` | `0x46006506`→`0x460C6500` | static | UNKNOWN | `OBSERVED` words + decode; intent `INFERRED` | P0 |
| VPI-005 | Camera step ±1/30→±1/60 | `0x3C043D08`/`0x3C04BD08` → halved | static; camera *framing* 9.0/1.90 is a separate optional feature | A: none; C: "visual feedback on Pokitaru" `OBSERVED` qualitative | `OBSERVED` words; camera timing parity `UNKNOWN` | P0 |
| VPI-006 | Titanium Bolt speed 0.24→0.12 + "factor" word | m1 0x2D8608, 0x17B78C (all modules except 15/21/22/24) | static | UNKNOWN | speed `OBSERVED` true halving; factor label contradicts its numeric ratio (`OBSERVED`) | P1 |
| VPI-007 | Breakables/debris half-step integrator (15 modules, 6 words) | e.g. m3 0x28140/0x28144/0x281D8/0x2CFFC/0x2D01C/0x2D1B4 | static | UNKNOWN | `OBSERVED` words + cave mechanics; gameplay effect `UNKNOWN` | P1 |
| VPI-008 | Bolt rotation/attraction table (77 runtime constants, 11 modules) | e.g. m3 0x2E2DFC…0x2E2FC4 | static, runtime-gated | UNKNOWN | `OBSERVED` rows incl. `continuous=true`; effect `UNKNOWN` | P1 |
| VPI-009 | Level-up presentation 3 phases (15 modules, 3 words) | e.g. m4 0x50A88/0x50CF4/0x510C4 | static | UNKNOWN | `OBSERVED`; "90+30+50 updates" comment `INFERRED` | P2 |
| VPI-010 | Fire emission cadence 2/3→1/3 (modules 1, 4 only) | m1 0x2D1708, m4 0x2E46E8 | static | UNKNOWN | `OBSERVED`; the "≈20 emissions/s preserved" claim is a historical comment | P2 |
| VPI-011 | Teleporter fixed timers A/B (8 modules: 1,2,3,4,7,8,9,10) | m1 0x179F68/0x17A0BC … | static | UNKNOWN | `OBSERVED`; proposed from Pokitaru profile 07 | P2 |
| VPI-012 | Bee Mine fade step 17→8.5 (12 modules) | e.g. m4 0x2E0C44 | static | UNKNOWN | `OBSERVED` words; cosmetic only | P3 |
| VPI-013 | "Decorative shrapnel step" 1.0→0.5 (12 modules) | e.g. m4 0x115B38 | static **but REJECTED by a prior local analysis** | UNKNOWN | `REJECTED` in `…/07_POKITARU_SOCLE_COSMETIQUES_TEST.ini` ("this parameter is not a delta-time"); still present in the global corpus | P3 — resolve contradiction |
| VPI-014 | Bolt "timer état 0" 1.0→0.5 (11 modules) | e.g. m3 0x11E9A4 | static | UNKNOWN | `OBSERVED` | P2 |
| VPI-015 | Bolt attraction denominator 15→30 and effect interval 2→4 (11 and 2 modules) | m3 0x2E2E14, 0x11F1FC | static | UNKNOWN | `OBSERVED` | P2 |

### B. Pokitaru level-object compensations (present only in the V1 archive; ABSENT from the v0.2.1 manifest and the 1470-word ledger)

I verified this absence directly: a regex over every `mechanic` in `patch_ledger.csv` for crab/trainingbot/boat/dropship/elevator/door/luna/enemywave returns **zero rows**, and the 9 corresponding RVAs are not present in the file. Provenance for all rows below: `L/archives/Pokitaru_60FPS_V1_two-builds.zip::pokitaru_v1/README_Pokitaru_V1.md`, `…/UCES00420_Pokitaru_V1_local-jal.ini`, `…UCES00420_Pokitaru_V1_global-wrapper.ini`, `L/archives/Pokitaru_60FPS_profils_tests_prealpha_2026-08-06.zip::…/04_POKITARU_SOCLE_NIVEAU_INDIVIDUEL_TEST.ini`; static validation `…/VALIDATION_TECHNIQUE.md` (147 vanilla values cross-checked, "structural and static… not a replacement for PPSSPP 30/60 trials"). Module 1, base `0x09139D00`, PRX `d10a81d0…`. All are `proposed`/static-only, documented as `[VALIDÉ]`/`[REPLAY]` by the author but with **no recorded A/B/C measurement**.

| ID | Mechanic (module 1 RVA from runtime−base) | Words | A/B/C |
|---|---|---|---|
| VPI-016 | Crab pursuit speed + attack threshold | 0x2CF328 `0x3E6EEEF0`→`0x3DEEEEF0`; 0x2CF3C8 `0x41D80000`→`0x42580000` (27→54 updates) | UNKNOWN/UNKNOWN/"validated" label only |
| VPI-017 | TrainingBot speed + hitbox start/end | 0x2D9018 `0x3E4CCCCE`→`0x3DCCCCCE`; 0x185314 `0x2A240032`→`0x2A240064`; 0x18531C `0x2A240035`→`0x2A24006A` | UNKNOWN |
| VPI-018 | EnemyWave private delta 1/30→1/60 | 0x137F5C `0x3C043D08`→`0x3C043C88` | UNKNOWN |
| VPI-019 | HutDoor speed + 2 local smoothing calls | 0x2D28C0; 0x1442FC; 0x1445A0 (WF-016, one-pass in v0.6.0 ✓) | UNKNOWN |
| VPI-020 | Luna target speed + 3 local smoothing calls | 0x2D4EA0; 0x2BF20/0x2BF44/0x2BF68 (WF-017, one-pass ✓) | UNKNOWN |
| VPI-021 | Level01DoorTarget speed + 1 call | 0x2D44F0; 0x1508C8 (WF-046, one-pass ✓) | UNKNOWN |
| VPI-022 | TriggeredDoor profile-4 speed + 2 calls | 0x2D95A8; 0x187724/0x1879A4 (WF-019, one-pass ✓) | UNKNOWN |
| VPI-023 | Level01Boat speed + 3 calls | 0x2D42DC; 0x14EF28/0x14F5C4/0x14F968 (WF-036, one-pass ✓) | UNKNOWN |
| VPI-024 | TMRobotHeadB speed (melee/patrol) | 0x2D874C | UNKNOWN |
| VPI-025 | DropshipB init factor + 1 flight smoothing call (6 other calls deliberately excluded) | 0x12F644; 0x12E994 (WF-047, one-pass ✓); other 6 are WF-033, two-pass | UNKNOWN |
| VPI-026 | Final elevator progression 1/30→1/60 | 0x1563E8 `0x3C063D08`→`0x3C063C88` | UNKNOWN |
| VPI-027 | Strategy-level: 15 local JAL rewrites vs neutralize the wrapper's first internal pass (55 callers) | 0xE35C entry, 0xE290 helper, 0xE394 suppression | archive says the global variant is "experimental until a complete replay"; v0.6.0 implements per-callsite routing (27/55 one-pass, WF-014 excluded) | `OBSERVED` description; `REJECTED` for reuse as a validated blanket fix |

**VPI-028 (flagged):** the 14 level-object compensations above were **dropped** when the corpus moved from the Pokitaru-local package to the v0.2.1 global manifest. If V2 assumes "the global ledger covers the V1 fixes", Pokitaru object parity is silently incomplete. This is the single most important coverage reconciliation in this report.

### C. Kalidon

| ID | Mechanic (module 3 RVA / reference RA) | Words / callsite | Patch status | A / B / C | Evidence |
|---|---|---|---|---|---|
| VPI-029 | `Lvl3Platform` movement, WF-044, owner RVA 0x158A18 (size 10760) | callsite RVA 0x15AAEC, `$ra` ref `0x092947F4`; one-pass in v0.6.0 | static policy + historical `ONE_PASS_CANDIDATE` | A: 1066 hits / 35.533 s (video window 08:03.883–08:39.417); B: 7325 hits / 122.250 s; C: not run | `OBSERVED` historical measurement + trace CSV (0004: 7325 hits, 7319/7324 1-VBlank gaps); A-video window is **not a pure cycle** (includes player movement/retries) |
| VPI-030 | Acid/fluid height (`fluid += fluidSpeed`, direct add before wrapper) | disassembly citation in history, **no raw disasm in repo** | `CUSTOM` proposed; not implemented | A vs B: "acid rises ~2× faster" user report; C: none | symptom `OBSERVED` (user); causality `INFERRED`; direct-add mechanism `INFERRED` |
| VPI-031 | MungoDrone defeat sequence, WF-058, owner 0x16AE04 | callsite RVA 0x16C2D4, `$ra` ref `0x092A5FDC`; one-pass in v0.6.0 | static policy | A: 1945 hits / 184 active VBlanks / **6.100 s**; B: 1943 hits / 184 active VBlanks / **3.050 s**; C: not run | strongest quantitative lead; `OBSERVED` single paired capture with video timestamps; same work executed in half the time |
| VPI-032 | Kalidon doors, WF-016 | callsites RVA 0x1461F0/0x146494; `$ra` 0x0927FEF8/0x0928019C; one-pass | static policy | A: 952 hits, 2-VBlank cadence; B: 985 hits, 1-VBlank cadence | `OBSERVED` aggregate across several doors — **not** a single-door cycle; C not run |
| VPI-033 | WF-002 counter-example (self-normalizing) | RVA 0x48978; `$ra` 0x09182680; stays two-pass | static policy | A ≈53.21 hits/s; B ≈55.53 hits/s | `OBSERVED`; supports "not all frame-based logic doubles" |
| VPI-034 | Kalidon pickup generalisation (5 words) | 0x2EC780–0x2EC7A0 | static, `experimental_generalisation_not_validated` | UNKNOWN | see VPI-041 for the value conflict |

Capture-identity contradiction to preserve: three different "A-passage" Kalidon totals appear — **67,905** hits (`L/history/6a86dce7…:4126`, "two captures ≈14 min 12 s"), **69,173** hits (`L/CONTINUITE.md:52`, "13 active callsites"), while the preserved `trace_L03_0001.*` is **19,287** hits and `trace_L03_0003.*` is **2,006**. The A/B per-family numbers (1066/1945/952/2595) come from one identified video timeline and are the only ones I would use as a lead.

### D. Metalis

| ID | Mechanic (module 4) | Words / RVA / callsite | Patch status | A/B/C | Evidence |
|---|---|---|---|---|---|
| VPI-035 | Clank vehicle movement: WF-029 shared helper (`two_pass`, was the failed 05C one-pass test) + integrator 0x2AB54 + table 0x2ECE98 | WF-029 2 sites; 0x2AB54; 0x2ECE98 | policy write applied and rolled back 2026-09-14 | user: 60 FPS "accelerated ×2", vehicle still too fast under full v0.6.0 profile | `wf029-apply/rollback-result.json` = memory apply/rollback `OBSERVED`; failure is `OBSERVED` qualitative; no distance/duration |
| VPI-036 | ClankSaw movement constants (7 words: caps/accel/brake/coast + current velocity) | live addrs 155421592…164313856; RVAs listed in `metal is-experiments.json` (0x2E4CF4… etc.) | `applied-mem`, `verified=true`, user judged movement/rotation correct | A/B/C: none measured | `clanksaw-movement-result.json`, `clanksaw-rotation-result.json`; qualitative only; `metal is` README warns "validation qualitative uniquement" |
| VPI-037 | Enemy/Clank vehicle physics tables (Ram/Electro/Saw) 40 rows | RVAs 0x2E1754…0x2EC7xx (`arena-batch-result.json` 40 changes; `resume-crates-result` 51) | `applied-mem` | UNKNOWN | `OBSERVED` writes/readbacks; gameplay `UNKNOWN` |
| VPI-038 | Vehicle/trap countdowns (EnemyRam ×2, EnemyElectro ×2, ClankSaw ×2, obstacle Saw/Vent, Clank active/recharge integers) | RVAs 0x140000-range + 0x2E3xxx | `applied-mem` | UNKNOWN | same JSONs; some explicitly `experimental_partial` |
| VPI-039 | ObstacleSpinningFloor angular increment | RVA from `metal is-global-audit/README.md` (0x166018 increment, const 0x2E848C); v0.6.3 word 0x2E1F4C (module 4) | static | UNKNOWN | `OBSERVED` statics; note the warning that the 1.0 at 0x16606C is a matrix component |
| VPI-040 | Crate/teleporter timers: 0x13579C & 0x135CF0 (`obj+0x70` -= 1) and shared emitter 0x67060 (`pvar+0x28` += 1/30) | module 4 | after deleting scene script: original corpus; 0x67060 applied for Metalis (`metal is-experiments.json`, `Teleport emitter elapsed seconds`, `experimental_gameplay_qualitative`) | UNKNOWN | `debris-collision…json` records `userValidated` crate respawn + teleport animation (qualitative); warning not to double-patch 0x1359C4/0x135F18 |
| VPI-041 | Debris collision-countdown inconsistency: cave 7 delivers f12=0.5 while `state+0x34` countdown still decrements by 1 | cave 7 word 34; m4 0x27EA0→cave7; 0x27F5C/0x27F68/0x279A0/0x27BD0 | static cave transform + one applied word (0x27E?? cave word, `debris-collision-1789592905266.json`, `change` before 1006911360 → after 1006911232) | UNKNOWN | `OBSERVED` arithmetic inconsistency (m4 README "modèle illustratif"); attribution to a visual defect `UNKNOWN`; m4 README warns the expiring object may be due to low-speed stop/rebound or a separate particle system |
| VPI-042 | Nano/ammo pickup (Metalis experimental): initial 0.1→0.05, accel 0.06→0.015, max 0.3333→0.1667, steering below cap 0.08→0.04083, at cap 0.2→0.10557 | m4 0x2E3544…0x2E3560; timers 0x1340A4/0x1352FC (`-1→-0.5`) | `applied-mem`, verified; user "validates Nano and ammo collection" qualitatively | A/B/C: none | `pickup-collection-1789593231151.json` gives the exact floats; `OBSERVED`; `1 - sqrt(1-alpha)` formula `INFERRED` |
| VPI-043 | Cross-level pickup generalisation (9 modules: 1,2,3,5,6,7,8,9,10; 5 words each = 45) | `generalisation-experiments.json` | static only | **27/45 differ from the Metalis reference**: 9× max speed, 9× steering at cap, 9× steering below cap | recomputed from `audit-v063-pickup.csv` (45 rows, all `static_only_not_gameplay`); e.g. LEVEL_03 max speed 0.08333 vs 0.16667; steering-at-cap 0.05 vs 0.10557 → `REJECTED` as "same correction generalised"; correct cross-level values `UNKNOWN` |
| VPI-044 | Metalis minigames: BotFlinger vehicles, MicrobotThrow/Goal/Teleporter, MicrobotSurvival | classes in `metal is-classes.json`, pools in `minigames-inventory-20260916.json`; VehicleMissile 0x196EA0, DerbyPowerup 0x1332FC | proposed only; explicit "pools are not proof of activity" | UNKNOWN | `OBSERVED` inventory; gameplay `UNKNOWN` |

### E. Weapons, damage, melee

| ID | Mechanic | Versioned data | Patch status | A/B/C | Evidence |
|---|---|---|---|---|---|
| VPI-045 | Weapon constant corpus: 13 weapons × modules (Lacerator, Mootator, Bee Mine Glove, Static Barrier, Sniper Mine, Agents of Doom, RYNO/TELT, Shock Rocket, Concussion Gun, Scorcher, Laser Tracer, Acid Bomb Glove, Suck Cannon) | `patch_ledger.csv` layer 2: 950 historical words; per-module 86 words for modules 1–10,23,24 and 2 for 22 | static | UNKNOWN | `OBSERVED` words; semantics per family `INFERRED`; the separate `supplemental-files/known_weapon_patch_candidates.csv` is a **different earlier dataset** (170 rows, only 4 weapons: RYNO/TELT 72, Shock Rocket 48, Lacerator 34, Sniper Mine 16; 50 rows "validated on LEVEL_01; signature identical") — do not merge the two without a join |
| VPI-046 | Burner/Scorcher continuous damage: `lui a0,1.0→0.5`, `lui a2,-1.0→-0.5`, `ori a0,3→6` | e.g. m3 0x1399B0/0x139C50/0x139DA8; m4/m23 similar | static | A/B/C: none | user "accelerated damage confirmed"; `OBSERVED` symptom; the accumulator/scan-modulo explanation `INFERRED`; `CONTINUITE.md` explicitly says wrapper one-pass does not fix Burner |
| VPI-047 | Laser Tracer: two projectile constants (`15→30`, `6→12`) + cave-hook `sub.s f12,f12,f20` and NOP of `swc1 f12,8(s1)` | m3 0x2E7954/0x2E7958; 0x14AACC/0x14AAD0 | static | UNKNOWN | `OBSERVED`; continuous-damage cadence `UNKNOWN` |
| VPI-048 | Shock Rocket + RYNO/TELT: age/speed/explosion phase/flight lifetime, helix angular steps | 84+72+24+… rows (m3 0x2ED508–0x2EDB40; 0x182270–0x1822A0) | static; the earlier `known_weapon_patch_candidates.csv` has 50 rows "validated on LEVEL_01" signature-identical | UNKNOWN | recoil specifically flagged by user (`OBSERVED` symptom) |
| VPI-049 | Agents of Doom: summon duration 60→120, `-1→-0.5` countdowns, cave add-hook | m3 0x108368…0x10F3D4, 0x2E14B0/0x2E14B4/0x2E1BD0 | static | UNKNOWN | `OBSERVED`; "invocation until expiry" needs a dedicated scene |
| VPI-050 | Deployables: Sniper Mine (`-1→-0.5`, `1.0→0.5`), Bee Mine Glove (1/90→1/180, 0.1→0.05, 0.25→0.125, angles), Static Barrier (120→240, 1/30→1/60) | m3 ranges from layer 2 | static | UNKNOWN | `OBSERVED`; durations/tick counts unmeasured |
| VPI-051 | Utility weapons: Suck Cannon (30→60, 0.15→0.075, cave hooks), Concussion Gun, Acid Bomb Glove (cave hook + NOP store), Mootator (1/30→1/60 ×6, 1/60→1/120, 1/90→1/180, 1/135→1/270) | layer 2 | static | UNKNOWN | `OBSERVED` |
| VPI-052 | Melee: Wrench / TMRobotHeadB contact window and animation-impact alignment | no dedicated patch word in the ledger; only Pokitaru TMRobotHeadB speed (VPI-024) | not patched | UNKNOWN | user report only; `CONTINUITE.md` flags it |
| VPI-053 | Missile recoil (player + enemies): VehicleMissile 0x?→ `disasm-1932e4.txt`, f14 from 0x2EC338, damage via descriptor+0x20, impulse at 0x19348C/0x1934B4, callback +4 at 0x1934E0 | module 4 RVAs 0x1932E4, 0x196EA0, 0x2EC31C/0x2EC338 | none applied | user: recoil too strong on player *and* enemies; the metal is README warns an unchanged impulse + unchanged decay gives the same displacement sum in half the real time | `OBSERVED` symptom + disassembly; distance/duration unmeasured |
| VPI-054 | Ammo consumption and weapon cooldown | no located words; `custom` families WF-006…012 | not patched | UNKNOWN | explicit coverage gap; energy-vehicle cooldown "seems ×2" unmetre |

### F. Menus, HUD, camera, input

| ID | Mechanic | Coordinates | Patch status | Evidence |
|---|---|---|---|---|
| VPI-055 | Pause-menu cursor blink: `HUDFXCYCLE_Update` adds/subtracts a step per call with no delta time; two states `0x2CF7BC`/`0x2CF7E4`, float candidates `0x2CF7D0`/`0x2CF7D4`/`0x2CF7F8`/`0x2CF7FC` (0.2→0.1, 0.05→0.025) | module 4 RVAs; HUDFXCYCLE_Update 0xA6A34 | **unapplied**; early float extractor output is `SUPERSEDED` | `OBSERVED` static; "cycles twice as fast at doubled call rate" `INFERRED` |
| VPI-056 | Menu/HUD persistence and stale inactive objects (screen-17 object still in RAM while screen 3 active) | `dev061-menu-readonly-1789598570147.json`; `dev061-integration…json` active menu screen 3, 7 routes | observed only | `OBSERVED`; do not interpret a pointer as ownership |
| VPI-057 | Camera framing 9.0/1.90, zero horizontal offset, vanilla FOV | no RVA recorded in the examined files | proposed/optional feature | `OBSERVED` reported visual judgement on Pokitaru only; parity relevance `UNKNOWN`; out of Priority-0 scope unless it changes timing |
| VPI-058 | Input / second stick prototype (`SceCtrlData` Rx/Ry), `AnalogIsCircular=True` | `L/snapshot-original/RACSM_Controls/` | emulator config, not game code | `OBSERVED` source; gameplay effect `UNKNOWN`; not a 60 FPS parity item |

### G. Special modes and transitions

| ID | Mechanic | Evidence | Status |
|---|---|---|---|
| VPI-059 | Giant Clank modules 15/21: 15 static writes incl. VBlank/δ/substeps/camera + breakable + particle words; crash 2 s after arming (`0x2cc9bf` in PPSSPP), same crash with the previous version, same crash with modules excluded, cause `UNKNOWN` | `L/sessions/plantage-clank-geant-20260917-2134/{RAPPORT.md,status.log}`; `plantage` status log lines 51–72 | `OBSERVED` crash sequence; `REJECTED` LEVEL_15-writes-necessary; no clean no-plugin replay found |
| VPI-060 | 60→30 mode request/applied state machine (`g_rcsm_requested_fps`, `g_rcsm_applied_fps`, `g_rcsm_fps_pending`; "deferred until verified module reload"; actual in-round conversion not implemented) | `L/development-v0.6.1/sources/profiler/src/psp_plugin_runtime.c:37-39,555,1822-1823`; status logs `frame_rate applied=30 requested=30 game_writes=0` | `OBSERVED` plugin state; displayed cadence and 30 FPS parity `UNKNOWN` |
| VPI-061 | Airboard modules 22/23: 11/24 callsites, WF-024 one-pass; detect-only trace has 0 installed / 0 active / 0 hits | `trace-validation/trace_L22_0002.*`; `module_fingerprints` anchor `0x45010012` | `OBSERVED` detection only; no Airboard gameplay data |
| VPI-062 | Loading screens natively ≈20 FPS; must not receive the 60 FPS correction blindly | user observation recorded in the crash report; historical discussion `6a85799c` | `OBSERVED` user report; native behaviour, not a regression; no measurement |
| VPI-063 | Level transitions / hook lifetime: 33 hooks temporarily disappeared ~20 s before the B recording and were reinstalled; JIT marker `0x68xxxxxx` caused a false module-change diagnosis historically | `L/history/6a86dce7…`; `L/CONTINUITE.md` | `OBSERVED`; transition timing of the plugin itself `UNKNOWN` |

### H. Negative and auxiliary

| ID | Item | Status |
|---|---|---|
| VPI-064 | Save-space / skill-bit exclusions: whole null span `0x3E4EC–0x536DF` is **not** free (`+0x534E0` writer), skill bits 25–47 are not a contiguous free interval | `REJECTED` / `SUPERSEDED`; not a 60 FPS parity item but must survive |
| VPI-065 | 38,219 static arithmetic candidates (37,341 outside wrapper families) and 85,452 heuristic function candidates | `STATIC_CANDIDATE_NOT_APPLIED_NOT_LIVE_VALIDATED` by the generator itself; not patches, not mechanics; must not be counted as fixes |
| VPI-066 | Metalis static transfer search: 20 new candidates, 176 `absent_or_not_unique; no transfer` rows | `OBSERVED` static; gameplay effect `UNKNOWN`; a signature match does not establish cross-level behaviour |

**Distinct candidate parity items: 66.** They are mutually distinct, testable mechanics; cross-level copies of the *same* mechanic are one item (e.g. VPI-002 covers 15 modules), while *same-family-but-different-mechanic* cases are separate (VPI-029 platform vs VPI-030 acid; VPI-031 Mungo vs VPI-032 doors).

---

## 4. Candidate timing mechanisms, with discriminating predictions

**M1 — Outer-cadence change with per-module constant compensation (BASE+SOCLE).** Removing one `sceDisplayWaitVblankStart` doubles the simulation cadence; the delta constant, player substeps, local physics accumulation, camera step and Titanium constants are then halved. Prediction: any state advanced inside the wrapper or by BASE/SOCLE constants keeps its real-time rate; any state advanced by a bare per-update increment outside those words runs 2× fast. Evidence: `OBSERVED` words/cadence; the historical 60 Hz/30 Hz histogram is `TESTED` in the instrumentation scope only.

**M2 — Two-pass wrapper as an implicit ×2 smoothing.** A callsite entering the vanilla wrapper performs the helper twice; at 30 Hz that is intentional smoothing; at 60 Hz it performs twice as much work per second → one-pass restores the original rate. Evidence for: WF-058 (184 updates in both, 2× real-time compression), WF-044 (1 hit/VBlank at 60 vs 2-VBlank spacing at 30). Evidence against a blanket rule: WF-002 keeps ≈53→55 hits/s while going from 2 hits per active VBlank to 1 — a self-normalizing counter. `OBSERVED`; the mechanism is `INFERRED`.

**M3 — Bare per-update increments outside the wrapper.** Kalidon acid (`fluid += fluidSpeed` before the wrapper), the Burner/Laser accumulators, and per-frame countdowns cannot be fixed by one-pass routing; they need a `CUSTOM` half-step or a delta-time conversion. Prediction: with WF-044 in one-pass, platform motion changes while the acid slope stays ~2×. `INFERRED` (disassembly citations exist only in history text for Kalidon; the module-4 counterpart has preserved disasm files).

**M4 — Register-substituted half-step with a plugin-injected 0.5 constant.** Breakables/debris: cave 7 provides f28=0.5 and the patched words switch operands f22→f28; vanilla gravity is NOP'd and re-added at half step; age/duration/ground progress become 0.5 per update. Prediction: the PRX diff shows operand swaps, not 0.5 constants; the plugin-owned cave must be present for the behaviour; and systems consuming a *different* countdown (state+0x34) can desynchronise by 2× — which is exactly the m4 inconsistency in VPI-041. `OBSERVED` words/decode; gameplay effect `UNKNOWN`.

**M5 — Per-frame float countdown/increment tables (LUI halves).** The numerous `0x3Cxx3F80`→`0x3Cxx3F00` and `…BF80`→`…BF00` words are halves of constants loaded into FPRs. Some are genuine timers/steps; others (e.g. the "shrapnel step", the 1.0 at 0x16606C) were explicitly labelled non-timer/matrix values. Prediction: only changes at addresses whose disassembly shows an increment/decrement of a state field should track real-time behaviour. `OBSERVED` words; per-site semantics `INFERRED`/`UNKNOWN`.

**M6 — Weapon-specific integer modulus / emission divisor.** Scorcher `ori a0,3→6`, Blaster `lui a2,30→60`, Bee Mine `interval 2→4`, fire `2/3→1/3`. These alter how many updates pass between hits/emissions, i.e. an indirect rate change rather than a delta-time change. Prediction: hit counts per unit time scale exactly with the integer ratio, and damage-per-hit stays constant unless the damage accumulator is also patched. `INFERRED`.

**M7 — Self-normalizing / non-frame-based logic.** WF-002 and possibly the 20 FPS loading screens. Prediction: no `ONE_PASS` change should be applied; forcing one could halve an already-correct effect. `OBSERVED` for WF-002 hit rates; the loading screen is a user observation.

---

## 5. Cross-level and cross-system relationships

1. **Shared root cause, several symptoms:** the BASE/SOCLE layer is byte-identical in shape across 15 modules (only RVAs and the VBlank JAL target differ). Any V2 conclusion about "Pokitaru timing" must state whether it depends on BASE/SOCLE or on a module-specific word.
2. **Shared wrapper family, several levels:** WF-016 (HutDoor in module 1) reappears as Kalidon doors (module 3) and in modules 1,3,6,7,9,10. A one-pass verdict for WF-016 is global by construction; a *gameplay* result in one module does not validate the doors of another.
3. **Shared mechanism, different implementations:** VPI-003 (player substeps), VPI-004 (local physics), VPI-007 (debris integrator) and VPI-041 (vehicle/arena constants) are four different code patterns that all implement "halve the effective step". Treating them as the same fix would be an inference, not a duplication.
4. **Cross-level transfer that is not a copy:** `metalis_transfers.csv` derives 20 candidates by unique 49-word windows from the Metalis source sites (e.g. Teleport emitter 1/30→1/60 into modules 1,2,3,7,8,9,10,24) and records 176 unmatched combinations. A signature match is not a behaviour proof; the 0x67060 transfer also warns that the helper is shared more widely than crates.
5. **Weapon-family duplication traps:** `known_weapon_patch_candidates.csv` (4 weapons, 170 rows) and the ledger's `WEAPONS` layer (13 weapons, 950 rows) overlap in intent but not in row identity. Neither has been joined to the other; `family_patch_relations.csv` is empty.
6. **Policy vs archive divergence:** the 3 WF-014 Pokitaru callsites are one-pass in the V1 local-JAL archive and two-pass in v0.6.0. This must be an explicit decision in V2, not an inheritance.
7. **Dependency chain for any A/B/C test:** module identity + delta + vanilla-word preflight → base layer state → wrapper route state → observable. Any of these can invalidate a gameplay comparison if unrecorded (the Kalidon B packet documented its exact delta for this reason).

---

## 6. Competing interpretations

| # | Interpretation A | Interpretation B | Which evidence would separate them |
|---|---|---|---|
| 1 | The 60 FPS conversion changes the outer loop only; all doubling symptoms are per-update logic that must be halved case by case | The wrapper's two-pass is the dominant cause; one-pass families fix most symptoms | Apply BASE+SOCLE with the wrapper left vanilla to a scene with a covered and an uncovered mechanism; compare real-time rates |
| 2 | WF-058's 6.10→3.05 s is an internal counter | It is an external counter driving an animation; one-pass will not fix it | Same scene with WF-058 routed one-pass; if the duration stays ≈3.05 s, an external/`CUSTOM` fix is required |
| 3 | The Kalidon acid 2× is `fluid += fluidSpeed` per update | The acid is a separate water/particle system, only visually similar | One-pass WF-044 alone; and disassembly-level tracing of the fluid field |
| 4 | Metalis pickups need the quarter-step / `1-sqrt` formula | Straight halving is correct across levels | A/B/C per level with a scripted pickup at a fixed distance; both value sets already differ on 27/45 words |
| 5 | Debris disappearing too fast is the cave f12=0.5 vs `+0x34` decrement-1 inconsistency | It is a low-speed stop / rebound / separate particle-system effect | Instrument the `+0x34` field and the disappearance event in one controlled fall |
| 6 | The Giant Clank crash is caused by the module-15/21 patch profile | It is independent of the plugin (emulator/backend/driver) | Clean no-plugin replay through the same route, with dated config and module identity |
| 7 | The v0.2.1 global corpus is a superset of the Pokitaru V1 fixes | It is a different, narrower corpus that dropped the 14 object words | A join of the archive INI against the manifest (done here: the 14 words are absent) |

---

## 7. Uncertainty and missing evidence

1. **No original 30 FPS gameplay capture is present in the repository.** The Kalidon A/B video and the profiler stage 02/03 raw traces are referenced by hash but not found in the examined tree (`P45/profiler/IN_SITU_ANALYSIS_*.json` records input hashes; the files themselves are absent). `UNKNOWN`.
2. **Three incompatible Kalidon "A" totals** (67,905 / 69,173 / 19,287), plus 2,006 for `0003`. Cumulative B exports (0004/0005 both 87,570) must not be summed. `UNKNOWN`.
3. **The `LEVEL_02.PRX` hash discrepancy** (ISO vs reference) is unresolved; neither copy is proven vanilla. `UNKNOWN`.
4. **Metalis v0.6.3 runtime constants**: the generated cave-7 template and the runtime guard disagree; v0.6.3 cannot arm that Metalis cave branch. v0.6.4 fixes it only in a host harness. In-game Metalis behaviour for v0.6.3/v0.6.4 is `UNKNOWN`.
5. **Metalis transfer gaps**: 176 absent/non-unique combinations; 20 positive signatures with no in-game test.
6. **Version skew in the coverage table**: LEVEL_24 static writes 101 (v0.6.0 `COVERAGE.csv`) vs 108 (`patch_audit_summary.json`).
7. **Missing RVAs**: Pokitaru object words have runtime addresses (base 0x09139D00) but no versioned RVA/file-offset table entry; the archive tables must be recomputed to RVAs before any reuse.
8. **Damage/ammo/cooldown/melee/lifetime** have no measured baseline and, in the case of melee/ammo, no located patch word at all.
9. **No gameplay-validated item exists.** All historical "validation" for gameplay is user judgement or author labels; all JSON "verified" fields are memory write/readback or host-harness results.
10. **30 FPS mode identity**: the plugin state machine (`applied=30`) is a request/acknowledgement, not a measured screen cadence; a genuine 30 FPS parity baseline still has to be established.

---

## 8. Recommended deterministic tests (ranked, with discriminating outcome)

**T1 (highest value) — Kalidon MungoDrone A/B/C.** Same save duplicated, same route, record the full defeat sequence. Arms: A = vanilla 30; B = BASE+SOCLE, wrapper two-pass; C = B + WF-058 one-pass (module 3 only). Measure real time between first and last WF-058 hit, the active-VBlank count and gap histogram, and the hit count. Predictions: if C ≈ 6.10 s and hits/VBlanks ≈ A → wrapper one-pass is the fix; if C ≈ 3.05 s → the counter is outside the wrapper and a `CUSTOM` half-step is required. This is the only historical lead with a clean same-work comparison.

**T2 — Base-vs-local discrimination on an untouched module.** Choose LEVEL_06 or LEVEL_09 (only WF-016 one-pass, no weapon pack relevant) and measure one purely mechanical, scriptable observable (a moving object's full travel time, an enemy attack cadence, or a trap cycle) with A vs B, then with the module's local words added. Expected: items that match at B are BASE-covered; items that double identify a per-update mechanism and the corresponding word.

**T3 — Kalidon platform + acid separation.** With A/B/C as in T1 plus WF-044 one-pass alone, measure platform travel duration *and* acid height over a fixed time. Discriminates M2 vs M3 for VPI-029/030 without touching the Burner.

**T4 — Pokitaru object-word A/B/C.** Because the 14 words are absent from the ledger, run a first controlled test on 2–3 objects (Crab, TrainingBot hitbox, final elevator) using the archive INI as C. Measure distance/time and hit windows, not "feels right". This both validates the archive and decides whether to migrate those words.

**T5 — Debris integrator consistency.** In a controlled fall, instrument the `state+0x34` countdown and the disappearance event at 30, 60 two-pass and 60 cave-0.5. Distinguishes M4-internal inconsistency from a low-speed/particle effect.

**T6 — Cross-level pickup disagreement.** For one fixed scripted pickup trajectory, compare A vs the Metalis experimental values vs the generalisation values (LEVEL_03 is the clearest case: max speed 0.1667 vs 0.0833; steering-at-cap 0.10557 vs 0.05). This is a deterministic numeric fork; one of the two value sets must lose.

**T7 — Pause blink period.** Sample the two pause cursor states' `value` at +8 and their step words over a fixed wall-clock window at 30 and 60, before applying the four candidate floats. Distinguishes "called twice per frame" from "step too large" and closes VPI-055.

**T8 — Giant Clank clean baseline.** Fully disabled plugin, dated config, same route, same save; if the crash persists, the plugin is exonerated at least for that configuration. Recorded module identity/hash is mandatory because modules 15/21 are declared equivalents.

Each test must record: build hash, module index + verified hash, load base/delta, patch-layer state (static/applied/disabled), route state per callsite, save identity, input method, repetitions (≥3), and raw capture. A trace-parser PASS or a memory readback is not a result.

---

## 9. Counts and ID reconciliation

**Items.** 66 distinct candidate parity items (VPI-001…VPI-066). Breakdown: 15 global/base, 12 Pokitaru objects + 1 strategy, 6 Kalidon, 10 Metalis, 10 weapons/damage, 4 menu/HUD/camera/input, 6 special modes/transitions, 2 negative/auxiliary, 1 static-inventory caution.

**Quantitative baselines.**
- Items with a *reported* quantitative lead in at least one arm: **9** (VPI-001, 002/006 counts of words, 029, 030/031, 032, 033, 035/036 counts, 042, 043).
- Items with a *usable reproducible 30 FPS baseline* (raw capture present in the repository + documented method + ≥2 repetitions): **0**.
- Items with a single documented A window whose method and timestamps are recorded but whose raw video is absent: **3** (Kalidon WF-044, WF-058, WF-016).
- Rule used: a derived report, a trace-parser PASS, a memory readback, or a user "feels right" never counts as a reproducible baseline.

**Historical candidate-fix counts (kept separate).**
- Static/verified words: 1470, of which 99 are `metalis-experiments` + `generalisation-experiments` extras; 1371 are the historical corpus; 512 plugin cave words (8×64); 493 callsites with 119 configured one-pass / 374 two-pass / 168 custom-fallback.
- Excluded by design: 99 `cave_return` words, 15 legacy global-wrapper words.
- Applied in memory (historical): 111 manual ledger write events (54 with module RVAs; 91 "lost, reintegrated into the plugin", 16 "lost at PPSSPP close", 2 rollbacks, 2 same-day cancellations); v0.6.1 read-only integration 167 sites / 36 redirects; v0.6.0 Metalis armed session 106 static writes / 36 callsites; Kalidon B 8 CWCheat writes with 33 hooks installed.
- **Gameplay-validated corrections: 0.**

**Duplicate / ambiguous items to reconcile.**
- WF-013 vs WF-014 vs WF-021 (all transversal actor navigation, overlapping descriptors) — do not merge into one item; each has distinct callsites and one WF-014 is the V1/V0.6 divergence.
- WF-028 vs WF-029 (Clank torsos vs shared vehicle helper) — distinct; WF-029 is the rollback case, WF-028 is the one-pass case.
- WF-016 appears as Pokitaru HutDoor (VPI-019) and Kalidon doors (VPI-032) — same family, different gameplay tests; link, do not merge test results.
- `0x67060` appears as the shared teleport emitter (VPI-040) and as 20 transfer candidates (VPI-066) — same mechanism, must be counted once as a mechanism.
- `known_weapon_patch_candidates.csv` vs the ledger's WEAPONS layer — two datasets, no join yet.
- Pokitaru V1 22-write common patch vs the ledger's 8 BASE/SOCLE words — same source, 14 words dropped; VPI-016…VPI-027 vs VPI-002…VPI-006.
- `AUDIT_HISTORIQUE.md` 67,905 vs `CONTINUITE.md` 69,173 vs `trace_L03_0001` 19,287 — three capture identities, unresolved.

---

## 10. Explicit coverage gaps (no usable evidence found)

| Domain | Status |
|---|---|
| Melee (Wrench, contact window, animation-impact) | no located patch word; user report only |
| Ammo consumption per shot/weapon | no located word; not in any ledger |
| Weapon cooldown (energy vehicle, rocket, turret) | user "seems ×2"; no measurement |
| Direct damage per hit and damage-over-time for Burner/Laser/acid | only accumulator words; no damage measurement |
| Recoil distance/duration (player and enemies) | symptom + disassembly only |
| Enemy AI/attack cadence (except Kalidon MungoDrone and the derived Ryllus family hits) | no controlled measurement |
| Jumping/falling physics (player) | no isolated measurement; BASE cover inferred |
| Collision (player/enemy) | no isolated test; debris collision-countdown inconsistency only |
| Moving platforms outside Kalidon Lvl3Platform | no test |
| Pickups: standard bolt/Nanotech/ammo trajectories at 30 FPS | no A baseline |
| Bolts/breakables reward counts and uniqueness | no test |
| HUD timing (other than pause blink) | no evidence |
| Menus other than pause blink/persistence | no evidence |
| Vehicles/minigames (BotFlinger, Survival, Derby) | inventories only, no timing |
| Giant Clank gameplay parity | crash blocks; modules excluded; no data |
| Airboard gameplay | detect-only trace, zero hits |
| Transitions/loading parity | user observation (≈20 FPS native), no measurement |
| Ryllus-specific objects (expandable bridge, column, boulder, doors) | static family hits only, no gameplay test |

---

## 11. Source index (primary files actually inspected)

- Framing: `AGENTS.md`, `PROJECT_GOALS.md`, `MIGRATION.md`, `docs/methodology/EVIDENCE_LEVELS.md`, `research/inbox/legacy-v1-inventory.md`, `research/inbox/legacy-v1-inventory-review.md`, `tools/agents/MISSION_FAILSAFE.md`.
- Corpus/patch: `L/sources-v0.6.0/sources/{provenance/experience_v021_manifest.json,BINARY_AUDIT.json,COVERAGE.csv,HOST_VALIDATION.json,POLICY_RESOLUTION.json,PSP_BUILD_VALIDATION.json}`, `L/sources-v0.6.0/sources/profiler/{module_fingerprints.csv,tools/generate_full_patch.py}` (LAYERS map), `L/research-2026-09-18-global/{patch_ledger.csv,wrapper_ledger.csv,prx_hashes.csv,patch_audit_summary.json,injected_caves.csv,metalis_transfers.csv,metalis_transfer_gaps.csv,audit-v063-pickup.csv,audit_patch_sites.py,iso_verification.json,static-inventory/counts.json}`.
- Wrappers: `P45/tables/{wrapper_callsites,wrapper_families,wrapper_anatomy,validation,family_patch_relations}.csv`, `P45/POKITARU_STAGE02_RESULT.md`, `P45/RYLLUS_STAGE03_RESULT.md`, `P45/profiler/IN_SITU_ANALYSIS_v0.4.3_STAGE02.json`, `IN_SITU_ANALYSIS_v0.4.4_STAGE03.json`, `P50/DISPATCHER_SPEC.md`, `P50/METALIS_TEST_PROTOCOL.md`.
- Archives: `L/archives/Pokitaru_60FPS_V1_two-builds.zip` (README + 2 INIs), `L/archives/Pokitaru_60FPS_profils_tests_prealpha_2026-08-06.zip` (patch_manifest, MATRICE_TESTS, VALIDATION_TECHNIQUE, profiles 04 & 07), `L/archives/RCSM_Kalidon_Passage_B_60FPS_Titanium_v0.1_UCES00420.zip` (PATCH_MAP, README, INI), `L/archives-manifest.csv` (archive SHA-256s).
- Runtime: `L/connection/{dev061-integration-1789598570306.json,wf029-before,apply,rollback,clanksaw-movement-plan/result,clanksaw-rotation-result,pickup-collection-1789593231151,debris-collision-1789592905266,arena-batch-result,resume-crates-result-1789592738689}.json`, `L/inventaire-2026-09-17/inventaire-manuelles.csv`, `L/trace-validation/trace_L03_000{1,3,4,5}.result.txt` + `.csv`, `trace_L01_0001`, `trace_L04_0002`, `trace_L22_0002`, `L/sessions/2026-09-14-metalis-{clank-detect,global-x2}/OBSERVATION.md`, `L/sessions/plantage-clank-geant-20260917-2134/{RAPPORT.md,status.log}`.
- Analyses: `L/research-2026-09-16/metalis/README.md`, `combat-minigames-followup.md`, `L/metalis-global-audit/README.md`, `L/research-2026-09-16/menus/RAPPORT.md`, `render/README.md`, `saves/README.md`, `L/supplemental-files/known_weapon_patch_candidates.csv`, `L/research-2026-09-18-global/weapons-gadgets/weapon-classes.json`, `L/development-v0.6.1/VALIDATION_SUMMARY.json`, `L/development-v0.6.3-generalisation/{VALIDATION_PRINCIALE_V063.json,sources/profiler/{generated/{full_patch.generated.c,metalis-experiments.json,generalisation-experiments.json},src/psp_plugin_runtime.c}}`, `L/development-v0.6.4-no-menu/METALIS_CAVE_GUARD_VALIDATION.json`, `L/CONTINUITE.md`, `L/OVERCOMPENSATED_VUE_ENSEMBLE.md`, `L/START_HERE.md`, `L/history/6a86dce7-2998-83eb-bf81-229c2835c35d.md`.

**Nothing was written, patched, moved, or deleted.** The only deterministic recomputations I performed were counts/joins/word comparisons on those files; every resulting claim is labelled at claim level with its scope.