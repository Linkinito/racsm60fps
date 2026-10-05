---
kind: static
title: "Damage atlas: all inventory families, ranks, modifications and child attacks"
date: 2026-10-06
authors: ["GPT (Codex)", "GPT read-only weapons worker"]
status: complete
evidence: [OBSERVED, INFERRED, CORROBORATED, TESTED, REJECTED, SUPERSEDED, UNKNOWN]
summary: "All 25 inventory ids are accounted for, with distinct direct, area, semantic and child routes; remaining transitive damage and live parity are explicit."
systems: [weapons, ranks, mods, damage, projectiles]
levels: [LEVEL_01, LEVEL_24]
variants: [A0, B, C]
environment: "Original clean LEVEL01 exports and prior scoped live reports; LEVEL24 MiniTurret binding"
related: [research/v2/weapons-armor-inventory-20261003/REPORT.md, research/v2/weapons-finalize-static-20261003/REPORT.md, research/v2/weapons-next-static-20261003/REPORT.md, research/v2/damage-atlas-20261006/REPORT.md]
---

# Provenance and conventions

This integrates the independent read-only weapon worker. RVAs are LEVEL01 unless
explicitly LEVEL24; source SHA is in METHOD. Selected C exports are the existing
`20261001-mass/all/c/0x<RVA>.c` corpus. The accepted table constructor is
`20261001-mass/slices/weapons-armor-inventory-004/00100eec.c`; the rejected earlier
constructor slice must not be substituted. Raw bodies stay ignored/local.

Primary historical evidence: weapons-armor-inventory, weapons-finalize-static,
weapons-next-static, agents-bomb-static, laser-gate-static, tremblator-ray,
otto-flamer-static (all20261003), and plugin-inventory-20261005. TESTED claims
below are narrowly inherited from those identified experiments; no new live run
occurred. Static scalar predictions are not measured HP decrements.

`r` means raw rank; row numbers/mod ids are hexadecimal. `1F71C` selects
`2AE95C + (id + ownerVariant + 1)*58`. Variants -1/0 shift one adjacent record;
their runtime owner meaning is not fully closed. Rank/ammo/XP are `+3C/+40/+44`;
three owned/enabled optional definitions are `+4C..4E`, availability `+4F..51`.
`1FC00` resolves pointer identity against 43 definitions at `2AE8B0`, not a
generic mod bitmask. Evolution `1FFBC` is rank >2; advanced `1F654` is inventory
type2 and rank >3. These predicates are different.

# Complete inventory domain

| Id / identity | Legal parameter ranks | Ammo capacities in rank order | Mods | Principal update |
| --- | --- | --- | --- | --- |
| 0 sentinel candidate | 0 | 0 | none | UNKNOWN |
| 1 Wrench | 0 | 0 | none | `189BE8`, id binding tentative |
| 2 Blaster / owner Lacerator | 0..7 | 60,70,80,120,120,120,120,120 | 01,02 | `116A00` |
| 3 BlitzGun / owner Tremblator | 0..7 | 25,25,30,30,25,25,25,25 | 04,05,06 | `11A5B0` |
| 4 BombGlove | 0..7 | 5,7,9,10,8,8,8,8 | 07,08 | `1217F4` |
| 5 AgentsGlove | 0..7 | 6,8,10,10,10,10,10,10 | 0A,0B | `10FD58` |
| 6 BeeMineGlove | 0..7 | 8,8,8,8,8,8,10,12 | 0D,0E | `115990` |
| 7 ShieldCharger | 0..7 | 5 throughout | 10,11 | `16CB78` |
| 8 ShockRocket | 0..7 | 20,20,22,22,18,20,22,24 | 13,14,15 | `16F954` |
| 9 CrossbowGun | 0..7 | 8,8,10,10,8,8,8,8 | 16,17 | `12B254` |
| 10 Flamethrower | 0..7 | 60,90,90,90,90,90,90,90 | 19,1A | `13B8F0` |
| 11 LaserTracer | 0..7 | 200,200,300,300,300,300,300,300 | 1C,1D | `148CEC` |
| 12 SuckCannon | 0..7 | 8,10,12,16,10,12,14,16 | 1F | `1762A8` |
| 13 Mootator | 0..7 | 0 throughout | none | `15A364` |
| 14 MiniTurretGlove | 0 only | 30 | none | LEVEL24 `13A7AC` |
| 15 Ryno / owner TELT | 0..3 only | 30,30,40,50 | none | `168C28` |
| 16 Hypershot | 0 | 0 | none | `144954` |
| 17 Sproutomatic | 0 | 0 | none | `17553C` |
| 18 Polarizer | 0 | 0 | none | `15F058` |
| 19 PDA | 0 | 0 | none | `15E380` |
| 20 Shrinkray, passive type3 | 0 | 0 | none | UNKNOWN |
| 21 Boltgrabber, passive type3 | 0 | 0 | none | `121264`, empty |
| 22 Grindboots, passive type3 | 0 | 0 | none | UNKNOWN |
| 23 Mapomatic, passive type3 | 0 | 0 | none | UNKNOWN |
| 24 Boxbreaker, passive type3 | 0 | 0 | none | `121D74`, empty |

