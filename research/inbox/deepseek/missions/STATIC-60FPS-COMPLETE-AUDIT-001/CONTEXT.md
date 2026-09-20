# Project Context

## Game

Ratchet & Clank: Size Matters  
Platform: PSP  
Region/build: UCES00420

Repository:

`C:\Users\linki\Documents\PPSSPP\RAC_60FPS`

## Objective

Create a 60 FPS implementation whose real-time gameplay behavior matches the original 30 FPS game as closely as possible.

This means preserving:

- movement speed;
- acceleration;
- gravity;
- jump behavior;
- glide behavior;
- camera motion;
- weapon fire rate;
- projectile speed;
- projectile lifetime;
- cooldowns;
- damage timing;
- damage-per-second behavior;
- enemy movement;
- enemy attacks;
- boss behavior;
- environmental mechanisms;
- timers;
- state transitions;
- animation timing;
- effects;
- scripted sequences;
- minigames;
- vehicles;
- menu/UI timing where gameplay-update dependent.

The project is not satisfied by "looks close enough".

## Reference configurations

### A0

Original 30 FPS reference behavior.

This is the semantic target.

### B0

60 FPS / VBlank unlock without timing corrections.

This exposes systems that are frame/update dependent.

### B1

B0 plus the known shared delta correction from approximately 1/30 to 1/60.

The historical player-related two-pass loop remains in its original form.

### C1

Current 60 FPS base patch.

Contains:

- B0;
- shared delta approximately 1/60;
- player/vehicle-related loop changed from two passes to one;
- no historical local ×2 scalar.

C1 improves Ratchet/player behavior and some animations but is NOT assumed globally correct.

Known residual symptoms include systems such as enemy movement and some attacks remaining too fast or otherwise desynchronized.

## Existing reverse-engineering landmarks

Previous work includes a player/shared-delta investigation around:

`0x1517C -> 0x88768`

The relevant callee was established around:

`0x88768`

rather than the earlier suspected `0x884A4`.

A relevant runtime/object field historically discussed is:

`+0x578`

Do not merge unrelated observations into a single timing mechanism without code evidence.

A cross-level flag/static address around:

`0x2B0208`

has also been investigated.

It must NOT be assumed to be a universal FPS selector.

LaserTracer is an important static case.

Known areas include approximately:

`0x14CA70`

and:

`0x148CEC`

Previous analysis suggests concepts equivalent to:

`rate = 30`

and:

`dt = 1 / rate`

This should be audited statically in full.

## Existing corpus

The project already contains an inventory of roughly 534 classes/objects/candidates.

This is the minimum starting corpus, not necessarily the full game.

Every original entry must survive into the final coverage accounting.

Newly discovered helpers, classes, timing systems and duplicated implementations must be added recursively.

## Core analytical principle

Whenever possible model a real-time mechanism as:

`real_time_rate = calls_per_second × work_per_call`

or an appropriate extension of that model.

A single class can contain multiple independent timing mechanisms.

Example:

- movement may use a fixed per-call step;
- animation may use shared dt;
- attack cooldown may be a frame counter;
- damage may trigger from a state or collision callback.

Do not classify only at class level.

Classify mechanisms.
