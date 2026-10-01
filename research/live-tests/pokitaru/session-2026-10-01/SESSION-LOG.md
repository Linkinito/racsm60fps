# Live session 2026-10-01 (Pokitaru, owner + Claude)

Environment: PPSSPP 1.20.4 Vulkan, InterpGate IG-v16f (lean, 7.8 KB PRX) as the only plugin.
Raw outputs (ignored): `raw/`. Evidence levels per docs/methodology/EVIDENCE_LEVELS.md.

1. IG-v15a (237 KB loaded) resident: loading Dayni Moon crashed PPSSPP (owner-observed).
   IG-v16f resident: Dayni Moon loads (owner-observed). Memory pressure INFERRED, not proven.
2. Tool fixes during the session: plugin signature ignores relocated j/jal bits; `spawn` and `clock`
   originals are relocated words (status was refused as MIXED until fixed; nothing written).
3. A0 + telemetry baseline near the crabs (`raw/baseline-a0-crabs.json`): 30.0 updates per game
   second; crab top speed 15.1 u/s; crab counter +0x64 reload 0.5 s (static theory 15 frames). OBSERVED.
4. C1 + nav,nav2 (telemetry): 60.0 updates/s; Ratchet attachments x1.0-1.2 vs A0; crab position
   x1.3 (behaviour noise); butterflies x2.00. Owner: crabs move at normal speed, attacks 2x early,
   butterflies too fast.
5. + crab (0x2CF3C8 27->54) + timer-patches Crab (29 words): owner: crab attack timing OK.
6. + butterfly fix + timer-patches Butterfly: new constants only affect butterflies initialised
   later; telemetry still x2.00 for existing ones.
   INCIDENT: a one-shot instance edit used moby+0x58 (wrong; butterfly data is moby+0x54) and halved
   35 words that were pointers (~1 min); all 35 restored from the recorded originals. Owner
   reported the game stable afterwards; later results of this session may still be affected.
   Re-done with moby+0x54 and strict value-range guards: 10 butterflies (20 values) halved ->
   telemetry x1.00 vs A0. 16 butterflies with another configuration (speed 0.025-0.04, flap 0)
   untouched. Owner: butterflies normal speed, game stable.
Open: crab stateTimer (+0x60) counts up; plugin records only upward reloads (durations not yet
measured). Instance edits need a guarded tool (class record offset from decompilation + ranges).
