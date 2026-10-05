---
kind: static
title: "Damage atlas: dispatch, health, armor, hazards and destructible receivers"
date: 2026-10-06
authors: ["GPT (Codex)"]
status: complete
evidence: [OBSERVED, INFERRED, CORROBORATED, TESTED, UNKNOWN]
summary: "A detailed static atlas of distinct damage and death routes; weapon, Clank and minigame contracts are separate, and behavioral parity remains unmeasured."
systems: [weapons, damage, health, armor, hazards, objects, Clank, minigames]
levels: [all]
variants: [A0, B, C]
environment: "UCES00420 clean offline modules, existing Allegrex exports and stored Claude module maps; no emulator experiment"
related: [research/tasks/gpt-damage-atlas-20261006.md, research/v2/damage-health-20261003/REPORT.md, research/v2/weapons-armor-inventory-20261003/REPORT.md, research/v2/module-bytematch-20261005/REPORT.md]
---

# Result and reading guide

Damage is a family of protocols, not one universal health subtraction. A weapon
can select targets, deliver a scalar plus type/reaction, spawn another damaging
actor, ask for a semantic transformation, or trigger a receiver whose return
value describes an event rather than remaining health. Ratchet's common receiver
is only one route. Grind collisions, arena vehicles and several death requests
take other routes. A zero scalar can destroy an object; a nonzero scalar can be
rejected; return 3 can describe completion without proving a conventional kill.

This dossier covers the complete 25-entry inventory domain, the 19 non-null
registered receiver slots in the inspected LEVEL_01 class table, common player
health and armor, identified environmental/death families, and the distinct
Clank/minigame/multiplayer domains. It is exhaustive over those enumerated
domains, **not proof that every scene-authored hazard or indirect receiver in
every level has been closed**. Explicit gaps are part of the result.

- [WEAPONS.md](WEAPONS.md): inventory, firing, ranks, modifications, child actors,
  contact/area events and timing contracts.
- [CLANK_MINIGAMES.md](CLANK_MINIGAMES.md): Clank, Giant Clank, flight, arena
  vehicles, MicroBot, Skyboard and multiplayer.
- [COVERAGE.md](COVERAGE.md): coverage matrix, contradictions, exact next
  research/measurement targets and publication decisions.
- [METHOD.md](METHOD.md): provenance, offline reproduction and exporter limits.

All unqualified function/data addresses below are **LEVEL_01 RVAs**. They are
not runtime pointers or portable patch locations. Field names are analytic
labels. OBSERVED denotes code/data inspected; INFERRED denotes interpretation;
CORROBORATED denotes independent existing evidence; TESTED is reserved for a
specified reproducible test. No new live A0/B/C test was performed here.

# 1. End-to-end damage protocol

## 1.1 Target selection and delivery are separate

`14A74` (existing name P_DamageEvent, 212 bytes) uses the already selected target
at `3696AC`, checks its group receiver, copies an impact position with a vertical
offset, and calls the group's receiver at group offset `+20`. Missing target or
receiver gives -1. It does not itself search an area, subtract HP or maintain
Ratchet's suppression timer. Decompiler float argument order is not an ABI
proof; any future instrumentation must use the instruction-level calling
convention rather than copying a guessed C prototype.

`EE9C` (P_HitTest, 336 bytes) queries at most 16 objects through `16E98`, adjusts
the query center by half a diameter along a direction, and invokes receivers
with **scalar 0, type 2, reaction 0**, followed by collision helper `EFEC`.
Consequently this query can trigger a crate or other semantic receiver despite
having no conventional HP payload. Counting calls alone does not measure DPS.

`100C30` is the shared area delivery helper. It queries at most 16 targets,
excludes its supplied source, applies player eligibility (`10A28`/`319E0`), builds
a direction from the center with a fallback for coincident positions, and
delivers a four-field record from the table at `2CB0CC`, stride 16. Selector 2
halves the selected scalar before delivery. Owner/id-dependent reward helper
`10924` can run after the receiver. Its return value is the **query count**, not
the number of accepted hits, deaths, or distinct health decrements. Saturation,
overlap, rejection and repeated targets must be measured independently.

