# Targeted decompilation plan (2026-09-30)

Goal: an annotated Ghidra project of LEVEL_01 that makes fixed-step logic readable
and searchable, not a recompilable decompilation. Outputs stay local (copyright).

Status: the first bounded annotation/decompilation pilot is implemented and
TESTED for pipeline execution/preservation. Ten functions and two callsites are
covered; complete Pokitaru timing understanding and gameplay parity remain
UNKNOWN. Evidence: research/v2/targeted-decompilation-pilot-20260930/REPORT.md.
Reproduction: research/scripts/ghidra/README.md.

Existing assets (owner machine): Ghidra 12.0.4 with the Allegrex extension
(`AppData/Roaming/ghidra/ghidra_12.0.4_PUBLIC/Extensions/ghidra-allegrex`), Java 26.0.1, project
`C:/Users/linki/SIZEMATTERS60FPS.gpr` used for research/v2/ghidra-timing-findings-2026-09-20.md.
Application root: Downloads/ghidra_12.0.4_PUBLIC_20260303/ghidra_12.0.4_PUBLIC.
The Downloads path in the original draft was the separate extension distribution.

1. Provenance (completed for pilot): inspect the existing LEVEL_01 import first;
   original SHA256 d10a81d076fb44987a45314a020cda2f7e8b39f860b957911ca9365464676571,
   Allegrex, image base zero, 54,806 applied relocations and segment boundary
   +0x2DD108 confirmed. Source has zero defined functions. Copy only LEVEL_01
   to a local project; preserve source/original assets. Re-import only if needed.
2. Annotate by script (Ghidra Python/Java, committed under research/scripts/ghidra/):
   - class table (research/v2/class-table/level01-classes.json): name every update
     callback with replaceable `probable_<Class>_Update_<RVA>` aliases, preserve
     shared addresses, primary names and uncertainty of other descriptor roles;
   - field-definition strings -> configuration metadata; create pvar structure
     types only after offsets/layout are established by code/runtime evidence;
   - known engine functions: main update 0x1517C, pump 1 0x6B7F4, pump 2 0x6E6D4,
     player 0x2FFF0/0x2FB8C, navigation 0x28FFC..0x2A8F0, animation 0x76448/0x76AA4,
     particles 0x8CC18 + animators 0x7E810/0xDE23C/0xDE8A8, health 0x38700/0x312AC,
     shrapnel 0x191D7C, animated displacement 0x6C318;
   - source-path strings -> candidate namespaces (EFFECTS, ENGINE, ...), after
     binding their references; unimplemented in the first pilot.
   Completed pilot: 150 descriptors/469 function-slot aliases, ten Crab/nav
   functions. 0x29188/0x29334 are JAL callsites, never function entries. Next:
   identify their containing functions and displacement input producers; bind
   Crab counter resets/consumers. Preserve rejected first-run outputs locally.
3. Pattern search on decompiled P-code: counter++ compared to a threshold,
   pos += vel without delta, life -= const, float immediates 1/30, 30, 0.5.
   Output: per-class candidate list with sites -> research/v2/decomp-candidates/
   (now ignored). Current bounded scanner emits two candidates; delta/store/
   threshold tracing and full-class coverage remain pending. Matches are static
   candidates, not proven timing defects or absence of upstream delta scaling.
4. Use the list to drive live fixes (fixes.py) class by class, highest visibility first.
5. Port: function matching (Version Tracking / BSim) from LEVEL_01 to other
   LEVEL_xx modules produces candidate matches. Verify each module's instructions,
   data layout, argument contracts and live behavior before accepting a port.
