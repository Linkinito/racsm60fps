# Overcompensated V2 — agent rules

## Parent startup and checkpoint
Read only: (1) AGENTS.md, (2) CURRENT_STATE.md, (3) its active task.
Open deeper evidence only for a specific current question, through
research/EVIDENCE_INDEX.md. Do not routinely reread inventories, old experiments,
worker reports or legacy documentation. Before every substantial parent session
ends, update CURRENT_STATE.md: durable findings, changed/rejected hypotheses,
blockers, exact NEXT ACTION and exact next-session files. Prefer <=4 KB; max8 KB.
CURRENT_STATE is a checkpoint, not a history log. Verify actual Git HEAD on resume.

Owner quota rule, 2026-10-03: check the account's remaining five-hour Codex quota
at session checkpoints. At approximately10% remaining, stop research, summarize
the work, update the checkpoint and relevant documents, commit logical steps,
and publish a curated project-authored file allowlist to GitHub main. This does
not authorize bulk publication of v2-research or any game-derived raw evidence.

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
- Never expose secrets in prompts, files, logs or reports. Detached research
  workers are read-only; Claude owns authorized live gameplay experiments.
  No concurrent source edits without isolation. Preserve original
  game assets; modify only for explicitly authorized experiments.
- Commit logical steps separately; separate infrastructure from research.
- GitHub publication is curated: publish development progress and critical
  source/documentation only. Keep raw measurements, captures, experiment
  outputs and experimental artifacts local. Do not bulk-push the research
  branch; use an explicit file allowlist for each public update.
- Never commit game-derived content on any branch: game PRX/ISO, SAVEDATA,
  memory captures, disassembly listings, string dumps, zips of those.
  v2-research is local-only; only main is public. docs/PUBLICATION_POLICY.md.
  Before every main push run tools/publish/check_publication.py --staged.
- Before live experiments, probes or patches read research/GOTCHAS.md; add
  new traps there. New reports start with front matter
  (docs/methodology/REPORT_FRONT_MATTER.md); do not rewrite old reports.

## Research ownership and reading budget
Owner decision, 2026-10-03: GPT owns function decompilation and Ghidra annotations;
Claude is the primary in-game reference and owns gameplay experiments, PPSSPP
control and reproducible A/B/C measurements. DeepSeek is the backup, not a routine
stage. Use it for an explicit blocker, unavailable primary or justified second
opinion; record the reason and use only required read-only roles.
Use deterministic tools for mechanical work. GPT handles its static research
directly; Luna is optional bounded read-only support, not a mandatory route.
Prefer one native worker if needed; maximum two. No duplicated investigation
after delegation. No automatic DeepSeek trio.
Static findings and live measurements must retain provenance and uncertainty;
neither role alone nor model agreement establishes gameplay parity.
Startup: AGENTS.md -> CURRENT_STATE.md -> active task; at most THREE additional
substantial targeted reads before narrowing the question or using bounded support.
Completed backup mission: PARENT_HANDOFF first;
full reports/history only for a concrete exception. Never repeatedly poll workers.
Research sessions must yield experimental evidence, a narrowed hypothesis,
validated protocol or precise blocker; preparation alone needs a hard blocker.
At most one substantial tooling detour per experiment; persist/delegate more.
Keep PPSSPP source cache read-only; no reclone/rebuild/reinstall/environment
duplication/reindex/version change without owner authorization. GPT may perform
targeted source lookup for its static question; bounded support is optional.
Preserve the existing tools/configuration; this ownership change does not require
another infrastructure refactor. Details and backup failsafe:
docs/methodology/ORCHESTRATOR_POLICY.md.

## Language and detailed policy
Owner communication: simple French. Persistent artifacts, code comments, reports,
new identifiers and commit messages: English. Preserve legacy language and source
paths when migrating. Raw external reports stay in research/inbox/ until reviewed.
Detailed research requirements remain binding in docs/methodology/RESEARCH_POLICY.md;
consult relevant sections, not the entire file by default. Operational details:
docs/methodology/ORCHESTRATOR_POLICY.md and tools/agents/MISSION_FAILSAFE.md.
