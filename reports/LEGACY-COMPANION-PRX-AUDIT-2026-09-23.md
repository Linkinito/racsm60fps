# Archived C companion PRX — bounded source audit

Date: 2026-09-23. Scope: a read-only lookup in the archived
`development-v0.6.4-no-menu/sources/profiler` source tree. These are OBSERVED
source properties, not newly TESTED gameplay behavior. The relevant files are
under `01-Travail-et-profil-PPSSPP/Overcompensated-Reprise-2026-09-14/`.

## What already exists

- Module detection is runtime based. `psp_plugin_runtime.c:678-735` enumerates
  PSP modules, selects the exact `RCSM_LEVEL_MODULE_NAME`, validates its text
  address/size and rejects ambiguous matches. `:738-797` computes the base
  delta and matches relocated fingerprints; fallback scanning is only used
  when the module API fails. `:783-791` checks the relocated PPSSPP marker.
- `global_60fps` is a selectable configuration mode, while `detect_only` is
  the default (`psp_plugin_runtime.c:231-243`, `:534-559`). The FPS choice
  stores requested, selected and applied values and resets on module exit
  (`rcsm_fps_choice.h:4-9`, `rcsm_fps_choice.c:3-24`).
- The C dispatcher already selects a profile, relocates it, applies policies
  and selects module-specific assembly hooks (`psp_plugin_runtime.c:903-923`,
  `:1336-1391`). Its hook map explicitly covers indices 1–10, 15 and 21–24.
  Installation suspends dispatch, checks original words, prepares corrections,
  writes redirects and patches, then confirms the target rate (`:1432-1497`).
- Full patches are module-indexed tables (`rcsm_full_patch.h:4-50`) with at
  most 192 words and eight caves per descriptor. The preparation validates
  relocated jump reachability; preflight checks originals; installation
  verifies writes and rolls back on failure (`rcsm_full_patch.c:22-64`,
  `:104-126`). Continuous entries are maintained only under a narrow word
  condition (`:84-102`).
- Unresolved, ambiguous, foreign or changed words fail closed. Activation
  waits for three stable polls and resets on module transition/reload
  (`psp_plugin_runtime.c:1730-1792`, `:1802-1827`).

## Compiled-profile reconciliation

`generated/wrapper_profiles.generated.c:593-612` declares exactly 15 profile
records (493 total callsites): indices 1–10, 15 and 21–24. The separate
`module_fingerprints.csv:1-16` lists the same keys with one reference runtime
word per key, and marks 15/21 equivalent. It contains no PRX SHA-256. The
current 21-file BIN inventory has a matching tracked reference hash for all
15 profile names. FRONTEND and `LEVEL_16`–`LEVEL_20` have no compiled profile,
detection/callsite table or hook target; these six also lack a tracked vanilla
reference in the current inventory. A name match plus a tracked PRX hash does
not prove that an archived runtime anchor still matches after loading, nor
that a game correction is behaviorally faithful.

## Gap against the current goal

This is already **one C companion PRX with centralized profile selection**.
The five Lvl3Elevator edited game PRXs are isolated experimental images, not
the intended final distribution format. The companion still relies on
compiled profile and hook tables; it does not derive coverage for all current
BIN images or 538 static class leads. Separate assembly hook symbols remain
(`psp_plugin_runtime.c:169-198`, `:903-921`). Its full-patch table is bounded
to `full_layers=15`, and class-level correction coverage cannot be inferred
from mode selection or an installed hook.

Historical `global_60fps` policy excludes two Giant Clank module indices, 15
and 21, after an archived crash claim (`psp_plugin_runtime.c:1350-1361`). The
source exclusion is OBSERVED; an intrinsic impossibility or a current crash is
UNKNOWN. The new owner save makes both Giant Clank levels reachable for future
regression checks, but access and behavior have not been tested in this audit.
Removing this guard without diagnosis would be premature.

## Design decision and next measurement

Retain the source's useful resolver, identity guards, stable-module check and
transactional rollback. Generate a module descriptor registry from verified
image fingerprints and relocation metadata; each descriptor should state its
hook, patch words, cave needs and eligibility policy. Keep the C companion as
one entry point. Replace a blanket special-mode assumption only after
module-specific cause analysis and reproducible A0/B0/C tests. Correct only
measured timing channels; an object string, a static marker and a working
installation are each insufficient to establish gameplay parity.

The next offline task is a narrow word-level reconciliation: compare each
archived detection and patch word with its corresponding current tracked PRX
image, map relocations and record exact mismatches before any port. An explicit
`UNSUPPORTED` descriptor should cover each of the six uncovered images until
its provenance and signatures are established. The runtime gate can then select a
repeatable main-level/Skyboard/Giant Clank scenario from the owner save; no
separate PPSSPP instance is needed for this offline audit.
