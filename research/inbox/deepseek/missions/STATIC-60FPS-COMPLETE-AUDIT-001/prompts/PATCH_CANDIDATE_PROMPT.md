# PATCH CANDIDATE AGENT PROMPT

Consume mechanisms with:

- C1_EXPECTED_INCORRECT
- C1_EXPECTED_PARTIALLY_CORRECT

For each:

1. restate the causal timing mechanism;
2. identify root correction point;
3. determine whether correction should affect:
   - delta;
   - step;
   - tick duration;
   - cooldown;
   - loop multiplicity;
   - update frequency;
   - interpolation/damping coefficient;
   - another semantic variable;
4. derive exact candidate instruction/value if possible;
5. derive raw opcode if possible;
6. record shared scope;
7. enumerate side-effect risks;
8. provide at least one manual validation test.

Do not blindly:

- halve damage;
- halve every constant;
- replace 30 by 60 everywhere;
- halve interpolation coefficients;
- patch broad shared code without checking consumers.

Every output candidate status:

`UNVERIFIED_STATIC_CANDIDATE`

Never apply candidates to active project files.
