#!/usr/bin/env python3
"""Exercise the real D0 controller on an in-memory debugger/PRX ABI.

The mock PRX applies the linked engine already tested offline. No network/live IO.
"""
import argparse,hashlib,importlib.abc,importlib.util,json,struct,sys,types
from pathlib import Path
from unittest.mock import patch
ROOT=Path(__file__).resolve().parents[3]
def load(name,path):
    s=importlib.util.spec_from_file_location(name,path);m=importlib.util.module_from_spec(s);s.loader.exec_module(m);return m
def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--build',type=Path,required=True)
    p.add_argument('--tests',type=Path,required=True);p.add_argument('--out',type=Path,required=True);a=p.parse_args()
    if a.out.exists():raise ValueError('existing result')
    a.out.parent.mkdir(parents=True,exist_ok=True)
    controller=load('d0_control_test',ROOT/'tools/runtime/control-d0.py')
    engine=load('d0_engine_model',ROOT/'patches/experimental/d0-temporal/test_offline.py')
    manifest=json.loads((a.build/'manifest.json').read_bytes());elf=(a.build/'patch.elf').read_bytes()
    results=[];case=None;client=None
    class WsError(RuntimeError):pass
    class Client:
        def __init__(self,*args):
            nonlocal client
            client=self;self.seq=0;self.log=[];self.mem={};self.sent=[];self.reply=None;self.ticks=100;self.disconnected=False;self.lost=False
            self.base=0x09139D00;self.plugin=0x08900000;self.control=self.plugin+manifest['symbols']['d0_control']
            self.words=[0x44305430,1,0,0,0,0,0,0,0,0]
            self.mem[self.plugin+manifest['symbols']['d0_build_id']]=bytes.fromhex(manifest['buildId'])
            if case=='bad-build':self.mem[self.plugin+manifest['symbols']['d0_build_id']]=bytes(32)
            for g in manifest['guards']:self.mem[self.base+g['rva']]=struct.pack('<I',g['word'])
            for r in manifest['rules']:self.mem[self.base+r['rva']]=struct.pack('<I',r['before'])
            if case=='foreign':self.mem[self.base+manifest['rules'][0]['rva']]=struct.pack('<I',0xBAD0CAFE)
        def connect(self):pass
        def close(self):pass
        def raw(self,address,size):
            if self.control<=address and address+size<=self.control+40:return struct.pack('<10I',*self.words)[address-self.control:address-self.control+size]
            return self.mem[address]
        def request(self,event,fields=None):
            if self.disconnected:raise WsError('disconnected')
            self.log.append(event)
            if event=='hle.module.list':return {'modules':[{'name':'D0Temporal','isActive':True,'address':self.plugin,'size':0x40000}]}
            if event=='memory.read':
                import base64
                return {'base64':base64.b64encode(self.raw(fields['address'],fields['size'])).decode()}
            if event=='cpu.status':self.ticks+=222000;return {'ticks':self.ticks,'paused':False,'stepping':False}
            if event=='cpu.breakpoint.list':return {'breakpoints':[]}
            raise AssertionError('unexpected request '+event)
        def _send_frame(self,data):
            if self.disconnected:raise WsError('disconnected')
            message=json.loads(data);self.sent.append(message)
            assert message['event']=='memory.write_u32'
            assert message['address'] in (self.control+8,self.control+12)
            self.words[(message['address']-self.control)//4]=message['value']
            if message['address']==self.control+8:
                result,owned,game,writes,steps=engine.run_engine(elf,manifest,self.base,self.words[4],message['value'])
                assert result>=0
                self.words[4]=owned;self.words[5]=2 if owned else 0;self.words[6]=self.base;self.words[7]=12
                for addr,v in game.items():self.mem[addr]=struct.pack('<I',v)
                if message['value']==1 and case in ('lost-ack','disconnect') and not self.lost:
                    self.lost=True;self.reply=None
                    if case=='disconnect':self.disconnected=True
                    return
            self.reply=json.dumps({'ticket':message['ticket'],'event':'memory.write_u32'})
        def _recv_message(self):
            if self.reply is None:raise WsError('write delivered but acknowledgment lost')
            return self.reply
    def identity(c):return {'game':{'id':'UCES00420'},'module':{'baseDecimal':c.base,'size':0x46B900},'state':'C1','cpu':{'paused':False,'stepping':False}}
    fake=types.ModuleType('d0_ws');fake.DebuggerClient=Client;fake.WsError=WsError;fake.REQUEST_TIMEOUT_S=.05
    fake.identity=identity;fake.read_word=lambda c,a:struct.unpack('<I',c.raw(a,4))[0]
    class Loader(importlib.abc.Loader):
        def create_module(self,spec):return fake
        def exec_module(self,module):pass
    real_spec=importlib.util.spec_from_file_location
    def spec(name,path):return importlib.util.spec_from_loader(name,Loader()) if name=='d0_ws' else real_spec(name,path)
    for case,action,profile in [('status','status','help'),('trial','trial','help'),('arm','arm','help'),
                               ('wave','trial','help-wave'),('lost-ack','trial','help'),('disconnect','trial','help'),
                               ('foreign','trial','help'),('bad-build','trial','help')]:
        dest=a.out.with_name(a.out.stem+'-'+case+'.json')
        if dest.exists():raise ValueError('existing case output')
        argv=['control-d0','--build',str(a.build),'--tests',str(a.tests),'--action',action,'--profile',profile,'--seconds','0.001','--out',str(dest)]
        if profile=='help-wave':argv.append('--allow-unmeasured-enemywave')
        error=None
        with patch.object(sys,'argv',argv),patch('importlib.util.spec_from_file_location',side_effect=spec):
            try:controller.main()
            except BaseException as e:error=str(e)
        record=json.loads(dest.read_bytes())
        if case=='status':assert not client.sent and error is None
        elif case in ('trial','wave'):assert error is None and client.words[4]==0 and record['cleanup']=='ALL_D0_RULES_ORIGINAL_VERIFIED'
        elif case=='arm':assert error is None and client.words[4]==1 and 'cleanup' not in record
        elif case=='lost-ack':assert error and client.words[4]==0 and record['cleanup']=='ALL_D0_RULES_ORIGINAL_VERIFIED'
        elif case=='disconnect':assert error and client.words[4]==1 and record['cleanup']=='UNRESOLVED' and record['status']=='FAILED_OR_PARTIAL'
        else:assert error and not client.sent
        results.append({'case':case,'status':'PASS','record':dest.name})
    report={'status':'OFFLINE_CONTROLLER_PASS_NOT_RUNTIME_ACCEPTED','cases':results,
            'controllerSha256':hashlib.sha256((ROOT/'tools/runtime/control-d0.py').read_bytes()).hexdigest(),
            'methodSha256':hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
            'limits':'In-memory debugger transport and PRX monitor ABI; not actual socket loss, SDK monitor scheduling or PPSSPP gameplay.'}
    a.out.write_bytes((json.dumps(report,indent=2)+'\n').encode());print(json.dumps({'status':report['status'],'cases':len(results)}))
if __name__=='__main__':main()
