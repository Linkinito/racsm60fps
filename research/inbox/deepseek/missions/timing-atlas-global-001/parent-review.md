# Parent review — timing-atlas-global-001

Review started 2026-09-20 against branch `v2-research`, HEAD
`c038b38b5c3ea30bac37e987165b42fe500c68a1`.
Status: COMPLETE — parent arbitration and next-session gate persisted. Initial
checkpoint preceded full-report reads. No runtime work, workers, patch or binary
changes were performed in this review.

## Completion evidence and scope

`mission.json`: WORKERS_COMPLETE / READY_FOR_PARENT, completed
2026-09-20T01:11:13.9307796Z. `workers/panel-summary.json`: all three workers
succeeded, child exit codes 0; reports Explorer 34595, Mapper 29203, Skeptic
15339 bytes. These establish research completion, not scientific validation.
Raw reports and handoffs remain unchanged. Parent arbitration below will distinguish
static observations, inferences and unmeasured runtime cadence.

## Immediate propagation guards

- Universal RVA+0x74 is REJECTED; use the containing ELF PT_LOAD mapping.
- Current LEVEL_02 vanilla 0037689a... must not inherit historical contamination.
- Mapper's catch-up-wait branch direction requires explicit re-decoding.
- Post-loop gate=1 does not prove a second LaserTracer dispatch.
- Total 0x1EBC4 entries include three caller paths; use 0x2FCF0 for substep attribution.
- State/phase dispatch above 0x1517C and entity pump 0x6EBE4 do not prove global cadence.
- B0 doubling and gameplay parity remain UNKNOWN/UNTESTED.
- Preserve accepted N-VEL interpretation of +0x578; global dt*60 normalization remains rejected.

## Executive synthesis

The evidence supports several interacting timing domains, not a universal game
clock. One level-local shared delta feeds a player outer update and a conditional
two-pass inner loop. Other consumers use normalized displacement, countdowns,
fixed per-call work, embedded 1/30 or 1/60 steps, and local rate-derived constants.
State tables and object/weapon callbacks compose their invocation counts.
The limiter is compatible with a second wait when exactly one VBlank elapsed;
its removal has not established a real-time doubling of any domain.

All three complete reports were read. References below use Explorer E§, Mapper M§,
Skeptic S§, and the accepted [Ghidra note](../../../../v2/ghidra-timing-findings-2026-09-20.md)
G§. OBSERVED claims attributed to a worker mean reported raw-byte observations,
reviewed for internal consistency; this parent did not rerun their corpus scans.
After all required checkpoint files existed, a bounded parent script verified
selected bytes/hashes; see [parent-static-checks.json](parent-static-checks.json).
All three report hashes match their handoff sourceSha256; registry transcription
contains exactly 150 L01 name/RVA rows. This does not verify the 534-name union.
CORROBORATED is reserved for compatible concrete evidence, not model votes.
No new gameplay claim is TESTED here.

## Accepted findings and arbitration

### Player/shared-delta structure

CORROBORATED (E§1, M§S1.1/5, S§1, G§1–8): 0x151E0/E4 construct
0x3D088889 (~1/30); 0x151E8 calls 0x88768 with delay-slot `mtc1 a0,f20`.
The retained scalar reaches 0x87A84, 0x6B7F4, 0x2FFF0 and 0x6B618.
The accepted delta-producer review rejects a hidden incoming-delta effect inside
0x88768. A shared producer for these four calls is not a single producer for the
whole module: dozens of other literal builders exist.

0x2FFF0 saves the scalar and calls 0x2FB8C at 0x300F4. On the normal
`player+0x95C & 0x8000` path, 0x360A4 runs before two loop passes.
The gate store at 0x2FCB4 receives `a0` from `sltiu a0,s1,1` (0x2E240001).
With s1=0,1 and post-loop restoration, the exact gate sequence is **1 / 0 / 1**.
The prior Skeptic destination-register/dead-value reading is REJECTED.

The seven callees per pass are 0x353A4, 0x32004, 0x3BFF8, 0x3C88C,
0x32888, 0x39B74 and 0x1EBC4. Only the final two are explicitly passed this
delta in their delay slots, 0x2FCE8 and 0x2FCF4. Passing the player pointer to
the first five does not establish an incoming-float contract. Alternate branches,
early exits and state gating prevent a universal two-passes-per-entry claim.

