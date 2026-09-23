# Cross-object timing families and correction plan (2026-09-23)

## Decision boundary

Priority 0 is behavioral parity with UCES00420 at its original 30 FPS. The
target is equal behavior over elapsed game time, including event frequency,
durations, trajectories, damage, ammunition, state transitions and visual
timing. Non-interactive objects and effects are part of Priority 0 parity: box
debris, Pokitaru butterflies and `SharkgatorFin`, and level-up animations are
explicit examples. Their exact update functions and defects remain UNKNOWN
until measured. A smoother
60 FPS rendering does not establish parity. A0 is original 30 FPS, B0 is
uncorrected 60 FPS, B1 adds the 1/60 shared delta, and C1 adds one player
substep. A candidate correction is a separate C arm with its exact PRX, mode,
module hash and initialization state recorded.

The unit of correction is a **behavioral channel in a known dispatch domain**,
not a class name, a callback address, or a literal. One callback can update
several channels governed by different clocks. One dispatch group can carry
objects with opposite correction needs. We must not apply a global half-rate
rewrite or infer a defect from a static marker alone.

## Working model

For each channel, record four things:

1. **Invocation clock:** outer update, player substep, first-pump group walk,
   gate-qualified call, collision/event, or an unresolved nested route. Measure
   calls per emulated second in A0, B0 and C1 when relevant.
2. **Per-call operation:** incoming `f12`, a fixed float step, an integer
   increment/decrement, a threshold/reset, an event payload, or a mixture.
3. **Consumer meaning:** position/velocity integration, timer, lifetime,
   animation phase, cooldown, damage, ammunition, hit invulnerability, etc.
   Preserve uncertainty where field identity is unresolved.
4. **Observed outcome:** elapsed duration, distance/trajectory, event count,
   damage, ammo and visible behavior, with a reproducible A/B/C comparison.

For a *linear additive* channel, real-time slope is approximately `calls/s ×
change/call`. If C1 doubles the eligible call rate, a fixed additive step may
need half its original value. If the call rate is unchanged, halving the step
would create a new defect. If the step already uses `f12` and `calls/s × f12`
is preserved, it needs no further scaling. These are predictions to test, not
patch rules for unexamined objects. Thresholds, clamping, integer rounding,
random choices and event side effects invalidate simple slope equivalence.

For a lifetime expressed as `N` callback decrements, predict `N / calls/s`;
when the callback doubles, `N` may need to double to preserve seconds. A
floating countdown may instead consume real delta. Neither transformation is
safe if `N` counts hits, spawns or discrete opportunities rather than time.
Likewise, preserving damage per second alone is insufficient if hit frequency,
knockback, invulnerability or status-effect application changes.

Visual channels need the same separation. A debris burst may have spawn count,
initial velocity, trajectory, lifetime and fade as distinct channels. A
non-interactive creature may have pose phase, movement path and idle/wait
duration. A level-up effect may combine a one-shot trigger, particle burst,
HUD animation and sound cue. Measure each against A0 in elapsed time; scaling
all animation increments by one half would damage channels already driven by
delta time or a preserved substep cadence.

## Evidence-backed families and controls

