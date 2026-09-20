# ACTIVITY_STATUS_PROTOCOL.md

Purpose: make future status output show what each DeepSeek worker is currently doing without parsing log tails.

This protocol applies to future `resume-*` runs and any new long-running static audit run.

## Worker activity file

Each worker SHOULD maintain:

`workers\_activity\<role>.activity.json`

Example:

```json
{
  "role": "mapper",
  "phase": "SHARD_ANALYSIS",
  "shard": 7,
  "inventoryRange": "INV-0151..INV-0175",
  "activity": "Tracing update callbacks for Pokitaru enemy objects and assigning A0/B0/B1/C1 timing models.",
  "detail": "Currently resolving shared-delta vs fixed-per-call movement for three descriptor-linked implementations.",
  "updatedAtUtc": "2026-09-20T22:00:00Z"
}
```

## Update rule

Rewrite the activity file whenever the worker changes meaningful subtask, for example:

- bootstrap source reconciliation;
- inventory import;
- shard N analysis;
- helper/dependency expansion;
- implementation fingerprinting;
- candidate patch synthesis;
- skeptic review;
- coverage closure;
- handoff writing.

Do not update it for every individual command.

Target granularity: one update every meaningful task change, generally every few minutes or at shard boundaries.

## Required fields

- `role`
- `phase`
- `activity`
- `updatedAtUtc`

Recommended:

- `shard`
- `inventoryRange`
- `detail`
- `mechanismId`
- `candidateId`

## Quota/resume

Before a quota stop, write:

```json
{
  "role": "mapper",
  "phase": "PARTIAL_QUOTA_STOP",
  "activity": "Stopped cleanly after shard 11. Next work is shard 12.",
  "nextShard": 12,
  "updatedAtUtc": "..."
}
```

The resume run must read this file before continuing.

## Compatibility

The enhanced PowerShell status scripts prefer `activity.json`.

If absent, they fall back to a heuristic reading of recent stdout/stderr lines, which is less reliable.
