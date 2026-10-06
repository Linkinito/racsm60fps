#!/usr/bin/env python3
"""Build a module-relative MIPS disassembly corpus for the identified objects
and for the V1 wrapper families (WF-nnn).

Goal: the two registers that the project uses at class level are name-only.
  * the frozen 538-name register (research/v2/c1-residual-timing-atlas/),
  * the 59 WF families of the legacy wrapper catalog.
This script materializes the *code* of both, so that later static work reads a
listing instead of re-implementing a decoder, and so that the numbers in the
catalog can be re-derived from the images.

Inputs (all tracked in git):
  - legacy V1 catalog tables (development-v0.6.3-generalisation/sources/tables):
      object_descriptors.csv       1,927 descriptor rows, 538 names, 5,971 callbacks
      wrapper_families.csv         59 families
      wrapper_family_members.csv   267 wrapped owner functions
      wrapper_callsites.csv        493 callsites
      wrapper_anatomy.csv          15 per-module wrapper entries (plugin-injected)
  - vanilla module images: prx-reference/LEVEL_*.PRX (15 modules; identical to
    02-Jeu-et-dumps/Data/BIN/LEVEL_*.PRX as of 2026-09-21)
  - frozen register: research/v2/c1-residual-timing-atlas/c1-residual-timing-atlas.csv

Outputs (generated; never edited by hand):
  <out>/objects/<Name>.asm
  <out>/families/<WF-nnn>.asm
  <out>/INDEX.csv, <out>/MANIFEST.sha256

Addresses: module-relative RVAs. File offset = RVA + delta, where delta is read
from the file-backed PT_LOAD0 of the image itself (delta = 0x74 for every level
image here); the value is verified per image and recorded, never assumed.

Decoding: capstone MIPS32 little-endian (vendored under the legacy
analysis-deps/ directory). Words capstone cannot decode are printed raw and
marked `UNDECODED`.

Extent rule (heuristic, always recorded per listing):
  linear sweep from the function start; stop after the delay slot of the first
  `jr`-class instruction whose successor is a plausible new function (prologue
  `addiu $sp,$sp,-N`, a zero-padding word, or the end of the window); otherwise
  keep sweeping so that an early-return guard does not truncate the listing.
  A sweep that reaches the instruction bound is marked TRUNCATED_BOUND.

Evidence level: static decode. A listing is not a behavior claim, and the corpus
carries no verdict field by design.

Determinism: no timestamps; identical inputs produce byte-identical files.
"""

import argparse
import csv
import hashlib
import os
import struct
import sys

REPO = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
LEGACY = os.path.join(
    REPO, '01-Travail-et-profil-PPSSPP', 'Overcompensated-Reprise-2026-09-14',
    'development-v0.6.3-generalisation')
DEFAULT_TABLES = os.path.join(LEGACY, 'sources', 'tables')
DEFAULT_IMAGES = os.path.join(LEGACY, 'prx-reference')
REGISTER = os.path.join(REPO, 'research', 'v2', 'c1-residual-timing-atlas',
                        'c1-residual-timing-atlas.csv')
MAX_INSNS = 1024


def sha256_file(path):
    h = hashlib.sha256()
    with open(path, 'rb') as fh:
        for chunk in iter(lambda: fh.read(1 << 20), b''):
            h.update(chunk)
    return h.hexdigest()


def load_capstone():
    try:
        import capstone  # noqa: F401
    except ImportError:
        vendor = os.path.join(REPO, '01-Travail-et-profil-PPSSPP',
                              'Overcompensated-Reprise-2026-09-14', 'analysis-deps')
        sys.path.insert(0, vendor)
    import capstone
    return capstone


class Image(object):
    """One module image plus its verified RVA -> file-offset mapping."""

    def __init__(self, path, module_key):
        with open(path, 'rb') as fh:
            self.data = fh.read()
        if self.data[:4] != b'\x7fELF':
            raise ValueError('%s is not a decrypted ELF image' % path)
        self.module_key = module_key
        self.path = path
        self.sha256 = hashlib.sha256(self.data).hexdigest()
        self.segments = self._read_segments()
        self.delta, self.filesz = None, None
        for p_offset, p_vaddr, p_filesz, p_flags in self.segments:
            if p_vaddr == 0:
                self.delta = p_offset - p_vaddr
                self.filesz = p_filesz
        if self.delta is None:
            raise ValueError('%s has no PT_LOAD at vaddr 0' % path)

    def _read_segments(self):
        e_phoff, = struct.unpack_from('<I', self.data, 0x1C)
        e_phentsize, = struct.unpack_from('<H', self.data, 0x2A)
        e_phnum, = struct.unpack_from('<H', self.data, 0x2C)
        out = []
        for i in range(e_phnum):
            off = e_phoff + i * e_phentsize
            p_type, p_offset, p_vaddr, _p_paddr, p_filesz, _memsz, p_flags, _al = \
                struct.unpack_from('<IIIIIIII', self.data, off)
            if p_type == 1:  # PT_LOAD
                out.append((p_offset, p_vaddr, p_filesz, p_flags))
        return out

    def word_at(self, rva):
        off = rva + self.delta
        if off < 0 or off + 4 > len(self.data):
            raise ValueError('%s: RVA 0x%X is outside the file' % (self.module_key, rva))
        return struct.unpack_from('<I', self.data, off)[0]

    def in_code_segment(self, rva):
        return 0 <= rva and rva + 4 <= (self.filesz or 0)


