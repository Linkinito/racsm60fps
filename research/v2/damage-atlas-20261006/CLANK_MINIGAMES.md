---
kind: static
title: "Damage atlas: Clank forms, vehicles, minigames and multiplayer"
date: 2026-10-06
authors: ["GPT (Codex)", "GPT read-only Clank/minigame worker"]
status: complete
evidence: [OBSERVED, INFERRED, CORROBORATED, UNKNOWN]
summary: "Specialized receivers and controller resources differ from campaign Ratchet; exact damage, failure, collision and multiplayer gaps are enumerated."
systems: [Clank, GiantClank, vehicles, Microbot, Skyboard, multiplayer, damage]
levels: [LEVEL_02, LEVEL_04, LEVEL_08, LEVEL_10, LEVEL_15, LEVEL_16, LEVEL_17, LEVEL_18, LEVEL_19, LEVEL_20, LEVEL_21, LEVEL_22, LEVEL_23, LEVEL_24]
variants: [A0, B, C]
environment: "Existing clean native modules, canonical instruction corpus and stored Claude maps; no live experiment"
related: [research/v2/damage-atlas-20261006/REPORT.md, research/v2/disasm-corpus/REPORT.md, research/v2/module-bytematch-20261005/REPORT.md]
---

# Evidence boundaries and provenance

This is the parent-integrated handoff of one independent read-only worker.
Native descriptor lookups used class names and four relocated callback pointers,
not new function matching. Selected existing canonical class exports supplied
instructions; bounded native reads closed known entries/callers where exports
were absent. No PPSSPP control, annotation, patch or asset write occurred.

The new descriptor helper reports a header four bytes before the old corpus
convention: LEVEL02 ClankPlr is `2E8300` versus the old `2E8304`. The relevant
callbacks are descriptor `+8/+C/+10/+14`. Its `words[8]` label is **not a proven
pvar-size field**. Absolute globals were resolved with existing
`build-plugin-sites.py` `pair_address()` using relocation records/PT_LOAD
segments; unrelocated HI/LO immediates initially give wrong GCS segment addresses.

The canonical corpus uses heuristic callback extents. SurvivalBot's update is
explicitly `TRUNCATED_BOUND` at 1,024 instructions, so the omitted tail cannot
support an absence claim. Native decoder queries decoded individual 4-byte
instructions: an unsupported Allegrex opcode otherwise stops a multi-instruction
Capstone decode early. Empty class updates can coexist with model/controller
updates; empty damage slots can coexist with controller health/failure.

| Clean native module | SHA-256 |
| --- | --- |
| LEVEL02_clean | `0037689a926197969231795c4d6b05980e5e94558394617b21e8b8bcd79bc8aa` |
| LEVEL08 | `c6906ca8805ec805063036429ecc86ce316efdd386641e87fc8c92dd90dad8a8` |
| LEVEL10 | `07f9010f78cf6f49f8fdad0dbf89ce20375dff600183117605c3ebf231583772` |
| LEVEL21 | `0e7a7f7d70a70e51081b0471e257f50d3a86f987a5eae546b2a178d2190dd706` |
| LEVEL22 | `be7ef86357ee668bb1c194226e4cd2e55920a4f7f375952ffb494c0de5a78986` |
| LEVEL23 | `7c8a790eccf722cfd8e5a6e066d17300cf84c1f4068535a6575542229c0f7561` |
| LEVEL24 | `a4e3f6496b3d2d238767fbb72b9db274dc5179dbe4d6f71eea2ce1fee22480bf` |

LEVEL01/04/15 hashes are in METHOD. These are frozen clean-file identities, not
live emulator hashes. MP16..20 individual source hashes and new worker derivative
script hashes were not gathered before the quota stop: that provenance gap is
explicit. Use the stored module-map source identities before any reproduction.

# 1. On-foot Clank and alternate player

## ClankPlr wrapper

| Module | Descriptor | Init | Secondary | Update | Damage |
| --- | --- | --- | --- | --- | --- |
| 02 clean | `2E8300` | `13ABAC` | `13ABF8` | `13AC00` | `13AC08` |
| 04 | `2E22F8` | `12C2EC` | `12C338` | `12C340` | `12C348` |

