# Current checkpoint — 2026-10-03 (research ownership)

Priority0: UCES00420 original30 -> faithful60 parity; experimental only.
v2-research is local-only; main is curated public (allowlist). Verify HEAD on resume.
Verified HEAD: 365b574b1f23c30b4fb17262e5b3de8e6ff08f55.
Owner focus: the 13 weapons, 1:1 measured parity ("1:1 ou rien").

Owner decision: GPT owns decompilation/Ghidra annotations; Claude owns gameplay/A/B/C measurements.
DeepSeek is backup only (blocker, unavailable primary, justified second opinion); Luna is optional.
AGENTS/policies updated. No runtime/config change, backup launch or new experimental evidence.
Active log: research/live-tests/pokitaru/session-2026-10-02b/SESSION-LOG.md.
Summary: docs/WEAPONS_PARITY_2026-10-02.md.
Static map: research/v2/call-context-20261002/REPORT.md. Fixes: docs/FIX_CATALOGUE_2026-10-01.md.

## Measured 1:1 (TESTED, single location, frame-exact where stated)

- Blaster (id 2): `weapondt` cadence 4.133 vs A0 4.134 shots/s; `blastershot` speed 125.7 vs 125.9.
- Ryno (id 15): `animlat` cadence 30.08 @60 vs 15.0 @30 frames; `rynorocket` 23.94 vs 23.97 u/s.
- Tremblator (id 3): cadence `weapondt` 46.0 @60 vs 23.0 @30 frames.
- REJECTED: `rynorate`. Old "weapondt no effect": PPSSPP JIT keeps branch + delay slot;
  fixes.py now rewrites the preceding branch (jitRefresh).

## Open: Tremblator shock wave (A0: phase 3 at 13, gone at 14 frames @30 Hz -> 26/28 @60)

Best so far rayhalf + segfade 24.45/25.45; mode 3 23.4/24.4. Chain: BlitzGunShot records -> ray state
machine 0x5FACC (state 3 destroys, 0x11CCD4) -> segment animator 0x60100 (decrements ray count) +
ray particles 0xC9ED8 (life from table 0x2CE3E8 = 9/14, shared with record age check).
IG-v24 "30 Hz island" installed (blitzhalf at 30 Hz, raycb, segrate mode 3, original table).
NOT validly measured: runs 85-91 had PPSSPP in background (fps 25..200) -> INVALID.

## Static, end of session (INFERRED, measure before relying on it)

- Equipped weapon updates use substeps: per-call logic already correct at 60 Hz. Removed:
  frametimers 0x16D014 (ShieldCharger), frames30 0x11A1E0 (BlitzGun), three mixed-context Crossbow
  sites. `laser2`, `laserfadein`, `laserfadeout` are probable double corrections.
- Predictions for the 10 unmeasured weapons: research/v2/weapons-static-20261002/NOTES.md
  (weapondt needed: Bombglove, BeeMineGlove, Mootator; projectiles 2x fast: AgentOfDoom, BeeMine,
  ShockRocketShot, SuckCannonComet, NapalmBubble; rays: ShieldChargerBolt, CrossbowShot).

## Last recorded environment (not rechecked today)

PPSSPP 1.20.4 Vulkan; IG-v24 (sha256 331e1d7d…323b); fixes.py targets IG-v24.
Rollback IG-v19..v23: patches/experimental/interp-gate/build/.
Measurements require foreground PPSSPP and throttled polling. Fire: input.buttons.press/send, circle.
Ammo aid: set-ammo.py.

## Exact NEXT ACTION by primary

1. GPT: via research/EVIDENCE_INDEX.md locate existing Ghidra access/project and Tremblator evidence.
   Decompile/annotate 0x5FACC -> 0x60100 / 0xC9ED8; preserve provenance/tentative labels; prepare
   testable hypotheses for Claude. Ghidra access is UNKNOWN; no annotation performed today.
2. Claude: load Pokitaru, Tremblator, foreground window. Fire once (creates group), then
   `fixes.py --target C1 --fix weapondt,animlat,blitzhalf,raycb,segrate`; `ray-stats.py --seconds 30
   --autofire 2` (check valid=true). Target 26/28. Then A0 control (13/14).
3. Claude: next A0/C1 cadence via ryno-probe --lite --weapon N; projectiles via projectile-tracker
   --weapon N; GPT handles code analysis. CrossbowGun 9 and ShieldCharger 7 share the ray machine;
   then ShockRocket 8, Bombglove 4, BeeMine 6, AgentsGlove 5, Flamethrower 10,
   LaserTracer 11, SuckCannon 12, Mootator 13. Static notes: research/v2/weapons-static-20261002/.
4. Claude later: visual review of animlat outside weapons. GPT supplies targeted static analysis.
Next GPT files: AGENTS.md, CURRENT_STATE.md, research/EVIDENCE_INDEX.md; then indexed Ghidra
access instructions/ray-chain evidence only. Claude next: the active session log.
