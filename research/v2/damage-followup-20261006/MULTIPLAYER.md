---
kind: static
title: "Multiplayer damage: admission, network events, death staging and turret combat"
date: 2026-10-06
authors: ["GPT (Codex)", "Codex read-only worker clank_minigames"]
status: complete
evidence: [OBSERVED, CORROBORATED, INFERRED, UNKNOWN]
summary: "Closed LEVEL16 player and turret damage consequences; separated receiver results, packet notifications, score bookkeeping and staged respawn."
systems: [multiplayer, damage, death, respawn, turret, networking]
levels: [LEVEL_16]
variants: [A0, B, C]
environment: "Clean native module, existing stored map and bounded read-only worker; no live multiplayer session"
related: [research/v2/damage-atlas-20261006/CLANK_MINIGAMES.md, research/v2/damage-followup-20261006/REPORT.md]
---

# Result and scope

The campaign damage receiver is not the multiplayer contract. LEVEL16 has its
own common player receiver, a local/remote wrapper, pair admission, staging
exclusion, network notifications and score bookkeeping. A wrapper return2 is
not evidence that HP subtraction occurred. A staged player may already have
100HP while retaining a death state. Destruction of a ridden turret requests
its owner's death state without first subtracting the owner's HP.

These are OBSERVED native paths. Team/friendly-fire labels and several network
mode labels remain INFERRED; receiving packet handlers and actual live timing
remain UNKNOWN. No claim is extended to LEVEL17..20 by address similarity or
old matching alone. Original MP main-loop limit1 is distinct from campaign2.

# Provenance and method

Clean source `02-Jeu-et-dumps/Data/BACKUP/BIN/LEVEL_16.PRX`, SHA-256
`7bddff247e89508bd43f27bade4418ba4ecd54ac6837e73b349baf89eb068914`.
The read-only worker verified the source before and after native reads. Existing
map `research/v2/module-bytematch-20261005/_local/matches-LEVEL_16.json`, SHA-256
`807ad32e68fbfab7f56d4fd6758ac05cbec034d58a4d53fb6a5291b1b5181371`, was consumed
without new matching. Native words and PSP relocations, not decompiler argument
guesses, establish the following constants and pointers. Raw listings remain
local. Reproduction windows and method hashes are indexed in METHOD.md.

# 1. Common player receiver318B8

Full reviewed body ends at31FA8; next entry31FAC. Admission is ordered:

1. Require player flags95C bit8000.
2. Reject when player97C is nonzero.
3. Reject current stateF8 in29..32.
4. If mutable interceptorFA4 exists, its result other than1 overrides the route.
5. Call1FE20 (the existing map connects campaign22AD0 with EXACT/two agreeing
   callees). Its complete mode semantics remain outside this receiver closure.
6. If player5CC redirects to an object, dispatch its group receiver20 and
   return1 from the outer common route. The nested result is not propagated.

The direct HP branch subtracts incoming scalar times `(1 - 0)`: its reduction
factor here is a **literal zero**, not the campaign armor lookup. Negative HP
is floored to0. There is no upper max clamp in this branch; a negative incoming
scalar could increase HP, but reachable negative attacks are UNKNOWN.

Surviving damage reloads97C from relocated287540, whose clean file float is
**0.0** (HI/LO31ACC/31AD0, store31B10). That is a scoped file/read observation.
Other writers or initialized values are not closed, so "multiplayer has no
invulnerability anywhere" would be unsupported.

Attack typeA forces HP0 and requests2AD94(player,29), then returns3. It still
passes the preceding gates. Other terminal paths use2B for types3/C and the
pending-state fieldFa for ordinary death, followed by33330 and cleanup1FBAC.
Current state21 uses the100/102 substate handling. Entity flag8 is set.

Surviving reactions remain independent of subtraction: type1 normalizes its
direction; types0/D use impact relative to player position; type2 additionally
sets988; types3/C request reaction state42; type9 requests44 and direction.
Generic positive damage requests14 except special paths. Scalar0 can still
normalize/write96C/970/974 and988 or request states/transitions; surviving
receiver result2 is not a no-effect result.

# 2. Networked Ratchet wrapper1447D8

