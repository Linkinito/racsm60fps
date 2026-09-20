## Full technical report — `TIMING-ATLAS-GLOBAL-001` (DeepSeek Mapper)

Role note: this report covers the **Mapper** deliverables (dispatcher map, descriptor/function-pointer structures, cross-level homology, scanner specification, cadence-unknowables). It does not claim to be the Explorer inventory or the Skeptic review. Every claim below is labelled; `OBSERVED` = I decoded it from the raw PRX in this session.

### 0. Method, tooling limits, and what was actually measured

No Python, Node, Capstone, Ghidra, or *any* .NET method call is available on this host: the shell runs Windows PowerShell 5.1 in `ConstrainedLanguage`, `Get-FileHash`, `BitConverter`, `Encoding`, `New-Object`, and `pwsh.exe` are all blocked. `certutil` and `Get-Content -Encoding Byte` work.

I therefore implemented, in this session:

- an ELF32 section parser (section headers at `e_shoff`, `.text`/`.data`/`.rodata`/`.rel.*`), 
- a hand-written MIPS32 decoder (I, J, R, COP1 formats; I found and corrected a COP1 fs/fd field confusion before drawing any dataflow conclusion),
- alignment-filtered byte-pattern scanners over full sections.

All addresses are **unrelocated module RVAs**. For every module, the whole loadable image is one PT_LOAD with `file_offset = vaddr + 0x74`, so the reader applies `file = rva + 0x74`; this was verified on several sections, not assumed.

`LEVEL_01` corpus file: sha256 `d10a81d076fb44987a45314a020cda2f7e8b39f860b957911ca9365464676571`, size 3,444,725 (matches the documented vanilla hash).

### S1. Dispatcher map — LEVEL_01

**S1.1 The level frame update and its delta fan-out (`0x1517C`)** — `OBSERVED`

Decoded instruction evidence:

```
0151E0: 3C043D08   lui a0,0x3D08
0151E4: 34848889   ori a0,a0,0x8889      ; 0x3D088889 ~ 1/30
0151E8: 0C0221DA   jal 0x88768
0151EC: 4484A000   mtc1 a0,f20           ; delta into callee-saved f20
...
01521C: 4600A306   mov.s f12,f20   <- delay slot of jal 0x87A84   (0x15218)
015234: 4600A306   mov.s f12,f20   <- delay slot of jal 0x6B7F4   (0x15230)
015264: 4600A306   mov.s f12,f20   <- delay slot of jal 0x2FFF0   (0x15260)
01526C: 4600A306   mov.s f12,f20   <- delay slot of jal 0x6B618   (0x15268)
```

`0x4600A306` decodes as COP1 fmt=S, `fd=f12`, `fs=f20` → **`mov.s f12,f20`**. This independently reproduces the accepted four-consumer fan-out (`0x87A84`, `0x6B7F4`, `0x2FFF0`, `0x6B618`) and confirms `mtc1 a0,f20` at `0x151EC`.

**S1.2 Who calls the frame update — `OBSERVED` (new)**

A full `jal` census (20,458 `jal` sites in `.text`) gives **exactly two** callers of `0x1517C`: `0x15AA8` and `0x15B18`. Both are inside the region `0x15A00–0x15BA0`:

```
015AA8: jal 0x1517C ; 015AB0: jal 0x156DC
015AC8: lw a1,0x6F00(a0) ; addiu a1,a1,1 ; sw a1,0x6F00(a0)   ; frame counter++
015B18: jal 0x1517C   (reached only after jal 0xAA330 ; beq v0,zero)
```

There is **no `jal` anywhere in `LEVEL_01` targeting `0x15A00–0x15B70`**. The region is instead addressed by a **relocated function-pointer table in `.rodata`** (`.rodata` vaddr `0x1C02C8–0x1C02F0`, file offsets `0x1C033C–0x1C0364`) whose entries are `0x15A80, 0x15A98, 0x15AA0, 0x15AA8, 0x15AD8, 0x15B08, 0x15B38, 0x15B50, 0x15B68, 0x15B80, 0x15B98`.

Consequence for the atlas: **the level simulation entry is state-table dispatched, not statically reachable by a `jal` chain.** The frame update runs once per entry into the selected state-table function. Cadence cannot be inferred from the call graph alone (see S9, item 1).

**S1.3 Frame limiter / VBlank structure (`0x96490`)** — `OBSERVED` (new, and it corrects the received model)

`0x96490` is a real function prologue (`addiu sp,sp,-48`; `a0` masked `ANDI a0,0xFF`) and has **exactly one caller in the whole module: `0x94B38`**. The limiter block inside it:

