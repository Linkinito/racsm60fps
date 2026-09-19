"""Record the player address operand and its ELF relocations; no live access."""
from pathlib import Path
import hashlib
import json
import struct

ROOT = Path(__file__).resolve().parents[3]
SOURCE = ROOT / '01-Travail-et-profil-PPSSPP/Overcompensated-Reprise-2026-09-14/development-v0.6.3-generalisation/prx-reference/LEVEL_01.PRX'
data = SOURCE.read_bytes()
digest = hashlib.sha256(data).hexdigest()
assert digest == 'd10a81d076fb44987a45314a020cda2f7e8b39f860b957911ca9365464676571'
header = struct.unpack_from('<16sHHIIIIIHHHHHH', data)
assert data[:6] == b'\x7fELF\x01\x01'
segments = [struct.unpack_from('<IIIIIIII', data, header[5] + i * header[9]) for i in range(header[10])]
sections = [struct.unpack_from('<IIIIIIIIII', data, header[6] + i * header[11]) for i in range(header[12])]
words = []
for address in (0x30014, 0x30018):
    segment = next(s for s in segments if s[0] == 1 and s[2] <= address < s[2] + s[4])
    offset = segment[1] + address - segment[2]
    words.append({'rva': hex(address), 'file_offset': hex(offset), 'word': hex(struct.unpack_from('<I', data, offset)[0])})
relocations = []
for index, section in enumerate(sections):
    if section[1] != 0x700000A0:
        continue
    assert section[9] == 8 and section[5] % 8 == 0
    for offset in range(section[4], section[4] + section[5], 8):
        address, info = struct.unpack_from('<II', data, offset)
        if address in (0x30014, 0x30018):
            relocations.append({'section_index': index, 'file_offset': hex(offset), 'r_offset': hex(address), 'r_info': hex(info)})
assert [w['word'] for w in words] == ['0x3c100006', '0x2610a838']
assert [(r['r_offset'], r['r_info']) for r in relocations] == [('0x30014', '0x10005'), ('0x30018', '0x10006')]
result = {
    'source': SOURCE.relative_to(ROOT).as_posix(), 'source_sha256': digest,
    'script_sha256': hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
    'scope': 'Static file observations only; no loader execution, live pointer, ISO provenance or gameplay validation.',
    'load_segments': [{'index': i, 'offset': hex(s[1]), 'vaddr': hex(s[2]), 'file_size': hex(s[4]), 'memory_size': hex(s[5])} for i, s in enumerate(segments) if s[0] == 1],
    'words': words, 'relocations': relocations,
    'conclusion': 'The unrelocated operand 0x5A838 has relocation entries. A live player address cannot be justified by adding the code base alone; resolve loader semantics or capture the relocated pair and call argument.'
}
output = Path(__file__).with_name('player-address-evidence.json')
output.write_text(json.dumps(result, indent=2) + '\n', encoding='utf-8', newline='\n')
print(output.relative_to(ROOT).as_posix())
