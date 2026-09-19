"""Verify preserved save bytes and decode limited SFO metadata without launching PPSSPP."""
from pathlib import Path
import datetime
import hashlib
import json
import struct

HERE = Path(__file__).resolve().parent
STAGING = HERE / 'a0-staging-20260919T144841Z'
manifest = json.loads((STAGING / 'manifest.json').read_text(encoding='utf-8'))
def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest() if path.is_file() else None
def sfo(path):
    data = path.read_bytes()
    magic, version, keys, values, count = struct.unpack_from('<4sIIII', data)
    assert magic == b'\x00PSF' and count < 1000
    result = {}
    for i in range(count):
        key_offset, kind, length, capacity, value_offset = struct.unpack_from('<HHIII', data, 20 + 16*i)
        start = keys + key_offset
        key = data[start:data.index(0, start)].decode('utf-8')
        if key not in ('TITLE', 'SAVEDATA_TITLE', 'SAVEDATA_DIRECTORY'):
            continue
        assert values + value_offset + length <= len(data)
        raw = data[values+value_offset:values+value_offset+length].split(b'\x00', 1)[0]
        try:
            text = raw.decode('utf-8')
        except UnicodeDecodeError:
            text = None
        result[key] = {'text': text, 'raw_hex': raw.hex(), 'format': hex(kind), 'encoding_status': 'UTF-8' if text is not None else 'UNKNOWN'}
    return result
checks = []
metadata = []
for item in manifest['files']:
    rel = item['relative_path']
    copied = STAGING / 'local/save-snapshot' / rel
    source = Path(manifest['source_root']) / rel
    checks.append({'relative_path': rel, 'snapshot_matches_manifest': sha(copied) == item['sha256'],
                   'original_still_matches_snapshot': sha(source) == item['sha256']})
    if copied.name == 'PARAM.SFO':
        metadata.append({'relative_path': rel, 'fields': sfo(copied)})
result = {'utc': datetime.datetime.now(datetime.timezone.utc).isoformat(),
          'script_sha256': sha(Path(__file__)), 'manifest_sha256': sha(STAGING/'manifest.json'),
          'checks': checks, 'sfo_metadata': metadata,
          'scope': 'Byte preservation and SFO strings only. No emulator launch or proof of in-game slot ordering, health, equipment, scene or RAM state.'}
output = HERE / ('save-audit-' + datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ') + '.json')
output.write_text(json.dumps(result, indent=2)+'\n', encoding='utf-8', newline='\n')
print(json.dumps({'file': str(output), 'count': len(checks), 'snapshot_intact': all(c['snapshot_matches_manifest'] for c in checks),
                  'original_unchanged': all(c['original_still_matches_snapshot'] for c in checks), 'metadata': metadata}, indent=2))
assert all(c['snapshot_matches_manifest'] for c in checks), 'Preserved snapshot mismatch'
