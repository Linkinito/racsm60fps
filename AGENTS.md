# AGENTS.md

## Project mission

This repository serves two purposes:

1. Build and maintain accurate modifications for *Ratchet & Clank: Size Matters* (PSP, UCES00420), beginning with the 60 FPS project known as **Overcompensated**.
2. Preserve reusable reverse-engineering knowledge for future modding, emulation research, tooling, and a possible full decompilation project.

A successful patch is not enough by itself.

Important investigations should also preserve:
- what was observed;
- how it was observed;
- what was inferred;
- what was experimentally tested;
- what remains uncertain;
- what other reusable knowledge was discovered along the way.

The repository should remain understandable to contributors who did not participate in the original research.

---

## Project priority

Before starting any substantial task, read `PROJECT_GOALS.md`.

Priority 0 is 30 FPS → 60 FPS behavioral parity.

Reverse engineering, documentation and tooling exist primarily to help
achieve and validate that goal.

Do not prioritize optional user-facing features while Priority 0 remains
materially incomplete, unless explicitly requested by the project owner.

---

## Investigation escalation chain

The default investigation chain is:

1. The parent Sol agent defines the technical question.
2. Deterministic tools and existing evidence are checked first.
3. One or more DeepSeek workers may investigate independent aspects in parallel.
4. A DeepSeek skeptical reviewer should independently challenge important hypotheses.
5. The parent Sol agent reconciles the findings.
6. GPT-6 Astra may be used only for materially unresolved or architecturally difficult cases.
7. No model consensus constitutes validation.
8. Important gameplay claims ultimately require reproducible evidence or controlled testing.

For parallel investigations, workers should have distinct scopes rather than duplicate the same reasoning unnecessarily.

Priority remains 30 FPS → 60 FPS gameplay parity.

---

## Core principle

**No language-model output is automatically considered factual or validated.**

LLMs are research assistants, reviewers, and hypothesis generators.

Technical truth comes from evidence.

Preferred evidence includes:
- reproducible runtime tests;
- 30 FPS / 60 FPS comparisons;
- memory observations;
- instruction-level analysis;
- call-site analysis;
- deterministic scripts;
- hashes and binary comparisons;
- controlled patch experiments;
- repeated measurements;
- independently reproduced observations.

Agreement between several models may increase confidence but does not by itself make a claim `TESTED`.

---

## Evidence vocabulary

All important technical claims should use one of the evidence statuses defined in:

`docs/methodology/EVIDENCE_LEVELS.md`

The principal statuses are:

- `OBSERVED`
- `INFERRED`
- `CORROBORATED`
- `TESTED`
- `UNKNOWN`
- `REJECTED`
- `SUPERSEDED`

Do not silently promote an `INFERRED` result to `TESTED`.

---

## Preservation policy

Never delete useful historical research merely because a newer explanation appears better.

Old information should instead be:
- retained in Git history;
- marked `SUPERSEDED`;
- moved to `research/rejected/`;
- moved to `research/superseded/`;
- linked to the newer explanation.

A rejected hypothesis can remain scientifically useful because it prevents future researchers from repeating the same failed investigation.

Unknown or poorly understood legacy material must not be discarded solely because its current value is unclear.

---

## Legacy V1

The pre-V2 project is preserved by the Git tag:

`legacy-60fps-pre-v2`

The V1 tree is historical evidence.

Do not rewrite or clean the legacy history for cosmetic reasons.

Migration into V2 is tracked in:

`MIGRATION.md`

---

## Research workflow

New investigations should normally follow this sequence:

1. Define a narrow technical question.
2. Gather existing evidence.
3. Inspect relevant code, traces, memory, or binaries.
4. Produce explicit observations.
5. Separate observations from interpretations.
6. Identify alternative explanations.
7. Propose a falsifiable test where possible.
8. Perform or request validation.
9. Document reusable knowledge.
10. Update the migration or system documentation if appropriate.

Investigations should not jump directly from:
"this looks plausible"

to:
"this is how the game works."

---

## Agent roles

### Explorer

Typical model:
- DeepSeek Flash

Purpose:
- broad repository exploration;
- locating references;
- mapping functions and call sites;
- identifying candidate globals;
- classifying large result sets;
- reading repetitive assembly;
- comparing logs;
- generating research inventories.

Default permissions:
- read-only.

Explorer conclusions enter the project as research findings, not validated facts.

---

### Independent reviewer

Typical model:
- DeepSeek Flash in an independent context.

Purpose:
- analyze the same evidence without relying on the first agent's conclusion;
- identify unsupported assumptions;
- propose alternative explanations;
- search for counter-evidence.

Whenever possible, the reviewer should receive raw evidence rather than the first agent's reasoning.

---

### Technical reviewer

Typical model:
- GPT-5.6 Sol.

Purpose:
- investigate contradictions;
- review technically difficult findings;
- detect reasoning mistakes;
- evaluate competing explanations;
- design discriminating tests;
- review patches before validation.

The technical reviewer should actively search for reasons a proposed conclusion may be wrong.

---

### Escalation expert

Typical model:
- GPT-6 Astra.

Use only when:
- lower-cost agents disagree on an important issue;
- evidence supports several competing explanations;
- architecture-level reasoning is required;
- reverse engineering requires a substantial conceptual leap;
- a blocking issue remains unresolved after normal investigation.