def decode_window(cs, image, rva, max_insns=MAX_INSNS):
    """Linear decode of up to max_insns words starting at rva."""
    md = cs.Cs(cs.CS_ARCH_MIPS, cs.CS_MODE_MIPS32 | cs.CS_MODE_LITTLE_ENDIAN)
    out = []
    for i in range(max_insns):
        addr = rva + 4 * i
        if not image.in_code_segment(addr):
            break
        word = image.word_at(addr)
        raw = struct.pack('<I', word)
        insn = next(md.disasm(raw, addr), None)
        if insn is None:
            # capstone's MIPS32 core has no Allegrex VFPU (COP2) table, and its
            # MIPS64 reading of the same word would be wrong for this target;
            # keep the raw word and only record the opcode fields we can read.
            note = ('op=0x%02X funct=0x%02X' % (word >> 26, word & 0x3F)
                    if (word >> 26) == 0 else 'op=0x%02X' % (word >> 26))
            out.append({'rva': addr, 'word': word, 'mnem': None, 'op': '',
                        'note': note})
        else:
            out.append({'rva': addr, 'word': word,
                        'mnem': insn.mnemonic, 'op': insn.op_str})
    return out


def _is_prologue_like(dec):
    if dec['word'] == 0:
        return True
    op = dec['op'].replace(' ', '')
    if dec['mnem'] in ('addiu', 'addi', 'daddiu') and op.startswith('$sp,$sp,-'):
        return True
    if dec['mnem'] in ('sw', 'sd') and op.startswith('$ra,'):
        return True
    return False


def extent(decoded):
    """Return (count, status, continuations) for a linearly decoded window."""
    n = len(decoded)
    i, continued = 0, 0
    while i < n:
        if decoded[i]['mnem'] in ('jr', 'ret'):
            end = min(i + 2, n)          # include the delay slot
            if end >= n or _is_prologue_like(decoded[end]):
                status = 'LINEAR_FIRST_RETURN' if continued == 0 else 'LINEAR_AFTER_CONTINUE'
                return end, status, continued
            i = end
            continued += 1
            continue
        i += 1
    return n, 'TRUNCATED_BOUND', continued


def fmt_insn(dec):
    text = ('%-8s %s' % (dec['mnem'], dec['op'])).rstrip() if dec['mnem'] \
        else 'UNDECODED (%s)' % dec.get('note', '')
    return '0x%08X  %08X  %s' % (dec['rva'], dec['word'], text)


def listing(lines, rva, decoded, count, status, note=None):
    undecoded = sum(1 for dec in decoded[:count] if dec['mnem'] is None)
    suffix = '  undecoded=%d' % undecoded if undecoded else ''
    lines.append('; function RVA 0x%06X  %d instructions  %s%s'
                 % (rva, count, status, suffix))
    if note:
        lines.append('; %s' % note)
    for dec in decoded[:count]:
        lines.append(fmt_insn(dec))
    lines.append('')


def parse_hex(text):
    text = (text or '').strip()
    if text.lower().startswith('0x'):
        return int(text, 16)
    return int(text or '0', 0)


def load_rows(path):
    with open(path, encoding='utf-8-sig', newline='') as fh:
        return list(csv.DictReader(fh))