```
096620: lbu a0,0x6E50(s4)      ; global gate byte 0x2B6E50
096624: beq a0,zero,16->       ; gate == 0 -> skip the entire limiter
09662C: jal 0x1BF424           ; sceDisplay stub: VBlank wait
096634: lui s0,0x002B
096638: jal 0x1BF42C           ; sceDisplay stub: vcount-like read
096640: lw a0,0x6E58(s0)       ; stored vcount  (0x2B6E58)
096644: addiu a0,a0,1
096648: bne v0,a0,3->          ; if (vcount != stored+1) i.e. a vblank was missed
096650: jal 0x1BF424           ; <<< historical B0 NOP site: CATCH-UP wait
096658: jal 0x1BF42C
096660: sw v0,0x6E58(s0)
```

So the historical "conditional second `sceDisplayWaitVblankStart`" is **not** a second mandatory wait: it is a *catch-up* wait taken only when the previous frame consumed more than one vblank. Removing it (`B0`) removes the catch-up, which is exactly the mechanism by which the outer loop is allowed to free-run faster. The gate byte `0x2B6E50` (writes at `0x965F4`, `0x9661C`) can disable the whole limiter block.

**S1.4 sceDisplay stub callers — `OBSERVED`, corrects a prior count**

Section `.sceStub.text.sceDisplay` is RVA `0x1BF414`, size `0x28` = **5 stubs of 8 bytes**: `0x1BF414, 0x1BF41C, 0x1BF424, 0x1BF42C, 0x1BF434`. `LEVEL_01` contains **13 `jal` sites into that section**, not six:

| stub | call sites |
|---|---|
| `0x1BF414` | `0x1B61BC` |
| `0x1BF41C` | `0x1B6180` |
| `0x1BF424` (wait) | `0x209A4`, `0x20BC0`, `0x24344`, `0x87818`, `0x94648`, `0x9662C`, `0x96650` |
| `0x1BF42C` (vcount) | `0x877C4`, `0x96638`, `0x96658` |
| `0x1BF434` | `0x87554` |

The prior "six callsites" figure was probably restricted to the `0x96xxx` cluster. Any homology or patch reasoning based on "one sceDisplay call per module" must be rebased on the specific stub (`0x1BF424` here) resolved per module.

**S1.5 Player chain — re-verified (`OBSERVED`)**

`0x2FFF0` (called from `0x15260` with the shared delta) contains `mov.s f20,f12` at `0x30024` (`0x46006506` → `fd=f20, fs=f12`), i.e. the wrapper immediately re-saves the delta into callee-saved `f20`; it calls `0x2FB8C` at `0x300F4`. `0x2FB8C` contains `mov.s f20,f12` at `0x2FBBC` (`0x46006506`, the historical "D" patch site), `sltiu a0,s1,1` at `0x2FCB0`, `sb a0,0x208(s2)` at `0x2FCB4` with `s2 = lui 0x002B` (→ flag `0x2B0208`), the seven-call body, `slti a0,s1,2` at `0x2FCFC`, and the post-loop `ori a0,zero,1 / sb a0,0x208(s2)` at `0x2FD08/0x2FD0C`. Delay slots `0x2FCE8` and `0x2FCF4` are both `mov.s f12,f20` (feeding `0x39B74` and `0x1EBC4`).

**S1.6 Weapon dispatch — re-verified (`OBSERVED`)**

```
01F2A0: lw a1,0x40(a0)     ; weapon object +0x40
01F2AC: lw a1,0x1C(a1)     ; +0x1C = current update callback
01F2C8: (reload) lw a1,0x1C(a1)
01F2D0: jalr ra,a1
01F2D4: 4600A306 mov.s f12,f20   ; contract: a0=weapon, f12=delta
```

**`0x1EBC4` (Player_WeaponUpdate) has three callers: `0x1E4E8`, `0x1E610`, `0x2FCF0`.** It is *not* called exactly once per outer frame.

**S1.7 Indirect-call census — `OBSERVED`**

`LEVEL_01` contains **277 `jalr`** sites. Method-slot histogram of the pointer loaded immediately before the `jalr` (offset of the `lw` that produced the call register):

