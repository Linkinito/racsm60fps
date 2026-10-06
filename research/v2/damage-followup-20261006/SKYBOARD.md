---
kind: static
title: "Skyboard mines: transient speed scaling and direct displacement"
date: 2026-10-06
authors: ["GPT (Codex)"]
status: complete
evidence: [OBSERVED, CORROBORATED, INFERRED, UNKNOWN, TESTED]
summary: "Resolved LEVEL22 mine consequence setters and movement consumer; no HP subtraction in those paths, with crash/respawn and race outcomes still open."
systems: [Skyboard, AirRaceMine, movement, hazards, minigames]
levels: [LEVEL_22]
variants: [A0, B, C]
environment: "Clean native module and exact PSP field-reference queries; no runtime/race test"
related: [research/v2/damage-atlas-20261006/CLANK_MINIGAMES.md, research/scripts/ghidra/recipes/damage-followup-skyboard-001.json]
---

# Result

The prior atlas's mine slowdown/knockback inference is now bound to explicit
movement writes. 4710C arms a short-lived global multiplier;47144 copies a
vector and a count;46BB8 consumes them by scaling displacement and adding
direct position offsets. Neither setter nor this complete movement helper
subtracts HP or dispatches a damage receiver. Mine effect helperEBAE4 is a
separate presentation producer. Actual crash, out-of-bounds, death, respawn or
race penalty consequences remain UNKNOWN; this pass does not establish that
mines can never cause those indirect outcomes.

# Provenance and reproduction

Source `02-Jeu-et-dumps/Data/BACKUP/BIN/LEVEL_22.PRX`, SHA-256
`be7ef86357ee668bb1c194226e4cd2e55920a4f7f375952ffb494c0de5a78986`.
Recipe `damage-followup-skyboard-001.json` has6 bounded native windows and7
PSP references, including full reviewed movement46BB8..46DA8, effectEBAE4..
EBC88 and mineEC86C..ECD0C. Method source preservation is TESTED offline only.
Raw listings/manifests stay under ignored local damage-followup storage.
No matching, new function inventory, import, live interaction or game write.
No LEVEL23 equivalence is promoted from these LEVEL22 constants/consumers.

# 1. Transient multiplier4710C

Native f12 is compared with0; a negative input returns without changing the
fields. A nonnegative input writes global2222C8 and sets integer2222CC=2.
The helper does not impose an upper clamp at1. A caller can repeatedly refresh
the count; this is not a fixed two-frame slowdown duration by itself.

46BB8 first forms displacement1A8/1AC/1B0 from its supplied vector scaled by
f12. When2222C8>=0, it multiplies these displacement components and a separate
global contribution by2222C8. It adds that global contribution to object
position30/34/38, decrements2222CC by1 and sets2222C8=-1 when the count reaches
zero. Negative2222C8 takes the unscaled global-contribution path. It eventually
adds1A8/1AC/1B0 to position and sets homogeneous3C=1.

Thus speed/displacement scaling is CORROBORATED. Duration and total distance
depend on the number of46BB8 consumers between repeated mine setter calls,
their supplied motion and gate/order. Two consumer calls without refresh
exhaust an initial count2; render frames are not established clock units.

# 2. Impact vector47144

The helper's a0 vector must be nonnull. Its canonical player pointer resolves
to29DB80, but the native nonzero test is of the materialized pointer rather
than a player HP/eligibility field. It stores a1 at2222D0 and copies the three
floats into global2D3158/5C/60. AirRaceMine supplies a1=2.

46BB8 tests2222D0>0, adds that vector directly to position30/34/38, decrements
the count and writes-1 when exhausted. It does not multiply the copied vector
by its incoming delta in this branch. Two admitted consumers with no refresh
can therefore add the same vector twice. Repeated setter calls overwrite the
vector and reset the count; cumulative movement depends on ordering/cadence.

The located reset writer48310..4831C stores0 into2222CC/D0. Its larger state
entry and activation timing were not resolved. Initialization/caller ownership
must be measured rather than treating clean zero data as a full reset protocol.

# 3. Mine source envelopes and separate effects

The old atlas named constants24E17C/24E184. An attempted direct file read at
24E17C failed because that address is not uniquely file-backed in clean22.
Native PSP HI/LO ECAF4/ECAF8 and ECB98/ECB9C instead resolve to **23E17C=0.6**
and **23E184=3.0**. These new LEVEL22 coordinates supersede those two inherited
addresses only; the old report remains preserved. They are clean file values,
not a runtime initialization or seconds-duration proof. Initial2222C8 is-1;
the two integer counts are0.

Prior state1 target query/slowdown configuration and state4 recovery remain
as documented in CLANK_MINIGAMES.md. For ordinary-impact state3, nativeEC86C
throughECD0C additionally confirms:

- While age70 is below23E17C, normalize source vector148/14C/150, scale by
  pvar204 times `(1 - age/23E17C)`, clamp a negative Y component to0 and call
  47144(vector,2). Nonzero vector validity is not guaranteed by this arithmetic
  alone; no runtime division failure is asserted.
- While age70 is below23E184, call4710C(age/23E184).
- Write pvar208 from a clamped presentation envelope based on
  `(23E17C - 2*age)/23E17C`; this field is not a proved HP store.
- Once both time windows have passed, request mine state4 and recover through
  47684/106340/1063E8 before reset to1.

Slowdown state2 also calls4710C with its age/progress factor and eventually
EBAE4/state4. The bounded EC148 head now confirms its age producer: after
config/pvar and canonical-pointer guards, EC22C..EC234 adds literal float
**1/30 (3D088889)** to moby70. It also subtracts that same literal from pvar1DC.
It is a per-call nominal-time increment, not incoming elapsed delta. EC148
stores target-minus-mine vector148/14C/150 and derives distance1E8 and a
clamped-looking spatial envelope1E4 before the increment. Full helper tail,
call ownership, resets and eligible cadence remain unclosed. Conditional
nominal window lengths are about18 and90 age increments, with floating/strict
comparison and initial phase affecting exact boundary calls. They are not
measured0.6/3-second durations at either render rate.

EBAE4's complete reviewed body constructs a scale/position matrix, calls58354,
then1159C0/1163B8 with position, configured values, colors/parameters and counts
1E/78. It contains no ordinary HP write, group receiver or terminal-player
request. Its effect/presentation role is INFERRED from the call/data shape;
full indirect callee semantics remain outside this scoped closure. It must not
be counted as a second HP attack merely because it occurs at detonation.

# Minimal measurement and remaining gaps

Record mine type/state/age, source vector and204, globals2222C8/CC/D0/2D3158,
each4710C/47144 call, each46BB8 consumer, player position/speed/HP/state and
race/crash/out-of-bounds result. Compare one isolated contact against repeated
contact; record consumer ordering and whether the two counts are refreshed.
Separate movement loss from HP loss, effects, control suppression and respawn.

Open: race actor/control callback ownership, age/delta units, reset/initialization
entry, rider crash/death/out-of-bounds, race-controller result/time penalties,
sentry/other obstacles, LEVEL23 consumers and data, indirect presentation
callees. No broad half-rate patch or gameplay-parity acceptance follows.