def main():
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument('--tables', default=DEFAULT_TABLES)
    ap.add_argument('--images', default=DEFAULT_IMAGES)
    ap.add_argument('--register', default=REGISTER)
    ap.add_argument('--out', default=os.path.join(REPO, 'research', 'v2', 'disasm-corpus'))
    ap.add_argument('--limit-objects', type=int, default=0,
                    help='debug: only the first N objects (0 = all)')
    args = ap.parse_args()

    cs = load_capstone()
    tables = args.tables
    descriptors = load_rows(os.path.join(tables, 'object_descriptors.csv'))
    families = load_rows(os.path.join(tables, 'wrapper_families.csv'))
    members = load_rows(os.path.join(tables, 'wrapper_family_members.csv'))
    callsites = load_rows(os.path.join(tables, 'wrapper_callsites.csv'))
    anatomy = load_rows(os.path.join(tables, 'wrapper_anatomy.csv'))
    register = load_rows(args.register)

    modules = sorted({r['module_key'] for r in descriptors} | {r['module_key'] for r in members})
    images = {}
    for module in modules:
        path = os.path.join(args.images, module + '.PRX')
        images[module] = Image(path, module)
        if images[module].delta != 0x74:
            print('NOTE %s: PT_LOAD0 delta = 0x%X (not 0x74)' % (module, images[module].delta))

    objects_dir = os.path.join(args.out, 'objects')
    families_dir = os.path.join(args.out, 'families')
    os.makedirs(objects_dir, exist_ok=True)
    os.makedirs(families_dir, exist_ok=True)

    register_by_name = {}
    for row in register:
        register_by_name.setdefault(row['class_name'], row)

    index = []
    image_hashes = {m: images[m].sha256 for m in modules}
    input_hashes = {
        'object_descriptors.csv': sha256_file(os.path.join(tables, 'object_descriptors.csv')),
        'wrapper_families.csv': sha256_file(os.path.join(tables, 'wrapper_families.csv')),
        'wrapper_family_members.csv': sha256_file(os.path.join(tables, 'wrapper_family_members.csv')),
        'wrapper_callsites.csv': sha256_file(os.path.join(tables, 'wrapper_callsites.csv')),
        'wrapper_anatomy.csv': sha256_file(os.path.join(tables, 'wrapper_anatomy.csv')),
        'register': sha256_file(args.register),
    }

    # ---------------- objects ----------------
    by_name = {}
    for row in descriptors:
        by_name.setdefault(row['object_name'], []).append(row)
    names = sorted(by_name)
    if args.limit_objects:
        names = names[:args.limit_objects]

    covered = 0
    for name in names:
        reg = register_by_name.get(name)
        lines = ['# object: %s' % name,
                 '# source: legacy V1 object_descriptors.csv (descriptor + callback RVAs)',
                 '# register: %s' % (('primary_family=%s taxonomy=%s occurrences=%s'
                                      % (reg['primary_family'], reg['taxonomy_tags'],
                                         reg['occurrence_count'])) if reg else 'NOT IN REGISTER'),
                 '# images: %s' % ', '.join('%s=%s' % (m, image_hashes[m][:12]) for m in modules),
                 '; RVAs are module-relative; capstone MIPS32 LE; extent rule in REPORT.md',
                 '']
        n_callbacks = 0
        for row in sorted(by_name[name], key=lambda r: (r['module_key'], r['descriptor_rva'])):
            module = row['module_key']
            image = images[module]
            lines.append('## %s  descriptor 0x%06X  pvar_schema=%s'
                         % (module, parse_hex(row['descriptor_rva']),
                            row.get('pvar_schema') or '-'))
            callbacks = [parse_hex(x) for x in row['callback_rvas'].split(';') if x.strip()]
            for rva in callbacks:
                decoded = decode_window(cs, image, rva)
                count, status, cont = extent(decoded)
                listing(lines, rva, decoded, count, status,
                        note=('continuations=%d' % cont) if cont else None)
                index.append({'kind': 'object', 'item': name, 'module': module,
                              'anchor_rva': row['descriptor_rva'], 'rva': '0x%06X' % rva,
                              'insns': count, 'extent': status,
                              'file': 'objects/%s.asm' % name})
                n_callbacks += 1
        path = os.path.join(objects_dir, name + '.asm')
        with open(path, 'w', encoding='utf-8', newline='\n') as fh:
            fh.write('\n'.join(lines) + '\n')
        covered += 1
        if covered % 50 == 0:
            print('objects: %d/%d' % (covered, len(names)))

    # ---------------- families ----------------
    members_by_family = {}
    for row in members:
        members_by_family.setdefault(row['family_id'], []).append(row)
    callsites_by_family = {}
    for row in callsites:
        callsites_by_family.setdefault(row['family_id'], []).append(row)

    for fam in sorted(families, key=lambda r: r['family_id']):
        fid = fam['family_id']
        lines = ['# %s  status=%s  signature=%s' % (fid, fam['family_status'], fam['family_key']),
                 '# modules=%s members=%s callsites=%s levels=%s'
                 % (fam['module_count'], fam['member_count'], fam['callsite_count'],
                    fam['levels']),
                 '# static_domain_hypotheses=%s evidence_strength=%s'
                 % (fam.get('static_domain_hypotheses') or '-',
                    fam.get('evidence_strength') or '-'),
                 '# symbolic_names=%s' % (fam.get('symbolic_names') or '-'),
                 '# wrapper entries (plugin-injected, not present in the vanilla images):']
        for a in sorted(anatomy, key=lambda r: int(r['module_index'])):
            lines.append('#   %s two_pass=%s one_pass_inner=%s entry_words=%s,%s,%s,%s'
                         % (a['module_key'], a['two_pass_entry_runtime'],
                            a['one_pass_inner_runtime'], a['entry_word_0'],
                            a['entry_word_1'], a['entry_word_2'], a['entry_word_3']))
        lines.append('; RVAs are module-relative; capstone MIPS32 LE; extent rule in REPORT.md')
        lines.append('')

        for row in sorted(members_by_family.get(fid, []),
                          key=lambda r: (r['module_key'], r['owner_rva'])):
            module = row['module_key']
            image = images[module]
            rva = parse_hex(row['owner_rva'])
            decoded = decode_window(cs, image, rva)
            count, status, cont = extent(decoded)
            legacy_end = parse_hex(row['function_end_rva_estimate'])
            computed_end = rva + 4 * count
            match = 'MATCH' if legacy_end == computed_end else 'DIFF'
            lines.append('## member %s  owner RVA 0x%06X  (%s)'
                         % (module, rva, row.get('owner_assignment_status') or '-'))
            lines.append('; legacy_end_estimate=0x%06X computed_end=0x%06X %s '
                         'wrapper_calls=%s incoming=%s legacy_insns=%s'
                         % (legacy_end, computed_end, match, row.get('wrapper_call_count'),
                            row.get('incoming_direct_calls'), row.get('instruction_count')))
            if row.get('exact_object_descriptors'):
                lines.append('; descriptors=%s' % row['exact_object_descriptors'])
            listing(lines, rva, decoded, count, status,
                    note=('continuations=%d' % cont) if cont else None)
            index.append({'kind': 'family-member', 'item': fid, 'module': module,
                          'anchor_rva': row['owner_rva'], 'rva': '0x%06X' % rva,
                          'insns': count, 'extent': status,
                          'file': 'families/%s.asm' % fid})

        for row in sorted(callsites_by_family.get(fid, []),
                          key=lambda r: (r['module_key'], parse_hex(r['callsite_rva']))):
            module = row['module_key']
            image = images[module]
            rva = parse_hex(row['callsite_rva'])
            window = decode_window(cs, image, rva - 8, 5)
            lines.append('## callsite %s 0x%06X (owner 0x%06X, policy %s)'
                         % (module, rva, parse_hex(row['owner_rva']),
                            row.get('profiler_default_policy')))
            lines.append('; recorded (V1 armed capture): %s' % row['instruction_context'])
            for dec in window:
                marker = '>' if dec['rva'] == rva else ' '
                lines.append('%s%s' % (marker, fmt_insn(dec)))
            lines.append('; vanilla words decoded above; the recorded capture shows the wrapper '
                         'entry as the jal target, so compare the targets explicitly')
            lines.append('')
            index.append({'kind': 'family-callsite', 'item': fid, 'module': module,
                          'anchor_rva': row['owner_rva'], 'rva': '0x%06X' % rva,
                          'insns': len(window), 'extent': 'WINDOW_5',
                          'file': 'families/%s.asm' % fid})

        path = os.path.join(families_dir, fid + '.asm')
        with open(path, 'w', encoding='utf-8', newline='\n') as fh:
            fh.write('\n'.join(lines) + '\n')

    # ---------------- index + manifest ----------------
    index_path = os.path.join(args.out, 'INDEX.csv')
    with open(index_path, 'w', encoding='utf-8', newline='') as fh:
        writer = csv.DictWriter(fh, fieldnames=['kind', 'item', 'module', 'anchor_rva',
                                                'rva', 'insns', 'extent', 'file'])
        writer.writeheader()
        for row in index:
            writer.writerow(row)

    manifest_lines = []
    for root, _dirs, files in os.walk(args.out):
        for fn in sorted(files):
            if fn == 'MANIFEST.sha256':
                continue
            full = os.path.join(root, fn)
            rel = os.path.relpath(full, args.out).replace(os.sep, '/')
            manifest_lines.append('%s  %s' % (sha256_file(full), rel))
    manifest_lines.sort(key=lambda line: line.split('  ', 1)[1])
    with open(os.path.join(args.out, 'MANIFEST.sha256'), 'w', encoding='utf-8',
              newline='\n') as fh:
        fh.write('\n'.join(manifest_lines) + '\n')

    print('objects=%d families=%d index_rows=%d files=%d'
          % (len(names), len(families), len(index), len(manifest_lines)))
    print('input hashes:')
    for key, value in sorted(input_hashes.items()):
        print('  %s %s' % (value, key))
    print('image hashes:')
    for module in modules:
        print('  %s %s delta=0x%X filesz=0x%X'
              % (image_hashes[module], module, images[module].delta, images[module].filesz))


if __name__ == '__main__':
    main()
