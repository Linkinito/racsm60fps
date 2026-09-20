# STATIC-60FPS-COMPLETE-AUDIT-001 — exhaustive static parity campaign

MISSION PURPOSE

Perform an exhaustive STATIC audit of Ratchet & Clank: Size Matters UCES00420 so that every known gameplay/object/system entry is classified for its expected behavior under A0/B0/B1/C1 and, where C1 is expected to differ from A0 in real time, receives one or more technically justified UNVERIFIED static correction candidates.

This mission intentionally supersedes the older workflow recommendation in CURRENT_STATE that broad class-by-class static reverse engineering should stop before runtime validation. The owner explicitly requests exhaustive pre-classification and pre-patching now.

Do not discard the technical evidence in CURRENT_STATE. Only the older workflow priority is superseded.

REPOSITORY

C:\Users\linki\Documents\PPSSPP\RAC_60FPS

OUTPUT ROOT

reports\STATIC-60FPS-COMPLETE-AUDIT-001

MISSION KIT / RULES

research\inbox\deepseek\missions\STATIC-60FPS-COMPLETE-AUDIT-001

Read:
- SOURCE_PRIORITY.md
- CONTEXT.md
- MISSION.md
- AGENTS.md
- RUNBOOK.md

NO RUNTIME

DeepSeek must not connect to PPSSPP, inspect live RAM, attach a debugger, automate input, launch gameplay, modify savestates, write runtime memory, or run live experiments.

Existing runtime reports may be read only as PRIOR_RUNTIME evidence when SOURCE_PRIORITY.md points to them.

Do not claim a static inference was runtime-observed.

OWNER TARGET

At 60 FPS, C1/future successors must reproduce A0 30 FPS real-time behavior:
- same movement;
- same speed/acceleration/gravity;
- same state durations;
- same attack cadence;
- same weapon rate of fire;
- same projectile behavior;
- same damage timing/DPS semantics;
- same timers/cooldowns;
- same environmental motion;
- same animation/event timing;
- same camera behavior;
- same scripts/minigames/vehicles/UI timing where update-sensitive.

CANONICAL STARTING CORPUS

Use:
research\v2\c1-residual-timing-atlas\c1-residual-timing-atlas.csv

Current evidence describes:
- 538 names in the structured corpus;
- 534 names in the canonical union.

The 534-name canonical union is the minimum mandatory audit register.

Do NOT reopen raw legacy inventories merely to recreate the 534 names if the current atlas is intact.

Use v1-parity and older inventories only for targeted provenance/reconciliation when current sources disagree or omit evidence.

Every canonical name must appear in each role's coverage accounting.

Discovered missing helpers/systems/functions must be added to an expanded queue.

EVIDENCE STATES

Use project-native evidence states exactly:
- OBSERVED
- INFERRED
- CORROBORATED
- TESTED
- UNKNOWN
- REJECTED
- SUPERSEDED

Model agreement is not TESTED.

Also record confidence where useful, but never replace evidence_state with confidence.

A0/B0/B1/C1

Use the canonical definitions in CURRENT_STATE_complete_2026-09-20.md.

Important:
- A0 = vanilla control.
- B0 = A0 plus only the VBlank-unlock NOP at the relevant loaded 0x96650 homolog.
- B1 = B0 plus shared delta ~1/30 -> ~1/60, player loop still two passes, local scalar vanilla.
- C1 = B1 plus player loop threshold 2 -> 1, local player scalar remains vanilla.

C1 is an experimental split-domain arm, not final parity.

Do not assume C1 makes every delta consumer correct.

Some vanilla logical-substep consumers may require a local reconstruction of 1/30 rather than the outer 1/60.

CURRENT EVIDENCE CHRONOLOGY

CURRENT_STATE contains a stale statement that no clean A0/B0 cadence experiment had completed.

EVIDENCE_INDEX now references newer bounded runtime evidence including:
- A0/B0 player-loop true-stop comparison near +0x2FCFC with ~1.999967x B0 complete-cycle cadence in the tested Pokitaru scene;
- A0/C1 Level01Waterfall callback cadence ~29.970540 Hz vs ~59.939060 Hz (~1.9999326x), while fixed per-call steps remained unchanged;
- preliminary B1/C1 player evidence.

Treat these only at their tested scope.

Do not extrapolate Pokitaru runtime cadence to every callback/class/module.

When CURRENT_STATE runtime-status prose conflicts with a newer dated evidence-index entry, preserve the conflict and prefer the newer evidence for that exact tested proposition.

STATIC FACTS / PITFALLS TO PRESERVE

Do not resurrect rejected/superseded claims, including:
- 0x151E8 -> 0x884A4 as the shared-delta target;
- universal dt*30 -> dt*60 rewrite;
- forcing player+0x578 to 1 globally;
- historical local player x2 scalar as preferred clean architecture;
- every 60.0f literal meaning refresh-rate support;
- all 1/30 literals belonging to one timing domain;
- universal RVA + 0x74 file mapping;
- bare loop-tail patterns as unique player-loop identifiers;
- LaserTracer rate logic as a game-wide master clock;
- post-loop gate restoration proving another LaserTracer dispatch;
- Flamethrower %3 -> %6 as deterministic frame decimation;
- stale contaminated LEVEL_02 as current baseline.

