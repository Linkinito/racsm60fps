"""Copy game saves to a new local staging directory; never modify source saves."""
from pathlib import Path
import datetime
import hashlib
import json
import shutil

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[3]
SOURCE = ROOT.parent / 'PSP/SAVEDATA'
stamp = datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ')
target = HERE / ('a0-staging-' + stamp)
target.mkdir()
(target / '.gitignore').write_text('/local/\n', encoding='utf-8', newline='\n')
def sha(p):
    return hashlib.sha256(p.read_bytes()).hexdigest()
records = []
for folder in sorted(SOURCE.glob('UCES00420*')):
    for source in sorted(folder.rglob('*')):
        if not source.is_file():
            continue
        relative = source.relative_to(SOURCE)
        destination = target / 'local/save-snapshot' / relative
        destination.parent.mkdir(parents=True, exist_ok=True)
        before = sha(source)
        shutil.copy2(source, destination)
        copied, after = sha(destination), sha(source)
        assert before == copied == after, 'Save changed during copying; preserve failed staging'
        records.append({'relative_path': relative.as_posix(), 'bytes': source.stat().st_size, 'sha256': before})
assert len(records) > 0
result = {'utc': stamp, 'source_root': str(SOURCE), 'script_sha256': sha(Path(__file__)),
          'owner_report': {'slot': 5, 'iso': 'Ratchet & Clank - Size Matters (Europe) (PSN).iso', 'lineage': 'Normal boot from ordinary save, Pokitaru, vanilla'},
          'scope': 'All five game-save folders copied to preserve slot mapping; slot5-to-DATA4 mapping not independently established. Staging only: no emulator launched, no config copied, no original save changed.',
          'files': records}
(target/'manifest.json').write_text(json.dumps(result, indent=2)+'\n', encoding='utf-8', newline='\n')
(target/'script.py').write_bytes(Path(__file__).read_bytes())
print(json.dumps({'target': str(target), 'verified_files': len(records)}))
