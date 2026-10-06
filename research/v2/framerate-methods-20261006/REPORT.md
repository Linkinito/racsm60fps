---
kind: survey
title: "Frame-rate unlocking methods: preliminary comparison and external audit plan"
date: 2026-10-06
authors: ["GPT (Codex)"]
status: blocked
evidence: [INFERRED, UNKNOWN]
summary: "Compared general clock and rendering strategies; external implementations and transfer to UCES00420 remain unverified because the quota-stop threshold was already reached."
systems: [timing, simulation, rendering, physics, interpolation, methodology]
related: [research/tasks/gpt-framerate-unlock-methods-20261006.md, research/v2/damage-followup-20261006/REPORT.md]
---

# Scope and evidence limit

This is a conceptual assessment, not a completed audit of external patches.
The owner requested alternatives beyond current work. The five-hour quota was
7% remaining at startup; AGENTS requires stopping new research near10%. No new
external project/source was inspected, no claimed case study was reproduced,
and no patch, emulator configuration or game asset changed. General equations
below explain strategy and tradeoffs; application to this game is INFERRED or
UNKNOWN. Source-level comparison resumes after quota reset.

# Separate three objectives

- Presentation rate: how often an image is displayed.
- Simulation rate: how often movement, collision and rules advance.
- Real-time pacing: how quickly game time advances relative to elapsed time.

Removing a presentation wait may also advance simulation more often. Repeating
an unchanged image can raise a reported presentation rate without smoother
motion. Generating/interpolating images can improve presentation while leaving
simulation/input sampling at the original rate. These outcomes are different;
the owner's objective remains faithful original30 behavior at60 presentation.

# Strategy comparison

| Strategy | Mechanism | Benefit | Main limit |
|---|---|---|---|
|Cap/VBlank change only|Remove or shorten a wait/interval|Small change if logic already independent|Frame-bound systems can accelerate; pacing/input may still be wrong|
|Shared delta-time repair|Feed appropriate simulation delta at a common boundary|One clock can cover many truly delta-based consumers|Per-call constants, integer counters and animation events remain; shared scalar may have unrelated consumers|
|Fixed simulation with interpolated rendering|Keep original ticks; draw intermediate states|Preserves original physics/event cadence while improving visible motion|Requires state snapshots and a render-only boundary; input latency/teleports/camera/UI need policy|
|Higher simulation rate with per-system repair|Run smaller steps and convert frame-bound formulas|Can improve control/collision sampling and actual animation updates|Original discrete trajectories, thresholds, collisions and random/event ordering may change|
|Hybrid clock scheduling|Keep selected subsystems at their original rates; others render/update more often|Fits engines with mixed ownership and hard-coded behavior|Shared state, first/second substeps and cross-system ordering must be explicit|
|Timing virtualization|Hook a clock/query/wait so the game sees a selected time model|Potentially central if consumers truly rely on that clock|Clock changes also affect scripts/audio/networking; hooks cannot fix independent frame counters|
|Recompilation/source-level separation|Recover or modify update/render architecture|Allows structural fixes and deliberate interpolation|Large project; compiler/ABI/render architecture work, not a drop-in binary patch|
|External frame generation|Synthesize display frames from rendered images|Can improve perceived smoothness with minimal game-logic changes|Does not increase underlying simulation/input rate; visual artifacts and added latency possible|
|Emulator speed/CPU overclock only|Change throughput/emulated scheduling|Can remove a performance bottleneck|Does not by itself repair a game's logical frame cap or behavioral timing|

Cap changes and installation vehicles such as cheat codes, trampolines, plugins
or binary edits are not different mathematical timing strategies. A tiny patch
can repair a central clock; a large patch can still merely remove a wait.

# Why a global factor is insufficient

For constant velocity, displacement=v*dt. Two half-steps preserve the sum if
velocity stays constant and no intervening event occurs. A per-call displacement
must be converted or executed at its original cadence instead.

For damping x'=q*x, two identical updates produce q^2, not q. Matching the
original total decay over two substeps suggests sqrt(q) per substep; this does
not automatically preserve collision/state behavior. Exponential smoothing
needs a time-aware coefficient rather than simply halving its old coefficient.

