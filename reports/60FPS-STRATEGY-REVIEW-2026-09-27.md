# 60 FPS strategy review — 2026-09-27

UCES00420 / Priority0. Starting HEAD d81f682832adbfeea96a8909f6ac1dd1c30f9227.
Parent synthesis, bounded Luna lookups, reviewed external skeptic, and one new
deterministic address intersection. No live PPSSPP access or gameplay change.
Existing controller work was preserved; during this audit it was committed
separately in9c5feff/126da25. A0=original30, B0=uncorrected60,
C1=experimental core, D0=C1 plus selected temporal overrides.

## Decision and owner direction

**Build a broad inferred experimental profile first; test it through reversible
A0/patch gameplay; use measured local exceptions to improve it.**

The owner explicitly clarified that the project should infer corrections from
existing engine timing and the former PRX, then try the widest useful candidate.
Per-class proof is not a prerequisite for an experimental trial. Proof remains
required before claiming validation or release parity. The initial audit draft's
core-acceptance-first sequence is superseded by this direction.

Next deliverable: **D1, a timing-only experimental global profile**, reusing the
legacy dispatcher/profile tables where applicable, with an A0/C1/D1 switch and a
small gameplay observation panel. D1 is a design target here, not a built patch.
Test a second level early. Preserve C1 as a comparison arm and D0/local work as
reusable overrides; do not discard history or silently import optional features.

The important correction to our reasoning is this: **different timing channels
rule out an indiscriminate scalar, not a global scheduling correction.** Treating
every possible regression as a prerequisite investigation has pushed the work
toward a class-by-class campaign. That is neither required for prototyping nor
what the owner wants.

## What is established, and what is not

| Existing result | What it buys | Limit |
| --- | --- | --- |
| Help A0/C1/D0/remove/reapply rates about 1/2/1/2/1 | TESTED same-instance reversible timer correction,600 samples | Long reminder event and broad timer parity UNKNOWN |
| Acidbomb delta countdown about1/1; fixed velocity decrement about1/2 | TESTED mixed domains inside one callback; a shared policy needs units and dispatch | Initial aim differed; trajectory/contact/damage parity UNKNOWN |
| Flamethrower phase about60/s in both arms | TESTED useful preserved-channel control | Does not settle active damage/ammo; owner's Mungo DPS observation remains unresolved |
| Pokitaru elevator10.01s ->5.00s under C1 | TESTED visible fixed-step gameplay defect | Not a verdict on all fixed-step code |
| Kalidon half-step companion | TESTED bounded work beyond Pokitaru; matching sampled endpoints and owner-observed smoother comparable motion | Direction1 is1.76% slower; compound legacy profile, not isolated core-only correction |
| Waterfall/Butterfly local output corrections | Measured rate/recurrence fixes and useful negative findings | Entire effect/steering/gameplay parity UNKNOWN |
| Same93 callbacks in bounded A0/C1 free play | Real execution shortlist | Not93 validated mechanics, matched input or full lifecycles |

Sources: [D0](../research/live-tests/pokitaru/d0-001-20260927/REPORT.md),
[Acidbomb](../research/live-tests/pokitaru/atlas-probes-001/acidbomb-REPORT.md),
[Flamethrower](../research/live-tests/pokitaru/atlas-probes-001/flamethrower-REPORT.md),
[Kalidon](../research/live-tests/kalidon/lvl3elevator-A0-PRX-visual-comparison-REPORT.md),
[free play](../research/live-tests/pokitaru/freeplay-001-20260927/REPORT.md),
[Waterfall](../research/live-tests/pokitaru/waterfall-007-mist-visual-20260926/REPORT.md),
[Butterfly](../research/live-tests/pokitaru/waterfall-008-prx-butterfly-20260926/REPORT.md).
The evidence index links the Pokitaru elevator probe.

Thus the work is not all cosmetic and not confined to one level. Nevertheless,
we have accumulated more evidence about isolated rates than completed gameplay
contracts. A weapon contract includes shots/ammo/contact/HP; a projectile includes
spawn/trajectory/lifetime/impact; a platform includes travel/endpoint/rider behavior.
These should guide observation during D1 play, not become a prerequisite census.

## Concrete wasted-motion risks identified

- Accessible visual fields and long-lived Help objects have attracted effort while
  combat/physics remain open. Their evidence is valuable; further polish should
  wait unless it blocks play or exposes a shared regression. No time/cost ledger
  exists, so this is a qualitative prioritization judgment.
