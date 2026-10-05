---
kind: register
title: "Damage atlas coverage, unresolved contracts and publication allowlist"
date: 2026-10-06
authors: ["GPT (Codex)"]
status: complete
evidence: [OBSERVED, INFERRED, REJECTED, SUPERSEDED, UNKNOWN]
summary: "Enumerated inventory/receiver/domain coverage with exact unresolved targets; authored findings are published without raw game evidence."
systems: [weapons, damage, hazards, armor, Clank, minigames, publication]
levels: [all]
related: [research/v2/damage-atlas-20261006/REPORT.md, research/v2/damage-atlas-20261006/WEAPONS.md, research/v2/damage-atlas-20261006/CLANK_MINIGAMES.md]
---

# Coverage boundary

"Complete" is the status of this integrated static dossier, not evidence that
every gameplay mechanic is validated. All 25 inventory entries are accounted for
as combat families, active gadgets, passive equipment or sentinel. All 19 non-null
LEVEL01 registered receiver rows are accounted for. Other levels' indirect
receivers, scene configurations, bosses and controller consequences remain
explicit gaps. Coverage is categorical, not a fabricated percentage of the game.

| Domain | Positive closure | Remaining boundary |
| --- | --- | --- |
| Inventory 0..24 | Rank legality, mods and each family's investigated source/child paths | Retail evolution/mod labels, owner-variant runtime binding |
| Common delivery | Selected-target, zero-scalar hit query, 16-target area delivery and table writer | ABI/instrumentation, overlap/query saturation, actual accepted counts |
| Ratchet | Ordered gates, armor, HP, suppression, type10 terminal route | Active group label, difficulty/source bindings, actual boundary timing |
| Armor 0..13 | Equipment reduction and offense/passive contracts | Child effects' damage completeness, passive callback cadence, combined DPS |
| LEVEL01 registered receivers | All 19 class rows, including shared/no-op/semantic receivers | Other modules and group callbacks not represented by this table |
| Environment | Surface classes, Fire, grind collision, Sharkagator, death/recovery clocks | Scene bindings, scripts, pits/lava/crushing/electric objects, upstream attack gates |
| On-foot Clank | Active forwarding and wrapper-return semantics | Constructor/form/state21 binding |
| Small Clank bots | Scalar-independent state17 transition | State17 lifecycle, controller/ports/houses and follower consequences |
| Derby torsos | Direct HP, interceptors, local cooldown and death/wreck branches | Takeover/armor participation, exact per-module cadence |
| Bot flinger | Magnitude conversion, state/cooldown and return0 | `19AE0C` health versus reaction consequence |
| Vehicle ordnance | Mine event, missile impact/timeout and lifetime | `193A84/1932E4` scalar/radius/ownership |
| Microbot | Survival controller boundary and toss fuse/blink | Full SurvivalBot/result helpers; toss explosion/failure |
| LEVEL10 Giant Clank | Local/mirrored HP, no rejecting +38 timer, rocket direct tuple/expiry | Launch/flight/filtering and measured DPS |
| LEVEL15/21 GCS | Controller root/resource/cap/state request and firing/path/effect clocks | Resource loss writers, virtual state3 meaning, collision/projectile payload |
| LEVEL22/23 Skyboard | Mine slowdown/knockback/recovery and model boundary | Consequence helpers, sentry, rider/crash/out-of-bounds |
| MP16..20 | Distinct native targets and one-substep original loop | Receiver/authority/team/turret/score/respawn/instant-kill semantics |

# Changed, rejected and superseded interpretations

- **REJECTED:** `4C2C0` as Clank oxygen/minigame drain. Direct callers bind it
  to grind world/rail collision; retain direct HP and downstream state death.
- **REJECTED:** universal receiver return-code semantics. Flinger/Luna accept
  effects with 0; Clank wrapper returns 2 regardless of nested result;
  BreakableObject can return 3 without deleting the excluded source case.
- **REJECTED:** zero scalar implies no damage consequence. Crates and semantic
  type10 transformations/destruction are counterexamples.
- **REJECTED:** Giant Clank +38 is a receiver invulnerability timer. Its positive
  value does not prevent subtraction in the reviewed receiver.
- **REJECTED:** empty class update/receiver implies no update or no harm.
  Model/controller ownership is positive evidence in several forms.