Zero ammo does not establish unlimited firing. XP thresholds are retained in
the prior inventory report. `1F898` uses strict greater-than, retains remainder,
and increments once per grant. Rank3/7 progression stops depend on mode; rank3
purchase uses `BBAF0/BA588/203B0/203FC`. Bomb ranks5/6 share `2ACB1C`.
Ryno pointers4..7 are null despite the general setter accepting7. SuckCannon
is excluded from normal refill `201CC`. Retail evolution/mod names remain
UNKNOWN where not owner-corroborated.

# Shared timing and damage contracts

Table `2CB0CC` stride16 holds selector/scalar/type/reaction. Scalar is at
`2CB0D0 + 16*row`; selector2 is halved by selected callers. `100EEC` reconstructs
live rows, many using 1/30. Zero semantic rows remain meaningful. Actual result
feeds reward `10924`; terminal3 must not be invented by cadence gates.

Normal A0 weapon dispatch is two weapon substeps per30-Hz frame plus one
presentation callback. Corrected core is one weapon substep and one presentation
per60-Hz frame. Many weapon counters already get60 calls/s; presentation doubles.
Accepted weapon-delta changes weapon-only delay-slot `2FCF4` to `2*f20`; preceding
`2FCF0` needs JIT refresh. It does not globally alter `39B74`. Pre-JIT negative
weapon-delta inference is SUPERSEDED by session-2026-10-02b and
`docs/WEAPONS_PARITY_2026-10-02.md`. Modified-backup LEVEL02 one-pass conclusions
are SUPERSEDED by clean module provenance.

Never combine a30-Hz body with life-halving intended for60 calls; halve neither
both Tremblator damage layers nor arbitrary animation fields. Ryno rate24->48
is REJECTED. Segment rate/fade/life changes are distinct hypotheses.

# Id1 Wrench and melee

Wrench is a damage producer despite no ammunition. `189BE8/18A6C8/18A2B0`
contain variant-specific update, delivery and charged-bonus paths. `+DC` is a
per-call decrement; `+FE` admission, `+FD` once latch, `+FF` emission and `+102`
fade have different roles. Armor combo variants, burn/secondary children,
absorption charge and passive effects are detailed in REPORT section3.
Crate/Breakable receivers can destroy without scalar HP damage (REPORT section5).
Ordinary melee geometry, complete combo/Boxbreaker consumer and all per-target
deduplication windows remain UNKNOWN; no universal melee cadence fix is accepted.

# Id2 Blaster

Entries `11666C/1167E8/116A00/117AE4/118130`. Mod01 launches two opposite-offset
muzzles. Normal row r+29 scalars `[1,3,5,4,13,18.5,26.5,44]`; alternate r+31
`[1.25,3.75,6.25,5,15,21,30,50.5]`. Rank3 decrease is observed, not a balancing
error. Constructor caches row/rank/owner/velocity using `2CDEA4/2CDEA0` and
timestep. Update adds age1, owner-dependent life, velocity and swept collision;
excludes source/owner, shortens displacement on contact, delivers cached row
and weapon2 reward. Effects can occur on the final call. Rank3 terminal child
`1178CC/116350` is unclosed. Mod02 affects lock state, not proven fire interval.
Prior TESTED cadence4.133/4.134shots/s and speed125.7/125.9units/s accept paired
speed/life only. Next: two-muzzle overlap, child, expiry/contact ordering and
all-rank hit/reward counts.

# Id3 BlitzGun / Tremblator

