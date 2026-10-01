# Current checkpoint — 2026-10-01 late audit

Priority0: UCES00420 original30 -> faithful60 parity; experimental only.
Branch v2-research is local-only. Actual HEAD after audit commits: b30d34e (verified); slice tooling
07450e1; quarantine 5dbb7b3. Verify HEAD on resume; never bulk-push this branch.
Active task: research/v2/crab-timer-audit-20261001/REPORT.md.
Evidence entry: research/EVIDENCE_INDEX.md -> Crab timer batch rejection.

## Current decision / blocker

REJECTED: generated Crab timer batch. 45 rows =29 unique sites; TEN sites
change animation IDs, entity flags or wave capacity, not duration. Runtime
activation now refuses before connecting; status/off remain available.
Tests:3 offline guard cases pass. No live mutation or emulator inspection in
this audit. Original generated dataset preserved as evidence, not manually edited.
Nineteen reload candidates remain; no reviewed replacement enabled yet.
Other generated classes (especially TrainingBot) need dataflow review before use.
The earlier claim that LEVEL_01 static timing analysis is closed is superseded.

OBSERVED instructions: transition0x12744c clears indirect data+0x60 at0x127950;
its old-state-D path reloads DISTINCT +0x64 from trunc(helper0x2172c*15).
Helper selects1.0/1.1/1.2/1.3 via global0x2DF3D0 ->15/16/18/19, not random15..29.
Update0x126F28 decrements +0x64 before state dispatch; selector0x126750 tests it
before choosing stateD. This cooldown is MISSED by the integer-immediate batch.
Doubling the float before truncation is not exactly twice the original integer.
Random modulus doubling also changes sampled distribution. Rates/eligibility/
full gameplay parity UNKNOWN; do not promote owner impression to measured parity.
Butterfly +0x6c is a signed16 countdown at entity+0x54, consumed by0x122820 and
reloaded via0x1226B0; its two-site timer classification remains experimental.

## Claude work reviewed / runtime last reported

Mass corpus: research/v2/decomp-candidates/_local/20261001-mass/,
PokitaruMass20261001.gpr;5045/5045 decompiled per docs/DECOMP_STATUS_2026-10-01.md.
Annotations and summaries: research/v2/decomp-summary/. Catalogue:
docs/FIX_CATALOGUE_2026-10-01.md (now warns about rejected batch).
PPSSPP1.20.4 Vulkan; latest owner session IG-v16f lean7.8KB, Dayni loaded;
IG-v15a had crashed Dayni (memory pressure INFERRED). Later owner work disabled
InterpGate in plugin.ini; do not infer current loaded state or re-enable blindly.
OCEnhance installed by Claude (optional Priority2, separate from parity).

Owner session: research/live-tests/pokitaru/session-2026-10-01/SESSION-LOG.md.
Crab motion and attack rhythm accepted visually with combined fixes; this does
not validate the rejected timer batch. Butterfly10 instances measured x1.00 vsA0;
16 other configurations untouched. Prior wrong-pointer edit restored35 words;
later results may be affected. Use clean boots for fresh evidence.
Other catalogue families largely INFERRED/untested. Clock window correction
must not be combined with doubled2760 skill-point threshold. Rejected static:
animdisp0x6C318 absolute point; pickups0x7248 look-at matrix.

## Ghidra preservation / audit artifacts

Ghidra12.0.4 Allegrex, Java26.0.1; canonical PRX SHA in reports.
Original C:/Users/linki/SIZEMATTERS60FPS.gpr preserved. Prior r2 local copy
reopened and verified15 functions,54806 APPLIED relocations,36 initialized
blocks matching source,zero loaded-byte changes. Prior quota interruption closed.
New mass-copy slice: slices/crab-timer-audit-001/, five functions plus bounded
instruction ranges exported successfully; invocation/method/output hashes local.
Twelve audit EOL comments applied to that Ghidra copy, save success; no function
names/entries changed. Source annotations.json beside active report; no separate
read-only verification of saved comments. Source base annotation set preserved.
Raw C/P-code/instructions/database stay ignored; only authored methods/reports
committed. Detailed hashes and rejection-site table are in the active report.

## Exact NEXT ACTION

Session 2026-10-02 log: research/live-tests/pokitaru/session-2026-10-02/SESSION-LOG.md (owner-accepted:
crabtimers, camera incl. 0x3634/0x37F8, frames30 HUD, springs, spawn, butterfly, OCE-v5; rejected particles-all).
1. Restart PPSSPP first (grew to ~14 GB during debugging). Blaster: C1 halves fire rate (A0 4.2 vs C1 2.0
   shots/s, ammo-decrement meter); test `substepdt` (2 x delta into 0x39B74) with the meter; check Ryno too fast.
1a. Next live test order (clean boot, A0 baseline + monitor): physstep (bolts, crate debris), particles-rate
   (waterfall, teleporter), camfilters (camera follow), Blaster probes + weapondt/substepdt, Ryno probe ->
   rynorate, helphint.
1b. Built offline (untested): IG-v18 `physstep` (bolts + crate debris = 0x2832C, NOT particles), IG-v19
   `particles-rate` (half-rate update, full-rate draw, byte-exact restore). Installed: IG-v19. Domain map:
   docs/WHY_60FPS_IS_HARD.md. Water scroll: no writer in LEVEL_01 (likely EBOOT geometry).
2. Per-particle work: crate debris 0x1A05F0, waterfall 0xDE23C, waves 0x7E810 (per-record callback at +0);
   find the waterfall water-scroll source; bolts flying to Ratchet; teleporter/help-box UI animations.
3. TrainingBot timer list review before activation (same generator weakness as Crab).
Next files only: AGENTS.md, CURRENT_STATE.md, active REPORT above. Then targeted
sources via EVIDENCE_INDEX: timer-patches.py, timer-patch-spec.py, selected local
slice manifest/C/instructions. Do not reread mass inventory or old session history.
Quota at final research check: five-hour88%,weekly99%; weekly limit binds first.
