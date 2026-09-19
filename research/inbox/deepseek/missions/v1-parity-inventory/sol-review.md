# V1 parity inventory — parent critical review

Date: 2026-09-19. Review stage: Sol/parent reconciliation. Starting HEAD: `7cacd2b916e5164da2c7fa4a6fe961f97d966b60`, branch `v2-research`. This review completes the interrupted mission; it does not repeat the workers or validate gameplay. No gameplay code was changed for this review.

`L/` denotes `01-Travail-et-profil-PPSSPP/Overcompensated-Reprise-2026-09-14/`; `P45/` denotes `L/sources-v0.4.5/Size_Matters_wrapper_profiler_v0.4.5-prealpha_UCES00420/`. Worker IDs are namespaced **E**, **M**, and **S**, because their identically numbered VPI entries describe different things. Original reports remain unchanged. Deterministic checks are reproducible with `verify-review.py`; outputs are `parent-checks.json`, `parent-socle-context.asm`, and `reconciled-items.csv`. These are static/recorded-evidence checks, not an emulator experiment.

## 1. Executive summary

The three workers completed successfully at 2026-09-18T21:09:23Z. The task and snapshot have identical SHA-256 `665f3aa7caba5849d27d5f31e495ff52607521485125d47825573fdcb1ac954e`. The initial HOME failure is preserved under `attempt-1/`; the retry used PID 39572. Commit `35f8e46` subsequently added explicit CODEX_HOME resolution/propagation; the successful old run predates that change and cannot itself validate the hardened launcher. Commit `7cacd2b` preserved the three reports. `RESUME.md` and `READY_FOR_SOL_REVIEW.md` contained PowerShell backtick/interpolation damage, but the JSON paths and reports survived. No parent review or `research/v2/` model existed on resumption.

V1 supplies useful patch words, code, partial traces and qualitative trials. **No reproducible, controlled original-30/gameplay-corrected-60 comparison is established by the reviewed corpus.** This is a statement about available evidence, not proof that no historical testing ever occurred.

The reconciled working inventory retains **65 candidate contexts**, **59 with a historical correction/policy candidate**, **6 with reported numerical 30 FPS leads**, **0 with a usable reproducible 30 FPS gameplay baseline**, and **9 essentially unknown contexts**. These are planning units, not a definitive count of all game mechanics. Counts are audited by `reconciled-items.csv`: retain Explorer entries except E006/008/009/010/024/027/036/067/069/070/072/077. Excluded entries remain as negative history, dependencies, coverage gaps or explicit duplicates; they are not deleted. Mapper's finer fire-emission, teleporter, Bee-fade and shrapnel distinctions remain subitems of E075/E058/E044, to be split when tested. The workers' 77, 66, and 142 mechanic-label counts are **not interchangeable**.

Reported-number IDs are E001, E015, E028, E032, E034, E035. A call count, VBlank-derived interval, traversal window or Airboard lap report is not automatically a mechanic baseline. The nine essentially unknown contexts are E007/035/050/064/065/071/073/074/076: loading, Airboard, arena controller, generic ammo/cooldown, melee timing, Giant Clank behavior/crash, BotFlinger, Microbot survival, and boss phases. Other entries also lack measured baselines but contain more concrete candidate mechanisms. Candidate counts include rejected proposals and untested static policies; they do not count successful fixes.

## 2. Historically established evidence

- **OBSERVED, static:** the Pokitaru archive has 22 common writes plus alternative local/global wrapper strategies. All 22 original words match the pinned LEVEL_01 PRX in this review. Four core words are VBlank, delta, substep limit, and local float compensation; camera, Titanium and objects are additional changes.
- **OBSERVED, static:** the 1,470-row later ledger is not a superset of the early Pokitaru package. The 14 object-specific common writes after the eight base/camera/Titanium words are absent from its module-1 RVA set. Their absence does not prove a regression: later routing may overlap in effect, which is untested.
- **OBSERVED, recorded memory:** v0.6.1 has 167 site and 36 callsite records in `L/connection/dev061-integration-1789598570306.json`, explicitly scoped to read-only integration. All site pass flags are true. Its `LIVE_VALIDATION.json` is a summary and excludes gameplay fidelity.
- **OBSERVED, recorded data:** Metalis has manual write/readback records; pickup values differ in 27/45 generalization rows; static transfers have 176 missing/nonunique cases. Those are narrower facts than correctness of any gameplay result.