- **SUPERSEDED, claim-level:** old saved-image zero damage rows as evidence of
  missing weapon damage. Existing `100EEC` initializer and this worker's
  float32 reconstruction identify live positive rows and intentional semantic
  zero rows. Historical reports are preserved, not rewritten wholesale.
- **UNKNOWN:** GCS resource +2C as literal HP and state3 as death. Depletion
  and replenishment are observed; labels require loss writers/state handlers.
- **UNKNOWN:** a module wrapper's masked EXACT match with zero agreeing callees
  as inherited receiver behavior. MP native calls demonstrate why it fails.
- **UNKNOWN:** the Bee initializer's id4 queries for mods0D/0E as an intended
  Bee binding; preserve the contradiction instead of silently correcting code.

# Exact prioritized next static action

First close **LEVEL15 GCS resource-loss and terminal state**: resolve the four
virtual tables constructed by `109F08`, using native relocation records; identify
their enter/update callbacks, writers to root `3FC2B8 +2C`, and state3 behavior.
Use known entry evidence. Reuse a suitable existing LEVEL15/21 Ghidra program if
the owner supplies it; otherwise the saved-program absence is a precise blocker
for decompilation, not for a bounded native query. No new matching or global census.

Subsequent independent targets, in order of unresolved consequence:

| Module / entry | Question |
| --- | --- |
| 04 `19AE0C` | Flinger converted magnitude: reaction quantity or HP/event consequence? |
| 04 `193A84`, `1932E4` | Mine/missile payload, area filtering and ownership |
| 04 `15DCE0`, `15DD8C` | Toss expiry/explosion/failure |
| 04 `15B324`, `15B4E8`, `18251C`, full `182AA0` | Survival result/contact; repair truncated evidence by bounded export |
| 15/21 `108AE0` | Registered event7 consequence |
| 22 `4710C`, `47144`, `EBAE4`, `EC148` | Slowdown/knockback/crash and age producer |
| 23 `10FE88` | Sentry contact outcome |
| 16 `318B8`, `1447D8`, then `145704`, `149264` | MP authoritative receiver/turret damage |
| 01 `16B0E0`, caller of Sharkagator state1 | Upstream instant-death attack eligibility |
| 01 `2B0A1C` clean scalar and grind configuration | Direct drain floor versus lethal state admission |
| Campaign scene hazard/controller bindings | Scripted instant death, crushing, pits, electric/lava volumes; no bulk raw publication |

No live experiment, validated patch or optional balancing is authorized by
these hypotheses. Claude's reproducible A0/B/C protocols are in the main report
and CLANK_MINIGAMES. Weapon measurements are in WEAPONS. Critical common-player
180 suppression stays unchanged; objects/children/controllers keep separate
timing ownership until measured.

# Reproduction and authored publication

Generate `coverage.json` and `provenance.json` with
`research/scripts/build-damage-atlas.py`; verify local slice with `--verify-local`.
Run report front-matter validation, whitespace review and the publication checker
on the actual staged main allowlist. Generated JSON is authored contract
metadata and file hashes, not a copied game table or list of opcodes.

The owner's2026-10-06 request explicitly authorizes Git/GitHub publication of
these new findings. Publication-policy research-tree warnings are resolved by
this scoped decision: publish exactly the following project-authored files,
after review. No old research history is copied wholesale.

```text
research/v2/damage-atlas-20261006/REPORT.md
research/v2/damage-atlas-20261006/WEAPONS.md
research/v2/damage-atlas-20261006/CLANK_MINIGAMES.md
research/v2/damage-atlas-20261006/COVERAGE.md
research/v2/damage-atlas-20261006/METHOD.md
research/v2/damage-atlas-20261006/coverage.json
research/v2/damage-atlas-20261006/provenance.json
research/scripts/build-damage-atlas.py
research/scripts/ghidra/ExportDamageSlice.java
research/scripts/ghidra/recipes/damage-atlas-level01-001.json
research/scripts/ghidra/recipes/damage-atlas-level04-001.json
research/scripts/ghidra/recipes/damage-atlas-level15-001.json
research/tasks/gpt-damage-atlas-20261006.md
```

Local CURRENT_STATE, evidence-index and GOTCHAS updates remain on v2-research;
public readers have a self-contained dossier. Raw C/instruction exports, modules,
captures, trial words, inventories of game-derived addresses and worker scratch
outputs remain ignored/local. Only main is pushed; local logical commits retain
the research checkpoint. No raw assets or experimental patch payloads belong in
this authored allowlist.
