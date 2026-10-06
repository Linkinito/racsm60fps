---
kind: static
title: "GCS flight attack producers: five storage families and six health-bridge sites"
date: 2026-10-06
authors: ["GPT (Codex)", "Codex read-only worker weapon_damage"]
status: complete
evidence: [OBSERVED, CORROBORATED, INFERRED, UNKNOWN, REJECTED]
summary: "Closed source-side packet offsets, contact/cleanup contracts and beam scalar4/contact reload10; other payload values, labels and live cadence remain unknown."
systems: [GCS, GiantClank, projectiles, beam, damage, collision]
levels: [LEVEL_15]
variants: [A0, B, C]
environment: "Clean original native bodies and PSP references, read-only worker; no live experiment"
related: [research/v2/damage-followup-20261006/GCS.md, research/v2/damage-followup-20261006/METHOD.md]
---

# Result and scope

All six delegated direct10C6EC call sites belong to five bounded producer
families. The beam's raw scalar4, local ten-call contact reload and initialized
reciprocal phase rates are positively closed. Other families expose exact
packet/scalar locations but not authoritative concrete scene configuration.
Some contacts consume the record even if root protection blocks HP loss;
others retain impact state or a non-decrementing contact marker.

Clean LEVEL15 source SHA-256
`cebd5b53f4a7f0b42cc7aec7f7e2e13749089a3dd630a3af1fcccaf81748e70a`, path
`02-Jeu-et-dumps/Data/BACKUP/BIN/LEVEL_15.PRX`. Exact worker windows are in
`damage-followup-gcs-sources-001.json`; original byte hashes in provenance.json.
Existing GCS/GCS_Ship/GCS_Models/GCS_Asteroid canonical headers do not bind these
producer entries to retail class names. Pool definitions with a numeric stride
are not Moby name-pointer descriptors. No new census/matching/import/runtime/
files/annotations by the worker. No LEVEL21 equivalence promotion.

Parent receiver closure is reused, not duplicated: nativea2 is packet,
10C6EC reads `float(packet+4)` then10BE94 applies root protection and health
loss. This route does not use ordinary Ratchet weapon rows/38540/armor.

# 1. Source routing register

`cfg` means the configuration actually used by that producer; it is distinct
from the record/header pointer. Four-byte offsets are not interchangeable.

| Site | Producer/full reviewed bounds | Storage | Packeta2 | Consumed scalar | Value |
|---|---|---|---|---|---|
|DDC24|DDA74..DE400|pool stride70|cfg+40|cfg+44|UNKNOWN|
|DDE80|same body|same pool, flight contact|cfg+40|cfg+44|UNKNOWN|
|F8578|F7E20..F85D0|owner subobject338|cfg+14|cfg+18|4.0|
|F9788|F92A8..F9CD0|pool stride94|cfg+70|cfg+74|UNKNOWN|
|FBE0C|FBB40..FC4B0|dense linked chunks stride28|*(record24)+10|cfg+14|UNKNOWN|
|FCAE0|FC820..FCF20|dense linked chunks stride24|*(record20)+28|cfg+2C|UNKNOWN|

No direct ordinary enemy receiver call orJALR occurs in these five bounded
bodies. This is a positive direct-routing result; it does not exclude indirect
enemy interaction in unclosed effect/geometry helpers. No ordinary bolt/XP
reward should be inferred from visual effects.

# 2. Shared70-byte pool DDA74: flight and retained impact

Native definition23617C holds stride70; update word236188 points toDDA74.
Adjacent DD29C/DD4A0/DD284/107658 are positive function words, with transitive
roles outside this scope. Inputheader38 gives cfg, header3C gives per-call age
decrement. Linked chunkC is buffer,10 active count.

| Record offset | Operational use |
|---|---|
|18/1C/20|direction/movement|
|24/28/2C|position|
|30|remaining age/lifetime-like scalar|
|4D byte|flight versus impact/postflight branch|
|50/54|orientation/rotation|
|64|managed/effect field|

Nonzero4D impact branch uses age and an interpolated cfg1C/20 size, adds cached
player radius and tests squared distance. Accepted overlap callsDDC24 with
cfg40 packet. Negative age/terminal paths useDD264 cleanup.

