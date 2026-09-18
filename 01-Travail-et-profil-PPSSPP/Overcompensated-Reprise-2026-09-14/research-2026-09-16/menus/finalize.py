from elf_menu import *
p=Elf(BIN/'LEVEL_04.PRX')
rows=[]
for a in [0x2cf7bc,0x2cf7e4]:
 d=p.read(a,40);rows.append(dict(rva=hex(a),raw_hex=d.hex(),color_words=[hex(x) for x in struct.unpack_from('<2I',d)],value_min_max_up_down=struct.unpack_from('<5f',d,8),direction_mode_counter=struct.unpack_from('<3I',d,28)))
(OUT/'pause-cycles.json').write_text(json.dumps(rows,indent=2,allow_nan=False))
manifest=dict(status='static_candidate_not_applied',module='LEVEL_04.PRX',sha256=hashlib.sha256(p.b).hexdigest(),function_rva='0xA6A34',writes=[])
for a in [0x2cf7bc,0x2cf7e4]:
 for off in [20,24]:
  old=struct.unpack('<I',p.read(a+off,4))[0];v=struct.unpack('<f',p.read(a+off,4))[0];new=struct.unpack('<I',struct.pack('<f',v*.5))[0];manifest['writes'].append(dict(rva=hex(a+off),expected=hex(old),replacement=hex(new),original_float=v,replacement_float=v*.5))
(OUT/'pause-blink-candidate.json').write_text(json.dumps(manifest,indent=2))
for name in ['straddle.junk','LEVEL_04.PRX','FRONTEND.PRX']:
 path=BIN/name;print(name,len(path.read_bytes()),hashlib.sha256(path.read_bytes()).hexdigest())
