#!/usr/bin/env python3
"""Decode recorder chunks and compare observed callback coverage, without host-time slopes."""
import argparse,hashlib,json,math,struct
import statistics
from collections import defaultdict
from pathlib import Path
MAGIC=0x31524652
HEADER=struct.Struct('<27I');EVENT=struct.Struct('<24I')
def read_trace(path,manifest):
    raw=Path(path).read_bytes();offset=0;chunks=[];samples=[];previous=-1;truncated=False
    ns,nc=len(manifest['sites']),len(manifest['callbacks'])
    while offset<len(raw):
        if len(raw)-offset<HEADER.size:truncated=True;break
        h=HEADER.unpack_from(raw,offset);size=HEADER.size+4*(2*ns+nc)+h[10]*EVENT.size
        if h[0]!=MAGIC or h[1]!=2 or h[2]!=size or h[8]!=ns or h[9]!=nc or h[17]!=96 or h[10]>128:
            raise ValueError('invalid trace frame/schema/build dimensions')
        if struct.pack('<8I',*h[18:26]).hex()!=manifest['buildId']:raise ValueError('trace build fingerprint mismatch')
        if chunks and h[26]!=chunks[0]['traceNumber']:raise ValueError('mixed recorder output files')
        if h[3]!=previous+1:raise ValueError('missing/reordered whole-trace sequence; segmented inputs unsupported')
        if offset+size>len(raw):truncated=True;break
        previous=h[3];offset+=HEADER.size
        counts=struct.unpack_from('<%dI'%(2*ns+nc),raw,offset);offset+=4*(2*ns+nc)
        chunk={'sequence':h[3],'epoch':h[4],'base':h[5],'arm':{1:'A0',2:'C1'}.get(h[6],'UNKNOWN'),'status':h[7],
               'dropped':h[11],'timeUs':h[12]+(h[13]<<32),'mode':h[14],'stride':h[15],'traceNumber':h[26],
               'callbackCounts':list(counts[2*ns:]),'siteCounts':list(counts[:2*ns])}
        if chunks and chunk['timeUs']<chunks[-1]['timeUs']:raise ValueError('clock reset requires a new trace')
        chunks.append(chunk)
        for _ in range(h[10]):
            e=EVENT.unpack_from(raw,offset);offset+=EVENT.size
            if e[1]>=ns or e[0]!=0xFFFFFFFF and e[0]>=nc:raise ValueError('event index outside scope')
            if e[9]!=chunk['base']+manifest['sites'][e[1]]['rva']+8 or e[14]&~3:raise ValueError('event callsite/validity attribution mismatch')
            t=e[3]+(e[4]<<32)
            if t>chunk['timeUs']:raise ValueError('event timestamp exceeds export timestamp')
            samples.append({'epoch':h[4],'arm':chunk['arm'],'status':h[7],'callback':e[0],'site':e[1],'hit':e[2],'timeUs':t,
                'a0':e[5],'a1':e[6],'a2':e[7],'a3':e[8],'ra':e[9],'f12Bits':e[10],
                'object0':e[11],'object1':e[12],'pvar':e[13],'valid':e[14],'fieldBits':list(e[15:21]),'positionBits':list(e[21:24])})
    return {'chunks':chunks,'samples':samples,'truncatedTail':truncated,'sha256':hashlib.sha256(raw).hexdigest()}
