from pathlib import Path
from pdf2image import convert_from_path
from pypdf import PdfReader
from PIL import Image,ImageDraw
root=Path(r'C:\Users\linki\Documents\PPSSPP\Documentation-Overcompensated-2026-09-15\qa')
poppler=r'C:\Users\linki\.cache\codex-runtimes\codex-primary-runtime\dependencies\native\poppler\Library\bin'
for pdf in root.glob('*.pdf'):
 folder=root/pdf.stem;folder.mkdir(exist_ok=True)
 pages=convert_from_path(str(pdf),dpi=105,poppler_path=poppler)
 thumbs=[]
 for i,im in enumerate(pages):
  im.save(folder/f'page-{i+1}.png');im.thumbnail((400,566));tile=Image.new('RGB',(420,596),'#cccccc');tile.paste(im,((420-im.width)//2,10));ImageDraw.Draw(tile).text((10,578),str(i+1),fill='black');thumbs.append(tile)
 for i,page in enumerate(PdfReader(pdf).pages):print(pdf.stem,i+1,'words',len(page.extract_text().split()))
 for start in range(0,len(thumbs),6):
  subset=thumbs[start:start+6];sheet=Image.new('RGB',(420*min(3,len(subset)),596*((len(subset)+2)//3)),'white')
  for j,im in enumerate(subset):sheet.paste(im,((j%3)*420,(j//3)*596))
  sheet.save(folder/f'contact-{start//6+1}.png')
