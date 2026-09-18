"""Bounded, read-only search in archived conversation pages."""
import argparse, json
from pathlib import Path
p=argparse.ArgumentParser()
p.add_argument('query')
p.add_argument('--limit',type=int,default=5)
p.add_argument('--chars',type=int,default=1000)
a=p.parse_args()
root=Path(__file__).resolve().parent/'history'
hits=[]
for f in sorted(root.glob('*-??.json')):
    d=json.loads(f.read_text(encoding='utf-8'))
    for t in d['turns']:
        for item in t['items']:
            text=item.get('text','') if item['type']=='agentMessage' else '\n'.join(c.get('text','') for c in item.get('content',[]))
            pos=text.casefold().find(a.query.casefold())
            if pos<0: continue
            start=max(0,pos-150)
            hits.append({'title':d['thread']['title'],'thread':d['thread']['id'],'turn':t['id'],'role':item['type'],'source':str(f),'excerpt':text[start:start+max(100,min(a.chars,5000))]})
print(json.dumps({'total_matches':len(hits),'results':hits[:max(1,min(a.limit,30))]},ensure_ascii=False,indent=2))
