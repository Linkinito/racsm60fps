# TIMING-ATLAS-GLOBAL-001 — Breadth-first timing-domain atlas

## Mission type

Read-only static research mission.

Roles:

- Explorer
- Mapper
- Skeptic

Target profile:

- `deepseek-flash-high`

Parent remains the sole authority for PPSSPP runtime experiments and patch writes.

No worker may launch, connect to, manipulate, or patch PPSSPP.

---

## Primary objective

Build a **breadth-first timing atlas** of the single-player game code now that several concrete timing semantics have been reconstructed in `LEVEL_01.PRX` with Ghidra.

This mission must NOT repeat the LaserTracer mistake of recursively reverse-engineering one class in extreme depth.

The goal is coverage and classification first.

For each relevant gameplay class/update path, determine enough to classify its timing behavior, then move on.

Priority 0 remains 30 FPS -> 60 FPS behavioral parity.

---

## Required reading

Before analysis, read:

1. `AGENTS.md`
2. `PROJECT_GOALS.md`
3. `MIGRATION.md`
4. `docs/methodology/EVIDENCE_LEVELS.md`
5. `CURRENT_STATE.md` when present
6. `research/EVIDENCE_INDEX.md` when present
7. `research/v2/timing-domains.md`
8. `research/v2/ghidra-timing-findings-2026-09-20.md`
9. `research/inbox/deepseek/missions/timing-domains-crosslevel-001/sol-review.md` when present
10. previous player-clock accepted reports where relevant

Do not rerun completed missions.

Use their results as prior evidence, but independently verify any material binary claim before promoting it.

---

## Canonical single-player module scope

Priority corpus:

- `LEVEL_01`
- `LEVEL_02`
- `LEVEL_03`
- `LEVEL_04`
- `LEVEL_05`
- `LEVEL_06`
- `LEVEL_07`
- `LEVEL_08`
- `LEVEL_09`
- `LEVEL_10`
- `LEVEL_15`
- `LEVEL_21`
- `LEVEL_22`
- `LEVEL_23`
- `LEVEL_24`

Treat each PRX separately.

Do not transfer raw RVAs across modules.

`LEVEL_16` through `LEVEL_20` are multiplayer/lobby modules and are out of Priority-0 scope unless needed to falsify a structural generalization.

`FRONTEND` is also outside the main gameplay atlas unless needed for a shared-engine comparison.

### LEVEL_02 provenance rule

Use only the restored verified vanilla `LEVEL_02.PRX` baseline.

A previously contaminated one-pass `LEVEL_02` variant existed and must not be used as the vanilla reference.

Record hashes for all modules actually analyzed.

---

## New accepted static context from Ghidra

Treat the following as the current parent-reviewed static model. Challenge it if raw binary evidence disagrees.

### Shared frame delta

In `LEVEL_01`, `0x1517C` constructs approximately `1/30` once and fans it out to four major calls.

B1 changes this shared scalar to approximately `1/60`.

### Player outer/substep architecture

`Player_UpdateOuter` at `0x2FB8C` calls `Player_UpdateTimingFields` once before a main two-pass player loop.

On the main path the loop calls seven functions per pass and writes the module-local gate `0x2B0208` as:

- pass 0: `1`
- pass 1: `0`
- post-loop: `1`

### Player timing fields

`0x360A4` writes/integrates:

- `+0x56C = dt`
- `+0x570 = wrap_like(old, ~1/60) + dt`
- `+0x574 += dt`
- `+0x578 = dt * 30`
- `+0x584/+0x588/+0x58C += dt`
- state-dependent `+0x57C` or `+0x580 += dt`

### Normalized-step split

`+0x578` has at least two distinct semantics at its consumers.

- `0x328A0` divides per-update displacement by `+0x578`, strongly indicating 30 Hz velocity normalization. A value of `0.5` at 60 Hz may be correct.
- `0x42C04` also subtracts `+0x578` from timer-like fields in some branches, while another branch subtracts literal `1.0`.

Therefore a global change from `dt*30` to `dt*60` is rejected as a general fix.

### Explicit substep delta countdowns

`0x32588` subtracts its incoming float from several player fields and clamps them to zero.

This is a real explicit-delta countdown family.

### Mixed timing inside `0x39B74`

The same function contains:

- normalized-step consumers;
- explicit incoming-delta consumers;
- `+1/-1` per-call counters;
- hard-coded `1/60`;
- hard-coded `-1/30`.

Do not assign one timing semantic to a whole function just because one timing constant appears in it.

### Weapon update callback contract

`Player_WeaponUpdate` around `0x1EBC4` dispatches the current weapon update via:

