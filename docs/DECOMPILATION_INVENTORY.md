# Decompilation inventory (snapshot 2026-11-09)

Scope: every decompilation, Ghidra project, annotation pass, scanner and static
slice produced by Overcompensated V2 for Ratchet & Clank: Size Matters (UCES00420)
up to research HEAD `addec4d`. It lists **what exists, how it was produced, how much
it covers, and what it established**. It deliberately contains **no decompiled
code, disassembly, string dumps or per-function address tables**: those are
game-derived and stay local (`research/v2/decomp-candidates/_local/`, ignored by
Git; see [PUBLICATION_POLICY.md](PUBLICATION_POLICY.md)). Counts come from local
indexes, saved recipes and reports; where a number was not re-measured in this
session it is attributed to its source report.

Evidence labels follow [methodology/EVIDENCE_LEVELS.md](methodology/EVIDENCE_LEVELS.md).
Decompilation completion is **not** semantic understanding: a successful decompile
does not validate a prototype, a name or a gameplay claim.

Companion documents: [DECOMPILATION_FINDINGS.md](DECOMPILATION_FINDINGS.md) (engine
findings), [DECOMP_STATUS_2026-10-01.md](DECOMP_STATUS_2026-10-01.md),
[DECOMP_PROGRESS_2026-10-03.md](DECOMP_PROGRESS_2026-10-03.md),
[FIX_CATALOGUE_2026-10-01.md](FIX_CATALOGUE_2026-10-01.md).

## 1. Summary table

| Target | Tool / project (local) | Functions | Status | Main use |
| --- | --- | ---: | --- | --- |
| LEVEL_01 (Pokitaru) full | Ghidra 12.0.4 headless, `PokitaruMass20261001` | 5,045 decompiled (5,046 in the saved database) | Complete decompile; names partial | Class/clock/damage/weapon research |
| FRONTEND full | `FrontendStatic20261001` | 893 indexed | Complete decompile; names minimal | Menus, options, save, loading |
| LEVEL_10 (Quodrona) | `QuodronaStatic20261003` | about 148 targeted slice entries | Targeted | Otto/Flamethrower, Laser gate, menus, helpers |
| LEVEL_16 / 20 / 24 | `ClockFamily20261003` | a few targeted entries | Targeted | Dynamic-clock family, MiniTurret |
| LEVEL_04 / 15 | clean PRX read-only slice export | 5 + 6 | Targeted, no saved project | Damage atlas (Derby, Giant Clank) |
| EBOOT animation | `Anim` project | one export | Targeted | Loading-screen animation clocks |
| LEVEL_01 timing pilot | `PokitaruTiming20260930` / `r2` | 10 then 15 | Pilot, superseded by mass | Method proof, Crab navigation |
| 19 other level modules | no decompiler; masked byte matching | 5,045 reference functions mapped | Matching only | Porting fixes, finding unique code |

## 2. Method, tools and guardrails

