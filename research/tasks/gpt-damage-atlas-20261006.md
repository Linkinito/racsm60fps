---
kind: protocol
title: "Owner mission: comprehensive weapons and damage-mechanism atlas"
date: 2026-10-06
authors: ["GPT (Codex)"]
status: complete
evidence: [OBSERVED, INFERRED, TESTED, UNKNOWN]
summary: "Deep offline analysis of all weapon families and damage recipients, including Clank, minigames, destructibles and instant-death paths."
systems: [weapons, damage, health, hazards, Clank, minigames, objects]
levels: [all]
variants: [A0, B, C]
related: [research/EVIDENCE_INDEX.md, docs/PUBLICATION_POLICY.md]
---

# Scope and authorization

Owner request2026-10-06: analyze in detail and as exhaustively as possible all
weapons and mechanics capable of damaging Ratchet, enemies, Clank, minigame
actors, static/dynamic objects, including instant-death. Subagents authorized.
Commit logical steps locally and publish curated project-authored findings to
GitHub main. Claude is unavailable until Wednesday evening.

Static/Ghidra ownership remains GPT; no live gameplay measurements are inferred
from Claude's absence. No emulator control, asset modification, build/install or
new function bytematching. Existing clean images, exports, stored maps and
targeted native registry/receiver/caller queries may be used read-only.

## Workstreams

1. Parent: common damage dispatch, player receivers, health/suppression/armor,
   hazards/instant-death, destructibles and coverage/reproduction/publication.
2. Read-only worker: every weapon family, rank/mod/child-effect contracts;
   reconcile accepted/rejected prior live evidence and identify narrow gaps.
3. Read-only worker: Clank/Giant Clank, Skyboard and other minigame routes;
   distinguish common functions from module-specific receivers and lethal paths.

Maximum two workers. They own independent read-only questions, do not edit any
source/document/runtime/project, and return evidence/provenance/UNKNOWNs. Parent
integrates their reports without duplicating delegated investigations.

## Deliverables and completion

New front-matter reports in research/v2/damage-atlas-20261006/, project-authored
coverage/contract JSON and reproducible offline method. Raw exports, call lists,
words and derived game data stay ignored in _local/. Cover every discovered
weapon, receiver family, hazard/death family and module domain; report unresolved
names, data initializers, indirect callers and runtime legality explicitly.
Each finding records module/function/field role, event versus recurring operation,
timing domain, interactions, contrary evidence and a falsifiable next measurement.

No fabricated completeness claim: separate documented mechanisms from unclosed
routes. Update EVIDENCE_INDEX and a compact CURRENT_STATE checkpoint. At quota
approximately10% remaining, stop research, preserve precise next actions, commit
the current logical findings and publish the curated allowlist. Public output
contains explanatory prose, methods and reviewed contracts only, no bulk game
listings, raw measurements, captures, extracted strings or opcode payloads.

Completion: integrated static dossier, all enumerated domains accounted for; transitive and scene-specific closure remains explicit UNKNOWN. No live test or gameplay-parity acceptance. Research stopped at the quota checkpoint; authored allowlist publication follows COVERAGE.md.
