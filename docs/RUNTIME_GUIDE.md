# Runtime guide — testing corrections live

How to reproduce the 2026-09-30 experiments. Everything here writes emulated RAM
only; restarting the game restores the original code. Never modify the ISO.

## Requirements

- PPSSPP 1.20.x with the WebSocket debugger enabled (`RemoteDebuggerOnStartup`,
  default port 60907) and plugins enabled.
- Your own copy of the game (UCES00420).
- Python 3.12 on the host.
- For wrapper fixes: the `InterpGate` plugin built from
  `patches/experimental/interp-gate` (`python patches/experimental/interp-gate/build.py --name <new-name>`,
  requires the PSP SDK) and copied to `PSP/PLUGINS/InterpGate/`. Keep other
  plugins disabled (`UCES00420 = false` in their `plugin.ini`).

## Switching corrections

Stand in Pokitaru with the game running, then:

```text
python tools/runtime/fixes.py --target status --out <new dir>
python tools/runtime/fixes.py --target C1 --fix nav,crab --out <new dir>
python tools/runtime/fixes.py --target A0 --out <new dir>
```

`A0` is the original game (30 FPS); `C1` unlocks 60 FPS with the three-word core;
`--fix` adds corrections (`nav`, `crab`, `debris`, `particles`; `animdisp` is known
to freeze the game). Every word is verified before and after writing, the CPU is
paused during writes, and a JSON record is written to the output directory.
Keep raw outputs local (`research/live-tests/**/raw/` is ignored).

## Investigation tools

| Tool | Use |
|---|---|
| `fix-monitor.py` | numeric check of fixes: rates per game second, timer durations, hook calls, A0 baseline ratios (needs `--fix telemetry`) |
| `group-census.py` | list active pump-1 classes and instance counts |
| `crab-probe.py --rva <callback>` | find an entity of a class and list which fields change |
| `write-probe.py` | stop on writes to a field (`--address`, `--deref`, `--change`) and report the writing code |
| `call-probe.py --rva <function>` | stop at a function entry and report arguments and caller |
| `call-toggle.py --site <call>` | disable one call for a few seconds to see what it drives |
| `value-scan.py` | iterative float search in RAM (e.g. health) |
| `pump-gate.py`, `frametime.py`, `interp-gate.py` | the rejected global arms, kept for reproduction |

Static helpers in `research/scripts/`: `class-table.py` (class registration table),
`shared-helper-census.py` and `triage-helpers.py` (fixed-step helper search).
They read a local vanilla `LEVEL_01.PRX` that is never committed.