- **Disassembler/decompiler:** Ghidra 12.0.4 with the Allegrex extension, headless, Java 26.0.1, run on a *copy* of the owner's source project. The source project is never the annotation target.
- **Read-only rules:** source processing uses `-readOnly -noanalysis`; annotation is saved only to the local copy; each run records invocation JSON, logs, method hashes and an explicit completion marker (headless Ghidra can return exit code 0 after a script error). Slice exporters check the expected source SHA-256, Allegrex LE32, image base 0, aligned entries inside `.text`, and compare hashes of every initialized memory block before and after.
- **Project-authored Ghidra scripts** (`research/scripts/ghidra/`, 12 Java files and PowerShell runners): `MassDecompile`, `DecompileAll`, `AnnotateNames`, `AnnotateTimingPilot`, `ApplyAnnotations`, `ReviewFunctionNames`, `ExportDamageSlice`, `FindImmediates`, `FindClockDataReferences`, `TraceTimingSlice`, `CopyTimingProgram`, `InspectTimingProject`; runners `Invoke-TimingPilot.ps1`, `Invoke-MenusSlice.ps1`, `Verify-TimingPilot.ps1`.
- **Recipes:** 73 JSON slice/annotation recipes in `research/scripts/ghidra/recipes/` (about 1,200 slice entries in total; about 700 distinct LEVEL_01 functions across the Pokitaru groups). Recipes carry the entry evidence statement for each function, and are the reproducible record of *why* a function was opened.
- **Scanners and builders** (`research/scripts/`, about 108 Python/Node/PowerShell tools): class-table extraction, call contexts, fixed-step, frame-timer, 1/30 literal, x30 conversion, age, phase, clock, spring and particle-pool scanners; xref finders; module bytematch; native-frame-rate census; damage atlas, weapon dossier, plugin-inventory builders. Each dataset carries its method hash and is regenerated, never hand-edited.
- **Naming conventions:** `P_` prefix for project-assigned names (role INFERRED unless stated), `probable_*` aliases and namespace `RAC_Timing_Static` for descriptor bindings, original `FUN_*` name preserved in the plate note of every renamed function.

## 3. LEVEL_01 mass decompilation (2026-10-01)

| Item | Value |
| --- | --- |
| Source | Original LEVEL_01 module (relocation-applied: 54,806 relocations, image base 0) |
| Decompiled | 5,045 of 5,045 indexed functions (C + instruction export + metadata per function) |
| Saved database | 5,046 functions, 456,516 instructions, 52 initialized blocks (hashes recorded) |
| Local output size | about 396 MB (8,348 C files, 1,817 JSON files incl. annotated exports) |
| Coverage of the code image | Function extents cover every byte of the first segment up to the end of code; the tail is INFERRED non-code (rodata/data) |
| Preservation checks | Original function count, instruction count, block hashes and all pre-existing comments unchanged by the later naming passes (TESTED offline) |
| Known limits | Calling conventions and float/register-passed arguments are often absent from decompiler signatures; function bodies need source review |

### 3.1 Names assigned

| Pass | Date | Names | Notes |
| --- | --- | ---: | --- |
| Class registration table | 2026-09-30/10-01 | 496 automatic | From the 150-class registration table; slot 2 = pump-1 update; 150/150 agree with the earlier atlas |
| Hand annotations | 2026-10-01 | 133 (158 function entries, 226 address entries in the dataset) | `level01-annotations.json`, status TENTATIVE_NAMES_STATIC_FINDINGS |
| Reviewed names, pass 1 | 2026-10-03 | 164 | equipment (16), damage/health (8), weapon rank (5), segmented-ray helpers (8), camera/navigation/HUD (5), particle core (3), particle animators (43), particle setup (47), optional descriptor bindings (29) |
| Reviewed names, pass 2 | 2026-10-03 | 36 | byte/string operations, the LCG random generator, sine/cosine wrappers and kernels, matrix/volume operations, debug/localization utilities, Moby create/destroy, graphics state toggles, formatter wrappers |
| Shared helper naming (GPT) | 2026-10-03 | 19 | audio, UI rectangle and animation helpers; animation boundary checks consume a latch |
| Totals after passes | | | automatic `FUN_*` 4,509 to 4,309; other primary names 537 to 737 |

Reading: about 85% of LEVEL_01 functions still carry automatic names. Names are
semantic hypotheses, not retail symbols. The 29 `P_Descriptor_*_Extra*` names only
express verified class-pointer membership; optional slot semantics are UNKNOWN.
Next naming targets were the highest-fan-out shared helpers.

### 3.2 Datasets derived from the decompilation (`research/v2/decomp-summary/`)

