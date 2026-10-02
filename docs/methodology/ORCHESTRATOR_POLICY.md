# Research ownership and backup policy

## Scope and ownership

Goal: faithful 30 FPS -> 60 FPS behavioral parity with reproducible evidence.
Owner decision, 2026-10-03, supersedes the former mandatory routing hierarchy:
GPT owns function decompilation and Ghidra annotations; Claude is the primary
in-game reference and owns gameplay experiments; DeepSeek is the backup.
This changes responsibilities, not the running model or installed configuration.
Do not claim a live model switch or rebuild the existing orchestration tools.
Research requirements remain in [RESEARCH_POLICY.md](RESEARCH_POLICY.md);
evidence meanings in [EVIDENCE_LEVELS.md](EVIDENCE_LEVELS.md).

## Primary responsibilities and backup gate

Use the following division of work:

1. **Deterministic script:** hashes, counts, diffs, numeric aggregation, trace
   parsing, status checks, file existence and repetitive transformations. Do not
   spend an LLM call on an answer a script can provide.
2. **GPT:** targeted static analysis, function decompilation, call/dataflow analysis,
   and Ghidra names, types and comments. Preserve binary/address provenance and
   mark tentative interpretations. Prepare concrete hypotheses and discriminating
   test requests from static findings; reconcile returned measurements with code.
3. **Claude:** primary live PPSSPP control, RAM/register/breakpoint work,
   savestate/input orchestration, gameplay changes within authorized experiments,
   A/B/C test design/execution and reproducible measurements. Record environment,
   inputs, patches, contradictions and missing evidence so GPT can use the results.
4. **DeepSeek backup:** use only for a recorded blocker, primary unavailability
   (including quota loss), or a justified independent second opinion. Existing
   detached read-only Explorer/Mapper/Skeptic roles remain available. Select only
   required scopes; the full trio requires a recorded justification. Broad mapping
   alone no longer requires automatic delegation to DeepSeek.

Luna remains optional bounded read-only support, normally 1–5 selected files,
using `luna_reader` / `luna_triage`. Prefer one; maximum two concurrent native
workers. GPT does not have to delegate its decompilation or annotation work.

Luna never controls PPSSPP, changes gameplay or files, declares TESTED, performs
exhaustive research, or duplicates the primary. After a worker owns a question,
GPT must not independently redo it. Arbitration may inspect the exact
evidence needed to resolve a material conflict; this is not a parallel remapping.
Luna is not a replacement for the detached DeepSeek quota failsafe.
Neither a static interpretation, an annotation, a working patch nor model
agreement establishes gameplay parity. Evidence promotion requires the project
criteria regardless of which primary produced the evidence.
Assign file/project ownership and isolate concurrent source or Ghidra project
writes; live gameplay ownership does not authorize unrelated repository changes.

## Existing optional-support configuration

`.codex/config.toml` declares the parent default and enables native agents with
`agents.max_concurrent_threads_per_session = 2`. The two role entries refer to
`.codex/agents/luna_reader.toml` and `luna_triage.toml`: model `gpt-5.6-luna`,
`model_reasoning_effort = "medium"`, `sandbox_mode = "read-only"`, approvals never.
Existing unrelated roles are preserved. Role prompts forbid further delegation,
live emulator/app access, file writes and evidence promotion.

The existing model/support defaults are preserved; they do not override the new
GPT/Claude/DeepSeek ownership or make Luna/DeepSeek mandatory.
These are project defaults for a trusted project, not a claim that a running
desktop task hot-reloaded its model or capacity. Reopen/start a task to load the
new configuration; no manual TOML editing or PPSSPP setup change is required.
If the host exposes a larger capacity in the current session, obey the project
limit manually and do not launch extra workers. Do not alter host/global settings.
Configuration lookup was delegated to one read-only Luna during this infrastructure
task; no substantive research mission was launched by the refactor.

