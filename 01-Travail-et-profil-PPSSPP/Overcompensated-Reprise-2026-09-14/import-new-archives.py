from pathlib import Path
import hashlib, json, shutil, zipfile
root = Path(__file__).resolve().parent
names = ['Size_Matters_wrapper_dispatcher_v0.5.0-prealpha_UCES00420.zip', 'Overcompensated_v0.6.0_global_experimental_UCES00420.zip']
records = []
for name in names:
    source = Path('C:/Users/linki/Downloads') / name
    digest = hashlib.sha256(source.read_bytes()).hexdigest()
    target = root / 'archives' / name
    if target.exists() and hashlib.sha256(target.read_bytes()).hexdigest() != digest:
        raise RuntimeError('Archive conflict: ' + name)
    if not target.exists(): shutil.copy2(source, target)
    dest = root / ('sources-v0.6.0' if 'v0.6.0' in name else 'sources-v0.5.0')
    with zipfile.ZipFile(target) as z:
        for entry in z.infolist():
            p = (dest / entry.filename).resolve()
            if not p.is_relative_to(dest.resolve()) or (entry.external_attr >> 16) & 0o170000 == 0o120000:
                raise RuntimeError('Unsafe archive member: ' + entry.filename)
        if not dest.exists(): z.extractall(dest)
        records.append({'source': str(source), 'copy': str(target), 'sha256': digest, 'bytes': source.stat().st_size, 'members': len(z.infolist())})
    print('\nEXTRACTED', dest)
    for f in dest.rglob('*'):
        if f.is_file() and (f.suffix in ['.md', '.py'] or 'MANIFEST' in f.name or 'VALIDATION' in f.name): print(f.relative_to(dest))
(root / 'new-archives-manifest.json').write_text(json.dumps(records, indent=2), encoding='utf-8')
print(json.dumps(records, indent=2))