| Dataset | Content | Entries |
| --- | --- | ---: |
| class updates / verdicts | per-class update callback and static verdict | 150 / 150 classes |
| call contexts | calling context per function (substep loop, pump, particle, unknown) | 5,045 functions |
| fixed-step candidates | per-call constant steps by class | 102 classes |
| domain-2 backlog | classes still needing a fixed-step review | 53 classes |
| frame-time constants / k30 audit | literal 1/30 sites and their context | 108 sites |
| frames30 sites | seconds x 30 conversions | 17 |
| phase steps | per-call fade/countdown constants | 33 (24 exclusive after review) |
| clock sites | users of the global frame counter | 21 groups |
| age70 sites | `+0x70 += 1.0` entity-age sites | 7 (4 reviewed) |
| spring parameters | {k, d} structs of the engine spring | 28 |
| particle pools | animator / pool registrations | 49 |
| displacement integrators | movers adding a per-call vector | 6 |
| observed indirect edges | live-observed callback edges | dataset |
| timer-patch spec | generated timer rewrite spec (Crab batch REJECTED) | dataset |

## 4. FRONTEND decompilation (2026-10-01)

893 functions indexed, 962 C files, 156 JSON files, about 24 MB local. Used for the
menus/options/save study: native list and text primitives, screen routing and
setting storage, the post-GE and pre-presentation overlay boundary, the Utility
imports (on-screen keyboard shutdown/update/status, system parameter integer; not
a message dialog), loading-screen states. 61 menu-related slice entries are
recorded in the menus recipes. Names are mostly automatic.

## 5. Quodrona (LEVEL_10) project (2026-10-03)

About 148 distinct targeted entries (158 C files, 750 local files, 51 MB). Topics:
Otto animation/state exits and a separate logical state, Flamethrower release and
fireball rows, deferred damage, LaserTracer gate (Pokitaru versus Quodrona
contracts), Agents bomb chain, menus (a mirror of the Pokitaru menu slices), effect
consumers, and a named-slice annotation pass (repeated on a fresh reopen with zero
changes). Identity of the module is bound by `level10-static-identity.json`.

## 6. Other targeted projects and exports

- **LEVEL_16 / LEVEL_20 / LEVEL_24 clock family:** imports and four small slices (the clock writers and consumers, MiniTurret in 24) to test whether LEVEL_16..20 ("dynamic clock family") share the one-pass player loop and Laser gate signature: they do not (identity JSON per module).
- **LEVEL_04 and LEVEL_15:** three read-only slice exports (3 + 5 + 6 functions) for Derby torsos and the Giant Clank ship controller, produced by `ExportDamageSlice.java` without a saved project; further LEVEL_04/15/16 decompilation was recorded as a precise blocker (no saved project).
- **EBOOT animation project:** a single bounded export used for the loading-screen particle and ribbon clocks (inference: Inside Clank loading screen still 3x with the base patch).
- **Timing pilot (2026-09-30):** first bounded Ghidra copy; ten functions (seven descriptor-bound Crab functions, a state handler and two helpers), then 15 with `nav-crab`. The first run mistakenly treated two guarded JAL callsites as functions; its outputs are kept as SUPERSEDED evidence. It proved the guarded-copy method later scaled to the mass decompile.

## 7. Cross-module matching (no decompiler)

`match-module-functions.py` compares the 5,045 LEVEL_01 function extents against
the 19 other level modules using each module's own PSP relocation table
(`R_MIPS_26` keeps the opcode; HI16/LO16 keep the upper half). Classes: EXACT, MULTI,
VARIANT (at least 50% of 4-word shingles), ABSENT. Validation: a LaserTracer match
was confirmed independently; callee consistency held in 7,927 to 16,379 checks per
module with 0 to 4 disagreements.

| Module group | Share of LEVEL_01 function words that match exactly |
| --- | --- |
| LEVEL_02 to 10 (campaign) | 86 to 90% |
| LEVEL_23, 24 | 82 to 83% |
| LEVEL_22 | 62% |
| LEVEL_16 to 19 (multiplayer) | 56 to 58% |
| LEVEL_15 / 21 (Giant Clank) | 52% (identical to each other in this test) |
| LEVEL_20 (lobby) | 42% |

