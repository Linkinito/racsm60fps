# SOURCE_PRIORITY.md — exhaustive static audit

This hierarchy is specific to STATIC-60FPS-COMPLETE-AUDIT-001.

## Tier 0 — current truth and chronology

Read first:

1. `research\EVIDENCE_INDEX.md`
2. `research\checkpoints\2026-09-20\CURRENT_STATE_complete_2026-09-20.md`

Use CURRENT_STATE as the canonical definition of:
- project objective;
- A0/B0/B1/C1 architecture;
- accepted/rejected static architecture;
- address-mapping rules;
- evidence-state vocabulary.

Use EVIDENCE_INDEX as the more current address book for later evidence added after the checkpoint.

If a newer dated EVIDENCE_INDEX entry contradicts CURRENT_STATE's experiment-status prose, preserve the contradiction and use the newer evidence only for the exact proposition it tested.

Example:
CURRENT_STATE says no valid A0/B0 measurement had completed, while EVIDENCE_INDEX later records a bounded A0/B0 player-loop true-stop comparison.

Do not rewrite historical checkpoint text.

## Tier 1 — canonical 534-name register

Primary:

- `research\v2\c1-residual-timing-atlas\c1-residual-timing-atlas.csv`
- `research\v2\c1-residual-timing-atlas\C1_RESIDUAL_TIMING_ATLAS.md`
- `research\v2\c1-residual-timing-atlas\family-summary.json`
- `research\v2\c1-residual-timing-atlas\FORMAL_TIMING_QUANTIFICATION.md`
- `research\v2\c1-residual-timing-atlas\POKITARU_PRE_RUNTIME_STATIC_REFINEMENT.md`
- `research\v2\c1-residual-timing-atlas\pokitaru-representative-refinement.csv`
- `research\v2\c1-residual-timing-atlas\pokitaru-representative-static-extract.json`

The current evidence index describes a 538-name structured corpus and a 534-name canonical union.

Use the 534-name union as the immutable minimum coverage register.

Do not rebuild this register from old raw inventories unless the current atlas is missing/corrupt or a specific provenance dispute requires it.

## Tier 2 — accepted static architecture

- `research\v2\ghidra-timing-findings-2026-09-20.md`
- `research\v2\timing-domains.md`
- `research\v2\hypotheses\player-clock.md`
- `research\v2\pokitaru\player-address-evidence.json`
- `research\v2\pokitaru\player-clock-socle-map.md`
- `research\v2\pokitaru\socle-callers.json`
- `research\v2\pokitaru\socle-dataflow.asm`

Use only relevant sections.

Do not turn accepted scope-limited findings into universal rules.

## Tier 3 — parent-reviewed DeepSeek research

Prefer parent-reviewed/handoff artifacts before full worker reports.

### timing-atlas-global-001

Priority:
- `parent-review.md`
- `PARENT_HANDOFF.md`
- `parent-static-checks.json`
- `READY_FOR_PARENT_REVIEW.md`
- `NEXT_SESSION.md`

Only open full worker reports for specific tables/provenance:
- Explorer: class registry / module constant census
- Mapper: dispatch/call graph/homology
- Skeptic: byte-level falsification/scanner pitfalls

### timing-domains-crosslevel-001

Prefer:
- `parent-review-crosslevel.md`
- `PARENT_HANDOFF.md`
- `RESUME.md`
- `workers\panel-summary.json`

### player-clock-consumer-map-001

Prefer:
- `parent-review.md`
- `PARENT_HANDOFF.md`
- `READY_FOR_PARENT_REVIEW.md`

### player-clock-delta-producer-001

Prefer:
- `parent-review.md`
- `PARENT_HANDOFF.md`
- `READY_FOR_PARENT_REVIEW.md`

## Tier 4 — V1 parity provenance

Use when current atlas needs original evidence/provenance:

- `research\inbox\deepseek\missions\v1-parity-inventory\sol-review.md`
- `research\inbox\deepseek\missions\v1-parity-inventory\reconciled-items.csv`
- `research\inbox\deepseek\missions\v1-parity-inventory\parent-checks.json`
- `research\inbox\deepseek\missions\v1-parity-inventory\parent-socle-context.asm`

Do not reopen `legacy-v1-inventory.md` merely to reconstruct the current corpus.

Open legacy source only for a specific unresolved discrepancy.

## Tier 5 — existing runtime evidence, read-only historical use

DeepSeek must NOT perform runtime work.

It may use concise existing reports as PRIOR_RUNTIME / TESTED evidence for their exact scope.

High-value examples from EVIDENCE_INDEX:

- `research\live-tests\pokitaru\waterfall-001\a0-owner-session\A0_WATERFALL_REPORT.md`
- `research\live-tests\pokitaru\waterfall-001\c1-owner-session\C1_WATERFALL_REPORT.md`
- `research\live-tests\pokitaru\player-clock-001\A0_B0_2FCFC_STOP_COMPARISON.md`
- `research\live-tests\pokitaru\player-clock-001\b1-20260920-owner-session\B1_REPORT.md`
- `research\live-tests\pokitaru\player-clock-001\c1-20260920-owner-session\C1_REPORT.md`

Read these only when they directly constrain a mechanism being analyzed.

Never recursively ingest the surrounding probe/raw directories.

## Bootstrap exclusions

Do not bulk-read:

- `**\mission-run.stdout.log`
- `**\mission-run.stderr.log`
- `**\workers\_logs\**`
- `**\probe-*\**`
- `**\inspection-*\**`
- `**\local\**`
- raw `.bin` RAM/memory files
- save snapshots
- staging save directories
- copied PPSSPP source-cache trees
- debugger raw protocol captures

These are provenance fallback sources only.

## Current mission output

Do not treat current mission outputs as independent evidence.

`reports\STATIC-60FPS-COMPLETE-AUDIT-001\`

may be read for resume/progress/reconciliation only.

## Evidence provenance fields

For imported findings record:

- source_path
- source_kind: STATIC / PRIOR_RUNTIME / HUMAN_OBSERVATION
- evidence_state
- previous_confidence if any
- independently_rechecked: YES / NO
- scope
- contradictions

## Conflict policy

When sources conflict:

1. preserve both;
2. determine whether one is chronologically newer;
3. determine whether scopes differ;
4. prefer primary static evidence for static claims;
5. prefer controlled runtime evidence for measured cadence in its tested scope;
6. never extrapolate scope silently;
7. write unresolved conflicts to `uncertainties.md` or `review\conflicts.md`.

## Owner override

CURRENT_STATE previously recommended not returning to broad per-class static reverse engineering before runtime validation.

For this mission only, the owner explicitly overrides that workflow priority.

The exhaustive static audit is intentional.

Technical evidence from CURRENT_STATE remains authoritative subject to newer evidence.
