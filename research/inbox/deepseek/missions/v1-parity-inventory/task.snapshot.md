# V1 parity inventory — Overcompensated V2

## Mission and boundary

Priority 0 is faithful **30 FPS → 60 FPS behavioral parity** for *Ratchet & Clank: Size Matters* (PSP, UCES00420). Exhaustively but conservatively inventory the distinct V1 behaviors known or suspected to depend on framerate and requiring V2 revalidation. The original, unmodified 30 FPS game is the gameplay reference. This is historical research and test planning, not patch development. Preserve useful negative findings and uncertainty.

Read `AGENTS.md`, `PROJECT_GOALS.md`, `MIGRATION.md`, `docs/methodology/EVIDENCE_LEVELS.md`, `research/inbox/legacy-v1-inventory.md`, `research/inbox/legacy-v1-inventory-review.md`, and `tools/agents/MISSION_FAILSAFE.md` first. The critical inventory review takes precedence over the navigation inventory wherever it corrects the latter. Follow V1 source paths back to exact versioned primary files, ZIP entries, manifests, ledgers, code, logs, traces, measurements, and test records where available. Use the immutable `legacy-60fps-pre-v2` tag as a historical anchor. Do not assume a directory called “current” names the tested binary. Keep archive contents, generated data, manual write ledgers, loaded-memory checks, instrumentation checks, qualitative reports, and gameplay measurements separate.

## Independent worker scopes

- **Explorer:** Search broadly across V1 archives, histories, notes, level/module material, weapon and object reports, and experiments for every distinct framerate-dependent gameplay lead. Record exact provenance and omissions. Include negative trials and leads outside known wrapper families.
- **Mapper:** Independently map candidate symptoms to versioned patch words, module/RVA or function/callsite evidence, measurements, test state, and possible shared timing mechanisms. Distinguish a static candidate from a patch that was applied, and an applied word from measured gameplay correction. Reconcile duplicate references without collapsing distinct mechanics.
- **Skeptic:** Independently challenge completeness, asserted 30 FPS baselines, numerical claims, module identity, causality, patch correctness, and the other workers' likely assumptions using primary evidence. Seek contradictions and missing raw artifacts. Propose discriminating controlled tests. Do not inherit another worker's conclusions as facts.

Each worker must produce an English report with a candidate-item table, citations to exact source paths and (where practical) line, row, ZIP entry, or recorded hash, an evidence limitations section, and a list of unresolved or possibly duplicate items. Reports should be usable for a parent Sol reconciliation. Do not inflate an item count by treating every static scan hit, table word, repeated write, or trace event as a distinct gameplay mechanic.

## Required coverage

Inventory base timing/main timing; player movement; acceleration/deceleration; jumping/falling; physics; collision; moving platforms; elevators; hazards; enemy movement; enemy AI; weapon fire rates; weapon cooldowns; ammo consumption; direct damage; damage over time; melee; projectiles; recoil; scripted timers; scripted sequences; pickups; bolts; breakables; object movement; animation timing; particles/VFX; HUD; menus; camera timing; vehicles; minigames; Giant Clank; Airboard; transitions; loading/level transitions where relevant; level-specific mechanics; and any other historical ×2, ×0.5, or otherwise framerate-dependent behavior found in V1. Record a domain with no usable evidence as an explicit coverage gap rather than inventing an item.

Explicitly investigate these historical leads without presuming they remain correct: base 30/60 timing mechanism; player movement; Pokitaru; Ryllus; Kalidon acid elevator/moving elements; WF-058/MungoDrone; Burner damage; weapon cooldowns and damage; melee; Metalis vehicles; debris/crates/collision; pickups; camera; menu timing; teleportation; Giant Clank; Airboard; and module-specific patches and regressions. Include wrapper policies and local changes only when tied to a possible gameplay behavior or necessary diagnostic dependency. Look for symptoms both inside and outside the historical 493 wrapper callsites.

## Candidate-item record

Use stable IDs such as `VPI-001`. One item should represent one independently testable mechanic/symptom in a defined context; link shared causes and cross-level variants rather than silently merging different behaviors. For **every** distinct candidate parity item, supply at least:

