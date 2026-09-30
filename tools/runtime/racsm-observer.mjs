#!/usr/bin/env node
// RACSM Runtime Observer v0.2 — persistent PPSSPP measurement console.
//
// It keeps ONE PPSSPP debugger WebSocket open for the whole session and lets
// the owner run repeated A0/C1 measurements without restarting an agent.
// It never writes memory, sends input, touches savestates/configuration, or
// changes the debugger port. Auto-bound profiles briefly own one true-stop
// breakpoint, remove it, and resume before free-running sampling begins.
import path from 'node:path';
import fs from 'node:fs';
import readline from 'node:readline';
import {fileURLToPath} from 'node:url';
import {PpssppClient, PolicyViolation, READ_ONLY_EVENTS, DEBUG_CONTROL_EVENTS} from './lib/ppsspp-client.mjs';
import {GAME_ID, inspectIdentity, stateDescription} from './lib/state.mjs';
import {buildReadPlan, describeField, listProfiles, loadProfile, sampleProfile} from './lib/profiles.mjs';
import {runCapture} from './lib/capture.mjs';
import {autoBindProfile} from './lib/binding.mjs';
import {compareCaptures} from './lib/compare.mjs';
import {
  OBSERVER_VERSION,
  formatValue,
  hexAddress,
  parseAddress,
  parseSeconds,
  relativePath,
  safeName,
} from './lib/util.mjs';

const runtimeDir = path.dirname(fileURLToPath(import.meta.url));
const projectRoot = path.resolve(runtimeDir, '..', '..');

function parseArgs(argv) {
  const options = {
    host: '127.0.0.1',
    port: 60907,
    measurementsDir: path.join(projectRoot, 'measurements'),
    banner: true,
  };
  for (let i = 0; i < argv.length; i += 1) {
    const arg = argv[i];
    const next = () => {
      const value = argv[++i];
      if (value === undefined) throw new Error(`Missing value for ${arg}`);
      return value;
    };
    if (arg === '--port') options.port = Number.parseInt(next(), 10);
    else if (arg.startsWith('--port=')) options.port = Number.parseInt(arg.slice(7), 10);
    else if (arg === '--host') options.host = next();
    else if (arg.startsWith('--host=')) options.host = arg.slice(7);
    else if (arg === '--measurements') options.measurementsDir = path.resolve(next());
    else if (arg.startsWith('--measurements=')) options.measurementsDir = path.resolve(arg.slice(15));
    else if (arg === '--no-banner') options.banner = false;
    else if (arg === '--help' || arg === '-h') options.help = true;
    else throw new Error(`Unknown argument: ${arg}`);
  }
  if (!Number.isInteger(options.port) || options.port < 1 || options.port > 65535) {
    throw new Error(`Invalid --port value: ${options.port}`);
  }
  return options;
}

const HELP = `
RACSM Runtime Observer v${OBSERVER_VERSION} — measurement commands

  status                          connect (if needed) and re-read game identity + the four guards
  profile                         list available measurement profiles
  profile <name>                  select a profile (e.g. profile player-clock)
  start [name]                    auto-bind the selected target and start recording
                                  optional flags: --interval-ms <n>, --no-ticks
  stop                            stop recording and finalize all output files
  entity <address>                set the active entity base address (e.g. entity 0x09471640)
  peek                            read the active profile once, without writing any file
  capture <name> <seconds>        sample the active profile into measurements/<name>/
                                  optional flags: --interval-ms <n> (default 20; 0 = as fast
                                  as possible, which freezes emulated time), --no-ticks
  compare <captureA> <captureB>   write comparison.json + COMPARISON.md (data only)
  list                            list existing captures
  help                            show this help
  quit                            close the connection and exit

Memory-read events — ${READ_ONLY_EVENTS.join(', ')}.
Internal binding events — ${DEBUG_CONTROL_EVENTS.join(', ')}.
No memory/register write, persistent breakpoint, input, savestate,
configuration change or debugger port change is allowed.
Capture is refused unless the guards recognize exactly A0, B0, B1 or C1.
`;

