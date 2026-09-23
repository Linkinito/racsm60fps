# Development status — 2026-09-23

## Objective and present boundary

The Priority 0 target is a faithful 60 FPS version of UCES00420 with original
30 FPS gameplay behavior over elapsed game time. A0 denotes the original
30 FPS game; B0 is uncapped 60 FPS; B1 adds the 1/60 shared delta; C1 also
uses one player substep. C1 is an experimental base, not a parity verdict.
Priority 0 also covers non-interactive visual timing and lifetimes, including
box debris, Pokitaru butterflies and `SharkgatorFin`, and level-up animations.
No parity result for these examples has yet been measured.

The code direction is a guarded companion PRX, leaving the ISO and original
game PRXs untouched. The current experimental elevator component covers five
known `Lvl3Elevator` module copies by exact hash and nearby-word checks. A
fresh LEVEL_03 instance acquired the correction, and one matched elevator
ride was 2.497471 s in A0 versus 2.541371 s with the earlier companion
(+1.76%). The newer five-module package has not been observed in game; the
four additional routes remain untested. The gap's cause is UNKNOWN.

## What the evidence changes

| Mechanism | Current finding | Development implication |
| --- | --- | --- |
| Outer callback with fixed step | Elevator and Waterfall speed up when eligible calls double; Waterfall's short cycle is directly measured. | Test a narrowly guarded rule per identified channel, starting with Waterfall. |
| Incoming-delta channel | Acidbomb's delta countdown retains its real-time rate while its fixed decay doubles. | Preserve the delta channel and correct only the defective fixed channel. |
| Player-substep fixed step | AgentsGlove counters and Flamethrower phase retain their A0 real-time rates. | A fixed literal alone is not grounds for halving it. |
| Gate-qualified channel | LaserTracer's gate/drain rate doubles under C1. Earlier whole-body decimation failed as a gameplay solution. | Isolate the gate's consumers while measuring animation, clip drain and hits together. |
| Damage and lifetime | Flamethrower damage against Mungo is an owner observation without controlled hit/HP attribution; integer counters need consumer meaning. | Measure hit count, damage per hit, ammo and duration before scaling damage or lifetime counters. |
| Visual timing and lifetime | The owner identified box debris, non-interactive Pokitaru creatures and level-up animations as required parity scope; their update mechanisms are UNKNOWN. | Compare burst count, motion, fade/lifetime, pose cycles and one-shot effect duration in A0/B0/C1 before choosing any scale factor. |

The shared group callback at `+0x1C` is a dispatch route, not a universal
timing policy. Its writer/provenance and possible use by a nested second pump
remain UNKNOWN. Static catalogs provide candidate locations, not a list of
proven defects. The full method and test order are in
`reports/GLOBAL-TIMING-FAMILY-PLAN-2026-09-23.md`.

## Next development sequence

1. Resolve group `+0x1C` provenance and trace first/second-pump callback
   targets and cadence in A0/C1.
2. Measure a complete Waterfall A0/B0/C1 cycle with field, animation and
   transition observations. Implement only its causally identified channel
   in the companion PRX, then compare corrected C against A.
3. Use Acidbomb and AgentsGlove as mixed-mechanism and preserved-rate
   controls. Resolve LaserTracer's gate-specific effects and Flamethrower's
   damage channel with separate, reproducible A/B/C tests.
4. Generalize each rule to other classes and modules only after independent
   representatives and regression checks. Run matched visual-parity probes
   for debris, Pokitaru idle animation and a level-up effect. Keep corrections
   experimental until the validated-patch evidence gate is met.

## Publication scope

The curated GitHub update contains this status, the family plan and the
project's working instructions. Raw captures, measurement datasets,
experimental outputs and unvalidated patch artifacts stay in the local
research workspace. Their absence from GitHub does not raise the evidence
level of the findings summarized here.