Both update callbacks are empty. LEVEL02 damage checks the actor against global
player active actor `+594`. The active case calls `357C4`, which the existing
Claude map identifies with LEVEL01 `3131C` (EXACT, one agreeing callee, zero
disagreeing). That wrapper invokes common `38540`. LEVEL04 uses `32648` mapped
to the same wrapper. Inactive actors return 1; admitted forwarding returns **2
regardless of nested result**. Neither survival nor acceptance can be inferred
from that outer 2 alone.

Constructors `354FC` (02) and `32380` (04) were not identified in stored maps.
The exact common-player form binding remains UNKNOWN. Empty updates do not
mean Clank cannot receive damage; the active forwarding is positive evidence.

## Alternate player state 21

LEVEL01 `39FD4` initializes state 21 through `56B44`; `3C88C` updates it through
`55EE0`. `2FB8C` selects it when active `+594` is NULL and alternate `+5AC` is
present, using `55D80/56B44`. `56B44` assigns `+594 = +5AC`, initializes HP/max
from `2B0D40/2B0D44`, model callbacks `559C8` at `+48/+DC` with context `+E4`,
and controller `36CF48 = -1`. Identification as **on-foot Clank is INFERRED**;
the class-to-form constructor binding is not proven.

`55EE0` invokes `570F0`, `56DC8`, `56348`. In `570F0`, substate 10 waits for
animation 9/fade via `97398`, writes player `+FA = 21`, restores HP from
`2B0D44` and reinitializes through `35A14`. Other branches use `36CF50 -= 1`,
player `+138 -= 1/30`, fixed motion/gravity/jump, and animation conditions;
`55EE0` also uses 1/60 model rotation. These mixed clocks execute inside player
machinery. Halving one constant is not a complete form correction.

# 2. Small Clank bots

LEVEL02 ClankBot descriptor `2E76F0`: init `132178`, secondary `132618`, update
`134E40`, receiver `13264C`. The receiver does **not subtract incoming scalar**.
State zero rejects (1); source group byte `+4B` values 0D/0B also reject. Other
sources select state 17 through `134FE0`, emit effects and return 3. This is an
observed single-hit state transition independent of scalar. State 17 as literal
destruction rather than disable/recovery is INFERRED until its handler is closed.
Source classifications 0B/0D are UNKNOWN.

`134E40` dispatches states 0..19. Reactivation, susceptibility, follower control,
ports, houses and ClankBotController consequences remain unclosed. Return 3
cannot replace state-handler/controller analysis.

# 3. Bot flinger and destruction derby

| Class | LEVEL04 damage | LEVEL08 damage |
| --- | --- | --- |
| ClankBotFlingerVehicle | `12A6A0` | `131494` |
| ClankElectroTorso | `12BA2C` | `132820` |
| ClankRamTorso | `12C850` | `13357C` |
| ClankSawTorso | `12D228` | `133F80` |
| ClankSpikeTorso | not bound here | `134B00` |
| EnemyBotFlingerVehicle | `13A788` | `145924` |

DestructionDerby controllers have zero receivers: LEVEL04 descriptor `2E3948`,
update `1362EC`; LEVEL08 `310A08`, update `140FE0`. Compiled flinger and derby
classes in one module do not establish simultaneous challenge use.

## Flinger: magnitude-to-reaction route

LEVEL04 `12A6A0` rejects positive moby `+70`. Otherwise incoming f12 times 30
is converted to an unsigned integer pvar `+F4`; a linked flag 1000 is cleared;
`19AE0C` receives source/position/configuration; state 4 is selected via `12A844`;
moby `+70` reloads 30 from data `2E1E48`. **Return remains 0 on admission.**
Update `12AAE8` decrements `+70` by one per callback unless state 4.

