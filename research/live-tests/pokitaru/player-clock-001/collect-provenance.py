"""Read-only local provenance; no ISO extraction, config edits or emulator access."""
from pathlib import Path
import configparser
import datetime
import hashlib
import json
import struct
import subprocess

ROOT = Path(__file__).resolve().parents[4]
OUT = Path(__file__).resolve().parent
ISO_DIR = Path('C:/Users/linki/Downloads/Ratchet & Clank - Size Matters (Europe) (PSN)')
MEMSTICK = ROOT.parent

def sha(path):
    with path.open('rb') as f:
        return hashlib.file_digest(f, 'sha256').hexdigest()

def identity(path):
    return {'path': str(path), 'bytes': path.stat().st_size, 'sha256': sha(path)}

def iso_modules(path):
    result = identity(path)
    with path.open('rb') as f:
        f.seek(16 * 2048)
        pvd = f.read(2048)
        assert pvd[:7] == b'\x01CD001\x01', 'Expected ISO9660 PVD'
        def record(raw):
            return struct.unpack_from('<I', raw, 2)[0], struct.unpack_from('<I', raw, 10)[0], raw[25], raw[33:33+raw[32]]
        root_extent, root_size, _, _ = record(pvd[156:190])
        entries = []
        visited = set()
        def walk(extent, size, prefix):
            assert size <= 16 * 1024 * 1024, 'Unexpected directory size'
            if extent in visited:
                return
            visited.add(extent)
            f.seek(extent * 2048)
            directory = f.read(size)
            at = 0
            while at < len(directory):
                length = directory[at]
                if not length:
                    at = (at // 2048 + 1) * 2048
                    continue
                child, count, flags, raw_name = record(directory[at:at+length])
                at += length
                if raw_name in (b'\x00', b'\x01'):
                    continue
                name = raw_name.decode('ascii').split(';')[0]
                full = prefix + '/' + name
                if flags & 2:
                    walk(child, count, full)
                elif name.upper() == 'LEVEL_01.PRX':
                    f.seek(child * 2048)
                    content = f.read(count)
                    assert len(content) == count
                    entry = {'iso_path': full, 'extent': child, 'bytes': count,
                             'magic_hex': content[:16].hex(), 'sha256': hashlib.sha256(content).hexdigest()}
                    if content[:6] == b'\x7fELF\x01\x01':
                        h = struct.unpack_from('<16sHHIIIIIHHHHHH', content)
                        ph = [struct.unpack_from('<IIIIIIII', content, h[5]+i*h[9]) for i in range(h[10])]
                        words = {}
                        for rva in (0x151E0, 0x2FCFC, 0x2FBBC, 0x96650):
                            s = next(s for s in ph if s[0] == 1 and s[2] <= rva < s[2]+s[4])
                            words[hex(rva)] = hex(struct.unpack_from('<I', content, s[1]+rva-s[2])[0])
                        entry['core_words'] = words
                    entries.append(entry)
        walk(root_extent, root_size, '')
        result['level_01'] = entries
    return result

config_path = MEMSTICK / 'PSP/SYSTEM/ppsspp.ini'
cfg = configparser.ConfigParser(interpolation=None, strict=False)
cfg.optionxform = str
cfg.read(config_path, encoding='utf-8-sig')
keys = {'General': ['CurrentDirectory', 'EnableCheats', 'EnablePlugins', 'LoadPlugins', 'RemoteISOPort', 'RemoteDebuggerOnStartup', 'PauseOnLostFocus', 'PauseWhenMinimized', 'RunBehindPauseMenu'],
        'CPU': ['CPUCore', 'CPUSpeed', 'FastMemoryAccess'],
        'Graphics': ['GraphicsBackend', 'FrameSkip', 'AutoFrameSkip', 'VSync', 'InternalResolution', 'FrameRate', 'FrameRate2'],
        'Control': ['AnalogDeadzone', 'AnalogSensitivity', 'AnalogIsCircular', 'AnalogInverseDeadzone']}
result = {'utc': datetime.datetime.now(datetime.timezone.utc).isoformat(),
          'git_head': subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=ROOT, text=True).strip(),
          'script_sha256': sha(Path(__file__)),
          'scope': 'Candidate filesystem provenance only; active ISO/config and selected save slot not established by file presence or Recent.',
          'executable': identity(Path('C:/Program Files/PPSSPP/PPSSPPWindows64.exe')),
          'candidate_config': identity(config_path),
          'selected_settings': {section: {k: cfg.get(section, k, fallback=None) for k in names} for section, names in keys.items()},
          'per_game_configs': [identity(p) for p in sorted((MEMSTICK/'PSP/SYSTEM').glob('*UCES00420*')) if p.is_file()],
          'saves': [identity(p) for d in sorted((MEMSTICK/'PSP/SAVEDATA').glob('UCES00420*')) for p in sorted(d.rglob('*')) if p.is_file()],
          'isos': [iso_modules(ISO_DIR/name) for name in ('Ratchet & Clank - Size Matters (Europe) (PSN).iso', 'copy.iso')]}
directory = OUT / ('provenance-' + datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ'))
directory.mkdir()
(directory/'record.json').write_text(json.dumps(result, indent=2)+'\n', encoding='utf-8', newline='\n')
(directory/'script.py').write_bytes(Path(__file__).read_bytes())
print(json.dumps({'directory': str(directory), 'isos': result['isos'], 'per_game_configs': result['per_game_configs'], 'save_file_count': len(result['saves'])}, indent=2))
