---
kind: static
title: "Weapon children: ElectroBall arcs, Shield decoys and Treehouse MiniTurret chain"
date: 2026-10-06
authors: ["GPT (Codex)", "Codex read-only worker weapon_damage"]
status: complete
evidence: [OBSERVED, CORROBORATED, INFERRED, UNKNOWN]
summary: "Identified Shock mod13 and Shield mod11 children and their semantic/lifecycle contracts; narrowed MiniTurret to a native class chain with a firing stub and unresolved effective damage."
systems: [weapons, ShockRocket, ShieldCharger, ElectroBall, decoy, MiniTurret, damage]
levels: [LEVEL_01, LEVEL_24]
variants: [A0, B, C]
environment: "Existing C plus targeted original instructions/registry references; read-only worker, no live test or import"
related: [research/v2/damage-atlas-20261006/WEAPONS.md, research/v2/damage-followup-20261006/METHOD.md]
---

# Result and provenance

The prior anonymous Shock mod13 child is ElectroBall; Shield mod11 creates a
RatchetDecoyInner/Outer pair. Their clocks and semantic receivers are now
separate from their parent weapons. The LEVEL24 MiniTurret chain is identified,
but legal availability and effective damage remain UNKNOWN. An original firing
stub and unused-looking projectile fields support a prototype-route hypothesis,
not an assertion that the weapon is universally harmless.

Clean sources and SHA-256:

- LEVEL01: `d10a81d076fb44987a45314a020cda2f7e8b39f860b957911ca9365464676571`.
- LEVEL24: `a4e3f6496b3d2d238767fbb72b9db274dc5179dbe4d6f71eea2ce1fee22480bf`.

Source files are `02-Jeu-et-dumps/Data/BACKUP/BIN/LEVEL_01.PRX` and
`LEVEL_24.PRX`. C evidence is existing ignored
`research/v2/decomp-candidates/_local/20261001-mass/all/c/`; Mini glove evidence
is the existing `weapons-next-clock-20261003/slices/miniturret-24/` beneath
that local root. Native windows/C hashes and reproduction recipes are in
METHOD.md. No new matching, function census, import, export, annotations,
runtime experiment, game-asset modification or worker file edits.

**Coordinate trap:** old LEVEL01 class-table addresses below are historical
anchors one word before the actual name field. These anchors can contain a
scalar, not a descriptor pointer. LEVEL24's new native registry pointers are
reported at the actual name-field base. Pvar size is an explicitly checked
callback/descriptor field, not a guessed descriptor offset.

# 1. Shock mod13: ElectroBall

## 1.1 Identity, constructor and cached damage

CORROBORATED identity: hash5495B11A, old anchor2D0FAC, actual name field2D0FB0;
init132B38, cleanup132BA8, update132BEC, pvar28, registered receiverNULL.
It is distinct from ElectroshockWave (old anchor2D10B8, update134310).

1715C8 requires mod13 and its target-category condition, then invokes132F30
before the direct electrical hit using row `rank+55`. The wrapper obtains
target animation displacement, creates through132E20 and follows that target.
The inferred constructor `void` C prototype conflicts with its returning
caller and is not used to deny a returned object.

| Child field | Observed role | Parent creation value |
|---|---|---|
|pvar0| owner for reward | parent rocket owner |
|pvar4/8| two shared arc handles | initially0 |
|pvarC/10| decorative respawn waits | staggered |
|pvar14| followed target | wrapper target |
|pvar18| decorative endpoint distance |2D748C=2.0 |
|pvar20| cached damage row | creation rank+65 |
|pvar24| candidate-query radius |2D74D8=3.0 |
|moby70| update-call lifetime |2D74D4=90.0 |

The child caches its row at creation, unlike previously identified Agent
selectors that reread current rank. Reviewed update does not change that row
after a rank change. Existing row-family file scalars for `r+65` are
`[3.6,4.8,6,7.5,10.5,15,22,33]`; effective loss still belongs to each receiver.

## 1.2 Lifetime, position and query admission

Positive lifetime subtracts1 **before** active work. At/under0 it cleans up
without querying. Start90 therefore permits active work on calls1..89 and
deletes on call90. A nonpositive starting lifetime follows a separate branch
and is indefinite until another termination condition. Target flags masked by6
terminate the child; otherwise refreshed animation displacement drives position.
A terminal parent hit can consequently invalidate the child before its first
secondary query, depending on actual target receiver flag writes.

