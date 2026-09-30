// Automated tests for the RACSM Runtime Observer.
//
// Everything runs against a fake PPSSPP debugger, so no game state, savestate,
// memory or configuration is touched. The fake server records forbidden
// requests separately from the bounded debugger-control transaction.
import fs from 'node:fs';
import os from 'node:os';
import path from 'node:path';
import {spawn} from 'node:child_process';
import {fileURLToPath} from 'node:url';
import {FakePpssppDebugger} from './fake-ppsspp-debugger.mjs';

const testsDir = path.dirname(fileURLToPath(import.meta.url));
const runtimeDir = path.dirname(testsDir);
const repoRoot = path.resolve(runtimeDir, '..', '..');
const observerScript = path.join(runtimeDir, 'racsm-observer.mjs');
const nodeExe = process.execPath;

const results = [];
function check(name, condition, detail = '') {
  results.push({name, ok: Boolean(condition), detail});
  console.log(`${condition ? 'PASS' : 'FAIL'}  ${name}${condition || !detail ? '' : `  -> ${detail}`}`);
}

class ObserverProcess {
  constructor({port, measurementsDir}) {
    this.port = port;
    this.measurementsDir = measurementsDir;
    this.output = '';
    this.cursor = 0;
    this.exitCode = null;
  }

  start() {
    this.child = spawn(
      nodeExe,
      [observerScript, '--port', String(this.port), '--measurements', this.measurementsDir, '--no-banner'],
      {cwd: repoRoot, stdio: ['pipe', 'pipe', 'pipe']},
    );
    this.child.stdout.on('data', (chunk) => {
      this.output += chunk.toString('utf8');
    });
    this.child.stderr.on('data', (chunk) => {
      this.output += chunk.toString('utf8');
    });
    this.exited = new Promise((resolve) => {
      this.child.on('exit', (code) => {
        this.exitCode = code;
        resolve(code);
      });
    });
  }

  write(line) {
    this.child.stdin.write(`${line}\n`);
  }

  async waitFor(pattern, {timeoutMs = 40000, label = String(pattern)} = {}) {
    const deadline = Date.now() + timeoutMs;
    for (;;) {
      const slice = this.output.slice(this.cursor);
      const match = pattern.exec(slice);
      if (match) {
        this.cursor += match.index + match[0].length;
        return match[0];
      }
      if (this.exitCode !== null) {
        throw new Error(
          `observer exited (code ${this.exitCode}) while waiting for ${label}\n--- output tail ---\n${this.output.slice(-3000)}`,
        );
      }
      if (Date.now() > deadline) {
        throw new Error(
          `timeout waiting for ${label}\n--- output tail ---\n${this.output.slice(-3000)}`,
        );
      }
      await new Promise((resolve) => setTimeout(resolve, 25));
    }
  }

  async send(line, pattern, options) {
    this.write(line);
    if (pattern) return this.waitFor(pattern, options);
    return null;
  }

  async quit() {
    this.write('quit');
    const code = await Promise.race([
      this.exited,
      new Promise((resolve) => setTimeout(() => resolve('timeout'), 15000)),
    ]);
    return code;
  }

  kill() {
    try {
      this.child.kill();
    } catch {
      /* ignore */
    }
  }
}

function readJson(file) {
  return JSON.parse(fs.readFileSync(file, 'utf8'));
}