```asm
a0 = current weapon object
callback = [[weapon+0x40]+0x1C]
jalr callback
mov.s f12,f20
```

Individual weapon callbacks may ignore `f12`.

### Flamethrower correction

The historical `3 -> 6` site is a pseudo-random modulo selection, not proven deterministic frame decimation.

Do not describe it as "every 3 frames -> every 6 frames".

The direct damage causal path remains unresolved.

### LaserTracer local 30/60-aware subsystem

A local timing block has:

- static rate `30.0f`;
- `dt = 1/rate`;
- explicit `if (rate == 60.0f)` branches;
- damping-like coefficients consistent with `exp(-k*dt)`;
- one raw function pointer to the initializer at `0x2DD1F8`;
- consumers concentrated in the LaserTracer/tracer helper region.

This is currently interpreted as a **local rate-aware subsystem**, not a game-wide master clock.

Search for analogous local 30/60-aware subsystems elsewhere.

---

## Refined timing-domain taxonomy for this mission

Use these tags.

### `O`
Outer explicit-delta integration.

### `S`
Logical substep cadence.

### `D`
Explicit delta consumer inside any update domain.

### `N-VEL`
Normalized frame-step used for velocity / displacement normalization.

### `N-TIMER`
Normalized frame-step reused as a countdown or progression amount.

### `C`
Pure per-call fixed amount, such as `+1`, `-1`, `position += fixed_speed`.

### `F30`
Hard-coded `1/30` or an equivalent fixed 30 Hz step.

### `F60`
Hard-coded `1/60` or equivalent fixed 60 Hz step.

### `R`
Configurable rate-aware subsystem, especially explicit 30/60 paths.

### `E`
Event/state-gated timing.

### `V`
VBlank / display synchronization.

### `H`
Wrapper/call-composition domain.

### `U`
Unresolved.

Multiple tags per callback are expected.

---

## Mission philosophy: breadth first

The mission is not to fully decompile every class.

For a callback or class, stop once there is enough evidence to answer:

1. What class/system owns it?
2. What is the update callback or likely update path?
3. What timing tags apply?
4. Does it appear vulnerable to a 30->60 cadence change?
5. Is it already rate-aware?
6. What single runtime observation would best validate or falsify the classification?

Only recurse into helper functions when necessary to classify timing behavior.

Default helper recursion depth should be shallow.

Do not spend tens of thousands of tokens understanding visual math that does not affect timing classification.

---

# Role scopes

## Explorer — broad gameplay-system inventory

Primary goal: maximize breadth.

### A. Build a representative class/update inventory

Cover, where discoverable:

- NPCs / enemies
- enemy attacks
- projectiles
- player weapons
- continuous-damage systems
- pickups
- breakables
- moving level objects
- elevators / platforms / doors
- hazards
- scripted sequences
- teleporters
- camera objects / camera core
- animations
- particles / cosmetic effects
- bosses / special modes when structurally accessible

Use object descriptors, source-path strings, relocation-backed function pointers, known wrapper corpus data, and class tables.

### B. Classify timing signatures

For each useful update callback, record the presence of:

- incoming float delta;
- explicit `1/30`;
- explicit `1/60`;
- `+1/-1` counters;
- fixed movement increments;
- integer frame thresholds;
- modulo/divisor logic;
- `dt * 30` or equivalent normalization;
- local static rate;
- explicit comparison with `60.0f`;
- event/state gating.

### C. Search specifically for latent rate-aware systems

Find candidate subsystems resembling the LaserTracer pattern:

- static `30.0f`;
- derived reciprocal;
- coefficients derived from reciprocal/rate;
- explicit `== 60.0f` branch;
- local initializer referenced indirectly from data/relocation tables.

Do not assume every `60.0f` constant is timing.

### D. Historical symptom anchors

Where possible, connect the atlas to already known historical x2 symptoms:

- Pokitaru final elevator
- Kalidon acid
- camera
- Burner damage/effects
- animations/particles
- moving scenery
- teleportation
- enemy timing

Do not force a match where ownership remains uncertain.

### Explorer deliverable

A breadth-first table with at least:

- module
- class/system
- descriptor/name evidence
- update RVA
- timing tags
- most relevant constants/fields
- likely 30->60 risk
- evidence status
- best next runtime discriminator

Avoid long prose per entry.

---

## Mapper — structural update/dispatcher and cross-level homology map

Primary goal: explain how major systems get called and generalize safely across modules.

### A. Update dispatchers

Find and characterize, where possible:

- generic object/Moby update dispatch;
- weapon update dispatch;
- enemy/NPC dispatch;
- script/update dispatch;
- animation dispatch;
- camera update entry;
- particle/effect update dispatch.

