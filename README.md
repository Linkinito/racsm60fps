# Overcompensated — Ratchet & Clank: Size Matters at 60 FPS

Research project to run *Ratchet & Clank: Size Matters* (PSP, EU `UCES00420`)
at 60 FPS on PPSSPP **without changing how the game plays**.

> **Status: experimental research.** No release-quality 60 FPS patch exists yet.
> Individual corrections have been measured on a few objects; a first global
> candidate (D1) is built but has not passed its first in-game acceptance test.
> See [docs/DEVELOPMENT_STATUS_2026-09-23.md](docs/DEVELOPMENT_STATUS_2026-09-23.md)
> and [CURRENT_STATE.md](CURRENT_STATE.md).

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

The current strategy (see
[reports/60FPS-STRATEGY-REVIEW-2026-09-27.md](reports/60FPS-STRATEGY-REVIEW-2026-09-27.md)):

1. Build one **broad, inferred** global timing profile (D1) from the existing
   engine knowledge and the legacy dispatcher.
2. Play the game while hot-switching between original 30 FPS (A0) and the
   candidate, and record discrepancies.
3. Turn each measured discrepancy into a documented local exception.

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
