#!/usr/bin/env python3
"""Build the RI-v1 blob for a given LEVEL_01 base address (symbols differ per session).

Usage: python patches/experimental/render-interp/build.py --base 0x9139D00 --link 0x2C1818 --out <dir>
Outputs <dir>/ri.bin (raw bytes to copy to base+link) and <dir>/ri.json (symbol addresses).
Game addresses are RVAs from the local decompilation (OBSERVED): pump 1 0x6B7F4, pump 2 0x6E6D4,
0x159DC frame function, group root variable 0x2CA0D0; imports in the EBOOT stubs at 0x883C3C0/0x883C3D0
(sceKernelAllocPartitionMemory / sceKernelGetBlockHeadAddr, EBOOT base is fixed).
"""
import argparse, json, os, re, subprocess
from pathlib import Path
HERE = Path(__file__).resolve().parent; REPO = HERE.parents[2]
SDK = REPO/'01-Travail-et-profil-PPSSPP/Overcompensated-Reprise-2026-09-14/toolchains/pspdev-win'
ap = argparse.ArgumentParser(); ap.add_argument('--base', type=lambda x: int(x, 0), required=True)
ap.add_argument('--link', type=lambda x: int(x, 0), default=0x2C1818)
ap.add_argument('--hilink', type=lambda x: int(x, 0), default=0x2B7700); ap.add_argument('--out', type=Path, required=True)
ap.add_argument('--weapon', type=lambda x: int(x, 0), default=0)
ap.add_argument('--alloc', type=lambda x: int(x, 0), default=0x883C3C0); ap.add_argument('--head', type=lambda x: int(x, 0), default=0x883C3D0)
a = ap.parse_args(); a.out.mkdir(parents=True, exist_ok=False)
env = os.environ.copy(); env['PATH'] = str(SDK/'bin')+os.pathsep+env.get('PATH', '')
def run(cmd):
    r = subprocess.run([str(x) for x in cmd], cwd=a.out, env=env, text=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    if r.stdout: print(r.stdout, end='')
    if r.returncode: raise SystemExit('failed: %s' % cmd[0])
    return r.stdout
b = a.base; addr = b+a.link
defs = {'RI_PUMP1': b+0x6B7F4, 'RI_PUMP2': b+0x6E6D4, 'RI_FRAME': b+0x159DC, 'RI_ROOTVAR': b+0x2CA0D0, 'RI_ALLOC': a.alloc, 'RI_HEAD': a.head, 'RI_FOGRESET': b+0x88768, 'RI_LIGHTS': b+0x159A0, 'RI_GATE1': b+0x2B29FC, 'RI_GATE2': b+0x2B2A00, 'RI_COUNTER': b+0x2AF28C, 'RI_PRIMRESET': b+0x8DC14, 'RI_PRIMCNT': b+0x303B44, 'RI_PRIMLIST': b+0x303144, 'RI_FREE': 0x883C3E0, 'RI_SCRATCH': b+0x7D510, 'RI_POOL1': b+0x2B2D18, 'RI_POOL2': b+0x2B2D1C, 'RI_LATCH': b+0x36EE90, 'RI_DIREDGE': b+0x2B2BE4, 'RI_HELP': b+0xA47B8, 'RI_PRIMPTR': b+0x2DD330, 'RI_PRIMBASE': b+0x302F1C, 'RI_PRIMEND': b+0x2DD334, 'RI_PARTICLES': b+0x8CC18, 'RI_WEAPON': a.weapon, 'RI_ITEMPOOL': b+0x2DD338, 'RI_NODES': b+0x303B48, 'RI_STRIDES': b+0x2B66B0, 'RI_FLUSH': b+0x8E2D4, 'RI_L1CNT': b+0x2E0C30, 'RI_L2CNT': b+0x2E0CF4, 'RI_L3CNT': b+0x2E0DB8, 'RI_DCNT': b+0x303B44}
cmd = [SDK/'bin/psp-gcc.exe', '-Os', '-G0', '-std=gnu11', '-Wall', '-Wextra', '-Werror', '-ffreestanding', '-fno-schedule-insns', '-fno-schedule-insns2', '-fno-pic', '-mno-abicalls',
       '-fno-strict-aliasing', '-nostdlib', '-nostartfiles', '-Wl,--build-id=none', '-Wl,-Ttext=0x%X' % addr, '-Wl,--section-start=.hitext=0x%X' % (b+a.hilink), '-Wl,-e,ri_pump1']
cmd += ['-Wl,--defsym,%s=0x%X' % kv for kv in defs.items()] + [HERE/'ri.c', '-o', 'ri.elf']
run(cmd)
run([SDK/'bin/psp-objcopy.exe', '-O', 'binary', '-j', '.text', '-j', '.rodata', '-j', '.data', '--gap-fill=0', 'ri.elf', 'ri.bin'])
run([SDK/'bin/psp-objcopy.exe', '-O', 'binary', '-j', '.hitext', '--gap-fill=0', 'ri.elf', 'ri.hi.bin'])
nm = run([SDK/'bin/psp-nm.exe', 'ri.elf'])
sym = {m[1]: int(m[0], 16) for m in re.findall(r'(?m)^([0-9a-f]+) [A-Za-z] (ri_\w+)$', nm)}
size = (a.out/'ri.bin').stat().st_size
(a.out/'ri.json').write_text(json.dumps({'base': hex(b), 'link': hex(a.link), 'size': size, 'hi_link': hex(a.hilink), 'hi_size': (a.out/'ri.hi.bin').stat().st_size, 'symbols': {k: hex(v) for k, v in sym.items()}}, indent=1))
print('size', size, {k: hex(v) for k, v in sym.items()})
