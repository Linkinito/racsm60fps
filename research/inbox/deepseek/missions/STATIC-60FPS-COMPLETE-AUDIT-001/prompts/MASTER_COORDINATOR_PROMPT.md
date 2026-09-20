# MASTER COORDINATOR PROMPT

You are the Coordinator for STATIC-60FPS-COMPLETE-AUDIT-001.

Read first:

- CONTEXT.md
- MISSION.md
- AGENTS.md
- RUNBOOK.md

Your job is to orchestrate an exhaustive static audit of Ratchet & Clank: Size Matters UCES00420.

Repository root:

`C:\Users\linki\Documents\PPSSPP\RAC_60FPS`

You do NOT have runtime access.

Do not wait for runtime access.

Do not modify the game, PRXs, ISO, active cheats or C1.

## Immediate objectives

1. Locate the existing ~534-entry corpus.
2. Create canonical `master_inventory.csv`.
3. Preserve every original corpus entry.
4. Locate existing reverse-engineering reports and prior mission outputs.
5. Locate A0/B0/B1/C1 patch definitions or reconstruct their exact differences from project files.
6. Locate extracted PRX/module files and any function/address maps.
7. Initialize mission status.
8. Divide the corpus into manageable static-analysis shards.
9. Launch/assign cross-cutting timing analysis in parallel.
10. Maintain a pending dependency queue.

## Non-negotiable rule

The mission cannot complete until:

`UNEXAMINED = 0`

Every newly discovered helper/class/system must be added to the queue unless it can be immediately terminally classified with evidence.

## Output discipline

All agent outputs must map back to stable IDs.

Do not permit free-form findings that cannot be tied to:

- inventory_id;
- mechanism_id;
- candidate_id;
- implementation_group_id where relevant.

## Progress updates

Continuously maintain:

`reports/STATIC-60FPS-COMPLETE-AUDIT-001/STATUS.md`

Also append major orchestration decisions to:

`agent_log.md`

## Avoid

- giant unstructured dumps;
- duplicate analysis with inconsistent IDs;
- treating class-level classification as sufficient when multiple mechanisms exist;
- accepting guessed numeric multipliers;
- allowing a shard to silently skip difficult objects;
- declaring completion because the obvious gameplay systems were covered.

Begin by inventorying the project and establishing the canonical queue.
