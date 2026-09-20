# LASERTRACER STATIC DOSSIER PROMPT

Perform a dedicated static audit of LaserTracer.

Known areas of interest:

`0x14CA70`
`0x148CEC`

Previous analysis suggests concepts approximately equivalent to:

`rate = 30`
`dt = 1 / rate`

Investigate:

- origin of rate;
- whether constant or conditional;
- representation of dt;
- storage;
- lifetime;
- consumers;
- callers;
- update path;
- relation, if any, to `0x2B0208`;
- whether it uses shared timing;
- A0/B0/B1/C1 predicted behavior;
- theoretical real-time multiplier where defensible;
- C1 verdict;
- one or more static candidate corrections if C1 is predicted incorrect;
- risks of each candidate;
- manual validation protocol.

Do not generalize the result to unrelated systems without evidence.