class Observer {
  constructor(options) {
    this.options = options;
    this.runtimeDir = runtimeDir;
    this.projectRoot = projectRoot;
    this.measurementsDir = options.measurementsDir;
    this.client = new PpssppClient({
      host: options.host,
      port: options.port,
      clientName: 'RACSM Runtime Observer',
      clientVersion: OBSERVER_VERSION,
    });
    this.identity = null; // last verified identity
    this.identityFresh = false;
    this.profile = null;
    this.entityAddress = null;
    this.captureInFlight = false;
    this.abortController = null;
    this.captureJob = null;
    this.binding = null;
    this.jobSerial = 0;
    this.closing = false;
    this.client.onDisconnect((reason) => this.onDisconnect(reason));
  }

  say(...args) {
    console.log(...args);
  }

  onDisconnect(reason) {
    const hadIdentity = this.identity !== null || this.identityFresh;
    this.identity = null;
    this.identityFresh = false;
    if (this.closing) return;
    if (hadIdentity) {
      this.say(`\n[observer] PPSSPP connection lost: ${reason}.`);
      this.say('[observer] Previous identity invalidated — run "status" to verify a new one before measuring.');
    }
    this.abortController?.abort(`PPSSPP connection lost: ${reason}`);
    this.captureJob?.bindingController.abort(`PPSSPP connection lost: ${reason}`);
    this.captureJob?.stopController.abort(`PPSSPP connection lost: ${reason}`);
  }

  async ensureConnected() {
    if (this.client.connected) return;
    this.say(`[observer] connecting to ${this.client.url} ...`);
    await this.client.connect();
    this.say('[observer] connected.');
  }

  async status() {
    try {
      await this.ensureConnected();
    } catch (error) {
      this.identity = null;
      this.identityFresh = false;
      this.say(`Connection to PPSSPP : FAILED — ${error.message}`);
      this.say('STATE = UNKNOWN');
      this.say('CAPTURE REFUSED');
      return null;
    }

    let identity;
    try {
      identity = await inspectIdentity(this.client, {
        clientName: 'RACSM Runtime Observer',
        clientVersion: OBSERVER_VERSION,
      });
    } catch (error) {
      this.identity = null;
      this.identityFresh = false;
      this.say(`Identity inspection FAILED — ${error.message}`);
      this.say('STATE = UNKNOWN');
      this.say('CAPTURE REFUSED');
      if (error instanceof PolicyViolation) this.say(`Policy: ${error.message}`);
      return null;
    }

    this.identity = identity.identityValid ? identity : null;
    this.identityFresh = identity.identityValid;
    this.printStatus(identity);
    return identity;
  }