For semi-implicit Euler motion, v'=v+a*h then x'=x+v'*h. Replacing one step h
with two h/2 steps changes position by -a*h^2/4 relative to that one-step result,
even with equal final velocity and constant acceleration. This is a discretization
difference, not proof the original implementation should be physically improved.
Faithful original behavior may favor retaining its simulation step.

An integer wait of90 updates can represent3seconds at30 calls/s or1.5seconds
at60; both claims depend on actual ownership. This project already contains
systems with two original substeps per30Hz frame, so render rate alone cannot
determine which waits require scaling. Exact-zero checks, strict thresholds,
integer rounding and one-shot event latches require separate treatment.

Periodic damage has the same distinction: d per accepted update can double
damage per second if accepted updates double, but reducing a discrete bullet's
damage merely because rendering doubled would rebalance that weapon.

# Most useful alternative to investigate for this project

Fixed original simulation plus render interpolation is the clearest structural
alternative to extensive per-system60Hz conversion. It is a hypothesis, not a
ready recommendation or a patch proven feasible for UCES00420.

Necessary boundaries: original authoritative movement/collision/AI/event state;
previous/current transforms; renderer reads that do not alter collision state;
separate camera/UI/particles; explicit teleport/spawn/deletion handling; and
preserved player/weapon substeps. Interpolation must not write temporary poses
into shared state used by targeting, damage or physics. Common previous/current
interpolation can introduce a simulation-step delay; higher display rate alone
does not guarantee better input response.

Current constraints matter: modular PRX ownership, unknown render-only boundary,
limited plugin boot/memory budget, shared transforms and intertwined effects.
Adding snapshots for many actors may be expensive. A tiny alternating update
gate without interpolation could retain30Hz visible movement despite60 renders.
Hybrid scheduling at a well-established boundary is another candidate, but it
must preserve existing two-substep player/weapon contracts rather than add a
second rate correction. None of these alternatives is accepted as superior yet.

# External sources queued, not reviewed

The links below are audit starting points. Their current contents, implementation
and relevance were **not accessed or verified in this pass**:

- [Fix Your Timestep](https://gafferongames.com/post/fix_your_timestep/): theoretical fixed/variable step and accumulator reference.
- [Zelda64Recomp](https://github.com/Zelda64Recomp/Zelda64Recomp): candidate structural recompilation/render study; mechanism must be verified in source.
- [DSfix](https://github.com/PeterTh/dsfix): candidate binary/wrapper correction study; actual clock/physics changes must be established from source.
- [PCSX2 patches](https://github.com/PCSX2/pcsx2_patches): candidate game-specific emulator patches; no assumption of parity from a60FPS label.

Inspect pinned commits and selected files rather than downloading inventories
of game-derived patches. Never import third-party/game-derived listings into
public project documentation. Summarize inspected mechanisms with citations.

# Audit and acceptance protocol

First audit Zelda64Recomp and DSfix, at most three selected timing/render files
per case after README/commit identity. Resolve one precise clock/render question
before expanding. Record both positive evidence and unclosed consumers.

Compare original/cap-only/corrected on matched setups: elapsed emulated time,
simulation/render calls, input-to-motion delay, projectile travel/impact/fuse,
cooldown and accepted damage, animation events, collision outcomes, menus,
cutscenes, save/load, spawn/delete/teleport, audio and relevant network behavior.
If the strategy claims variable FPS, add several supported rates plus stalls;
average FPS alone cannot validate catch-up and event ordering. Protect original
simulation-time definitions from host-speed/foreground artifacts.

Deliver a source-backed matrix, a transfer-feasibility ranking and one bounded
experiment per viable strategy. Claude owns any live PPSSPP A0/B/C trial.
The present blocker is the owner quota rule, not missing external-source access.

# Curated publication selection

Only these two project-authored files are selected for this update:

- research/tasks/gpt-framerate-unlock-methods-20261006.md
- research/v2/framerate-methods-20261006/REPORT.md

Local checkpoint/index are separate. No external code, game bytes, raw evidence
or experimental patch is selected; use the mandatory staged checker on main.
