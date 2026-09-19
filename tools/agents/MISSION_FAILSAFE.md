# Detached mission failsafe

Operational policy: docs/methodology/ORCHESTRATOR_POLICY.md.
Persist CURRENT_STATE.md with the planned mission ID before launch.

```powershell
pwsh -NoProfile -ExecutionPolicy Bypass -File .\tools\agents\scripts\start-deepseek-mission.ps1 -MissionId <id> -TaskFile research\tasks\<task>.md
```

The launcher returns immediately. Task, parent checkpoint, mission.json and
RESUME.md already exist. A detached PowerShell runner owns completion; no parent
callback or parent-model quota is required. CODEX_HOME propagates to children.
Workers hydrate the API key from process or persistent Windows User/Machine.
Secrets are never printed. Read-only workers emit full report plus compact JSON
in the same response. Host scripts extract/aggregate and persist final state.

Inspect once in a future session or on an explicit owner status request:

```powershell
pwsh -NoProfile -ExecutionPolicy Bypass -File .\tools\agents\scripts\get-deepseek-mission-status.ps1 -MissionId <id>
```

Do not repeatedly poll. Work independently or end after launching.
QUEUED/RUNNING means not complete. WORKERS_COMPLETE/READY_FOR_PARENT means reports,
handoffs and READY_FOR_PARENT_REVIEW.md were persisted, not gameplay validation.
WORKERS_FAILED/BLOCKED preserves successful scopes and diagnostics.
After quota loss: read root startup files, inspect persisted state, read
PARENT_HANDOFF.md first, then only necessary full-report sections. Never restart
from memory or overwrite a completed mission. Legacy READY_FOR_SOL and
sol-review.md remain supported. No paid OpenAI fallback is enabled implicitly.

Detachment survives launcher/parent-session exit, not OS shutdown or deliberate
process termination. Network/provider failures are recorded when the runner can
handle them. An interrupted runner can leave stale RUNNING; the status command
flags an unverified PID. Review diagnostics before any narrowly scoped retry.
