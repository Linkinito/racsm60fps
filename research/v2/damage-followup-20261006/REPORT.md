---
kind: static
title: "Damage atlas continuation: causal closures across weapons, hazards and minigames"
date: 2026-10-06
authors: ["GPT (Codex)", "Codex read-only workers weapon_damage and clank_minigames"]
status: complete
evidence: [OBSERVED, CORROBORATED, INFERRED, UNKNOWN, TESTED]
summary: "Deepened the prior damage atlas with distinct health, semantic death, displacement and minigame-resolution contracts; exhaustive scene coverage and live parity remain open."
systems: [weapons, damage, health, death, hazards, Clank, GCS, Microbot, arena, Skyboard, multiplayer]
levels: [LEVEL_01, LEVEL_04, LEVEL_15, LEVEL_16, LEVEL_22, LEVEL_24]
variants: [A0, B, C]
environment: "Clean static evidence, two read-only workers and bounded native reproduction; no runtime test or patch"
related: [research/v2/damage-atlas-20261006/REPORT.md, research/v2/damage-followup-20261006/METHOD.md, research/tasks/gpt-damage-atlas-followup-20261006.md]
---

# Outcome and reading route

This continuation closes several major transitive gaps from the original
[damage atlas](../damage-atlas-20261006/REPORT.md). It preserves its full25-id
weapon inventory, armor contracts and19 registered LEVEL01 receiver rows,
then follows previously unclosed child actors and specialized controllers.
It does not replace or cosmetically rewrite the earlier evidence.

Damage is not one universal scalar path. Distinguish four consequences:

1. **HP subtraction:** ordinary player/enemy receivers, GCS controller loss,
   arena area recipients and MP turret/player branches have different gates.
2. **Semantic terminal/state request:** Sharkagator, grind/duration branches,
   MP turret pilot death and decoy receivers can act without subtracting the
   target's ordinary HP. Zero scalar is not a universal no-effect event.
3. **Movement/control consequence:** Skyboard multipliers/position impulses and
   flinger interface forwarding can change gameplay before any HP/death route.
4. **Minigame resolution:** Survival Port quotas and resolved-bot accounting
   separate successful arrival, deletion and bridge conversion from player HP.

Each report records exact gates, field/writer roles, clocks, source identity,
uncertainty, and minimal falsifiable A0/B/C measurements. Static closure is not
live gameplay parity, measured DPS or an accepted60FPS correction.

| Detailed report | Main new closure | Important limit |
|---|---|---|
|[GCS](GCS.md)|literal health/mirror/healing, collision loss, protection, refill and terminal state3|global mode8 visible outcome and cadence|
|[GCS sources](GCS_SOURCES.md)|six bridge call sites and five bounded producer families|retail names, scene payload selection and callback cadence|
|[Weapon children](WEAPON_CHILDREN.md)|ElectroBall shared arcs, paired Shield decoys, native MiniTurret chain|effective/available MiniTurret damage; indirect targeting|
|[Hazards](HAZARDS.md)|Shark exposure, canonical grind floor, same-state duration terminal requests|scene material/volume bindings|
|[Arena/Microbot](ARENA_MICROBOT.md)|Toss/Mine payloads, full SurvivalBot/destructor chain, flinger forwarding|outer Survival result and occupant callback|
|[Skyboard](SKYBOARD.md)|mine transient multiplier, two-use position impulse and age increment|crash/death/out-of-bounds/result consumers|
|[Multiplayer](MULTIPLAYER.md)|local/remote and pair gates, packets, staged respawn, turret/pilot outcomes|network authority, outcome scheduler and other MP modules|
|[Method](METHOD.md)|bounded windows, source preservation, hash-only regeneration|no raw publication or parity promotion|

# High-impact findings

GCS controller float2C is now CORROBORATED as health: initialization100,
admitted subtraction/floor0, capped healing and ceiling mirror into player964.
Protection138 affects damage admission and firing but uses its own decrement;
world collision has independent158 cooldown30/scalar10. Health depletion
requests state3 before the refill contribution. State3 ultimately requests
global mode8 after57 updates. Menu/reset duration units and physical timing
remain unmeasured. A displayed integer can hide fractional health changes.

Shock mod13 ElectroBall caches rowrank+65 and shares an eight-entry arc pool
with its parent. Existing parent arcs, decorative entries and other balls can
suppress same-target hits or exhaust slots. Query precedes15-update arc cleanup,
so isolated recurrence can differ from a naive per-frame damage loop. Shield
mod11 decoys have900-call life and separate fade; eligible source category1/9
can return3 with scalar0 without HP subtraction. Decoy owner proximity has an
unclosed targeting-registration consumer.

MiniTurret's Ball->Turret->Rocket/Manager chain is positively identified in
LEVEL24. The original non-evolved targeted firing route is a return-zero stub.
The alternate rocket caches a float but its reviewed update never reads that
field or sends an ordinary damage packet. Collision/model events, initialization
and legal rank availability remain open; this is not proof of harmlessness.
Its initially-ten field is not a proven ten-shot limit.