async function main() {
  const workDir = fs.mkdtempSync(path.join(os.tmpdir(), 'racsm-observer-tests-'));
  const measurementsDir = path.join(workDir, 'measurements');
  fs.mkdirSync(measurementsDir, {recursive: true});
  console.log(`work dir: ${workDir}`);

  const server = new FakePpssppDebugger({state: 'A0'});
  const port = await server.start(0);
  console.log(`fake PPSSPP debugger on 127.0.0.1:${port}`);

  const observer = new ObserverProcess({port, measurementsDir});
  let quitCode = null;
  try {
    observer.start();
    await observer.waitFor(/racsm> /, {timeoutMs: 20000, label: 'observer startup prompt'});
    check('launch: observer starts and shows its interactive prompt', true);

    // --- A0: connection, status, recognizable state -------------------------
    await observer.send('status', /Recognized state\s+: A0 \(vanilla 30 FPS\)/, {label: 'A0 status'});
    const statusText = observer.output;
    check('status: recognizes A0 guards', /Recognized state\s+: A0/.test(statusText));
    check('status: prints PPSSPP version', /PPSSPP version\s+: PPSSPP v1\.20\.4/.test(statusText));
    check('status: prints game id', /Game ID\s+: UCES00420/.test(statusText));
    check('status: prints game version', /Game version\s+: 1\.00/.test(statusText));
    check('status: prints active module and base', /Active module\s+: rcp1 @ 0x09139D00 size 0x46B900/.test(statusText));
    check(
      'status: prints all four guards',
      ['wait', 'sharedDelta', 'loopThreshold', 'localScalar'].every((key) => statusText.includes(key)),
    );
    check('status: reports capture readiness', /Capture ready\s+: YES/.test(statusText));

    // --- profile ------------------------------------------------------------
    await observer.send('profile player-clock', /Active profile: player-clock/, {label: 'profile load'});
    check('profile: loads player-clock', /Active profile: player-clock/.test(observer.output));
    check(
      'profile: lists the four expected fields',
      ['dt', 'phase', 'accumulator', 'normalizedStep'].every((name) =>
        new RegExp(`field: ${name} = entity\\+0x[0-9A-F]+ \\(float32\\)`).test(observer.output),
      ),
    );

    // --- entity + capture ---------------------------------------------------
    await observer.send('entity 0x09471640', /Active entity: 0x09471640/, {label: 'entity set'});
    await observer.send('capture test_A0 1', /\[capture\] written to/, {label: 'A0 capture'});
    check('capture: completes and reports its directory', /\[capture\] written to/.test(observer.output));

    const captureA0Dir = path.join(measurementsDir, 'test_A0');
    for (const file of ['manifest.json', 'summary.json', 'samples.csv', 'samples.ndjson']) {
      check(`capture: writes ${file}`, fs.existsSync(path.join(captureA0Dir, file)));
    }
    const manifestA0 = readJson(path.join(captureA0Dir, 'manifest.json'));
    const summaryA0 = readJson(path.join(captureA0Dir, 'summary.json'));
    const csvA0 = fs.readFileSync(path.join(captureA0Dir, 'samples.csv'), 'utf8').trim().split('\n');
    const ndjsonA0 = fs.readFileSync(path.join(captureA0Dir, 'samples.ndjson'), 'utf8').trim().split('\n');
    check('capture: manifest records state A0', manifestA0.state === 'A0', `state=${manifestA0.state}`);
    check('capture: manifest records the profile hash', /^[0-9a-f]{64}$/.test(manifestA0.profile?.sha256 ?? ''));
    check('capture: manifest records the four guard words', Boolean(manifestA0.guardWords?.wait && manifestA0.guardWords?.localScalar));
    check('capture: manifest records entity address', manifestA0.entity?.addressHex === '0x09471640', JSON.stringify(manifestA0.entity));
    check(
      'capture: manifest records requested and observed duration',
      manifestA0.requestedSeconds === 1 && manifestA0.observedSeconds >= 0.9,
      `requested=${manifestA0.requestedSeconds} observed=${manifestA0.observedSeconds}`,
    );
    check('capture: manifest records a real mean sample rate', manifestA0.meanSampleRateHz > 0, `rate=${manifestA0.meanSampleRateHz}`);
    check('capture: manifest records the sampler hash', /^[0-9a-f]{64}$/.test(manifestA0.sampler?.combinedSha256 ?? ''));
    check('capture: csv header has index/timestamp/elapsed/fields', /^index,time_monotonic_ns,elapsed_seconds,ppsspp_ticks,dt,phase,accumulator,normalizedStep,/.test(csvA0[0]));
    check('capture: csv rows match the sample count', csvA0.length - 1 === summaryA0.sampleCount, `rows=${csvA0.length - 1} count=${summaryA0.sampleCount}`);
    check('capture: ndjson rows match the sample count', ndjsonA0.length === summaryA0.sampleCount, `rows=${ndjsonA0.length} count=${summaryA0.sampleCount}`);
    check('capture: ndjson rows carry fields and timestamps', Boolean(JSON.parse(ndjsonA0[0]).fields?.dt));
    check('capture: summary reports a real sample rate', summaryA0.sampleRateHz > 0, `rate=${summaryA0.sampleRateHz}`);
    check(
      'capture: summary has start/end/min/max/mean and delta/slope',
      ['start', 'end', 'min', 'max', 'mean', 'delta', 'slopePerSecond'].every((key) => key in summaryA0.fields.dt),
    );
    check('capture: ticks are recorded', summaryA0.ticks?.available === true && summaryA0.ticks.span > 0);
    check(
      'capture: pacing interval is applied and recorded',
      manifestA0.sampleIntervalTargetMs === 20 &&
        manifestA0.sampleIntervalMs.mean >= 18 &&
        manifestA0.sampleIntervalMs.mean <= 60,
      `target=${manifestA0.sampleIntervalTargetMs} mean=${manifestA0.sampleIntervalMs.mean}`,
    );
    check('capture: no freeze warning when emulated time advances', manifestA0.clockFrozen === false && summaryA0.warnings.length === 0);

    // --- UNKNOWN state must refuse captures without writing to the game ----
    server.setState('HYBRID');
    await observer.send('status', /STATE = UNKNOWN/, {label: 'hybrid state status'});
    check('unknown: hybrid guard combination is reported UNKNOWN', /STATE = UNKNOWN[\s\S]*CAPTURE REFUSED/.test(observer.output.slice(-2000)));
    await observer.send('capture test_unknown 1', /CAPTURE REFUSED/, {label: 'unknown capture refusal'});
    check(
      'unknown: capture is refused and writes nothing',
      !fs.existsSync(path.join(measurementsDir, 'test_unknown')),
    );

    server.setState('ODD_SCALAR');
    await observer.send('status', /STATE = UNKNOWN/, {label: 'odd scalar status'});
    check('unknown: unexpected local scalar word is refused', /base\+0x2FBBC = 0x46006507/.test(observer.output));

    // --- C1 -----------------------------------------------------------------
    server.setState('C1');
    await observer.send('status', /Recognized state\s+: C1/, {label: 'C1 status'});
    check('status: recognizes C1 guards', /Recognized state\s+: C1 \(WAIT NOP, shared delta 1\/60, loop threshold 1\)/.test(observer.output));
    await observer.send('capture test_C1 1', /\[capture\] written to/, {label: 'C1 capture'});
    const manifestC1 = readJson(path.join(measurementsDir, 'test_C1', 'manifest.json'));
    check('capture: C1 manifest records state C1', manifestC1.state === 'C1', `state=${manifestC1.state}`);
    check(
      'capture: C1 guard words differ from A0 only where expected',
      manifestC1.guardWords.wait === 0 &&
        manifestC1.guardWords.sharedDelta === 0x3c043c88 &&
        manifestC1.guardWords.loopThreshold === 0x2a240001,
      JSON.stringify(manifestC1.guardWords),
    );
    await observer.send('capture test_noticks 1 --no-ticks', /\[capture\] written to/, {label: 'capture without ticks'});
    const manifestNoTicks = readJson(path.join(measurementsDir, 'test_noticks', 'manifest.json'));
    check(
      'capture: --no-ticks records samples without the tick counter',
      manifestNoTicks.ticks.available === false && manifestNoTicks.sampleCount > 0,
      JSON.stringify(manifestNoTicks.ticks),
    );

    // --- comparison ---------------------------------------------------------
    await observer.send('compare test_A0 test_C1', /COMPARISON\.md/, {label: 'comparison'});
    const comparisonDir = path.join(measurementsDir, 'comparisons', 'test_A0__vs__test_C1');
    check('compare: writes comparison.json', fs.existsSync(path.join(comparisonDir, 'comparison.json')));
    check('compare: writes COMPARISON.md', fs.existsSync(path.join(comparisonDir, 'COMPARISON.md')));
    const comparison = readJson(path.join(comparisonDir, 'comparison.json'));
    check('compare: reports both capture states', comparison.captures.a.state === 'A0' && comparison.captures.b.state === 'C1');
    check(
      'compare: reports per-field ratio and difference',
      'ratioBOverA' in comparison.fields.dt.mean && 'absoluteDifferenceBMinusA' in comparison.fields.dt.mean,
    );
    check(
      'compare: md contains data-only disclaimer',
      /no gameplay conclusion/i.test(fs.readFileSync(path.join(comparisonDir, 'COMPARISON.md'), 'utf8')),
    );

    // --- comparison refusal on entity mismatch ------------------------------
    await observer.send('entity 0x09471648', /Active entity: 0x09471648/, {label: 'second entity'});
    await observer.send('capture test_other 1', /\[capture\] written to/, {label: 'second entity capture'});
    await observer.send('compare test_A0 test_other', /COMPARISON REFUSED/, {label: 'comparison refusal'});
    check('compare: refuses a different entity address', /entity addresses differ/.test(observer.output));

    // --- automatic target binding + manual start/stop -----------------------
    server.autoHitDelayMs = 50;
    await observer.send('profile flamethrower', /auto-bind: module\+0x13B904 object=s0, pvar=s1/, {
      label: 'automatic profile load',
    });
    observer.write('start auto_flamethrower');
    await observer.waitFor(/\[capture\] STARTED/, {timeoutMs: 20000, label: 'automatic capture start'});
    await new Promise((resolve) => setTimeout(resolve, 350));
    await observer.send('stop', /\[capture\] written to/, {timeoutMs: 20000, label: 'manual capture stop'});
    const autoDir = path.join(measurementsDir, 'auto_flamethrower');
    const autoManifest = readJson(path.join(autoDir, 'manifest.json'));
    const autoSummary = readJson(path.join(autoDir, 'summary.json'));
    check(
      'auto-bind: records object and pvar bases without entity input',
      autoManifest.bases?.object?.address === server.objectAddress && autoManifest.bases?.pvar?.address === server.pvarAddress,
      JSON.stringify(autoManifest.bases),
    );
    check(
      'auto-bind: manifest proves breakpoint removal and CPU resume',
      autoManifest.binding?.cleanup?.breakpointRemoved === true && autoManifest.binding?.cleanup?.cpuResumed === true,
      JSON.stringify(autoManifest.binding?.cleanup),
    );
    check(
      'manual capture: stop finalizes cleanly rather than aborting',
      autoManifest.stoppedByUser === true && autoManifest.aborted === false && autoSummary.sampleCount > 0,
      `stopped=${autoManifest.stoppedByUser} aborted=${autoManifest.aborted} samples=${autoSummary.sampleCount}`,
    );
    check(
      'auto-bind: combined profile records both object and pvar fields',
      autoManifest.profile?.name === 'flamethrower' &&
        ['objectPhase70', 'pvarPhase10'].every((field) => field in autoSummary.fields),
    );
    check('auto-bind: no temporary breakpoint remains', server.breakpoints.size === 0, `remaining=${server.breakpoints.size}`);
    server.autoHitDelayMs = null;

    await observer.send('profile agents-glove', /auto-bind: module\+0x10FD6C pvar=s2/, {
      label: 'second automatic profile load',
    });
    observer.write('start cancel_before_hit');
    await observer.waitFor(/breakpoint interne temporaire:/, {timeoutMs: 10000, label: 'binding armed before cancel'});
    await observer.send('stop', /\[bind\] cancelled:/, {timeoutMs: 20000, label: 'binding cancellation cleanup'});
    check('auto-bind cancel: writes no capture when target never hit', !fs.existsSync(path.join(measurementsDir, 'cancel_before_hit')));
    check(
      'auto-bind cancel: removes the owned breakpoint and restores running CPU',
      server.breakpoints.size === 0 && server.cpuStepping === false,
      `remaining=${server.breakpoints.size} stepping=${server.cpuStepping}`,
    );

    // --- list + clean quit ---------------------------------------------------
    await observer.send('list', /test_C1/, {label: 'list command'});
    check('list: shows existing captures', /test_A0/.test(observer.output) && /test_C1/.test(observer.output));

    quitCode = await observer.quit();
    check('quit: exits cleanly with code 0', quitCode === 0, `exit code ${quitCode}`);
  } catch (error) {
    check(`main flow: ${error.message.split('\n')[0]}`, false, error.message);
    observer.kill();
  }

  // --- resilience: module move during a capture -----------------------------
  const observer2 = new ObserverProcess({port, measurementsDir});
  try {
    server.clearRawGuardOverrides();
    server.setModuleBase(0x09139d00);
    server.setState('A0');
    observer2.start();
    await observer2.waitFor(/racsm> /, {timeoutMs: 20000, label: 'second observer startup'});
    await observer2.send('status', /Recognized state\s+: A0/, {label: 'status before resilience capture'});
    const beforeMissingProfile = observer2.output.length;
    await observer2.send('capture no_profile 1', /CAPTURE REFUSED/, {label: 'capture without a profile'});
    const missingProfileSegment = observer2.output.slice(beforeMissingProfile);
    check(
      'capture: missing profile is refused without claiming an unknown state',
      !missingProfileSegment.includes('STATE = UNKNOWN') && /no active profile/.test(missingProfileSegment),
      missingProfileSegment.trim(),
    );
    await observer2.send('profile player-clock', /Active profile: player-clock/);
    await observer2.send('entity 0x09471640', /Active entity: 0x09471640/);
    observer2.write('capture resilience 3');
    await observer2.waitFor(/\[capture\] resilience/, {label: 'resilience capture start'});
    await new Promise((resolve) => setTimeout(resolve, 400));
    server.setModuleBase(0x0915a000);
    await observer2.waitFor(/capture stopped early: .*module base changed/, {
      timeoutMs: 20000,
      label: 'module-move abort',
    });
    check('resilience: capture aborts when the module base moves', true);
    await observer2.waitFor(/identity invalidated/, {timeoutMs: 10000, label: 'identity invalidation notice'});
    check('resilience: identity is invalidated after the module move', true);
    await observer2.send('capture after_move 1', /CAPTURE REFUSED/, {timeoutMs: 20000, label: 'capture refusal after invalidation'});
    check('resilience: capture is refused until a new valid status', true);
    const manifestResilience = readJson(path.join(measurementsDir, 'resilience', 'manifest.json'));
    check(
      'resilience: aborted capture still writes its raw data and abort reason',
      manifestResilience.aborted === true && /module base changed/.test(manifestResilience.abortReason ?? ''),
      manifestResilience.abortReason,
    );

    // --- frozen emulated clock warning ---------------------------------------
    server.setModuleBase(0x09139d00);
    server.frozenTicks = true;
    const beforeFrozen = observer2.output.length;
    await observer2.send('status', /Recognized state\s+: A0/, {label: 'status before frozen capture'});
    await observer2.send('capture frozen_ticks 1', /\[capture\] written to/, {label: 'frozen capture'});
    await observer2.waitFor(/WARNING: PPSSPP ticks did not advance/, {label: 'frozen clock warning line'});
    const frozenSegment = observer2.output.slice(beforeFrozen);
    const manifestFrozen = readJson(path.join(measurementsDir, 'frozen_ticks', 'manifest.json'));
    check(
      'frozen clock: capture is labelled and warned about',
      manifestFrozen.clockFrozen === true &&
        (manifestFrozen.warnings ?? []).some((warning) => /ticks did not advance/.test(warning)),
      JSON.stringify(manifestFrozen.warnings ?? null),
    );
    check(
      'frozen clock: console prints the warning',
      /WARNING: PPSSPP ticks did not advance/.test(frozenSegment),
    );
    server.frozenTicks = false;

    const quitCode2 = await observer2.quit();
    check('resilience: second session also quits cleanly', quitCode2 === 0, `exit code ${quitCode2}`);
  } catch (error) {
    check(`resilience: ${error.message.split('\n')[0]}`, false, error.message);
    observer2.kill();
  }

  // --- policy proof ---------------------------------------------------------
  check(
    'policy: fake debugger received no forbidden request',
    server.violations.length === 0,
    JSON.stringify(server.violations.slice(0, 3)),
  );
  const events = [...new Set(server.requests.map((request) => request.event))].sort();
  check(
    'policy: only memory-read or bounded debugger-control events were used',
    events.every((event) => [
      'version', 'game.status', 'cpu.status', 'hle.module.list', 'memory.read', 'memory.read_u32',
      'cpu.breakpoint.list', 'cpu.breakpoint.add', 'cpu.breakpoint.remove', 'cpu.getAllRegs', 'cpu.resume', 'cpu.stepping',
    ].includes(event)),
    events.join(', '),
  );

  await server.stop();

  const failed = results.filter((result) => !result.ok);
  console.log('');
  console.log(`${results.length - failed.length}/${results.length} checks passed.`);
  console.log(`raw test data: ${workDir}`);
  if (failed.length > 0) {
    console.log('failed checks:');
    for (const failure of failed) console.log(`  - ${failure.name}${failure.detail ? ` (${failure.detail})` : ''}`);
    process.exitCode = 1;
  }
}

await main();
