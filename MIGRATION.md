# V1 → V2 Migration

## Purpose

The V2 project is a structured reconstruction of the existing Overcompensated research.

It is not a clean-room restart and it is not permission to discard old work.

The V1 state is permanently preserved by the Git tag:

`legacy-60fps-pre-v2`

The migration process determines which historical findings can be:

- directly retained;
- revalidated;
- reinterpreted;
- superseded;
- rejected;
- archived for future investigation.

---

## Migration rule

The V1 preserves what we discovered.

The V2 contains what we can explain.

If legacy material cannot currently be understood, do not discard it.

Mark it as unresolved and preserve its location.

---

## Migration states

### NOT_REVIEWED

Legacy material has not yet been examined for V2.

### INVENTORIED

The item has been identified and its purpose is approximately known.

### NEEDS_REVALIDATION

The legacy result is useful but should be experimentally or analytically checked again.

### MIGRATED

The useful knowledge has been transferred into the V2 structure.

### SUPERSEDED

The original information remains historically useful but has been replaced by a better explanation or implementation.

### REJECTED

The original hypothesis was later demonstrated to be wrong.

### LEGACY_ONLY

The material is intentionally retained only in the historical tree.

Typical examples:
- temporary experiments;
- obsolete build outputs;
- redundant snapshots;
- intermediate tooling.

### UNRESOLVED

The material may contain useful information but its meaning is not yet sufficiently understood.

Do not delete unresolved material.

---

## Initial migration inventory

| Legacy area | Current understanding | V2 destination | Migration state | Revalidation |
|---|---|---|---|---|
| Base 30 → 60 FPS timing change | Core framerate conversion | `docs/systems/timing/` | NOT_REVIEWED | Required |
| Pokitaru fixes | Several known local timing corrections | `docs/systems/levels/` | NOT_REVIEWED | Required |
| Ryllus fixes | Several known local timing corrections | `docs/systems/levels/` | NOT_REVIEWED | Required |
| Kalidon acid elevator | Known ×2 behavior at 60 FPS | `docs/systems/levels/` | NOT_REVIEWED | Required |
| Burner damage ×2 | Known gameplay timing issue | `docs/systems/weapons/` | NOT_REVIEWED | Required |
| Camera distance 1.90 | Known camera configuration result | `docs/systems/camera/` | NOT_REVIEWED | Required |
| Camera timing problems | Partially investigated | `research/hypotheses/` | NOT_REVIEWED | Required |
| Known timing globals | Multiple previously identified addresses | `research/globals/` | NOT_REVIEWED | Required |
| Timing call-site research | Large candidate inventory exists | `research/functions/` | NOT_REVIEWED | Required |
| PRX profiler | Existing instrumentation system | `tools/` / `docs/` | NOT_REVIEWED | Review |
| v0.6.x experimental builds | Historical implementation stages | legacy history | INVENTORIED | No |
| Menu experiments | Separate development branch/history | relevant system docs | NOT_REVIEWED | Review |
| Runtime traces | Historical evidence | `evidence/traces/` | NOT_REVIEWED | Selective |
| Static inventory CSVs | Generated research dataset | `research/` + generation docs | NOT_REVIEWED | Review |
| Existing control work | Input / second-stick research | `docs/systems/input/` | NOT_REVIEWED | Review |

This table is intentionally incomplete at project start.

The first V2 research task is to expand it.

---

## Migration procedure

For each legacy item:

### 1. Locate

Record:
- source path;
- relevant files;
- relevant historical version;
- related scripts or outputs.

### 2. Understand

Determine:
- what question was being investigated;
- what result was reached;
- what evidence existed;
- whether the result was measured, inferred, or merely assumed.

### 3. Classify

Assign an evidence status using:

`docs/methodology/EVIDENCE_LEVELS.md`

### 4. Preserve provenance

Record where the information came from.

When useful include:
- legacy file path;
- commit/tag;
- original filename;
- hashes;
- original addresses;
- date of experiment.

### 5. Revalidate

Important gameplay or timing claims should normally be revalidated against a controlled 30 FPS / 60 FPS baseline.

### 6. Migrate

Move the intelligible result into the appropriate V2 documentation or research area.

Do not necessarily move the original file.

### 7. Link

The new documentation should point back to the relevant legacy evidence when possible.

### 8. Update this file

Change the migration state and note the V2 destination.

---

## Information that should survive migration

Preserve whenever useful:

- function addresses;
- module identities;
- call sites;
- return addresses;
- constants;
- memory offsets;
- structures;
- timing values;
- test measurements;
- traces;
- known regressions;
- failed patches;
- rejected hypotheses;
- old symbol names;
- tooling;
- scripts;
- build methodology;
- level-specific discoveries;
- weapon behavior;
- camera behavior;
- input behavior;
- unusual PPSSPP observations.

---

## What should not automatically migrate

Do not copy into V2 simply because it exists:

- duplicate binaries;
- toolchains;
- savestates with no documented purpose;
- generated build outputs;
- redundant PRX copies;
- temporary logs;
- caches;
- external dependencies;
- obsolete working directories.

Important information from these items should be documented instead.

---

## Generated datasets

Historical generated inventories may remain frozen as V1 evidence.

For V2, document:

- generator script;
- input data;
- generation parameters;
- output format;
- SHA-256 where useful.

Prefer reproducible regeneration over manually maintained giant output files.

---

## Patch migration

Do not migrate an old patch merely because it worked.

For each patch establish:

- symptom addressed;
- original baseline;
- patched behavior;
- suspected mechanism;
- actual mechanism if known;
- side effects;
- whether a root-cause fix now exists.

Possible outcomes:

`MIGRATED`

`SUPERSEDED`

`REJECTED`

`UNRESOLVED`

---

## Research debt

Legacy discoveries that cannot yet be explained should be tracked explicitly.

Example:

| Item | Evidence | Problem | Next investigation |
|---|---|---|---|
| Address X | runtime observation | semantic role unknown | map readers/writers |
| Function Y | static inventory | suspicious fixed-step math | compare 30/60 traces |

Research debt is preferable to pretending uncertainty does not exist.

---

## Migration completion criterion

The legacy project does not need to disappear.

Migration is considered sufficiently complete when:

- all important V1 discoveries are inventoried;
- validated behavior has a V2 home;
- unresolved material is explicitly tracked;
- rejected hypotheses are preserved;
- important tests are reproducible;
- future contributors no longer need to understand the entire historical folder structure to work effectively.

The V1 tag remains permanently available even after migration is complete.
