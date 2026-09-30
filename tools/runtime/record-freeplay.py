#!/usr/bin/env python3
"""Control only the FamilyRecorder PRX's two allowlisted configuration words.

The game core is never changed here. A0/C1 uses the separately guarded core tool.
Mode baseline exports clocks with no redirects; counters/samples install probes.
Finally requests off and verifies all original callsites/delays. Ambiguous module
binding is explicitly unresolved, never silently restored. No gameplay inputs.
"""
import argparse,base64,hashlib,importlib.util,json,struct,time
from pathlib import Path
REPO=Path(__file__).resolve().parents[2]
CLIENT=REPO/'research/live-tests/pokitaru/waterfall-001/ppsspp-ws.py'
MODES={'off':0,'counters':1,'samples':2,'baseline':3}
def load_client():
    spec=importlib.util.spec_from_file_location('freeplay_ws',CLIENT);mod=importlib.util.module_from_spec(spec);spec.loader.exec_module(mod);return mod
def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--build',type=Path,required=True);p.add_argument('--mode',choices=MODES,required=True)
    p.add_argument('--seconds',type=float,default=10);p.add_argument('--stride',type=int,default=8);p.add_argument('--port',type=int,default=60907);p.add_argument('--out',type=Path,required=True);p.add_argument('--trace-file',type=Path);a=p.parse_args()
    if a.out.exists() or not 0<a.seconds<=3600 or not 1<=a.stride<=1024:raise ValueError('invalid capture options/existing output')
    m=json.loads((a.build/'manifest.json').read_bytes());c=load_client();record={'status':'FAILED','mode':a.mode,'writes':[],'snapshots':[],
        'methodSha256':hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),'manifestSha256':hashlib.sha256((a.build/'manifest.json').read_bytes()).hexdigest()}
    plugin_base=None;game_base=None;owned_control=False
    class Writer(c.DebuggerClient):
        def control_write(self,address,value):
            control=plugin_base+m['symbols']['recorder_control']
            if address not in (control+8,control+12):raise c.WsError('outside plugin control allowlist')
            if address==control+8 and value not in MODES.values() or address==control+12 and not 1<=value<=1024:raise c.WsError('invalid plugin control value')
            modules=self.request('hle.module.list').get('modules',[])
            candidates=[x for x in modules if x.get('name')=='FamilyRecorder' and x.get('isActive')]
            if len(candidates)!=1 or candidates[0]['address']!=plugin_base:raise c.WsError('plugin binding changed: no writes')
            if read_control()['magic']!=0x31524652:raise c.WsError('plugin control signature changed')
            self.seq+=1;msg={'event':'memory.write_u32','address':address,'value':value,'ticket':'freeplay-%d'%self.seq}
            self._send_frame(json.dumps(msg).encode());deadline=time.monotonic()+c.REQUEST_TIMEOUT_S
            while True:
                reply=json.loads(self._recv_message())
                if reply.get('ticket')==msg['ticket']:
                    if reply.get('event')=='error' or reply.get('error'):raise c.WsError(str(reply))
                    break
                if time.monotonic()>deadline:raise c.WsError('control write acknowledgment lost')
            if c.read_word(self,address)!=value:raise c.WsError('control readback failed')
            record['writes'].append({'address':address,'value':value})
    client=Writer('127.0.0.1',a.port)
    def raw(address,size):
        r=client.request('memory.read',{'address':address,'size':size,'replacements':False});b=base64.b64decode(r.get('base64',''))
        if len(b)!=size:raise c.WsError('short memory read')
        return b
    def read_control():
        names=('magic','version','request','stride','status','base','epoch','installed','events','dropped','ioError','sequence','clockLo','clockHi','traceNumber')
        return dict(zip(names,struct.unpack('<15I',raw(plugin_base+m['symbols']['recorder_control'],60))))
    def clock_bracket():
        first=read_control();before=client.request('cpu.status');deadline=time.monotonic()+2
        while time.monotonic()<deadline:
            latest=read_control()
            if latest['sequence']>first['sequence']:
                after=client.request('cpu.status')
                return {'ticksBefore':before['ticks'],'ticksAfter':after['ticks'],'timeUs':latest['clockLo']+(latest['clockHi']<<32),'sequence':latest['sequence']}
            time.sleep(.03)
        raise c.WsError('recorder clock did not advance')
    def originals():
        for g in m['guards']:
            if c.read_word(client,game_base+g['rva'])!=g['word']:raise c.WsError('module content guard mismatch')
        for s in m['sites']:
            pair=struct.unpack('<II',raw(game_base+s['rva'],8));expected=c.jal_word(game_base+s['rva'],game_base+s['direct']) if s['direct'] else s['word']
            if pair!=(expected,s['delay']):raise c.WsError('callsite/delay not original at '+hex(s['rva']))
    try:
        client.connect();identity=c.identity(client);record['identityBefore']=identity;game_base=identity['module']['baseDecimal']
        if identity['game'].get('id')!='UCES00420' or identity['module']['size']!=0x46B900 or identity['state'] not in ('A0','C1'):raise c.WsError('requires UCES00420 Pokitaru A0/core-only C1')
        if identity['cpu']['paused'] or identity['cpu']['stepping'] or client.request('cpu.breakpoint.list').get('breakpoints'):raise c.WsError('CPU must run without breakpoints')
        modules=client.request('hle.module.list').get('modules',[])
        if any(any(t in x.get('name','').lower() for t in ('waterfall','rcsmprofiler','elevator')) for x in modules if x.get('isActive')):raise c.WsError('corrective companion loaded; core-only capture refused')
        matches=[x for x in modules if x.get('name')=='FamilyRecorder' and x.get('isActive')]
        if len(matches)!=1:raise c.WsError('FamilyRecorder not uniquely active')
        plugin_base=matches[0]['address'];control=plugin_base+m['symbols']['recorder_control']
        if control+60>plugin_base+matches[0]['size']:raise c.WsError('control outside plugin')
        start=read_control();record['controlBefore']=start
        if start['magic']!=0x31524652 or start['version']!=2 or start['request']!=0 or start['installed'] or start['status']!=0 or start['ioError']:raise c.WsError('recorder not idle/healthy')
        if raw(plugin_base+m['symbols']['recorder_build_id'],32).hex()!=m['buildId']:raise c.WsError('loaded build fingerprint mismatch')
        # Certify loaded hook bytes against the pinned linked ELF, allowing only
        # its single JAL relocation. No arbitrary plugin address is accepted.
        from importlib.util import spec_from_file_location,module_from_spec
        spec=spec_from_file_location('freeplay_builder',REPO/'patches/experimental/family-recorder/build.py');builder=module_from_spec(spec);spec.loader.exec_module(builder)
        elf=(a.build/'patch.elf').read_bytes();section=builder.sections(elf)['.text'];lo=m['symbols']['recorder_hook'];hi=m['symbols']['recorder_hook_end'];expected=bytearray(elf[section[4]+lo-section[3]:section[4]+hi-section[3]])
        for i in range(0,len(expected),4):
            w=struct.unpack_from('<I',expected,i)[0]
            if w>>26==3:struct.pack_into('<I',expected,i,c.jal_word(plugin_base+lo+i,plugin_base+m['symbols']['recorder_hit']))
        if raw(plugin_base+lo,len(expected))!=expected:raise c.WsError('loaded hook binary does not match build')
        originals();owned_control=True
        client.control_write(control+12,a.stride);client.control_write(control+8,MODES[a.mode]);start_host=time.monotonic();record['cpuStart']=client.request('cpu.status')
        if a.mode!='off':record['clockStart']=clock_bracket()
        while time.monotonic()-start_host<a.seconds:
            time.sleep(min(1,a.seconds));snap=read_control();record['snapshots'].append({'hostSeconds':time.monotonic()-start_host,'control':snap,'cpu':client.request('cpu.status')})
            now=c.identity(client)
            if now['module']!=identity['module'] or now['state']!=identity['state']:raise c.WsError('module/core changed during capture')
            if snap['ioError'] or snap['status'] in (2,3,4):raise c.WsError('recorder refused/ambiguous binding or IO failure')
            if a.mode in ('counters','samples') and not snap['installed']:raise c.WsError('probe installation failed')
        if a.mode!='off':
            record['clockEnd']=clock_bracket();x,y=record['clockStart'],record['clockEnd'];us=y['timeUs']-x['timeUs']
            if us<=0:raise c.WsError('invalid emulated clock span')
            bounds=[(y['ticksBefore']-x['ticksAfter'])/us,(y['ticksAfter']-x['ticksBefore'])/us]
            if not 0<bounds[0]<=bounds[1]:raise c.WsError('non-positive/inconsistent emulated tick calibration')
            record['clockCalibration']={'microseconds':us,'ticksPerMicrosecondBounds':bounds,'status':'BRACKETED_NOT_ASSUMED_HOST_TIME'}
        record['cpuEnd']=client.request('cpu.status');record['hostSeconds']=time.monotonic()-start_host;record['status']='CAPTURED_NOT_PARITY'
    except BaseException as error:
        record['error']=str(error);raise
    finally:
        if owned_control:
            final=None
            try:
                client.control_write(plugin_base+m['symbols']['recorder_control']+8,0)
                deadline=time.monotonic()+3
                while time.monotonic()<deadline:
                    final=read_control()
                    if not final['installed']:break
                    time.sleep(.1)
                record['controlAfter']=final
                if final is None or final['installed'] or final['status'] in (3,4):raise c.WsError('cleanup unresolved: fully close PPSSPP before further captures')
                fresh=c.identity(client)
                if fresh['module']!=record['identityBefore']['module']:raise c.WsError('module changed during cleanup')
                originals();record['cleanup']='ALL_ORIGINAL_CALLSITES_AND_DELAYS_VERIFIED'
                if a.trace_file:
                    import re
                    expected_path=Path('C:/Users/linki/Documents/PPSSPP/PSP/PLUGINS/FamilyRecorder')/('trace-%03d.bin'%start['traceNumber'])
                    if a.trace_file.resolve()!=expected_path.resolve():raise c.WsError('trace path is not the active plugin output')
                    target=a.out.with_suffix('.trace.bin')
                    if target.exists():raise c.WsError('refusing raw trace overwrite')
                    time.sleep(.3);data=a.trace_file.read_bytes();time.sleep(.1)
                    if a.trace_file.read_bytes()!=data:raise c.WsError('trace still changing after disarm')
                    spec=spec_from_file_location('freeplay_trace',REPO/'tools/runtime/analyze-freeplay.py');decoder=module_from_spec(spec);spec.loader.exec_module(decoder)
                    decoded=decoder.read_trace(a.trace_file,m);latest=read_control()
                    if decoded['truncatedTail'] or not decoded['chunks'] or decoded['chunks'][-1]['traceNumber']!=start['traceNumber'] or decoded['chunks'][-1]['sequence']+1!=latest['sequence']:raise c.WsError('trace identity/completion does not match the active recorder')
                    with target.open('xb') as stream:stream.write(data)
                    record['trace']={'path':str(target),'sha256':hashlib.sha256(data).hexdigest()}
            except BaseException as error:record['cleanup']='UNRESOLVED';record['cleanupError']=str(error);record['status']='FAILED_OR_PARTIAL'
        record['requests']=client.log;a.out.parent.mkdir(parents=True,exist_ok=True);a.out.write_text(json.dumps(record,indent=1),encoding='utf-8');client.close()
    print(json.dumps({'status':record['status'],'cleanup':record.get('cleanup'),'out':str(a.out)}))
    if record['status']=='FAILED_OR_PARTIAL':raise SystemExit(2)
if __name__=='__main__':main()
