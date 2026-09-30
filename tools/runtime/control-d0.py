#!/usr/bin/env python3
"""Request only D0's two control words. Never writes game code/core directly.

Trial automatically requests off and independently verifies original rule words.
Lost write acknowledgment triggers cleanup; disconnect remains UNRESOLVED.
"""
import argparse,base64,hashlib,importlib.util,json,struct,time
from pathlib import Path
ROOT=Path(__file__).resolve().parents[2]
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('--build',type=Path,required=True);p.add_argument('--tests',type=Path,required=True)
    p.add_argument('--action',choices=['status','trial','arm','off'],required=True)
    p.add_argument('--profile',choices=['help','help-wave'],default='help')
    p.add_argument('--allow-unmeasured-enemywave',action='store_true')
    p.add_argument('--seconds',type=float,default=5);p.add_argument('--port',type=int,default=60907)
    p.add_argument('--expected-base',type=lambda s:int(s,0),default=None)
    p.add_argument('--out',type=Path,required=True);a=p.parse_args()
    if a.out.exists() or not 0<a.seconds<=60:raise ValueError('existing output/invalid duration')
    if a.profile=='help-wave' and not a.allow_unmeasured_enemywave:raise ValueError('EnemyWave trial requires explicit unmeasured opt-in')
    m=json.loads((a.build/'manifest.json').read_bytes());tests=json.loads(a.tests.read_bytes())
    if tests['status']!='OFFLINE_PASS_NOT_RUNTIME_ACCEPTED' or tests['manifestSha256']!=sha(a.build/'manifest.json') or sha(a.build/'patch.prx')!=m['prxSha256']:raise ValueError('build/offline result mismatch')
    for name,expected in m['inputs'].items():
        if sha(ROOT/name)!=expected:raise ValueError('build input changed: '+name)
    if sha(ROOT/'patches/experimental/d0-temporal/test_offline.py')!=tests['testSourceSha256']:raise ValueError('offline method changed')
    spec=importlib.util.spec_from_file_location('d0_ws',ROOT/'research/live-tests/pokitaru/waterfall-001/ppsspp-ws.py')
    ws=importlib.util.module_from_spec(spec);spec.loader.exec_module(ws)
    plugin_base=None;control=None;game_base=None;intent=False;completed=False
    rec={'status':'FAILED','profile':a.profile,'action':a.action,'writes':[],'snapshots':[],
         'methodSha256':sha(Path(__file__)),'manifestSha256':sha(a.build/'manifest.json')}
    class Writer(ws.DebuggerClient):
        def config_write(self,address,value):
            allowed={control+8:(0,1,3),control+12:(0,0xD0000002)}
            if address not in allowed or value not in allowed[address]:raise ws.WsError('outside D0 control allowlist')
            verify_plugin()
            self.seq+=1;ticket='d0-%d'%self.seq
            message={'event':'memory.write_u32','address':address,'value':value,'ticket':ticket}
            self._send_frame(json.dumps(message).encode());deadline=time.monotonic()+ws.REQUEST_TIMEOUT_S
            while True:
                reply=json.loads(self._recv_message())
                if reply.get('ticket')==ticket:
                    if reply.get('event')=='error' or reply.get('error'):raise ws.WsError('D0 control write refused')
                    break
                if time.monotonic()>deadline:raise ws.WsError('D0 write acknowledgment lost')
            if ws.read_word(self,address)!=value:raise ws.WsError('D0 control readback failed')
            rec['writes'].append({'address':address,'value':value})
    client=Writer('127.0.0.1',a.port)
    def raw(addr,size):
        data=base64.b64decode(client.request('memory.read',{'address':addr,'size':size,'replacements':False}).get('base64',''))
        if len(data)!=size:raise ws.WsError('short read')
        return data
    def read_control():
        fields=('magic','abi','request','enemyGate','installed','status','base','moduleId','generation','error')
        return dict(zip(fields,struct.unpack('<10I',raw(control,40))))
    def verify_plugin():
        modules=client.request('hle.module.list').get('modules',[])
        matches=[x for x in modules if x.get('name')=='D0Temporal' and x.get('isActive')]
        if len(matches)!=1 or matches[0]['address']!=plugin_base:raise ws.WsError('plugin binding changed/no writes')
        if control<plugin_base or control+40>plugin_base+matches[0]['size']:raise ws.WsError('ABI outside plugin')
        sig=read_control()
        if sig['magic']!=0x44305430 or sig['abi']!=1:raise ws.WsError('D0 ABI mismatch')
        if raw(plugin_base+m['symbols']['d0_build_id'],32).hex()!=m['buildId']:raise ws.WsError('loaded D0 build mismatch')
        return sig
    def verify_words(mask):
        identity=ws.identity(client)
        if identity['module']['baseDecimal']!=game_base or identity['module']['size']!=0x46B900:raise ws.WsError('target module changed')
        for g in m['guards']:
            if ws.read_word(client,game_base+g['rva'])!=g['word']:raise ws.WsError('content guard mismatch')
        for r in m['rules']:
            if ws.read_word(client,game_base+r['rva'])!=(r['after'] if mask&r['bit'] else r['before']):raise ws.WsError('rule readback mismatch '+r['name'])
        return identity
    def wait_mask(mask):
        deadline=time.monotonic()+3
        while time.monotonic()<deadline:
            snap=verify_plugin()
            if snap['request']==mask and snap['installed']==mask and snap['status'] in ((2,) if mask else (0,4)):
                verify_words(mask);return snap
            if snap['status'] in (3,5):raise ws.WsError('D0 unresolved/refused '+str(snap))
            time.sleep(.05)
        raise ws.WsError('D0 transition timeout')
    try:
        client.connect();identity=ws.identity(client);rec['identityBefore']=identity
        if identity['game'].get('id')!='UCES00420' or identity['module']['size']!=0x46B900:raise ws.WsError('requires supported Pokitaru')
        game_base=identity['module']['baseDecimal']
        if a.expected_base is not None and game_base!=a.expected_base:raise ws.WsError('module differs from expected switch binding; no writes')
        modules=client.request('hle.module.list').get('modules',[])
        matches=[x for x in modules if x.get('name')=='D0Temporal' and x.get('isActive')]
        if len(matches)!=1:raise ws.WsError('D0Temporal not uniquely loaded')
        plugin_base=matches[0]['address'];control=plugin_base+m['symbols']['d0_control']
        start=verify_plugin();rec['controlBefore']=start
        verify_words(start['installed'])
        if a.action=='status':rec['status']='OBSERVED_CONTROL_NOT_GAMEPLAY_ACCEPTANCE';completed=True
        elif a.action=='off':
            intent=True;client.config_write(control+8,0);rec['controlAfter']=wait_mask(0)
            rec['status']='ORIGINAL_RULE_WORDS_VERIFIED';completed=True
        else:
            if identity['state']!='C1' or identity['cpu']['paused'] or identity['cpu']['stepping'] or client.request('cpu.breakpoint.list').get('breakpoints'):raise ws.WsError('requires running C1 without breakpoints')
            if start['request'] or start['installed'] or start['status'] not in (0,4):raise ws.WsError('D0 must start idle')
            if any(any(s in x.get('name','').lower() for s in ('waterfall','rcsmprofiler','elevator')) for x in modules if x.get('isActive')):raise ws.WsError('first D0 trial requires core-only profile')
            rec['cpuStart']=client.request('cpu.status');intent=True
            client.config_write(control+12,0xD0000002 if a.profile=='help-wave' else 0)
            mask=3 if a.profile=='help-wave' else 1
            client.config_write(control+8,mask);rec['controlActive']=wait_mask(mask)
            deadline=time.monotonic()+(a.seconds if a.action=='trial' else .25)
            while time.monotonic()<deadline:
                time.sleep(.1);snap=verify_plugin();now=verify_words(mask)
                if snap['installed']!=mask or snap['status']!=2 or now['state']!='C1':raise ws.WsError('D0/core changed during trial')
                rec['snapshots'].append(snap)
            rec['cpuEnd']=client.request('cpu.status')
            if rec['cpuEnd']['ticks']<=rec['cpuStart']['ticks']:raise ws.WsError('CPU ticks did not advance')
            rec['status']='RULE_INSTALLATION_VERIFIED_NOT_GAMEPLAY_PARITY';completed=True
    except BaseException as error:rec['error']=str(error);raise
    finally:
        if intent and not (a.action=='arm' and completed):
            try:
                client.config_write(control+8,0);rec['controlAfter']=wait_mask(0)
                rec['cleanup']='ALL_D0_RULES_ORIGINAL_VERIFIED'
            except BaseException as error:
                rec['cleanup']='UNRESOLVED';rec['cleanupError']=str(error);rec['status']='FAILED_OR_PARTIAL'
        rec['requests']=client.log;a.out.parent.mkdir(parents=True,exist_ok=True)
        a.out.write_bytes((json.dumps(rec,indent=2)+'\n').encode());client.close()
    print(json.dumps({'status':rec['status'],'cleanup':rec.get('cleanup'),'out':str(a.out)}))
    if rec['status']=='FAILED_OR_PARTIAL':raise SystemExit(2)
if __name__=='__main__':main()