Astra should not routinely reread bulk repository content that can be summarized or filtered beforehand.

---

## External agent reports

Raw external-agent reports belong in:

`research/inbox/`

They must not be copied directly into validated documentation without review.

A useful report should contain:

- task;
- conclusion;
- evidence;
- addresses and symbols involved;
- relevant callers/callees;
- memory/global accesses;
- alternative explanations;
- uncertainties;
- suggested falsification tests;
- reusable discoveries.

---

## Reverse-engineering documentation

When useful information about a function is discovered, document:

- address;
- module;
- tentative name;
- evidence status;
- known callers;
- known callees;
- important reads;
- important writes;
- relevant constants;
- suspected structures;
- timing behavior;
- affected gameplay system;
- associated patches;
- validation tests;
- remaining uncertainty.

Tentative symbol names must be clearly identified as tentative.

Addresses are identifiers, not explanations.

Prefer:

`UpdateAcidElevator`

over:

`FUN_0887A2C0`

only when the proposed semantic name is sufficiently supported.

If uncertain, retain both:

`FUN_0887A2C0 — tentative: UpdateAcidElevator`

---

## Function and structure naming

Do not invent authoritative names merely for readability.

Tentative names should remain replaceable.

Structure field names should distinguish between:

- known semantics;
- probable semantics;
- unknown offsets.

Example:

`+0x34 probable_velocity_x`

is preferable to:

`+0x34 velocity_x`

when the meaning has not yet been established.

---

## Patch policy

Experimental patches belong in:

`patches/experimental/`

Validated patches belong in:

`patches/validated/`

A patch should move to `validated` only when:

- its effect is reproducible;
- its causal relationship is sufficiently understood;
- relevant regressions have been checked;
- supporting research is documented;
- the test environment is recorded.

Prefer root-cause fixes over chains of compensating patches.

If an older patch corrected a symptom rather than the root cause, preserve its historical documentation and mark it `SUPERSEDED`.

---

## 30 FPS baseline

The original 30 FPS behavior is the primary gameplay reference unless there is evidence that the original behavior itself is defective.

For FPS-related research, record when applicable:

- duration;
- distance;
- movement speed;
- animation timing;
- cooldown;
- hit frequency;
- damage;
- particle lifetime;
- UI timing;
- camera behavior;
- physics behavior;
- number of updates or calls.

Comparisons should ideally include:

- original 30 FPS;
- unpatched 60 FPS;
- candidate patched 60 FPS.

---

## Generated inventories

Large generated datasets are evidence, not canonical explanations.

Whenever possible:
- preserve the generation method;
- preserve hashes;
- preserve important derived summaries;
- avoid manually editing generated inventories;
- regenerate rather than hand-fix generated output.

---

## Git policy

Commit logical research steps separately.

Good examples:

- `Document timing evidence levels`
- `Add legacy migration inventory`
- `Map Kalidon elevator update path`
- `Validate Burner damage timing at 60 FPS`
- `Replace local elevator compensation with root timing fix`

Do not combine unrelated investigations into one commit when avoidable.

Do not rewrite historical commits simply to make the history look cleaner.

---

## Safety rules for automated agents

Default external research agents to read-only access.

Do not allow multiple automated workers to modify the same source tree concurrently unless they use isolated worktrees or branches.

Do not expose API keys or secrets in:
- prompts;
- committed files;
- logs;
- research reports.

Do not modify original game assets unless the task explicitly requires an experiment and the original is preserved.

---

## Language policy

The project uses two languages for two distinct purposes.

### Communication with the project owner

All direct communication with the project owner must be in **French** in a relatively simple manner as the owner knows little about reverse engineering but still knows a little bit of basics about programming.

This includes:

* explanations;
* questions;
* progress updates;
* summaries presented in chat;
* requests for manual tests;
* descriptions of problems or proposed next steps.

Technical vocabulary may remain in English when it is the standard terminology or when translating it would reduce precision. However think of anyone that could take the project with the same level of knowledge as the owner.

### Persistent project artifacts

All persistent technical artifacts created for the project must be in **English**.

This includes:

* research reports;
* investigation notes;
* reverse-engineering documentation;
* evidence records;
* experiment reports;
* generated summaries;
* agent reports;
* schemas;
* structured datasets;
* trace annotations;
* tool documentation;
* source-code comments;
* newly created README files;
* commit messages.

Unless there is a specific reason otherwise, newly introduced identifiers, tentative function names, structure-field names, filenames, and directory names should also use English.

### Legacy material

Do not translate or rewrite legacy files merely to enforce this language policy.

Historical material must remain in its original form unless migration or documentation work explicitly requires a translated or normalized representation.

When legacy French material is migrated into V2 documentation:

* preserve the original source path;
* write the new V2 documentation in English;
* preserve technical meaning rather than performing a literal translation.

### Agent output

External or delegated agents must produce their persistent reports in English even when the task was requested in French.

The parent agent should summarize or explain those results to the project owner in French.

In short:

**Conversation with the owner: French.**
**Project knowledge and persistent artifacts: English.**

---

## Final research objective

A future researcher should be able to answer:

- What was changed?
- Why was it changed?
- What evidence showed the original problem?
- What evidence supports the fix?
- Which assumptions remain uncertain?
- Which game systems were discovered during the investigation?
- How can the result be reproduced?

If a patch works but none of these questions can be answered, the investigation is not finished.