0x360A4 stores dt at +0x56C, accumulates +0x574 and other timing fields,
and writes +0x578=dt*30. +0x570's remainder-like constant is **0x3C88893B**,
not the usual 0x3C888889. Preserve that distinction in numeric checks.
0x328A0 divides displacement by positive +0x578 to form +0x28C/290/294:
N-VEL use is CORROBORATED. Global dt*60 replacement remains REJECTED.
0x42C04 also uses +0x578 in countdown-like logic and has a literal -1 branch
(accepted G§5); S§1's limited window does not erase that evidence. Its precise
branch predicates and gameplay names for +0x9D4/9D8 remain unresolved here.
S§1's apparent `==0 then decrement` wording is not promoted as canonical pseudocode.

0x32588 explicitly subtracts incoming dt from +0xA00/A08/A0C/A14/A18;
S§1 adds five clamp-to-zero blocks. Field gameplay meanings remain UNKNOWN.
0x39B74 mixes this D path, N-VEL/N-TIMER, per-call counters, a negative F30
expression and F60 calls. Static execution under an active path does not itself
prove 60 substeps per wall second, contrary to S§5's stronger phrasing.

### Level phase/state dispatch and limiter

Accept M§S1.2's reported two direct callsites into 0x1517C: 0x15AA8,
0x15B18. Relocated .rodata entries at 0x1C02C8…0x1C02F0 reference the
0x15A80…0x15B98 region. This supports an **INFERRED phase/state dispatch
structure**; the table reader, selected index, owning thread and frequency are
UNKNOWN. Treat entries as code labels, not necessarily independent function
starts. Absence of direct jal callers does not prove exclusive table ownership.

M§S1.3 reports limiter entry 0x96490, direct caller 0x94B38, gate byte
0x2B6E50, stored counter 0x2B6E58. Accepted names for the relevant imports
are wait at 0x1BF424 and vcount query at 0x1BF42C. S§3's lack of import-name
strings is a limitation of that verification method, not evidence against an
accepted import identity; library/NID resolution is stronger than string searches.

Re-decoding the supplied branch sequence:

```
0x9662C  call WAIT                  # first wait, within the enabled limiter
0x96638  call VCOUNT
0x96640  a0 = stored
0x96644  a0 = a0 + 1
0x96648  bne v0,a0,+3              # target = PC+4+3*4 = 0x96658
0x9664C  delay slot
0x96650  call WAIT                  # reached on equality, not inequality
0x96654  delay slot
0x96658  call VCOUNT; then store the new counter
```

Thus Mapper's **"catch-up wait taken when unequal/already late" is REJECTED**.
The defensible INFERRED role is a normal second wait when the current counter
equals stored+1, skipped when more than one VBlank has already elapsed (ordinary
forward-counter interpretation; reset/wrap/state effects must be recorded).
The whole block can be gated off. The first wait remains after B0. Therefore B0
is not an unrestricted free-run patch and an exact 2x cadence is not guaranteed.
The two reports disagree on the final store's address (0x96660 vs 0x96664).
The subsequent bounded parent read resolves it: 0x96660=0x10000003 is an
unconditional branch; its delay slot at **0x96664=0xAE026E58** stores v0.
0x96648=0x14440003 independently confirms BNE v0,a0 to 0x96658, with NOP
delay slot. These branch/word observations are now parent OBSERVED.

Prefer M§S1.4's explicit 13-callsite/5-stub table over E§9/10's six-call count:
seven sites target WAIT, three VCOUNT, three other display stubs. Do not treat
section membership as proof of identical import semantics or carry stub indexes
between modules without resolving their import records.

### ELF mapping and current provenance

S§0/1/7 disproves E§0/10 and M§0's universal mapping. For LEVEL_01:

| PT_LOAD | p_offset | p_vaddr | p_filesz | valid mapping |
|---|---:|---:|---:|---|
| 0 | 0x74 | 0 | 0x2DD104 | RVA+0x74 within this file-backed segment |
| 1 | 0x2DD178 | 0x2DD108 | 0x1AC | RVA+0x70 within this file-backed segment |

