---
kind: static
title: "Arena and Microbot consequences: area payloads, exit quotas, bridge resolution and occupant release"
date: 2026-10-06
authors: ["GPT (Codex)", "Codex read-only worker clank_minigames"]
status: complete
evidence: [OBSERVED, CORROBORATED, INFERRED, UNKNOWN]
summary: "Closed LEVEL04 Toss/Mine payloads and SurvivalBot destructor accounting; separated exit success, bridge conversion, removal and flinger release from player HP."
systems: [Microbot, SurvivalBot, arena, VehicleMine, flinger, damage, minigames]
levels: [LEVEL_04]
variants: [A0, B, C]
environment: "Complete bounded native updates and resolved dispatch tables; no Ghidra import or live play"
related: [research/v2/damage-atlas-20261006/CLANK_MINIGAMES.md, research/v2/damage-followup-20261006/METHOD.md]
---

# Result and evidence limits

Microbot Toss performs real area receiver dispatch, with recipient-specific
outcomes. VehicleMine's earlier unresolved193A84 is roster removal; its actual
payload is a separate interface callback. Survival counts remaining exit quotas
and resolved robots independently: arrival, deletion and bridge conversion are
different causes of resolution. Flinger consequences forward a vector through
an occupant interface, whose final effect remains UNKNOWN.

Clean LEVEL04 source `02-Jeu-et-dumps/Data/BACKUP/BIN/LEVEL_04.PRX`, SHA-256
`6896122ac19973e928303dc94c40fa309b5f06e5fef6ab14f624987035a4dc37`.
Worker source-preservation check was unchanged. Existing helper/native schema
provenance and all31 byte-window hashes are reproduced in METHOD.md/recipe.
No files, game assets, runtime, project, annotation or Git edits by the worker.
Full native extent is not full semantic understanding of every transitive
helper. No equivalence is extended to04 relatives08/24 or other modules.

# 1. Native callback identities and coordinate correction

These canonical descriptor RVAs begin at the **name pointer**, unlike older
one-word-earlier anchors.2E7700/2E791C/2EA930 contain preceding data and are
not class hashes or the actual name field. Native R_MIPS32 callbacks corroborate
the following bindings:

| Class | Actual name base | Init / destructor / update / receiver |
|---|---|---|
|MicroBotSurvival|2E7704|15B1B0 /15B288 /15B8BC /NULL|
|MicrobotTossBomb|2E7920|15D6A0 /15D77C /15D7B0 /15DA5C|
|SurvivalBot|2EA934|1817BC /1817C4 /182AA0 /NULL|
|SurvivalBotPort|2EAA14|1849AC /184A18 /184A4C /NULL|
|SurvivalBotSpawner|2EAAE0|184F80 /184FE8 /18501C /NULL|
|SurvivalBridge|2EAC90|185B94 /185C3C /185C7C /not newly inspected|
|VehicleMine|2EC2B0|196624 /196650 /196658 /NULL|

TossBomb receiver15DA5C returns0. Its zero/NULL standard damage acceptance
does not preclude fuse/contact/fluid detonation or interface-based deletion.

# 2. Toss flight and area detonation

15DCE0..15DD8C follows global2E7860 -> current controller ->config20, named
`vehicleController` in the existing MicrobotToss schema. It calls1932E4 then
6D208 to delete the bomb, after effect/sound calls.

| Payload | Toss value |
|---|---|
|roster controller|linked vehicle/area controller|
|excluded target and damage source|bomb pvar38; owner/thrower label INFERRED|
|center|bomb position|
|radius|2E7904=2.0|
|scalar|2E7914=1.0|
|impulse|0.0|
|direction override|NULL|

Full15DD8C..15E0D4 flight reaches detonation when bombY<=controller config28
(`deadlyFluidHeight` in existing schema),19BB4 overlap/contact (type28, radius
2E7900~0.15),1B160 sweep (type28), or the prior fuse path. Position adds pvar
velocity1C/20/24 directly per call; vertical velocity loses2E75EC~0.01088889036
per call, without incoming-delta multiplication. No direct playerHP or round
failure assignment occurs in these consequence bodies. Receiver identity and
admission determine actual damage/destruction/failure.

# 3. Shared area helper1932E4

Full1932E4..193550 reads controller pvar byte44 and iterates8-byte roster
records from pvar0: recipient Moby plus metadata. It skips the excluded object,
asks195270 for target extent, then admits **horizontal XZ** squared distance
at most `(radius + extent)^2`. This helper has no Y-distance or line-of-sight
test. Actual roster membership still limits eligible objects.

It calls each group's receiver20 with scalar, **type2, reaction1**, center,
NULL direction and supplied source, ignores the nested result and returns a
geometric-admission boolean. A true result is not proof of HP subtraction.
Nonzero impulse separately computes radial/override direction and invokes the
metadata impulse callback using recipient geometry/mass. Toss impulse0 bypasses
that branch. Callback meanings and roster population remain UNKNOWN.

# 4. Survival controller: quota and resolution are different

