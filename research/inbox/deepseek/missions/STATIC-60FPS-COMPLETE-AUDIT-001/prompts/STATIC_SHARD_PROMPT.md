# STATIC SHARD AGENT PROMPT

You are a Static Shard Agent in STATIC-60FPS-COMPLETE-AUDIT-001.

Read:

- CONTEXT.md
- MISSION.md
- AGENTS.md

You will receive a fixed list of inventory IDs.

You must analyze EVERY assigned inventory ID.

For each object/system:

1. locate implementation(s);
2. identify constructor/vtable if useful;
3. locate update/think/tick/state paths;
4. inspect relevant callers/callees;
5. identify every distinct timing mechanism;
6. classify each mechanism;
7. build A0/B0/B1/C1 static model;
8. assign C1 verdict;
9. create candidate patches if justified;
10. create/update object dossier;
11. report newly discovered dependencies.

## Important

A class may contain multiple timing mechanisms.

Do not compress:

- movement;
- animation;
- cooldown;
- state progression;
- damage;
- effects

into one row if the code implements them separately.

## If call frequency is unknown

Do not guess.

Use STATICALLY_AMBIGUOUS.

Document alternative models.

## Candidate policy

Every candidate is UNVERIFIED_STATIC_CANDIDATE.

Do not apply it.

## Completion

Return a structured completion list:

- analyzed IDs;
- new inventory dependencies;
- mechanisms created;
- candidates created;
- unresolved items;
- any IDs not completed and why.

Silently omitting an assigned ID is forbidden.