The wrapper obtains the player from victim moby58->pvar0; NULL returns0.
2A2B4 tests pointer equality with canonical player32C700. 2AB88 considers
states28..33 terminal, and144784 synchronizes entity flag8. A prior-terminal
predicate prevents duplicate death bookkeeping in the reviewed wrapper.

Source compatibility includes group byte4B equal0B/0D, or144B4C accepting
source group30 hash9412C3E8/7C7A2E3F. Actual class labels for the latter hashes
remain UNKNOWN. 144ADC tests a separate whitelist at2B5FA4 containing
056F654E, EF38865E, F8426710, ECFD0651; their names are not inferred from nearby
descriptors.

| Victim/source condition | Reviewed consequence |
|---|---|
| Nonlocal victim | Forward scalar0 to318B8; a compatible local source may emit a damage notification if not whitelisted and pair admission succeeds |
| Local victim, whitelisted source | Immediate return1 |
| Local victim, other compatible source | Pair filter before ordinary forwarding |
| NULL source | Only local victim invokes318B8; outer route then returns1 |

2ABB0 gets source player via source58->pvar0 and compares its F4 with victimF4.
Equal values require F49D8's nonzero byte2A5DE4 and absence of victim in F3358's
four-record staging table31D170 (stride20). Other admitted pairs continue.
The F4/team and byte/friendly-fire interpretation is INFERRED: score aggregation
also indexes F4, but a user-visible setting binding was not read.

The wrapper discards318B8's result. It can flash144A8C for a compatible local
source, independently checks new HP0 versus prior-terminal status, records
attributed F65D4 or unattributed F69B0 death when source differs from victim
moby, sets entity8 and returns3. Otherwise it returns2. Thus packet/flash,
nested admission, HP change and outer return must be recorded separately.

# 3. Outgoing packet formats and score consequences

Primitive append helpers are FA0F0 byte, FA20C little-endian u32 and FA344
float32. EDC8C emits:

| Opcode | Serialized fields in this producer | Downstream producer |
|---|---|---|
|66| victimE8 u32, sourceE8 u32, source group30 hash u32, damage float32 | EDC8C ->ED584 |
|5D| victimE8, attackerE8, source hash | ED694 ->EFD54 |
|6B| victimE8 | ED7C4 ->EFD54 |

The reviewed66 packet does **not** serialize attack type, reaction, impact
position or direction. ED584 sends via FA6F8 argument0 when session2A36C8==2;
otherwise it selects the victim peer among three records31C120 (stride20),
routes its first word and releases throughFA044. ED570 tests the same session
value against1. Host/client naming, authoritative receiver and transport
delivery behavior remain UNKNOWN rather than inferred from one branch.

F65D4 passes source hash toF6620 and by default acts only for a local victim
unless an extra flag changes that condition. It requires both players568 zero.
It writes the4x4 matrix31D794 indexed by F0 and score31D7E4; F69B0 handles
unattributed death at31D7D4. Team-like aggregation F45A0/F45C8 indexes F4 with
stride1C. A different attacker increments score; a self case decrements with
zero floor when mode2A36CC==1 (ED554). Localized messages/source counters and
ED694 notification follow unless the alternate event flag applies. Score/kill
labels are INFERRED from these cooperating paths; mode and568 meanings remain
UNKNOWN. A damage return alone cannot establish a credited kill.

# 4. Death request and staged respawn

2AD94 accepts requested28..33, rejects existing29..32, requires player568 zero
and rejects staging membershipF3358. It sets entity8, pendingFa and invokes
33330. Its table1902D8 resolves death/reaction entries29->343DC,
2A->346A0,2B->349D8,2C/2D->34714,2E->34A48,30->34C48,31->34CD4,32->35254.
The29 entry sets death/hide flags, clearsD90, records position and hides models;
there is no HP subtraction in this state-entry consequence.

F2F4C resets state, sets current/max HP to100, copies spawn transform, rebuilds
collision/model state and marks the matching staging record1D=1. F3528 calls
it, hides models, resets record1D=0 and restores the old death stateF8. This
positively distinguishes initialized respawn HP from active survival.
The actual reviewed F2F4C windows leave gapF31B0..F31D0 (eight instructions).
These positive writes are closed; a newly complete read of that body is not
claimed. Exact reproduction bounds preserve the gap in METHOD.md.