1. Unique identifier; gameplay domain; level; module; mechanic/symptom.
2. Exact V1 source path(s) and version; evidence provenance (firsthand measurement, user report, source, disassembly, generated table, memory readback, trace, etc.).
3. Known original 30 FPS behavior and any quantitative 30 FPS baseline, including unit, scene, measurement method, capture identity, repetition count, and precision when known.
4. Known uncorrected 60 FPS behavior; known historical corrected 60 FPS behavior. State `UNKNOWN` for absent arms.
5. Historical patch or candidate, whether merely proposed, statically present, applied in memory, built, enabled, or gameplay-tested; relevant function/address/RVA/callsite only when supported, with module/base/version qualification.
6. Evidence status **for each material claim** using `OBSERVED`, `INFERRED`, `CORROBORATED`, `TESTED`, `UNKNOWN`, `REJECTED`, or `SUPERSEDED`; name the scope of any `TESTED` label.
7. Quantitative measurement available: yes/no; quality of measurement (raw controlled capture, derived report, approximate user timing, qualitative report, etc.); contradictory evidence; missing evidence.
8. Recommended V2 measurement; recommended A/B/C test with a controlled scene and measurable outcome; suggested priority and why; dependencies; uncertainty; and whether this symptom may share a root cause with other IDs.

Use **A = original 30 FPS**, **B = uncorrected 60 FPS**, **C = candidate corrected 60 FPS**. Do not fill missing A, B, or C from a plausible ×2 relationship. An approximate historical number may be recorded as a *reported* quantitative lead, but identify if its raw capture and test controls are missing. Distinguish `quantitative baseline reported` from `usable reproducible 30 FPS baseline`; give both counts. For historical candidate-fix counts, report separately proposed/static candidates and changes known to have been applied. “Essentially unknown” means a credible parity domain/lead whose original behavior or symptom lacks enough evidence to define a controlled comparison; state the counting rule and any ambiguous cases. Give a deduplicated count and an ID-level reconciliation so the parent can audit it.

## Evidence and provenance traps to check

- v0.6.1's 167/167 sites and 36/36 redirects are a loaded-memory integration result from `L/connection/dev061-integration-1789598570306.json`, not gameplay parity; `LIVE_VALIDATION.json` is a summary, not the primary arrays.
- The broad static scan's 38,219 candidates are not applied or validated patches. The manual ledger's 111 write events, 54 module-RVA rows, generated tables, and runtime data are distinct evidence layers; verify version and row linkage. Runtime cave transformations can be absent from flat patch ledgers.
- `LEVEL_02.PRX` ISO/reference identity differs in the recorded hashes; its cause is unknown. Do not use either as unquestioned vanilla evidence. Historical absolute addresses are session-specific; qualify RVAs by module and version.
- Pokitaru/Ryllus profiler stage 02/03 reports contain useful derived timing counts, but original raw captures/logs may be absent. A later detect-only trace does not validate earlier hit totals. Kalidon `0004`/`0005` parser results are cumulative, and the 67,905/87,570 hit accounts need capture identity.
- WF-058/MungoDrone's approximately 6.10 s versus 3.05 s is a reported timing lead with incomplete raw provenance, not yet a controlled A/B/C result. Kalidon acid ×2 and WF-044 causality need separate tests.
- Metalis static transfer includes 20 candidates and 176 absent/non-unique combinations; neither a signature match nor a transfer gap determines gameplay behavior. WF-029 write/rollback and other guarded readbacks do not measure vehicle, collision, or pickup parity.
- v0.6.3/v0.6.4 Metalis cave template/guard and 27/45 collection value mismatches are versioned source/host issues, not in-game validation. Distinguish the old “not integrated” cave statement from later implementation and guard conflict.
- Giant Clank's same-scene LEVEL_15-write necessity was contradicted by the exclusion trial; the crash cause remains `UNKNOWN` without a comparable clean no-plugin replay. Airboard detect-only parser success is not gameplay validation.
- Inactive menu objects can remain in RAM; check active-screen ownership. Early menu float extraction was superseded. An installed but disabled plugin is not an active gameplay trial.

## Research rules and output

`UNKNOWN` is preferable to guessing. A historical patch is not proof of correctness. “Felt correct” is qualitative evidence only. Static analysis is not gameplay validation. Runtime memory success is not gameplay validation. Agreement between models is not validation. Preserve contradictions and rejected/superseded hypotheses with provenance. Distinguish `OBSERVED`, `INFERRED`, `CORROBORATED`, and `TESTED` at claim level. No authoritative semantic name may be assigned from an address alone.

Do **not** create or modify gameplay patches, original game assets, or V1 historical files. Do **not** begin Priority 2 feature work. Use read-only investigation and write only the mission's assigned research outputs. The parent Sol agent will critically review all worker reports before any claim is promoted. Prioritize the first controlled gameplay experiments that discriminate base-timing causes from local compensations and can be repeated across builds/modules.