The live table initializer `100EEC` writes scalars, including values derived
from `2CB0C8` (1/30). Earlier questions based on zero values in a saved static
image are superseded by the positive writer evidence in the inventory report.
Some zero rows are nevertheless intentional semantic operations; initialization
does not imply all rows become positive. Exact row families are in WEAPONS.

## 1.2 Return values are receiver-local contracts

The useful common pattern is rejected/ignored 0 or 1, accepted survival 2,
terminal 3. It is **not a global enum contract**. Counterexamples inspected:

| Receiver | Observable result | Consequence |
| --- | --- | --- |
| Ratchet `38540` | 0 eligibility rejection, 1 state/proxy rejection, 2 survival, 3 death | Nested proxy handling can conceal its receiver's return |
| BreakableObject `122088` | Always 3, but excludes one source group from deletion | 3 alone does not establish destruction |
| LunaNPC `1534C0` | Reaction state change, then 0 | 0 does not mean no effect |
| Flinger, LEVEL_04 `12A6A0` | Accepted local damage/state event, then 0 | Generic accepted-hit counters would miss it |
| PathAnimal `15DC40` | State/animation event, then 3 | Terminal result need not be death |
| Cow `1996F8` | Ordinary reaction changes state, then 3 | Reward/child behavior needs its own contract |
| Clank wrapper, LEVEL_02 `13AC08` | Admitted forwarding, then 2 | Nested Ratchet terminal result is not propagated |

Any probe must log source, recipient class/group, event type, scalar, result,
HP before/after and state before/after. A patch that fabricates terminal 3 to
restore a rate can alter rewards, transformations or child creation.

# 2. Ratchet health and the common receiver

## 2.1 Exact order matters

`38540` follows these gates and side effects in order:

1. Player flags `+95C` must include bit `8000`; otherwise return 0.
2. A nonzero `+97C` suppression field rejects the request, return 0.
3. Current player state `+F8` in 29..32 rejects it, return 1.
4. Interceptor `+FA4` can rewrite scalar/type/reaction by reference. Only its
   return -1 falls through; other values finish the request.
5. An active proxy at `+5CC` receives forwarding through its group callback.
   The outer function returns 1, independently of the nested outcome.
6. The direct branch updates the reaction field `+984`.
7. Armor reduction is enabled only when active actor `+594` has the checked
   group identity `36919224`. The exact retail/group label is UNKNOWN. Matching
   that number to the first word of a class descriptor found no class and was
   rejected: those are different identities.
8. Reduction helper `608` sums piece slots 0,1,2,4 (`5B0`) and combo extra
   (`5E0`). No explicit cap was seen in this sum.
9. If appropriate, armor callback `163210` receives incoming scalar times the
   reduction **before** the direct HP subtraction.
10. Effective scalar is incoming times `(1 - reduction)`. It is subtracted from
    HP `+964`, and negative HP is clamped to zero.
11. Zero HP takes a terminal branch: state 21 updates `+100/+102`; types 3/C
    choose death state 2B; other normal cases request 2A. Death/actor flags are
    changed and return 3.
12. Survival reloads `+97C` from `2B030C`, value 180, and handles knockback,
    current-state restrictions and type/reaction transitions.
13. **Type 10 forces HP to zero and calls `31B64` with state 29**, returning 3,
    even with scalar zero. It still passes all earlier gates, including
    suppression, interceptor and proxy. This is a semantic terminal operation,
    not an unconditional bypass of invulnerability.
14. Other admitted surviving requests return 2.

Types 0/1/2/D/9 affect knockback in selected cases; types 6/7 have semantic uses
in other receivers. Retail names for the complete type and reaction domains are
UNKNOWN. Naming every value "bullet", "fire" or "explosion" would overstate
the evidence. State and group eligibility can change what the same tuple means.

## 2.2 Health storage and writers