Zero4D flight branch tests age, subtracts header3C, advances position by its
direction/configured movement, computes orientation/plane contacts and may
set4D=1/clip position. Player overlap callsDDE80 with the same packet.

Common terminalDD038 is conditional: nonzero4D writes age1 and invokes102318
on managed64, retaining the record; otherwiseDD264 removes it with last-record
exchange/compaction and1020EC relocation. **Contact always immediately deletes
this family is REJECTED.** World-plane->retained-impact contact->final cleanup
and possible repeated HP opportunities require live/source configuration data.

Movement cfg4/8 is multiplied by1BA28. Its F730 mode selects0.9/0.8/0.7 for
modes1/2/3,1 otherwise. This is a mode speed factor, **not elapsed time**.
Lifetime decrement header3C is separate; creator/candidate adjustment is UNKNOWN.
Direct calls include1BA28,10C6EC twice,DD264,1020EC,112378,C9308,102318,
102104,DD038. No defended wall-time/repeat-damage period is assigned.

# 3. Beam subobject F7E20: raw4 and local contact reload10

## 3.1 Owner/configuration chain and coordinate correction

Native update word23856C points to owner callbackE93E0. Its E94E0 call supplies
owner record+338 toF7E20 and shared table **3FB950**, plus calculated position/
orientation. Earlier1BB248 was a **raw PSP addend**, not table RVA: segment1
base240708 resolves `1BB248+240708=3FB950`.

Setup E9A24 callsF7340(cfg238364); E9B48 callsF7478(table3FB950,cfg238364).
F7478 stores cfg at table0 and initializes subordinate geometry storage.

| cfg238364 offset | Original value/use |
|---|---|
|0 /4 /8|15.0 /6.0 /25.0|
|C|2.0 contact geometry input|
|10|10.0 local contact reload|
|14|integer packet/header2|
|18|4.0 damage scalar at23837C|
|1C|material/config pointer238324|
|20 /24|integers2 /6|
|28 /2C|~0.100000009 /~-0.0500000045|
|30|1.5|
|114 /118 /11C|initialized1/15 /1/6 /1/25|

The reciprocal fields are stored0 beforeF7340 runs. It writes the effective
rates; "file0 means no phase progress" is REJECTED. Packetbase238378 is cfg14,
and bridge consumes its next float23837C=4. **Header2 does not halve it**:
campaign weapon selector rules are absent from the closed GCS bridge.

## 3.2 Phase, geometry and independent protection

SubobjectA0 is phase/state,A4 progress,A8 local contact cooldown;88/8C/90 and
94/98/9C are geometry/anchor positions. Progress uses initialized reciprocals,
without an elapsed-seconds argument. Retail source/attack name remains UNKNOWN.

The body subtracts1 fromA8, requires active/nonzero geometry and cooldown<=0,
then tests beam segment/contact throughC0BB8 using configured radius. Accepted
intersection prepares geometry/effects, callsF8578 and reloadsA8=cfg10=10.
Failed geometry does not reload. The producer reloads even if root protection
prevents HP subtraction; raw4/opportunity is not guaranteed4HP/everytenframes.

Conditional once-per-frame predictions only:

| Call-count scale |30 admitted calls/s|60 admitted calls/s|
|---|---:|---:|
|contact10|~0.333s|~0.167s|
|phase15|~0.500s|~0.250s|
|phase6|~0.200s|~0.100s|
|phase25|~0.833s|~0.417s|

Actual phase boundaries, owner scheduling and eligible body frequency are
UNKNOWN. These arithmetic predictions are INFERRED, not measured durations,
DPS or patch acceptance. Rendering/material calls do not establish rewards.

# 4.94-byte pool F92A8: consumed contact and corrected lifetime

Definition23B41C holds stride94; update23B428 pointsF92A8; adjacent pointers
F8710/F8908/F86F8. Header38 cfg/header3C cached age decrement match the pool
pattern, but this record's schema differs:

| Record offset | Operational use |
|---|---|
|0..14|rotating basis/orientation|
|18/1C/20|direction/movement|
|24/28/2C|evaluated/contact position|
|30/34/38|movement-base position|
|3C|remaining age/lifetime-like scalar|
|40/44/48|geometry/effect motion|
|4C /50 byte /60|helper handle/state /state byte /decrementing budget|
|54/58 /64..80|rotation parameters /two oscillator groups|
|88|managed relocation field|