Enemy `13A788` rejects state 3, otherwise multiplies an integer state/config
value by incoming magnitude, writes `+F4`, invokes `19AE0C`, selects state 3,
and returns 0. The quantity is **INFERRED reaction duration/intensity, not proven
HP**. `19AE0C` is the exact unresolved consequence helper. The main report's
phrase "local damage/state event" refers to the admitted receiver operation,
not to established health subtraction in this flinger path.

## Torso: direct common-player HP, separate admission

Reviewed Ram/Saw/Electro/Spike paths:

1. Attack type 4 branches to LEVEL04 `1663E8` / LEVEL08 `189E48`, uses a separate
   transition and returns 2; its retail meaning is UNKNOWN.
2. Ordinary admission permits `moby +70 <= 0`, **or reaction 3**. Reaction 3
   bypasses this particular timer, not every possible upstream filter.
3. Interceptor `1A460C` (04) / `1C8C08` (08) can finish early.
4. Incoming f12 subtracts directly from global player HP `+964`, clamped at zero
   and at max `+968` for negative input. The inspected branch bypasses `38540`.
5. Death invokes vehicle controller `192F10` (04), changes flags, removes head/
   attachments, emits wreck/effects (`196004` etc.) and disables model callbacks.

LEVEL04 player root is relocation-resolved `34B740`: HI/LO sites Ram
`12C964/12C968`, Electro `12BB24/12BB28`, Saw `12D320/12D324`. Ram reload is
15 (`2E239C`); Saw 15 (`2E2464`). Electro `12BEB0` includes `+70 -= 1` per
callback. Other reviewed torso countdowns are per-call, but exact module/terminal
branches require their own closure. Ram ordinary return is 0; Saw ordinary
return 2 includes terminal behavior. Campaign return semantics do not transfer.

Common armor reduction is absent in the inspected subtraction branch. Actual
armor participation through takeover/setup/interceptors, HP units and challenge
initialization remain UNKNOWN. A 15-callback cooldown can run twice as fast if
the torso update doubles; Ratchet's already-corrected 180 substep timer does not
repair it. This is a falsifiable risk, not measured parity failure.

## Vehicle mines and missiles

LEVEL04 VehicleMine init `196624`, update `196658`: state 1 invokes `193A84`
with owner pvar `+8`, then deletes through `6D208`. Radius, scalar and receiver
filtering inside `193A84` remain UNKNOWN.

VehicleMissile update `196EA0` has per-callback movement, collision `1931E8`,
and lifetime `+70 -= 1`. **Impact and timeout both** invoke `1932E4` with
owner/context/position and data `2EC330/2EC334/2EC338`, then delete. The shared
effect route is observed; damage amount, radius, classes, owner immunity and
friendly fire remain UNKNOWN. This timeout contract differs from Giant Clank's
rocket and Ryno, which have deletion-only reviewed expiry branches.

# 4. Microbot survival and toss

| Class | LEVEL04 update | LEVEL08 update | LEVEL24 update |
| --- | --- | --- | --- |
| Microbot | `15A5E4` | `178AC8` | not bound here |
| MicroBotSurvival | `15B8BC` | `179DA0` | `137C10` |
| MicrobotTossBomb | `15D7B0` | `17BC94` | not bound here |
| MicrobotTossGoal | `15E340` | `17C824` | not bound here |

Microbot and MicroBotSurvival have zero damage callbacks. The reviewed LEVEL04
Survival controller (descriptor `2E7700`) manages board/cursor, selections, UI,
input repeat and spawned bots. `+44` is a modulo-six input repeat; `18110C/184F60`
spawn/launch, byte `+4D` increments and moby `+70` delays. Around `15C2B4`,
cleanup calls `15B324`, deletes UI, clears selection, invokes `32984(1)` to
restore player control, then selects state 2. No direct `+964` subtraction or
common receiver was seen in this body. **Failure policy is still UNKNOWN**:
`15B324`, `15B4E8`, bot helper `18251C`, and the full `182AA0` SurvivalBot
update remain precise targets. Its truncated export cannot rule out later
attack/failure branches.