## 3. Existing quantitative evidence

**Kalidon B:** preserved raw trace and CSV names are not evidence for the identically named earlier A files. `trace_L03_0004.csv` and `0005.csv` have the same SHA-256 `03f10ac4becbce8587a8478d88b26bb21475c4f54c095ef8569f9b68df0e94c5`; they must not be counted twice. The historical B packet includes the four core changes, camera and Titanium, plus instrumentation. Call it **historical socle-B**, not unlock-only B0.

**WF-058:** the history table records A=1,945 hits/184 active VBlanks/~6.100 s and B=1,943/184/~3.050 s (`L/history/6a86dce7-2998-83eb-bf81-229c2835c35d.md`, around lines 4526–4552). `183*2/60` and `183/60` reproduce the seconds. The history also states video endpoints 10:58.850–11:01.900 for B. Thus the Skeptic correctly challenges independence, but cannot prove from arithmetic alone that the numbers were *never* video-timed. Raw A/video are unavailable in the reviewed evidence. Status: **OBSERVED in historical report**, B trace counts inspectable, absolute gameplay duration and C correction **UNKNOWN**. 184 active VBlanks do not mean 184 total hits or one object invocation per VBlank; the trace reports up to 12 hits within one.

**Kalidon total reconciliation:** Explorer's historical chronology is supported by history lines 4126, 4383–4402: an earlier 67,905 aggregate; later 2,866+69,173=72,039 A aggregate; 87,570 socle-B. Mapper/Skeptic calling these intrinsically incompatible is too strong. The chronology explains differing totals, but missing A files prevent independent rederivation and filenames were reused. Do not compare whole-route totals as equal-work tests.

**WF-044:** 35.533 s and 122.250 s are not established matched platform-cycle durations; B includes traversal/retries. Reject a 3.44× platform slowdown conclusion. Acid height requires its own observable.

**WF-002:** reported 2,595/48.767≈53.2 and 2,585/46.550≈55.5 hits/s suggest a counterexample to blanket doubling. Skeptic's multiplication of total hits by 2/60 incorrectly treats same-VBlank hits as distinct intervals. This does not establish self-normalization either. The link to player substeps remains **INFERRED**, not corroborated causality.

**Profiler stages 02/03:** retain derived reports (55/57 hooks; 496,697/122,243 hits; Ryllus 67,865/68,742 two-VBlank transitions). Original captures have not been located/replayed. A detect-only Pokitaru trace with zero hooks/hits cannot replace stage 02. A histogram of selected callsites is not a whole-game cadence measurement.

## 4. Static/integration-only evidence

The 493-callsite/59-family catalog describes one wrapper's callers, not all clocks. The empty family-to-patch relation table remains mapping debt. Secondary callbacks, bare increments and damage paths can bypass the wrapper. The 38,219 scan candidates are neither validated functions nor 38,219 gameplay defects. The 170-row supplemental weapon file contains **four** system labels (Lacerator 34, RYNO 72, Shock Rocket 48, Sniper Mine 16), unlike the broader weapon corpus; Explorer/Skeptic's association with 13 weapons conflates datasets.

