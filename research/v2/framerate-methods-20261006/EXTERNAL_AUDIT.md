---
kind: survey
title: "External frame-rate unlocking audit: DSfix and Zelda64Recomp"
date: 2026-10-06
authors: ["GPT (Codex)"]
status: active
evidence: [OBSERVED, INFERRED, UNKNOWN]
summary: "Two pinned source reviews establish contrasting clock and render-interpolation mechanisms; runtime parity and transfer to UCES00420 remain untested."
systems: [timing, simulation, rendering, interpolation, methodology]
related: [research/tasks/gpt-framerate-unlock-methods-20261006.md, research/v2/framerate-methods-20261006/REPORT.md]
---

# Scope and evidence boundary

The owner explicitly requested continuation until quota exhaustion, superseding
the normal 10% stop threshold for this audit session. This continues the
[preliminary conceptual comparison](REPORT.md), whose quota blocker is historical.
Two public repositories were inspected through read-only GitHub access, at the
commits below. No repository was cloned, built, executed or modified. No live
PPSSPP experiment, game patch, source import or gameplay-parity test occurred.

OBSERVED here means a behavior is visible in the cited external source. A README
promise or source comment is attributed to its author, not promoted to our own
runtime result. Transfer recommendations are INFERRED; actual UCES00420 outcomes
are UNKNOWN. Reviewed windows are bounded, not whole-project coverage.

| Case | Pinned commit | Reviewed scope |
| --- | --- | --- |
| DSfix | `2a500d24d1965a26d13f1823976a737feecf77d7` (2016-12-17) | `FPS.cpp`, selected `RenderstateManager.cpp` pacing/presentation paths, selected `memory.cpp` lookup context, `DEVREADME.txt` |
| Zelda64Recomp | `b65c482ed672258eb684ab94a4e8c8aa662615ee` (2026-09-25) | README claims, selected actor/limb transform tagging and camera interpolation-control paths |

# DSfix: bounded elapsed time plus explicit presentation pacing

