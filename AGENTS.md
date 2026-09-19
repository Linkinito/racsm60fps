# Overcompensated V2 — agent rules

## Parent startup and checkpoint
Read only: (1) AGENTS.md, (2) CURRENT_STATE.md, (3) its active task.
Open deeper evidence only for a specific current question, through
research/EVIDENCE_INDEX.md. Do not routinely reread inventories, old experiments,
worker reports or legacy documentation. Before every substantial parent session
ends, update CURRENT_STATE.md: durable findings, changed/rejected hypotheses,
blockers, exact NEXT ACTION and exact next-session files. Prefer <=4 KB; max8 KB.
CURRENT_STATE is a checkpoint, not a history log. Verify actual Git HEAD on resume.

## Non-negotiable project rules
- Priority 0: original 30 FPS -> faithful 60 FPS behavioral parity (UCES00420).
  No silent rebalancing or optional Priority 2 features. Scope details:
  PROJECT_GOALS.md. A=original30, B=uncorrected60, C=candidate corrected60.
- A working patch, static match, runtime write, "felt correct", or model consensus
  does not establish gameplay parity. Record reproducible measurements, test
  environment, provenance, contradictions and missing evidence.
- Use OBSERVED, INFERRED, CORROBORATED, TESTED, UNKNOWN, REJECTED, SUPERSEDED
  precisely (docs/methodology/EVIDENCE_LEVELS.md). UNKNOWN beats guessing.
  Never silently promote evidence. Tentative names/fields remain tentative.
- Preserve useful history, negative results and uncertain legacy material.
  Tag legacy-60fps-pre-v2 is historical evidence; no cosmetic rewrites.
  Track migration in MIGRATION.md. Generated datasets are evidence, not canon:
  preserve methods/hashes and regenerate rather than manually edit them.
- Experimental patches: patches/experimental/. Validated: patches/validated/
  only after reproducibility, causal understanding, regression checks, documented
  evidence and environment. Prefer root causes; preserve superseded fixes.
- Never expose secrets in prompts, files, logs or reports. External workers are
  read-only. No concurrent source edits without isolation. Preserve original
  game assets; modify only for explicitly authorized experiments.
- Commit logical steps separately; separate infrastructure from research.

## Delegation and reading budget
Parent policy: GPT-6 Astra, Medium. Use existing external DeepSeek Explorer /
Mapper / Skeptic with distinct scopes; no native Codex/OpenAI research subagents.
For broad exploration: define question, persist state, launch detached workers
early, then do limited independent work or end. Never repeatedly poll workers.
One status check on a future session or explicit owner request is sufficient.
Before delegation, use only a few targeted substantial reads unless essential.
After delegation, read PARENT_HANDOFF.md first. Full report sections are exceptions
for disagreement, provenance, explicit handoff requests or evidentiary ambiguity.
Use scripts for counts/status/log aggregation. No parent-model summary calls.
Workers require no parent callback to finish. Preserve reports and failed scopes;
never restart completed investigations from memory after quota interruption.

## Language and detailed policy
Owner communication: simple French. Persistent artifacts, code comments, reports,
new identifiers and commit messages: English. Preserve legacy language and source
paths when migrating. Raw external reports stay in research/inbox/ until reviewed.
Detailed research requirements remain binding in docs/methodology/RESEARCH_POLICY.md;
consult relevant sections, not the entire file by default. Operational details:
docs/methodology/ORCHESTRATOR_POLICY.md and tools/agents/MISSION_FAILSAFE.md.
