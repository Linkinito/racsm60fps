# External DeepSeek worker tools

Parent policy: GPT-6 Astra, Medium. Workers: independent Explorer / Mapper /
Skeptic through the existing external provider for broad research/falsification.
Bounded read-only lookup/triage uses project Luna roles (prefer one, maximum two).
Read docs/methodology/ORCHESTRATOR_POLICY.md for reading budgets and handoff rules.

## Requirements

PowerShell7, codex CLI, a user-level deepseek-flash-high.config.toml and configured
DeepSeek provider in CODEX_HOME. DEEPSEEK_API_KEY comes from the process or Windows
User/Machine environment, never the repository. Pass -CodexHome explicitly when
needed. Do not print configuration secrets. Workers use read-only sandbox and
approval_policy=never. Reports are English.

## Preferred workflow

Persist CURRENT_STATE.md with mission ID, then use start-deepseek-mission.ps1.
Explicit -Roles is required: select only the role(s) the question needs.
The full trio requires a recorded multi-domain or consequential justification.
See MISSION_FAILSAFE.md for complete commands. No repeated parent polling.

invoke-deepseek-panel.ps1 is the runner's synchronous internal panel; it launches
independent child processes and waits locally. invoke-deepseek-worker.ps1 invokes
the external provider. Full reports include a worker-authored compact JSON block;
export-parent-handoff.ps1 extracts <role>-handoff.json and builds PARENT_HANDOFF.md.
No parent call is used for aggregation. Invalid JSON/schema fails that scope;
original reports and _logs status/diagnostics remain available.

New mission review path is parent-review.md; old sol-review.md is preserved.
For legacy missions without compact data, export-parent-handoff.ps1
-MissionDirectory <path> -Legacy creates a pointer-only handoff with explicit
UNKNOWN, without rewriting historical reports or pretending to summarize them.

Get-deepseek-mission-status.ps1 returns one compact JSON object with deterministic
counts, sizes, wrapper exit codes, timestamps and required-file presence. Legacy
panel summaries are supported (unrecorded exit codes remain null).
Do not use -Force to restart an existing mission: launcher refuses evidence
replacement. Recover only the failed scope with a new ID after diagnosis.

Tests: pwsh -NoProfile -ExecutionPolicy Bypass -File
 tools/agents/tests/test-orchestration.ps1
