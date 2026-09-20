# Next runtime gate — PLAYER-CLOCK-001 A0/B0

Prepared 2026-09-20 by timing-atlas parent review. NOT EXECUTED by that review.
Question: does removing the conditional second VBlank wait change the shared
level/player scheduling rate in this Pokitaru scene? No candidate correction yet.

## Entry and stop gates

1. Read AGENTS.md, CURRENT_STATE.md, this file. Verify branch and actual HEAD.
   First read-only shell command when runtime work is authorized:
   `Get-Process PPSSPPWindows64 -ErrorAction SilentlyContinue | Select-Object Id,Path`
   Discover listening ports for those PIDs; match the executable to the existing
   `isolated-20260919T150446Z/local/app/` path. Never infer ownership from port
   60908 or historical PID alone.

   **Owner override — launching the existing isolated lab is authorized.** If no
   matching PPSSPP process is running, locate and launch exactly ONE instance of
   the already-prepared isolated laboratory under:
   `research/live-tests/pokitaru/player-clock-001/isolated-20260919T150446Z/`

   The prohibition on launching PPSSPP applies only to arbitrary, new, cloned,
   rebuilt, replacement, or uncontrolled emulator instances. It does NOT prohibit
   starting the existing isolated laboratory prepared for this experiment.

   The runtime agent may launch that existing isolated executable, load its existing
   UCES00420 laboratory session/checkpoint, connect to its debugger/API, pause or
   unpause it, execute the authorized A0/B0 experiment, and close that isolated
   instance during cleanup when appropriate. It must NOT launch or touch the user's
   normal PPSSPP installation/session, create a second isolated copy, clone/download/
   rebuild PPSSPP, modify PPSSPP source, change emulator version, create a new
   emulator installation, or substitute another ISO/game build.

   If the existing isolated lab cannot be identified or started without creating,
   rebuilding, replacing, or materially reconfiguring the environment, stop with
   that concrete blocker. Do not create a substitute lab.
2. Read-only debugger requests: version, game.status, cpu.status, hle.module.list.
   Require UCES00420 and one active rcp1. Preserve initial pause/input/breakpoint
   state; do not remove user breakpoints. Historical base 0x09139D00 is a hint,
   not an address to reuse without discovery.
3. Verify executable/config/ISO provenance, module LEVEL_01 reference hash
   d10a81d076fb44987a45314a020cda2f7e8b39f860b957911ca9365464676571,
   loaded relocation-normalized code, routes and absent experimental plugins/
   cheats. Use `memory.read` with replacements:false, not memory.read_u32's
   ignored replacements parameter. Account for loader import bindings.
4. Verify checkpoint lineage and visible Pokitaru scene. Neutral, safe ground,
   no menu/travel/cutscene, same health/equipment/weapon/position across arms.
   Do not assume a cheat-unlocked LaserTracer save is ordinary progression.
   Record any such lineage; use a clean matching source for the vanilla gate.
   Existing isolated slot-0 checkpoint was historically created with Fichier→
   Sauvegarder état, then restored via F4; re-hash and verify it before reuse.
5. Resolve player state from relocated operands/call a0. Historical P=base+
   0x337940 (0x09471640 at old base) was observed; verify it, not merely the sum.
   Require active normal path (+0x95C bit 0x8000) and correlate state fields.
6. Guard original words at U/G/S/P: +0x96650 relocated WAIT jal; +0x151E0
   0x3C043D08 (next ori produces 0x3D088889); +0x2FCFC 0x2A240002;
   +0x2FBBC 0x46006506. Save exact loaded U word **and surrounding words**
   before any change. Do not restore from unrelocated PRX 0x0C06FD09.

Any failed identity, lineage, baseline, scene or observer check blocks B0. Preserve
the exact failure and existing state; do not substitute a guess or another patch.

## Measurements and observer calibration