LEVEL04 TossBomb descriptor `2E791C`: init `15D6A0`, update `15D7B0`, no-op
receiver `15DA5C` returns 0. State 2 performs physics `8D5F4`; fuse `+70 -= 1`
around `15D980`; blink pvar `+3C -= 1` around `15D990`; expiry calls `15DCE0`;
state 3 calls `15DD8C`. Blink toggles byte `+46`/visual color, with reload based
on remaining fuse /300 and `2E7908/2E790C`. These are demonstrably callback
clocks. Explosion/failure is unclosed in `15DCE0/15DD8C`. Normal BombGlove
scalars cannot be copied onto this specialized challenge bomb. TossGoal's
goal/failure update was not deeply inspected.

# 5. LEVEL10 Giant Clank combat

GiantClankPlayer descriptor `2D8F64`: init `13E2CC`, secondary `13E594`, empty
update `13E5C8`, damage `13E5D0`. Init embeds a record at pvar `+50`: owner
`+0`, global player `+4`, health `+30 = 100` (`2D8C88`), timers `+34/+38/+3C`,
integer `+F0 = 100` with unknown role. Embedded controller callbacks own update.

Receiver `13E5D0` rejects state getter `13D0D0 == 8` (return 1). If `+38 <= 0`
it clears `+3C`, then **subtracts every admitted scalar even while +38 is
positive**, reloads `+38 = 1`, and mirrors HP to associated player `+964`.
Zero clamps to zero, selects state 8 through `13D0D8`, returns 3. Surviving
positive reaction can request state 7 if `+34 <= 0`; survival returns 2.
No common armor computation appears here. **Timer +38 is not a rejecting
invulnerability check in this receiver**; upstream filtering remains UNKNOWN.

GiantClankRocket init `13EDDC`, secondary `13EE0C`, update `13EE44`, zero receiver.
Lifetime `+70` starts 60 (`2D90C0`) and decrements one per callback. Expiry
deletes without collision damage. Flight `13F11C`, collision `13F308` with
radius `2D90C4`; owner's active `+594` is excluded. Collision kind 2 dispatches
target group `+20` with **scalar 1, type 1, reaction 1**, impact/direction/source,
then emits and deletes once. The literal anchor convention around `2D90CC`
must not be conflated with descriptor-header conventions. No rank-based read
was found in this callback. Launch rate/ammo/motion/additional area targets are
UNKNOWN in launch/flight helpers.

# 6. LEVEL15/21 Giant Clank flight: GCS

The flight modules use GCS rather than LEVEL10 GiantClankPlayer. Existing
whole-file comparison reports fourteen differing bytes, mainly asset names.
That is close compilation, not universal interchangeability or behavioral parity.

| Class | Descriptor | Init | Update | Damage |
| --- | --- | --- | --- | --- |
| GCS | `235B74` | `D719C` | `D736C` | 0 |
| GCS_Asteroid | `23C838` | `109A24` | `109A84` | 0 |
| GCS_Models | `23C8AC` | `109E78` | `109ED8` | 0 |
| GCS_Ship | `23CD60` | `10CB68` | `10CB9C` | `10CBA4`, no-op 0 |

Reviewed callbacks share these RVAs in 15/21. Ship update is empty; init binds
its model to the controller. HP/resource administration therefore belongs to
controller code, not the ship's no-op receiver.

## Controller resource and virtual state

`10C81C` accesses relocation-resolved root **`3FC2B8`**, HI/LO `10C83C/10C840`.
Fields: scalar `+2C`, flag byte `+30`, state index `+64`, state object `+68`,
state array `+6C`, virtual-transition stop flag `+80`, counter `+394`.
If `+30 == 0` and scalar `+2C <= 0`, it requests state 3 via `10B95C`.
It then replenishes per callback, clamping at **100** (`23CA10`):

- While `+394 < 0`, contribution is `23CA14 = 0`.
- Otherwise contribution is `100/60`, denominator `23CA38 = 60`.
- `+394 -= 1` per callback.

The resource, cap, depletion-triggered transition and gate are OBSERVED. Calling
it "health" and state 3 "death" is **INFERRED**, pending subtraction writers
and state-3 handler. Gate direction is retained exactly; do not reinterpret
negative/positive counter from intuition.

