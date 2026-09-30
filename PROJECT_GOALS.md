# Overcompensated — Project Goals

## Primary objective

The primary objective of Overcompensated V2 is to produce a **stable 60 FPS implementation of Ratchet & Clank: Size Matters (UCES00420) whose gameplay behavior matches the original 30 FPS game as closely as technically possible.**

This objective has absolute priority over additional features.

The project must first solve framerate-dependent behavior.

It must not use the 60 FPS conversion as an opportunity to rebalance, redesign, modernize, or intentionally alter the original game.

---

## Priority 0 — 30 FPS → 60 FPS gameplay parity

Before additional gameplay or quality-of-life features are developed, the project must establish that the 60 FPS version reproduces the behavior of the original 30 FPS game.

"1:1 parity" means behavioral equivalence, not identical frame-by-frame rendering.

The 60 FPS version naturally renders twice as many visual frames.

What must remain equivalent is the gameplay and timing produced over real time.

Relevant systems include, but are not limited to:

* player movement;
* acceleration and deceleration;
* jumping and falling;
* physics;
* collisions;
* moving platforms;
* elevators;
* environmental hazards;
* enemy movement;
* enemy AI update behavior;
* weapon fire rates;
* weapon cooldowns;
* ammunition consumption;
* damage per unit of real time;
* hit frequency;
* damage-over-time effects;
* melee behavior;
* projectiles;
* recoil;
* timers;
* scripted sequences;
* object movement;
* pickups;
* bolts and breakables;
* particle lifetimes;
* visual-effect timing;
* animation speed;
* menu animation timing;
* HUD timing;
* camera interpolation and movement;
* minigames;
* vehicle sections;
* Giant Clank sections;
* Airboard sections;
* transitions and level-specific mechanics.

A system must not be considered fixed merely because it "looks normal."

Whenever practical, parity should be demonstrated through measurement.

---

## Reference model

The original unmodified 30 FPS behavior is the reference implementation.

For every important framerate-sensitive mechanic, investigations should compare:

1. original 30 FPS behavior;
2. uncorrected 60 FPS behavior;
3. candidate corrected 60 FPS behavior.

This A/B/C model should be preferred over subjective comparison.

Example:

* 30 FPS baseline: elevator completes movement in 8.42 s
* uncorrected 60 FPS: elevator completes movement in 4.21 s
* corrected 60 FPS: elevator completes movement in approximately 8.42 s

The exact acceptable tolerance depends on the mechanic and measurement precision and must be documented.

---

## Fidelity before architecture elegance

A global or architectural correction is preferable when it correctly explains and fixes several symptoms.

However, architectural elegance must not be accepted as proof of gameplay correctness.

Conversely, a local patch that restores correct behavior can remain useful while the deeper mechanism is investigated.

The preferred long-term outcome is:

**correct behavior + understood cause + reproducible evidence**

rather than either:

**working patch with no explanation**

or:

**elegant theory with incorrect gameplay.**

---

## No silent gameplay changes

During the parity phase, do not intentionally introduce:

* weapon rebalancing;
* enemy rebalancing;
* altered movement;
* altered difficulty;
* altered damage;
* altered ammunition economy;
* new camera behavior;
* quality-of-life gameplay changes;
* modernized controls;
* new content.

If the original 30 FPS game contains a known bug, reproducing that behavior may still be correct for parity purposes.

Fixing original-game bugs is a separate decision and must not be mixed silently into the 60 FPS parity work.

---

## Parity gate

Additional user-facing features must not become the main development focus until the 60 FPS parity milestone is considered sufficiently complete.

This does not prohibit development of:

* instrumentation;
* profilers;
* analysis tools;
* test harnesses;
* logging;
* debugging interfaces;
* internal tooling required to complete the 60 FPS work.

Those are enabling tools rather than user-facing features.

---

## Priority 1 — Validation and stabilization

Once broad 30/60 parity has been established:

* perform regression testing across all known modules;
* verify level transitions;
* verify special gameplay modes;
* verify save/load behavior;
* verify 30 ↔ 60 mode transitions if supported;
* investigate crashes;
* remove obsolete compensating patches;
* consolidate root-cause fixes where safe;
* document remaining known deviations.

The result should be a release candidate whose purpose is simply:

**Ratchet & Clank: Size Matters at 60 FPS, behaving like Ratchet & Clank: Size Matters at 30 FPS.**

---

## Priority 2 — Optional enhancements

Only after the parity/stability milestone should user-facing enhancements become a primary development target.

Potential later features include:

* improved camera configuration;
* second-stick camera control;
* alternative control schemes;
* FOV options;
* draw-distance improvements;
* ultrawide support;
* optional weapon balancing;
* New Game+ additions;
* additional configuration;
* other quality-of-life features.

These features must remain separable from the core 60 FPS parity patch whenever practical.

A user who wants only faithful 60 FPS should not be required to enable unrelated gameplay modifications.

---

## Priority 3 — Long-term reverse-engineering value

The project should preserve knowledge useful for:

* future mods;
* emulator research;
* engine understanding;
* symbol mapping;
* structure reconstruction;
* eventual decompilation work.

This is an important secondary outcome of the research process.

It must support the primary objective rather than delay it indefinitely.

Reverse engineering should therefore be driven by concrete questions whenever possible:

* What causes this 60 FPS discrepancy?
* Which function owns this behavior?
* Is the update frame-based or time-based?
* Which variable controls the observed rate?
* Is the same mechanism shared by other levels?
* Can one root-cause correction replace several local patches?

Broad exploratory research is valuable when it helps answer those questions or preserves discoveries made along the way.

---

## Definition of success

The project is not complete because:

* the game renders at 60 FPS;
* a plugin installs successfully;
* memory writes are applied successfully;
* static analysis finds candidate timing code;
* a model believes a patch is correct.

The core 60 FPS milestone is reached when controlled evidence shows that the game's important systems behave equivalently to the original 30 FPS implementation across the supported game.

The guiding principle is:

**First make 60 FPS behave like 30 FPS.**
**Then make it better.**
