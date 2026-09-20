# Runbook

## Phase 0 — Initialize

1. Run the initialization script from repository root.
2. Copy the existing object/class corpus into the mission working area or point the Coordinator to it.
3. Ensure the Coordinator can inspect all extracted PRX/module data and all previous static-analysis outputs.
4. Do not require PPSSPP runtime access.

## Phase 1 — Inventory import

The Coordinator must identify:

- canonical original corpus;
- source file for each corpus entry;
- module/level if known;
- addresses if known;
- duplicates/aliases.

No original corpus row may disappear.

## Phase 2 — Cross-cutting timing pass

Before or in parallel with the first shards:

- identify shared delta consumers;
- identify common update helpers;
- identify global loops;
- identify common frame counters;
- identify common animation/state helpers;
- identify common movement/physics helpers.

This prevents shards from repeatedly rediscovering the same root causes.

## Phase 3 — Static shard analysis

For every assigned object:

1. Identify constructor/vtable/implementation.
2. Find update/think/tick/state functions.
3. Trace relevant callees.
4. Classify all timing mechanisms.
5. Create A0/B0/B1/C1 model.
6. Assign C1 verdict.
7. Create patch candidates where justified.
8. Write object dossier.
9. Emit newly discovered dependencies to Coordinator.

## Phase 4 — Implementation grouping

Fingerprint equivalent implementations across PRXs.

Keep each concrete address instance while linking them to a shared implementation group.

## Phase 5 — Patch candidate synthesis

For every incorrect/partial C1 mechanism:

- identify semantic root cause;
- derive candidate;
- derive opcode if possible;
- document risks;
- document expected impact;
- create manual validation protocol.

## Phase 6 — Skeptic pass

Audit:

- all P0/P1 mechanisms;
- all CONFIRMED_STATIC/STRONG candidates;
- all broad-scope candidates;
- any candidate touching shared code.

Downgrade confidence where required.

## Phase 7 — Coverage closure

Run closure until the pending queue is empty.

Required:

`UNEXAMINED = 0`

Any newly discovered helper creates a new pending item until terminally classified.

## Phase 8 — Human test queue

Generate a prioritized queue for manual PPSSPP testing.

Recommended order:

1. P0 root-cause shared candidates;
2. enemy movement;
3. enemy attacks;
4. weapon cadence/damage;
5. physics;
6. environment;
7. camera;
8. presentation;
9. cosmetics.

## Safe operating rules

Agents may create reports and analysis helpers.

Agents must not alter active gameplay binaries or patches.

No live patch testing is part of this mission.