Use existing parent tools; inspect their actual capabilities before use. This is a
protocol, not a claim that a complete seven-site logger already exists. Do not
rebuild/instrument the emulator or launch research workers to execute this gate.
If existing debugger logging cannot meet the checks below, persist that precise
tooling blocker instead of collecting invalid cadence data.

Use log-only counters during free-running windows, not stop-on-hit breakpoints.
Record monotonic host timestamps, emulated ticks, CPU frequency/calibration,
input state, game state, count completeness and overflow/drop indicators.
Calibrate ticks against wall time at the unchanged CPU setting; do not assume
ticks equal microseconds. Native replay input timestamps use emulated global
microseconds, a different quantity. Neutral input is sufficient for this first gate;
movement/replay parity belongs later.

Predeclare: 2-second settle, then 10-second measured window, excluding pauses,
loads and setup. Collect three A0 windows from the same checkpoint. Use the same
settle/window for B0 and restored A0. Restore/reverify checkpoint before each arm;
record actual emulated and wall window bounds. Record health/position and state
before/after each. Keep measurement logging configuration identical across arms.
If natural state transitions prevent comparable windows, stop and choose a new
documented checkpoint before restarting the experiment, retaining failed windows.

Before the comparison, compare an uninstrumented run, a minimal counter run and
the complete observer on the same neutral scene. Observer acceptability criterion
is predeclared here: wall-normalized emulated-time progression must differ by no
more than 5% from the uninstrumented baseline, with no dropped trace records or
pause events. Repeat once if a transient host disturbance is documented; otherwise
stop on failure. This is a measurement-quality bound, not gameplay parity tolerance.
Do not claim completeness from an empty trace. Historical JIT interior breakpoints
missed some loop sites while tail hits were observed; verify site coverage against
the loop tail and callsite conservation before trusting rates.

| Counter | Purpose / required attribution |
|---|---|
| base+0x1517C | Shared level-delta update; record caller/phase if available |
| base+0x2FB8C | Player outer update; a0 must match the tracked player |
| base+0x39B74 | Simulation substep; restrict caller to player loop 0x2FCE4 (ra=base+0x2FCEC) |
| base+0x2FCF0 | Weapon callsite specifically in player substep; never substitute total 0x1EBC4 |
| base+0x96490 | Limiter/driver entry, with argument and gate where practical |
| base+0x96648 | Branch reached; capture v0 and a0, count equal/not equal |
| base+0x96650 | A0 executed WAIT call; B0 NOP-site reach count, explicitly NOT a wait count |

Auxiliary: loop tail +0x2FCFC with s1 values; gate byte base+0x2B0208
at pass stores and post-loop restoration; optional +0x360A4. For an active
normal iteration expect s1 tail values 1,2, two loop callsite hits per outer, and
gate 1/0/post1. Exclude/label partial windows and alternate paths. Count first
WAIT +0x9662C if practical, with independent VBlank counter queries via the
observed VCOUNT returns at +0x96638/+0x96658. Their returned vcount deltas
(handle unsigned wrap) are the display-time denominator, not WAIT-call counts.
If VCOUNT-return capture is unavailable, mark independent VBlank count UNKNOWN
and do not call display-cadence validation complete. Display FPS alone is insufficient.

Sample player +0x574 at window endpoints and synchronized outer-boundary samples;
fit/report its slope and float quantization. +0x578 is a value, not an accumulating
clock: sample after +0x360A4 writes it. Also record +0x56C, +0x570, +0xF8,
+0x95C and optional active +0x9D4/9D8. No invented gameplay labels for those fields.

## Arms and predictions

**A0:** no socle edits. Under a stable normal 30-Hz outer schedule predict ~30/s
at level/player outer, ~60/s for each normal-path substep callsite, +0x56C≈1/30,
+0x578≈1 and +0x574 slope≈1 unit/s. These are hypotheses, not admission criteria
to discard contrary observations. Limiter frequency is independently measured.
Within the enabled limiter, equality at +0x96648 falls through to the second
WAIT; inequality branches to +0x96658 and skips it. Record actual branch fractions.