Native132CC0 loads f12 from pvar24 before132CEC calls16E98. Existing C omitted
this float argument. Query capacity2 and other arguments129,101,2,1 are
OBSERVED;3 is its radius, subject to helper filtering. Updater then requires a
target receiver and ownership/eligibility through10A28/319E0. Ratchet eligibility
is UNKNOWN until those query/category/ownership conditions are established.

1335F4 requires a nonnull receiver-bearing target, rejects targets already
represented by any active shared-pool entry, obtains a usable local handle,
creates a target arc, reads cached row20, applies selector2 halving when needed,
calls the real receiver and forwards its actual result to
10924(owner,8,target,result). The ray updater13302C has no damage/reward call.
Visual endpoint updates are not repeated damage by themselves.

## 1.3 Shared pool and conditional recurrence

Global332B5C contains8 entries, stride6C. Handles combine slot index and a
generation;1335A4 validates index/generation/active state,133550 searches all
active target references. Parent ShockRocket arcs and ElectroBalls share it.
Parent binding can suppress the child's same-target hit. Concurrent rockets,
other children and decorative entries affect capacity and recurrence.

133388 takes a free entry or compares priorities: target arcs priority1,
decorative priority0. Replacement requires a strictly higher priority than the
lowest existing one. Each ElectroBall owns two handles; damage can replace its
decorative/state2 handle, but does not freely overwrite active target bindings.

| Arc contract | Clean value | Clock |
|---|---|---|
|decorative life|2D0F1C=9| owner updates |
|target-bound life|2D0F24=15| owner updates |
|decorative respawn random range|2D0F20, up to approximately7| per-call wait |

Query runs before handle decrement. For one isolated owner/no competing pool
operations, call1 creates life15 and decrements it in that same update. Query
through call15 still sees the binding; cleanup occurs after call15's query;
call16 can hit again. An earliest15-call interval is **INFERRED under those
conditions**, not a universal period. Target invalidation and pool contention
can alter it. Cleanup132BA8 releases both handles; ray disappearance alone
does not prove pool release.

Conditional physical deletion time is90/eligible-callback-frequency (about3s
at30 calls/s,1.5s at60). Spawn phase, dispatcher ownership and real A0/C cadence
are UNKNOWN. No unconditional threshold-halving fix follows from these numbers.

## 1.4 Minimal next measurement

One surviving target, mod13 off/on: separate parent rowsr+55/r+5D from child
r+65, target flags, both child handles, eight pool entries and actual receiver/
reward results. Repeat a terminal parent hit and two simultaneous rockets.
Record creation rank versus current rank and candidate/accepted target counts.
This distinguishes suppressed child hits, capacity contention and true damage
recurrence without using visuals as a proxy.

# 2. Shield mod11: Ratchet decoy pair

## 2.1 Identity and paired creation

| Class | Hash | Old anchor / actual name field | Init / cleanup / update / receiver | Pvar |
|---|---|---|---|---:|
|RatchetDecoyInner|0805C334|2D6260 /2D6264|163EB8 /163EC0 /164C30 /163F80|18C|
|RatchetDecoyOuter|11ECC0AC|2D62D4 /2D62D8|165140 /16517C /165184 /NULL|4|

16D37C invokes mod11 creation on an accepted absorption branch after updating
shield capacity/XP/state, provided mod11 is owned and163E90 reports fewer than
two decoys for the owner. Count array333174 is indexed by ownerF0.

164100 derives owner transform, chooses a random offset, uses source/normal
for direction and checks obstruction/supporting geometry. Placement can fail.
Both inner and outer must allocate; outer failure cleans up inner. Successful
creation can retain a dynamic supporting object/transform, registers spatial
bounds, creates three shared rays, hides both with flag20, sets inner alpha255
and life900, then increments owner count. Owner/shield/outer/support/ray fields
are lifecycle data; they are not a closed HP schema.

## 2.2 Activation, fade and moving support

164C30 first advances three rays. A phase1 event clears hidden20 on both,
sets inner state1 and starts another visual pulse; phase3 disables remaining
ray updating. Invalid retained supporting object destroys inner; valid support
updates its transform and copies it to outer.

