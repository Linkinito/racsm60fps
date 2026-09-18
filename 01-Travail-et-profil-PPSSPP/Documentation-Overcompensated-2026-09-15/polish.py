from pathlib import Path
p=Path(r'C:\Users\linki\Documents\PPSSPP\Documentation-Overcompensated-2026-09-15\build_docs.py')
s=p.read_text(encoding='utf-8-sig')
s=s.replace("def save(d,name):d.save(OUT/(name+'.docx'))", "def save(d,name):\n for node in list(d.styles.element.iter(qn('w:pBdr')))+list(d.element.iter(qn('w:pBdr'))):\n  node.getparent().remove(node)\n d.save(OUT/(name+'.docx'))")
s=s.replace('à l’entrée de la fonction repérée à RVA 0x2AB54, après revalidation de la session','dans la fonction identifiée, après revalidation de la session')
s=s.replace('Les indices d’objets sont des associations statiques. [S2, S4]','Les indices sont des associations statiques : @0 indique la fonction de l’objet, @1 à @3 une proximité de un à trois appels. Seuls trois indices au plus sont affichés par famille. [S2, S4]')
p.write_text(s,encoding='utf-8')