`10B95C` invokes old virtual-state exit, updates `+64`, selects from `+6C`,
stores `+68`, invokes new enter; it does not set campaign HP. `10C81C` invokes
animation `10A654`, input `10B9D4`, weapon `10A988`; up to two virtual state
transitions/callbacks can execute until `+80` changes. Callback multiplicity
must be measured before changing a per-call resource rate.

`10C7D0` initializes through `109F08` (four state objects/tables), `10A5E4`
animation, `10A8BC` attack setup, `10B014` effects, `10B1EC` clears effect
pointers `+34/+4C/+58`. Table pointer immediates in `109F08` are relocated
segment addresses. Resolve the four tables and their enter/update functions to
find loss writers, collision and state-3 death/out-of-bounds behavior. Missing
saved LEVEL15/21 Ghidra programs are an exact decompiler blocker, not authority
to rebuild the environment.

## Firing, path and visual effects

`10A988`: `+1F8` decreases each callback; on expiry `+1F4` decreases. Admission
uses flag `+15C`, cooldown `+138`, button 8000 and `+1F4`. Available count
`+1FC > 0` sets `+160`, reloads `+1F8 = 1`, reloads `+1F4` from `23CAEC`,
sets two channel phases `+1EC` to 0/.5, decrements `+1FC`. Empty count uses
near-camera visual helper `102104`. Projectile damage and exact ammunition
semantics remain UNKNOWN.

GCS update `D736C` calls path/camera `D6094`, particles `D6AE0`, ship `10C81C`
and wave/enemy handlers. Event 7 callback `D6F60 -> 108AE0` is unresolved;
`D6F84 -> 105668`; `D6F7C` is no-op. `D6094` advances with 1/30 times
`235A10`, can freeze under a simulation condition, and can set controller `+18`
to -1 at path end. It is not established as HP or out-of-bounds death.
`D6AE0` accumulates motion-dependent particle fractions, floors births, emits
through `1119E4`, retains remainder. `D67CC` is HUD/UI/counter work with unknown
health relation. Bounded `10B328` movement/camera inspection did not close
collision consequence. Visual births are not damage events.

# 7. Skyboard races and obstacles

| Class | LEVEL22 update | LEVEL23 update |
| --- | --- | --- |
| RaceController | `104E34` | `14536C` |
| Skyboard | `107F28` | `155A40` |
| AirRaceMine | `EC86C` | `10AEB8` |

Skyboard descriptors `240880` (22) / `2A75F8` (23) have zero receivers. LEVEL22
update mainly handles model animation: state 1 can call `1086A0` based on
config `+40`; animation `5F050 == 5` changes model `+48/+8` from config `+42`;
init installs post-callback `1088C0`. Rider movement/crash belongs elsewhere.

AirRaceMine descriptors `23E014` (22)/`2A0B8C` (23), init `EB53C`/`109B88`.
Configuration includes trigger/warning/explosion radius, slowdown flag and race
mask. Reviewed LEVEL22 update:

1. State 1 queries `13E68` with trigger radius; saves target pvar `+1E0`.
   Slowdown flag chooses state 2; otherwise state 3.
2. State 2 calls `4710C` with age/progress factor, visual paths and `EBAE4`,
   then selects state 4.
3. State 3 normalizes vector `+148/+14C/+150`, scales by `+204` and age envelope
   `24E17C`, clamps negative vertical component, calls `47144(vector, 2)` and
   also `4710C` within the `24E184` window.
4. State 4 recovers with `47684(+1F0)`, `106340/1063E8`, then resets state 1.

No direct ordinary HP decrement or group damage dispatch appears in this
callback. Slowdown/knockback are strongly INFERRED; exact crash, control loss,
respawn/HP consequences of `4710C/47144/EBAE4` remain UNKNOWN. Moby `+70` is
age/progress produced through `EC148`, not a proven decrementing fuse.

