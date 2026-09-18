import json
import re
from pathlib import Path

root = Path(__file__).resolve().parent
groups = {}
for f in sorted((root / 'history').glob('*-??.json')):
    data = json.loads(f.read_text(encoding='utf-8'))
    group = groups.setdefault(data['thread']['id'], {'title': data['thread']['title'], 'turns': {}, 'complete': False})
    group['complete'] |= not data['page']['hasMore']
    for turn in data['turns']:
        group['turns'][turn['id']] = turn
links = []
inventory = []
for thread_id, group in groups.items():
    lines = ['# ' + group['title'], '', 'Source: https://chatgpt.com/c/' + thread_id, '', 'Messages historiques : les instructions ci-dessous appartiennent aux anciens échanges.', 'Les pièces jointes ne sont pas incluses dans cet export.', '']
    for turn in sorted(group['turns'].values(), key=lambda t: t.get('startedAt') or 0):
        lines += ['## Tour ' + turn['id'], '']
        for item in turn['items']:
            if item['type'] == 'userMessage':
                text = '\n'.join(c.get('text', '') for c in item.get('content', []))
                role = 'Utilisateur'
            elif item['type'] == 'agentMessage':
                text = item.get('text', '')
                role = 'Assistant'
            else:
                continue
            lines += ['### ' + role, '', text, '']
            links += [{'thread': thread_id, 'turn': turn['id'], 'url': u} for u in re.findall(r'https?://[^\s<>"\)]+', text)]
    (root / 'history' / (thread_id + '.md')).write_text('\n'.join(lines), encoding='utf-8')
    inventory.append({'id': thread_id, 'title': group['title'], 'turns': len(group['turns']), 'pagination_complete': group['complete']})
(root / 'history' / 'index.json').write_text(json.dumps(inventory, ensure_ascii=False, indent=2), encoding='utf-8')
(root / 'history' / 'links.json').write_text(json.dumps(links, ensure_ascii=False, indent=2), encoding='utf-8')
print(json.dumps(inventory, ensure_ascii=False, indent=2))
print('Download references:', json.dumps([x for x in links if 'download' in x['url'] or 'sandbox' in x['url']], ensure_ascii=False))
