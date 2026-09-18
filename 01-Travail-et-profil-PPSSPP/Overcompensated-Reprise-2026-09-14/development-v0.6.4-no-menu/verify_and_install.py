from pathlib import Path
import hashlib,json,subprocess,shutil,datetime
root=Path(__file__).resolve().parent
project=root/'sources/profiler';plugin=root.parent.parent/'PSP/PLUGINS/SizeMattersWrapperProfiler'
hashfile=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
elf=project/'patch.elf';prx=project/'patch.prx'
nm=subprocess.check_output([str(root.parent/'toolchains/pspdev-win/bin/psp-nm.exe'),str(elf)],text=True)
assert not any(x in nm for x in ['rcsm_menu','menu_monitor','menu_stop','menu_load_choice','menu_save_choice'])
assert b'Overcompensated.fps' not in prx.read_bytes()
assert b'30 FPS (choisi)' not in prx.read_bytes()
assert not (plugin/'plugin.ini').exists(),'Plugin activation has changed; do not overwrite state'
old_hash=hashfile(plugin/'patch.prx')
assert old_hash=='2913a613e77b1e7c749a017fed334585dfd50c15db9ee9a659420ecdab25fc44',old_hash
backup=root/'backup-plugin-before-no-menu'
assert not backup.exists(),'Backup already exists; do not replace'
shutil.copytree(plugin,backup)
manifest={str(p.relative_to(backup)):hashfile(p) for p in backup.rglob('*') if p.is_file()}
assert all(hashfile(plugin/k)==v for k,v in manifest.items())
(root/'BACKUP_MANIFEST.json').write_text(json.dumps(manifest,indent=2)+'\n')
config=(plugin/'RCSMProfiler.ini').read_text(encoding='utf-8-sig').replace('0.6.3-generalisation-dev.2','0.6.4-no-menu-dev.1').replace('; Applied on plugin start or a verified module reload, never mid-round.','; Startup INI only: menu toggle and sidecar preference have been removed.')
runtime=root/'runtime-no-menu';runtime.mkdir()
(runtime/'RCSMProfiler.ini').write_text(config,encoding='utf-8')
shutil.copy2(prx,runtime/'patch.prx')
shutil.copy2(plugin/'plugin.ini.desactive-pour-test',runtime/'plugin.ini.desactive-pour-test')
shutil.copy2(runtime/'patch.prx',plugin/'patch.prx')
shutil.copy2(runtime/'RCSMProfiler.ini',plugin/'RCSMProfiler.ini')
sidecar=plugin/'Overcompensated.fps'
if sidecar.exists():
    assert hashfile(sidecar)==hashfile(backup/'Overcompensated.fps')
    sidecar.unlink()
assert hashfile(plugin/'patch.prx')==hashfile(prx)
assert not (plugin/'plugin.ini').exists()
report={'timestamp_local':datetime.datetime.now().isoformat(),'version':'0.6.4-no-menu-dev.1','installed':True,'enabled':False,'plugin_path':str(plugin),'backup':str(backup),'before_sha256':old_hash,'after_sha256':hashfile(prx),'bytes':prx.stat().st_size,'checks':{'menu_symbols_absent':True,'sidecar_path_absent_from_binary':True,'plugin_disabled_preserved':True,'backup_all_files_sha256_verified':True},'sidecar':'removed from plugin after verified backup; no longer read or written by binary'}
(root/'INSTALLATION_NO_MENU.json').write_text(json.dumps(report,indent=2)+'\n')
build=json.loads((root/'BUILD_WINDOWS.json').read_text());build.update(installed=True,enabled=False,installed_path=str(plugin/'patch.prx'));(root/'BUILD_WINDOWS.json').write_text(json.dumps(build,indent=2)+'\n')
print(json.dumps(report,indent=2))
