# Parent orchestration policy

## Scope and model policy

Parent: GPT-6 Astra, Medium reasoning. This is the desired session configuration,
not a script-enforced change to the host model. Existing external DeepSeek
Explorer / Mapper / Skeptic handle independent research scopes; do not substitute
native OpenAI subagents. Astra arbitrates contradictions, reasons about causes,
designs experiments and reviews conclusions. Scripts count and aggregate.
Research requirements remain in [RESEARCH_POLICY.md](RESEARCH_POLICY.md);
evidence meanings in [EVIDENCE_LEVELS.md](EVIDENCE_LEVELS.md).

## Thin startup / reading budget

Read AGENTS.md, CURRENT_STATE.md (preferred <=4096 bytes, hard limit8192), then
only its active task. Verify Git branch/HEAD cheaply. Open at most a few targeted
substantial files before delegation unless an essential question requires more.
Use research/EVIDENCE_INDEX.md to select precise sections. Do not routinely read
inventories, old experiments, full reports or V1 history. Parse raw traces
deterministically before review. Reference evidence; do not copy it into state.

## Launch early, never poll

For broad research: define a bounded question and distinct worker scopes; persist
CURRENT_STATE with planned mission ID; launch detached workers early; record the
mission; do useful independent work or end. Launcher snapshots parent state
before any child starts and refuses a checkpoint missing the mission ID.
No repeated LLM polling. A future session or explicit owner status request uses
one compact status command. The cheap self-test may be checked once after
independent infrastructure work.

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
