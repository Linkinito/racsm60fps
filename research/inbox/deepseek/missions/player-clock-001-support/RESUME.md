# Overcompensated V2 — Mission Resume Checkpoint

Mission: $MissionId

This file exists so the investigation can be resumed even if the parent Codex
session stops because of a usage limit, application restart, crash, or context loss.

## Canonical mission state

Read:

- mission.json
- 	ask.snapshot.md
- workers/panel-summary.json when present
- workers/explorer.md when present
- workers/mapper.md when present
- workers/skeptic.md when present

The governing project files remain:

- AGENTS.md
- PROJECT_GOALS.md
- MIGRATION.md
- docs/methodology/EVIDENCE_LEVELS.md

## Resume procedure for Sol

If mission.json says WORKERS_COMPLETE:

1. Read the governing project files.
2. Read 	ask.snapshot.md.
3. Read all worker reports and workers/panel-summary.json.
4. Treat worker agreement as corroboration only, never validation.
5. Write the parent review to sol-review.md in English.
6. Identify contradictions, missing evidence, and deterministic next tests.
7. Escalate to Astra only if a materially difficult ambiguity remains after normal review.
8. Summarize the outcome to the project owner in French.
9. Do not modify gameplay patches unless the original mission explicitly authorizes it.

If mission.json says WORKERS_FAILED:

1. Inspect mission-run.stderr.log.
2. Inspect workers/_logs/ if present.
3. Preserve successful worker reports.
4. Restart only the failed scope unless the evidence set itself must be regenerated.

If the mission is still QUEUED or RUNNING, inspect the recorded runner PID
and logs before starting a duplicate mission.

## Important

DeepSeek output is research evidence/hypothesis material, not authoritative truth.
Priority 0 remains faithful 30 FPS -> 60 FPS behavioral parity.