| slot | sites | meaning (INFERRED) |
|---|---|---|
| `0x20` | 26 | most common virtual method — candidate "per-tick update" |
| `0x00`/`0x10` | 16 / 16 | callbacks stored at object+0 / via descriptor+0x10 block |
| `0x04` | 13 | |
| `0x1C` | 8 | **weapon update (confirmed)** |
| `0x0C` | 8 | |
| `0x18` | 7 | |
| `0x28` | 7 | reached as `desc+0x10 → +0x28` |
| `0x14` | 6 | |
| `0x08` | 5 | |
| other | 1–3 each | `0x2A5C`, `0x3C`, `0x48`, `0x54`, `0x84`, `0x94`, `0x188`, `0x7F0`, `0x7F4`, `0x994`, `0x2028`, `0x202C`, `0x9500`, `0xA298`, `0xE0`, `0xF21C`, `0xF220`, `0xFA0` |

**S1.8 State-machine dispatchers — `OBSERVED`**

- `0x1AD1F0–0x1AD710`: 20 `jalr` sites whose target comes from `lw a2,0x10(sp)` / `lw s2,0x10(sp)` — i.e. **a jump table held on the stack** (a switch/state machine, event/state driven). `0x2FFF0` calls `0x1ADA9C` with `a2 = 0x28`, adjacent to this region.
- `.rodata` tables of relocated code pointers (S1.2, S2.2) are further phase dispatchers.

**S1.9 Entity pump — `OBSERVED` (new)**

At `0x6EBE4–0x6ED00` (manager region `0x6E…`):

```
06EBE4: lw a2,0xC(a2)
06EBE8: lw a0,0x68(a2) ; andi a0,a0,0x1 ; beq a0,zero,3->
06EC08: addiu a2,a2,248          ; stride 0xF8 walk
06EC4C: lw a1,0x4(a2) ; andi ... 0xFFFFFF7F ; jal 0x769F4
06EC68: lw a0,0xD4(a2) ; beq a0,zero,8-> ; lw a1,0xD8(a2) ; jalr a3
06ECA4: lw a1,0xE0(a0) ; beq a1,zero,4-> ; jalr a1
06ECD8: lw a0,0xDC(a0) ; beq a0,zero,4-> ; jalr a1
```

i.e. **a per-frame walk over `0xF8`-byte records with an `andi 0x1` state test, dispatching three indirect callbacks (`+0xD4/+0xD8`, `+0xDC`, `+0xE0`)**. Other iteration strides found by the jalr→loop scan: `0x80` (`0x6B204`, `0x6EB…`), `0x50` (`0x6B388`, `0x6B5B8`, `0xFAFA4`, `0x108B78`, `0x1774A4`), `0x4C` (`0x1093B0`), `0xFA0`/`0xF90`/`0xF60`/`0x5E8`/`0x1C40`, and `0x158`/`0x460`/`0x95`/`0x49` in other subsystems.

### S2. Descriptor / function-pointer structures

**S2.1 Object → class indirection — `OBSERVED`**

`LEVEL_01` has **1,388** `lw rX,0x40(rY)` instructions. The recurring chains are:

```
lw a0,0x40(obj)            ; class descriptor
lw a1,0x4(a0)              ; -> array of 0x10-byte records
lbu a2,0x44(obj)           ; obj+0x44 = byte index
sll a3,a2,4 ; addu a0,a0,a3
lw a1,0x10(desc)           ; -> sub-block
lw a1,0x3C(a1) ; andi a1,a1,0x800|0x10|0x8|0x2|0x2002   ; flag words
lw a1,0x30(desc) ; compare against 32-bit class IDs (e.g. 0x00B90E7A60, 0x4B6F098C)
lw a0,0x20(desc) ; jalr                                    ; method slot
```

Additional observed object fields: `+0x44` byte index, `+0x48` sub-object pointer, `+0x4B` byte state (compared to `0x1`, `0x4`, `0x5`…), `+0x59C` current weapon (from `0x1EBC4`), `+0x68` flag word, `+0x64`, `+0x95C`.

**S2.2 Relocated pointer records in `.data`/`.rodata` — `OBSERVED`**

`LEVEL_01`: `.rel.data` 1,860 entries, `.rel.rodata` 1,680 entries, all type `2` (`r_info & 0xFF == 2`, i.e. `R_MIPS_32`). Reading the word at each `r_offset` gives the target RVA directly (2356 of them point into `.text`). Examples that anchor the atlas:

- **Weapon name table**, stride `0x58`, name pointer at record+0 into `.rodata`: `0x2AEA0C→'blaster'`, `0x2AEA64→'blitzgun'`, `0x2AEABC→'bombglove'`, `0x2AECCC→'flamethrower'`, `0x2AED24→'lasertracer'`, `0x2AEE84→'ryno'`, `0x2AF19C→'boxbreaker'`, `0x2AF22C→'TRACKREEL'`.
- **Class records**, name at +0, three function pointers at +0x04/+0x08/+0x0C, a field-description string pointer at +0x14: `0x2CF444→'Crab'`, `0x2CEBC0→'BreakableObject'`, `0x2D1914→'Fire'`, `0x2D1A58→'Flamethrower'` (callback `0x2D1A64→0x13B8F0`), `0x2D414C→'LaserTracer'` (`0x2D4150→0x148A70`, `0x2D4154→0x148B64`, `0x2D4158→0x148CEC`, `0x2D417C→0x149184`, `0x2D4194→0x14927C`), **`0x2D51B4→'Lvl3Elevator'`** (`0x2D51B8→0x1562DC`, `0x2D51BC→0x155DCC`, `0x2D51C0→0x156710`, field string at `0x2D51C8` = `"CurveLink path; f32 moveTime; f32 progress; f32 progInc; f32 wai…"`), `0x2D6128→'Ratchet'`, `0x2D8030→'Teleporter'`, `0x2D85A4→'TitaniumBolt'`, `0x2D91E0→'TrainingBot'`.
- **LaserTracer class ID candidate**: `.data` word `0x4996B438` at `0x2D41D0`, inside the same record cluster — consistent with the "descriptor+0x30 compared against a 32-bit class ID" pattern. INFERRED, not proven.
- **State tables in `.rodata`** (function pointers, 4-byte aligned, contiguous): e.g. `0x1C02C8…0x1C02F0 → 0x15A80…0x15B98` (level states), plus the other clusters listed in the earlier reloc dump.

**S2.3 Indirect handlers with no direct caller — `OBSERVED`, independently reproduced**

- `0x148CEC` (**LaserTracer update**): **0 direct `jal`**; reached only through the relocated word at `.data 0x2D4158`.
- `0x14CA70` (**tracer rate initializer**): **0 direct `jal`**; only the raw word `0x0014CA70` at file/vaddr `0x2DD1F8`.
- `0x96490`: 1 direct caller (S1.3).

The previous cross-level Mapper's core claim ("`0x148CEC` is pointer-dispatched, not `jal`-dispatched") is therefore **corroborated by an independent decode**, not merely inherited.

### S3. Cross-level homology table (measured, per module, own ELF parse)

Hashes via `certutil -hashfile … SHA256` (all files under `02-Jeu-et-dumps/Data/BIN/`).

| module | sha256 | .text size | .data vaddr/size | 30.0f in .data | 60.0f in .data | byte-pair `08 3D` in .text | `jalr ra,*` | `mov.s f12,f20` |
|---|---|---:|---|---:|---:|---:|---:|---:|
| LEVEL_01 | `d10a81d0…6bb571`* | 0x1BF1AC | 0x2A9E80 / 0x33200 | 81 | 31 | 109 | 277 | 723 |
| LEVEL_02 | `0037689a…bc8aa` | 0x1D4BB4 | 0x2C0E00 / 0x35000 | 87 | 32 | 115 | 278 | 754 |
| LEVEL_03 | `4b6cf5e4…e8b94` | 0x1D3850 | 0x2BE400 / 0x34B80 | 92 | 25 | 162 | 295 | 738 |
| LEVEL_04 | `6896122a…4dc37` | 0x1D2A6C | 0x2BC900 / 0x33C00 | 95 | 33 | 112 | 318 | 764 |
| LEVEL_05 | `af7474d3…5bbb` | 0x1AE218 | 0x297480 / 0x30B00 | 77 | 28 | 120 | 267 | 681 |
| LEVEL_06 | `c7953cd3…fec39c` | 0x1AFEF0 | 0x299B80 / 0x31780 | 84 | 27 | 123 | 286 | 707 |
| LEVEL_07 | `40e236a8…dc233d` | 0x1CF310 | 0x2B9800 / 0x34280 | 96 | 28 | 168 | 284 | 753 |
| LEVEL_08 | `c6906ca8…dad8a8` | 0x1FD1A8 | 0x2E8700 / 0x37C80 | 120 | 39 | 115 | 312 | 834 |
| LEVEL_09 | `5674dd1a…f78e6370` | 0x1AAD78 | 0x294400 / 0x31500 | 84 | 26 | 146 | 272 | 709 |
| LEVEL_10 | `07f9010f…1583772` | 0x1C7780 | 0x2B1700 / 0x32C80 | 103 | 45 | 108 | 304 | 734 |
| LEVEL_15 | `cebd5b53…48e70a` | 0x12E628 | 0x214A00 / 0x2BC80 | 103 | 33 | 83 | 273 | 619 |
| LEVEL_21 | `0e7a7f7d…90dd706` | 0x12E628 | 0x214A00 / 0x2BC80 | 103 | 33 | 83 | 273 | 619 |
| LEVEL_22 | `be7ef863…a78986` | 0x1343F8 | 0x21B680 / 0x28A80 | 66 | 18 | 90 | 206 | 559 |
| LEVEL_23 | `7c8a790e…c0f7561` | 0x194C38 | 0x27CF00 / 0x2EB00 | 82 | 24 | 101 | 244 | 672 |
| LEVEL_24 | `a4e3f649…e22480bf` | 0x1918E4 | 0x279700 / 0x2EF80 | 85 | 25 | 100 | 245 | 659 |
| FRONTEND | `f203e56c…356fc2104` | 0x3037C | 0x112980 / 0xE1680 | **0** | **0** | 1 | 19 | 37 |

