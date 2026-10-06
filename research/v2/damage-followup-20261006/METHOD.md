---
kind: offline
title: "Damage follow-up method: bounded native reads and public hash-only provenance"
date: 2026-10-06
authors: ["GPT (Codex)"]
status: complete
evidence: [OBSERVED, TESTED, UNKNOWN]
summary: "Reproduced selected native windows against clean source hashes, with instruction text and raw tables retained locally; static semantics and gameplay acceptance remain distinct."
systems: [methodology, provenance, static-analysis, publication]
levels: [LEVEL_01, LEVEL_04, LEVEL_15, LEVEL_16, LEVEL_22, LEVEL_24]
related: [research/scripts/inspect-damage-routes.py, research/scripts/build-damage-followup-provenance.py, research/v2/damage-followup-20261006/provenance.json]
---

# Scope and evidence handling

Parent owns GCS health/state controller, Sharkagator/grind/state-duration and
Skyboard movement. Two owner-authorized read-only workers own MP/LEVEL04
consequences and weapon children/GCS source families. Parent writes integration.
No concurrent source edits, game writes, live experiments, emulator control,
function matching/census, new Ghidra import, reindex, installation or rebuild.
The pre-existing saved-program absence remains a decompilation blocker; native
reads and PSP relocation resolution can still close causal questions.

OBSERVED means exact reviewed code/data behavior. Independent binding/consumer
paths can CORROBORATE a role such as GCS health or Port quota. Names, wall time,
unobserved indirect consequences and retail result meanings stay INFERRED or
UNKNOWN as each report states. TESTED here refers to offline source preservation,
recipe/metadata regeneration and checked input identity, never live parity.

# Bounded native inspector

`inspect-damage-routes.py` reuses existing `build-plugin-sites.py::Elf` and
`pair_address`, and `build-object-disasm-corpus.py::load_capstone`. Installed/
vendored Capstone5.0.7 was retained. Each4-byte instruction is independently
decoded; unsupported Allegrex/VFPU words are marked UNDECODED, not a silent end
of the function. Maximum32 explicit windows per recipe, maximum16384 bytes per
window, aligned known entry/review bounds. Windows are not inferred universal
function extents. Raw source SHA is checked before/after each invocation.

HI16/LO16 resolution verifies instruction/register/relocation relationships and
referenced PT_LOAD segment; raw addends are not module RVAs. R_MIPS32 pointer
tables use stored word plus the referenced segment RVA. Original byte hashes
concatenate unmodified little-endian `Elf.word()` bytes, without relocation
masking. This differs from hashes of decoded text or normalized code matching.

Raw instructions, resolved table contents and manifests are under ignored
`research/v2/decomp-candidates/_local/damage-followup-20261006/`. Existing output
manifests cannot be overwritten. Adaptive earlier hazards001..004/Skyboard001..
003 remain useful local history; the public summary selects only final recipes.

# Reproduction register

Recipes are in `research/scripts/ghidra/recipes/`:

| Recipe suffix | Final local folder | Windows | PSP references | Question |
|---|---|---:|---:|---|
|gcs-001|gcs-001|4|5|four virtual states/root binding|
|gcs-002|gcs-002|11|10|loss/healing/protection/refill/state3|
|hazards-001|hazards-005|15|5|Shark/grind/state-duration|
|mp-001|mp-003|22|5|MP receiver/turret/respawn and sampling initializer|
|skyboard-001|skyboard-004|6|7|mine multiplier/impulse/age producer|
|arena-001|arena-002|31|6|Toss/Survival/Mine/flinger and bounded outcome-reader rejection|
|miniturret-001|miniturret-001|9|0|native Ball/Turret/Manager/Rocket chain|
|children-001|children-002|5|0|ElectroBall/decoy ABI and shared spatial replacement|
|gcs-sources-001|gcs-sources-001|13|0|five producer bodies and supporting initializer/contact windows|
|roster-001|roster-002|4|0|VehicleController/flinger registration and complete192E78|

These120 windows include overlaps and context; they are not120 distinct complete
functions, and the38 references are not a global reference census. Six clean
source hashes and each window/method/recipe hash are in provenance.json.

For each row, run the existing inspector with full recipe name
`damage-followup-<suffix>.json` and the corresponding local output folder:

```powershell
python research/scripts/inspect-damage-routes.py research/scripts/ghidra/recipes/damage-followup-arena-001.json research/v2/decomp-candidates/_local/damage-followup-20261006/arena-002
python research/scripts/build-damage-followup-provenance.py
```

On a fresh authorized evidence checkout, use the registered folder names. If
that manifest already exists, preserve it; choose another local folder only by
an explicit documented generator selection. Private clean modules and existing
C inputs are prerequisites; they are not included in GitHub. The public tools
do not retrieve game assets or install dependencies. The loader can use an
already-installed Capstone or the existing private legacy vendor path.

# Worker evidence and completeness controls

Shock/decoy C hashes: fourteen decisive existing files are verified against worker
hashes by the public provenance generator. Other scoped C entries are listed in
WEAPON_CHILDREN.md; the old all/index and class-table provenance remain local.
Mini nine original native windows are reproduced rather than dumping functions.
LEVEL24's empty identity class-list is not promoted to a class census.
Integration mechanically cross-checked21 decisive original-window hashes
against worker values: all9 Mini windows, all5 GCS producer bodies and7 Arena
payload/destructor/full-update/negative-reader windows. All matched. This checks
identity/bounds, not independent semantic agreement or gameplay acceptance.

Arena's full SurvivalBot update182AA0..184534 contains1701 instructions, unlike
the prior truncated1024-instruction canonical listing. Complete callback,
destructor and state-setter reads closed resolution accounting; transitive
interaction/motion helpers remain semantically incomplete. Existing canonical
descriptor table input SHA was
`7fcdba08f17f640020cd38fca7fed4ce3ad6f098c4151c604be09a8338ab172e`.

MP reproduction preserves its original eight-instruction **gapF31B0..F31D0**.
Positive HP100/transform/staging writes in surrounding respawn windows remain
valid, but the full F2F4C body is not claimed newly read. Packet/score/helper
findings came from the worker's additional bounded direct-callee reads; the21
main-window recipe is not a claim to include every such body. Existing map
hash/provenance are in MULTIPLAYER.md. No new module matching was performed.

Old descriptor anchors can be one word before the actual name pointer and
contain ordinary scalars. Reports label coordinate conventions explicitly.
Skyboard legacy24E17C/184 coordinates failed direct clean-file backing;
native pairs positively resolve23E17C/184. GCS3FB950 table is a relocated
address, not its raw PSP addend. Never repair these by assuming all offsets
share one coordinate convention.

# Public provenance and validation

`build-damage-followup-provenance.py` reads an explicit manifest allowlist,
checks clean source/current method/recipe identity and fourteen reviewed C hashes,
then writes only source/method/recipe hashes, window ranges and byte hashes.
Instruction text, native words, table entries, strings, captures and raw outputs
are excluded. Authored method/recipe hashes normalize CRLF toLF; game/source
and C evidence hashes preserve original bytes. Regenerate instead of editing
provenance.json manually.

Front matter is validated with the existing report_catalog checker on the
explicit new-report list. Whitespace checks cover authored diffs. Publication
uses a separate existing main checkout and explicit file allowlist after staged
publication checker, preserving the local-only research branch and raw data.
Research-path warnings are reviewed under the owner's explicit GitHub request;
any failure must be resolved before push. No broad test suite or live parity
claim is implied by these document/tool checks.