Nonfading states decrement life70 by1. Reaching0 sets state3 and returns;
fading begins on the next body call. State3 subtracts clean scalar17 at2D62D4
from alpha, floors0 and updates packed color; an already-zero alpha at entry
destroys inner. Start255 needs15 fade subtraction calls, then a subsequent
terminal call. Old anchor2D62D4 genuinely stores this scalar17; actual outer
name field is the next word2D62D8, so these addresses are consistent.

900 calls conditionally correspond to30s at30 eligible calls/s or15s at60;
clock/phase measurements are still UNKNOWN. Outer165184 increments UV bytes78
and79 by2 independently. These are presentation/lifecycle clocks, not shield
weapon-delta clocks.

## 2.3 Incoming semantic receiver

Native163F80 reads the source from **t1**, not the misleading short C prototype.
It ignores damage scalar, type and reaction:

- NULL source or category byte other than1/9 returns1.
- Eligible category1/9 sets inner state3, ORs flag40, sets moby68=-1, destroys
  outer if present and returns3.

No HP subtraction occurs. An eligible **scalar0** event can have a terminal
response. This is decoy destruction/fade semantics, not Ratchet instant death.
No explicit already-fading guard exists in this receiver; repeat eligibility/
attacker accounting during fading is UNKNOWN and depends on calling filters.

Cleanup163EC0 releases3 rays, sets owner95C bit400, decrements count, unlinks
tracking/spatial data and destroys remaining outer. No10924 occurs in this
pair; incoming attackers may account for its return separately.

Inner squared owner distance below100 calls163FF4 and clears owner400; otherwise
it sets that bit. 163FF4 invokes14748/14780/1480C/1483C/1484C/1485C registration.
Shared spatial replacement and one non-damage consumer are closed below;
enemy-target diversion remains UNKNOWN. Do not name
400 "distraction" merely from proximity. Fading updates can still perform it.
No outgoing standard damage sender occurs in reviewed inner/outer callbacks;
indirect targeting/support consequences are not excluded.

## 2.4 Minimal next measurement

Record paired allocation, owner count, hidden/visible phase, life900 and fade
255->0. Compare source categories1/9/other and scalar0, recording inner state,
outer cleanup and attacker reward. Repeat two decoys, support invalidation and
owner crossing10 units; identify registration consumer before naming an AI
effect or changing its timing.

## 2.5 Shared spatial snapshot and a concrete non-damage consumer

Native163FF4..164050 replaces one snapshot rather than allocating a list:

| Helper | Decoy native input | Shared destination |
|---|---|---|
|14748|a0=moby30|position369640..4C; offset3696B0 from2AA918~0.6|
|14780|a0=moby|16-float transform369650..68C|
|1480C|a0=2CA358 vector(0,0,0,1), **f12=0**|vector369690..69C, scalar3696A0=0|
|1483C|a0=1|integer3696A4=1|
|1484C|f12=float2D6254=3|float3696A8=3|
|1485C|a0=moby|registered pointer3696AC|

1480C's inferred integer-like prototype is misleading: vector arrives in a0,
scalar in f12. No HP/damage dispatch in the setters. A4/A8 and owner400 meanings
remain UNKNOWN;1/3 do not prove enable/radius/priority/damage.

1486C copies three position floats;14890 four;148BC returns position pointer;
148C8 transform pointer;148D8 copies auxiliary vector/returnsA0 scalar in f0.
14908 produces adjusted position with B0 vertical offset and another conditional
Y override; operational use is closed without a broader targeting label.

One selected existing C consumer **ShakeyBush_Update16ABA8** requires148D8's
scalar>1e-5 in its inactive spatial branch, then uses position/transform for
proximity/orientation. Decoy's scalar0 fails this guard. Conditional suppression
of that branch is INFERRED; controller-trigger/already-active paths can still
move the bush. No damage dispatch/HP subtraction in the reviewed consumer;
canonical ShakeyBush context supports identity. Enemy diversion remains UNKNOWN.

Five setter C files/one consumer and three native windows form this bounded
pass; hashes in provenance.json. Concrete14908 caller **181C18** was located
but **not opened** within that budget. Next read that single consumer and bind
its class from existing canonical evidence; it may be another presentation/
collision use. No global enemy targeting search or live acceptance.

# 3. LEVEL24 MiniTurret chain