  printStatus(identity) {
    const line = (label, value) => this.say(`  ${label.padEnd(18)}: ${value}`);
    this.say('');
    this.say('PPSSPP Runtime Observer — status');
    line('Connection', `CONNECTED (${this.client.url})`);
    line('PPSSPP version', identity.ppsspp.version ? `${identity.ppsspp.name} ${identity.ppsspp.version}` : 'unavailable');
    line('Game ID', identity.game.id ?? 'unavailable');
    line('Game version', identity.game.version ?? 'unavailable');
    line('Game title', identity.game.title ?? 'unavailable');
    line('Game paused', identity.gamePaused ? 'yes' : 'no');
    line(
      'Active module',
      identity.module
        ? `${identity.module.name} @ 0x${identity.module.address.toString(16).toUpperCase().padStart(8, '0')} ` +
            `size ${identity.module.size !== null ? `0x${identity.module.size.toString(16).toUpperCase()}` : 'unavailable'} (${identity.module.isActive ? 'active' : 'inactive'})`
        : 'unavailable',
    );
    line('CPU', `stepping=${identity.cpu.stepping} paused=${identity.cpu.paused} ticks=${identity.cpu.ticks ?? 'n/a'}`);

    this.say('  Guards:');
    if (identity.guards) {
      for (const [key, guard] of Object.entries(identity.guards)) {
        this.say(
          `    base+${guard.rva.padEnd(8)} ${key.padEnd(14)} = ${guard.word}  [${guard.label}]  @ ${guard.address}`,
        );
      }
    } else {
      this.say('    unavailable (identity could not be established)');
    }
    line('Recognized state', stateDescription(identity.state));
    line('Active profile', this.profile ? `${this.profile.name} (${this.profile.fields.length} fields, sha256 ${this.profile.sha256.slice(0, 16)}…)` : 'none (run "profile <name>")');
    line('Active entity', this.entityAddress === null ? 'none (run "entity 0x...")' : hexAddress(this.entityAddress));
    line(
      'Auto binding',
      this.binding
        ? Object.entries(this.binding.bases).map(([base, address]) => `${base}=${hexAddress(address)}`).join(', ')
        : this.profile?.binding
          ? 'pending (resolved automatically by "start")'
          : 'not used by this profile',
    );

    if (identity.identityValid) {
      this.say('  Capture ready      : YES');
    } else {
      this.say('  Capture ready      : NO');
      this.say('STATE = UNKNOWN');
      this.say('CAPTURE REFUSED');
      for (const reason of identity.stateReasons) this.say(`  reason: ${reason}`);
    }
    this.say('');
  }

  refuseCapture(reason, {stateUnknown = true} = {}) {
    if (stateUnknown) this.say('STATE = UNKNOWN');
    this.say('CAPTURE REFUSED');
    this.say(`reason: ${reason}`);
  }

  requireCaptureReady() {
    if (!this.identityFresh || !this.identity) {
      return {
        ok: false,
        stateUnknown: true,
        reason: 'no valid identity for this session — run "status" and read the guards first',
      };
    }
    if (!this.identity.identityValid || this.identity.state === 'UNKNOWN') {
      return {
        ok: false,
        stateUnknown: true,
        reason:
          this.identity.stateReasons.join('; ') ||
          'guards do not match A0, B0, B1 or C1 — a hybrid or unexpected state is always refused, never guessed',
      };
    }
    if (!this.profile) return {ok: false, stateUnknown: false, reason: 'no active profile — run "profile <name>"'};
    const needsEntity = this.profile.fields.some((field) => field.base === 'entity');
    if (needsEntity && this.entityAddress === null) {
      return {
        ok: false,
        stateUnknown: false,
        reason: 'no active entity — run "entity 0x..." (profile fields are entity-relative)',
      };
    }
    const needsAutomaticBases = this.profile.fields.some((field) => ['object', 'pvar'].includes(field.base));
    const bindingMatches =
      this.binding?.profileName === this.profile.name &&
      this.binding?.moduleBase === this.identity.module?.address;
    if (needsAutomaticBases && !bindingMatches) {
      return {
        ok: false,
        stateUnknown: false,
        reason: 'target is not bound yet — run "start <capture-name>" and activate the selected gameplay target',
      };
    }
    const plan = buildReadPlan(this.profile, {
      entityAddress: this.entityAddress,
      baseAddresses: bindingMatches ? this.binding.bases : null,
      moduleBase: this.identity.module?.address ?? null,
      moduleSize: this.identity.module?.size ?? null,
    });
    return {ok: true, plan, reason: null};
  }