Mapper's instruction decoding needs correction. The binary words decode to `mov.s f20,f12` → `add.s f20,f12,f12`, not `mov.s f10,f6` → `add.s f10,f6,f12`. The patch **doubles the incoming scalar locally**; its semantic purpose still requires caller/dataflow/runtime evidence. Likewise `3C044000` → `3C043F80` is `lui a0,0x4000` → `lui a0,0x3f80`, loading high halves for 2.0/1.0. Interpreting whole instruction words as floats to claim a ratio near 1 is invalid. The surrounding `mtc1` supports the historical factor description. These errors demonstrate why worker consensus cannot establish correctness.

## 5. Qualitative user observations

Retain the reports of rapid acid rise, Burner damage, melee impact/animation mismatch, crab failed jumps, Metalis vehicles/traps, recoil affecting player and enemies, improved crate/teleport timing and Nano/ammo collection. They identify candidate symptoms; no duration, distance, damage or ammo count is supplied by their write/readback records. A label such as `userValidated` means the recorded judgment, not a controlled parity result. Camera framing feedback concerns an optional feature and is excluded from the parity count.

## 6. Claims requiring V2 revalidation

Every core-player behavioral claim needs ablation: VBlank unlock, general delta, conditional substep loop and local scalar doubling. Pokitaru object rates/hit windows need later individual tests. Ryllus requires current image identification. WF-058 needs a clean A and a measured C; WF-044/platform and direct acid increment must be separated. Continuous weapons require independent damage-per-hit, hit rate, ammo and effect-duration measurements. Metalis pickup transfer, debris trajectories/countdowns and all special modes remain unvalidated. Menus/HUD/teleportation cannot inherit validation from static matches or stale objects.

## 7. Contradictions and provenance problems

| Issue | Reconciled result and resolving evidence |
|---|---|
| LEVEL_02 identity | `iso_verification.json` contains **two** ISO results: `copy.iso` 14/15 with LEVEL_02 `811d…`; second named PSN ISO 15/15 with `003768…`. Skeptic caught an omission by earlier inventories. Neither filename proves retail provenance. The cause of the difference remains UNKNOWN; do not claim the reference disagrees with every available ISO. |
| Kalidon sessions | History distinguishes multiple A sessions and B; original A artifacts still missing. Explorer's chronology accepted as reported history, not reconstructed raw capture. |
| Pokitaru coverage | 14 early object words absent from later ledger; local 15-JAL strategy and later policy differ, notably WF-014. Requires explicit version matrix, not wholesale inheritance. |
| Physics and Titanium decode | Mapper's register decode and instruction-as-float argument rejected by deterministic disassembly. |
| Metalis pickups | 27/45 value identities differ; the Metalis quarter-acceleration/nonlinear steering experiment itself is unmeasured. Neither transform earns approval from algebra alone. |
| Cave guard | v0.6.2 local override, v0.6.3 template/guard conflict and v0.6.4 host repair are different events. Host acceptance does not demonstrate in-game arming/parity. |
| Giant Clank | Same-scene LEVEL_15 writes are not established as a necessary cause. Later exclusion line belongs to `L/development-v0.6.4-no-menu/backup-plugin-before-no-menu/status.log`, not the earlier session log. Prior LEVEL_07 writes/plugin activity remain possible confounders. |
| Giant Clank identity | Shared anchors/equivalent profiles and `matches=2` require stronger module identity. This is not proof that ambiguity caused the crash. A host executable crash does not exonerate guest patches/JIT interactions. |
| Menu objects | Screen-17 data persisted while screen 3 was active; active ownership must be verified. Earlier color-as-float extraction was superseded. |
| Counts and completeness | All three worker counts mix levels of aggregation. Some fields requested by the task remain UNKNOWN, and broad gap rows are not independently testable items. The 65-context crosswalk is a conservative research index, not an exhaustive certification of every weapon/state/module. |

## 8. Missing 30 FPS baselines

No reusable controlled baseline was found for player position/velocity, acceleration, stop distance, jump apex/duration, animation phase, contact timing, weapon damage/ammo/cooldown, pickups, debris, HUD, menu, vehicles or special modes. Pokitaru/Ryllus derived instrumentation reports do not fill these gaps. Airboard's reported 2:51.6 lap lacks controlled input and cannot isolate boost or movement. Capture provenance, exact scene/save, active words, timing settings and repetitions must accompany new baselines.

