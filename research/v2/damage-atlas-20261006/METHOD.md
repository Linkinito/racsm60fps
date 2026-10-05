---
kind: offline
title: "Damage atlas provenance and bounded reproduction method"
date: 2026-10-06
authors: ["GPT (Codex)"]
status: complete
evidence: [OBSERVED, TESTED, UNKNOWN]
summary: "Existing exports, clean module queries and a three-function read-only export were used; absent LEVEL_04/15/16 projects remain precise decompiler blockers."
systems: [damage, provenance, Ghidra]
levels: [LEVEL_01, LEVEL_04, LEVEL_10, LEVEL_15, LEVEL_16, LEVEL_22]
environment: "Offline Windows workspace, existing Allegrex runtime and saved projects; no reimport, rebuild, emulator or new bytematching"
related: [research/scripts/ghidra/ExportDamageSlice.java, research/v2/damage-atlas-20261006/REPORT.md]
---

# Source identity and method

The session resumed local v2-research at
`1bd11ffbe8b46a6ed10a1827625cdbd0940bcccf`. The tool/mission logical commit is
`c2183ac07be7804796609c5903f90ecc4258d551`. Two authorized read-only native
workers covered independent weapon and Clank/minigame questions; the parent
handled common receivers, armor, hazards and destructibles. No source edits
were delegated and no investigated scope was repeated for model consensus.

The principal existing LEVEL_01 decompilation corpus is
`research/v2/decomp-candidates/_local/20261001-mass/all/c/`, with instruction
exports and function metadata alongside it. Existing class registration evidence
is `research/v2/class-table/level01-classes.json`. Clean module source hashes and
content roles are retained by the module-map report; stored Claude bytematches
are evidence consumed here, not recomputed. Older reports remain unchanged.

| Source | SHA-256 / role |
| --- | --- |
| Clean LEVEL_01 | `d10a81d076fb44987a45314a020cda2f7e8b39f860b957911ca9365464676571` |
| Clean LEVEL_04 | `6896122ac19973e928303dc94c40fa309b5f06e5fef6ab14f624987035a4dc37` |
| Clean LEVEL_15 | `cebd5b53f4a7f0b42cc7aec7f7e2e13749089a3dd630a3af1fcccaf81748e70a` |
| Existing weapons/armor inventory | 25 ids, rank/mod definitions, initializer and armor contracts |
| Existing damage-health report | Instruction-reviewed common receiver and limited live provenance |
| Existing module-bytematch report | Module-specific address translation; absent/vacuous mappings kept explicit |

Targeted clean PRX reads and the existing `build-plugin-sites.py` relocation
helper resolve absolute globals when an instruction export carries segment-
relative HI/LO operands. A literal assembly operand is not automatically an
absolute data RVA. Cross-module behavior is only inferred where the stored map
has sufficient provenance; an EXACT row with zero agreeing callees does not
establish receiver semantics.

# New read-only Ghidra slice

`ExportDamageSlice.java` consumes expected source SHA, a bounded recipe, an
ignored output directory and `READONLY_DISCARD`. The caller must use existing
headless Ghidra with **`-readOnly -noanalysis`**. The script checks executable
SHA, Allegrex LE32, image base zero, 1..16 aligned entries inside .text and a
written entry-evidence statement. It can create ephemeral function/disassembly
metadata solely for the requested slice. It hashes every initialized memory
block before and after and rejects any difference. It exports C, instruction
text and a local manifest with hashes; it does not rename/annotate persistent
projects, match functions or alter game bytes.

The mode string alone is not enforcement of headless read-only mode. Both the
caller flags and successful before/after validation are required. Preserve
previous output; the exporter refuses to overwrite an existing manifest.

Reproduction command shape (use the installed runtime and existing project):

```text
analyzeHeadless <existing-project-directory> <existing-project-name>
  -process LEVEL_01.PRX -readOnly -noanalysis
  -scriptPath <repository>/research/scripts/ghidra
  -postScript ExportDamageSlice.java <expected-source-sha>
    <repository>/research/scripts/ghidra/recipes/damage-atlas-level01-001.json
    <repository>/research/v2/decomp-candidates/_local/<new-slice-directory>
    READONLY_DISCARD
```

TESTED here: the saved `PokitaruMass20261001` project exported `38540`, `31B64`
and `4C2C0` successfully. All **52 initialized blocks** had unchanged hashes.
Function count was 5049 before and after. The stdout contained
`DAMAGE_SLICE_COMPLETE`; there was no project-save success. The ignored output
is `.../_local/damage-atlas-20261006/level01-001/`. This verifies export
preservation, not gameplay parity.

| Function | Exported C SHA-256 |
| --- | --- |
| `38540` | `46d72e253c48e8377483a457fddaa8706a3cb5f7379770b9c6c9374828562663` |
| `31B64` | `8a51e1142b2951a1bac8ac41b94c74547b6e92d9179bb8e5cae473cb277885f8` |

The manifest additionally records all three instruction hashes, body bounds and
sizes, recipe hash and third C hash. These game-derived exports remain ignored
and are excluded from every commit/publication. The verification command below
checks them without printing or copying their contents into authored reports.

# Precise tooling blocker, not an environment rebuild request

The existing canonical Ghidra project did not contain root `LEVEL_15.PRX`.
Its read-only attempt failed before export. No LEVEL_15 decompilation is claimed.
Available saved projects inspected were Pokitaru, Quodrona, Frontend and existing
clock/animation research copies; a suitable saved LEVEL_04/15/16 program was not
located. No reimport, project recreation, version change or runtime installation
was performed. The LEVEL_04 and LEVEL_15 recipes preserve bounded future entries
from established descriptor/direct-caller evidence, without claiming execution.

This was the session's single substantial tooling detour. Existing canonical
instruction corpora and clean relocation-aware queries supplied the minigame
findings despite the decompiler blocker. Future authorization should first reuse
an owner-provided suitable existing program, or explicitly approve a bounded
import if none exists. Do not reclone/rebuild/reindex PPSSPP.

# Authored coverage and reproducibility

`research/scripts/build-damage-atlas.py` generates `coverage.json` from explicit
project-authored domain contracts, hashes the authored reports into
`provenance.json`, and optionally verifies the ignored slice's hashes and
unchanged blocks. It publishes no raw function bodies, words, call lists,
extracted strings or binary assets. Generated outputs are regenerated rather
than manually edited.

```text
python research/scripts/build-damage-atlas.py
python research/scripts/build-damage-atlas.py --verify-local
python tools/research/report_catalog.py check research/v2/damage-atlas-20261006/REPORT.md research/v2/damage-atlas-20261006/WEAPONS.md research/v2/damage-atlas-20261006/CLANK_MINIGAMES.md research/v2/damage-atlas-20261006/COVERAGE.md research/v2/damage-atlas-20261006/METHOD.md
```

Local verification requires the owner's lawful existing sources. Public users
can regenerate authored coverage/provenance without possessing game data.
Provenance hashes identify the exact checked files; neither hashes nor a
successful generator establish the correctness of an interpretation.