Damage `11B4F8` has two queries, owner filtering and cross-query deduplication,
up to32 candidates. Falloff is `ceil((1-distance/range)*4)`, minimum1, times
one quarter base; selector2 and other multipliers remain separate. Row r+39
`[4,8,12,16,38,66,90,134]`. Visual rays are not continuous damage proof.
Mod04 changes spread `2CE284`; mod05 charge starts near.1, adds `2CE28C/30`
per eligible update to `2CE2BC`, changing range/damage/ray count and firing on
release; mod06 lock eligibility. Five shared ray/particle paths use independent
states. Final callback `11C078 -> 11C0B8 -> C9ED8` decrements signed16 life;
an earlier initializer hook missed that replacement. Lifetime-only does not
restore ray phase/fade/pool schedule; offline phase3~ordinal13/removal~14 are
conditional predictions. Prior TESTED cadence46A0frames/23*2Cframes; ray island
not accepted, runs85..91 invalid background conditions. Next: fresh-shot query
geometry, accepted multiplicity, final callback/entity/pool removal ordering.

# Id4 BombGlove / AcidBomb

`1217F4` cooldown/release use supplied delta; post `121370` advances latch1->2,
launches once, debits ammo only on successful creation. Bomb movement/spin/
gravity are per-call, fuse/post duration/trail use delta; trail checks not-exactly-
zero. Explosion `106C00` sends r+1 once. Persistent acid `107C78` sends r+9
when state/contact latch permits; surface callback `1080E0` activates it, not
an established one-second puddle timer.

Mod07 `63430` eligibility can reject existing effect; shared row11 life90
integer callbacks, origin4; `6438C` damages on eligible ticks, visual accumulator
+=4. Refresh/stacking not established. Mod08 requires exploded state plus
receiver2; `108BB0` creates/reuses source-linked target record, creation/repeat
`108A08` send row13, target3 terminates, cleanup `108980` can send14. Rows13/14
are scalar0 types6/7. No private attachment life proven; validity belongs to
bomb/source/target. Removing these calls changes semantics.

No accepted Bomb corrected trajectory; Quodrona attempt debugger hang. Body30
with accumulated delta, independent droplets and separately owned mods is a
candidate. Half-velocity/quarter-gravity leaves discrete Euler displacement
error; half/half doubles physical acceleration. Next: reproducible trajectory,
fuse/contact/explosion/acid onset and attachment creation/repeat/cleanup. See
prior Pokitaru symptoms task4 for isolated candidate contracts, not validation.

# Id5 AgentsGlove

Weapon waits subtract1; `10E77C` creates container hash223A1CCE, velocity/spin.
`10E714` dispatches states0/1/2 to `10EB1C/10EDC0/10F7D8`, unreviewed.
Agents life900, byteF1=60, post `10DA48`; controller `1091D0` may attempt40
target solver iterations. `1099BC` clears LOS, decrements life/F1, dispatches
ground/alternate AI. DC is classification0none/1clear/2obstructed, not elapsed
time. Random waits, analytic ordinal arc, fixed motion, animation events,
attack latches, exact-zero checks and retained-target expiry have distinct clocks.

Post consumes request with clear LOS: rank1 grenade, rank>=2 two lasers; failed
creation retries. Mod0B rocket has distinct LOS/state/F1 gate, reload60. Whole
post gating also changes effects/cleanup. Mod0A's complete consequence remains
UNKNOWN. Damage selection is newly explicit:

| Route | Row selector |
| --- | --- |
| Melee `10CF38` | fixed15/16 by advanced rank>3 |
| Grenade `1105B0` | fixed17/18 by advanced rank>3 |
| Expiry `109A68` | current canonical id5 rank, `2CD18C`: 24,24,24,24,25,26,27,28 |
| Laser `11136C` | current id5 rank, `2CD594`: 19,19,19,1A,1B,1C,1D,1E |
| Rocket `11231C` | current id5 rank, `2CD688`: 1F,1F,1F,1F,20,21,22,23 |

Children can reread current inventory rather than cached agent rank: in-flight
upgrade/owner changes are a required control. Rocket age+=1/30 but fixed motion
~2/3unit/call, impact/timeout terminal effects. Grenade integer age, gravity/
bounce/spin and global counter. Laser flight uses delta; impact fade/emission is
per-call, reviewed `111868` fade has no further receiver calls and emits10
random effects/call. Laser excludes AgentOfDoom/player groups.
Prior TESTED life900 at60calls=15s; two -.5 life loads plus JIT restore30s,
**life only**. Body30 plus that life correction would give~60s. Next: container,
attack/retry ordinals, current/cached rank and each child lifecycle.

