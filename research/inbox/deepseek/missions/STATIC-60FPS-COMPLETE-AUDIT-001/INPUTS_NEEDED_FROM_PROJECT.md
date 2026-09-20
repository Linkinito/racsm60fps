# Inputs useful for supervision and future ChatGPT review

The mission kit can start without all of these, but the following files greatly improve reliability.

## Highest priority

Please preserve or provide paths to:

1. The current active C1 patch/INI.
2. Definitions or historical files for A0/B0/B1/C1 if they exist as separate configs.
3. The current ~534-entry corpus/inventory.
4. Any Ghidra exports, symbol maps, disassembly maps or address databases.
5. Extracted PRX files from the ISO.
6. Any scripts already used to compare PRXs or identify duplicate functions.
7. Existing reports from previous missions.
8. Notes on known addresses and validated behaviors.
9. Any source code for helper tools used during reverse engineering.
10. A list mapping LEVEL_xx.PRX to level/location names, if available.

## Very useful

- Existing opcode patch lists.
- CSV files of classes/functions.
- Vtable dumps.
- Function signature/fingerprint lists.
- Call graph exports.
- Strings dumps.
- Known object layouts/field offsets.
- Cheat files from previous experiments.
- Logs showing which addresses were tested.
- A record of patches known to crash on level change.
- A record of patches already validated in specific levels.

## For ChatGPT supervision later

When returning results, the most useful compact bundle is:

- `coverage.md`
- `STATUS.md`
- `high_priority_findings.md`
- `shared_timing_architecture.md`
- `master_inventory.csv`
- `timing_mechanisms.csv`
- `patch_candidates.csv`
- 5–10 representative `objects/*.md`
- any file in which DeepSeek expresses uncertainty or conflicting hypotheses

If a candidate patch looks especially promising, also include:

- exact disassembly around the candidate;
- caller/callee context;
- module name;
- original opcode;
- candidate opcode;
- whether the code is duplicated in other PRXs.

## Important

Do not delete historical project files before the mission.

DeepSeek should have access to previous work so it can preserve validated discoveries rather than rediscovering them from scratch.
