---
kind: static
title: "Environmental damage follow-up: Sharkagator exposure and grind HP/state death"
date: 2026-10-06
authors: ["GPT (Codex)"]
status: complete
evidence: [OBSERVED, CORROBORATED, INFERRED, UNKNOWN, TESTED]
summary: "Resolved Sharkagator admission/retained exposure and the canonical-player grind HP floor; preserved scene and clock uncertainty."
systems: [hazards, Sharkagator, grind, damage, death]
levels: [LEVEL_01]
variants: [A0, B, C]
environment: "Existing clean LEVEL01 C plus bounded native words and PSP relocations; no live test"
related: [research/v2/damage-atlas-20261006/REPORT.md, research/scripts/ghidra/recipes/damage-followup-hazards-001.json]
---

# Changed interpretation

Sharkagator's death request is now linked to a specific exposure/attack gate,
rather than treated as an unconditional nearby-monster kill. Its accumulated
exposure can continue while the principal condition is false; leaving the
condition does not necessarily reset the attack clock. Grind's direct HP floor
is clean-file0, and its helper affects only the canonical player. A separate
height/state route can request death without HP reaching that floor.

These are static causal closures. Water/swimming semantics, physical time and
the scene's enable/configuration remain partly INFERRED or UNKNOWN. The prior
atlas is preserved; its corresponding unresolved fields are superseded only
within the exact LEVEL01 read scope below.

# Provenance

Source `02-Jeu-et-dumps/Data/BACKUP/BIN/LEVEL_01.PRX`, SHA-256
`d10a81d076fb44987a45314a020cda2f7e8b39f860b957911ca9365464676571`.
Existing C at `research/v2/decomp-candidates/_local/20261001-mass/all/c/`
for16AFD4,16B0E0,16B248,31078/8C/98,31350,186E1C,4C2C0,4BDC0,
486E4,4884C,48A6C,39B74,2FB8C and targeted3C88C/39FD4/4E008 branches. Recipe
`damage-followup-hazards-001.json` reproduces15 native windows and5 PSP
references. Original source hash unchanged before/after: TESTED offline
preservation only. Generated native listings are ignored/local. Recipe windows
are explicit review ranges, not a new complete-function inventory.

# 1. Sharkagator exposure admission16B0E0

Native arguments are shark in a0, player in a1, index in a2 and increment in
f12. The decompiler's rearranged float-first prototype must not be used as the
native ABI. The shark's config54 first word is a trigger-group pointer; pvar58
holds per-index float accumulators at4*index, an attack index at10 and bit mask
at14. The shift is1<<(index&31); callers/valid index bounds were not established
by this helper alone.

The principal eligible condition is:

- playerE8 is nonzero (3108C), not a generic collision/HP test;
- current signed stateF8 equals1B (31098);
- trigger group is NULL, or186E1C reports **no** overlapping trigger at player
  position30.

186E1C checks the group's count/state45 and walks trigger pointers at54,
calling71C10 until an overlap is found. The group is an exclusion in this
principal attack gate; scene safe-zone naming remains INFERRED.

On eligibility,16B0E0 sets the index bit, adds incomingf12 to its accumulator
and compares against resolved2D6F3C **2.5**. At/above threshold it calls16B248,
returns1 and begins the attack sequence.

On ineligibility it reads95C/960 through31350. If95C bit2 is set, it clears the
accumulator and index bit. Otherwise, if the index bit was already set, it
**continues adding incomingf12**. The threshold check occurs only in the
principal eligible branch. Exposure can therefore be retained and grow through
some ineligible periods, then cause immediate attack on re-entry. Exact flag2
meaning and scene transitions remain UNKNOWN.

16AFD4's state0 forwards its incomingf12 to this helper without a known literal
reload. The2.5 threshold is not automatically2.5 seconds. Establish the caller's
delta units/cadence before changing it. It is not a fixed integer countdown.

# 2. Attack sequence and instant-death request

16B248 derives placement/orientation from player and camera, sets shark state45
to1, clears byte46, stores the attack index and starts animation0. A confusing
camera NULL branch in existing C is a decompiler limitation, not a proven
runtime NULL-dereference bug.

In state1,16AFD4 reads animation time6A9E0. Above0.1 it changes shark state to2
and calls31B64(canonicalPlayer,29). PSP relocation binds that player reference
to337940. There is no local scalar damage, armor calculation or common-player
97C check on this route. The downstream death-request helper still rejects an
already-terminal29..32 state, as recorded in the original atlas.

State2 waits for animation completion6AA08, returns shark to state0 and clears
the selected accumulator. Other mask/reset ownership is not fully closed.
Actual animation progression and whether a target can escape after attack
entry require live measurement. This is a potential instant death through a
state request, not evidence of a high floating damage scalar.

