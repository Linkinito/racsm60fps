---
kind: register
title: "Damage continuation curated publication register"
date: 2026-10-06
authors: ["GPT (Codex)"]
status: complete
evidence: [OBSERVED, TESTED, UNKNOWN]
summary: "Explicit28-file project-authored publication selection, including the final decoy/TorsoB addendum; local evidence remains private and remote verification is recorded in the owner checkpoint."
systems: [publication, provenance, documentation]
related: [docs/PUBLICATION_POLICY.md, research/v2/damage-followup-20261006/publication-allowlist.txt]
---

# Selection and authorization

Owner explicitly requested detailed damage research, documentation, Git commit
and GitHub publication, then continued the mission. That authorization covers
this curated project-authored selection. It does not authorize publishing game
modules, C exports, listings, raw datasets, captures or the research branch.

Exact file-by-file allowlist: [publication-allowlist.txt](publication-allowlist.txt),
28 paths. It includes9 detail/integrated/method reports, hash-only provenance,
this register/allowlist, the task,11 native-window recipes and4 authored tools.
Two tools are pre-existing helper sources required by the inspector: their
inclusion makes the public method dependency chain explicit. No decoder vendor
or game assets are included. Raw-byte/source identity metadata is acceptable
provenance; it is not an embedded raw listing or measurement archive.

Local EVIDENCE_INDEX, GOTCHAS and CURRENT_STATE are updated separately; they are
not in this selection. The earlier atlas/history is preserved. Only main is
public; no merge/bulk push of v2-research is used.

Initial27-file publication was verified at main commit
`c726cdc5aed766f68b6ba57c460e265fdc962c0a`. The final decoy/TorsoB addendum
changes only the following nine allowlisted paths; no raw game content:

- research/scripts/build-damage-followup-provenance.py
- research/scripts/ghidra/recipes/damage-followup-decoy-ai-001.json
- research/tasks/gpt-damage-atlas-followup-20261006.md
- research/v2/damage-followup-20261006/REPORT.md
- research/v2/damage-followup-20261006/WEAPON_CHILDREN.md
- research/v2/damage-followup-20261006/METHOD.md
- research/v2/damage-followup-20261006/provenance.json
- research/v2/damage-followup-20261006/PUBLICATION.md
- research/v2/damage-followup-20261006/publication-allowlist.txt

# Required validation and publication procedure

1. Validate front matter on the explicit new reports/task; verify authored
   whitespace, source preservation, selected worker hashes and deterministic
   provenance regeneration.
2. Reuse the existing clean main publication checkout; fetch main and ensure
   current main includes the actual remote tip before applying the allowlist.
3. Copy only the committed allowlist paths from v2-research. Inspect the staged
   path list, then run `tools/publish/check_publication.py --staged` on main.
4. Research-tree warnings are accepted individually as authored findings,
   recipes/methods or provenance under the explicit owner request. Absolute
   personal paths, secrets, forbidden formats, raw dumps and all failures must
   be removed/resolved, not silently ignored.
5. Commit the curated main update, push only main, verify remote SHA equals
   local main and both working checkouts are clean. Record actual SHAs and
   final quota checkpoint in local CURRENT_STATE and the owner-facing result.

No live gameplay test, new patch, parity acceptance or whole-game completion
is claimed by publication. GitHub provides the authored findings and methods;
reproduction requires the privately held clean sources described in METHOD.md.