# Id6 BeeMineGlove

Weapon waits use delta; post launches mine. Mine state4 age+=1, every8eligible
calls attempts one bee, resets on success, registers SwarmManager until5. State5
strict threshold; state6 dies without0E, state7 calls `115FC8` with0E, state8
fades. `115FC8` area **fixed9D scalar1200 type0 reaction3 origin6**, plus3
shrapnel. This is a high-damage lead; Ratchet eligibility/one-shot UNKNOWN.
Swarm state1 strict>60 crosses at61 fromzero;0D changes later state, five slots.
Bee age+=1, filelife1800, per-call AI/motion/contact. Direct cached r+8D
`[9.6,19.2,28.8,38.4,72,118,190,275]`; evolved survivor2 installs r+95 via
`646AC`, predicted `[0,0,0,.166667,.333333,.666667,1.2,1.733333]`.
**Contradiction:** initializer `1157DC` queries0D/0E against id4, later code id6.
Pointer resolution predicts false initializer queries; preserve, don't fix.
No live acceptance. Next: spawn/swarm ordinals, area target eligibility, direct/
secondary and initializer quirk under natural state.

# Id7 ShieldCharger

Creation caches rank/capacity and consumes one ammo. Active `16CB78` queries16
close targets; current rank>0 sends r+D7 **every eligible update**, independent
of sound/status timer. Selector2 halves initialized scalar: r1..3=1/6->1/12;
r4=.8->.4; r5~1.166667/2; r6~2.333333/2; r7~3.333333/2; r0zero. Current
inventory rank is distinct from cached capacity. Rank>2 bolt `16EF60` reload150.
`16F228` follows target/endpoint and3shared rays; first phase1 with latch+D4zero
sends current r+DF once, actual reward, sets latch; phase3 cleanup.
Receiver absorption/capacity is separate. Mod10 reflects eligible projectile
through `16C084`; mod11 `163E90/164100` child pool<2, hash0805C334 identity/
lifecycle UNKNOWN. Incoming damage can feed XP `109A4`. No live DPS/bolt/mod
acceptance. Next: repeated contact, current rank, ray latch, reflection owner/
reward and mod11 child.

# Id8 ShockRocket

Mod14 charges~1/30/update to4, burst1..4;15lock;13extra electricity. Rocket
caches rank/mod13/speed, age-=1, capped angular guidance and fixed motion;
expiry can destroy without impact. Helper `1715C8`:
reject invalid/already-bound (`133550`), reserves up to3handles, optional
`132F30` target-linked child r+65, direct electrical r+55, actual reward,
evolved finite/excluded target chaining, **true only on terminal receiver3**.
Collision sends r+5D when false. Therefore a surviving target can accept BOTH
electrical and collision events: false means more than failure.
Scalars r+55 `[24,32,45,60,85,120,170,250]`; r+5D
`[48,32,45,60,85,120,170,250]`; r+65 `[3.6,4.8,6,7.5,10.5,15,22,33]`.
`132F30` creates via `132E20`, writes target child+14; actual recurring callback/
life UNKNOWN. No live acceptance. Next: survivor/terminal dual route, chain,
child, charge/burst ammo and deletion-only expiry.

# Id9 CrossbowGun

`12C01C` can create at calculated contact/end, bind animated target/exclusions;
mod17 seeks/recursively creates after occlusion. Direct `12B8E8` normal r+A6
`[32,48,64,80,114,165,232.5,360]`; alternate byte route r+9E
`[21,32,43,54,76,110,155,240]` plus config multiplier (official mode name
UNKNOWN). Area `12BBBC` r+AE `[10.5,16,21.5,26,76,110,155,240]`, up to16
targets. Direct stores up to4excluded pointers and actual reward; missing/
invalid animated target takes area. Mod16 creates3daughter shots once, copies
exclusions and sets daughter guard, not perfect global deduplication. Evolved
`12CDEC` creates3rays; independent phase1 latches each permit area once; all
phase3/completion controls cleanup. Attached state age150-=1, validity/`12BE5C`
can exit earlier; Boolean prototype inconsistent, needs instruction confirmation.
No live acceptance. Next: direct/area/daughter/ray total, exclusions, target
death and attachment lifetime separately.