Determine whether each dispatcher is:

- outer-frame driven;
- player-substep driven;
- independently scheduled;
- event-driven;
- unknown.

Do not infer cadence solely from a callback's contents.

### B. Descriptor/function-pointer structures

Use relocation-backed aligned data and nearby class/source strings.

Resolve enough descriptor layout to map update callbacks mechanically.

Document indirect-call patterns.

### C. Cross-level homologues

For important timing structures, locate homologues across all 15 single-player modules by instruction/dataflow signature, not absolute RVA.

At minimum map:

- shared frame-delta producer;
- player two-pass loop;
- player normalized `dt*30` producer;
- selected explicit-delta countdown pattern;
- VBlank frame-sync structure;
- known fixed-step elevator/camera anchors where present;
- local 30/60-aware initializer patterns.

### D. Scanner specification

Propose deterministic signatures that can later be implemented in Python/Capstone/ELF tooling.

Each signature should state:

- instruction window;
- register/dataflow constraints;
- relocation or section constraints;
- expected false positives;
- semantic confidence.

### Mapper deliverable

Produce:

1. dispatcher map;
2. cross-level homology table;
3. deterministic scanner specification;
4. list of cases where timing content alone cannot establish call cadence.

---

## Skeptic — adversarial review

Primary goal: prevent false universal fixes.

Independently challenge:

1. that B0 necessarily doubles every gameplay callback;
2. that player substep findings generalize to NPCs/objects;
3. that every `+1/-1` is time;
4. that every `1/30` or `1/60` is a timestep;
5. that every `60.0f` comparison is refresh/update-rate support;
6. that LaserTracer's local timing block is representative;
7. that historical x2 symptoms have the currently assumed owner;
8. that the wrapper corpus captures all timing-relevant calls;
9. that a callback is called once per outer update;
10. that a local patch can be generalized across modules.

Search for counterexamples:

- self-normalizing systems;
- event-driven systems;
- callbacks skipped or multiplied by state;
- alternate update paths;
- values representing angles/speeds/scales rather than time;
- systems already written for 60 logical ticks under a 30 FPS presentation layer.

### Skeptic deliverable

Return:

- strongest falsifications/counterexamples;
- claims safe to keep;
- claims that must remain `UNKNOWN`;
- minimum runtime experiments needed before any new global patch design.

---

# Required global outputs

The worker panel should enable the parent to build a matrix with rows representing systems/classes and columns such as:

| Module | Class/System | Update RVA | Owner/Dispatcher | O | S | D | N-VEL | N-TIMER | C | F30 | F60 | R | E | Historical symptom | Confidence | Runtime test |
|---|---|---:|---|---|---|---|---|---|---|---|---|---|---|---|---|---|

The mission should also produce a compact list of **timing archetypes**, not one narrative per class.

Example archetypes:

- explicit-delta integrator;
- fixed-step mover;
- frame-counted countdown;
- normalized-displacement velocity;
- local rate-aware spring/smoothing;
- 60 Hz logical substep system;
- random/probabilistic emission;
- state/event-only callback.

---

# Explicit non-goals

Do not:

- design or write the final gameplay patch;
- change INI files;
- patch PRXs;
- run PPSSPP;
- modify saves;
- recursively decompile every helper;
- fully reverse-engineer visual/rendering math unless needed for timing;
- treat model consensus as validation;
- rerun earlier broad missions;
- rediscover already accepted player-clock facts merely to fill tokens;
- infer exact semantics from an address alone;
- treat `reference_address_NOT_live` as a runtime address;
- use the previously contaminated `LEVEL_02` as vanilla.

---

# Runtime queue to propose, not execute

The final panel should rank a small runtime queue for the parent.

Mandatory candidate controls:

1. A0 vs B0 player outer cadence.
2. A representative fixed-step level object, preferably Pokitaru final elevator.
3. A representative enemy/NPC update.
4. A camera path.
5. A continuous weapon/damage case.
6. A projectile.
7. One animation/cosmetic system.

The queue should favor tests that discriminate multiple hypotheses at once.

---

# Acceptance criteria

The mission is successful if it gives the parent:

1. a broad enough atlas to stop analyzing one class at a time;
2. at least one classified representative for each major gameplay family where code permits;
3. a clear separation of player-only vs engine/global vs class-local timing;
4. candidate latent 30/60-aware subsystems;
5. deterministic scanner requirements;
6. a ranked runtime validation queue;
7. explicit uncertainty rather than invented completeness.

The mission is NOT successful merely because it produces a large report.

Breadth, falsifiability, and reusable structure are more important than token count.