  async capture(name, rawSeconds, flags) {
    if (this.captureInFlight) {
      this.say('CAPTURE REFUSED');
      this.say('reason: another capture is already running');
      return;
    }
    const readiness = this.requireCaptureReady();
    if (!readiness.ok) {
      this.refuseCapture(readiness.reason, {stateUnknown: readiness.stateUnknown});
      return;
    }
    let captureName;
    let seconds;
    try {
      captureName = safeName(name);
      seconds = parseSeconds(rawSeconds);
    } catch (error) {
      this.say(`usage: capture <name> <seconds>   (${error.message})`);
      return;
    }

    const includeTicks = !flags.includes('--no-ticks');
    let intervalMs = 20;
    const intervalFlagIndex = flags.findIndex((flag) => flag === '--interval-ms' || flag.startsWith('--interval-ms='));
    if (intervalFlagIndex >= 0) {
      const flag = flags[intervalFlagIndex];
      const raw = flag.startsWith('--interval-ms=') ? flag.slice('--interval-ms='.length) : flags[intervalFlagIndex + 1];
      const parsed = Number(raw);
      if (!Number.isFinite(parsed) || parsed < 0 || parsed > 10000) {
        this.say(`usage: capture <name> <seconds> [--interval-ms <0..10000>]   (invalid: ${raw})`);
        return;
      }
      intervalMs = parsed;
    }
    this.captureInFlight = true;
    this.abortController = new AbortController();
    this.say(
      `[capture] ${captureName}: ${seconds}s, profile ${this.profile.name}, state ${this.identity.state}, ` +
        `entity ${this.entityAddress === null ? 'none' : hexAddress(this.entityAddress)}, ticks ${includeTicks ? 'on' : 'off'}, ` +
        `interval ${intervalMs === 0 ? 'none (emulated time will freeze)' : `${intervalMs}ms`}`,
    );
    try {
      const result = await runCapture({
        client: this.client,
        identity: this.identity,
        profile: this.profile,
        captureName,
        seconds,
        measurementsDir: this.measurementsDir,
        runtimeDir: this.runtimeDir,
        entityAddress: this.entityAddress,
        baseAddresses: this.binding?.profileName === this.profile.name ? this.binding.bases : null,
        binding: this.binding?.profileName === this.profile.name ? this.binding : null,
        includeTicks,
        intervalMs,
        abortSignal: this.abortController.signal,
        onEvent: (event, payload) => {
          if (event !== 'progress' || !payload) return;
          this.say(
            `  [${payload.elapsedSeconds.toFixed(2)}s/${payload.requestedSeconds}s] ` +
              `samples=${payload.samples} attempts=${payload.attempts} missed=${payload.missed}`,
          );
        },
      });
      const summary = result.summary;
      this.say(`[capture] written to ${relativePath(process.cwd(), result.dir)}`);
      this.say(
        `  samples=${summary.sampleCount} missed=${summary.missedSamples} ` +
          `observed=${summary.observedSeconds.toFixed(3)}s rate=${summary.sampleRateHz === null ? 'n/a' : summary.sampleRateHz.toFixed(2)} Hz` +
          `${summary.ticks?.available ? ` tick_rate=${summary.ticks.meanTickRateHz === null ? 'n/a' : summary.ticks.meanTickRateHz.toFixed(2)} Hz` : ''}`,
      );
      if (summary.ticks?.available && summary.ticks.derivedEmulatedTimeRatio !== null) {
        this.say(
          `  emulated_time=${summary.ticks.derivedEmulatedSecondsAtAssumedTickRate.toFixed(3)}s ` +
            `(${(summary.ticks.derivedEmulatedTimeRatio * 100).toFixed(1)}% of real time at the assumed tick rate)`,
        );
      }
      for (const warning of summary.warnings ?? []) this.say(`  WARNING: ${warning}`);
      if (result.aborted) {
        this.say(`  capture stopped early: ${result.abortReason}`);
        if (result.identityInvalidated) {
          this.identity = null;
          this.identityFresh = false;
          this.say('  identity invalidated — run "status" before any new measurement.');
        }
      }
    } catch (error) {
      this.say(`[capture] FAILED: ${error.message}`);
    } finally {
      this.captureInFlight = false;
      this.abortController = null;
    }
  }

