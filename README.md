# Ratchet & Clank: Size Matters - 60 FPS Research Project

This is an experimental research project about making *Ratchet & Clank: Size Matters*, developed by the now-defunct High Impact Games studio, run at 60 FPS on PPSSPP.

For many years, players have wondered if a proper 60 FPS patch for this game was possible. Unlike many PSP games, *Size Matters* does not become playable at 60 FPS by changing one simple value or unlocking the framerate. Most attempts make the whole game run at double speed.

This project started mostly out of curiosity: could a 60 FPS patch be made for a game that has resisted a proper solution for almost 20 years?

## About this project

I am not a reverse engineering expert. I only know some basics of coding, and very little about MIPS assembly, PSP internals, or low-level game patching.

This is mostly a "for fun" and learning-oriented project. The goal is to understand how the game works, why it breaks at 60 FPS, and whether a playable patch can realistically be built.

ChatGPT 5.5 is being used as a research assistant to help:

- read and interpret disassembled MIPS code;
- compare similar routines across level files;
- identify likely timing, physics, animation, and update logic;
- document findings;
- convert discoveries into PPSSPP cheat codes or patch notes;
- automate some of the reasoning and research workflow.

All findings are manually tested in PPSSPP.

## Current status

A basic 60 FPS patch has been successfully tested on several levels.

The current base patch usually involves:

- bypassing the level-specific 30 FPS limiter;
- changing the main frame delta from 1/30 to 1/60;
- reducing the player update loop from 2 iterations to 1.

This makes the main player movement run at the correct speed in some levels.

However, the game was clearly built around a fixed 30 FPS logic. Many secondary systems still run too fast or desync, including weapons, projectiles, enemies, boost timers, traps, item pickup animations, crate debris, and some scripted events.

So this is not a finished 60 FPS patch yet. It is an ongoing research project.

## Why this is difficult

*Size Matters* seems to use many independent frame-based systems. Even when the main player movement is fixed, other parts of the game may still assume that one frame equals one 30 FPS tick.

This means that a full 60 FPS conversion is not as simple as changing one global value. Some parts may need individual fixes, level-specific patches, or deeper binary modifications.

## Repository goal

This repository is meant to:

- document the research;
- share tested PPSSPP cheat codes;
- track known issues;
- help other people understand the problem;
- maybe attract people with more reverse engineering experience.

This is not intended to include any copyrighted game files, PRX files, ISO dumps, or decompiled source code.

Only research notes, patch descriptions, and cheat codes should be shared here.

## Legal note

This project does not provide the game, game assets, PRX files, or ISO files.

You must own a legitimate copy of *Ratchet & Clank: Size Matters* to test anything from this repository.

## Contributions

Help is welcome, especially from people familiar with:

- PSP reverse engineering;
- MIPS assembly;
- PPSSPP debugging;
- Ghidra;
- binary patching;
- game physics and timing systems.

This project is still experimental, messy, and incomplete, but that is also what makes it interesting.