## 3.1 Native identities and glove/manager

The LEVEL24 identity guard has an empty class list; it is not a complete class
inventory. This bounded chain follows the established glove call and adjacent
native registry entries only.

| Class | Hash | Registry slot | Actual descriptor name base | Init / cleanup / update | Pvar |
|---|---|---|---|---|---:|
|MiniTurret|9FA3A84F|29BF78|2A1F48|139160 /139168 /1399B0|30|
|MiniTurretBall|B32180A3|29BF80|2A1FBC|13A39C /13A3A4 /13A3AC|34|
|MiniTurretGlove|13399A6F|29BF88|2A206C|13A5F4 /13A6AC /13A7AC|4C|
|MiniTurretManager|50C95904|29BF90|2A20F0|13B014 /13B01C /13B024|58|
|MiniTurretRocket|29895950|29BF98|2A2158|13B1EC /13B1F4 /13B214|C|

All five registered receivers areNULL. Turret has extra callback13998C;
reviewed rocket extra callback words are zero.13A6D8 finds a manager with matching
player owner or creates through13ABC8; glove retains it at pvar1C. Manager update
13B024 is a return stub; list/exclusion helpers still have behavior.

Glove reloads pvarC=26 and pvar8=180, early trigger18, each wait decrementing
per call. Successful firing decrements inventory id14 ammo before later ball
spawn. Launch branch2A2058=0.533333361; alternate ballistic2A2054 is file0 with
initializer/legal reachability UNKNOWN.

## 3.2 Ball flight and deployed turret

139FDC stores manager0, velocity1C..24, acceleration4..C (coefficient
2A1FB8=0.0111111123) and random rotation. No private lifetime is established.
13A3AC computes speed/direction and queries swept world1953C. Contact builds a
transform, calls138DAC(manager,transform), then64BFC(ball,1). Otherwise rotation
updates, acceleration is added to velocity and updated velocity to position.
This is per-call Euler-like integration, not supplied weapon delta. No outgoing
receiver/reward occurs in the reviewed Ball body.

138DAC creates turret, copies owner from manager, retains manager8, caches id14
rank18, state0, life1800 and cooldown10. Pvar1C also starts at10, but its role is
**UNKNOWN**: it is tested for zero after targeted firing, yet no decrement was
established in constructor/update/scanning/aim write audit. This is not a proven
ten-shot limit. Companion creation/manager13AF88 registration complete entry.

States<2 use139708 deployment without ordinary lifetime decrement. Presentation
scale grows0.2/call before active/search state. States>=2 decrement life1800 by1,
delete on expiry, and decrement nonzero cooldown with zero clamp. Target validation
1396D0->13AE2C, acquisition13AC9C, target parameters10/0.9, target-facing aim
0.2/~0.988, scanning aim0.05/~0.999, random waits12..25 and state4 search with
up to10 attempts are observed; complete filtering/parameter meanings remain open.

## 3.3 Stub, alternate projectile and damage uncertainty

For aligned valid target/cooldown0,1DDA4 selects evolved rank>=3. Evolved route
uses13B0B4; non-evolved route uses **FCA78, an original return-zero stub**.
This is native code, not failed decompilation. Scanning also calls13B0B4.
Reviewed firing sites pass2A1F00, clean float0; runtime writer/initialization
remain UNKNOWN. File0 does not establish runtime-zero weapon damage.

13B0B4 creates Rocket, stores owner and float argument in pvar8, starts life30.
13B214 decrements positive life1/call, moves forward at0.600000024/call and
cleans up64BFC on1B210 collision or expiry, with sound/effect cleanup. The reviewed
update never reads owner or pvar8 and contains no receiver/10924 call. This
narrows but does not close effective damage: collision-helper side effects,
animation/model events, data initialization and legal rank availability remain
UNKNOWN. Registry presence is not proof of usable campaign content. Existing
rank0 legal-parameter evidence does not authorize forced rank>=3 conclusions.

## 3.4 Next actions

First establish legal rank0 HIG Treehouse use. Record glove ammo, contact,
deployment, selected target, firing stub/scanning branch and rocket lifecycle.
Static gaps: writers of2A1F00 and pvar1C,13AC9C/13AE2C filters, collision/model
event consequences. No effective damage or30/60 gameplay parity is accepted.
