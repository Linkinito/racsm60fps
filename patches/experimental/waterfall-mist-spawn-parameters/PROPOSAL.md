# LEVEL_01 mist-family lifetime/interpolation experiment

Naming correction: the 0x40 family studied here is now CORROBORATED as white
surface foam/wave shapes by the [emission-suppression follow-up](../../../research/live-tests/pokitaru/waterfall-007-mist-visual-20260926/REPORT.md).
The earlier “mist/no waves” wording below is SUPERSEDED; this legacy path and
proposal are preserved. Actual mist opacity also needs the separate0x50
alpha007 correction in companion v8. C1 remains the external timing core only.

Status: **UNVERIFIED_STATIC_CANDIDATE**. This is a proposal, not an installed
patch or a full mist/river correction. No original game asset may be modified.

Follow-up: [live experiment](../../../research/live-tests/pokitaru/waterfall-004-20260926/REPORT.md)
TESTED the pair on new owner-bound records. It restores lifetime/counter rate
but doubles occupancy alone, so the pair is REJECTED as a complete spawn fix.
The expanded experimental candidate adds damping, translation and rotation,
and supersedes emission1/6 with the shared Waterfall every-fourth-update gate.
The [standalone companion](../waterfall-companion/README.md) is built separately
from C1 core and explicitly includes droplets006, mist and the common emitter
gate, no waves. Droplets006 also corrects second-family damping, rotation and
scalar growth while preserving original spawn velocity bounds. The rejected
four-word speed probe and superseded emission1/6 are excluded.
Its PRX loading/runtime remains unvalidated. The original proposal below is
retained as the protocol used for the first isolated test.

## Minimal runtime candidate

Resolve the active `rcp1` LEVEL_01 module and apply a guarded, reversible pair
of data-word changes at module-relative addresses:

| RVA | Expected | Replacement | Meaning from static trace |
| --- | --- | --- | --- |
| `0x2D49E8` | `0x42700000` (60) | `0x42F00000` (120) | lower lifetime denominator |
| `0x2D49EC` | `0x42B40000` (90) | `0x43340000` (180) | upper lifetime denominator |

Bind these sites to vanilla LEVEL_01 SHA-256
`d10a81d076fb44987a45314a020cda2f7e8b39f860b957911ca9365464676571`
and the hash-pinned instruction context in the read-only analyzer. Existing
records are unchanged; the emitter initializes future records with a half-rate
normalized counter and half-rate scalar interpolation. Do not combine with
005's counter/scalar half-steps, which would apply the correction twice.

## Falsifiable live protocol

1. Fully restart PPSSPP and load the owner-selected cascade state. Confirm
   module identity, fresh runtime base, A0/C1 guards and no leftover 005 hooks.
2. In A0 and C1 without this pair, identify the same emitter family and capture
   new record `+0x1C`, `+0x20`, `+0x18`, `+0x34`, lifetime and active count.
3. In C1 keep proven droplet 004, apply ONLY this pair with expected-word
   preflight, readback and a 5 s health check. Preserve rollback values.
4. Wait for old records to expire; analyze only records created after the
   change. Repeat matched captures and correlate them with visible mist.
5. Success requires A0-like counter/scalar/lifetime measurements, stable
   geometry and return behavior, and a documented occupancy comparison.
   A visible improvement alone does not establish parity.
6. Revert both values. Require recovery to the C1 baseline. If the effect is
   supported, port this pair into a separate guarded companion component.

Translation, angular recurrence, velocity damping, emission cadence and the
visible river-wave channel remain outside this candidate. A parameter-only
angular correction loses small nonzero rotations and is not included. The
earlier shared rotation/damping claim was SUPERSEDED: damping is independently
loaded from record+38, config+0; see the correction in the analysis report.

Evidence and reproducible model:
[analysis report](../../../research/v2/waterfall-static-simplification-20260926/REPORT.md).