LEVEL23 AirRaceSentry descriptor `2A144C`, init `10F9D0`, update `10FE88`, zero
receiver; config travel time/offset/circling/endpoint/race mask. Contact outcome,
race boundary, falling and instant failure remain UNKNOWN. Historical uncontrolled
lap timing does not establish parity.

# 8. Multiplayer is a separate damage domain

| Module | NetworkedRatchet descriptor | Update | Damage | Wrapper -> native receiver |
| --- | --- | --- | --- | --- |
| 16 | `2B5F34` | `144784` | `1447D8` | `2A48C -> 318B8` |
| 17 | `2A951C` | `140A98` | `140AEC` | `2A360 -> 31748` |
| 18 | `2B97C4` | `14C88C` | `14C8E0` | `2A4E8 -> 319A8` |
| 19 | `2B3A8C` | `143BC0` | `143C14` | `2BD64 -> 33074` |
| 20 | `22EAEC` | `F4088` | `F40DC` | `27DE4 -> 2ED50` |

Stored maps mark campaign `38540`, `31B64` and several related entries ABSENT
in MP16..20. This is missing correspondence, not absence of the concepts.
`3131C` wrapper matches are masked EXACT but **zero agreeing callees**; direct
native caller reads reveal the different targets above. Thus campaign armor,
type-10 semantics, suppression, interception, friendly fire and instant kills
cannot be inherited from the superficial wrapper match.

| Specialized class | LEVEL16 | LEVEL17 | LEVEL18 | LEVEL19 |
| --- | --- | --- | --- | --- |
| PlayerTurret receiver | `145704` | `141A18` | `14D80C` | `144B40` |
| TurretGun update, zero receiver | `14838C` | `1446A0` | `150494` | `1477C8` |
| TurretShot update, zero receiver | `149264` | `145578` | `15136C` | `1486A0` |
| Map controller update, zero receiver | `13A544` | `13966C` | `13D528` | `138CCC` |

Original player-loop bound is **one in MP16..20**, versus two in inspected
campaign/form modules. Campaign original-two/candidate-one reasoning does not
transfer. Authority, serialization, team rules, turret ownership, scoring,
respawn and environmental instant kills remain UNKNOWN. Exact next module is
LEVEL16: `318B8/1447D8`, then `145704/149264`; no suitable saved MP decompiler
program was found.

# 9. Measurement agenda for Claude

All comparisons require identical scene/checkpoint, input, mode, source, initial
HP and A0/B/C configuration, with accepted events rather than visuals alone.

| Question | Falsifiable prediction and measurements |
| --- | --- |
| Derby torso damage | Record HP per isolated Ram/Saw hit, callback spacing until a repeat, reaction-3 override, armor differences, wreck/death time. Ordinary route has local admission/direct HP; actual armor result remains open |
| Giant Clank timer | Identical enemy hits at several separations; record local/mirrored HP, +38, states 7/8. Positive +38 alone should not reject an admitted receiver call; distinguish upstream filters |
| Giant Clank rockets | Measure held-fire count, individual lifetime, impact count and expiry. Reviewed timeout has no collision damage |
| GCS resource | Correlate displayed meter with root 3FC2B8 +2C/+30/+64/+394 under one fixed collision and idle recovery. Prediction: cap 100; nonnegative counter selects 100/60 per callback; depletion with byte30 zero requests state3. Establish meaning first |
| Skyboard mines | Compare one slowdown and one ordinary mine: HP, speed/time, displacement, control suppression, crash/respawn/time penalty, recovery and repeated contact |
| Microbot toss | Neutral-input fuse/blink/explosion timing; determine whether expiry changes HP, destroys bot, fails round or only changes state |
| Microbot survival | One controlled bot contact; record result/score/failure and bot/controller state, not only common-player HP |
| On-foot Clank | Establish state21 entity binding; one fixed hazard's HP, repeat interval, animation and retry. Outer return2 is not acceptance evidence |
| Multiplayer | Separate self/ally/enemy/turret/environment hits with exact module/network setup; record authoritative/local/remote HP and score/respawn |

These are protocols and narrowed hypotheses, not executed live tests. Exact
unclosed helpers are retained in COVERAGE and constitute the next static work.