Seven-entry native table1DB398, indexstate-1:

| State | Native target | Reviewed consequence |
|---:|---|---|
|1|15B90C|initialize/activate and enter7|
|2|15C354|reset state0/external UI state|
|3|15C2AC|inert in this callback|
|4/5|15C368|inert|
|6|15C2B4|cleanup/deactivate, restore control, enter2|
|7|15BAB0|active round|

Controller pvar8[] is **Port-associated objects**, count48, not a bot array.
184998 matches Port config8 to controller;1847E0 resets config4 from config0.
Existing Port schema names these `survivalController`, `currentBots` and
`botsNeeded`, consistent with the exit decrement below. Pvar4C is total target
(at least1),4D spawned count,4E resolved count,4F active flag,30 spawner,40 spawn
threshold.

Active branch order is significant: inactive4F writesstate6; it then sums the
**low bytes** of every Port config4. Sum0 writesstate3; otherwise4E==4C writes
state4. These writes do not return immediately, so later result writes can
replace a cancellation request and spawn logic can still run in that callback.
Success=3/all quotas filled and failure=4/all robots resolved with remaining
quotas are **INFERRED** until the outer UI/result consumer is read or observed.

Spawn threshold15C900..15C93C is **max(spawnRate,1.5)*30**, clean2E76F8=1.5.
184F34 truncates configured totalBots and keeps low byte; initialization clamps
target to at least1. Attempt requires object70>threshold and4D<total.
Successful18110C increments4D and184F60 subtracts1 from spawner float18.
Attempt resets70=0 even if creation fails; otherwise70+=1. Given timer0 and
threshold45, strict comparison predicts first attempt on admitted call47,
subject to actual entry/reset state. It is not a measured physical interval.

15B324 wraps15C384(controller,0) scene cleanup, not HP/failure.15C384's
registry2DCE80 binds cohorts, Port array and spawner and requests active
CDE706C1 deletion on deactivation.15B4E8 selects up to32 nearby objects within
radius2E76F4=0.5, class/config filterCDE706C1, nearest squared3D distance.
18251C is command-state admission, not HP/alive: returns0 for hexadecimal
1,6,A,B,C,D,12,16,17,18,19,1A,1B,1D,1E,1F,20; other states/default return1.

# 5. Complete SurvivalBot consequence and destructor chain

The previous canonical listing stopped after1024 instructions. Full native
182AA0..184534 is **1,701 instructions**. Its complete read closes the missed
terminal/bridge/destructor distinction, while transitive helpers remain scoped.

Exit181930..181A88 searches group/config4B929E8F, positively tied to Port
schema. Required vertical proximity allows config4 decrement only if nonzero,
then requests1D. State setter184534 maps1D->1E;1E emits its effect and deletes
through6D208. Port quota changes independently of controller4E.

Registered destructor1817C4..1818C0 cleans object/effect/collision and calls
15B13C(controller,bot) **only if bot pvar92==0**.15B13C increments controller
byte4E and removes a matching selected-bot overlay. This is resolved/deleted
robot accounting, not an exit-success counter.

State17 at183E2C calls185A44, creates F3066045 and stores the bot backlink at
created pvar18. Exact callback/catalog binding identifies **SurvivalBridge**,
name base2EAC90/init185B94. It immediately calls15B13C, unlinks collision,
clears bot93, marks inactive and sets92=1. The eventual destructor then skips
a second count. This is bridge conversion, not a corpse/HP death.

1816F8 requests direct removal20 and resets70 unless1813EC protects states
19..1A,1E or existing flag20. State20 calls6D208; destructor later supplies
the4E notification. Common physics tail can request removal after fall-height/
vertical-difference conditions and certain bot collisions. No ordinary Ratchet
HP subtraction is in update, setter or destructor; registered receiver isNULL.
Hazards still affect bots through state/deletion, so NULL receiver is not
universal gameplay immunity.

Clock distinctions: pvar94 counts down1; several70 phases add fixed1/30
(182C00,182CCC,183A54,183A98 ranges), others add1 (182F14,1835C8). Movement,
falling, selection, spawning and resolution do not share a universal delta.
Full callback extent does not establish a defect without eligible-cadence data.

# 6. VehicleMine: physics-interface payload and owner guard

193A84..193AE8 only removes the mine from controller config roster: find pointer,
decrement pvar47 and replace removed slot with last entry.196658..1966A0 state1
calls that helper then deletes. It is not the damage payload.

Initialization installs pvar0 interface2EC298 whose first relocated callback is
**1968A0**. Full1968A0..196A6C decrements object70 by1 before state testing;
initial70 is900. State0 triggers on roster target within horizontal extent or
remaining70<=0. Extent adds2EC278~0.2 to supplied recipient radius.

Saved owner pvarC is skipped as trigger while remaining>900-60=840 (clean
2EC284/2EC280). This temporary owner-trigger guard is **not** an explosion
immunity. Trigger/expiry both call1932E4 with radius2EC288=1.5,
scalar2EC27C=2.0, impulse2EC28C~1/3, exclusion=mine, source=mine, directionNULL,
then state1 prevents repeated state0 payload. Descriptor update removes/deletes
later. Owner can be geometrically admitted by the explosion; Toss instead
excludes its saved owner/thrower pointer. Recipient gates remain decisive.