Use `p_offset + (RVA-p_vaddr)` only for a uniquely containing PT_LOAD and
file-backed bytes, checking requested size against p_filesz. BSS/p_memsz-only
addresses have no file bytes. Example: 0x2DD1F8 maps to **0x2DD268**, where
the pointer to 0x14CA70 resides. M§S2.3's file/vaddr conflation is rejected.
Runtime addresses additionally require relocation and loaded-segment identity.
Earlier first-segment code observations are not invalidated by this correction.

M§S4 and S§2 independently recomputed current Data/BIN/LEVEL_02.PRX as
`0037689a926197969231795c4d6b05980e5e94558394617b21e8b8bcd79bc8aa`, matching
the clean backup/reference with loop threshold 2. Current restored vanilla is
CORROBORATED and independently rehashed by the parent static check. The exact
threshold instruction is **RVA 0x34160**, file 0x341D4, word 0x2A240002.
Skeptic's RVA 0x3415C instead contains the preceding increment 0x26310001;
that off-by-one-instruction citation is corrected. E§0's quoted manifest hash
`8b25dc880062912c28adc49b78ce1e90952037ca18db8164e41301530647c7e9` is historical
contaminated provenance, **SUPERSEDED for the current path**, not deleted history.
Explorer used the clean reference for its LEVEL_02 analysis.

S§2 reports LEVEL_15/21 differ by only 14 bytes, in a level index/path region.
This narrows E's provenance uncertainty and is stronger than M's equal metrics.
Equal metrics alone did not prove code identity or "different packed assets";
those Mapper deductions are rejected. Preserve the reported bounded binary diff
as evidence for this pair, not an RVA-transfer license for other modules.

### Class/callback atlas and coverage

Preserve E§2's complete 150-row LEVEL_01 name→+0xC candidate registry and
534-name union across its scanned corpus. These are **worker OBSERVED extraction
results**, not 534 proven active update functions. E§2 documents per-module
counts (L01 150; L02 174; L03 160; L04 167; L05/06 130; L07 165; L08 212;
L09 134; L10 158; L15/21 9; L22 44; L23 103; L24 120; FRONTEND 2).
No name is common to all 15 gameplay modules in that registry. Explorer's
later "L02 highest" wording is numerically wrong: L08 has 212.

+0xC is strongly update-associated at anchored LaserTracer/Flamethrower/elevator
records. It is not universally proven Update(), and it must not be conflated
with the runtime weapon descriptor's +0x1C slot. Class records, weapon-name
records and runtime descriptor chains are distinct structures until linked.
M§S1.7's frequent +0x20 method slot does not make it a universal tick method.
Small integers inside records can look like code pointers. Zero jal/float counts
inside heuristic windows do not prove inactivity, event-only operation or absence
of delegated timing. These entries remain E/U candidates.

E§2/6 supplies useful anchors for hazards, platforms, teleporters, enemies,
projectiles and bosses; preserve that breadth rather than re-inventorying it.
Examples: Crab 0x126F28, TrainingBot 0x185B34, BlasterShot 0x118130,
CrossbowShot 0x12CDEC, Teleporter 0x1799C0 (all L01 candidates); level-local
Lvl3DeadlyFluid/Platform, Level04Crusher, Lvl07GuardBeam, LunaBoss and Otto
families remain static ownership leads. Presence in a module does not prove use
in the current level. The 493-callsite/59-family wrapper ledger is a partial
composition corpus, not a complete timing atlas. S§2 finds relevant patterns in
LEVEL_16/20 outside the 15-module corpus; their semantic identities remain open.

### LaserTracer, weapons and entity manager

CORROBORATED: LaserTracer class pointer 0x2D4158→0x148CEC; initializer
pointer 0x2DD1F8→0x14CA70; static rate 30 at 0x2D2C04, reciprocal and derived
coefficients, explicit rate==60 branch; XRef geography supports a local tracer
subsystem (G§10, E§4, S§1). No game-wide master clock is established.
E§4's 12/12 is **module-presence correspondence**, not twelve fully proven
identical initializers. LEVEL_07 has three detector hits (0x132FF8,0x133010,
0x1632F4); the anomaly is unresolved. Other div-site anchors: L02 0x161414,
L03 0x14E748, L04 0x1545C0, L05 0x140464, L06 0x141D24, L08 0x16A7A8,
L09 0x141FA4, L10 0x14E628, L23 0x13ABBC, L24 0x133F6C. These are div
sites, not automatically function entries. E's `0x45000005 = bc1t` is wrong:
the encoded condition is bc1f; the existence of a rate==60 choice survives.