F3358 tests four records; F339C reads recordC or-1; F33E0 clears record pointer,
fields4/8/1D. F33F8 displays integer `(config2A5D08 - record.float8 + 1)` with
localized strings. F35D4 partially closes spawn-candidate distances to other
players. The scheduler advancing record8 and activating/removing staging is
UNKNOWN. No elapsed respawn-duration claim follows from the display formula.

# 5. Turret receiver, pilot death and ammunition

145704 subtracts damage from turret pvar38 and floors at0. No local cooldown,
armor, pair filter or attack-type distinction occurs in this receiver. HP0
calls14691C only when session2A36C8==1; the receiver always returns2. Turret
initial HP is clean float200 at2B61F0 (HI/LO145420/145428).

14691C emits effects, sets turret state45=2 and flags70=0, and disables firing/
ownership. For an owner with positive E8 it calls2AD94(owner,29) and clearsD90,
without subtracting owner HP. Source0B/0D can additionally invoke attributed
F6A54 bookkeeping. This is a distinct potential pilot one-shot state route;
2AD94's existing death/staging/568 guards still apply. Live session outcomes
and whether a visible pilot remains attached at that instant are UNKNOWN.

14838C/1484C8 decrement cooldown pvar20 by incomingf12, floor at0, then require
fire input6000, nonzero ammo30, local owner and additional ownership checks.
Entry148460 loads40 ammunition. Successful148C50->1494C4 creation triggers
effects/network, sets cooldown to clean2B653C=0.5, decrements ammo and alternates
muzzle. Failed creation does not execute the success tail. The incoming-delta
producer, exact firing frequency and remote delivery require live measurement.

# 6. Turret projectile collision

149264 increments age70 by incoming delta and moves direction times speed40
(2B65D8) times delta. Lifetime pvarC is gun config8 divided by40; treating
config8 as range is INFERRED until scene configuration is measured. Expiry
149B78 cleans up without calling the reviewed hit helper. Movement149C88 leads
to149704, which traverses the movement segment, queries up to8 candidates,
samples points, excludes pvar4/8 gun/turret and selects the nearest qualifying
receiver with a vertical offset. It dispatches group receiver20 with:

- scalar25 (clean2B65DC), type1, reaction1;
- impact direction, source TurretShot;
- no projectile-local team gate, leaving receiver admission to the target.

The collision helper returns whether a hit candidate was found and discards
the nested receiver result. Sampling radius/step2B672C is file0; the worker's
14A19C trail use did not bind its writer. A later parent exact PSP field-reference
query positively found initializer **14A9A8**: it loads structure2B66F4's+4
float **1.2**, multiplies literal **0.8** and stores2B672C at14A9D0, approximately
**0.96** after float rounding. R_MIPS32 pointer2BBC10 registers14A9A8; no direct
JAL caller was found in the single-target query. Init dispatch order/runtime
overrides remain UNKNOWN. This closes the writer/value formula, superseding
only that earlier gap; it is not a measured initialized radius or proof all
scenes call it. Both PSP references and body are in the final MP recipe.
Conditional arithmetic predicts8 fully admitted
25-damage hits for a200HP turret, or4 for a100HP player. These are INFERRED
predictions under unchanged scalars, not observed shots-to-kill.

# Measurement agenda and remaining gaps

Claude's minimal live A0/B/C agenda:

1. Record local/remote identity, source group/hash, F4,2A5DE4, staging membership,
   current/pending state, HP/97C, nested return and wrapper return for one hit.
2. Compare the original scalar with remote scalar0 forwarding and packet66;
   observe receiving handler before naming network authority.
3. Separate staged100HP from active respawn, recording table8/1D and scheduler.
4. Test typeA under each preceding admission gate; do not bypass fields to claim
   an ordinary weapon one-shot.
5. Destroy a ridden turret and record turretHP, ownerHP/state and mode branch.
6. Track successful/failed shots, ammo40, incoming delta, cooldown0.5, movement40,
   config8 and actual2B672C initialized value.

Open static gaps: exact source class names; user-facing F4/byte binding; session
and score-mode meanings; packet consumers; player568; respawn scheduler;
2B672C initializer execution/overrides; scene gun range; additional ownership callers; incoming-delta
clock; module17..20 constants and behavior. No new live test, patch or parity
acceptance was performed.