  parseCaptureFlags(flags) {
    const includeTicks = !flags.includes('--no-ticks');
    let intervalMs = 20;
    for (let index = 0; index < flags.length; index += 1) {
      const flag = flags[index];
      if (flag === '--no-ticks') continue;
      if (flag === '--interval-ms' || flag.startsWith('--interval-ms=')) {
        const raw = flag.startsWith('--interval-ms=') ? flag.slice('--interval-ms='.length) : flags[++index];
        const parsed = Number(raw);
        if (!Number.isFinite(parsed) || parsed < 0 || parsed > 10000) {
          throw new Error(`invalid --interval-ms value: ${raw}`);
        }
        intervalMs = parsed;
        continue;
      }
      throw new Error(`unknown flag: ${flag}`);
    }
    return {includeTicks, intervalMs};
  }

  async startCapture(name, flags) {
    if (this.captureInFlight) {
      this.say('START REFUSED');
      this.say('reason: another binding/capture job is already active');
      return;
    }
    if (!this.profile) {
      this.say('START REFUSED');
      this.say('reason: select an automatic profile first (profile flamethrower, agents-glove, acidbomb or laser-tracer)');
      return;
    }
    if (!this.profile.binding) {
      this.say('START REFUSED');
      this.say(`reason: profile ${this.profile.name} has no automatic target-binding recipe`);
      return;
    }

    let options;
    try {
      options = this.parseCaptureFlags(flags);
    } catch (error) {
      this.say(`usage: start [name] [--interval-ms <0..10000>] [--no-ticks]   (${error.message})`);
      return;
    }

    const verified = await this.status();
    if (!verified?.identityValid || !this.identityFresh || !this.identity) return;
    if (verified.cpu.paused || verified.cpu.stepping) {
      this.say('START REFUSED');
      this.say('reason: PPSSPP CPU must be running before automatic target binding');
      return;
    }

    const generatedName = `${this.profile.name}_${this.identity.state}_${new Date().toISOString().replace(/[-:]/g, '').replace(/\.\d{3}Z$/, 'Z')}`;
    let captureName;
    try {
      captureName = safeName(name || generatedName);
    } catch (error) {
      this.say(`usage: start [name]   (${error.message})`);
      return;
    }
    const targetDir = path.join(this.measurementsDir, captureName);
    if (fs.existsSync(targetDir) && fs.readdirSync(targetDir).length > 0) {
      this.say('START REFUSED');
      this.say(`reason: capture directory already exists and is not empty: ${relativePath(process.cwd(), targetDir)}`);
      return;
    }

    const bindingController = new AbortController();
    const stopController = new AbortController();
    const job = {
      id: ++this.jobSerial,
      captureName,
      profile: this.profile,
      identity: this.identity,
      bindingController,
      stopController,
      phase: 'binding',
      promise: null,
    };
    this.binding = null;
    this.captureInFlight = true;
    this.captureJob = job;
    this.say(`[start] ${captureName}: profile=${job.profile.name}, state=${job.identity.state}`);
    this.say('[bind] automatic target discovery armed — return to PPSSPP and use the selected weapon.');

    job.promise = this.runManualCaptureJob(job, options)
      .catch((error) => {
        if (bindingController.signal.aborted && job.phase === 'binding') {
          this.say(`[bind] cancelled: ${bindingController.signal.reason ?? 'stopped by user'}`);
        } else {
          this.say(`[capture] FAILED: ${error.message}`);
        }
      })
      .finally(() => {
        if (this.captureJob?.id === job.id) {
          this.captureJob = null;
          this.captureInFlight = false;
          this.abortController = null;
        }
      });
  }