`3128C` and `312AC` expose current/max fields `+964/+968`. Progression helper
`35810` writes both. Healing helper `318C0` adds 20% of maximum HP and clamps to
the maximum, with a change flag at `+AA4`. Other direct writers exist outside
the common receiver. Player update `39B74` checks HP <= 0 and, except its state
37 case, schedules a death transition. Thus direct HP changes can cause death
later without producing a terminal return from `38540` at the write site.

Difficulty-dependent incoming values are selected from `2CC120` using
`CC588 - 1` (stride 40) and `22854` (stride 10). The exact owner/binding of
every selector is not closed; do not invent difficulty labels or claim identical
values across levels. A damage table is not a weapon-only table.

## 2.3 Suppression is already in the player substep domain

`39B74` decrements `+97C`. Original A0 performs two player substeps at 30 frames/s;
the corrected core performs one at 60 frames/s. Both nominally execute 60
decrements/s. The 180 reset therefore represents approximately three seconds
under those conditions. **Halving 180 again would change the intended window.**
Actual boundary admission, menus, pauses, slowdown and state transitions remain
UNKNOWN until measured. This reasoning applies to this field and owner only;
it does not transfer to object callbacks, vehicle cooldowns, armor emitters,
projectile lifetimes or every integer that happens to equal 180.

# 3. Armor: reduction and offensive mechanisms

## 3.1 Equipment and combinations

Equipment helper `42C` reads the inventory root `2AF280` and its slot layout;
`16305C` refreshes models and combo state into player `+5C8`. Helper `948` selects
uniform sets from six matching pieces, otherwise particular mixed tuples
(ordered slots 1,0,3,5). Piece indices 0..7 have observed contribution values
0, .05, .09, .12, .16, .21, .23, .24. The receiver sums slots 0,1,2,4 plus the
active combination's extra. Anatomical slot labels and all retail armor names
are UNKNOWN here; the numerical identity is retained instead of guessing.

| Combo | Extra reduction | Observed offensive/passive behavior |
| --- | --- | --- |
| 0 | 0 | Baseline |
| 1, uniform | .08 | Wrench burn row F0 and area row F1 |
| 2, uniform | .06 | `196FB8` emissions; surface path 10 emissions; passive modulo-5 branch |
| 3, uniform | .08 | Once latch `+FD`, eight children through `12D870` |
| 4, uniform | .10 | Attachments `192E54`/`192FD0`, attack `133EB0` |
| 5, uniform | 0 | Absorption `194A4C`; charged wrench bonus and reset |
| 6, uniform | 0 | Target effect `157214`, four passive emitters `193698`/`19353C` |
| 7, uniform | 0 | Fade/countdown, then child `122FA8` on expiry |
| 8, tuple 5,5,1,5 | .16 | Wrench variant 1; do not assume identical secondary behavior to set 1 |
| 9, tuple 4,3,3,4 | .08 | Variant 3, attack `141E70` |
| 10, tuple 2,1,1,1 | .12 | Variant 4, surface `15C8C4`, `197054` |
| 11, tuple 1,4,2,4 | .18 | Variant 2, attack `187CA4` |
| 12, tuple 3,6,6,6 | .11 | Variant 6, `157A20`, eight `157558` children |
| 13, tuple 1,7,2,7 | .34 | Variant 7, ordinary wrench scalar zeroed, secondary row 101 plus `646AC` input 180, set-2 emissions, equipped-wrench passive `192A98` |

These are code contracts, not measured combined DPS. Creation, effect animation,
receiver admission and actual scalar delivery must be distinguished for each
child. Visually similar armor effects can take different damaging paths.

## 3.2 Absorption, charging and timing risks

Set 5 consumes **incoming times reduction**, not the final damage remaining
after reduction. `194A4C` accumulates into `2DD358`. A strict `> 15` threshold
(`2D9FF8`) activates `2DD35C`. `194B74` drains by one per eligible call. Charged
wrench `18A2B0` applies a bonus and `194AB4` resets the state. A hit can overshoot
the threshold; neither the number 15 nor the accumulated value proves a fixed
15-second duration. Large hits, fractional contributions and source changes
need separate tests.

