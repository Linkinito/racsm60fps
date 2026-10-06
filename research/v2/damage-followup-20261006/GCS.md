---
kind: static
title: "Giant Clank flight: health, protection, collisions and terminal controller state"
date: 2026-10-06
authors: ["GPT (Codex)"]
status: complete
evidence: [OBSERVED, CORROBORATED, INFERRED, UNKNOWN, TESTED]
summary: "Resolved four GCS virtual states, positive health/mirror/loss/healing contracts, and terminal mode8 timing; source payloads and live behavior remain bounded gaps."
systems: [GiantClank, GCS, damage, health, death, collision]
levels: [LEVEL_15]
variants: [A0, B, C]
environment: "Clean LEVEL15 native instructions and PSP relocations; no Ghidra import or live experiment"
related: [research/v2/damage-atlas-20261006/CLANK_MINIGAMES.md, research/scripts/inspect-damage-routes.py]
---

# Result and changed interpretation

The original atlas left GCS resource `+2C` as an inferred health-like meter.
It is now positively bound to player HP: `10C81C` mirrors its **ceiling** into
associated player `+964`, writes max100 to `+968`, and passes the unrounded value
to display helpers. The controller initializes it to100, subtracts admitted
incoming damage with a zero floor, and has integer healing capped at100. These
independent code paths CORROBORATE the health role. A displayed integral HP can
hide fractional loss/recovery; instrumentation must record controller float too.

State3 is a terminal sequence after depletion: enter sets a terminal guard,
update drives effects/animation/fade and requests global mode8 after57 calls.
Its exact user-visible death/retry UI remains INFERRED pending the global mode
consumer/live control. This is much stronger than merely guessing from a zero
meter, but it is not a measured flight-death or30/60-parity acceptance.

Only LEVEL15 was read for this continuation. The prior shared15/21 RVAs are
historical evidence; this new body/constant analysis is not silently promoted
to LEVEL21 without source verification.

# Provenance and reproduction

Clean source `02-Jeu-et-dumps/Data/BACKUP/BIN/LEVEL_15.PRX` SHA-256
`cebd5b53f4a7f0b42cc7aec7f7e2e13749089a3dd630a3af1fcccaf81748e70a`.
`inspect-damage-routes.py` reuses the installed/vendored Capstone decoder and
existing `build-plugin-sites.py` ELF/relocation helper. No import, matching,
function census, runtime connection or asset write. Every4-byte instruction is
decoded independently; unsupported VFPU instructions are marked UNKNOWN rather
than silently truncating. Recipes give explicit windows and entry evidence,
not inferred complete function sizes.

```text
python research/scripts/inspect-damage-routes.py research/scripts/ghidra/recipes/damage-followup-gcs-001.json research/v2/decomp-candidates/_local/damage-followup-20261006/gcs-001
python research/scripts/inspect-damage-routes.py research/scripts/ghidra/recipes/damage-followup-gcs-002.json research/v2/decomp-candidates/_local/damage-followup-20261006/gcs-002
```

Use a fresh output suffix for reruns; prior manifest overwrite is refused.
TESTED preservation concerns the unchanged source-file hash and deterministic
raw window/hash export only. Manifests retain recipe/method/helper hashes,
listing and native-window hashes. Listings/table words remain ignored/local.
The six direct damage-bridge callsites below were queried by exact JAL target
inside executable sections, not by similarity matching or a new function census.

# 1. Four resolved virtual states

Constructor `109F08` allocates one28-byte block, sets four embedded state-object
pointers at root `+6C`, and initializes their virtual tables using PSP relocated
HI/LO pairs. Root resolves to `3FC2B8`; data pointer immediates such as198 are
segment-relative and must not be read as code addresses.

| State | Table RVA | Enter, table+18 | Exit, table+20 | Update, table+28 | Presentation, table+38 |
| --- | --- | --- | --- | --- | --- |
| 0 | `2408A0` | `12DFC4` | `12DFAC`, no-op | `12DFEC` | `12DFBC`, no-op |
| 1 | `2408E0` | `12E014` | `12E054`, no-op | `12E05C` | `12DFBC`, no-op |
| 2 | `240920` | `12E108` | `12DFAC`, no-op | `12E13C` | `12DFBC`, no-op |
| 3 | `240960` | `12E188` | `12DFAC`, no-op | `12E25C` | `12E3B0` |

Shared init/secondary callbacks `12DF9C/12DFA4`, render-slot `12DFB4`, and most
exit/presentation slots are no-ops. Table+8 is called during construction.
`10B95C` invokes old table+20, writes state index `+64`, selects object from
`+6C`, stores `+68`, calls new table+18. `10C81C` invokes table+28 and can make
up to two update/transition iterations in one controller callback; return-1
ends the loop, and flag `+80` can stop after a transition. `10CA44` presentation
calls table+30; animation/model paths invoke table+38 through `10A418`.
These are distinct owners: a virtual callback count is not automatically an
outer game frame, particle tick or player substep.

States0/1 respond to request `+160` (-1/no transition and1/state1), with
animation selections2/3 through `10A0AC`. State2 clears a blend/progress field,
selects animation1 and returns to0 after animation completion helper `10A230`.
Exact retail state names remain UNKNOWN. Do not label the four states from
their numerical positions alone.

# 2. Health initialization, loss, healing and temporary protection

Initialization `10B684` binds associated player, sets player state39, clears
ordinary actor/proxy fields, selects initial GCS state0, initializes health100,
terminal byte`+30=0`, protection `+138=0`, contact cooldown `+158=0`, refill
counter `+394=0`, and other motion/animation fields. The form does not keep an
ordinary active actor at player+594. It has its own controller protocol.

