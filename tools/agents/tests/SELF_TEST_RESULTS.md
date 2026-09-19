# Orchestration verification — 2026-09-19

Scope: infrastructure only. No PPSSPP interaction, gameplay changes, research
delegation or substantive corpus reread. One real DeepSeek Explorer transport
response, mission orchestration-self-test-001. Other role combinations are
covered with deterministic fixtures, not additional API calls.

## Observed results

- PowerShell syntax and fixture checks PASS: immutable full report/hash,
  compact extraction, absent/null/oversized handoff rejection, partial outcome
  counts (1 success /1 failure /1 pending), legacy panel compatibility, checkpoint
  maximum. Reproduce with test-orchestration.ps1.
- Launcher recorded return at 2026-09-19T14:24:38.0220195Z; child started at
  14:24:39.1680038Z and completed at 14:24:46.2624412Z. Launcher process was absent
  at verification. Runner persisted WORKERS_COMPLETE / READY_FOR_PARENT, report,
  extracted handoff, aggregate, RESUME, marker and child outcome0.
- One compact status invocation after independent infrastructure work reported
  1 success /0 failed /0 pending. No parent polling loop or callback.
- Full report1176 bytes; aggregate926 bytes (one minimal role, below the usual
  three-role 2–5 KB target). No parent summary call.
- Parent-state snapshot SHA matches manifest, contains planned mission ID and
  predates child start. CODEX_HOME propagated as C:\Users\linki\.codex.
- Executing the existing hydration block in a separate process after clearing its
  inherited key successfully restored it from persistent User/Machine environment.
  Only booleans were recorded; no key or new API call.

Evidence: research/inbox/deepseek/missions/orchestration-self-test-001/
host-verification.json, key-hydration-check.json, launch.json, mission.json,
workers/_logs/explorer.status.json and PARENT_HANDOFF.md. Full diagnostics remain
local; status and compact evidence are versioned.

## Limits and post-test hardening

This demonstrates completion independent of launcher lifetime. Account quota was
not deliberately exhausted, the desktop application was not forcibly killed,
and OS restart survival is not claimed. External provider/network/OS failures
remain possible. No gameplay validation follows from this test.

After the live test, final-state publication was tightened to write the aggregate
with explicit final labels before publishing manifest completion; failed startup
now persists BLOCKED, and failure removes a misleading ready marker. Deterministic
syntax/fixture checks were rerun; no second live API call was required.

An old support mission receives only a pointer/UNKNOWN handoff; its research
reports remain untouched and unreviewed by this infrastructure task.