Sharkagator attack admission requires E8, state1B and absence of exclusion
trigger overlap. Exposure threshold2.5 receives incomingf12; it can continue
growing during certain ineligible periods and reset only on a specific flag.
After attack animation time>0.1 it requests player29 without local armor/HP
subtraction. Grind has canonical-only directHP/floor0 plus enabled height/state
deaths. A1C is now a same-state duration counter, incremented in the player
substep; selected branches request2D above240. Do not double-correct that clock.

Toss scalar1/radius2 and VehicleMine scalar2/radius1.5 use shared roster-based
area dispatch, **horizontal geometry without local Y/LOS gating**. The helper
reports geometric admission and discards receiver acceptance. Toss excludes its
saved source pointer; Mine's temporary owner-trigger guard does not exclude its
owner from explosion. Mine's900/60 clocks are physics-interface calls.

SurvivalBot's full1701-instruction native update plus destructor closes missed
resolution paths. Ports retain remaining quotas; controller4E counts resolved
robots. Bridge conversion notifies early and sets92 so eventual cleanup cannot
double-count. Exit/removal notify through destructor. Win/fail labels remain
INFERRED until the outer consumer is bound. Flinger forwards a vector through
occupant callback4, so its registered receiver is not a closed ordinaryHP route.

Skyboard setters refresh multiplier/count2 and vector/count2; the movement
consumer scales displacement and directly adds position offsets. Age increases
fixed1/30 per eligibleEC148 call. Legacy constant coordinates24E17C/184 were
corrected by native relocations to23E17C=0.6 and23E184=3.0. No HP subtraction
occurs in the reviewed setter/movement/effect bodies, but indirect falls/crashes
remain possible hypotheses requiring their own consumers.

MP common receiver, network wrapper and turret have separate contracts.
Local/remote forwarding, whitelist, pair filters and staging can hide admitted
HP loss behind outer return2. Respawn preparation can set100HP while preserving
death state. Turret destruction can request pilot29 without touching pilotHP.
The reviewed damage notification lacks attack type/reaction/position/direction;
do not infer receiver authority from that outgoing format alone.

# Changes to earlier hypotheses

| Earlier uncertainty/tempting interpretation | Current scoped conclusion |
|---|---|
|GCS2C only a resource-like meter|health CORROBORATED by independent mirror/loss/healing|
|GCS state3 guessed from zero meter|resolved enter/update/effect sequence and mode8 request; visible retry/death label still INFERRED|
|anonymous Shock/Shield child|ElectroBall /RatchetDecoyInner+Outer identities CORROBORATED|
|MiniTurret unknown child or ten-shot count|native class chain closed; stub present; counter/decrement/damage UNKNOWN|
|leaving Shark condition resets exposure|REJECTED as universal rule: retained/mutating accumulator branch exists|
|grind minimum unresolved/generic eligibility|clean floor0; canonical-pointer equality; runtime settings remain bounded|
|A1C fall/depth distance|SUPERSEDED: same-state update counter; retail state meanings open|
|193A84 Mine payload|SUPERSEDED: roster removal; interface1968A0 dispatches payload|
|Survival resolution equals successful exits|REJECTED: destructor/bridge paths also notify|
|state17 robot corpse|REJECTED: positive SurvivalBridge creation/backlink|
|flingerF4 ordinaryHP|UNKNOWN; recoil countdown/interface forwarding positively observed|
|Skyboard24E constants|SUPERSEDED in clean22 by native23E coordinates|
|MP return2 or stagedHP100 proves survival|REJECTED as universal inference: wrapper/staging paths conceal state/admission|

# Coverage and exact next questions

The requested whole-game exhaustive analysis is **not yet complete**. This
session closes selected causal slices in six modules, not all scenes, bosses,
resident code, assets or indirect callbacks. Counts of inventory/registrations/
windows must not become a whole-game completeness percentage.

Highest-value remaining static work:

1. Bind Survival outer result/UI consumer and flinger's actual occupant callback;
   close GCS global mode8 consumer and scene source-config bindings.
2. Resolve MiniTurret2A1F00/pvar1C writers, legal availability and collision/
   model-event consequences; decoy spatial-registration consumer.
3. Trace named campaign pit/lava/crushing/electric/script volumes from exact
   class/scene bindings; do not infer a hazard from a string/name alone.
4. Close Skyboard crash/out-of-bounds/respawn/race result and sentry routes.
5. Close MP receiving handlers, role/setting bindings, respawn scheduler,
   sampling2B672C initializer execution/overrides and other MP-module equivalence.
6. Follow remaining weapon/environment/armor/indirect receiver gaps retained in
   the original COVERAGE.md; ordinary bosses and scene-authored objects require
   their own exact module/class question.

Claude's first live pass should measure one controlled instance per contract:
attack/source/target identity, packet scalar/type/reaction, admission flags,
HP/current/pending state, callback ordinal, simulation gate, elapsed time and
result/reward. Compare A0(original30),B(uncorrected60),C(candidate60) from the
same reproducible setup. Do not combine unvalidated timing changes across
distinct domains. Every detail report contains a smaller domain-specific agenda.

# Publication

Only authored reports, recipes, inspector/provenance reducer and required
project-authored helper sources are selected for public main. The exact
publication register is PUBLICATION.md. All source modules, existing C,
instructions, raw tables/manifests, schemas/captures and earlier adaptive output
remain local. v2-research is never bulk-pushed. No new patch or live acceptance.