Use PT_LOAD mapping for RVA -> file offset.

ROLE CONTRACT

The orchestrator launches explicit DeepSeek roles:
- explorer
- mapper
- skeptic

All roles work independently enough that one role's assumption does not become another role's premise.

All roles must use deterministic 25-name shards over the canonical 534-name register.

If context/quota becomes tight:
1. finish the current shard;
2. persist all rows;
3. update role progress JSON;
4. write a compact handoff;
5. stop cleanly;
6. never mark untouched rows complete.

On a resume mission:
- read role progress;
- continue at next incomplete shard;
- do not restart completed shards unless specifically auditing them.

Never recursively ingest all research logs.

ROLE: EXPLORER

Primary purpose:
exhaustive inventory/class/object inspection.

Must account for all 534 canonical names.

For every canonical item:
- locate module/class descriptors/known callbacks;
- identify implementation instances;
- locate update/think/tick/state/attack/move/render helpers where statically possible;
- identify aliases/stubs/wrappers/dead/data-only entries;
- identify timing-relevant fields/constants/operations;
- discover helper dependencies;
- detect duplicate or near-duplicate implementations across PRXs;
- classify terminal object status;
- record provenance.

Write only Explorer-owned files under:

reports\STATIC-60FPS-COMPLETE-AUDIT-001\staging\explorer\

Required:
- inventory_explorer.csv
- implementation_instances_explorer.csv
- discoveries_explorer.csv
- shard_manifest.csv
- progress.json
- BOOTSTRAP_REVIEW_EXPLORER.md
- EXPLORER_HANDOFF.md

Explorer must not write canonical mapper tables.

ROLE: MAPPER

Primary purpose:
canonical timing-mechanism and pre-patch dataset.

Mapper is the canonical writer for:
- master_inventory.csv
- timing_mechanisms.csv
- patch_candidates.csv
- implementation_groups.csv
- manual_test_queue.csv
- candidate_patches.md
- objects\*.md
- shared_timing_architecture.md
- high_priority_findings.md
- uncertainties.md
- STATUS.md
- coverage.md

Mapper must independently account for all 534 canonical names even if Explorer runs concurrently.

For each canonical item:
1. identify zero, one, or multiple timing mechanisms;
2. trace producer -> transformation -> consumer where possible;
3. classify each mechanism;
4. model A0/B0/B1/C1;
5. assign a C1 verdict;
6. derive a theoretical multiplier only when statically defensible;
7. create one or more UNVERIFIED_STATIC_CANDIDATE corrections when C1 is expected incorrect/partial and a concrete candidate is supportable;
8. otherwise state exactly why a candidate cannot yet be derived;
9. write a manual test protocol for every non-trivial candidate.

Mechanism families include but are not limited to:
DT_SHARED, DT_LOCAL, RATE_LOCAL, STEP_PER_CALL, TIMER_TICKS,
COUNTDOWN_PER_CALL, COOLDOWN_TICKS, STATE_TICKS, LOOP_MULTIPLIER,
CALL_FREQUENCY, ANIMATION_STEP, MOVEMENT_STEP, PHYSICS_STEP,
DAMAGE_TICK, FIRE_RATE, PROJECTILE_STEP, PARTICLE_STEP, CAMERA_STEP,
INTERPOLATION, SCRIPT_WAIT, EVENT_INTERVAL, RENDER_ONLY, MIXED.

Do not reduce a multi-mechanism object to one mechanism.

Examples:
- movement can be fixed-step while animation uses delta;
- attack cooldown can be frame-count based while damage is event driven;
- projectile motion and projectile lifetime can use different timing domains.

For every timing mechanism include:
- mechanism_id;
- inventory_id;
- class/object;
- module/PRX;
- function/RVA;
- implementation group;
- evidence_state;
- mechanism family;
- producer;
- consumer;
- relevant object field(s);
- constants;
- semantic role;
- A0 model;
- B0 model;
- B1 model;
- C1 model;
- numeric multipliers only if defensible;
- C1 verdict;
- priority;
- confidence;
- source/provenance;
- unresolved assumptions;
- candidate IDs.

C1 verdict:
- C1_EXPECTED_CORRECT
- C1_EXPECTED_INCORRECT
- C1_EXPECTED_PARTIALLY_CORRECT
- C1_PROBABLY_UNAFFECTED
- C1_STATICALLY_UNKNOWN

Candidate status is always:
UNVERIFIED_STATIC_CANDIDATE

Candidate must include when derivable:
- module;
- address/RVA;
- original instruction/value;
- original opcode;
- candidate instruction/value;
- candidate opcode;
- conceptual correction;
- expected C1 effect;
- shared scope;
- risks;
- evidence_state;
- confidence;
- manual_test_id.

Do not apply candidates.

Do not edit active INIs, PRXs, ISO or game binaries.

Do not blindly halve constants/damage/interpolation.

For multiplicative damping/interpolation, derive the equivalent per-step coefficient when possible or leave unresolved.

