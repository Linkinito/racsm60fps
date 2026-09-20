# Agent Architecture

## 1. Coordinator

Owns the canonical inventory and task queue.

Responsibilities:

- locate/import the existing corpus;
- assign immutable inventory IDs;
- assign shard work;
- track dependencies discovered by shards;
- create new inventory entries;
- prevent silent omissions;
- merge agent outputs;
- maintain STATUS.md;
- validate schemas;
- trigger audit/coverage passes.

The Coordinator should not attempt to deeply analyze all objects itself.

## 2. Static Shard Agents

Suggested batch size:

20–30 logical objects per shard, adjusted for complexity.

Each shard must:

- inspect every assigned object;
- locate relevant implementations;
- trace update/think/tick/state methods;
- follow relevant helpers;
- create object dossiers;
- emit timing mechanism records;
- emit patch candidate records where justified;
- report newly discovered dependencies;
- never silently drop an assignment.

## 3. Cross-Cutting Timing Agent

Focuses on shared infrastructure:

- shared delta;
- update loops;
- global schedulers;
- common physics helpers;
- common timers;
- animation helpers;
- event/state infrastructure;
- common projectile movement;
- common damage timing;
- utility functions reused across modules.

Outputs implementation groups and shared causal chains.

## 4. Duplicate/Fingerprint Agent

Find equivalent implementations across level PRXs/modules.

Use:

- binary fingerprints;
- normalized instruction sequences;
- call graphs;
- constants;
- relative structure;
- vtable similarities.

Create `implementation_group_id`.

Do NOT remove individual module/address instances from the inventory.

## 5. Patch Candidate Agent

Consumes mechanisms marked:

- C1_EXPECTED_INCORRECT
- C1_EXPECTED_PARTIALLY_CORRECT

For each:

- identify root-cause patch site(s);
- generate one or more static candidate corrections;
- avoid symptom-level fixes when a more semantic fix exists;
- record original and candidate opcodes when derivable;
- attach risk and scope.

All candidates remain UNVERIFIED_STATIC_CANDIDATE.

## 6. Skeptic/Auditor

Review P0/P1 and high-confidence findings.

Check for:

- unproven call frequency;
- misleading constants;
- render code confused with gameplay code;
- shared helpers with hidden consumers;
- incorrect assumptions about B1/C1 propagation;
- duplicate root causes;
- candidates that would over-correct already-correct systems;
- naive linear compensation for exponential behavior;
- address/module mixups.

May downgrade confidence.

## 7. Coverage Agent

Final reconciliation.

Compare:

- original corpus;
- expanded inventory;
- dossiers;
- mechanisms;
- implementation groups;
- candidates.

Must detect:

- missing objects;
- unexamined entries;
- timing-relevant objects without mechanisms;
- mechanisms without C1 verdict;
- bad/partial mechanisms without candidate or unresolved explanation;
- orphan candidates;
- orphan mechanisms;
- duplicate IDs.

Completion requires `UNEXAMINED = 0`.