# Id10 Flamethrower / Spitfire

Update marks pending work; post consumes it, keeping common tail and mod1A
release. Direct r+41 predicted `[.533333,.8,1.066667,2.133333,4.666667,7,10,
16.666667]`; eligible hits install secondary r+49 for45callbacks origin10.
Modulo query-distance cache does not imply skipped damage. Mod19 charged reach/
cache was omitted by FG2.1, included FG3.
Spitfire `1737F0` requires sufficient charge, caches charge/owner/speed/row;
`173AA0` fixed-step collision rays,3rotating trails, integerlife, near-contact
life clamp. Contact/expiry `173CCC` once, query32 charge-radius targets,
normally fixed51 scalar70 and weapon10reward. Its secondary eligibility/install
addresses **source Spitfire object**, row52 initialized1, not simply DOT on each
enemy; downstream target relation UNKNOWN.
Prior scoped TESTED Otto FG3 V1/V4/V5/V8: example .633=.533direct+.1secondary;
V4~2.67full/.53deferred/2.13direct; V5~6full/1.33deferred. V2/V3/V6/V7 NOTRUN.
V4/V5 mod1A cap/event70 accepted, trajectory/life/collision not. Small Pokitaru
binding samples are not full regular-enemy tests. FG3 secondary excludes
Spitfire/preserves chained callbacks. Next: initial phase, regular enemy DOT,
source-linked secondary, mod19reach and fireball flight/expiry.

# Id11 LaserTracer

First-pass `2B0208` governs ammo AND springs/state/fade/interception; keep input
copy preamble on both A0substeps. Weapon configuration clamps rank to3, damage
uses rawrank. Ammo fractional debit retains remainder; pvar+8 effect timer.
Post `14C474` passes owned1C/1D to beam `149828`; geometry/world cache/target
proximity/visual accumulators have broader scope than damage. Four routes:
`149F68` mod1C r+7D all intersections; `14A2A4` closest r+6D;
`14A9E0/14ADEC` near-owner/offset r+85. Exclusions/transparency differ; terminal3
affects continuation/reward. Zero-scalar receiver still reacts; skipped return0
may change transparency. Predicted normal r+6D `[5,7.166667,10.166667,13.333333,
17.333333,22.833333,29.666667,36.666667]`;1C r+7D 1.25times those;
r+85 approximately `[1.667,2.39,3.39,4.443,5.777,7.61,9.89,12.223]`.
Piercing label INFERRED. Mod1D `146154/1463D4/14B81C/193B50` pool identity/
damage/life UNKNOWN. Prior OttoV1 controls: A0 5HP/.4ammo perA0frame;
uncorrected60 10HP perA0-time frame/.4ammo per60frame; first-pass controls
ammo/state only, receiver gate controls normal HP only. Combined plugin/ranks/
mods/visuals not accepted. Next: combined controlled phase, terminal
transparency,4routes and1Dpool.

# Id12 SuckCannon

Absorption `175DC4 -> 177348` fixedCE scalar0 **type10 reaction1**; results0/1
reject, others allow cloning/storage of animated/static representation and
metadata, marked20000. Manager `17794C` progress+=~.15/call (`2D7E80`); completion
copies three metadata bytes/ammo slot, ammo+40++, deletes representation,
`10924` weapon12 explicitterminal3. This is authored storage credit, not a gate
license. Receiver-specific original target removal remains its own contract.
Comet `19ADF4`: first staging call, then integerage (filecap30), fixed movement/
subdivided collision. Direct r+B6 `[9.6,15,32,38,80,115,157.5,265]`; rebound
r+BE `[4.8,7.5,16,32,60,90,125.5,200]`; evolved area r+C6
`[0,0,0,26,40,65,92.5,135]` can coexist with direct; nonzerorank secondary
r+CF =1/30times `[2,2,8,16,36,72,108,150]`. Mod1F permits continuation when
old reboundcount<=2, increments; fourth contact old>2destroys. `19ABEC` seeks
target or reflects/randomizes, three-entry history not global perfect dedup,
short two-call collisionhold. No live acceptance; infinite-ammo unnatural
state not evidence of natural stuck-ready bug. Next: absorption/credit/slots,
startup,4contacts, overlap and secondary owner.

# Id13 Mootator