900/60 count physics-interface invocations, not proved render frames or
descriptor updates. Compare both invocation streams before a timing correction.

# 7. Flinger recoil and occupant forwarding

Full19AE0C..19B018 builds source-position versus flinger recoil, or uses its own
orientation for tiny displacement/source==occupant; normalizes horizontal
direction, initializes recoil and animation5 and uses model parameter divided
by incoming magnitude. A valid attached occupant receives a vector scaled by
2EC754~0.1 through2D404. Other paths clear/detach arms129C78.

2D404..2D484 invokes **occupant->pvar0 interface->callback4**, passes the vector
and flinger context, unlinks arms and clears occupant pointer. No directHP
subtraction or death request occurs in19AE0C. Launch/release is strongly
INFERRED, final consequence UNKNOWN until actual occupant callback is bound.
19B018..19B0BC calls motionE560, advances animation, decrements pvarF4 by1 and
returns whether zero. F4 is not proven HP; fullE560 cadence remains open.

# Measurement agenda and remaining gaps

1. Fill Port quotas versus exhaust robots; record4C/4D/4E, all quotas, controller
   state and visible result to test inferred success/failure labels.
2. Compare exit, fall/removal and bridge: quota decrement versus4E notification,
   bot92 and destructor; confirm bridge counts only once.
3. Toss fluid/contact/fuse: record scalar1/type2/reaction1, source/exclusion and
   each recipient HP/state/return.
4. Within actual roster, compare equalXZ/differentY and intervening obstacle:
   helper predicts horizontal admission, recipient/roster may still reject.
5. Mine interface counts versus descriptor calls, owner guard840, radius1.5,
   scalar2/impulse1/3 and ownerHP, avoiding an assumed immunity.
6. Flinger bind occupant callback4; record vector/motion/state/HP separately.
7. A0/B/C admitted callbacks and wall time for +1,1/30, spawn and mine clocks.

Open: outer Survival outcome consumer; complete Toss/Mine roster population and
recipient receivers; flinger occupant callback; E560; all transitive bot motion/
interaction semantics; scene/cross-module applicability. Missing saved LEVEL04
Ghidra program still blocks new decompilation, not the native causal closure.

Bounded outer-result follow-up:15B340..15B4E8 constructs board-relative camera/
transform setup;15B1B0..15B340 initializes/destructs pvar and UI selection;
15B848..15B8BC resolves board/zone links.15B894 caches1017F0's opaque lookup
for hash8BE62A0B at2E7774, without reading state3/4. None positively binds an
outcome reader or current-controller accessor. Precise blocker: missing scene/
script reference or method binding connecting an outer consumer to this Moby.
Keep result labels INFERRED, and do not label the opaque cached lookup a result
consumer. Future native work needs that specific binding; live observation of
the next reader of controller45 after3/4 can supply a concrete target. This
negative result is not evidence that no consumer exists.

# 8. VehicleController recipient registration

Additional bounded owner pass identifies actual name base2EC0BC:
VehicleController init192D30/destructor192E70/update1956DC/load19430C, pvar4C.
Schema: obstacles[16], healthTeleporters[4], powerupTeleporters[4], radius/toggle.
19430C..19437C clears counts/flags44/45/46/4A and40; resolves obstacle count47
and teleporter counts48/49.192D30 toggles their10/20 flags according to46.
Those configured lists are distinct from damage roster0/count44.

ClankBotFlingerVehicle name base2E1EA8 init12A518/receiver12A6A0 (pointer
2E1EB8) is a concrete actor submitting registration.12A518..12A668 requires
config0 controller link, resolves the scene reference and requires nonnull
group40, without a specific class-hash check. It clears pvar/sets1000 and
calls192E78(controller,self,2E1E4C,1) at12A5F4. Actual Toss scene membership is
UNKNOWN.

Parent closed full **192E78..192F10**: unconditionally writes actor/metadata
at `pvar+8*count44`, increments byte44, and if a3's low byte is nonzero stores
that entry address in40. It sets actor10 and sets/clears20 according to46.
When46 nonzero and metadata0 callback exists, invokes it with actor/integer1;
callback meaning is not independently bound.

Registration and a concrete receiver-bearing flinger are now OBSERVED. Helper
has no local capacity check, duplicate/class/state filter or explicit failure
branch. This is not proof of reachable overflow/bad scene data: callers/scenes
can impose limits. Special entry40 meaning, other classes, metadata impulse
callbacks and cleanup membership remain UNKNOWN. No localHP subtraction;
1932E4 later calls the registered group receiver.

Recipe `damage-followup-roster-001.json` preserves three worker-positive
windows and exact parent registration. Earlier decode19430C..195688 included
neighboring helpers; final reproduction selects actual19430C..19437C and does
not label that broader range a complete registration function.
