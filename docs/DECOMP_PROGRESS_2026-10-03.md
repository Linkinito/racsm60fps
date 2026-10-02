# Decompilation progress — 2026-10-03

Scope: UCES00420 original30 -> faithful60 behavioral parity. These are static
research results, with offline preservation checks. No new gameplay measurement
or validated patch is established by this update.

## Damage, health and equipment

A29-function LEVEL_01 slice connects projectile damage dispatch, player health,
equipment reduction and the post-hit suppression counter. A further five-entry
slice reviews weapon-rank selection, including four additional functions.

- **OBSERVED:** equipment contributions reach the direct player health
  subtraction. The earlier blanket inference that worn armor was ornamental
  is **REJECTED**. Named piece/set mappings and live effectiveness remain
  **UNKNOWN**.
- **OBSERVED:** the player post-hit counter decrements inside player substeps.
  **INFERRED:** original30 with two eligible substeps and candidate60 with one
  have the same nominal decrement rate. A blanket timer rescale is not justified
  by this path. Actual hit-acceptance boundaries need controlled measurements.
- **OBSERVED:** Flamethrower updates prepare a pending byte; an animation
  callback consumes it after skeleton work and issues damage queries.
  **INFERRED hypothesis:** the original's two updates can coalesce into one
  query, while the candidate's single update is consumed every60FPS outer frame.
  Preserved weapon-update cadence can coexist with doubled damage-query cadence.
  Target acceptance, collision eligibility and actual DPS remain **UNKNOWN**.
- **OBSERVED:** a shared weapon-rank setter permits eight rank values. Four
  exploratory saved-image scalar samples do not cover all permitted indices
  and do not establish actual damage. The active index, loaded scalar and its
  initialization writer still need runtime binding.
- A bounded scan of relocated static data found no aligned pointer-word match
  into the requested damage-table range. This negative result does not exclude
  computed addresses, external writers or runtime initialization.

## Tremblator

A ten-function slice shows particle callback replacement after generic
initialization. The current initializer-only callback hook is **INFERRED** to
be bypassed on these paths. Final callback routing and entity/ray/segment
ordering must be traced before any visual-wave parity claim. Offline lifetime
models are scheduling hypotheses, not gameplay validation.

## Preservation and next measurements

**TESTED offline preservation:** the original Ghidra project remains untouched
at the code-analysis level, and all36 initialized memory-block hashes match the
annotated local copy. Reviewed comments and primary symbols survive reopening;
repeat annotation passes append no duplicates. The original game module is
unchanged. Raw decompilations, databases, memory captures and experimental
recipes stay local; only this reviewed synthesis is published.

Next controlled measurements are the active damage-record/index and writer,
Flamethrower update/query/accepted-hit ratios, player hit-suppression boundaries,
equipment reduction and Tremblator callback/lifetime traces. Match scene,
weapon/upgrade, enemy, profile, measured FPS, clock and foreground state.
Homologous code must be checked before transferring LEVEL_01 findings to other
levels, including the earlier Mungo damage observation.

## RAM capture decision

Full RAM dumps on every level are not a prerequisite for static decompilation.
Capture the active objects, configuration records and callback pointers needed
for a defined runtime question. Cadence and parity require timestamped traces
and matched original30 / uncorrected60 / candidate60 measurements. See
[RAM capture strategy](RAM_CAPTURE_STRATEGY.md).

This update was closed at the owner's approximately10%-remaining five-hour
quota checkpoint. Detailed local research retains provenance, hypotheses,
negative results and exact next actions; no research branch is published in bulk.
