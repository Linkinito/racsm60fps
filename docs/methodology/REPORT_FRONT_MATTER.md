# Report front matter

Adopted 2026-10-03 (owner decision), adapted from the knowledge-base format of
rehan-remade/universal-modder (review: research/inbox/RESEARCH_GITHUB_CLAUDE.md).

New research reports, live-test reports, session logs and registers start
with a small structured block. A generated catalog then lets agents filter
reports instead of reading the hand-written `research/EVIDENCE_INDEX.md`.
Existing reports are not rewritten. A front matter block may be added to an
older report only when that report is touched for a substantive reason.
`EVIDENCE_INDEX.md` stays the curated address book; the catalog does not
replace its judgments.

## Format

The block is the first thing in the file, between two `---` lines. Supported
syntax is a deliberate subset of YAML: one `key: value` per line; values are
plain text, quoted text, or an inline list `[a, b, "c d"]`. No nesting and no
multi-line values.

```text
---
kind: live
title: "Flamethrower latch/query counts, A0 vs C1"
date: 2026-10-04
authors: ["Claude (Opus 5.5)"]
status: active
evidence: [OBSERVED, TESTED, UNKNOWN]
summary: "Matched A0/C1 latch and accepted-hit counts on Pokitaru; DPS UNKNOWN."
systems: [Flamethrower, damage]
levels: [Pokitaru]
variants: [A0, C1]
environment: "PPSSPP 1.20.4 Vulkan, IG-v24, foreground, emuSpeed 0.93-1.00"
supersedes: []
related: [research/v2/damage-health-20261003/REPORT.md]
---
```

## Keys

Required:

| Key | Meaning |
| --- | --- |
| `kind` | `static`, `live`, `offline`, `survey`, `session-log`, `protocol` or `register` |
| `title` | Plain description of the question or result |
| `date` | `YYYY-MM-DD` of the work (not of the last edit) |
| `authors` | Agent and model, and humans if they want credit |
| `status` | `active`, `complete`, `blocked`, `superseded` or `invalid` |
| `evidence` | Levels used by the main claims (docs/methodology/EVIDENCE_LEVELS.md) |
| `summary` | One sentence: the result and its main limit |

Optional: `game` (default UCES00420), `systems`, `levels`, `variants`
(A0/B/C1... as defined in PROJECT_GOALS.md), `environment` (emulator, plugin
build, guards), `supersedes`, `superseded_by`, `related` (repository-relative
paths), `tags`.

Rules:
- `status` and `evidence` never promote a claim. A report whose live runs were
  invalidated is `invalid` even if its static part stands.
- When a later report supersedes an earlier one, add `superseded_by` to the
  old report and `supersedes` to the new one. Do not delete the old claims.
- Recurring traps go to `research/GOTCHAS.md` with a link to the report.

## Tool

```sh
python tools/research/report_catalog.py check            # every file with front matter
python tools/research/report_catalog.py check FILE...    # front matter required
python tools/research/report_catalog.py index            # regenerate the catalog
python tools/research/report_catalog.py search flamethrower --status active
python tools/research/report_catalog.py new --kind live --title "..." --author "Claude (Opus 5.5)"
```

`index` writes `research/REPORT_CATALOG.md` and `research/report_catalog.json`.
Both are generated: regenerate them, never edit them by hand.
