# Crab timer batch audit — 2026-10-01

## Decision

REJECTED: applying the generated 29-word Crab batch as a duration correction.
Ten sites change non-duration semantics. Activation is now quarantined before
any emulator connection; status/off remain available for inspection/restoration.
No live memory, plugin configuration, saved game or original asset was changed
in this audit. The runtime state left by the owner/Claude has not been inspected.

The owner-observed improved attack rhythm remains historical evidence, but is
not acceptance of these ten changes. The October 1 session also records an
unrelated temporary Butterfly pointer-edit incident. Reproduce future timing
measurements from a clean boot, with an A0 baseline and the actual patch set
recorded. Do not reuse contaminated saves as parity evidence.

## Static findings

The original spec has 45 Crab rows but 29 unique sites; duplicate rows label
the same instruction as both +0x60 and +0x64. Its generator associates literals
with a whole function/class/offset, without proving the literal reaches that
field. It also confuses direct entity+0x64 flags with indirect Crab data+0x64.
An exact word match only validates location, not the proposed replacement.

| Rejected sites | Observed use | Why doubling is invalid |
| --- | --- | --- |
| 0x124058 | byte count through a linked wave manager, compared with 12 | capacity check, not elapsed time |
| 0x1276D0, 0x12775C, 0x127888, 0x12792C | argument 15 to animation helper 0x6AD50 | selects an animation |
| 0x127914 | comparison of 0x6AED0 result with the same animation identifier 15 | animation identity, not duration |
| 0x127A24 | OR bit 8 into entity+0x64 | entity flags, not indirect timer field |
| 0x137BA4 | OR bit 16 into registered entity+0x64 | wave registration flags |
| 0x6A48C, 0x6A4A8 | OR bits 1/2 into entity+0x64 in shared helper | lifecycle flags, potentially affects other classes |

CORROBORATED static dataflow: the remaining 19 sites form reload expressions
stored to Crab data+0x60 (entity+0x58 points to that data). These are eight
sites in 0x12461C/0x12469C/0x125200/0x1256DC, fixed value4 at 0x126320, and
ten sites in the transition function. They remain experimental candidates:
no measured cadence or full state-duration parity has been established.
Doubling a random modulus and offset is also not the same distribution as
doubling the original sampled integer. A replacement requires an explicit
policy for random draws, truncation and boundary updates; no replacement was
enabled in this session.

The five transition reload pairs, confirmed in instructions, are
0x127630/0x127654, 0x127688/0x1276AC, 0x1278C4/0x1278E8,
0x127B2C/0x127B50 and 0x127BD8/0x127BFC. Some switch blocks are absent from
the initially defined function body, despite appearing in recovered C; the
bounded instruction export corroborates the stores. State D clears +0x60
at 0x127950. This upgrades the prior slice's reset inference to an observed
instruction store, with state identity corroborated by the recovered switch.

The old-state-D cooldown is a DIFFERENT field, indirect data+0x64. Instructions
at 0x127544..0x127560 multiply helper 0x2172C's floating return by15 and truncate
to an integer. Helper 0x2172C selects 1.0/1.1/1.2/1.3 from the integer returned
by 0x123BC (global 0x2DF3D0); it is not a random-duration generator. Therefore
the static reload values are 15/16/18/19, not the previously proposed15..29.
The live selector value, full eligibility and rate remain UNKNOWN. The existing
integer-immediate batch misses this floating-point-derived reload entirely.
Simply multiplying15 by2 before truncation would not exactly double16/19.

Consumer follow-up (OBSERVED in recovered C): Crab update0x126F28 decrements
indirect+0x64 before its state dispatch; selector0x126750 tests that field before
choosing state D. Thus this is a separate cooldown gate, not the state-D attack
counter. Its runtime call cadence still requires measurement. Butterfly's two
sites were separately checked: update0x122820 decrements the signed16 field
at entity+0x54 -> data+0x6C and reloads via0x1226B0. That supports retaining
its experimental timer classification; it does not validate every configuration.

## Provenance and reproduction

Canonical LEVEL_01 PRX SHA256:
`d10a81d076fb44987a45314a020cda2f7e8b39f860b957911ca9365464676571`.
Input generated spec SHA256:
`4a725983e482f9768aee7b707ef921e984a871127ffe2428abee34810cba49dd`.
Do not manually edit that dataset; preserve it as rejected-candidate evidence.

Source corpus: local `research/v2/decomp-candidates/_local/20261001-mass/`.
Five functions and bounded instruction ranges were exported with the existing
Ghidra12.0.4/Allegrex environment using the project-authored recipe
`research/scripts/ghidra/recipes/crab-timer-audit-001.json` and `TraceTimingSlice`.
All five completed, and Ghidra reported save success. Raw C, P-code, instruction
exports, invocation hashes and slice manifest stay under local
`slices/crab-timer-audit-001/`; no game-derived output is added to Git.
The prior 15-function pilot separately passed its reopened preservation check.

Twelve authored EOL audit annotations were subsequently applied to the mass
Ghidra copy with `ApplyAnnotations.java`: ten rejection warnings and the two
distinct counter stores. The script reported zero function names/plates/entries
changed and12 address comments, followed by save success. Input:
`annotations.json` beside this report, SHA256
`1999eabcafc51b5672e11cf701b8b9170e11213a1d88049748f6e6d0558d2145`.
The local `annotations.stdout.log` records the application; read-only reopening
of those comments has not been independently verified. Earlier annotations
remain reproducible from the preserved authored base annotation set.

Read-only Luna review covered helper0x2172C/callee0x123BC, shared flags, four
Crab reload functions and Butterfly initializer. Parent review resolved the
material conflict using transition/capacity instructions and the generator.
The runtime quarantine has three offline tests, including refusal before
constructing any emulator client. This is tooling verification, not gameplay.

## Exact next action

Review the full Crab +0x60/+0x64 lifecycle and build an explicit, source-backed
replacement recipe. Keep the ten rejected sites original. Trace both countdown
and count-up states before choosing scaling; measure state-entry/exit and attack
events against A0 from a clean boot. Audit TrainingBot and other generated
timer classes before applying their lists; the same generator weakness applies.
Do not describe LEVEL_01 timing analysis as closed or port the rejected batch.