**B0:** pause; reverify U against saved exact word; write **only four-byte NOP at
base+0x96650**, using debugger write API that invalidates JIT instruction cache.
Read back raw bytes and all other socle guards. Unpause to the controlled window.
No shared-delta, loop-count, scalar, camera, weapon, rate-field or plugin changes.
Predict, conditionally on shared scheduling doubling: level/player ~60/s, each
unchanged two-pass substep ~120/s, +0x574 slope ~2, +0x578 still ~1. Branch
equality can still reach the NOP site, but the second WAIT count becomes zero.
The first WAIT and entire-limiter gate still exist. No guarantee of exactly 2x
under overruns, inactive limiter, other waits or phase changes.

Collect three B0 windows and three restored-A0 windows; retain ordering, clock
calibration and raw logs. Report individual estimates and dispersion, not only
pooled totals. Exploratory ratio bands fixed before data: 0.9–1.1 supports ~1,
1.8–2.2 supports ~2 only when all repetitions/uncertainty and observer checks
are compatible. Values outside or inconsistent between runs are unresolved and
must be explained; these bands are not a gameplay-parity acceptance criterion.

## Interpretation matrix

| Result | Decision |
|---|---|
| Level/player/substep and limiter-driver entry rates all ~2; per-outer substeps remain 2; +0x574 slope ~2 | CORROBORATES shared level/driver scheduling doubling in this scene; engine-wide ownership remains unproven until non-player sampling |
| Level/player/substeps ~2 but limiter-driver rate differs | Supports shared level doubling but leaves driver relationship unresolved; do not force the engine-global interpretation |
| Player/substeps ~2, level and limiter ~1, attributed counts trustworthy | Supports a player-local scheduling change; reconcile changed multiplicity/phase before any split patch; a fixed one-call chain would be contradicted |
| Level/player ~1 and restored A0 agrees | Falsifies simple B0-doubling premise for this state; inspect whether limiter was active and wait was actually exercised |
| Outer ~2, +0x574 slope ~1, dt guards unchanged | Contradicts the simple outer-delta integration model or sample attribution; resolve before further patching |
| Substep/outer ratio changes despite unchanged loop word | Alternate paths, missed logs or dispatch model failure; not evidence for a clean two-pass model |
| Branch equality/inequality and WAIT observations contradict the decoded control flow | Observer/address/module or control-flow assumption invalid; stop |
| Rates change nonuniformly, restoring A0 fails, instrumentation saturates or state differs | Inconclusive; no promotion and no additional candidate writes |

## Restoration, records and stop

Use a finally/cleanup path for every B0 exit, including timeout/error. Pause only
the verified isolated instance; restore **the exact saved relocated U word** to
the same guarded loaded module; invalidate code cache and verify raw readback.
If module identity changed, do not write the stale address: stop paused and report
the restoration blocker. Verify G/S/P unchanged. Release only owned inputs, remove
only owned breakpoints/logpoints, restore initial pause state when safe, record
cleanup success. A restored-A0 control must recover baseline within measured
uncertainty before interpreting B0. Never silently continue after cleanup failure.

Save UTC, actual Git HEAD/dirty hashes, script/config/module/checkpoint hashes,
normal-save lineage, scene/equipment, raw per-window counters/clock samples,
branch outcomes, field values, observer diagnostics, exact before/after words,
cleanup and contradictions. Keep RAM/save/binary payloads in ignored local storage
and publish hashes plus selected derived measurements. Update CURRENT_STATE.

STOP after A0/B0/restored-A0 interpretation. Next queue only then: (1) Lvl3Elevator
0x156710 progress vs calls, (2) candidate 0x6EBE4 manager ownership/cadence,
(3) LaserTracer dispatch+gate+local rate with progression lineage, (4) one enemy,
(5) one projectile, (6) camera, (7) L03 platform/fluid ownership and motion.
No B1/C/D correction is authorized by completion of this gate alone.
