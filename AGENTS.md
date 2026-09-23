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
- GitHub publication is curated: publish development progress and critical
  source/documentation only. Keep raw measurements, captures, experiment
  outputs and experimental artifacts local. Do not bulk-push the research
  branch; use an explicit file allowlist for each public update.

## Delegation and reading budget
Parent: GPT-6 Astra, Medium. Route before substantial research:
deterministic script -> read-only Luna for bounded <=5-file lookup/triage ->
detached DeepSeek for broad mapping/provenance/falsification -> Astra for live
PPSSPP, experiment design/execution, causal arbitration and evidence decisions.
Prefer one Luna; maximum two native workers. Use only required DeepSeek roles;
justify the full trio. No duplicated investigation after delegation.
Startup: AGENTS.md -> CURRENT_STATE.md -> active task; at most THREE additional
substantial targeted reads before routing. Completed mission: PARENT_HANDOFF first;
full reports/history only for a concrete exception. Never repeatedly poll workers.
Research sessions must yield experimental evidence, a narrowed hypothesis,
validated protocol or precise blocker; preparation alone needs a hard blocker.
At most one substantial tooling detour per experiment; persist/delegate more.
Keep PPSSPP source cache read-only; no reclone/rebuild/reinstall/environment
duplication/reindex/version change without owner authorization. Default lookup: Luna.
This is the final orchestration refactor; revisit only if a concrete experiment
proves necessity. Details and quota failsafe: docs/methodology/ORCHESTRATOR_POLICY.md.

## Language and detailed policy
Owner communication: simple French. Persistent artifacts, code comments, reports,
new identifiers and commit messages: English. Preserve legacy language and source
paths when migrating. Raw external reports stay in research/inbox/ until reviewed.
Detailed research requirements remain binding in docs/methodology/RESEARCH_POLICY.md;
consult relevant sections, not the entire file by default. Operational details:
docs/methodology/ORCHESTRATOR_POLICY.md and tools/agents/MISSION_FAILSAFE.md.
