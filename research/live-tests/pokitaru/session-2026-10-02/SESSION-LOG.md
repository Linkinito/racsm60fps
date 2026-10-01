# Live session 2026-10-02 (Pokitaru, owner + Claude)

Environment: PPSSPP 1.20.4 Vulkan, clean boot, InterpGate IG-v17 + OCEnhance OCE-v1 (right stick only).
1. A0 + telemetry baseline near the crabs: crab state durations median 1.17 s, cooldown 0.50 s.
2. C1 + nav,nav2,crab,crabtimers: telemetry crab state duration x0.99, cooldown x1.00, position x0.86 (active).
   Owner: crab attack rhythm OK. -> `crabtimers` owner-accepted (clean boot, telemetry consistent).
3. OCE-v1 right stick yaw works (owner). Vertical look: writes to the target pitch +0xC8 are overwritten every
   frame by 0xB958 (write breakpoint), which copies the default 0x2AA40C. Writing 0.6 to 0x2AA40C raised the
   camera (pitch 0.26 after a while); restored to 0.0. OCE-v3 (built) moves that default with the stick.
4. Owner: camera turns 2x too fast at 60 FPS (expected); `camera` parity fix applied live for evaluation.
   R3 (assumed bit 0x4) did not work; L+R recentres yaw only, not pitch.
5. `camera` with the negative caps (0x3634, 0x37F8): owner: L and R correct speed. -> owner-accepted.
6. OCE: R3 confirmed as bit 0x4 (aliased to L+R it also crouched Ratchet -> OCE-v5 hooks the recentre 0x2C84).
   Vertical look via the default target only: target clamps but the view does not tilt while standing
   (auto-pitch follows only when moving); writing pitch + target together holds (~0.41 for 0.5) -> OCE-v5.
7. Crates, A0 baseline then C1 + accepted fixes + springs, spawn, particles-all: telemetry 2179 particle
   records corrected/s over 9 animators, spawn withheld 66 of 131 calls/s. Owner: crate debris still 2x,
   particle quantity like A0, rotations normal (butterflies OK), waves still 2x and MIST/SPLASHES MULTICOLOURED.
   -> particles-all REJECTED as is (halves packed colour words; debris records mostly skipped by the
   identity check; 0x7E810 records carry a per-particle update callback at +0, so motion lives in callbacks).
   `springs`, `spawn`: no regression seen (owner). particles-all disabled immediately.
8. OCE-v5 after restart: owner: R3 recentres without crouch, vertical look works -> owner-accepted.
9. Waterfall (+waterfall): owner: mist/splash quantity like A0, mist/splash speed 2x, water scroll 2x, no flicker/colour issue. wfscroll steps are not the visible water scroll (UNKNOWN source).
10. + frametimers, phases, clock: owner: bolts fly 2x, HUD hides 2x, teleporter animation 2x but teleporter
    DURATION normal (frametimers effective), help box unfold/fold 2x. Polling the five "HUD fade" phase variables
    while the HUD showed/hid: none changed -> those phase sites are not the HUD fades (labels were wrong).
11. + frames30, age70: owner: HUD hides after 2 s, normal speed (frames30 HUD sites effective); bolts still 2x;
    Blaster and "Canon Tremblator" fire interval too long; nothing broken. Bisect: age70 removed next.
12. Ammo: Blaster stock found live at module+0x2AEA4C (int, entry +0x40 from 0x1F71C); decrement 0x1168E8 via
    write breakpoint. `infammo` test aid: 9 `addiu -1` sites + LaserTracer 2 subu. Owner: infinite for Blaster,
    Tremblator (BlitzGun), BeeMine, Sniper Mine (CrossbowGun), LaserTracer; SuckCannon broke (excluded);
    Acidbomb uses another form (pending). age70 removed: Blaster still fires too slowly; Ryno ("TELT") now
    fires too fast. Bisect next: frames30 removed.
13. frames30 removed: Blaster still slow, Ryno ("TELT") still fast; SuckCannon stuck "ready to fire" (likely left
    by the first infammo set; reload expected to clear). infammo extended (AgentsGlove, Flamethrower, Ryno,
    ShieldCharger, ShockRocket); owner: infinite for all owned weapons except Acidbomb.
14. Blaster fire rate measured from ammo decrements while holding fire (10 s each):
    A0 4.2 shots/s (gap 0.25 s); plain C1 (no fixes) 2.0 shots/s (gap 0.50 s) -> C1 itself halves it, not a fix.
    Blaster_Update is called from P_Player_WeaponUpdate (0x1F2D0 jalr, f12 = its own f20 = entry f12) inside the
    player substep loop (return 0x2FCF8). `weapondt` (2 x delta into the weapon call, delay slot 0x2FCF4): still
    2.0 shots/s -> the cooldown (pvar+4 -= dt) is NOT the limiter. Next hypothesis: 0x39B74 (other delta consumer
    in the loop, possibly the shooting animation) -> `substepdt` (0x2FCE8) prepared, NOT applied/tested.
15. Session stopped by the owner: debugger round-trips slowed down and PPSSPP grew to ~14 GB of RAM (leak while
    debugging, cause UNKNOWN; restart PPSSPP before the next session).
