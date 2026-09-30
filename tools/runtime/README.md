# RACSM Runtime Observer (v0.2)

Small local, memory-read-only runtime observer for *Ratchet & Clank: Size
Matters* (`UCES00420`) under PPSSPP on Windows. Owner-facing weapon profiles
discover their own live object/pvar addresses with one internally owned
temporary true stop-breakpoint, remove it, resume, and then sample while the
owner plays normally.

It is tooling only: it does not patch the game, does not interpret gameplay and
does not decide whether a state is "correct".

## Prerequisites

- Windows with PPSSPP running and its debugger server enabled on a TCP port
  (the WebSocket endpoint `ws://127.0.0.1:<port>/debugger` must answer).
- Node.js 22 or newer. `Start-RacsmObserver.ps1` looks for `node` on `PATH`
  and in a few known install locations; otherwise pass `-NodePath`.
- No extra packages: the observer uses Node's built-in `WebSocket`.

Note (2026-09-20): this machine has no standalone Node.js install, so the
launcher borrows a runtime it finds (currently the one bundled with the Codex
app, or Adobe's). Installing Node.js 22+ normally is the more durable option;
the launcher always prints which runtime it selected.

## Launch

```powershell
.\tools\runtime\Start-RacsmObserver.ps1 -Port 60907
```

Other options: `-MeasurementsDir <path>` (default `<repo>\measurements`),
`-NodePath <node.exe>`, `-NoBanner`, `-SelfTest`.

## Commands

```text
racsm> status                          verify connection, game, module and the four guards
racsm> profile                         list available profiles
racsm> profile flamethrower             select an automatic gameplay profile
racsm> start [optional_name]            auto-bind on first weapon update and start recording
racsm> stop                             stop and finalize all output files
racsm> profile player-clock             select a legacy/manual profile
racsm> entity 0x09471640               set its active entity base address
racsm> peek                            read the profile once (no file written)
racsm> capture test_A0 10              measure for 10 s into measurements/test_A0/
racsm> capture test_C1 10 --interval-ms 20
racsm> compare test_A0 test_C1         write comparison.json + COMPARISON.md
racsm> list                            list existing captures
racsm> quit
```

`capture` also accepts `--no-ticks` (do not read the PPSSPP tick counter per
sample) and `--interval-ms <0..10000>` (pacing; see limitations).
`start` accepts the same flags, but has no duration: it records until `stop`.
If its name is omitted, a profile/state/timestamp name is generated.

## Status output

`status` (re)connects if needed and prints: PPSSPP version, game id/version/
title, CPU state and ticks, active module (`rcp1`) with runtime base and size,
the four guard words with their labels, the recognized state
(`A0`/`B0`/`B1`/`C1`/`UNKNOWN`), the active profile and the active entity.

If the guards do not match exactly one known state, it prints

```text
STATE = UNKNOWN
CAPTURE REFUSED
```

plus one reason line per mismatching guard. A hybrid or unexpected combination
is always refused; nothing is guessed. After such a refusal you must run a
successful `status` before any new capture.

## Profiles

Profiles live in `tools/runtime/profiles/*.json`. Automatic profiles may use
`object`, `pvar` and `module` bases plus a bounded binding recipe; legacy
profiles may still use `entity`:

```json
{
  "name": "player-clock",
  "fields": [
    {"name": "dt", "offset": "0x56C", "type": "float32", "base": "entity"},
    {"name": "phase", "offset": "0x570", "type": "float32", "base": "entity"}
  ]
}
```

- `base` is `entity`, `object`, `pvar` or `module`.
- `type` is one of `float32`, `float64`, `int32`, `uint32`, `int16`, `uint16`,
  `int8`, `uint8`.
- Fields that are close together are read with a single `memory.read` block.
- The profile file hash and a normalized hash are recorded in every manifest,
  and `compare` refuses to mix different profiles.

The shipped `player-clock` profile is a demonstration: `dt` (+0x56C),
`phase` (+0x570), `accumulator` (+0x574), `normalizedStep` (+0x578). The field
names remain tentative labels, not confirmed semantics.

## Measurement files

```text
measurements/
  <capture>/
    manifest.json     provenance: game, PPSSPP, module, guards, state, profile
                      hash, entity, read plan, durations, counts, rate, warnings
    samples.csv       index, monotonic timestamp, elapsed seconds, ticks, fields
    samples.ndjson    same data, one JSON object per sample
    summary.json      duration, counts, real sample rate, per-field
                      start/end/min/max/mean/delta/slope, warnings
  comparisons/
    <A>__vs__<B>/
      comparison.json
      COMPARISON.md
```

Raw samples are never overwritten: `capture` refuses a name whose directory
already contains files. Missed reads are kept as rows with `sample_ok=0`
(`sampleOk: false` in NDJSON) and an `error` string; the miss count and reasons
are in the manifest.

## What `compare` checks

Comparison is refused when profiles (name or normalized hash), entity
addresses, game id/version or module names differ. Module *base* is recorded
for provenance but is not a compatibility key (it changes per launch).
Automatically bound object/pvar bases are also provenance rather than a
compatibility key because valid instances may occupy different addresses.

The report contains, for each metric: value A, value B, `B/A` when
mathematically valid (otherwise the reason it is omitted) and `B - A`, plus
both durations and sample counts. It deliberately contains **no** gameplay
conclusion: no "correct", "bugged", pass or fail statement.

## Safety

The client permanently refuses memory/register writes, input, savestates,
configuration changes and debugger-port changes. An automatic profile may own
exactly one true stop-breakpoint for address discovery. It refuses to coexist
with any existing breakpoint, reads declared registers only, removes its
breakpoint, verifies removal and resumes before sampling. Cancellation and
shutdown perform the same cleanup. Binding provenance and cleanup status are
stored in the manifest.

`status` is re-verified during captures; if the module base moves, the state
changes or the connection drops, the capture stops and identity is invalidated.

Guard words are read with `memory.read(..., replacements:false)`, the primitive
already used by the repository's live sessions. The debugger's
`memory.read_u32` can return emulator-internal words for patched instruction
addresses (observed on 2026-09-20: it reported `0x68001c76` where the real
instruction was `0x00000000`), which would make a known state look UNKNOWN.

## Known limitations

- **`memory.read` halts the emulated CPU for the duration of the read.**
  Measured read-only on 2026-09-20 (PPSSPP v1.20.4, state C1): back-to-back
  `memory.read` calls held emulated time at ~0.01 MHz (222 ticks per read)
  versus ~222 MHz idle, and every sampled field stayed constant. The sampler
  therefore paces its reads (`--interval-ms`, default 20). With that pacing the
  emulated clock ran at 99.9% of real time (`emulated_time ≈ observed`) while
  still producing ~50 samples/s. Use `--interval-ms 0` only if you deliberately
  want a frozen snapshot; captures taken that way are flagged with
  `clockFrozen: true` and a warning.
- **The sample rate is whatever the capture measured.** It is always reported
  (`sampleRateHz`, `sampleIntervalMs`) and never assumed to be 30 or 60 Hz.
  Sampling slower than the underlying clock aliases the data; a 20 ms interval
  gives ~50 samples/s, which is already marginal for 60 Hz dynamics.
- Legacy `entity` addresses remain runtime-specific. Automatic weapon profiles
  bind fresh object/pvar bases on every `start` and need no user-supplied address.
- v0.2 uses a breakpoint only for the first binding hit. Sampling afterwards is
  free-running, so per-callback tracing remains out of scope.
- `status` reports a state, not a validated patch: recognized guards do not
  prove which patch mechanism produced them, nor gameplay parity.

## Self-test (no emulator contact)

```powershell
.\tools\runtime\Start-RacsmObserver.ps1 -SelfTest
# or
node tools\runtime\tests\run-observer-tests.mjs
```

The suite drives the observer against a fake PPSSPP debugger (implemented in
`tests/fake-ppsspp-debugger.mjs`): launch, connection, `status` for A0 and C1,
UNKNOWN refusals (hybrid guards, unexpected scalar word), profile loading,
capture file generation, comparison and its refusals, module-move resilience,
automatic binding/start/stop, cancellation cleanup, frozen-clock warning,
clean `quit`, and proof that no forbidden event was sent. Raw test data is
written under the system temp directory.

## Example workflow: owner-driven weapon capture

```text
racsm> profile flamethrower
racsm> start pokitaru_flamethrower_A0
   ... return to PPSSPP and fire once; capture announces STARTED ...
   ... continue normal test gameplay ...
racsm> stop
   ... owner changes to the matched C1 state ...
racsm> start pokitaru_flamethrower_C1
   ... fire and play the same protocol ...
racsm> stop
racsm> compare pokitaru_flamethrower_A0 pokitaru_flamethrower_C1
racsm> quit
```

Every A0→C1 transition is done by the owner in PPSSPP; the observer never
applies a state and never verifies one for you beyond the four guards.
