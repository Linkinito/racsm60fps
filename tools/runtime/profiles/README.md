# Runtime observer weapon profiles

These profiles contain only fields whose storage width and arithmetic are
supported by the bounded Pokitaru static evidence. They do not prove that an
instance is active or assign a final gameplay meaning to a counter.

The four owner-facing profiles bind their own live object/pvar addresses:

| Profile | Automatically captured bases | Fields |
|---|---|---|
| `flamethrower` | object + pvar | object `+0x70`, pvar `+0x10` |
| `agents-glove` | pvar | pvar `+0x14/+0x40` |
| `acidbomb` | projectile object + its pvar | position `+0x30/+0x34/+0x38`, pvar integration/timers |
| `laser-tracer` | pvar + module | pvar `+0x08`, module `+0x2D2C4C` |

Normal use needs no address and no manual breakpoint:

```text
racsm> profile flamethrower
racsm> start
  ... use the weapon; wait for "[capture] STARTED" and keep playing ...
racsm> stop
```

`start` verifies the game/state, owns one temporary true stop-breakpoint,
captures the declared object/pvar registers on the first matching update,
removes the breakpoint, resumes PPSSPP, and only then starts free-running
sampling. `stop` finalizes CSV, NDJSON, manifest and summary files. Every start
performs a fresh binding, including after scene or savestate changes.

The older expert profiles remain available for backward compatibility and
manual inspection only. They require an explicit generic `entity` address:

| Profile | Required `entity` base | Fields |
|---|---|---|
| `flamethrower-object` | active Flamethrower object | float `+0x70` |
| `flamethrower-pvar` | active Flamethrower pvar | float `+0x10` |
| `agents-glove-pvar` | active Agents Glove pvar | floats `+0x14`, `+0x40` |
| `acidbomb-object` | one Acidbomb projectile object | float positions `+0x30/+0x34/+0x38` |
| `acidbomb-pvar` | pvar of that same projectile | float integration/timer fields `+0x08/+0x0C/+0x10/+0x14/+0x18/+0x34` |
| `laser-tracer-runtime` | active Laser Tracer pvar | float `+0x08` plus module float `+0x2D2C4C` |

## Internal binding provenance

No runtime object address is static across sessions. The automatic profiles
use these post-load stops and register bindings internally:

The following post-load stops avoid a separate pointer read. Add each RVA to
the module base printed by `status`:

| Class | Post-load stop RVA | Object register | Pvar register |
|---|---:|---|---|
| Flamethrower | `0x13B904` | `s0` | `s1` |
| AgentsGlove | `0x10FD6C` | `s0` | `s2` |
| Acidbomb | `0x107540` | `a0` | `s2` |
| LaserTracer | `0x148D28` | `s0` | `s1` |

Equivalent callback-entry RVAs are `0x13B8F0`, `0x10FD58`, `0x107534` and
`0x148CEC`; there, `a0` is the object and `[a0+0x58]` is its pvar. These details
are recorded in each capture manifest. Acidbomb's binding and capture begin on
the same live projectile, avoiding reuse of a stale projectile address.

Deliberately omitted:

- Flamethrower `+0x40`: 32-bit access is observed, but its base and exact
  meaning are not sufficiently established.
- Laser Tracer gate `module+0x2B0208`: the current bounded evidence does not
  establish a safe data type for the profile.
- AgentController fields: the current task does not yet prove the runtime
  Glove-to-controller instance edge.

Captures remain free-running samples after binding, not callback-synchronous
traces. The observer refuses automatic binding if another breakpoint already
exists, and records proof of removal/resume in the manifest.