For damage/rate-of-fire, repair timing semantics rather than automatically halving output magnitude.

Mapper role-local progress:
reports\STATIC-60FPS-COMPLETE-AUDIT-001\staging\mapper\progress.json

After every 25-name shard, flush canonical tables and progress atomically.

ROLE: SKEPTIC

Primary purpose:
independent coverage and falsification.

Must account for all 534 canonical names in:
reports\STATIC-60FPS-COMPLETE-AUDIT-001\review\skeptic_class_verdicts.csv

For each canonical name provide:
- canonical name;
- whether timing relevance is independently supported;
- evidence_state;
- likely mechanism family/families;
- known static ambiguity;
- highest-risk assumption;
- ACCEPT / DISPUTE / UNKNOWN relative to existing atlas classification where possible.

Also deeply audit:
- P0/P1 gameplay mechanisms;
- broad/shared candidates;
- high-confidence candidates;
- rate/damage/projectile/camera/physics candidates;
- any candidate patch touching common helpers.

Check:
- call frequency is not invented;
- render code is not mistaken for gameplay state;
- PT_LOAD mapping is correct;
- shared consumers are enumerated;
- C1 effects are not assumed from player behavior;
- linear x0.5 logic is not applied to exponential systems;
- aliases/duplicates do not hide per-level differences;
- prior REJECTED/SUPERSEDED claims are not resurrected.

Write:
- review\skeptic_class_verdicts.csv
- review\candidate_risk_review.csv
- review\conflicts.md
- review\progress.json
- review\SKEPTIC_HANDOFF.md

STATIC PATCH DESIGN PRINCIPLE

Prefer:
root timing cause -> family/shared helper -> class update -> local behavior -> symptom compensation.

But a broad shared fix is valid only if all relevant consumers are understood.

A candidate may be:
- local delta reconstruction;
- local rate 30 -> 60;
- fixed step correction;
- tick/cooldown duration correction;
- loop multiplicity correction;
- update decimation;
- mathematically equivalent damping/interpolation;
- another explained mechanism.

Never patch simply because a literal is 30, 60, 1/30, 1/60, 0.5 or 2.0.

KNOWN HIGH-VALUE DOMAINS

Ensure explicit coverage for:
- player outer timing and selected substep consumers;
- weapons and weapon callbacks;
- enemy locomotion;
- enemy attack cadence/state timing;
- projectiles/lifetimes/homing;
- damage and repeated damage;
- bosses;
- fixed-step environment/elevators/platforms/hazards;
- camera;
- LaserTracer/rate-aware local subsystem;
- scripts/state waits;
- particles/effects/animation;
- vehicles/minigames;
- UI/menu timing where update dependent.

LASERTRACER

Dedicated dossier required.

Known static anchors around:
- 0x14CA70
- 0x148CEC

Existing evidence:
- local rate 30;
- dt = 1/rate;
- explicit rate == 60 branch;
- local damping alternatives;
- scope is local tracer subsystem, not global game clock.

Determine:
- initializer ownership;
- fields;
- consumers;
- update callback/dataflow;
- per-module homology;
- A0/B0/B1/C1 expected behavior;
- candidate correction only if static + scoped prior evidence supports one.

WATERFALL / FIXED-STEP CONTROL

Use the existing matched A0/C1 Waterfall runtime report as PRIOR_RUNTIME evidence for that exact object/scene:
callback cadence approximately doubles under C1 while fixed per-call steps remain unchanged.

This is strong evidence that at least some class-local fixed-step logic remains overdriven under C1.

Do not generalize to all classes without code evidence.

COVERAGE RULE

No canonical name may silently disappear.

Final Mapper coverage must report:
- canonical names expected: 534;
- canonical names present;
- extra discovered names/helpers;
- terminally classified;
- timing relevant;
- multi-mechanism;
- probably unaffected;
- render only;
- aliases;
- unresolved;
- mechanisms;
- C1 correct;
- C1 incorrect;
- C1 partial;
- C1 unknown;
- candidate patches;
- P0/P1/P2/P3 candidates;
- UNEXAMINED.

The canonical completion condition is:
UNEXAMINED = 0

If quota ends first, mission status is PARTIAL, not COMPLETE.

BOOTSTRAP READ DISCIPLINE

Read SOURCE_PRIORITY.md first.

Do not recursively summarize:
- mission-run stdout/stderr;
- workers/_logs;
- probe directories;
- inspection directories;
- raw memory dumps;
- save snapshots;
- local debugger records;
- copied PPSSPP source trees.

Prefer:
checkpoint -> evidence index -> current atlas -> parent reviews/handoffs -> exact primary evidence only when needed.

RESULTS FIRST

Write durable CSV/MD progress continuously.

Do not keep the only copy of analysis in conversational context.

NO COMMIT

Do not commit, push, clean, reset, delete, or rewrite unrelated project files.

Do not commit proprietary PRX/game binaries or RAM dumps.

END CONDITION

If every role finishes:
write compact role handoffs and allow orchestrator aggregation.

If any role hits a resource/quota/context boundary:
persist next shard and stop cleanly.

Do not wait for another agent.
Do not poll parent.
Do not perform runtime experiments.
