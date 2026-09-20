# COORDINATOR_BOOTSTRAP_ADDENDUM.md

Append this instruction to MASTER_COORDINATOR_PROMPT.md or provide it immediately after the master prompt.

Before creating shards, read `SOURCE_PRIORITY.md` and obey its source hierarchy.

Do NOT recursively ingest all of `research\`.

The repository contains large quantities of runtime probes, raw memory dumps, worker stdout/stderr logs, save snapshots and PPSSPP API reference material. These are not bootstrap inputs.

Your first deliverable is a BOOTSTRAP REVIEW containing:

1. exact source files successfully located;
2. canonical starting inventory count;
3. reconciliation status between legacy inventory and v1-parity inventory;
4. existing timing families imported from research\v2;
5. shared timing facts imported from player-clock/socle research;
6. conflicts discovered between prior sources;
7. missing required inputs;
8. proposed shard plan;
9. pending-object count;
10. confirmation that no broad recursive ingestion of live-tests/logs was performed.

Do not launch the full 534+ object analysis until this bootstrap review has been written to:

`reports\STATIC-60FPS-COMPLETE-AUDIT-001\BOOTSTRAP_REVIEW.md`

After bootstrap, proceed autonomously unless a missing input makes a specific class impossible to inspect.

If one object is blocked, mark it unresolved and continue other work. Do not stall the entire mission.