The 0x148D7C/80 gate suppresses a fixed per-call decrement when zero.
**REJECTED:** S§3/6's two gated executions per outer call inferred from the
post-loop reset; M§S6's asserted 1→2 per-outer multiplicity is likewise unsupported.
A gate value enables work only if another dispatch occurs. Conditional hypothesis:
when dispatched on both substeps, work can run on pass 0 and be suppressed on
pass 1. A one-pass 60 Hz design may double real-time gated work relative to a
30 Hz outer schedule, if there is one effective eligible dispatch per outer.
Actual dispatch count, object multiplicity and gate sampling remain UNKNOWN.
G§10 records a cheat-unlocked LaserTracer observation; do not present that as
normal vanilla progression or assume it describes every isolated checkpoint.

Weapon contract (G§8, M§S1.6): current weapon→descriptor via +0x40, update
slot +0x1C, jalr at 0x1F2D0, delay-slot f12=f20. Individual callbacks may ignore
the scalar. 0x1EBC4 has direct callers **0x1E4E8, 0x1E610, 0x2FCF0**.
Only the last identifies the player-substep call; totals need caller attribution.
Flamethrower counters and random `%3` selection remain separate from the
unresolved damage path; deterministic "every third frame" is SUPERSEDED.

M§S1.9's 0x6EBE4…0x6ED00 region contains a reported 0xF8-stride walk,
record state/flag gating and callbacks around +0xD4/+0xD8/+0xDC/+0xE0.
Accept as an **INFERRED candidate entity pump/object manager**, a valuable future
hook lead. Reject "per-frame" or global Moby ownership as established facts.
The quoted offset pairs also need distinction between callback and context fields.
The 0x1AD1F0…0x1AD710 stack-loaded indirect-call region is an E/H dispatch
candidate; stack storage alone does not prove a particular switch implementation.

### Fixed-step ownership and unresolved disagreements

Lvl3Elevator descriptor 0x2D51B4 links init 0x1562DC and callback 0x156710.
Stored `(1/speed)*(1/30)` supports C/F30 mover semantics; actual callback rate,
field-name equivalence and travel speed need runtime correlation. Exact init store
offsets/registers differ in report excerpts; do not build a patch from that excerpt.
Camera ±1/30 at 0x361C/3634 and F60 add/sub pair 0x3FF6C/0x4000C are
static anchors, not proof of camera or timer cadence.

LEVEL_03 0x15AA84-region `field+0x34 += field+0x48` is CORROBORATED C-like
arithmetic. "field += field" means two fields here, not necessarily self-doubling.
E§6's association with Lvl3Platform 0x158A18 uses descriptor-derived boundaries
and remains INFERRED, since an intervening helper can exist. The acid-specific
ownership label is contested; Lvl3DeadlyFluid ownership and exact hazard effect
remain UNKNOWN. Resolve this before an acid-specific patch.

Additional census caveats: E§3's claim to reproduce all prior counts conflicts
with its own L24 table (60 vs quoted 52); retain the table as a method-specific
report, not exact reproduction. M handoff's 244–318 jalr range omits L22's 206.
FRONTEND lacks the reported 30.0/60.0 data constants but contains one 1/30
builder, so it is not simply devoid of timing. Full-build, raw-byte and data-word
counts are different populations. E's global compare-count claims are not used
as semantic evidence; the concrete rate comparison is sufficient.

## Canonical timing-domain map

Tags describe operation and scheduling separately; one function may carry many.

