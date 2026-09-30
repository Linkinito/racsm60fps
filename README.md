# Overcompensated — Ratchet & Clank: Size Matters at 60 FPS

Research project to run *Ratchet & Clank: Size Matters* (PSP, EU `UCES00420`)
at 60 FPS on PPSSPP **without changing how the game plays**.

> **Status: experimental research.** No release-quality 60 FPS patch exists yet.
> The 60 FPS core (C1) corrects Ratchet and most animations; six global
> approaches were tested in game and rejected; targeted corrections now fix the
> first enemy class completely (crab speed and attack timing) and work has
> started on the particle system. See [docs/FINDINGS_2026-09-30.md](docs/FINDINGS_2026-09-30.md),
> [docs/ROADMAP.md](docs/ROADMAP.md) and [CURRENT_STATE.md](CURRENT_STATE.md).

## The problem

The game was built around fixed 30 Hz logic. Unlocking the framerate is easy;
the problem is that many systems count *frames* rather than *time*, so they
simply run twice as fast: weapons, projectiles, enemies, timers, platforms,
elevators, particles, scripted events.

There is no single global speed value to fix. The engine mixes several timing
domains:

- an outer update loop, normally paced by two VBlank waits (30 Hz);
- a shared frame delta (≈ 1/30 s) passed to some consumers;
- a player update that runs **two substeps** per outer frame;
- hundreds of per-object callbacks with hard-coded per-frame constants.

Each level is a separate game module (`LEVEL_xx.PRX`) that is unloaded and
reloaded on every level change, which makes static cheat/`.ini` patches
impractical beyond the basic unlock.

## The approach

A **companion PRX plugin** loaded by PPSSPP next to the game. It detects which
level module is resident, verifies it by hash and by the original instruction
words, and applies guarded, reversible timing corrections. The original ISO
and game modules are never modified.

The current strategy (after the 2026-09-30 live tests):

1. Keep the whole game at 60 Hz with the three-word core (C1).
2. Correct fixed per-frame steps where they are applied, preferably once in a
   **shared engine helper** (ground navigation, shrapnel physics, particle
   animators), otherwise per class (e.g. an attack frame threshold).
3. Hot-switch between original 30 FPS (A0) and corrections while playing, and
   keep every correction reversible and documented.

Priority 0 is faithful 30 → 60 FPS behaviour. Quality-of-life features
(second analog stick, L2/R2, wider FOV closer to the PS2 games, new skill
points) come later and must stay separable from the core patch. See
[PROJECT_GOALS.md](PROJECT_GOALS.md).

## Repository layout

| Path | Contents |
| --- | --- |
| `docs/` | Documentation map, technical overview, methodology, legacy notes ([index](docs/README.md)) |
| `docs/fr/` | Owner-facing summary in French |
| `patches/experimental/` | Plugin sources and build scripts for experimental candidates (C1/D0/D1, recorders, companions) |
| `patches/validated/` | Empty until a correction meets the validation gate |
| `tools/runtime/` | PPSSPP debugger-API tools: observer, profile switch panels, probes, measurement scripts |
| `tools/prx/` | Offline PRX recipe tooling |
| `research/` | Evidence index, tasks, live-test reports, static maps (research branch only) |
| `reports/` | Consolidated analysis reports (research branch only) |
| `01-Travail-et-profil-PPSSPP/` | Legacy v0.4–v0.6 sources and notes, preserved for provenance (research branch only) |
| `cheats/` | Tested PPSSPP cheat files (public `main` branch) |

## Legal

This repository contains **no game files**: no ISO, no game PRX modules, no
save data, no memory dumps, no disassembly listings and no extracted assets or
text. You need your own legitimate copy of the game. The publication rules are
in [docs/PUBLICATION_POLICY.md](docs/PUBLICATION_POLICY.md).

*Ratchet & Clank* is a trademark of Sony Interactive Entertainment. This is an
unofficial fan research project, not affiliated with Sony, Insomniac Games or
High Impact Games.

## Contributing

Help is welcome, especially from people who know PSP reverse engineering,
MIPS, PPSSPP debugging, Ghidra or game timing systems. The project started
out of curiosity and is developed with the help of AI research assistants;
every finding is tested in PPSSPP and labelled with its evidence level
([docs/methodology/EVIDENCE_LEVELS.md](docs/methodology/EVIDENCE_LEVELS.md)).