  async runManualCaptureJob(job, {includeTicks, intervalMs}) {
    const bound = await autoBindProfile({
      client: this.client,
      identity: job.identity,
      profile: job.profile,
      signal: job.bindingController.signal,
      onEvent: (event, payload) => {
        if (event === 'armed') this.say(`  breakpoint interne temporaire: ${payload.breakpointAddressHex}`);
        else if (event === 'hit') this.say(`  cible reconnue à PC=${hexAddress(payload.pc)}; retrait et reprise automatiques...`);
        else if (event === 'cleanup-error') this.say(`  WARNING cleanup: ${payload.message}`);
      },
    });
    if (job.bindingController.signal.aborted) throw new Error(String(job.bindingController.signal.reason ?? 'binding cancelled'));

    const identityAfterBinding = await inspectIdentity(this.client, {
      clientName: 'RACSM Runtime Observer',
      clientVersion: OBSERVER_VERSION,
    });
    if (!identityAfterBinding.identityValid) throw new Error('identity became invalid during automatic binding');
    if (identityAfterBinding.module?.address !== job.identity.module?.address) throw new Error('module base changed during automatic binding');
    if (identityAfterBinding.state !== job.identity.state) {
      throw new Error(`guard state changed during automatic binding: ${job.identity.state} -> ${identityAfterBinding.state}`);
    }
    this.identity = identityAfterBinding;
    this.identityFresh = true;
    this.binding = {...bound, profileName: job.profile.name};
    job.phase = 'capturing';
    this.say(
      `[capture] STARTED — ${Object.entries(bound.bases).map(([base, address]) => `${base}=${hexAddress(address)}`).join(', ')}; ` +
        'play normally, then type "stop".',
    );

    const result = await runCapture({
      client: this.client,
      identity: identityAfterBinding,
      profile: job.profile,
      captureName: job.captureName,
      seconds: null,
      measurementsDir: this.measurementsDir,
      runtimeDir: this.runtimeDir,
      baseAddresses: bound.bases,
      binding: this.binding,
      includeTicks,
      intervalMs,
      abortSignal: job.bindingController.signal,
      stopSignal: job.stopController.signal,
      onEvent: (event, payload) => {
        if (event !== 'progress' || !payload) return;
        this.say(
          `  [${payload.elapsedSeconds.toFixed(1)}s] samples=${payload.samples} ` +
            `attempts=${payload.attempts} missed=${payload.missed}`,
        );
      },
    });
    job.phase = 'finalized';
    this.printCaptureResult(result);
    if (result.identityInvalidated) {
      this.identity = null;
      this.identityFresh = false;
      this.binding = null;
      this.say('  identity invalidated — the next "start" will re-run full status verification.');
    }
  }

  printCaptureResult(result) {
    const summary = result.summary;
    this.say(`[capture] written to ${relativePath(process.cwd(), result.dir)}`);
    this.say(
      `  samples=${summary.sampleCount} missed=${summary.missedSamples} ` +
        `observed=${summary.observedSeconds.toFixed(3)}s rate=${summary.sampleRateHz === null ? 'n/a' : summary.sampleRateHz.toFixed(2)} Hz`,
    );
    for (const warning of summary.warnings ?? []) this.say(`  WARNING: ${warning}`);
    if (result.aborted) this.say(`  capture aborted: ${result.abortReason}`);
  }

  async stopCapture(reason = 'stopped by user') {
    const job = this.captureJob;
    if (!job) {
      this.say('No automatic binding/capture job is active.');
      return;
    }
    this.say(`[stop] ${job.phase} job ${job.captureName} ...`);
    job.bindingController.abort(reason);
    job.stopController.abort(reason);
    await job.promise;
  }

  async compare(nameA, nameB) {
    let result;
    try {
      result = compareCaptures(this.measurementsDir, safeName(nameA), safeName(nameB));
    } catch (error) {
      this.say(`COMPARISON REFUSED`);
      this.say(`reason: ${error.message}`);
      return;
    }
    if (!result.ok) {
      this.say('COMPARISON REFUSED');
      for (const refusal of result.refusals) this.say(`reason: ${refusal}`);
      return;
    }
    this.say(`[compare] ${nameA} vs ${nameB} — data only, no gameplay conclusion`);
    this.say(`  ${relativePath(process.cwd(), result.comparisonPath)}`);
    this.say(`  ${relativePath(process.cwd(), result.markdownPath)}`);
  }