def f32(bits):return struct.unpack('<f',struct.pack('<I',bits))[0]
def summarize(decoded,manifest):
    active=defaultdict(lambda:defaultdict(int));exposure=defaultdict(float);windows=0
    losses=defaultdict(int);register_samples=defaultdict(int);field_samples=defaultdict(int)
    no_progress_windows=defaultdict(int);no_progress_seconds=defaultdict(float)
    for before,after in zip(decoded['chunks'],decoded['chunks'][1:]):
        if (before['epoch'],before['base'],before['arm'],before['status'],before['mode'])!=(after['epoch'],after['base'],after['arm'],after['status'],after['mode']):continue
        if after['status']!=1 or after['mode'] not in (1,2) or after['arm']=='UNKNOWN':continue
        dt=(after['timeUs']-before['timeUs'])/1e6
        if dt<=0:continue
        exposure[after['arm']]+=dt;windows+=1
        losses[after['arm']]+=(after['dropped']-before['dropped'])&0xFFFFFFFF
        if not any((y-x)&0xFFFFFFFF for x,y in zip(before['callbackCounts'],after['callbackCounts'])):
            no_progress_windows[after['arm']]+=1;no_progress_seconds[after['arm']]+=dt
        for i,(x,y) in enumerate(zip(before['callbackCounts'],after['callbackCounts'])):
            active[after['arm']][i]+=(y-x)&0xFFFFFFFF
    channels=defaultdict(list)
    previous_sample={};rates=defaultdict(list)
    for e in decoded['samples']:
        if e['status']==1 and e['callback']!=0xFFFFFFFF:
            register_samples[(e['arm'],e['callback'])]+=1
            if e['valid']&2:field_samples[(e['arm'],e['callback'])]+=1
        if e['status']!=1 or e['callback']==0xFFFFFFFF or not e['valid']&2:continue
        cb=manifest['callbacks'][e['callback']]
        identity=(e['epoch'],e['arm'],e['callback'],e['a0'],e['pvar'],e['object0'],e['object1'])
        previous=previous_sample.get(identity);previous_sample[identity]=e
        for j,field in enumerate(cb['fields']):
            value=f32(e['fieldBits'][j])
            if math.isfinite(value):channels[(e['arm'],e['callback'],field['name'])].append(value)
            if previous:
                dt=(e['timeUs']-previous['timeUs'])/1e6;before=f32(previous['fieldBits'][j])
                if 0<dt<=1 and math.isfinite(value) and math.isfinite(before):rates[(e['arm'],e['callback'],field['name'])].append((value-before)/dt)
    coverage=[]
    for i,cb in enumerate(manifest['callbacks']):
        arms={arm:{'hits':active[arm][i],'sessionExposureSeconds':exposure[arm],
                   'registerSamples':register_samples[(arm,i)],'fieldSamples':field_samples[(arm,i)],
                   'aggregateCallsPerSessionSecond':active[arm][i]/exposure[arm] if exposure[arm] else None} for arm in ('A0','C1')}
        present=[arm for arm in arms if arms[arm]['hits']]
        coverage.append({'rva':cb['rva'],'aliases':cb['aliases'],'observedIn':present,'arms':arms,
                         'interpretation':'Callback observed; aliases do not resolve individual class. Session totals/rates are exposure-dependent, not a defect verdict.' if present else 'NOT_OBSERVED_ON_CAPTURED_PATHS; other callers/states remain UNKNOWN'})
    return {'coverage':coverage,'validWindows':windows,'exposureSeconds':dict(exposure),
        'sampleCount':len(decoded['samples']),'droppedMax':max((c['dropped'] for c in decoded['chunks']),default=0),
        'droppedWithinEligibleWindows':dict(losses),
        'noCallbackProgressWindows':dict(no_progress_windows),'noCallbackProgressSeconds':dict(no_progress_seconds),
        'noCallbackProgressMeaning':'No instrumented callback progressed; gameplay state/menu/visibility remains unbound. These windows are reported, not silently removed or labeled a timing defect.',
        'samplingLimit':'Deterministic per-site stride can alias repeated instance order. Invocation coverage and register/field sampling coverage are separate; absent fields are UNKNOWN.',
        'truncatedTail':decoded['truncatedTail'],'fieldObservations':[{'arm':a,'callback':i,'field':f,'samples':len(v),'min':min(v),'max':max(v),'slope':None,'reason':'Lifecycle/state match and clock calibration required before a physical-rate comparison.'} for (a,i,f),v in channels.items()],
        'exploratoryFieldRates':[{'arm':a,'callback':i,'field':f,'pairs':len(v),'medianPerKernelSecond':statistics.median(v),'min':min(v),'max':max(v),'status':'EXPLORATORY_IDENTITY_STATE_CLOCK_UNVALIDATED; resets, recycled pointers and changed activity can dominate this rate'} for (a,i,f),v in rates.items()],
        'clock':'Raw PSP kernel microseconds; emulated-clock calibration against debugger ticks is required.',
        'coverageLimit':manifest['coverageLimit']}
def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--build',type=Path,required=True);p.add_argument('--trace',type=Path,action='append',required=True);p.add_argument('--out',type=Path,required=True);a=p.parse_args()
    if a.out.exists():raise RuntimeError('refusing evidence overwrite')
    m=json.loads((a.build/'manifest.json').read_bytes());decoded=[read_trace(t,m) for t in a.trace]
    result={'status':'OBSERVATION_NOT_PARITY','methodSha256':hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
            'buildManifestSha256':hashlib.sha256((a.build/'manifest.json').read_bytes()).hexdigest(),
            'captures':[{'trace':str(t),'traceSha256':d['sha256'],'summary':summarize(d,m)} for t,d in zip(a.trace,decoded)],
            'observedAcrossSuppliedFiles':[],'pairingStatus':'UNPAIRED_EXPLORATORY; BOTH means observed in supplied files, not matched gameplay/physics conditions'}
    union=defaultdict(set)
    for d in decoded:
        for row in summarize(d,m)['coverage']:union[row['rva']].update(row['observedIn'])
    for cb in m['callbacks']:
        seen=union[cb['rva']];result['observedAcrossSuppliedFiles'].append({'rva':cb['rva'],'aliases':cb['aliases'],'state':'BOTH' if seen=={'A0','C1'} else next(iter(seen))+'_ONLY' if seen else 'NOT_OBSERVED_UNKNOWN'})
    a.out.write_text(json.dumps(result,indent=1),encoding='utf-8');print(json.dumps({'out':str(a.out),'captures':len(decoded),'observedCallbacks':sum(bool(v) for v in union.values())}))
if __name__=='__main__':main()