Passive armor runs through `37238 -> 163274`, with `2B00C4`, group identity and
player state gates. Set 2 uses a modulo-5 gate; set 7 decrements `46B7EC` and
fades `46B7F0` using `2D9D78`. The invocation cadence of that passive path is
UNKNOWN; do not assume it is owned by the corrected player substep.

Wrench update `189BE8` has variant-specific paths and `+DC -= 1`. Delivery
`18A6C8` uses admission byte `+FE`, a once latch `+FD`, an emission byte `+FF`
(10) and fade byte `+102`. Those bytes include phase/effect roles. Halving every
byte or integer would alter event selection and rendering as well as time.

# 4. Environmental damage and instant-death routes

## 4.1 Death requests are distinct from HP subtraction

`31B64` accepts destination states 28..33 and refuses when already in 29..32.
It changes actor flags and requests a transition via `39FD4`; it does **not**
write HP. `31B44` is different: it changes pending state/flags and a UI-related
global. Its surface/water use is not evidence of instant death.

The Sharkagator update `16AFD4` is a concrete independent death-request path.
State 0 calls pursuit `16B0E0`. In state 1, animation time from `6A9E0` exceeding
.1 changes it to state 2 and calls `31B64(player, 29)`. State 2 later clears on
animation completion. The inspected branch does not subtract HP and does not
test `+97C` or call `38540`. Attack admission/upstream pursuit is still UNKNOWN.
This proves the distinct local route, not that every Sharkagator attack always
bypasses every upstream protection or that every animation constitutes a kill.

## 4.2 Surface hazards

Surface classifier `41E40` feeds `3C470` and `4253C`.

| Surface result/path | Observed behavior | Interpretation boundary |
| --- | --- | --- |
| Class 6 | Common wrapper `3131C`, type 3, reaction 1; selected state exclusions | Hazardous floor damage; exact scene material UNKNOWN |
| `3C470` class-6 condition | Stationary/equal-Y tolerance 1e-5; difficulty table or `2B016C` in mode 3 | Movement and state gates affect exposure |
| Class 5 | State 36 and vertical/surface handling | Not automatically a lethal surface |
| Class 2 | `31B44`, flag 100, depth threshold `2B0124` | Water/surface transition is INFERRED; not a direct death call |
| `3C88C`, multiple states | Compares `+A1C` with `2B0168`, then requests 2D | Potential fall/depth danger; exact field meaning UNKNOWN |

The scene binding for lava, pits, crushing doors, electric walls, scripted
volumes and similar named hazards has not been enumerated. No absence claim is
made. Legacy TriggerLink/damageArea strings are leads, not a closed class-to-
scene mechanism. Asset inspection would require its own bounded question and
provenance rather than treating all labels as the same receiver.

## 4.3 Grind rail collisions bypass the common receiver

`4C2C0` checks `31078`, directly subtracts its input from HP, and clamps against
`2B0A1C`. The exact value of that minimum was not established in this session.
It does not go through `38540`, armor, interceptor or `+97C`. Do not conclude
that this subtraction alone can kill: a positive floor would prevent that.
Downstream grind update `4E008` compares HP with that minimum and requests death
state 2C, establishing a separate lethal state route.

`4C660` performs swept world collision with sample count based on movement
distance/radius `2B09C0`, response helper `4C480`, and damage `2B09E4`.
`4DB6C` handles grind targets/switches with two independent cooldowns at player
`+C54/+C58`. Configuration `+7C/+80` scales the current HP obtained through
`3128C`; each damage value is rounded upward. Each cooldown decrements by one
per helper invocation. The source is tied to grind-switch logic; exact retail
obstacle names remain UNKNOWN.

`4E008` state 6 also compares a stored height `+C3C` minus current Y against
`2B0978`, when `2B0A50` enables the path, and requests state 2C. These findings
correct an initially considered oxygen interpretation of `4C2C0`, which is
**REJECTED** by its grind callers. A helper name or field offset is insufficient
to label a damage mechanism.

## 4.4 Fire and explosions