The source shows more than a frame-cap change. In
[FPS.cpp, lines 66–104](https://github.com/PeterTh/dsfix/blob/2a500d24d1965a26d13f1823976a737feecf77d7/FPS.cpp#L66-L104),
elapsed time comes from Windows QueryPerformanceCounter. The helper expresses
that elapsed time in milliseconds. Draw-thread messages with command 2 or 5
calculate the interval since the previous accepted message and feed it to the
animation-step writer.

The writer converts elapsed milliseconds to FPS, clamps FPS between 10 and the
configured current cap, then writes the reciprocal FPS as a step in seconds to
the game's step-time location. For a valid cap at least 10, the written interval
therefore lies between `1 / cap` and `0.1` seconds. During pause, the writer uses
a tiny positive value, `1e-18`, instead of zero. These are OBSERVED source rules;
the effects on every physics, animation and gameplay consumer were not audited.

This clamp matters: a long stall does not produce an arbitrarily large step.
The reviewed writer also does not implement a fixed-step accumulator that
replays all missed ticks. Whether some other subsystem compensates for lost
time is UNKNOWN. Describing this as a complete fixed-step engine would be wrong.

[Initialization, lines 130–211](https://github.com/PeterTh/dsfix/blob/2a500d24d1965a26d13f1823976a737feecf77d7/FPS.cpp#L130-L211)
checks the executable timestamp against a configured build, uses pattern lookup
for another build and aborts when required locations cannot be found. It changes
the game's presentation-interval setting to the value described by the source
as immediate, installs the draw-message detour and initializes the timer. This
is evidence of build-sensitive instrumentation, not universal compatibility.

Presentation pacing is a separate path. The wrapper invokes frame-time
management before the underlying presentation call. In
[RenderstateManager.cpp, lines 981–998](https://github.com/PeterTh/dsfix/blob/2a500d24d1965a26d13f1823976a737feecf77d7/RenderstateManager.cpp#L981-L998),
the limiter computes the desired interval from the current cap, subtracts
0.1 ms, and yields with SwitchToThread until that interval has passed. A low-FPS
state has hysteresis: entry compares against the configured threshold interval
plus 0.2 ms; exit compares against that interval minus 1 ms. Clock correction,
cap removal and frame pacing are distinct responsibilities.

**Transfer to our project, INFERRED:** a central delta can help only when its
consumers and ownership are established. Copying DSfix's host-wall-clock source
into PSP simulation would be unjustified: host elapsed time and emulated game
time can diverge under slowdown. The reviewed source cannot establish that
rewriting our shared delta fixes integer counters, repeated damage callbacks,
event admission or the already gated player paths.

# Zelda64Recomp: identify graphics transforms and control interpolation

The
[README, lines 59–62](https://github.com/Zelda64Recomp/Zelda64Recomp/blob/b65c482ed672258eb684ab94a4e8c8aa662615ee/README.md#L59-L62)
reports high-frame-rate RT64 rendering, including objects, terrain texture
scrolling and HUD elements, with gameplay unaffected. That last statement is a
project claim; this audit does not independently validate it or establish the
simulation cadence from a scheduler trace.

The inspected actor code provides a concrete renderer-facing mechanism.
[Actor transform tagging, lines 233–268](https://github.com/Zelda64Recomp/Zelda64Recomp/blob/b65c482ed672258eb684ab94a4e8c8aa662615ee/patches/actor_transform_tagging.c#L233-L268)
assigns matrix-group identities from an actor transform ID and a limb index;
post-limb groups use another ID range. An actor skip flag selects the
decomposed SkipAll variant instead of normal handling.
[Skeleton drawing, lines 289–345](https://github.com/Zelda64Recomp/Zelda64Recomp/blob/b65c482ed672258eb684ab94a4e8c8aa662615ee/patches/actor_transform_tagging.c#L289-L345)
wraps limb and post-limb drawing in matrix-group push/pop operations. These
reviewed paths annotate graphics commands. They do not establish that gameplay
positions are interpolated, nor do they prove stable identity across every
spawn/destruction case. The downstream interpolation algorithm was not read.

Camera handling shows why interpolation needs exceptions.
[Camera pre-update, lines 49–89](https://github.com/Zelda64Recomp/Zelda64Recomp/blob/b65c482ed672258eb684ab94a4e8c8aa662615ee/patches/camera_transform_tagging.c#L49-L89)
contains scene/mode-specific force-interpolation rules and a force-skip rule for
a small cutscene teleport. These include boss, targeting and location cases.
They are evidence of explicit handling for heuristic failures, not evidence that
one interpolation rule is safe for every transition.

[Perspective prediction and View_Apply, lines 153–267](https://github.com/Zelda64Recomp/Zelda64Recomp/blob/b65c482ed672258eb684ab94a4e8c8aa662615ee/patches/camera_transform_tagging.c#L153-L267)
use previous eye/target positions and velocities to compare predicted movement
with actual movement. The comments attribute chosen thresholds to testing;
those tests were not reproduced here. View application combines that decision
with force/skip flags, skips interpolation when returning from the pause menu,
and emits selective matrix interpolation flags into opaque and translucent
display lists. Skip overrides force. Flags are reset after application. A skip
branch still leaves a component marked for interpolation, so it should not be
described as disabling every component indiscriminately.

**Transfer to our project, INFERRED:** retaining the original gameplay cadence
while rendering intermediate states could preserve many frame-counted rules.
It requires a genuine presentation boundary, identities for objects/limbs,
previous/current state and explicit handling for teleports, camera cuts, pause,
spawn/destruction and screen-space effects. Such a boundary is not established
in UCES00420. Interpolating shared positions used by collision or targeting could
change gameplay. Feasibility under the existing PSP hook/memory budget is UNKNOWN.

# Comparison and falsifiable next steps

| Question | DSfix source result | Zelda64Recomp source result | Consequence for UCES00420 |
| --- | --- | --- | --- |
| How is extra rendering supported? | Immediate presentation setting and a cap-aware limiter | Tagged graphics matrices with interpolation controls | Unlocking presentation alone does not establish behavioral parity |
| What clock is evidenced? | QPC-derived elapsed milliseconds, bounded step written in seconds | This bounded review does not establish the simulation scheduler | Identify our emulated clock and ownership before changing time inputs |
| How are discontinuities handled? | Pause uses a tiny positive step; long intervals are clamped | Camera prediction, explicit force/skip cases, pause-return handling | Pause and transitions need dedicated regression scenarios |
| What remains unproved? | All gameplay consumers, catch-up elsewhere and whole-game parity | RT64 interpolation math/scheduling and independent gameplay parity | Neither example validates a global replacement in our game |

For a common-delta hypothesis, Claude's A0/B/C protocol should compare elapsed
emulated time, callback counts and accumulated motion/damage at normal speed
and during controlled host slowdown. A failure where wall time changes the game
outcome would reject host-clock substitution. No such experiment ran here.

For a render-interpolation hypothesis, compare gameplay tick/callback counts,
collision outcomes and projectile hit ordering while varying only display
cadence. Include a camera cut, pause/resume and object destruction. Smooth
images with changed hit ordering would fail parity. No such patch exists here.

The exact next external question is the renderer/runtime boundary behind the
Zelda tags: inspect the pinned `lib/rt64` dependency at
`23cab603c4f9f4a8b369b38e036f1aa484603878`, then only the scheduler bridge needed
to determine which states are interpolated and when. The parent also pins
`lib/N64ModernRuntime` at `df7e820d8c55e4fcb4616c210cbb2c01b25cd48c`.
Neither dependency's implementation was inspected. Establish that boundary
before expanding to additional projects or claiming a fixed simulation rate.

# Provenance and publication selection

Git blob identities returned by the read-only source reader:

| File | Blob SHA |
| --- | --- |
| DSfix `FPS.cpp` | `ed28094749cdec5a1ff844c11541c30c98043541` |
| DSfix `RenderstateManager.cpp` | `634fe1a16d9d80ed05c75ed5292b2968ae16bcd5` |
| DSfix `memory.cpp` | `f728df62cf19c2a2ee61d39ad8f96c9602d6b24a` |
| DSfix `DEVREADME.txt` | `75ee5dc80b45b499845da2ce8bc4ebeb626a0811` |
| Zelda64Recomp `README.md` | `e31603ebdd4d10e7e1c7cdb5b0e9ef235f03288f` |
| Zelda64Recomp `patches/actor_transform_tagging.c` | `796f10c0a1e44ec41624fee85938ca2b019bd474` |
| Zelda64Recomp `patches/camera_transform_tagging.c` | `60f0d004004bb6bc974ae0a6cd761abe5e5683a1` |

Public update allowlist: exactly this authored report and
`research/tasks/gpt-framerate-unlock-methods-20261006.md`. The local evidence
index/checkpoint are excluded. No external source file, game byte pattern,
game-derived listing, capture, asset or raw experiment output is published.
Existing owner GitHub authorization applies; run the staged publication checker
and verify the resulting remote main commit. Never push v2-research.

# Addendum 2026-11-09 (Claude): RT64 transform-interpolation boundary

Read-only GitHub API reads of `rt64/rt64` at the pinned gitlink
`23cab603c4f9f4a8b369b38e036f1aa484603878`: `src/hle/rt64_transform_group.h`,
`src/render/rt64_transform_processor.cpp` (lines 26-86), `src/hle/rt64_workload_queue.cpp`
(lines 205-228, 856-1110). No clone, build or execution. N64ModernRuntime not read.
Findings are OBSERVED in that source; transfer to UCES00420 is INFERRED.

- **Simulation cadence is not changed.** The queue keeps one workload per original
  game frame (rate `viOriginalRate`, from the console's video interface). Extra
  display frames are generated only when `targetRate > viOriginalRate`, not paused,
  and an interpolation target exists (lines 958-959). Otherwise weights are
  prev=0, cur=1 (no interpolation).
- **Interpolation is between two completed game frames.** `logicalTicks` advances
  by `targetRate` per workload; `displayFrames = (logicalTicks - displayTicks) /
  viOriginalRate`. Per intermediate frame, `prevFrameWeight` and `curFrameWeight`
  are clamped fractions of that gap (lines 973-974, 1053-1055). So the shown
  image lags the simulation by about one original frame (INFERRED from the
  prev/cur structure; latency not measured).
- **Matching and lerp.** A transform is interpolated only if the previous frame
  is valid and the transform has a matched index in it
  (`prevTransformIndex`); the rigid-body `lerp` is applied to the matrix
  decomposed per component (position/rotation/scale/skew/perspective, each
  AUTO/SKIP/FORCE per `TransformGroup`; vertex interpolation defaults to SKIP).
  Unmatched transforms are copied unchanged (processor lines 36-58).
- **Failure handling is in the game patches, not RT64.** The camera force/skip
  rules from the Zelda64Recomp audit above are the discontinuity mechanism;
  RT64 itself only consumes the tags. Frame skipping under load drops display
  frames, never game frames (lines 1040-1046).

**Consequence for UCES00420, INFERRED:** this design is render-only and keeps all
gameplay state at the original tick, so it cannot break frame-counted rules, but it
needs (1) a game-frame boundary where previous/current object matrices are both
available, (2) stable per-object identity across frames, (3) a renderer hook that
re-submits the display list with blended matrices. On PSP under PPSSPP, step 3
means a PPSSPP-side change or a GE-list replay; the existing plugin budget
(~30 KB, no GE hook) does not obviously allow it. Feasibility UNKNOWN. This is
the opposite trade-off to the project's current approach (simulate at 60 Hz),
which the owner has chosen to be primary (Priority 0 parity); interpolation would
remain a Priority 2 candidate unless the owner decides otherwise.

**Falsifiable test (unchanged from above):** hold gameplay tick count constant,
vary only display cadence, compare callback counts and hit ordering A vs
interpolated; include a camera cut, pause and object destruction.
Next external question (only if the owner wants it): PPSSPP's own
frame-generation/"render-to-display" path, to see whether the host already
offers a hook (read-only source lookup, cache is read-only per AGENTS.md).

# Addendum 2026-11-09 (2, Claude): PPSSPP host-side hooks for frame generation

Source: `hrydgard/ppsspp` tag `v1.20.4` (tag object `3a31057b7e44270b4d5cef8c31b6559d51802a3b`),
read through the GitHub API, matching the installed 1.20.4. Not the local 1.19.3
cache. Files read: `Core/HLE/sceDisplay.cpp` (lines 160-190, 360-680),
`Core/Config.cpp` (lines 731-797), `GPU/Common/PostShader.h`. No build, no run.

- **What exists (OBSERVED).** Config `RenderDuplicateFrames` (default off) makes
  `sceDisplay` flip on every vblank even without a new framebuffer
  (`postEffectRequiresFlip`, line ~603-606); only when frame skip is 0 and buffer
  effects are on. `ShaderChainRequires60FPS` does the same for post-shaders.
  Post-shaders may declare `usePreviousFrame` (one previous *output* frame, as an
  image, for blending; PostShader.h line 50-51).
- **What does not exist (OBSERVED in these files).** No motion-vector, object
  identity, or per-matrix interpolation. The host sees only finished framebuffers,
  so any host-side generation would be image blending/warping of two screen
  frames, not RT64-style transform interpolation. A full read of GPU/ for hidden
  generation code was not done (UNKNOWN beyond the files listed).
- **Consequence, INFERRED.** (1) Duplicate-frame rendering only re-presents the
  same image; it adds no new motion. (2) Screen-space blending of two 30 Hz
  frames gives ghosting on fast motion and cannot separate HUD from world;
  motion estimation is outside what a post-shader chain reads here. (3) RT64-style
  interpolation would need a new PPSSPP GE-level feature (capture matrices per
  draw, match across frames). That is a source change in PPSSPP, not a plugin
  patch, and is outside the owner's authorisation (no rebuild/fork).
- **Position.** Real 60 Hz simulation (current approach) stays the only route
  that meets Priority 0. Interpolation is not available as a cheap alternative.
  UNKNOWN: whether a blend shader looks acceptable; testing it needs only a
  post-shader on 30 Hz play and is a Priority 2 side experiment if the owner wants it.