`158CD0` target threshold may return-1; target change resets progress; target
retention uses delta. Rank increment per eligible update
`[.0074074073,.0111111114,.0166666675,.0333333351,.0333333351,.0333333351,
.0333333351,.0333333351]`, strict>threshold. Species threshold/admission needed
for duration. Conversion `158E10` fixed53 scalar0 type10 reaction1; **any nonzero
receiver result** creates `199CF4`, actual weapon13reward, clears progress/target.
`199CF4` selects species/world attachment: rank0 vs1..2 branches differ,
one state3age150, another state1age180, failedgeometry state5age0. Older
"all non-evolved150" shorthand too broad. `159608/159334` visual helpers, not
repeated ordinary damage. Transformed update/reversion/death/life owner UNKNOWN.
Next: species threshold, semantic receiver, lifecycle/reward under natural state.

# Id14 MiniTurretGlove

Positive LEVEL24 binding: registry29BF88 hash13399A6F, descriptor2A206C,
init13A5F4, callback13A6AC, update13A7AC, pvar4C. Existing export
`weapons-next-clock-20261003/slices/miniturret-24/0013a7ac.c`.
Update lazily establishes13A6D8, reads id14, decrements two per-call timers,
animation/input/aim gate, successful child **139FDC** consumesammo/reloads/state.
No supplieddelta, so weapon-delta doesn't directly fix timers. Child row/life/
target/terminal UNKNOWN; init id4 model query not BombGlove identity proof.
Onlyrank0, legal campaign availability UNKNOWN. Next: child bounded export and
owner-controlled legal activation; no forced unsupported ranks.

# Id15 Ryno / TELT

Only0..3. Animation launch, projectile flight and firing cadence separate.
Parent checked `169698` to resolve handoff shorthand: collision kind2 delivers
direct **r+E7**, then area **r+EB** via100C30. Both file scalar families
`[75,105,150,220]`; overlap/admission cannot be automatically summed. Expiry
age threshold deletes/effects without that area call. Prior TESTED launch
latency30.08A0frames/15*2Cframes, speed23.94/23.97units/s, life1.17/1.13s;
rate24->48 REJECTED. Global animation end-bit candidate `76BCC` via
`785B8/78618/78658` accepted only observed Ryno case; finite hold table/other
nonlooping consumers are regression risks. Next: direct/area overlap,4ranks,
kill/reward and animation regressions.

# Ids16..24: gadgets/passive consequences

| Entry | Observed main path | Transitive limit |
| --- | --- | --- |
| Hypershot `144954` | Delta cooldown, hook target, animation follow, no ordinary damage in reviewed update | Attachment/induced hazard contact UNKNOWN |
| Sproutomatic `17553C` | Activation animation,4UV/phase fields modulo800 each held update | Plant/level activation callbacks UNKNOWN |
| Polarizer `15F058` | Callback table333114 via15F010, target search15F760, target-specific callback every active update, distinct release argument | Registration writers/physics and induced damage UNKNOWN;15E600 presentation |
| PDA `15E380` | Menu AA440(12,0) | Purchases/equipment are separate consequences |
| Shrinkray | Passive type3; ShrinkRayRatchet172CFCempty, ShrinkBeam17202Cvisual | Id20 binding to these classes UNKNOWN; no invented offensive shrink weapon |
| Boltgrabber |121264empty | Passive collection consumer elsewhere |
| Grindboots | Passive record | Movement/hazard exposure, binding UNKNOWN |
| Mapomatic | Passive record | No closed direct damage producer |
| Boxbreaker |121D74empty | Wrench/object area consumer UNKNOWN; stub is not absence proof |

# Priority measurements and remaining closure

Use fresh natural inventory, exact module/hash/base, rank/mod/armor, controlled
source/target/difficulty and A0/B/C. Log actual query/delivery/result/HP/state,
child births/life/cleanup/rewards and action timestamps. Highest-value next
tests: Shock survivor/terminal dual-route; Bomb trajectory plus mod attachment;
Laser combined state/damage phase plus terminal transparency; Crossbow direct/
area/daughter/ray accounting. Separately vary current rank while Agent/Shield
children persist. No visual impression, runtime write or worker agreement proves
parity. Unclosed children: Blaster terminal, MiniTurret139FDC, Shock132E20,
Shield0805C334, Moot transformed lifecycle, Spitfire secondary relation and
gadget/passive consumers. These are bounded future questions, not implicit
permission for broad half-rate corrections or optional rebalancing.