## 9. Rejected or superseded V1 assumptions

Preserve the broad global-wrapper safety assumption as unsupported; old fixed-address unlocks as superseded; WF-029 ONE_PASS as a failed *complete local vehicle solution* only; “same pickup correction generalized” as rejected for value identity; old cave “not integrated” as superseded for v0.6.2; LEVEL_15-write necessity as rejected within the recorded trials. The shrapnel/non-timer and Tremblator negative leads require exact version/site checks before reuse. A threshold doubled under a doubled update rate can be legitimate: Skeptic's suspicion alone does not reject TrainingBot or Crab threshold patches.

## 10. Likely timing-domain clusters

The Great Clock should model outer cadence, explicit delta consumers, conditional player substeps, local scalar compensation, wrapper pass count, bare increments, frame counters/windows, accumulators, animation, weapon divisors, secondary callbacks, and possibly self-normalizing paths separately. Render, simulation, VBlank and wall time are separate observables. Multiple domains can affect one object. See `research/v2/timing-domains.md` for the subsequent living model.

## 11. Shared-root-cause candidates

**INFERRED:** doubled outer execution frequency can expose per-update arithmetic throughout unrelated mechanics. Player substep reduction can preserve some call rates while delta/local compensation changes per-call magnitude. Wrapper smoothing composes twice per call but cannot automatically control counters outside it. Pickup speed/acceleration/steering involve different discrete-time powers; their compensation may interact. Shared teleport emitters/secondary callbacks may explain crate and effect symptoms across levels. None is a universal fix; falsify each against state-level observations.

## 12. Priority A/B/C experiments

The owner's resumed instruction supersedes workers' recommendation to start at Kalidon. **PLAYER-CLOCK-001 in Pokitaru comes first:** establish genuine vanilla A0, compare unlock-only B0, then delta-only B1 relative to B0, choosing subsequent substep/local-physics arms by information gain. Record idle animation and straight-line/jump observables separately. Keep camera, Titanium, wrappers and object/weapon/effect patches absent.

Prepare WF058-CONTROL-001 as a later method control. Historical socle-B is an explicit separate arm; do not equate it with B0. Then separate Kalidon platform/acid, measure continuous damage, and resolve Metalis pickup/debris/vehicle behavior. Giant Clank clean control is required before crash attribution.

## 13. Blocked/unknown items

Historical A videos/traces, full 54-row manual-to-generated-to-loaded linkage, scene identity for special modes, exact animation ownership, reliable live player fields and deterministic replay remain dependencies. Missing evidence cannot be repaired by model agreement. A clean cold-boot A is preferable to a savestate created under historical patches. If a state is necessary, record its provenance and verify rebuilt state, not only four instruction words.

## 14. Potential Astra escalation candidates

No extra escalation is justified just to recount history. A bounded architectural question may later qualify if controlled ablations leave equivalent competing player-clock explanations; similarly Giant Clank after clean controls, or coupled pickup integration after measured trajectories. Missing videos, unknown scene setup and incorrect instruction decoding are evidence/tooling tasks, not reasons for model escalation.

## 15. Recommended validation order

1. Preserve this review and exact source checks; maintain unverified labels.
2. Document timing domains, binary player socle, hypotheses, and PLAYER-CLOCK-001 protocol.
3. Parent-only PPSSPP preflight, deterministic input and verified A0; validate observables.
4. Pokitaru ablation with independent cadence and player-state measurements; replicate and obtain skeptical review before TESTED.
5. WF-058 method control, then WF-044/acid and isolated Pokitaru object regressions.
6. Weapons/damage, Metalis motion/pickups/debris, other levels/special modes and transitions.

Official V2 gameplay inclusion remains unauthorized. This review promotes no gameplay fix to TESTED.
