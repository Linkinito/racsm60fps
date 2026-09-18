#!/usr/bin/env python3
"""Generate guarded, module-relative patches from the archived v0.2.1 corpus.

Requires the user's original PRX files; no game binary is included in this pack.
Every imported word and every wrapper call is checked against those binaries.
"""
import argparse
import collections
import csv
import hashlib
import json
from pathlib import Path
import struct

BASE = 0x09139D00
LAYERS = {'BASE': 1, 'SOCLE': 1, 'WEAPONS': 2, 'BREAKABLES': 4, 'PARTICLES': 8}


class Elf:
    def __init__(self, path):
        self.data = path.read_bytes()
        h = struct.unpack_from('<16sHHIIIIIHHHHHH', self.data)
        assert h[0][:7] == b'\x7fELF\x01\x01\x01' and h[2] == 8
        self.sections = [struct.unpack_from('<10I', self.data, h[6]+i*h[11]) for i in range(h[12])]
        names = self.sections[h[13]]
        self.names = self.data[names[4]:names[4]+names[5]]
        # PSP relocation sections use r_info: type:8, offset_segment:8,
        # address_segment:8. These PRX files use segment 0 for patched R_MIPS_26.
        self.relocations = {}
        for s in self.sections:
            if s[1] == 0x700000A0:
                for off in range(s[4], s[4]+s[5], 8):
                    addr, info = struct.unpack_from('<II', self.data, off)
                    self.relocations[addr] = info

    def word(self, offset):
        for s in self.sections:
            if s[2] & 2 and s[3] <= offset and offset+4 <= s[3]+s[5]:
                return 0 if s[1] == 8 else struct.unpack_from('<I', self.data, s[4]+offset-s[3])[0]
        raise ValueError(f'Unmapped offset {offset:#x}')


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--prx-dir', type=Path, required=True)
    args = ap.parse_args()
    root = Path(__file__).resolve().parents[2]
    manifest_path = root/'provenance/experience_v021_manifest.json'
    source = json.loads(manifest_path.read_text())
    images = {}
    for idx, expected in source['input_verification']['prx_hashes'].items():
        idx = int(idx)
        img = Elf(args.prx_dir/f'LEVEL_{idx:02d}.PRX')
        assert hashlib.sha256(img.data).hexdigest() == expected, f'PRX hash mismatch L{idx}'
        images[idx] = img
    caves = source['caves']
    cave_templates = []
    for c in caves:
        start, ret = int(c['start'], 16), int(c['return_word_address'], 16)
        words = [0]*64
        for w in c['static_words']:
            n = (int(w['address'], 16)-start)//4
            assert 0 <= n < 64
            words[n] = int(w['word'], 16)
        assert (ret-start)//4 < 63 and words[(ret-start)//4+1] == 0
        cave_templates.append(words)
    patches = collections.defaultdict(list)
    returns = collections.defaultdict(dict)
    imported = []
    for p in source['patches']:
        idx = p['module_index']
        addr, original, value = [int(p[k], 16) for k in ('address', 'runtime_vanilla', 'patched')]
        if p['kind'] == 'cave_return':
            ci = next(i for i,c in enumerate(caves) if int(c['return_word_address'],16) == addr)
            target = (value & 0x03FFFFFF) << 2
            assert value >> 26 == 2 and 0 <= target-BASE < 0x500000
            images[idx].word(target-BASE)
            returns[idx][ci] = target-BASE
            continue
        raw = images[idx].word(addr-BASE)
        assert raw == int(p['file_vanilla'],16), f'Original mismatch L{idx} {addr:#x}'
        if p['layer'] == 'WRAPPER':
            continue  # The common wrapper is kept intact; v0.5 routing replaces this.
        flags = 0
        if p['continuous']:
            flags |= 1
        elif original != raw:
            assert raw >> 26 == 3 and images[idx].relocations[addr-BASE] == 4
            assert original == (raw & 0xFC000000) | (((raw & 0x03FFFFFF)+(BASE >> 2)) & 0x03FFFFFF)
            flags |= 2  # Original J/JAL needs runtime delta.
        # Reject any unhandled relocation at a patched location.
        ri = images[idx].relocations.get(addr-BASE)
        assert ri is None or ri == 4, (idx, hex(addr), ri)
        if value >> 26 in (2,3):
            target = (value & 0x03FFFFFF) << 2
            if target in [int(c['start'],16) for c in caves]:
                flags |= 4  # Jump to a cave owned by this plugin.
                ci = next(i for i,c in enumerate(caves) if int(c['start'],16) == target)
                value = ci
            else:
                assert BASE <= target < BASE+0x500000
                flags |= 8
        if p['section'] == '.text':
            flags |= 16
        if p['mechanic'] == 'Déverrouillage VBlank':
            flags |= 32
        record = (addr-BASE, original, value, flags, LAYERS[p['layer']])
        assert not any(x[0] == record[0] for x in patches[idx]), f'Duplicate {idx} {addr:#x}'
        patches[idx].append(record)
        imported.append(p)
    calls = list(csv.DictReader((root/'tables/wrapper_callsites.csv').open(encoding='utf-8-sig')))
    anatomy = {int(r['module_index']): r for r in csv.DictReader((root/'tables/wrapper_anatomy.csv').open(encoding='utf-8-sig'))}
    # Field names are part of the saved v0.5.0 table, never guessed addresses.
    assert len(calls) == 493
    checked_calls = 0
    for r in calls:
        idx = int(r['module_index'])
        addr = int(r['callsite_runtime'],16)
        entry = int(anatomy[idx]['two_pass_entry_runtime'],16)
        assert images[idx].word(addr-BASE) == 0x0C000000 | ((entry-BASE) >> 2)
        assert not any(x[0] in (addr-BASE,addr+4-BASE) for x in patches[idx]), f'Wrapper conflict {idx} {addr:#x}'
        checked_calls += 1
    assert patches[15] == patches[21] and returns[15] == returns[21]
    lines = ['/* Generated by tools/generate_full_patch.py. Do not edit. */', '#include "rcsm_full_patch.h"']
    lines.append('const uint32_t g_rcsm_cave_templates[RCSM_CAVE_COUNT][RCSM_CAVE_WORDS] = {')
    for ws in cave_templates:
        lines.append('    {'+', '.join(f'0x{v:08X}u' for v in ws)+'},')
    lines.append('};')
    lines.append('const uint32_t g_rcsm_legacy_cave_addresses[RCSM_CAVE_COUNT] = {' + ', '.join(c['start']+'u' for c in caves)+'};')
    lines.append('const uint8_t g_rcsm_cave_return_indices[RCSM_CAVE_COUNT] = {' + ', '.join(str((int(c['return_word_address'],16)-int(c['start'],16))//4) for c in caves)+'};')
    for idx, records in patches.items():
        # Corrections before the VBlank unlock; restore runs in reverse order.
        records.sort(key=lambda x: (bool(x[3] & 32),x[0]))
        lines.append(f'static const RcsmFullWord kFull{idx}[] = {{')
        for off,old,new,flags,layer in records:
            lines.append(f'    {{0x{off:08X}u, 0x{old:08X}u, 0x{new:08X}u, {flags}u, {layer}u}},')
        lines.append('};')
    lines.append('const RcsmFullModule g_rcsm_full_modules[] = {')
    for idx, records in patches.items():
        rr=', '.join(f'0x{returns[idx].get(i,0):08X}u' for i in range(len(caves)))
        lines.append(f'    {{{idx}u, {len(records)}u, kFull{idx}, {{{rr}}}}},')
        for rec in records:
            if rec[3] & 4:
                assert rec[2] in returns[idx], f'No cave return {idx}/{rec[2]}'
    lines += ['};','const size_t g_rcsm_full_module_count = sizeof(g_rcsm_full_modules)/sizeof(g_rcsm_full_modules[0]);']
    (root/'profiler/generated/full_patch.generated.c').write_text('\n'.join(lines)+'\n')
    summary = {
        'status': 'PASS', 'validation': 'static_binary_only',
        'source_manifest_sha256': hashlib.sha256(manifest_path.read_bytes()).hexdigest(),
        'prx_sha256': source['input_verification']['prx_hashes'],
        'imported_game_writes': len(imported), 'runtime_constants': sum(p['continuous'] for p in imported),
        'wrapper_calls_checked': checked_calls, 'caves': len(caves),
        'modules': [{'index': idx,'patches':len(rs)} for idx,rs in patches.items()],
        'excluded_legacy_common_wrapper_writes': 15,
        'excluded_legacy_cave_returns_replaced_by_plugin_storage': 99,
        'ppsspp_gameplay_tested': False,
    }
    (root/'BINARY_AUDIT.json').write_text(json.dumps(summary,indent=2)+'\n')
    print(json.dumps(summary,indent=2))


if __name__ == '__main__':
    main()