- The checkpoint still asked to find EnemyWave's state1 writer after the newer
  [RESPAWN follow-up](../research/live-tests/pokitaru/d0-001-20260927/RESPAWN.md)
  had identified helper137AA0. The owner-confirmed A0 passage showed sampled0->3
  transitions with zero timers/ranges, outside the fixed-countdown target. C1
  activity was not bound to the capture window. More blind combat/reloads would
  not answer the intended question. State1 live countdown remains UNKNOWN.
- Old next steps can outlive completed work. Some prior recommendations predate
  the dispatcher map, Kalidon test and LaserTracer decimation failure. We corrected
  the current checkpoint and narrowed the queue; no orchestration redesign is needed.
- C1 has become a working foundation without full core/gameplay acceptance. Keep
  this visible and compare it to D1, rather than declaring it wrong or refusing to
  experiment until every behavior is proved.

## WF reuse and the former global PRX

The corpus contains59 WF families,267 members and493 callsites. These are useful
static wrapper/owner/callsite groups, not59 demonstrated gameplay corrections.
Plugin-injected wrapper bodies are absent from vanilla images.

Do not conflate three different structures: the WF wrapper grouping; the player's
two-iteration substep loop; and the separate group pump/player wrapper/nested
second pump in the main update region. The [core map](../research/v2/pokitaru/player-clock-socle-map.md)
pins the loop/scalar. The [dispatcher review](AGENT-SESSION-2026-09-23/DISPATCHER-OFFLINE-REVIEW.md)
reuses418 saved stops and finds pump motifs in20 level images. The21-module core
signature result has a different denominator; neither implies runtime parity.

**New OBSERVED deterministic overlap:** join the accepted93 LEVEL_01 callback
RVAs (A0epoch9/C1epoch11) to exact family-member entry RVAs. LEVEL_01 has27 member
rows and55 family-callsite rows. Eight callbacks match eight WF entries:

| Callback alias | RVA | Family |
| --- | --- | --- |
| Butterfly |0x122820|WF-051|
| CrankedObject |0x128C20|WF-031|
| HutDoor |0x143FEC|WF-016|
| Level01Boat |0x14EB68|WF-036|
| Level01DoorTarget |0x15083C|WF-046|
| SharkagatorFin |0x16B830|WF-027|
| TMRobotHeadB |0x17D49C|WF-030|
| TriggeredDoor |0x187614|WF-019|

This is static address overlap, not wrapper execution or eight defects. Aliases
retain their source uncertainty, especially TMRobotHeadB. No entry match does
not exclude indirect/interior links; WF-002/WF-058 cannot be declared absent from
the call graph. Use these entries as D1 observation/exception leads, not a new
mandatory eight-experiment campaign.

The [legacy companion audit](LEGACY-COMPANION-PRX-AUDIT-2026-09-23.md) identifies an
actual centralized C dispatcher, selectable global_60fps mode, module resolution,
relocated guards, installation/readback and rollback. It contains **15 compiled
profiles: LEVEL_01-10,15,21-24**, with the493 callsites. These are existing profiles,
not15 validated levels. FRONTEND and LEVEL_16-20 lack that compiled coverage.
**Source follow-up corrects the report-only reading:** the legacy runtime DOES
implement `default_policy=one_pass|two_pass|vanilla|custom`, family override lists
(`one_pass_families`, `two_pass_families`, `custom_families`) and exact return-address
overrides. Selection is **default -> WF family -> exact return address**. This is
the broad-policy/local-exception architecture requested by the owner. It selects
configured policies; it does not infer their semantic correctness. `custom`
currently falls back to two-pass, not an arbitrary custom gameplay fix.

The source hard-disables modules15 and21 because of an archived crash report:
15 compiled profiles do not imply15 activatable profiles;13 remain potentially
eligible before other guards. Preserve those exclusions. `allowed_module` bounds
a trial; `policy_module` requires that bound. `full_layers` accepts an odd mask
limited to15. This runtime file cannot establish whether the assembly layers
include optional camera/gameplay changes. `controls_enabled` only handles plugin
export/reset buttons. Layer contents need a bounded source extraction, not a new
gameplay-validation campaign.