3,014 LEVEL_01 functions are exact in all 19 modules (195,268 words); 142 exist only
in LEVEL_01. LEVEL_01 has 4,287 distinct masked bodies and 131 duplicate groups
(889 functions). Companion: a port census of fix sites across all modules (FG-v4
sites and the weapon-delta slot bind in LEVEL_01..10, 23, 24; LEVEL_02 already runs
one player pass; BlasterShot, RynoRocket and age sites bind in all normal-family
modules).

Module content map: 21 files (FRONTEND plus 20 LEVEL modules; modules 11-14 absent
from the supplied set) bound to content through identifier strings; original player
loop limit is 2 in 15 modules and 1 in LEVEL_16..20. Moby class inventory: 324
MOBYS source units found through assert paths, with EnemyController present in all
10 campaign modules.

## 8. Static research slices by theme (Ghidra recipes)

| Theme | Recipes | Distinct entries | Key findings (all static; no parity claim) |
| --- | ---: | ---: | --- |
| Menus (Pokitaru / Quodrona / FRONTEND) | 9 | 82 / 82 / 61 entries (Quodrona mirrors Pokitaru) | Native list/text primitives can host options; screen routing and storage need integration; overlay boundary needs live validation; native menu mode can keep simulation running |
| Weapons and armor inventory | 5 + finalize | 359 + 14 | 25 inventory ids, separate rank and mod state, a damage-table initializer, armor powers; weapon rank setter allows eight values; armor reaches the direct health subtraction (blanket "ornamental armor" REJECTED) |
| Damage and health | damage-health (2), damage-index | 29 + 5 | Common receiver path, post-hit suppression counter decrements inside substeps (same nominal rate in A and C), hit-acceptance boundaries need measurement |
| Damage atlas (GPT, 2026-10-06) | 3 level slices + 20 follow-up recipes | 14 functions + 133 windows | Nine linked reports; GCS2C health CORROBORATED; Derby, GCS, Skyboard, MP, arena, hazards, decoy and roster closures; scene and indirect coverage OPEN |
| Laser gate | 4 | 21 | Twelve modules have unique Laser contracts; first-pass state on the first substep, damage at the pair-end callback; four receiver sites; native FPS 30/60 branches rule out a universal two-word fix |
| Otto / Flamethrower | 11 | about 40 | Quodrona is LEVEL_10; Otto uses animation ids plus a logical state and countdowns; a two-hook query gate was specified; release fireball row is separate |
| Agents bomb | 5 | about 75 entries | Closure and event chains for Pokitaru and Quodrona |
| Tremblator ray | 2 | 10 | Particle callback replacement after generic initialization; segmented-ray state machine, segment pool animator, ray particle callback |
| Crab and navigation | 2 | 5 + 5 | Navigation move, attack counter, timer batch audit (10 of 29 sites not timers: batch REJECTED) |
| Weapons next / clocks | 7 | about 20 | Dynamic-clock family in LEVEL_16/20, consumers in LEVEL_01, MiniTurret in 24 |
| Static follow-up (effects, save, post-render) | 3 | 3 slices | Effect initialization writes 410 globals; source duration, fractional births and particle age have separate per-call contracts; birth copies coexist with live template reads; save request +C is a sequence ticket, not a slot; post-render dispatch resets a one-frame queue |
| Shared helpers | context + 2 naming | 26 + 19 + 36 | 37 helpers used by 5 or more classes; animation boundary checks consume a latch; predictive mode uses a fixed nominal 1/30 step |
| Animation boundary context | 1 | 4 | End flag raised on the first update past the end and read one update later (basis of `animlat`) |
| Render/logic probe (2026-11-09, local Ghidra reads) | n/a | about 12 functions read | Group pump 2, mesh draw, pose evaluation functions contain no time step; see section 9 |

## 9. Engine knowledge extracted (functional map)

Addresses are in the detailed local reports; here is the knowledge by role.

