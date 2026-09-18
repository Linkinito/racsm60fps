# Mission Failsafe Protocol

Long Overcompensated research missions must survive loss of the parent Codex
session, quota exhaustion, application restart, or context loss.

## Principle

The parent Sol session must not be the only place where mission state exists.

Before expensive external research begins, the mission launcher persists:

- the exact task snapshot;
- mission status;
- Git branch and HEAD;
- assigned DeepSeek roles;
- expected outputs;
- explicit resume instructions.

The external DeepSeek panel then runs in a detached PowerShell 7 process. The
mission can therefore continue even if the parent Codex GUI session becomes
unavailable.

## Start a mission

Example:

```powershell
.\tools\agents\scripts\start-deepseek-mission.ps1 `
    -MissionId v1-parity-inventory `
    -TaskFile research\tasks\v1-parity-inventory.md
```

The launcher returns quickly. It does not wait for the workers.

Mission state is stored under:

`research/inbox/deepseek/missions/<mission-id>/`

## Inspect state

```powershell
.\tools\agents\scripts\get-deepseek-mission-status.ps1 `
    -MissionId v1-parity-inventory
```

With no `-MissionId`, the script shows the most recently modified mission.

## Status values

- `QUEUED`: checkpoint created, runner not yet confirmed active.
- `RUNNING`: detached runner launched.
- `WORKERS_COMPLETE`: all requested DeepSeek reports completed; Sol review is pending.
- `WORKERS_FAILED`: at least part of the external worker phase failed.

Review status is tracked separately because worker completion is not technical
validation.

## If the Codex quota is exhausted

Do not restart the research from memory.

After Codex access returns:

1. Run the mission status script.
2. Open the mission's `RESUME.md`.
3. If present, open `READY_FOR_SOL_REVIEW.md`.
4. Have Sol read the task snapshot and raw worker outputs.
5. Produce the missing parent review.

DeepSeek consensus does not become validation merely because Sol was unavailable.

## Optional paid second-level fallback

A separately billed OpenAI API-key Codex invocation can be configured as a
distinct emergency reviewer if desired. It should not be enabled implicitly.
API-key use is billed separately from ChatGPT subscription usage and must remain
an explicit project-owner choice.

Astra is an escalation model for difficult reasoning, not a quota failsafe.
