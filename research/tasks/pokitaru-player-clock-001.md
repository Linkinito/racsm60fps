# PLAYER-CLOCK-001 — Pokitaru player-clock ablation

Primary question: why did the historical core restore Ratchet movement/physics and reportedly some animation timing at 60 FPS? Pokitaru is the first laboratory. This task authorizes only isolated reversible experiments, never official V2 patch inclusion. Parent alone controls PPSSPP; DeepSeek supports read-only analysis via `player-clock-001-support`.

Read `AGENTS.md`, `PROJECT_GOALS.md`, evidence levels, completed V1 `sol-review.md`, `research/v2/timing-domains.md`, `research/v2/pokitaru/player-clock-socle-map.md`, and `research/v2/hypotheses/player-clock.md`.

## Arms

U=VBlank unlock; G=general delta; S=substeps; P=local scalar doubling. Original/candidate words and qualified RVAs are in the map. All other code/data/routes remain at verified original state.

| Arm | Changes | Purpose |
|---|---|---|
| A0 | none, vanilla 30 FPS | genuine reference; cold-boot lineage |
| B0 | U | isolate outer cadence |
| B1 | U+G | discriminate general-delta consumers |
| B2 | U+S | discriminate iteration-driven behavior |
| B3 | U+P | isolate local scalar; may over-integrate |
| C1 | U+G+S | local-compensation comparison to D |
| C2 | U+G+P | iteration comparison to D |
| C3 | U+S+P | delta comparison to D |
| D | U+G+S+P | complete four-component socle |

These combinations are test arms, not safe gameplay releases. No code dependency has yet proved any combination invalid; B3/C3 may produce extreme motion. Run idle/short bounded observations first. Document unreachable branch or invalid state instead of silently dropping an arm. Never import historical eight/22-word socle, camera, Titanium, wrapper routing, weapons or object fixes into these arms.

## Preconditions and stopping gates

1. Identify PPSSPP executable/version and active config, ISO path/hash and LEVEL_01 module hash, loaded base and relocation. Do not infer module solely from historical global 0x08841120. Confirm original raw instruction words with `replacements:false`, all relevant routes and plugin state. Hashes of a relocated RAM module will not equal file hashes; compare normalized relocation/code regions with recorded method.
2. Preserve the user's current session before navigation. Prefer an isolated emulator/memory-stick/config and cold boot with copied normal save or new-game state. Unknown legacy savestates are unsuitable for A0 until provenance and dynamic state are verified. No destructive save overwrite.
3. Establish repeatable safe Pokitaru location, health/state/equipment/animation and input-neutral state. Record state creation under verified A0. Use identical source state for arms, reapply guarded words after state load, verify before and after. No save progress during tests.
4. Independently measure outer simulation count, VBlank count and elapsed wall time. Plugin requested/applied FPS and display refresh setting are not cadence measurements. Frame advance can measure emulated work but not unattended real-time pacing while debugger pauses are inserted.
5. Require verified player/animation observables before claiming behavior. Watchpoints/breakpoints must have known overhead; do not compare breakpoint wall times to free-running A. Preserve original CPU pause state, release injected input and remove owned breakpoints in `finally`.

If module/save provenance is ambiguous, scene control cannot reproduce the setup, destructive persistent modification is needed, or hypotheses cannot be separated with available instrumentation, persist a blocker and request the missing human input. No speculative address writes.

## Input and observables

Investigate native PPSSPP replay first; if unsuitable, use documented debugger input synchronized to emulated frames/VBlanks; wall-timestamped injection is a fallback with recorded scheduling error. Manual timing is last resort. Record stick mapping/deadzone/AnalogIsCircular, frame skip, speed/clock, vsync, rendering backend, run-behind-pause and focus behavior. Hold zero input for idle, constant cardinal stick for running, and exact press/release schedule for jumps.

Capture player position vector, position-derived horizontal displacement/velocity, candidate raw displacement vector, player state/flags, grounded proxy validated against jumps, jump launch/apex/landing, duration/apex/horizontal distance, animation ID/phase/rate once validated, outer-entry and actual substep counts, f12/f20 input/output and candidate timer fields. Candidate offsets are in the map and require correlation before semantic names. Store unsupported observables as UNKNOWN.

Scenarios: idle cycle; straight run; start/stop; standing jump; forward jump; simple wrench cycle only if animation/event measurement is reliable. Define world-space axes and zero origin from the same state. Detect jump events from state/position with explicitly documented thresholds; do not infer them from input time alone.

## Adaptive execution order

First verify A0 at least three repetitions with stable field/clock observations. Estimate measurement resolution and run variance; predeclare tolerance from these, e.g. one simulation interval plus measured uncertainty for event duration, never an arbitrary percentage chosen after seeing C.

Then run short B0 trials from the same setup and verify achieved cadence. Compare per-call changes as well as per-second rates. Next B1 is normally most informative for idle animation vs locomotion. If B1 restores animation and motion remains fast, test B2 or C1 to separate iteration effects. If B1 does not restore animation, locate phase owner before adding more patches. Compare C1 with D to isolate local scalar, including outside-loop +0x574 slope. If B0 already matches an observable, preserve that null result and investigate hidden normalization. Do not run all eight combinations automatically.

Use three repetitions for screening and five paired/reordered repetitions for any proposed restoration, checking reset state and branch comparability each time. Include a final restored A0 to detect drift or contamination. A candidate progresses through controlled test, comparison, replication, independent skeptical review and parent review before TESTED; official V2 merge remains a separate authorization.

## Storage and resume

Store under `research/live-tests/pokitaru/player-clock-001/`, unique run/session directories. Each record includes git HEAD and dirty-file hashes, UTC time, emulator executable/version/config and input mapping, ISO/module hash and loaded base/delta, exact before/after words and routes, plugin list, save/state identity and lineage, input sequence, raw samples with clocks, derived metrics and script hash, notes, evidence status, restoration outcome and next discriminating test. Failed preflights are retained; they are not A0 gameplay runs.

Keep `RESUME.md` current. The completed V1 mission must never be restarted merely because context is lost. Supporting worker reports are untrusted until reconciled against binary/live evidence.