- **Level loop and main update:** a `while` loop increments the global frame counter and calls the per-frame update; the update reads the shared delta once and calls, in order, player update, group pump 1 (entity updates), group pump 2 (render preparation), the particle walker and the deferred draw flush.
- **Group pump 1:** iterates groups (stride 0x50) and 0x80-byte moby records; each record's class update is called through one indirect call with the record and the delta.
- **Group pump 2:** culls by squared distance and a LOD byte, maintains flags and list links, evaluates skeletal poses and calls per-animation callbacks. Pose functions contain no 1/30 or 1/60 literal and no delta (INFERRED).
- **Moby record:** position at +0x30, rotation basis in the first 11 floats, animation object pointer, two class-data pointers (class dependent), flags with an active bit, age/timer, update/draw radius bytes.
- **Particles:** walker plus 49 animator pools with 80-byte records removed by swap-with-last; update and vertex generation share one pass; effect templates are derived at module start from a 1/30 base (228 fields).
- **Spring and filters:** one generic per-call spring and 20 critically damped camera filters with dt baked in.
- **Per-frame state that pump 1 refills:** fog sources, light-influence list, deferred draw entries, direct draw entries, the frame scratch pool, a second draw-item pool, the HUD prompt counter and confirm flag. This is why skipping pump 1 breaks fog, lights and prompts.
- **Input:** one latch per frame (make/break/edge); objects that run less often miss events.
- **Draw:** mesh draw receives live moby record pointers; vertex entries are typed (types 1, 6, 8 sampled) with strides 16/20/24.
- **Player:** state in the data segment, two-iteration substep loop (limit 2 in 15 modules, 1 in LEVEL_16..20), health float with a floor of 0 and a mirrored ceiling; one outer-loop function writes dt x 30.
- **Native frame-rate initializers:** 82 static initializers in LEVEL_01, eight derive constants from a time base (effect templates, damage-table base, camera, two filters, Laser with FPS 30/60 branches, player with FPS 60, bolt crank).
- **Weapons:** the equipped weapon update runs inside the player substep loop; projectiles (Blaster, Ryno, ShockRocket, BlitzGun, BeeMine) step or age per update; animation end latency of two updates explains the Ryno refire.
- **Damage:** a common delivery path (selected target, zero-scalar hit query, 16-target area delivery, table writer), armor reduction, post-hit suppression, separate semantic death, displacement and minigame-resolution contracts; Torso shot chain from decoy snapshot to receiver; Giant Clank ship with local/mirrored HP.
- **Classes:** 150 in Pokitaru (67 with embedded field-definition strings), 324 MOBYS source units in total, shared frameworks (EnemyController up to 12 members, EnemyWave, Grindrail, SentryTurret, TMRobot heads/torsos).

## 10. What has not been decompiled (gaps)

- LEVEL_02 to 09, 15 to 24 have **no saved decompilation project**; they are known only through masked matching and targeted slices. LEVEL_02, 10 and 23 were additionally checked by the native frame-rate census.
- About 4,300 of 5,046 LEVEL_01 functions keep automatic names; their roles are known only when reached by a slice or scanner.
- Whole-game scene bindings, scripts, bosses and indirect receivers outside LEVEL_01 (damage atlas boundary).
- Several class-side readers found live (three code addresses read by the crab class) are not read in source.
- The skinned-character draw path and animation callbacks were not read; pose functions only skimmed beyond the first 70 lines of the large one.
- No decompiled code is published; independent reproduction requires the owner's original files and the recipes and scripts listed above.

## 11. Reproduction and preservation

1. Obtain the owner's original modules locally (never committed); verify SHA-256 against the identity JSON files under `research/v2/class-table/`.
2. Use the existing Ghidra 12.0.4 + Allegrex environment; run the runners in `research/scripts/ghidra/` with a fresh run directory (they refuse existing destinations).
3. Regenerate datasets with the scanners; compare method hashes. Outputs are evidence, not canon.
4. Never stage `_local/`, decompiled C, instruction exports, field-string dumps or database binaries. Run `python tools/publish/check_publication.py --staged` before any public update.