Exact inspected read-only source:
`C:/Users/linki/Documents/PPSSPP/Overcompensated-Reprise-2026-09-14/development-v0.6.4-no-menu/sources/profiler/src/psp_plugin_runtime.c`.
Parsing/selection lines392-426,557-602,653-655,1166-1183; custom fallback1238-1244;
exclusions1350-1361; global installation1392-1460. Luna inspected these sections.
SHA256 `e6ebc8af1eae253af9721a4a61b8dffc8888d3258330c44f236cf451cd535b5f`.
The earlier report-only statement that family selectors were not demonstrated is
SUPERSEDED by this source lookup.

## Candidate strategy: infer broadly, then expose exceptions

**Preferred implementation starting point, INFERRED:** extract the timing-only
scope of the existing global arm into an explicit D1 manifest. Reuse
its dispatcher and guards with the current reversible-control approach. Preserve
known correct channels and explicit regression exclusions. Do not enable an
archive binary wholesale or assume its optional features are Priority0 timing.

Every imported rule should record module, before/after instruction, route/policy,
source provenance, assumed units and status INFERRED or previously TESTED in a
stated scope. This is sufficient for a reversible trial; every rule does not
need a new live study first. Unknown individual arithmetic can remain unchanged
while the shared core/route candidate is tested.

| Inferred timing type | Initial broad policy | Observe while playing |
| --- | --- | --- |
| Seconds via explicit delta | Use delta corresponding to actual domain cadence; preserve already-correct channels | Countdown/lifetime/reset |
| Fixed work per outer frame | Restore its domain rate, or scale its increment if execution must remain60Hz | Travel, rotation, timer and event rate |
| Duration stored as frame count | Rescale the count only if its decrement cadence changed | Expiration and boundary behavior |
| Twice-per30Hz substep work | One-per60Hz can preserve count; avoid a second blanket half | Weapon/phase and gameplay outcomes |
| First-substep/event-gated work | Preserve intended eligibility/real-time event rate separately | Firing, consumption and triggers |
| Mixed integration/damping/rendering | Start from the domain hypothesis; add local overrides when units or side effects require them | Trajectory/contact and smoothness |
| Quantized/random work | Preserve original recurrence/probability over real time, with phase/distribution limits explicit | Alpha, lifetime, spawning and event distributions |

This is a policy map, not a ready-made global constant replacement.

**Strong global hypothesis worth trying, INFERRED:** restore the original mixture
of approximately30Hz outer logic, approximately60Hz player/substep work and60Hz
presentation. It may correct several fixed/quantized channels together. It is not
equivalent to throttling the whole game. A30Hz-gated delta consumer needs its
appropriate1/30 input: gating C1's Acidbomb at30Hz while keeping1/60 halves its
already-correct countdown. Scheduling and delivered time must change coherently.

The external skeptic suggested a single outer gate with unchanged arithmetic;
that exact proposal is incomplete for this reason. The shared-domain hypothesis
remains valuable. Investigate the existing call boundary while preparing D1;
if it cleanly separates logic from presentation, make it the next broad variant.
If it does not, use the existing wrapper/profile mechanism and local exclusions,
without launching an engine rewrite. LaserTracer's known judder rejects its old
whole-callback decimation, not every possible domain-level design.

Why units matter: in the illustrative recurrence v+=a; x+=v, where v is displacement
per update, doubling updates suggests half initial v and quarter per-update a,
not halving all constants. Even that does not preserve every discrete collision
or endpoint. Physical velocity integrated with delta has a different rule.
Multiplicative damping needs a root-like transformation rather than half its
coefficient; clipping/rounding may invalidate that approximation. These models
justify targeted exceptions after a broad trial, not months of preflight theory.

## Fast experimental loop

1. **Build one concrete D1 profile from the existing timing machinery.** Separate
   original A0, current C1 and D1 recipe manifests. Exclude known optional features
   and conflicting companion ownership. Do mechanical checks on guards, branch/
   delay-slot effects, relocation, apply/readback/remove and original restoration.
   Do not make complete gameplay parity a condition for the first experimental boot.
2. **Use the owner's A0/D1 switch during ordinary play.** Start/stop observation
   when the owner actually plays. Show the exact active profile/module. Capture
   short windows around reported differences with existing tools; label inactive,
   paused or ineligible windows. Do not demand identical whole-level routes.
3. **Keep a few sentinel outcomes.** Player movement/jump/contact; one weapon's
   active ammo/HP behavior; one object/elevator; Acidbomb delta and Flamethrower
   phase as known controls. The observed WF matches give additional leads when
   encountered. No requirement to bind six channels simultaneously before trial.