**Lifetime is3C, not30.** F9408 reads3C; negative age terminates; normal path
subtracts header decrement/storeF944C. Mode-speed multiplication1BA28 drives
configuration motion, then basis/oscillator/base updates evaluate contact
position. Record70 oscillator data is distinct from cfg70 packet.

Player overlap callsF9788 with cfg70; scalarcfg74 remains UNKNOWN. Terminal
F9B24 emitsF2EC4/F2634 and optional102104, cleanupF86B8 atF9C04, compacts last
94-byte record, relocates managed field1020EC and updates count. This positive
contact path consumes its record even if root protection blocks HP loss, unlike
the retained70-family branch. Retail trajectory name, initialization, budget/
oscillator meanings and physical timing remain UNKNOWN.

# 5. Dense28-byte records FBB40: one-contact consumption

Manager4 listhead/sentinel traverses nodes with buffer and16-bit start/count.
Stride28 (40decimal) schema:0 life,4 per-call life decrement,8/C/10 position,
14/18/1C per-call velocity,20 presentation/progress UNKNOWN,24 cfg pointer.

Each processed record subtracts its own lifeStep4 from life0; nonpositive
result compacts/removes. Live position adds velocity without an elapsed-delta
argument. Creator adjustment of steps/velocity remains UNKNOWN. Player sphere
overlap prepares type1 geometryF2A3C/optional nearby102104 and callsFBE0C with
cfg10; consumed scalarcfg14 remains UNKNOWN. Contact then removes the record,
including when root protection prevents HP loss.

Full function endsFC4B0, not initial record-loop exitFBF14. Its longer
presentation tail contains no additional bridge/ordinary receiver/JALR.
Direct callsF2A3C,102104,10C6EC,102318,11C56C,746F4 do not imply another hit.

# 6. Dense24-byte records FC820: retained exact-zero contact gate

Stride24 (36decimal) schema:0 life,4 contact marker,8/C/10 base/origin,
14/18/1C movement/displacement,20 cfg pointer. Every processed record subtracts
cfg30 from life; nonpositive result compacts/removes. Surviving contact is
attempted **only when float(record4)==0**, not<=0.

The body evaluates a point using base/movement/progress, tests player overlap
andBEA74 geometry using cfgC/5C. Accepted route callsF2A3C type2 thenFCAE0 with
cfg28; scalarcfg2C remains UNKNOWN. It then stores
`marker = 1 - geometryParameter * cfg5C` atFCAEC.

The only record4 writes in the full body are compaction copy and this marker;
no local decrement/reset occurs. Nonzero marker suppresses later contact until
expiry/replacement, but the formula could produce exactly0. Attainable parameter
domain is UNKNOWN, so unconditional "at most one bridge call" is unsupported.
Contact retains the record and writes marker even when root protection blocks
HP loss. **Marker-as-countdown is REJECTED.** Tail throughFCF20 has no second
direct bridge/ordinary receiver/JALR; effect/geometry helpers remain scoped.

# Measurement agenda and precise gaps

1. Beam: record initializer values, body/contact ordinals, packet4, localA8 and
   root138/health2C separately; compare A0/B/C timing, geometry and HP loss.
2. Pools: identify cfg pointer/scalar, initial life/header decrement and mode
   factor; separate70 flight from retained impact contact,94 consumed contact.
3. Dense28: record creator lifeStep/velocity and contact consumption when root
   protection rejects HP loss.
4. Dense24: capture marker formula inputs, exact-zero reachability and later
   contacts/expiry; do not model it as a countdown.
5. Bind retail names from reproducible scene/source association rather than
   coexisting model/controller descriptors.

Open: four nonbeam configuration scalars/factories, initial lifetime/decrement/
velocity values, owner callback scheduling, scene/class labels, candidate data
adjustments, marker parameter domain, transitive effect/geometry interactions,
physical travel/HP-loss parity. Positive source storage and bridge routing are
complete for these five bodies; whole-flight attack coverage remains open.