| Family / representative | Established channel behavior | Correction hypothesis and current limit |
| --- | --- | --- |
| Outer callback, fixed float step — `Lvl3Elevator` | TESTED: raw C1 roughly halves ride duration; a guarded half-step restored near-A0 duration. A fresh LEVEL_03 companion instance acquired it. Matched direction-1 A0/C1 rides were 2.497471/2.541371 s (+1.76%). | A per-callback half-step is a credible rule for that elevator channel. The v4 companion contains five guarded module routes, but four new routes and the v4 package remain untested in game. The residual duration gap is UNKNOWN. |
| Outer callback, multiple fixed fields — `Level01Waterfall` | TESTED: outer cadence changes from about 29.97 to 59.94 calls/s in B0/C1. Its object `+0x70`, `+0x79`, and pvar `+0x04` keep fixed per-call changes; measured cycle time halves. | Strong first **non-elevator** experiment. Map each field to its visible consumer before choosing float-step scaling, threshold change or event gating. A single field edit cannot claim whole-object parity. |
| Outer callback, long fixed timer — `Level01HelpManager` | OBSERVED static step and group `+0x1C` dispatch; the 1200 s versus 600 s consequence is a timing prediction, not an end-to-end timed test. | Use as an independent test of the same clock class after the short Waterfall cycle. Exact timer binding and threshold behavior need confirmation. |
| Mixed delta and fixed step — `Acidbomb` | TESTED: callback cadence doubles (ratio 2.0006); `pvar+0x0C` changes by `f12` and retains its real-time rate, while fixed `pvar+0x14` changes by -0.002 each call and its real-time decay doubles. | Correct only the fixed decay/integration channel. Do not halve `f12` again. A matched trajectory still needs repeatable aim and launch state. |
| Player substep, fixed per-hit step — `AgentsGlove` and Flamethrower phase | TESTED: `AgentsGlove` counter rate is preserved (ratio 0.99980). Flamethrower phase also stays near A0 (ratio 0.9995): A0 has two substeps at 30 Hz; C1 has one at 60 Hz. | Negative controls against bulk half-scaling. A fixed literal is not itself a defect. Flamethrower **damage** is a separate, unresolved channel. |
| Gate-qualified work — `LaserTracer` | TESTED: the gate alternates over A0 substeps but remains asserted at each C1 call; `pvar+0x08` rate is about 2x in C1, and clip drain also doubled in the recorded probe. | Identify the gate's affected operations and a candidate preserving body/animation cadence. Earlier whole-body decimation was REJECTED as a gameplay fix. Clip identity and complete weapon parity remain UNKNOWN. |
| Outer delta forwarder — `AgentController` | TESTED: one outer call at about 30 versus 60 Hz; it forwards `f12` 1/30 versus 1/60, without an observed local accumulator. | Do not alter the forwarder globally. Measure child call counts and consumers before assigning a correction. |
| Integer counters and lifetime candidates | Static audit found 91 update functions with delta-unused integer counters; a later broader marker scan found many more candidate counter sites. | Classify each counter by its consumer and event semantics. Static counts are discovery queues, not counts of proven defects. |
| Visual-only timing and lifetime — box debris, Pokitaru butterflies/`SharkgatorFin`, level-up effects | OWNER-REPORTED scope examples; no A0/B0/C1 measurement or callback binding is claimed here. | Measure burst count, lifetime/fade, pose cycle, path and trigger-to-end duration separately. Classify each by dispatch cadence and delta/fixed/counter mechanism before a correction. |

These figures come from different bounded scanners. The 531 decoded update
functions yielded 169 fixed-float/no-incoming-delta cases, 91 integer-counter
cases, 9 delta readers and 262 without a bounded timing signature, plus 7
names without an update RVA. The later marker corpus reports 307 classes with
per-call fixed-step leads across catalogued functions. These are different
views and must not be merged into a defect total. Only a few representatives
have measured dispatch cadence. See the linked evidence below.

### Flamethrower damage decision

The owner observed roughly doubled damage per second against Mungo in
LEVEL_03. The measured Flamethrower **phase** is already rate-correct, and the
weapon is not the LaserTracer gate consumer. Thus `halve Flamethrower damage`
is an **unverified candidate**, not a conclusion. A controlled A0/B0/C1 test
must record target initial/final HP, weapon ammo, trigger duration, contact or
hit-event count and their timestamps, and the weapon's phase. Repeat at least
one matched target/setup after fresh initialization. If hit count doubles but
per-hit damage does not change, compare guarded per-hit scaling with restoring
A0 hit cadence; choose by hit timing and side effects as well as HP loss. If
hit count is unchanged, seek the damage payload or target-side consumer. If
neither HP nor contact evidence reproduces the observation, retain UNKNOWN.

## Dispatch boundary still open

The LEVEL_01 first pump (`0x6B7F4`) loads a callback at group `+0x1C` and
calls it at `0x6B9B8`; five saved object classes share that route. Its manager
group array/count derive from a loaded resource, but the observed loader pass
rebases `+0x04/+0x08/+0x0C` and does **not** establish the writer or semantic
owner of `+0x1C`. The nested second pump (`0x6E6D4`) has separate indirect
calls; whether it also invokes the same callback is UNKNOWN. Therefore shared
route membership does not establish identical cadence, nor justify one hook
that halves every object.