4. **Classify each discrepancy:** shared timing policy, local exception, input/
   initialization difference, or measurement artifact. Use B0 only where needed
   to distinguish unlock effects from C1/D1 compensation. Existing B0 measurements
   are not missing globally; many later channels lack matched B0 attribution.
5. **Transfer early to Kalidon.** Reuse the existing elevator observations and
   one shared gameplay control. Try both directions and transitions. Add an explicit
   exception if a recipe differs; do not redo all Pokitaru cosmetics first.

Hot switching swaps code, not history: it cannot undo spent ammo, completed waves,
accumulated timers or spawn-derived coefficients. For those cases wait for a new
natural object/event or use a normal save as needed; reserve reloads for actual
state dependence. At audit close, [hot-switch acceptance](../research/live-tests/pokitaru/d0-switch/REPORT.md)
records two live A0->D0-help->A0 cycles; [usage](../tools/runtime/D0-SWITCH.md) is
available. Reuse it and review D1 integration, rather than rebuild the controller.
D0 currently means C1+Help only. Do not manufacture state to expose a chosen rule.

A visible regression is useful prototype feedback. Restore the affected rule or
profile, record a reproducible example and keep moving; do not interpret it as
proof that all global approaches fail. Stop a trial on crash, lost module/guard
identity, broken restoration or inability to know which profile is active. For
semantic uncertainty alone, retain INFERRED/UNKNOWN and continue bounded tests.

No universal numerical tolerance is adopted. Owner-visible screening can identify
candidates; scoped measurement supports acceptance. The Kalidon1.76% observation
is not a game-wide allowance or reason to rebalance.

## Likely hard parts and deliberate deferrals

- Mixed logic/render callbacks can cause30Hz motion/animation when throttled;
  presentation exceptions or interpolation may be necessary.
- Collision/contact order, nonlinear integration and input/animation events may
  differ even when counts and average rates agree.
- Damage, ammunition and random event probability require active-event evidence;
  an invariant phase or time-to-kill alone can hide another changed variable.
- Module variants, FRONTEND/special modes and LEVEL_16-20's already-one-pass loop
  prevent copying LEVEL_01 recipes indiscriminately.
- Object recycling, initialization, save transitions, unload/reload and competing
  plugins affect reversible switching. Source-cache changes are unnecessary.
- Polling/stride aliasing, CPU pauses and observer overhead can imitate game defects.

These are exception categories and release risks, not reasons to postpone D1.
Defer further waterfall polish, Butterfly steering and long Help recurrence unless
they block play or reveal shared regressions. Stop blind EnemyWave trials and new
broad inventories. Measure progress by a playable global candidate, useful module
transfers, fixed regressions and explicit exceptions, not document/rule counts.

## New method, review provenance and next action

Reproducer: [measure-wf-callback-overlap.ps1](../research/scripts/measure-wf-callback-overlap.ps1).
Run pwsh -NoProfile -File research/scripts/measure-wf-callback-overlap.ps1.
Generated JSON stays local at research/v2/strategy-audit-20260927/wf-overlap.json.
Decimal JSON and hex CSV RVAs are normalized; epochs, module and93 unique callbacks
are asserted. Names are never join keys. First run stopped on decimal input; the
corrected method completed. Do not edit generated evidence manually.

SHA256:
- Coverage:850ac28535aca100abf3aa26c75adcd4f7433437f8f264a563bc5246edc28837
- Index:a326c66c68caf954e6360545d2c76593e122b03c514f6f60be1a2db93d5715af
- Method:788ecb1258cccc6c001e3f0cfbb82e97f2dab126e3a1cf8996c6ffdc09380f00
- Output:79b12def44ce8eef41ad3f8f7cfa13ed1a3d04e0ec4361d45b1bb6e68038ee72

Luna performed bounded WF/reuse/source lookups. DeepSeek mission audit-001 failed
before analysis; after explicit owner authorization,60fps-strategy-audit-001-r2
completed. Parent read PARENT_HANDOFF first and reviewed the disputed sections.
Accepted: mixed-cadence alternative, compound Kalidon arm and exposure cautions.
Qualified/rejected: globally absent B0, visual evidence being only subjective,
and an unchanged-delta outer gate preserving Acidbomb. Model agreement adds no
experimental validation. Detailed arbitration stays with the raw local mission.

Exact next action: [global candidate rollout task](../research/tasks/global-candidate-rollout-001.md).
Build the timing-only D1 manifest from the existing global profiles and review the
existing switch controller, then produce the first reversible experimental build.
Do not resume the previous EnemyWave eligibility hunt as the main task.