\* full hashes were printed in-session; LEVEL_01 = `d10a81d076fb44987a45314a020cda2f7e8b39f860b957911ca9365464676571`.

Definition of the pattern columns (so they are not over-read): `08 3D` is the raw byte pair found anywhere in `.text` (a superset of the `lui rt,0x3D08` immediate; alignment not enforced) and `mov.s f12,f20` is the exact instruction word `0x4600A306`. Both are **structural density indicators**, not semantic claims.

Homology verdicts:

- The engine skeleton (1/30 constant builders, a `mov.s f12,f20` delta-forwarding idiom at scale, 200–320 indirect calls, `.data` tables holding both `30.0f` and `60.0f`) is present in **all 15 single-player modules** and absent from `FRONTEND`. `CORROBORATED` by my own per-module parse (independent of the previous Mapper).
- **`LEVEL_15` and `LEVEL_21` are code-identical by every metric I measured** (identical `.text` size, `.data` vaddr/size, and all five pattern counts) with different file hashes → same compiled gameplay code, different packed assets. `OBSERVED`.
- **The substep-flag store is NOT portable as a literal word.** `sb a0,0x208(s2)` (`0xA2440208`) occurs 2× in `LEVEL_01` and **0× in every other gameplay module** — because the flag address and base register differ per module (`.data` base is `0x2A9E80` in L01, `0x2C0E00` in L02, `0x214A00` in L15/L21, …). Any scanner must resolve the module-local flag global and its store offset; hardcoding `0x208` or `0x2B0208` is invalid across modules.

### S4. Provenance findings that affect this mission

1. **`LEVEL_02` contamination is resolved — `OBSERVED`.** `Data/BIN/LEVEL_02.PRX` sha256 = `0037689a926197969231795c4d6b05980e5e94558394617b21e8b8bcd79bc8aa`, **byte-identical (same hash) to `Data/BACKUP/BIN/LEVEL_02_clean.PRX`**, and its word at file offset `0x341D4` = `0x2A240002` = `slti a0,s1,2` (two passes). The one-pass `8b25dc88…` variant named in the earlier review is no longer present in `Data/BIN`. The mission's LEVEL_02 provenance rule is satisfied by the file I used; the parent should record that the corpus changed since the previous mission and that the L02 numbers above were taken on the restored baseline.
2. **The "second VBlank wait" is a catch-up wait** (S1.3) — see Skeptic-relevant framing in S6.
3. **`sceDisplay` call counting must be per stub**, not per section (S1.4): 13 sites / 5 stubs in L01.

### S5. Timing-domain classification (only where I have first-hand instruction evidence)

