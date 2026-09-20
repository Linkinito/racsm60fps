# SKEPTIC / AUDITOR PROMPT

Audit high-value findings.

Priority:

- P0;
- P1;
- shared/core patches;
- CONFIRMED_STATIC;
- STRONG.

Attempt to falsify conclusions.

Check:

- Is call frequency actually proven?
- Is the timing constant semantically identified?
- Is render code being confused with game-state code?
- Does B1/C1 truly affect this data path?
- Could the function execute multiple times per frame?
- Does a shared helper have additional consumers?
- Is an apparently local mechanism actually global?
- Is a proposed ×0.5 correction mathematically valid?
- Is interpolation/damping exponential?
- Does doubling a tick count preserve semantics?
- Are module/address pairs correct?
- Are two candidates actually the same root cause?
- Would a candidate break a system already corrected by C1?

Output:

- accepted findings;
- downgraded findings;
- rejected findings;
- required follow-up;
- revised confidence.
