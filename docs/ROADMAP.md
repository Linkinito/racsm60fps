# Roadmap

Priority 0 remains faithful 30 -> 60 FPS behaviour (see [../PROJECT_GOALS.md](../PROJECT_GOALS.md)).

## Next

1. **Particles**: test IG-v10 on the waterfall; enumerate all particle animators
   and correct each one once (waves, crate debris, fire, sparks).
2. **Annotated Ghidra project for LEVEL_01**: import the class table, field
   definitions, source-path grouping and every identified function (player,
   navigation, animation, particles, health). Script searches for fixed-step
   patterns (counter vs threshold, `pos += vel` without delta, `life -= 1`) to
   list corrections per class instead of discovering them in play. Output stays local.
3. **Enemies and objects of Pokitaru**: verify `nav` on TM robots and TrainingBot,
   then class by class with the crab method (census -> probes -> constant or
   helper fix), prioritised by what the owner sees.
4. **Weapons**: LaserTracer ammo drain (player weapon route), Blaster cooldown.

## Then

5. **Self-applying plugin**: apply C1 and validated fixes on module load without
   the debugger (reuse the guarded module-identity approach of D1).
6. **Other levels**: port fixes by function matching (the engine is duplicated in
   every `LEVEL_xx.PRX`); handle modules without a player substep loop (16–20).
7. **Measurements** for promotion to `patches/validated/` (A0 / C1 / fix timings).

## Later (optional, separate from the 60 FPS patch)

- Developer convenience: skip language menu and intro videos (FRONTEND module).
- Quality of life: second analog stick, L2/R2, wider FOV, new skill points.

Detailed Priority 2 workstream notes: [priority2/README.md](priority2/README.md).
