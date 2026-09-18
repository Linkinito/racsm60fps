from pathlib import Path
p=Path(r'C:\Users\linki\Documents\PPSSPP\Documentation-Overcompensated-2026-09-15\build_docs.py')
s=p.read_text(encoding='utf-8');s=s.replace("{x['callsite_count']} sites sur {x['module_count']} modules. {note} Indices", "{x['callsite_count']} site{'s' if int(x['callsite_count'])>1 else ''} sur {x['module_count']} module{'s' if int(x['module_count'])>1 else ''}. {note.rstrip('.')}. Indices")
p.write_text(s,encoding='utf-8')