Fire update `13A51C` uses configured overlap `71C10` and calls wrapper `3131C`
with configuration scalar `[2]`, or a mode-4 difficulty lookup from `2CC1E4`
(stride 10), type 0, reaction 1. This selected branch contains ordinary damage,
not an instant-death request. Its other emitter branch is not another health
hit merely because particles are created. It cannot establish the behavior of
all flame, lava or enemy fire classes.

Area explosions use the source/query/selector/receiver contract in section 1.
A high scalar can exceed current HP on an admitted call, but the outcome still
depends on armor, suppression, ownership and target receiver. The Bee mod-0E
expiry row 9D has scalar 1200 in the reconstructed initialization: a concrete
high-damage lead, not a measured universal one-shot. Overlapping direct and area
deliveries must not be summed without observing receiver admission.

## 4.5 Death/recovery clocks

Player state machine `3C88C` contains several presentation/recovery phases:

- State 2A waits for animation completion, then enters 2F and loads `+A54`.
- State 2B waits for animation 3D at time >= .8, fades, restores HP from
  `2B0118`, and invokes checkpoint/retry behavior.
- State 2C motion can transition/fall through to 2D; 2D increments actor `+70`
  until `2B0120`, then fades and retries/restores health.
- State 2E increments `+70` by 1/60 and lowers Y by 1/60 until two seconds.
- State 2F decrements `+A54` by one per eligible player call and combines it
  with fade completion.
- State 32 interpolates Y from animation progress and increments `+A54` to
  threshold `2B0154` before 2F; state 31 has a flag-driven 2A transition.

These are not all damaging events. Some are already player-substep clocks.
Death latency, animation, recovery, checkpoint reset and the actual lethal
decision need separate A0/C timing measurements.

# 5. Enemies and objects: registered receiver inventory

The existing `level01-classes.json` has **19 non-null registered slot-3 rows**.
Two cow descriptors share one function. The table is a useful coverage boundary,
not a complete census of indirect group callbacks or other level classes. A null
registration slot does not prove invulnerability, and group callback `+20` is
not established by descriptor word 0 alone.

## 5.1 Health-bearing enemy families

| Receiver | Admission and storage | Terminal/reaction behavior |
| --- | --- | --- |
| Crab `1241E8` | Config `+40` rejects; states 19/1A reject except type 7; HP pvar `+74` subtracts scalar | Type 10 destroys; ordinary <=0 enters death state 19 or type-B immediate path; surviving return 2; reaction state 18 possible |
| TMRobotHeadB `17BB1C` | States 16/17 reject except 7; config `+3C` invulnerability; HP pvar `+70` | Type 10 destroys; reaction threshold/counter `+74` separate; death state 16, selected detached states B/C destroy directly |
| Torso `17E974` | Config `+30/+4C` rejects; state 16/7 rejects except 7; HP pvar `+6C` subtracts | Type 10 terminal branch; reaction reload `+74 = 15`; ordinary death 16/type B immediate; surviving 2 |
| TrainingBot `183F30` | State >12 rejects except 7; **pvar +70 adds damage** against difficulty-selected threshold `2CC104` | >= threshold enters D/E and returns 3; type 10 destroys; reaction cooldown `+7C = 15` |

The TrainingBot field is accumulated received damage, not remaining health.
Recording its increase as healing would invert the result. Torso/TrainingBot
reaction counters change animation admission; the inspected subtraction/addition
still occurs, so these are not proven HP invulnerability windows. No local
suppression counter was seen in the selected Crab receiver. That does not rule
out upstream source or collision gates.

Types 6/7 take semantic helper paths (`11278` in selected receivers). Damage,
reaction, effects, reward and cleanup can diverge. Remaining enemy families in
other campaign modules, bosses and spawners require their own receiver binding;
this table does not promote a LEVEL_01 contract to them.

## 5.2 Destructibles and non-HP interactions