| system / site (LEVEL_01 RVA) | owner / dispatcher | tags | evidence |
|---|---|---|---|
| `0x1517C` level frame update | state-table entry (`0x15AA8`, `0x15B18`), table in `.rodata 0x1C02C8` | **O, V-adjacent, H** | OBSERVED (S1.1/S1.2) |
| `0x2FFF0` player wrapper | `jal` from `0x15260` with `f12=delta`; re-saves `f20` at `0x30024` | **O, H** | OBSERVED |
| `0x2FB8C` player outer, loop `0x2FCA0–0x2FD04` | called only from `0x300F4` | **O, S (2 passes), H** | OBSERVED |
| `0x360A4` timing fields (`+0x56C…+0x58C`, `+0x578=dt*30`) | called once before the loop | **O, N-VEL/N-TIMER** | OBSERVED (prior work, unchanged by me) |
| `0x39B74`, `0x1EBC4` substep consumers | `0x2FCE8`/`0x2FCF4` pass `mov.s f12,f20` | **D, S** | OBSERVED |
| `0x1EBC4` weapon update | **3 callers** (`0x1E4E8`, `0x1E610`, `0x2FCF0`) → slot `0x1C` callback | **H, D, E** | OBSERVED |
| `0x148CEC` LaserTracer update | pointer-only (`.data 0x2D4158`); gated by `0x2B0208` | **R, E, C** | OBSERVED (pointer + 0 `jal`) |
| `0x14CA70` tracer timing init | pointer-only (`0x2DD1F8`); reads rate `0x2D2C04 = 30.0f` | **R** | OBSERVED for rate word & 0 `jal` |
| `0x96490` frame limiter | single caller `0x94B38`; gate byte `0x2B6E50` | **V, E** | OBSERVED |
| `0x6EBE4` entity pump | per-frame walk, stride `0xF8`, callbacks `+0xD4/+0xD8/+0xDC/+0xE0` | **C, E, H** | OBSERVED |
| `0x1AD1F0–0x1AD710` stack jump-table dispatch | 20 `jalr` from `0x10(sp)` | **E** | OBSERVED |
| `0x1562DC` `Lvl3Elevator` init path | class record `0x2D51B4` → `+0x04`; contains `div.s` by `obj+0x4` then `lui 0x3D08/ori 0x8889` at `0x1563E8/0x1563EC` | **C, F30** | OBSERVED (word `0x3C063D08` at `0x1563E8`), semantic naming INFERRED |
| `0x13B8F0` Flamethrower update | class record `0x2D1A58`, callback `0x2D1A64→0x13B8F0` | **C, E** | OBSERVED (descriptor link) |

Archetypes that this evidence supports: outer-delta integrator; 60 Hz logical two-pass substep; normalized frame-step with dual (velocity/timer) consumers; explicit incoming-delta countdown; per-call fixed-step mover (elevator); per-call counter/modulo emitter (Flamethrower); local rate-aware subsystem (LaserTracer); state/phase-table callback; gated callback; vcount catch-up frame limiter.

### S6. Candidate timing mechanisms (hypotheses, ranked, with discriminating consequences)

- **H1 — engine-global doubling.** If `0x96490`'s limiter gate/catch-up is the only thing pinning the outer rate, then after B0 `0x1517C` runs ~60×/s and *every* direct callee doubles: `0x87A84`, `0x6B7F4`, `0x2FFF0`, `0x6B618`, plus the entity pump and the player chain. Predicted signature: cadence ratio ≈2 for `0x1517C` **and** `0x2FB8C` **and** `0x1EBC4` **and** the `0x6E…` pump.
- **H2 — player-local doubling.** If the outer rate stays ~30 and only the substep count/paths change, the player chain doubles while `0x1517C`/`0x96490` stay flat. This is the configuration in which the accepted "split-domain" player patch is the whole story.
- **H3 — class-local exemption.** Descriptor-slot callbacks (weapon slot `0x1C`, pump callbacks `+0xD4…+0xE0`) and rate-aware code (`0x14CA70`, `0x2B0208`-gated `0x148CEC`) can be skipped, multiplied, or self-normalizing regardless of H1/H2 — the `0x2B0208` gate alone makes the LaserTracer handler run 1× (vanilla) vs 2× (one-pass loop) per outer frame, i.e. the historical four-change socle is expected to *over*-run that subsystem.
- **H4 — the elevator's `1/30` is a per-call fixed step.** `progress += (1.0/speed)*(1/30)` per callback: doubling the callback rate halves the wall-time duration unless the constant is recomputed. This is the cleanest "C/F30" archetype in the corpus and matches the historical Pokitaru symptom.
- **H5 — the limiter's catch-up branch behaves differently from a plain doubled rate.** Removing `0x96650` does not simply double anything; it removes compensation for long frames. Under load, B0 could produce 2× on light frames and unchanged cadence on heavy frames. This is testable only by logging the `vcount` mismatch branch, not by counting calls.

### S7. Best deterministic tests (ranked, for the parent to run; none executed here)