  runProfile(name) {
    if (!name) {
      const available = listProfiles(this.projectRoot);
      this.say(`Available profiles: ${available.join(', ') || '(none)'}`);
      if (this.profile) {
        this.say(`Active profile: ${this.profile.name}`);
        for (const field of this.profile.fields) this.say(`  ${describeField(field)}`);
      }
      return;
    }
    if (this.captureInFlight) {
      this.say('profile change refused: a binding/capture job is active; run "stop" first');
      return;
    }
    try {
      const profile = loadProfile(this.projectRoot, name);
      this.profile = profile;
      this.binding = null;
      this.say(`Active profile: ${profile.name} (${relativePath(this.projectRoot, profile.file)})`);
      this.say(`  sha256          : ${profile.sha256}`);
      this.say(`  normalized sha  : ${profile.normalizedSha256}`);
      for (const field of profile.fields) this.say(`  field: ${describeField(field)}`);
      if (profile.binding) {
        this.say(
          `  auto-bind: module+0x${profile.binding.breakpointRva.toString(16).toUpperCase()} ` +
            Object.entries(profile.binding.registers).map(([base, register]) => `${base}=${register}`).join(', '),
        );
      }
    } catch (error) {
      this.say(`profile error: ${error.message}`);
    }
  }

  setEntity(text) {
    try {
      this.entityAddress = parseAddress(text);
      this.say(`Active entity: ${hexAddress(this.entityAddress)}`);
    } catch (error) {
      this.say(`usage: entity <address>   (${error.message})`);
    }
  }

  async peek() {
    const readiness = this.requireCaptureReady();
    if (!readiness.ok) {
      this.refuseCapture(readiness.reason, {stateUnknown: readiness.stateUnknown});
      return;
    }
    try {
      const values = await sampleProfile(this.client, readiness.plan);
      const cpu = await this.client.request('cpu.status');
      this.say(`peek @ ${new Date().toISOString()} ticks=${cpu.ticks ?? 'n/a'} state=${this.identity.state}`);
      for (const [fieldName, value] of Object.entries(values)) {
        this.say(`  ${fieldName.padEnd(16)} = ${formatValue(value)}`);
      }
    } catch (error) {
      this.say(`peek FAILED: ${error.message}`);
    }
  }

  list() {
    if (!fs.existsSync(this.measurementsDir)) {
      this.say(`No measurements directory yet: ${relativePath(process.cwd(), this.measurementsDir)}`);
      return;
    }
    const entries = fs
      .readdirSync(this.measurementsDir, {withFileTypes: true})
      .filter((entry) => entry.isDirectory() && entry.name !== 'comparisons')
      .map((entry) => entry.name)
      .sort();
    if (!entries.length) {
      this.say('No captures yet.');
      return;
    }
    for (const entry of entries) {
      const manifestPath = path.join(this.measurementsDir, entry, 'manifest.json');
      if (!fs.existsSync(manifestPath)) {
        this.say(`  ${entry} (no manifest.json)`);
        continue;
      }
      try {
        const manifest = JSON.parse(fs.readFileSync(manifestPath, 'utf8'));
        const rate = manifest.meanSampleRateHz === null ? 'n/a' : manifest.meanSampleRateHz.toFixed(2);
        this.say(
          `  ${entry.padEnd(28)} state=${String(manifest.state).padEnd(7)} ` +
            `samples=${String(manifest.sampleCount).padStart(6)} rate=${rate} Hz profile=${manifest.profile?.name}` +
            `${manifest.aborted ? ' [ABORTED]' : ''}`,
        );
      } catch (error) {
        this.say(`  ${entry} (unreadable manifest: ${error.message})`);
      }
    }
  }

