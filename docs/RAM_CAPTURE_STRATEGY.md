# RAM capture strategy — 2026-10-03

## Decision

A complete RAM dump for every level is not a prerequisite for static
decompilation. The existing extracted PRX modules and relocation-aware Ghidra
imports provide executable code and static data. Capturing all levels blindly
would not establish function cadence, gameplay parity or full object coverage.

Runtime evidence is still needed for dynamically initialized parameters,
object/pvar layouts, indirect callback bindings, active groups, level-specific
content and special gameplay modes. Prefer bounded captures of the actual
objects and dependencies needed for a stated question. Full-game validation
will need representative live scenes across distinct modules/modes; this is
different from requiring a full dump of every level.

## When to capture

| Question | Preferred evidence |
|---|---|
| What does a function do? | Original module, relocations, targeted decompilation/callers |
| Which callback owns this visible effect? | Active object/group/particle records and final callback pointers |
| Which parameters were loaded for this weapon/upgrade/enemy? | Bound configuration table and object state in the relevant scene |
| How often does it run, and what changes per call? | Timestamped trace or controlled frame/true-stop measurements |
| Is this correction faithful? | Matched original30 / uncorrected60 / candidate60 measurements |
| Does loaded code differ from the extracted module, or are required dependencies unbound? | Relocation-aware module capture; widen to full RAM only if necessary |

One dump at level entry can miss objects loaded or spawned later, boss phases,
weapon upgrades, scripted scenes and different modes. Repeated scene-specific
captures are more useful when those are the actual unknowns. An address alone
is insufficient: module content can change while its base address stays the
same, as previously observed during a level transition.

## Minimal reproducible capture

Claude owns live gameplay and PPSSPP experiments. For a targeted capture record:

- UCES00420/source hashes, exact level/module/mode and scene, normal-load versus
  savestate provenance, weapon and upgrade, and relevant event/input state;
- PPSSPP version, renderer, emulated clock, measured FPS and foreground state;
- original30 / uncorrected60 / candidate60 profile and all active experimental
  fixes with hashes; prefer an original30 clean-load baseline first;
- module identity/base/guards, CPU ticks/frame markers, captured address ranges,
  pointer derivation, byte counts and SHA256 hashes;
- the object, pvar/configuration, owning group/callback and relevant emitter or
  particle records; related ranges should be coherent in time;
- the question answered, evidence status, missing dependencies and limits.

A static snapshot cannot measure call rate or causality. Pair it with traces
or A/B/C experiments when timing is the question. Keep RAM, module bytes,
savestates and disassembly local and ignored; commit only project-authored
methods, hashes and reviewed interpretations.

## Immediate need

No new whole-level dump is required to continue the current Tremblator
decompilation. The next missing evidence is a bounded fresh-shot capture of
final particle callbacks and a time-resolved entity/segment trace, followed by
controlled A/B/C measurements. Other levels should be captured when their own
runtime-only question becomes active.