Existing player dispatcher3C88C maps1B to4884C->48A6C; enter39FD4 invokes
486E4. Those helpers control vertical target2D4, interpolated2D0/2D8, surface
query class2, input/animations24..26 and possible1D transition. This supports
a water/surface movement interpretation but does not by itself bind the retail
state label. The native exposure/death contract is valid without that label.

# 3. Grind direct HP and height/state routes

4C2C0 receives player in a0 and incoming damage in f12. It calls31078 without
changing a0. Native31078 is pointer equality with canonical337940, not an
unknown hit-eligibility predicate. Only that canonical player is modified.

Admitted result is `HP964 = max(HP964 - incoming, file2B0A1C)`; resolved floor
2B0A1C is **0.0**. There is no38540, armor calculation or common97C protection
inside this helper. Prior grind producers4C660/4DB6C and independentC54/C58
cooldowns remain as described in the original atlas. Clean world-contact scalar
2B09E4 is **1.0**. Runtime configuration and initialized scalar changes remain
UNKNOWN; these are positive clean-file values, not universal gameplay damage.

4E008 has two distinct terminal conditions:

- In the previously identified state6 branch, when byte2B0A50 is enabled,
  stored heightC3C minus currentY34 above2B0978 requests pendingFa=2C. The clean
  threshold is **1.0**. This branch can request death independently of HP loss.
- In the later completion branch, after three1A4E74 channels fall below0.01,
  HP964<=floor requests2C. With positive HP and byte2B0A50 zero it requests0/
  ordinary animation; with the byte enabled it also requests2C.

The height-enable byte is clean-file0. Native4BDC0 explicitly resets it to0
along with36CCF8/36CD18/19 and playerC6C. No nonzero writer was found in the
targeted existing named-global C search. That does not exclude indirect,
resident or scene initialization. Do not claim the height gate is universally
inactive, or manufacture a scene-specific lava/rail/fall label.

# 4. State-duration terminal condition, not a measured fall-distance field

The prior atlas left playerA1C's meaning UNKNOWN. Exact producer39B74 compares
current signed stateF8 with remembered stateFC. If equal it adds literal1 to
floatA1C; otherwise it copies F8 to FC and resetsA1C to literal0. Native39F84..
39FA4 confirms both branches, with f22=1/f24=0 established at39C00..39C08.
This CORROBORATES a duration-in-same-state counter, not a spatial depth/distance
field or a delta-in-seconds accumulator.

Existing3C88C C compares it with2B0168 in shared cases4/40 and cases12/36,
requesting pendingFa=2D on strict `A1C > threshold` when each preceding branch
reaches the comparison. Three scoped native loads at3DD1C,3E108 and3EA9C confirm
the same2B0168 read, strict comparison and pending2D stores. Their individual
native case-table bindings were not independently rebuilt; case labels retain
the existing decompiler provenance. Clean threshold is **240.0**.

2FB8C's ordinary player simulation loop calls3C88C, then39B74 inside the same
two-substep body when95C bit8000 is set and no alternateD90 controller replaces
it. The consumer therefore sees the previous post-update counter. This clock
already belongs to the player substep domain. The existing corrected loop/gate
can alter its physical rate; do not additionally halve240 merely because a
render rate doubled. Exact initial phase, state-transition ordering and callback
count to a terminal request remain live measurement questions.

The mechanism narrows a potential prolonged-state death. Retail fall/depth/
stuck labels and scene applicability remain UNKNOWN; the counter is not a
complete pit/kill-volume detector. Requests use the pending state directly,
with no local HP subtraction, armor or common97C admission.

# 5. Minimal live controls and remaining scope

For Sharkagator, record f12 units, index, accumulator/mask, playerE8/F8/95C,
trigger overlap, attack entry, animation time, playerHP/97C and pending/current
state. Compare continuous exposure, exclusion entry, ordinary state exit with
bit2 clear, and a bit2 reset. A reset assumption predicts differently from the
observed retained-exposure branch and is falsifiable.

For grind, record canonical identity, incoming scalar,964, C54/C58, state,
2B0A50, stored/current heights and each pending2C request. Separate HP exhaustion
from enabled height/completion deaths. Test both ordinary invulnerability and
armor values without assuming they protect the direct helper.

For duration terminal requests, capture F8/FC/A1C before3C88C and after39B74,
pendingFa, substep ordinal, loop/gate/pause behavior and the preceding branch
conditions. Compare uninterrupted state against transitions resettingA1C;
measure elapsed time only after confirming the actual simulation cadence.

Open gaps: Sharkagator caller/index ownership and clock; exact player state/flag
labels; trigger scene bindings; animation completion/reset; nonzero2B0A50
writers/scene activation; pits, lava, crushing, electric volumes, scripts and
other campaign hazard classes. No scene absence or exhaustive instant-death
claim follows from this bounded pass. No runtime patch or parity acceptance.
