# CROSS-CUTTING TIMING AGENT PROMPT

Analyze shared timing infrastructure across the game.

Focus on:

- shared delta producers/consumers;
- common update loops;
- internal multi-pass loops;
- physics helpers;
- animation helpers;
- timers;
- state counters;
- scheduler/event systems;
- projectile helpers;
- camera helpers;
- shared movement code;
- damage tick infrastructure.

Known landmarks include:

- shared/player timing chain around `0x1517C -> 0x88768`;
- object/runtime field historically discussed as `+0x578`;
- cross-level address/flag around `0x2B0208`;
- LaserTracer areas around `0x14CA70` and `0x148CEC`.

Do not assume these landmarks are universal.

Your job is to identify actual data/control flow.

Create implementation groups where many objects inherit the same timing logic.

For every shared mechanism, identify which inventory entries consume it where statically provable.

Do not propose a broad shared patch until hidden consumers and scope have been considered.