| Tag | Meaning and concrete anchor | Evidence / unresolved scheduling |
|---|---|---|
| O | Outer explicit delta: shared 0x1517C fan-out; 0x360A4 accumulators | CORROBORATED structure; wall cadence UNKNOWN |
| S | Logical player substep: normal two-pass loop, gate 1/0/post1 | CORROBORATED; normal-path qualification required |
| D | Explicit dt consumer: 0x32588; delta forwarded into weapon callback | CORROBORATED contract; gameplay meanings incomplete |
| N-VEL | Displacement divided by dt*30: 0x328A0 | CORROBORATED; preserve normalized-step semantics |
| N-TIMER | dt*30 reused as countdown: 0x42C04, mixed literal -1 | OBSERVED accepted Ghidra; local parity UNKNOWN |
| C | Fixed per-call amount: Flamethrower countdown, gated tracer decrement, L03 field addition | Static operations; caller frequency UNKNOWN |
| F30 | Embedded 1/30: elevator stored progress step; camera ±1/30; 0x39B74 negative term | Different semantics; no universal halving rule |
| F60 | Hardcoded 1/60 inside substep and 0x3FF6C/0x4000C pair | CORROBORATED literals; not automatically 60 Hz |
| R | Local configurable rate: LaserTracer 0x14CA70, reciprocal and damping coefficients | CORROBORATED local scope; writer/initialization cadence UNKNOWN |
| E | Event/state/flag gate: phase entries, player alternatives, tracer eligibility | Static gating; active path must be measured |
| V | Display synchronization: 0x96490, gate, first wait and conditional second wait | Equality branch retained; B0 effect UNTESTED |
| H | Invocation composition: 0x2FFF0, three-caller weapon manager, descriptor dispatch, wrappers | CORROBORATED anchors; ledger incomplete |
| U | Unresolved ownership or semantics: entity-manager scope, unanchored class slots, damage/animation clocks | Preserve UNKNOWN; no guessed global owner |

Architecture: V driver and phase-table level update have an unresolved scheduling
relationship. The level update fans out O, including H→player O→S. S contains
D/N/C/F consumers and gate-dependent effects. Independently dispatched classes
contain C/F/R/E behavior; the candidate entity manager may connect some of them,
but that edge is not proven. There is no established universal master dispatcher.

## Implications for an eventual PRX architecture

Design only, not an approved patch: bind hooks to module hash and segment-aware,
relocated structural signatures. Separate observed scheduling from per-call work.
An outer 1/60 plus one-pass player design is conditional on measured doubling;
selected substep D consumers may need A0-equivalent input while O stays true dt.
Do not double 0x2FBBC globally: it also feeds outer timing fields. Preserve
N-VEL's dt*30 producer; any N-TIMER compensation must be local and measured.
Maintain F60 values if their effective call rate is restored, rather than blindly
scaling literals. R systems require coherent rate/derived-coefficient treatment,
E/H systems require dispatch attribution, and damage needs causal ownership.
No enemy/projectile/camera or global pump fix follows solely from player parity.

Production scanner requirements: independently parse each ELF; use file-backed
PT_LOAD bounds and executable-section/alignment checks; decode same-register
lui/ori builders and COP1 fields; track PSP relocations and register dataflow;
qualify loop signatures with gate, seven-call body and tail (bare tails have 41
L01 matches); validate pointer candidates through relocation/code evidence without
requiring every leaf to have a stack prologue; resolve display import NIDs rather
than universal stub indexes; identify R via reciprocal/use/compare dataflow, not
a nearby 60 literal. Emit hash, segment, section, RVA/file offset, words, method,
confidence and negative matches. Join wrappers by module identity+RVA; preserve
unmatched modules/classes and keep detector anomalies visible. No scanner was
implemented or corpus regenerated in this review.

## Exact next gate and stopping rule

The next authorized runtime session must execute the standalone
[NEXT_RUNTIME_GATE](../../../../live-tests/pokitaru/player-clock-001/NEXT_RUNTIME_GATE.md).
It compares A0 with **B0 = only NOP at loaded base+0x96650**, measures seven
primary sites and player slopes, and restores the exact saved runtime word.
Same-scene repeated free-running measurements and observer-overhead checks are
mandatory. All-site doubling supports a shared level-driver mechanism in that
scene; it does not prove every game object doubles. Caller-attributed player-only
doubling supports a local scheduling change requiring explanation. No doubling,
inactive limiter or observer saturation falsifies or leaves unresolved the relevant
premise as specified in the gate. Stop after restoration and interpretation.

No A0/B0 experiment, code patch, PPSSPP control or worker launch occurred during
this parent-review mission. See NEXT_SESSION.md for minimal resumption files.
