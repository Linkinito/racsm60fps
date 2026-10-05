# Standalone plugin design (roadmap step 2)

Status: design, 2026-10-05. Nothing here is built or tested yet.
Inputs: [ROADMAP.md](ROADMAP.md), the GPT fix inventory
(`research/v2/plugin-inventory-20261005/`, local research branch) and the
cross-module bytematch (`research/v2/module-bytematch-20261005/`, local).

## Goal

One PPSSPP plugin PRX that turns the original game into the corrected 60 FPS
version on its own: no debugger, no external tool, no change to the ISO or
to any game file on disk. The owner starts the game and plays version C.
It reuses what already works in the experimental packages instead of starting
over:

| Existing piece | Reused for |
| --- | --- |
| WF-v12 companion (`patches/experimental/waterfall-companion`) | standalone boot, `rcp1` module resolution, guarded install with dispatch suspended, rollback, unload detection, status log |
| D1 (`patches/experimental/d1-global`) | per-module profiles with identity guards |
| InterpGate (`interp-gate`) | animation latch hook (`animlat`), shared pump wrapper |
| FlamerGate (`flamer-gate`) | weapon phase gates FG-v3 |
| Fix tools (`tools/runtime/fixes.py`, `timer-patches.py`) | known word-level fixes and their JIT handling |

## Architecture

```text
build time (PC, offline)                         run time (PSP / PPSSPP)
------------------------                         -----------------------
fix definitions (project-authored)  --+
  site = function + offset, word or hook |
clean BACKUP LEVEL_xx.PRX (local)   --+--> site tables per module --> plugin PRX
bytematch maps (local)              --+    (generated, _local only)      |
                                                                          v
                               monitor thread: find rcp1 -> identify module ->
                               check guards -> install groups -> watch unload
```

### 1. Fix definitions (project-authored, publishable)

Each fix is written once against LEVEL_01, in a small text/JSON format:

- `id`, `group` (core, accepted, weapons, experimental), `status`
  (copied from the inventory, never promoted by the build);
- site: containing LEVEL_01 function start + offset, or a data object reached
  through a named code reference (for data fixes such as thresholds);
- kind: `word` (replacement instruction or value), `hook` (jump to a stub
  compiled into the plugin) or `data`;
- `delaySlot` flag: the build refreshes the preceding branch as well;
- dependencies and conflicts (for example: never stack the catalogue
  butterfly flap and the WF flap hook).

Definitions contain no game bytes. Original words are not written by hand.

### 2. Site tables (generated, local only)

A build tool reads the clean modules and the bytematch maps:

- For each fix and each module, the site is ported only when its containing
  function is EXACT in that module. VARIANT or ABSENT means "not ported" and
  is reported, never guessed.
- Data sites are ported through their referencing code (HI16/LO16 pair in an
  EXACT function), then the original data value is compared with LEVEL_01.
- Each entry records the original word (read from the clean module) and a
  guard window (masked words around the site).
- Module identity: text size plus a set of masked anchor words per module. A
  module that matches no profile gets no writes.

These tables contain game-derived words, so they live in `_local/`, and the
built PRX is never published (only sources and the generator are).

### 3. Run time

- One monitor thread polls the module list (100 ms). On a new `rcp1` module it
  identifies the profile, then installs groups in order: core first, then
  accepted, then weapons, then the experimental groups enabled in `plugin.ini`.
- Installing a group is all-or-nothing: suspend dispatch, check every guard of
  the group, write, invalidate the data cache and the instruction cache,
  including the preceding branch for delay slots (GOTCHAS on the PPSSPP JIT),
  then resume. If any guard fails, nothing in that group is written and the
  reason is logged.
- One shared 30 Hz phase owned by the plugin replaces tool-side phase choice
  for FG-v3 and similar gates. A single pump owner removes the conflicts
  between clock, telemetry, `ig_upd` and ray islands.
- Level change: when the bound module disappears, ownership is dropped
  (the memory is gone, nothing is restored), and per-module state is reset.
  The next module is then resolved again.
- Profiles in `plugin.ini`: `A0` (no writes, original game), `C1` (core only),
  `C` (core + accepted + weapons), plus per-group switches. Optional later: a
  button combination to switch A0/C at run time for measurement.
- Status log written to the memory stick, as the WF companion does.

### 4. Scope of version 1

LEVEL_01 only, core + accepted + tested items from the inventory:
C1 core, camera with negative caps, HUD hide-delay, `weapondt`,
`blastershot`, `rynorocket`, `animlat`, `nav` (crab), crab threshold,
butterfly, D0 Help, WF emission and flap, FG-v3. Experimental extras
(FG-v4/v5/v5.1, D1 wrappers, frames30 beyond HUD) stay off by default.

## Milestones and acceptance

| Milestone | Content | Acceptance (Claude, live, A0 vs C) |
| --- | --- | --- |
| M0 | Build tool + LEVEL_01 site tables; core and word/data fixes only | fresh boot without debugger; all guards pass; status log clean; Blaster 4.13 shots/s, BlasterShot speed and camera reproduce earlier measurements |
| M1 | Add hooks: `animlat`, `nav`, FG-v3 with plugin phase, WF, D0 | earlier TESTED values reproduced inside the combined build; A0 profile changes nothing |
| M2 | Campaign modules 02-10 (EXACT sites only) | per-module coverage report; one live spot check per module, starting with LEVEL_10 (Quodrona, existing kit) |
| M3 | Skyboard, Treehouse, Giant Clank, multiplayer | only after their unique code has been looked at |

A combined build is accepted only on measurement. Each fix keeps its own
evidence level. The plugin does not upgrade any fix to TESTED.

## Open questions (assigned in the GPT mission)

1. Full original and replacement words for every required fix (local only).
2. Site expressed as function + offset, and data sites through their code
   reference, so they can be ported.
3. Missing site sets: `rynorocket` data addresses, `blastershot` lifetime,
   HUD hide-delay site, FG-v3 LEVEL_01 sites.
4. Plugin phase: which counter defines the 30 Hz phase so that FG-v3 and the
   Laser gate agree.
5. Data constants used by EXACT functions: equal across modules or not.
