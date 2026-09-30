# Pokitaru free-play family recorder — experimental

Owner requested two free-play sessions A0 then **C1 CORE ONLY**, without exact
route replay. This package observes invoked code; it does not correct gameplay.

## Implementation

The pinned vanilla ELF, existing timing atlas and historical direct-wrapper
callsite register generate one-word JAL/JALR probes. The original delay slot and
callee execute once. The legacy context-save mechanism is adapted without its
FPS/full_layers15 policy. Unknown/target-modifying/relocated delay slots are
excluded explicitly. Original game assets and the legacy source remain intact.

Current scope:322 instrumentable callsites,150 update-associated callback RVAs,
12 excluded sites. Runtime matching resolves callback aliases, not necessarily
the exact class where several classes share one function. Static T1-T9 labels
are candidates, not proof of semantic timing defects. Other callers/mechanics
remain UNKNOWN. Counts include every instrumented invocation; register/field
events are sampled (default every8 hits per site, plus its first hit).
The initial C1 pilot overflowed at stride8. Use `--stride 31` for the next
discovery pilot (tested without further losses in the immobile scene), leaving
headroom and changing the repeated-order sampling phase. Deterministic stride
can still alias instance order: invocation, register and field coverage are
reported independently. Absence of a field sample is UNKNOWN, not inactivity.

Selected pvar channels: Lvl3Elevator progress/increment, Level01HelpManager timer,
Acidbomb countdown/integration fields. Their a0 pvar-load instructions are
reproduced by the builder. Per-record object ownership/lifecycle still needs
live acceptance. Raw position, pointer-header and incoming f12 bits supply
context; do not interpret every f12 as a timestep or match recycled pointers
as a continuous object. No unverified general physics schema is imposed.

Counters and a128-event ring use bounded static memory; loss is recorded. The
hot path saves context and suspends dispatch for coherent updates; its cost is
UNKNOWN until the baseline/counters/samples pilot. Export runs outside the hot
path. Files use exclusive names trace-000.bin onward and are never truncated.
Newlib heap16KiB is verified in linked ELF. Schema2 embeds the source-input build
fingerprint and exact output number. Whole-trace prefixes require sequence0;
partial suffixes are unsupported. Mode0 leaves game callsites original;
baseline3 exports clocks without installing probes. Modes1/2 install probes.

PSP kernel microseconds are raw game-time observations. The controller brackets
their advancement with debugger CPU ticks; calibration bounds and observer cost
must pass before physical-rate conclusions or long owner sessions.

## Guards and lifecycle

Binding requires unique rcp1, LEVEL01 segment extent46B830,22 content guards,
strict A0/C1 core guards and every original callsite/delay. Runtime J reachability
is checked. Owned-site/delay checks continue during capture. Changed contents,
foreign code, or ambiguous module queries invalidate capture and retain ownership
with **status3/no writes**. They require a full PPSSPP close; successful removal
must not be claimed. Confirmed unload is status4. Installed stubs remain resident
after removal, and module_stop refuses unloading after any use because a
preempted game thread may still be inside a stub.

Normal disarm requests mode0 then verifies every original site/delay. This is
separate from the core-state tool. The controller writes only PRX request/stride
words, validates loaded hook bytes, refuses corrective companions/core changes,
preserves failures, and reports unresolved cleanup explicitly.

## Reproduction and acceptance

- `build.py --name <new-name>`: refuses existing outputs, pins all input hashes.
- `test_offline.py --build <build> --out <new-json>`: compiled-hook adversarial
  register/HI/LO/FCR/FPU model and stream corruption/segmentation checks. These
  do not establish emulator behavior. Failed build directories are preserved.
- `tools/runtime/install-freeplay-recorder.py`: requires complete PPSSPP closure,
  matching source/build/offline-test hashes; backs up named companion mappings
  and disables their UCES entry for core-only discovery. Does not alter ISO/PRX.
- `tools/runtime/record-freeplay.py --build <build> --mode baseline|counters|samples
  --seconds <duration> --out <new-json> [--trace-file <installed-trace>]`:
  bounded capture, bracketed clock, verified cleanup, optional frozen trace copy.
- `tools/runtime/analyze-freeplay.py --build <build> --trace <file> [--trace <file>]
  --out <new-json>`: strict decoder and A0/C1 callback coverage. Aggregate session
  counts/rates depend on action/instance exposure and are not defect verdicts.
  Across-file coverage is explicitly unpaired. Exploratory field-rate candidates
  retain clock/state/lifecycle uncertainty and require targeted confirmation.

Next gate: normal-save Pokitaru short baseline/counters/samples captures in A0,
then C1, installation/removal byte checks, clock and overhead bounds. No long
free-play session until this gate passes. Cascade/wing additions are a separate
named regression arm. Evidence remains local; no validated patch promotion.
Passive startup, immobile A0/C1 capture and one-site counter attribution have
passed in the indexed family-recorder-001 report. Busy-play/transition coverage
and semantic channel parity remain separate gates.