| Registered class/receiver | Detailed contract |
| --- | --- |
| BreakableObject `122088` | Returns 3 unconditionally; deletion excluded for one source-group identity. Scalar is not used as an HP decrement in this function |
| Crate `129478` | Requires active bit 1 and rejects types 6/7. No scalar-health comparison; an admitted type can break it even with zero scalar. Type 10/B bypass ordinary debris/reward paths before cleanup `1204C8`; ordinary path uses `18CF88`, `12A000`, state 2 and `6A3C0` |
| CrateAmmo `129670` | Rejects 6/7; helper `1296E8` returns 0/3. Detailed extra-drop ownership remains UNKNOWN |
| LunaNPC `1534C0` | Unless states E/F, changes reaction state to 11, then returns 0; no local HP subtraction |
| PathAnimal `15DC40` | State 0 -> 1, animation 2/sound, returns 3; otherwise 1. Completion is not proof of death |
| MutantCow / MutantMadCow `1996F8` | Type 10/B destroys. Ordinary path rejects missing source/state >4; otherwise `19A318` requests state 5 and returns 3 |
| ShakeyBush `16AAFC` | Sets state 1, random lifetime `+70`, config `+50 = 0`, `+54 = lifetime/30`, table `+58`; returns 0, no scalar-health subtraction |
| RatchetDecoyInner `163F80` | Selected source identities trigger state 3, flag 40 and linked child destruction, return 3; otherwise 1 |
| BeeMine `113AF8` | Same-source/team case in state 5 unlinks/reset lists and velocity, returns to state 1, clears flags/effects; returns 0, not direct HP loss |
| Ratchet `162FC0` | Forwards through `3131C` only when its actor aliases the active global actor; otherwise 1. Exact decompiled prototype must be reconciled with instructions for probes |
| AgentOfDoom `109CDC` | Eight-byte no-op receiver returning 0 |
| ChameleonDecoy `1232D0` | Eight-byte no-op receiver returning 0 |
| DropshipB `12E904` | Eight-byte no-op receiver returning 0 |
| ShieldCharger `16D37C` | Separate contact/absorption logic; detailed in WEAPONS |

The physical object may be static or dynamic while its damage protocol remains
semantic. Motion, collision enablement, break animation, debris spawn, pickups
and removal can be separate fields/callbacks. No-op slot receivers do not prove
that another interaction, collision script or controller cannot remove them.

# 6. One-shot taxonomy and falsifiable protocol

| Kind | Concrete lead | What remains to prove |
| --- | --- | --- |
| HP exhaustion in one admitted event | Any scalar >= effective remaining HP, e.g. high Bee row 9D | Real scalar, armor, difficulty, source/receiver gates and overlap |
| Semantic terminal type | Common Ratchet type 10; several enemy/object type 10/B paths | Which source invokes it in each playable context; earlier gates |
| Direct death-state request | Sharkagator `16AFD4 -> 31B64(29)` | Pursuit/attack admission and actual death completion |
| Direct HP writer plus downstream death state | Grind `4C2C0`, `4E008` | Minimum HP value, configuration, cooldown cadence and state eligibility |
| Controller/vehicle terminal state | Arena vehicle receivers, Giant Clank local HP | Controller reset and UI/HP synchronization; see CLANK_MINIGAMES |
| Scene script/volume/unknown class | TriggerLink and unbound hazard leads | Exact class/caller/scene binding; no universal result assumed |

For each mechanism Claude should record A0/B/C from a reproducible initial state:
module/hash/base, plugin/patch guards, difficulty, rank/mod/armor, source and
recipient identity, HP/state/suppression before and after, query/delivery/accepted
counts, event timestamps, child lifetimes, rewards and checkpoint result.
Repeat with full/low HP, suppression active/inactive, armor/proxy active/inactive
where relevant. For recurring damage, compare accepted HP per second and total
HP per action, not only particle count or one callback's scalar. For semantic
events, compare state transition, transformation/child count, cleanup and reward.

No new experimental patch is promoted by this atlas. Static equality, a valid
write, native-worker agreement and a plausible duration do not establish A0/C
gameplay parity. The result is a detailed causal map and precise measurement
agenda for the owner's Priority 0, with all unresolved routes retained.
