# STATIC-60FPS-COMPLETE-AUDIT-001

## Mission type

Exhaustive static audit + static pre-patch candidate generation.

No runtime access is assumed.

## Mission objective

Analyze the entire game statically and determine everything whose real-time behavior can differ between A0 at 30 FPS and C1 at 60 FPS.

For every object/system/function, determine:

1. what it does;
2. how it updates;
3. what timing mechanism(s) it uses;
4. how A0 behaves;
5. how B0 is expected to affect it;
6. how B1 is expected to affect it;
7. how C1 is expected to affect it;
8. whether C1 is likely correct, incorrect, partially correct, unaffected, or statically ambiguous;
9. whether a plausible static candidate correction exists;
10. what manual runtime test would validate or reject that candidate.

## Coverage

Start from the existing ~534-entry corpus.

Every original entry must receive a terminal status.

Discover and recursively add:

- helper functions;
- shared update infrastructure;
- additional classes;
- duplicated level implementations;
- per-level variants;
- common physics helpers;
- common animation helpers;
- timers;
- state-machine infrastructure;
- projectile logic;
- camera logic;
- script timing;
- event scheduling;
- UI timing where update-frequency dependent.

Mission completion requires:

`UNEXAMINED = 0`

## Allowed terminal object statuses

- TIMING_RELEVANT
- TIMING_RELEVANT_MULTI_MECHANISM
- INHERITS_SHARED_TIMING
- FRAME_DEPENDENT
- CALL_FREQUENCY_DEPENDENT
- RENDER_ONLY
- DATA_ONLY
- WRAPPER_ONLY
- ALIAS_OF_OTHER_ENTRY
- NO_TIMING_LOGIC_FOUND
- PROBABLY_UNAFFECTED
- STATICALLY_AMBIGUOUS
- DEAD_OR_UNUSED
- UNRESOLVED_BINARY
- MISSING_IMPLEMENTATION

`UNEXAMINED` is allowed only while work is in progress.

## Timing mechanism taxonomy

Use as starting categories:

- DT_SHARED
- DT_LOCAL
- RATE_LOCAL
- STEP_PER_CALL
- TIMER_TICKS
- COUNTDOWN_PER_CALL
- COOLDOWN_TICKS
- STATE_TICKS
- LOOP_MULTIPLIER
- CALL_FREQUENCY
- ANIMATION_STEP
- MOVEMENT_STEP
- PHYSICS_STEP
- DAMAGE_TICK
- FIRE_RATE
- PROJECTILE_STEP
- PARTICLE_STEP
- CAMERA_STEP
- INTERPOLATION
- SCRIPT_WAIT
- EVENT_INTERVAL
- RENDER_ONLY
- MIXED

Add new categories when required by evidence.

## Per-mechanism analysis

For every timing-relevant mechanism record:

- object/class;
- function;
- module/PRX;
- address/range;
- vtable slot where relevant;
- callers;
- callees;
- relevant globals;
- relevant object fields;
- constants;
- producer;
- consumer;
- semantic role;
- timing implementation;
- expected A0 behavior;
- expected B0 behavior;
- expected B1 behavior;
- expected C1 behavior;
- theoretical multiplier when statically defensible;
- C1 verdict;
- candidate patch IDs;
- confidence;
- unresolved assumptions.

## C1 verdicts

- C1_EXPECTED_CORRECT
- C1_EXPECTED_INCORRECT
- C1_EXPECTED_PARTIALLY_CORRECT
- C1_PROBABLY_UNAFFECTED
- C1_STATICALLY_UNKNOWN

## Static prediction labels

- EXPECTED_A0_REFERENCE
- EXPECTED_2X
- EXPECTED_1X
- EXPECTED_0.5X
- EXPECTED_PARTIAL
- EXPECTED_CHANGED_BUT_RATIO_UNKNOWN
- EXPECTED_UNAFFECTED
- STATICALLY_UNKNOWN

Do not invent numeric multipliers when call frequency cannot be proven.

## Candidate patch rule

Every proposed correction is:

`UNVERIFIED_STATIC_CANDIDATE`

Candidate types may include:

- CANDIDATE_SHARED_DT
- CANDIDATE_LOCAL_DT_HALF
- CANDIDATE_RATE_30_TO_60
- CANDIDATE_STEP_HALF
- CANDIDATE_DURATION_TICKS_DOUBLE
- CANDIDATE_COOLDOWN_TICKS_DOUBLE
- CANDIDATE_LOOP_2_TO_1
- CANDIDATE_UPDATE_DIV2
- CANDIDATE_DAMAGE_TICK_RATE
- OTHER_EXPLAINED_CANDIDATE

Prefer root-cause corrections over symptom compensation.

Examples:

- If damage doubles because damage ticks happen twice as often, do not blindly halve damage.
- If damping is multiplicative, do not blindly divide the coefficient by two.
- If interpolation is exponential, derive or flag the mathematically equivalent coefficient.
- If a timer is frame-count based, doubling its duration may be semantically better than halving unrelated behavior.

## Patch candidate fields

For every candidate provide when derivable:

- candidate ID;
- mechanism ID;
- module;
- address;
- original instruction/value;
- original opcode;
- proposed instruction/value;
- proposed opcode;
- conceptual change;
- expected C1 effect;
- shared scope;
- risks;
- confidence;
- alternative candidate(s);
- manual validation test.

## No automatic patch application

Do not modify:

- active cheat files;
- C1;
- PRX binaries;
- executable;
- ISO.

Do not apply generated candidates.

An optional commented/disabled candidate INI may be produced for human inspection only.

## Multi-mechanism requirement

Never assume one object equals one timing problem.

An object can contain separate mechanisms for:

- movement;
- animation;
- cooldown;
- state progression;
- damage;
- effects;
- physics;
- camera.

Each needs its own mechanism row when distinct.

## Special domains

### Weapons and attacks

Separate:

- animation;
- firing eligibility;
- cooldown;
- projectile creation;
- projectile motion;
- lifetime;
- impact;
- damage;
- repeated damage;
- ammo consumption.

### Movement

Separate:

- position integration;
- velocity;
- acceleration;
- gravity;
- friction;
- steering;
- rotation/turn rate;
- path progression;
- collision-sensitive behavior.

### Camera

Inspect:

- smoothing;
- recentering;
- acceleration;
- interpolation;
- rotation;
- shake;
- recoil;
- scripted transitions.

### Scripts/state machines

Look for:

- frame waits;
- tick counters;
- repeated polling;
- update-count-dependent state transitions;
- scripted movement steps;
- event intervals.

### Physics/interpolation

Do not use naive ×0.5 compensation for multiplicative/exponential behavior.

## LaserTracer

Perform a dedicated dossier around approximately:

`0x14CA70`
`0x148CEC`

Investigate the apparent local:

`rate = 30`
`dt = 1 / rate`

Determine:

- source;
- storage;
- consumers;
- callers;
- update assumptions;
- relation, if any, to `0x2B0208`;
- A0/B0/B1/C1 model;
- C1 verdict;
- candidate correction if appropriate.

## Completion gate

The mission is complete only when:

- every inventory entry is terminally classified;
- every discovered dependency is processed or explicitly unresolved;
- every timing-relevant entry has mechanism records;
- every mechanism has A0/B0/B1/C1 analysis;
- every mechanism has a C1 verdict;
- every expected incorrect/partial C1 mechanism has a candidate or explicit reason none can yet be derived;
- high-priority candidates have manual test notes;
- coverage audit has no silent omissions;
- `UNEXAMINED = 0`.

Do exhaustive work.
Do not optimize for speed.
Do not stop at obvious cases.
