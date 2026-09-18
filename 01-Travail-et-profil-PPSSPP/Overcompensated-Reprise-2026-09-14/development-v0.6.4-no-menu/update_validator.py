from pathlib import Path
p=Path(__file__).resolve().parent/'sources/profiler/tools/validate_prx.py'
s=p.read_text(encoding='utf-8-sig').replace('0.6.3-generalisation-dev.2','0.6.4-no-menu-dev.1').replace('version 0.6.3 int','version 0.6.4 int')
s=s.replace('''        candidate = pspdev / "bin" / name
        if candidate.is_file():
            return candidate''','''        for executable in (name, name + ".exe"):
            candidate = pspdev / "bin" / executable
            if candidate.is_file():
                return candidate''')
p.write_text(s,encoding='utf-8')