Resolve this with a bounded static search for writes/references to the group
record and resource field, then a true-stop A0/C1 trace comparing exact entity
and callback targets at the first pump and second-pump indirect sites. Record
module hash, return address, call count per emulated second and selected
object identity. A missing static writer is a result to preserve: the pointer
may be resource supplied or installed by another route. Do not assert this
until observed.

## Ordered experimental plan

1. **Freeze the reference matrix.** For each selected scene, save exact A0,
   B0, B1 and C1 guard words, module/PRX hashes, PPSSPP version, normal
   in-game save lineage and raw `cpu.ticks` times. Use true stops; burst polling
   can stall the emulated CPU. Keep original game assets untouched.
2. **Resolve the group boundary.** Complete the `+0x1C` provenance and nested
   pump test above, at least for Waterfall and one control. If the second pump
   invokes a channel independently, count both paths before any scale factor.
3. **Build a channel table, not a patch list.** For Waterfall, Acidbomb,
   LaserTracer, Flamethrower, AgentsGlove, AgentController, HelpManager and
   Elevator, enter callback cadence, exact input step, consumer, baseline
   outcome, competing explanation and evidence status. Carry UNKNOWN cells.
   Extend by timing family and module signature, then sample one independent
   object per proposed reusable rule.
4. **First new companion experiment: Waterfall.** Use a short, repeatable
   cycle to measure A0/B0/C1 elapsed period and each field's step. Implement
   one narrowly scoped, hash-guarded rule in `patches/experimental/` for the
   causally identified channel. Compare C against A for full cycle, field
   trace, animation and transitions. Keep the existing elevator rule separate
   for rollback and interpretation.
5. **Test mixed and gated mechanisms.** Acidbomb tests whether a fixed channel
   can be corrected while its delta countdown remains invariant. LaserTracer
   tests a gate-specific correction with clip drain, visual smoothness and
   hit events measured together. Flamethrower/Mungo resolves the damage
   channel before any damage-scaling patch. AgentsGlove remains a control.
6. **Test visual parity representatives.** Capture one matched box-break event
   (piece count, motion, disappearance/fade times), one stable Pokitaru idle
   scene (butterfly and `SharkgatorFin` animation-cycle and path periods), and
   one reproducible level-up trigger (effect duration and cue timing). Compare
   A0/B0/C1 first, then a guarded C candidate for a proven defective channel.
   Record video or frame-indexed observations alongside emulator ticks; keep
   trigger count and gameplay reward unchanged. Determine the actual object
   identities and callbacks instead of assigning them from visible names.
7. **Generalize only after a rule survives independent representatives.**
   Map per-module equivalents from hash-pinned code and guarded readback;
   test fresh initialization, both modes of a transition, reload and
   regression controls. Expand companion coverage only for mechanisms with
   measured A/B/C outcomes. `patches/validated/` requires reproducibility,
   causal understanding, documented environment and regression checks.

For each experiment, decide acceptance from predeclared observables and
measurement precision. A matched average duration is insufficient when the
trajectory, hit distribution or ammo economy differs. Record contradictions
and rejected candidates. No global tolerance is inferred from the elevator's
provisional +1.76% comparison.

## Source trail

The paths below identify the local evidence archive. Raw measurements and
experimental artifacts are intentionally outside the curated GitHub update.

- `research/EVIDENCE_INDEX.md` links the frozen raw captures and reports.
- `reports/AGENT-SESSION-2026-09-23/DISPATCHER-OFFLINE-REVIEW.md` gives the
  first/second pump structure and current `+0x1C` provenance limit.
- `reports/STATIC-60FPS-COMPLETE-AUDIT-002/analysis/REPORT.md` gives the
  bounded function taxonomy and its limits.
- `research/live-tests/pokitaru/atlas-probes-001/` contains Acidbomb,
  AgentsGlove, LaserTracer and Flamethrower A0/C1 measurements.
- `research/live-tests/pokitaru/waterfall-001/` contains A0/B0/C1 cadence
  and cycle measurements.
- `patches/experimental/lvl3-elevator-halfstep/GENERALIZED-COMPANION-PRX.md`
  records the existing guarded elevator component and untested v4 routes.