  async handle(line) {
    const trimmed = line.trim();
    if (!trimmed) return;
    const parts = trimmed.split(/\s+/);
    const [command, ...args] = parts;
    switch (command.toLowerCase()) {
      case 'status':
        await this.status();
        break;
      case 'profile':
      case 'profiles':
        this.runProfile(args[0]);
        break;
      case 'entity':
        this.setEntity(args[0]);
        break;
      case 'peek':
        await this.peek();
        break;
      case 'capture':
        await this.capture(args[0], args[1], args.slice(2));
        break;
      case 'start':
        await this.startCapture(args[0]?.startsWith('--') ? null : args[0], args.slice(args[0]?.startsWith('--') ? 0 : 1));
        break;
      case 'stop':
        await this.stopCapture();
        break;
      case 'compare':
        if (!args[0] || !args[1]) {
          this.say('usage: compare <captureA> <captureB>');
          break;
        }
        await this.compare(args[0], args[1]);
        break;
      case 'list':
        this.list();
        break;
      case 'help':
        this.say(HELP);
        break;
      case 'quit':
      case 'exit':
        return 'quit';
      default:
        this.say(`Unknown command: ${command} (type "help")`);
    }
    return null;
  }

  async shutdown() {
    if (this.closing) return;
    this.closing = true;
    this.abortController?.abort('observer shutting down');
    if (this.captureJob) {
      this.captureJob.bindingController.abort('observer shutting down');
      this.captureJob.stopController.abort('observer shutting down');
      try {
        await this.captureJob.promise;
      } catch {
        /* the job already reports its own failure */
      }
    }
    this.identity = null;
    this.identityFresh = false;
    try {
      this.client.close('observer shutting down');
    } catch {
      /* ignore */
    }
  }
}

async function main() {
  let options;
  try {
    options = parseArgs(process.argv.slice(2));
  } catch (error) {
    console.error(`racsm-observer: ${error.message}`);
    process.exitCode = 2;
    return;
  }
  if (options.help) {
    console.log(HELP);
    return;
  }

  const observer = new Observer(options);
  if (options.banner) {
    console.log('');
    console.log(`RACSM Runtime Observer v${OBSERVER_VERSION} — automatic target binding (${GAME_ID})`);
    console.log(`Debugger target : ${observer.client.url}`);
    console.log(`Measurements    : ${observer.measurementsDir}`);
    console.log('Type "help" for the command list. Captures are refused unless the guards');
    console.log('recognize exactly A0, B0, B1 or C1.');
    console.log('');
  }

  const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout,
    prompt: 'racsm> ',
    terminal: process.stdin.isTTY === true,
  });
  let inputClosed = false;
  const promptIfInteractive = () => {
    if (!inputClosed && !quitRequested) rl.prompt();
  };

  process.on('SIGINT', () => {
    if (observer.captureInFlight) {
      observer.say('\n[observer] stopping the active binding/capture job ...');
      void observer.stopCapture('interrupted by user (SIGINT)');
      return;
    }
    observer.say('\n[observer] closing (SIGINT) ...');
    void observer.shutdown().then(() => {
      rl.close();
      process.exit(0);
    });
  });

  let queue = Promise.resolve();
  let quitRequested = false;
  rl.on('line', (line) => {
    queue = queue.then(async () => {
      if (quitRequested) return;
      const result = await observer.handle(line);
      if (result === 'quit') {
        quitRequested = true;
        await observer.shutdown();
        rl.close();
        return;
      }
      promptIfInteractive();
    });
  });

  rl.on('close', () => {
    inputClosed = true;
    queue = queue.then(async () => {
      await observer.shutdown();
      if (!quitRequested) process.exit(0);
    });
  });

  promptIfInteractive();
}

await main();