1. **Cadence triple**: log per-second counts of `base+0x1517C`, `base+0x2FB8C`, `base+0x1EBC4`, and `base+0x96490` in A0 vs B0. `H1` ⇔ all four ≈2×; `H2` ⇔ only the player chain changes. This one test discriminates H1/H2/H5 simultaneously and is strictly stronger than the current single-site `0x2FB8C` control.
2. **Catch-up wait tally**: instrument the branch at `0x96648` (taken/not-taken) and the `0x96650` JAL in A0/B0. Distinguishes "second wait is continuous" from "catch-up only" and explains any non-integer cadence ratio.
3. **Elevator**: `Lvl3Elevator` class record `0x2D51B4`; sample `progress`/`progInc` (`moveTime`, `progress`, `progInc` fields are named in the descriptor's field string) and wall-clock traversal, A0/B0/C. Directly tests the per-call fixed-step archetype.
4. **Weapon slot**: count entries of the slot-`0x1C` callback (e.g. Flamethrower `0x13B8F0`, or the current weapon) across the three `0x1EBC4` callers; verifies whether the weapon domain is once-per-substep or state-multiplied.
5. **Local rate-aware knob**: read-only sample of `.data 0x2D2C04` in A0/B0 (must stay `30.0f` unless a writer exists) and count `0x148CEC` entries + the `0x2B0208` flag sequence.
6. **State table**: resolve the reader of the `.rodata` table at `0x1C02C8` and log its selected index in A0/B0 — needed before any claim that "the level always runs one frame-update per display frame".
7. **Entity pump**: count `0x6EBE4`-region entries and the number of `0xF8`-stride records passing the `andi 0x1` test per second, A0/B0.

### S8. Deterministic scanner specification (derived from scans that actually ran)

Inputs: every `.PRX` in `02-Jeu-et-dumps/Data/BIN/`. Parse ELF32 section headers from `e_shoff`/`e_shentsize`/`e_shnum`; map `file = vaddr + 0x74` **only after asserting** the section's `addr - offset` delta is constant for one PT_LOAD. Emit `(module, section, rva, kind, matched words, resolved value, containing-prologue)`.

| ID | instruction window | constraints | false positives | confidence |
|---|---|---|---|---|
| **S1-float** | `lui rt,HI` immediately followed by `ori rt,rt,LO` (same `rt`) | 32-bit value `(HI<<16)\|LO` must equal `0x3D088889` (≈1/30) or `0x3C888889` (≈1/60) | none seen for the exact pairs; `ori …,0x8889` **alone** is unreliable (the earlier report's own warning) | HIGH |
| **S2-loop** | `ori s1,zero,0` … body … `addiu s1,s1,1` ; `slti a0,s1,N` ; backward `bnez/beq a0` | `N` per module (2 = vanilla); require the 4-instruction window | `slti a0,s1,2` alone occurs 9–16×/module | MEDIUM alone, HIGH with the window |
| **S3-flag** | `sltiu a0,s1,1` ; `sb a0,OFF(base)` where `base = lui 0x00XX` | resolve `OFF` **per module** from the module's own `.data`; do not reuse `0x208` | many `sltiu …,1` | HIGH only as a pair with the store |
| **S4-delta** | `mov.s f12,f20` = word `0x4600A306` | only meaningful inside a function that also builds 1/30 | 559–834 hits/module | LOW alone (density metric only) |
| **S5-vblank** | `jal` into the module's `.sceStub.text.sceDisplay` section; classify the stub by its index within the section (8-byte entries) | do **not** count section-wide; identify the catch-up pattern `jal WAIT ; jal VCOUNT ; lw r,global ; addiu r,r,1 ; bne v0,r ; jal WAIT` | other display calls (SetFrameBuf etc.) | HIGH for the pattern, MEDIUM for stub naming |
| **S6-indirect** | parse `.rel.data`/`.rel.rodata` (`Elf32_Rel`, 8 bytes, `r_info&0xFF == 2`), read word at `r_offset` → target RVA | group by contiguous `r_offset` runs; a run whose targets are all in `.text` is a function-pointer table | `r_info` type must be checked; unaligned coincidences inside `.data` floats were observed (e.g. apparent `0x15A4F` targets in `.data`) | HIGH with grouping+alignment |
| **S7-slot** | `lw rX,0x40(rY)` ; `lw rZ,SLOT(rX)` ; `jalr rZ` | `SLOT ∈ {0,4,8,C,10,14,18,1C,20,28,30}`; require all three in order | any two-level pointer chase | MEDIUM–HIGH |
| **S8-rate** | `lwc1 f,(base+0x2C04)` ; `div.s` ; `swc1` ; compare against `0x42700000` (60.0) | the module's rate address differs; resolve via the `30.0f` word in `.data` | any `1/x` computation | MEDIUM |

Cross-checks the scanner must apply: module-scoped RVAs only; hashes recorded for every file analysed; join against the wrapper ledger by `(module, rva)`; never treat `reference_address_NOT_live` as a live address.

### S9. Where timing content alone cannot establish call cadence (Mandatory list)

1. **`0x1517C`** — 2 call sites, both inside a **state table** (`.rodata 0x1C02C8`); the table reader is unresolved. Entry frequency is not derivable from code.
2. **`0x148CEC`** and `0x14CA70` — **0 direct `jal`**; reached only via relocated pointers (`0x2D4158`, `0x2DD1F8`). Static call graphs see nothing; the `0x2B0208` gate means it can also be skipped for arbitrary frames.
3. **`0x1EBC4`** — 3 callers; a count of one caller proves nothing about weapon update rate.
4. **`0x6EBE4` pump** — the `andi a0,0x1` test on `record+0x68` gates entities, so "N objects updated per frame" is state-dependent.
5. **Everything reachable only through `.data`/`.rodata` tables** (all class callbacks, all state tables, all `jalr` method slots) is invisible to any `jal`-based cadence argument.
6. **The frame limiter itself** — the gate byte `0x2B6E50` can disable the block entirely, and the second wait is conditional on a vcount mismatch, so outer cadence is not a simple function of instruction removal.
7. **Cross-module transfer of a literal word**: `sb a0,0x208(s2)` / `0x2B0208` is L01-local (0 occurrences elsewhere); `slti a0,s1,2` occurs in every module for unrelated reasons. Any generalisation must be structural, resolved per module.

### S10. Uncertainty, contradictions, and what I could not resolve

UNKNOWN (mine): the reader/owner of the `.rodata` state table at `0x1C02C8`; the dispatcher that loads `.data 0x2D4158` (LaserTracer handler); any runtime writer of `0x2D2C04`; whether the `0x94xxx` driver (frame limiter caller `0x94B38`) and the `0x15A80` state entries execute in the same thread; the exact semantics of descriptor offsets `0x30`/`0x10`/`0x4`; whether the `0xF8`-stride pump is the global Moby pump or a sub-manager; and whether `LEVEL_15`/`LEVEL_21` code identity extends beyond the five metrics I measured.

Contradictions/refinements vs prior accepted text: (a) prior "six sceDisplay callsites" vs my 13 (per-stub table in S1.4); (b) prior "conditional second VBlank wait" is more precisely a vcount catch-up branch (S1.3); (c) prior L02 contamination is no longer present in `Data/BIN` (S4.1). No contradiction found with the accepted player-clock facts (`0x2FB8C`/`0x360A4`/`0x2B0208`/`0x148CEC`/`0x14CA70`/weapon contract/`+0x578` dual semantics) — all of those were re-decoded here and matched.

<!-- PARENT_HANDOFF_V1 -->
```json
{
  "established": "L01: 277 jalr/20458 jal; 0x1517C called only from 0x15AA8,0x15B18; limiter entry 0x96490 has single caller 0x94B38; L02 Data/BIN == clean 0037689a; report S1/S4",
  "corroborated": "All 15 SP modules carry 30.0f and 60.0f .data constants, 244-318 jalr, 559-834 mov.s f12,f20; FRONTEND has 0/0/19/37; independent per-module ELF parse; report S3",
  "inferred": "obj+0x40 -> class descriptor; slot 0x1C = weapon update, 0x20 = most common method (26 sites); 0xF8-stride entity pump callbacks +0xD4/+0xDC/+0xE0; report S2/S5",
  "contradictions": "Prior 'six sceDisplay callsites' vs 13 jal sites into the stub section (7 into 0x1BF424); prior L02 contamination absent now (hash equals BACKUP clean); report S4",
  "rejected": "Unconditional 'second VBlank wait': 0x96650 is a catch-up wait taken only when vcount != stored+1; section-wide sceDisplay counting; literal 0x208 flag store portability; report S1.3/S3",
  "unknown": "Reader of .rodata state table 0x1C02C8; dispatcher loading 0x2D4158; runtime writer of 0x2D2C04; thread/loop relation of 0x94B38 vs 0x15A80; report S9",
  "top_hypotheses": "H1 whole level frame 0x1517C doubles at B0 (engine-global); H2 only player chain doubles; H3 gate/rate-aware paths exempt (0x2B0208, 0x14CA70); H4 elevator is per-call 1/30 step; report S6",
  "best_discriminating_test": "Per-second counts of base+0x1517C, base+0x2FB8C, base+0x1EBC4, base+0x96490 in A0 vs B0; all four x2 => H1, player-only x2 => H2; report S7",
  "blockers": "Read-only mission, no runtime access; indirect dispatch owners unresolved for 0x148CEC/0x1C02C8; no Capstone/Python (ConstrainedLanguage) so scans are PowerShell byte patterns",
  "full_report_required": "yes: S1 dispatcher map (VBlank catch-up, 3-caller weapon path), S2 descriptor records, S3 homology table, S8 scanner spec, S9 cadence-unknowables"
}
```
<!-- /PARENT_HANDOFF_V1 -->