Damage helper **`10BE94`** receives an incoming scalar in f12. It resets/starts
flash state `+148/+154/+14C/+150` first. Then it only subtracts health when
**`+138 <= 0`**. Subtraction is clamped at zero; no common38540, armor reduction,
player+97C suppression or receiver return/reward contract appears here. It
emits an additional effect/display call `8C9C8(5A)`. The flash field is not the
HP admission timer: feedback can start even when health subtraction is blocked.

Protection `+138` decrements by one in controller input `10B9D4`, and is also
checked by firing logic `10A988`. Setter `10C7A0` reloads **4.5** from `23CA0C`.
Native controller-mode branches `D52F4/D538C` call it; one branch contains menu
creation/wait helpers. Its presentation-protection interpretation is INFERRED;
the positive gate and fire inhibition are OBSERVED. A reload of4.5 with unit
decrement cannot be called4.5seconds. Exact scheduling during menus/omissions
and the first eligible post-reset hit remain UNKNOWN.

Healing **`10C740`** converts integer a0 to float, adds to controller HP, caps
at100. `D6760` invokes it from an accumulator that retains fractional remainder
and delivers only positive integral units. This is a separate event-driven
healing path, not the automatic refill below.

# 3. Refill is a finite controller gate

`10C81C` checks terminal eligibility before refilling: if byte`+30=0` and
HP<=0, it enters3. It then uses `+394`:

- Counter<0 adds zero.
- Counter>=0 adds100/60 per controller call, then decrements counter by1.
- Health is capped100; setter `10C7B8` loads60, called via `D5A80`.

From an exact60 reset, the nonnegative branch admits61 calls (60 through0).
At each call the cap may discard excess; total intended healing is not inferred
by simply multiplying scalar by61. Initial counter0 similarly admits one call.
This is **not continuous100/60 recovery forever**. Exact script/event meaning
of `D5A80` and all resets remains UNKNOWN. Depletion enters the terminal state
before refill, so subsequently positive health does not itself undo that entry.

# 4. World contacts and enemy payload bridge

World-contact helper `10C188` queries `107208` with radius3 (`23C988`), constructs
collision displacement/normal and uses transformed vertical condition less
than-.5 (`23C990`). When contact cooldown`+158<=0`, it reloads **30** (`23C99C`)
and delivers scalar **10** (`23C994`) to `10BE94`. `10C81C` decrements`+158` once
per controller call. Ordinary player armor/suppression is bypassed, while the
separate `+138` gate still applies. A collision object's virtual response can
also be invoked with its own packet (type field3); response/motion and HP damage
are separate events.

Thus sustained qualifying world contact can produce one attempted hit per
30-controller-call cooldown, not necessarily one accepted HP decrement each
time. Controller/presentation invocation order can shift the first repeated
hit. World-contact labels (wall/floor/asteroid) require scene/object binding.

Damage bridge **`10C6EC`** reads incoming scalar from supplied packet `a2+4`
and invokes `10BE94`. Six direct native callsites:
`DDC24`, `DDE80`, `F8578`, `F9788`, `FBE0C`, `FCAE0`. The inspected `DDC24`
branch uses a squared-distance overlap test and packet at source record+40;
`FBE0C` uses configuration pointer+10. These establish additional source-owned
damage delivery, but all producer classes/scalars/cooldowns are not closed.
No universal source damage value is invented from the bridge.

# 5. Terminal sequence and clock ownership

Enter **`12E188`** sets controller byte`+30=1`, zeros state object timers`+4/+8/+C`,
invokes an effect and distance-conditioned visual creation. It does not subtract
ordinary player HP or invoke38540.

Update **`12E25C`** increments state timer`+4` by1 each call. Native constants:

| Condition | Effect |
| --- | --- |
| timer>=57 (`23CA24`) | `F3BC -> 117A0(8,0)`, global pending mode8 request |
| timer>30 (`23CA1C`) | Fade fraction `(timer-30)/25`, capped1; color/visibility/global fade helpers |
| 12<timer<=13 (`23CA18`) | Select animation0 through10A0AC |
| Every update | Clear firing/request state, zero blend field, return-1 |

At eligible-update cadence30/s, threshold57 is nominal1.9s; at60/s it is.95s.
This is a conditional clock prediction, not measured A0/C divergence: actual
controller scheduling/omitted updates must be recorded. The mode8 consumer's
retry/checkpoint semantics are still UNKNOWN in this report.

Presentation **`12E3B0`** uses state time to grow fractional effect-birth rates,
preserves remainder, emits through `F2634`, chooses randomized effect variants,
and decrements another accumulated visual quantity. Those visual births are
not more HP damage. Halving one timer or globally gating the model callback
would change other animation/emission/event contracts.

# Falsifiable measurement and exact remaining questions

Claude: fixed LEVEL15 scene/input and natural state; record controller root HP
float, mirrored player HP, max, +30/+64/+138/+158/+394 and callback ordinals,
displayed meter, damage source packet, and outer timestamps in A0/B/C.

1. One reproducible world contact: expected attempted scalar10, admitted only
   with138nonpositive; contact reload30 independent of common97C/armor.
2. Protection reset: correlate4.5 setter, menu/state, firing block and actual
   eligible-hit boundary; do not assume seconds.
3. Refill trigger: counter60 should select nonnegative recovery61 calls, capped;
   identify trigger and depletion-before-refill ordering.
4. Lethal packet/world hit: record state3 enter, HP ceiling/display, timer12/30/57,
   effect/animation/fade and pending mode8 to actual retry/checkpoint.

Static next: close six source producers/configuration payloads, global mode8
consumer, and D5A80 trigger registration. LEVEL21 source-specific verification
remains separate. No patch or parity acceptance is produced by this report.
