# Evidence Levels

## Purpose

Reverse engineering mixes direct observations, interpretation, experimentation, and uncertainty.

This document defines the vocabulary used throughout the project to distinguish those categories.

The status describes the strength and nature of the evidence.

It does not describe how confident a language model feels.

---

## OBSERVED

A directly recorded fact.

Examples:

- a function is called 60 times during a measured interval;
- address `0x0916DD20` contains a specific floating-point value;
- a memory location changes when an elevator moves;
- a PRX calls a specific function;
- a 30 FPS test takes 8.42 seconds;
- a trace contains a particular return address.

An observation does not automatically explain why the behavior occurs.

Example:

`OBSERVED: function X executes twice as many times at 60 FPS.`

This does not yet establish:

`function X causes the gameplay speed increase.`

---

## INFERRED

A technical interpretation derived from observations or code analysis but not directly demonstrated by experiment.

Examples:

- a counter appears to be a frame counter;
- a function probably updates an elevator;
- an offset appears to represent velocity;
- a call appears responsible for damage ticks.

An inference should include the evidence from which it was derived.

When reasonable, also record competing interpretations.

---

## CORROBORATED

An inference independently supported by multiple evidence sources.

Examples:

- static code analysis and runtime traces agree;
- two independent investigations reach the same result from the same raw evidence;
- a suspected timer correlates consistently with several gameplay measurements;
- separate levels expose the same underlying function behavior.

Corroboration increases confidence but does not necessarily establish causality.

`CORROBORATED` is not synonymous with `TESTED`.

---

## TESTED

A claim verified by a controlled and reproducible experiment.

A good test should identify:

- environment;
- input state;
- baseline;
- modification;
- expected result;
- observed result.

Example:

Baseline:

`30 FPS elevator duration = 8.42 s`

Unpatched:

`60 FPS elevator duration = 4.21 s`

Candidate correction:

`60 FPS patched duration = 8.43 s`

Repeated results consistent across multiple runs.

This may justify:

`TESTED: the candidate correction restores the original elevator timing.`

It does not necessarily justify broader claims about the entire timing architecture.

---

## UNKNOWN

Relevant information that is currently unresolved.

Use `UNKNOWN` rather than inventing an explanation.

Examples:

- exact purpose of a function unknown;
- structure ownership unknown;
- reason for a constant unknown;
- caller relationship not yet mapped.

Unknown information is valuable because it defines future research work.

---

## REJECTED

A previously plausible hypothesis contradicted by evidence.

Rejected hypotheses should normally be preserved.

Document:

- original hypothesis;
- why it appeared plausible;
- experiment or evidence that rejected it;
- replacement explanation, if known.

Example:

`REJECTED: global X controls camera interpolation.`

Reason:

Changing X modifies several gameplay systems but does not independently restore the 30 FPS camera behavior.

---

## SUPERSEDED

A historically useful description that has been replaced by a more precise explanation.

A superseded statement may have been partially correct.

Example:

Old description:

`0x0917AE40 = 2 hits/frame variable`

Later understanding:

`0x0917AE40 participates in weapon hit accumulation and was only indirectly observed through hit frequency.`

The old statement should not disappear.

Instead:

`SUPERSEDED by research/weapons/hit-accumulator.md`

---

## Confidence is separate from evidence status

Do not confuse:

`INFERRED — high confidence`

with:

`TESTED`

A highly convincing inference is still an inference.

Likewise:

`OBSERVED`

can be certain even if its meaning is completely unknown.

Recommended optional confidence field:

- `LOW`
- `MEDIUM`
- `HIGH`

Example:

`INFERRED / HIGH CONFIDENCE`

---

## Evidence priority

When evidence conflicts, prefer roughly this order:

1. reproducible controlled experiment;
2. direct runtime measurement;
3. deterministic code or binary analysis;
4. independently corroborated analysis;
5. single-agent interpretation;
6. intuition.

This ordering is not absolute.

A badly designed experiment may still produce misleading results, while static code analysis may conclusively establish some properties.

---

## Model agreement

Multiple language models agreeing does not constitute independent experimental evidence.

Model agreement may justify:

`CORROBORATED`

only when the agents independently analyze actual evidence and their reasoning can be checked.

If both agents rely on the same unsupported assumption, agreement adds little value.

---

## Promotion rules

Typical progression:

`UNKNOWN`

→ `OBSERVED`

→ `INFERRED`

→ `CORROBORATED`

→ `TESTED`

This is not mandatory.

Some findings can move directly from `UNKNOWN` to `TESTED` through a decisive experiment.

Other findings may permanently remain `INFERRED`.

---

## Documentation rule

Every important technical statement should make clear whether it is:

- something we saw;
- something we concluded;
- something we tested;
- something we do not know.

When in doubt, use the weaker status.