Official references used for the schema:
[Subagents](https://learn.chatgpt.com/docs/agent-configuration/subagents) and
[Configuration Reference](https://learn.chatgpt.com/docs/config-file/config-reference).
The concurrency key excludes the parent and bounds simultaneous child threads;
it does not change external detached DeepSeek workers or account limits.

## Results, detours and PPSSPP source cache

Every substantial parent research session must produce at least one reproducible
measurement, confirmed live address/state, confirmed frequency/rate, falsified or
materially narrowed hypothesis, validated protocol, or precise blocker.
Infrastructure preparation alone is not a successful research session unless it
resolves a hard blocker. Do not promote evidence to meet this output requirement.

During an active experiment, allow at most one substantial infrastructure/tooling
detour. Persist and delegate additional detours; retain a concrete experimental
NEXT ACTION. Do not turn this exception into another architecture refactor.

Keep the existing internal PPSSPP copy as a persistent read-only source cache.
Without explicit owner authorization, do not reclone, rebuild, reinstall, duplicate
the environment, broadly reindex, upgrade or downgrade it. Default source lookup
is handled by GPT for a precise static question, with optional bounded Luna
support. Inspect only relevant files/functions and record source
version/hash; cached 1.19.3 material is not proof of active 1.20.4 semantics.

## Thin startup / reading budget

Read AGENTS.md, CURRENT_STATE.md (preferred <=4096 bytes, hard limit8192), then
only its active task. Verify Git branch/HEAD cheaply. Allow at most THREE additional
substantial targeted reads before narrowing the question or using bounded support.
If a DeepSeek backup
mission completed, read PARENT_HANDOFF.md first after startup. Full worker reports
and historical corpus are exception-only reads, never routine resume material.
Use research/EVIDENCE_INDEX.md to select precise sections. Do not routinely read
inventories, old experiments, full reports or V1 history. Parse raw traces
deterministically before review. Reference evidence; do not copy it into state.

## Backup launch, never poll

Once the backup gate is met, record why DeepSeek is needed, define a bounded
question and only the required worker scopes; persist
CURRENT_STATE with planned mission ID; launch detached workers early; record the
mission; do useful independent work or end. Launcher snapshots parent state
before any child starts and refuses a checkpoint missing the mission ID.
No repeated LLM polling. A future session or explicit owner status request uses
one compact status command. The cheap self-test may be checked once after
independent infrastructure work.
The launcher and internal panel require explicit `-Roles`; there is no automatic
trio. This refactor does not authorize a new substantive research mission.

## Handoff contract

Workers retain full English reports and append PARENT_HANDOFF_V1 JSON to the same
final response. The host extracts workers/<role>-handoff.json with report SHA256.
Fields: established, corroborated, inferred, contradictions, rejected, unknown,
top_hypotheses, best_discriminating_test, blockers, full_report_required.
Each is a nonempty string <=180 characters. Typical PARENT_HANDOFF.md target is
2–5 KB; exceptional evidence may exceed the target rather than lose contradictions.
Schema: tools/agents/prompts/handoff.md. No second model summary call.

Read PARENT_HANDOFF first. Open full sections only for material disagreement,
provenance verification, an explicit requested section or genuine ambiguity.
ESTABLISHED is a worker claim, not evidence promotion. The deterministic aggregate
preserves role attribution; it never votes or infers consensus. Malformed handoff
fails its worker scope while preserving the full report.

Legacy missions remain valid. Optional deterministic legacy handoffs contain
pointers and UNKNOWN, never invented summaries. Locate needed sections by headings.
Old READY_FOR_SOL, sol-review.md and SOL_REVIEW_COMPLETE remain readable; new
missions use PARENT names.

## Durable state and quota loss

Launcher persists task, parent snapshot, manifest and RESUME before Start-Process.
CODEX_HOME is resolved and propagated to children. Workers hydrate DEEPSEEK_API_KEY
from process then Windows User/Machine without printing it. Workers use read-only
sandbox with approvals disabled. Detached runner waits locally, retains reports,
status/logs, aggregates handoffs and writes the review marker and final state.
There is no parent callback. Parent quota does not gate completion. OS shutdown,
network/provider failure, process termination and provider quota remain external
failure modes; this is not a reboot-persistent service.
Preserve CURRENT_STATE and mission state before long launches. Continue to use the
existing detached implementation; no paid provider test, rebuild or new service is
needed for this routing update. A successful launch is not a successful analysis.

Only the runner writes mission.json after launch (atomic replacement); launcher
writes launch.json separately. Errors become WORKERS_FAILED/BLOCKED. Preserve
successful scopes. No automatic retry, duplicate mission or destructive Force
replacement. Inspect failed scope before retry. Compact status returns counts,
sizes, exit codes, timestamps, required-file presence and legacy compatibility.
Exit code is worker-wrapper outcome0/1, not necessarily native provider exit code.

## Session checkpoint / Git

Before every substantial parent session ends, update CURRENT_STATE with completed
work, durable next-action findings, changed/rejected hypotheses, blockers, exact
NEXT ACTION and required files. No historical log. Record actual HEAD after commit;
a commit cannot contain its own hash. A checkpoint-only follow-up working-tree
change is acceptable and must be reported. Commit infrastructure separately from
research. Never rewrite legacy history or push destructive main changes.
