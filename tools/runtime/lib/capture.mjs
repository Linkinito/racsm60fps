// Memory-read sampling engine: records raw samples to CSV + NDJSON, then writes
// a manifest and a summary. Debugger binding happens before this module runs.
import fs from 'node:fs';
import path from 'node:path';
import {
  OBSERVER_NAME,
  OBSERVER_VERSION,
  csvEscape,
  ensureDir,
  formatValue,
  monotonicNs,
  nowIso,
  relativePath,
  safeName,
  sha256File,
  sha256Text,
  sleepMs,
} from './util.mjs';
import {buildReadPlan, sampleProfile} from './profiles.mjs';
import {classifyState, readGuards} from './state.mjs';

export const SAMPLER_FILES = Object.freeze([
  'racsm-observer.mjs',
  'lib/binding.mjs',
  'lib/capture.mjs',
  'lib/compare.mjs',
  'lib/ppsspp-client.mjs',
  'lib/profiles.mjs',
  'lib/state.mjs',
  'lib/util.mjs',
]);

// Derived-only constant: the project's established PPSSPP tick calibration.
// Raw tick values are always recorded; this is used solely to express how much
// emulated time a capture covered and is labelled as a derived assumption.
export const TICK_RATE_HZ_ASSUMED = 222222222;

export function samplerIdentity(runtimeDir) {
  const files = {};
  for (const relative of SAMPLER_FILES) {
    const file = path.join(runtimeDir, relative);
    files[relative] = fs.existsSync(file) ? sha256File(file) : null;
  }
  return {
    name: OBSERVER_NAME,
    version: OBSERVER_VERSION,
    memoryReadOnly: true,
    debuggerControlCapable: true,
    files,
    combinedSha256: sha256OfValues(files),
  };
}

function sha256OfValues(values) {
  const lines = Object.entries(values)
    .map(([key, value]) => `${key}:${value ?? 'missing'}`)
    .join('\n');
  return sha256Text(lines);
}

class FieldAccumulator {
  constructor(name) {
    this.name = name;
    this.count = 0;
    this.sum = 0;
    this.min = null;
    this.max = null;
    this.first = null;
    this.last = null;
    this.slopeN = 0;
    this.slopeSumX = 0;
    this.slopeSumY = 0;
    this.slopeSumXY = 0;
    this.slopeSumXX = 0;
    this.increases = 0;
    this.decreases = 0;
    this.equal = 0;
    this.previous = null;
  }

  add(seconds, value) {
    if (typeof value !== 'number' || !Number.isFinite(value)) return;
    this.count += 1;
    this.sum += value;
    this.min = this.min === null ? value : Math.min(this.min, value);
    this.max = this.max === null ? value : Math.max(this.max, value);
    if (this.first === null) this.first = value;
    this.last = value;
    this.slopeN += 1;
    this.slopeSumX += seconds;
    this.slopeSumY += value;
    this.slopeSumXY += seconds * value;
    this.slopeSumXX += seconds * seconds;
    if (this.previous !== null) {
      if (value > this.previous) this.increases += 1;
      else if (value < this.previous) this.decreases += 1;
      else this.equal += 1;
    }
    this.previous = value;
  }

  summary() {
    if (this.count === 0) {
      return {count: 0, note: 'no numeric samples'};
    }
    const denominator = this.slopeN * this.slopeSumXX - this.slopeSumX * this.slopeSumX;
    const slope = denominator === 0 ? null : (this.slopeN * this.slopeSumXY - this.slopeSumX * this.slopeSumY) / denominator;
    const steps = this.increases + this.decreases + this.equal;
    return {
      count: this.count,
      start: this.first,
      end: this.last,
      min: this.min,
      max: this.max,
      mean: this.sum / this.count,
      delta: this.last - this.first,
      slopePerSecond: slope,
      monotonicFraction: steps === 0 ? null : (this.increases + this.equal) / steps,
      steps: {increases: this.increases, decreases: this.decreases, equal: this.equal},
    };
  }
}

// One 'error' listener per stream (a listener per write leaks and trips
// MaxListenersExceededWarning during long captures), plus backpressure handling.
function lineWriter(stream) {
  let failure = null;
  stream.on('error', (error) => {
    failure = failure ?? error;
  });
  return {
    write(line) {
      if (failure) return Promise.reject(failure);
      return new Promise((resolve, reject) => {
        if (failure) {
          reject(failure);
          return;
        }
        if (stream.write(`${line}\n`)) resolve();
        else stream.once('drain', resolve);
      });
    },
    close() {
      return new Promise((resolve) => stream.end(resolve));
    },
    get error() {
      return failure;
    },
  };
}

export async function runCapture({
  client,
  identity,
  profile,
  captureName,
  seconds,
  measurementsDir,
  runtimeDir,
  entityAddress = null,
  baseAddresses = null,
  binding = null,
  includeTicks = true,
  intervalMs = 20,
  identityCheckMs = 1000,
  maxConsecutiveMissed = 20,
  abortSignal = null,
  stopSignal = null,
  onEvent = null,
}) {
  const name = safeName(captureName);
  const dir = path.join(measurementsDir, name);
  if (fs.existsSync(dir) && fs.readdirSync(dir).length > 0) {
    throw new Error(
      `Capture directory already exists and is not empty: ${relativePath(process.cwd(), dir)} ` +
        '(raw data is never overwritten intentionally; choose another capture name)',
    );
  }
  ensureDir(dir);

  const plan = buildReadPlan(profile, {
    entityAddress,
    baseAddresses,
    moduleBase: identity?.module?.address ?? null,
    moduleSize: identity?.module?.size ?? null,
  });
  const fieldNames = plan.fields.map((field) => field.name);

  const csvPath = path.join(dir, 'samples.csv');
  const ndjsonPath = path.join(dir, 'samples.ndjson');
  const csv = lineWriter(fs.createWriteStream(csvPath));
  const ndjson = lineWriter(fs.createWriteStream(ndjsonPath));

  const header = ['index', 'time_monotonic_ns', 'elapsed_seconds', 'ppsspp_ticks', ...fieldNames, 'sample_ok', 'error'];
  await csv.write(header.join(','));

  const startedAtUtc = nowIso();
  const startNs = monotonicNs();
  const accumulators = new Map(fieldNames.map((fieldName) => [fieldName, new FieldAccumulator(fieldName)]));
  const sampleTimes = [];
  const identityChecks = [];
  const missedReasons = new Map();

  let index = 0;
  let attempts = 0;
  let sampleCount = 0;
  let missedSamples = 0;
  let consecutiveMissed = 0;
  let firstTick = null;
  let lastTick = null;
  let aborted = false;
  let abortReason = null;
  let stoppedByUser = false;
  let stopReason = null;
  let identityInvalidated = false;
  let lastIdentityCheckNs = monotonicNs();
  let lastProgressNs = monotonicNs();

  const recordMiss = (message) => {
    missedSamples += 1;
    consecutiveMissed += 1;
    const key = String(message).slice(0, 160);
    missedReasons.set(key, (missedReasons.get(key) ?? 0) + 1);
  };

  while (true) {
    const nowNs = monotonicNs();
    const elapsedRequested = (nowNs - startNs) / 1e9;
    if (seconds !== null && elapsedRequested >= seconds) break;
    if (stopSignal?.aborted) {
      stoppedByUser = true;
      stopReason = stopSignal.reason ? String(stopSignal.reason) : 'stopped by user';
      break;
    }
    if (abortSignal?.aborted) {
      aborted = true;
      abortReason = abortSignal.reason ? String(abortSignal.reason) : 'interrupted by user';
      break;
    }

    const sampleStartNs = monotonicNs();
    const elapsedSeconds = (sampleStartNs - startNs) / 1e9;
    attempts += 1;

    let values = null;
    let ticks = null;
    let error = null;
    try {
      values = await sampleProfile(client, plan);
      if (includeTicks) {
        const cpu = await client.request('cpu.status');
        ticks = Number.isInteger(cpu.ticks) ? cpu.ticks : null;
      }
    } catch (caught) {
      error = caught?.message ?? String(caught);
      recordMiss(error);
    }

    if (values) {
      sampleCount += 1;
      consecutiveMissed = 0;
      for (const [fieldName, value] of Object.entries(values)) {
        accumulators.get(fieldName)?.add(elapsedSeconds, value);
      }
      sampleTimes.push(sampleStartNs);
      if (ticks !== null) {
        if (firstTick === null) firstTick = ticks;
        lastTick = ticks;
      }
    }

    const ndjsonRow = {
      index,
      timeMonotonicNs: sampleStartNs,
      elapsedSeconds,
      ppssppTicks: ticks,
      fields: values,
      sampleOk: values !== null,
      error,
    };
    await ndjson.write(JSON.stringify(ndjsonRow));
    const csvRow = [
      index,
      sampleStartNs,
      formatValue(elapsedSeconds),
      ticks === null ? '' : ticks,
      ...fieldNames.map((fieldName) => formatValue(values?.[fieldName])),
      values !== null ? 1 : 0,
      error === null ? '' : csvEscape(error),
    ];
    await csv.write(csvRow.join(','));
    index += 1;

    if (consecutiveMissed >= maxConsecutiveMissed) {
      aborted = true;
      abortReason = `too many consecutive missed reads (${consecutiveMissed}); last error: ${error}`;
      break;
    }

    const checkNowNs = monotonicNs();
    if (identityCheckMs > 0 && (checkNowNs - lastIdentityCheckNs) / 1e6 >= identityCheckMs) {
      lastIdentityCheckNs = checkNowNs;
      try {
        const check = await recheckIdentity(client, identity);
        identityChecks.push({
          atElapsedSeconds: (checkNowNs - startNs) / 1e9,
          moduleBase: check.moduleBase,
          state: check.state,
          ok: true,
        });
        if (check.state !== identity.state) {
          aborted = true;
          identityInvalidated = true;
          abortReason = `guard state changed during capture: ${identity.state} -> ${check.state}`;
          break;
        }
      } catch (caught) {
        aborted = true;
        identityInvalidated = true;
        abortReason = `identity re-check failed: ${caught?.message ?? String(caught)}`;
        identityChecks.push({
          atElapsedSeconds: (checkNowNs - startNs) / 1e9,
          ok: false,
          error: String(caught?.message ?? caught),
        });
        break;
      }
    }

    if (onEvent && (checkNowNs - lastProgressNs) / 1e6 >= 500) {
      lastProgressNs = checkNowNs;
      onEvent('progress', {
        elapsedSeconds: (checkNowNs - startNs) / 1e9,
        requestedSeconds: seconds,
        samples: sampleCount,
        attempts,
        missed: missedSamples,
      });
    }

    // Pacing: PPSSPP halts the emulated CPU for the duration of each
    // memory.read, so back-to-back reads freeze emulated time. Waiting between
    // samples lets the game run at full speed again.
    if (intervalMs > 0) {
      const nextDueNs = sampleStartNs + intervalMs * 1e6;
      const remainingMs = (nextDueNs - monotonicNs()) / 1e6;
      if (remainingMs > 0) await sleepMs(remainingMs);
    }
  }

  const endNs = monotonicNs();
  const observedSeconds = (endNs - startNs) / 1e9;
  await csv.close();
  await ndjson.close();
  if (csv.error) throw csv.error;
  if (ndjson.error) throw ndjson.error;

  const ticksAvailable = firstTick !== null;
  const tickSpan = ticksAvailable ? lastTick - firstTick : null;
  const derivedEmulatedSeconds = tickSpan === null ? null : tickSpan / TICK_RATE_HZ_ASSUMED;
  const derivedEmulatedTimeRatio =
    derivedEmulatedSeconds === null || observedSeconds === 0 ? null : derivedEmulatedSeconds / observedSeconds;
  const clockFrozen = ticksAvailable && attempts > 1 && tickSpan === 0;

  const warnings = [];
  if (clockFrozen) {
    warnings.push(
      'PPSSPP ticks did not advance during this capture: emulated time was frozen, so the recorded values are a snapshot, not a running observation. Use a larger --interval-ms value.',
    );
  } else if (derivedEmulatedTimeRatio !== null && derivedEmulatedTimeRatio < 0.9) {
    warnings.push(
      `Emulated time advanced at ~${(derivedEmulatedTimeRatio * 100).toFixed(1)}% of real time during this capture; the sampling loop slowed the emulated CPU down.`,
    );
  }
  if (missedSamples > 0) {
    warnings.push(`${missedSamples} sample(s) could not be read; they are recorded with sample_ok=0 and null fields.`);
  }

  const summary = {
    capture: name,
    state: identity?.state ?? 'UNKNOWN',
    startedAtUtc,
    endedAtUtc: nowIso(),
    requestedSeconds: seconds,
    observedSeconds,
    sampleIntervalTargetMs: intervalMs,
    sampleCount,
    attemptCount: attempts,
    missedSamples,
    intervalMs,
    sampleRateHz: observedSeconds > 0 ? sampleCount / observedSeconds : null,
    attemptRateHz: observedSeconds > 0 ? attempts / observedSeconds : null,
    aborted,
    abortReason,
    stoppedByUser,
    stopReason,
    ticks: firstTick === null
      ? {available: false}
      : {
          available: true,
          first: firstTick,
          last: lastTick,
          span: tickSpan,
          meanTickRateHz: observedSeconds > 0 ? tickSpan / observedSeconds : null,
          derivedEmulatedSecondsAtAssumedTickRate: derivedEmulatedSeconds,
          derivedEmulatedTimeRatio,
          assumedTickRateHz: TICK_RATE_HZ_ASSUMED,
        },
    clockFrozen,
    warnings,
    fields: Object.fromEntries([...accumulators].map(([fieldName, accumulator]) => [fieldName, accumulator.summary()])),
    notes: [
      'Sampling is host-driven over the PPSSPP debugger WebSocket: the real cadence is whatever the samples show.',
      'Values are raw reads; no resampling, interpolation or wrapping correction is applied.',
      'Delta and slope are only meaningful for fields that are monotonic in the captured window.',
      'PPSSPP halts the emulated CPU for the duration of each memory read, so a pacing interval is required for the game to keep running.',
      'A temporary true stop-breakpoint may have been used before sampling solely to discover object/pvar bases; it is removed before the first sample.',
    ],
  };

  const intervals = sampleTimes.slice(1).map((time, i) => (time - sampleTimes[i]) / 1e6);
  const manifest = {
    sampler: samplerIdentity(runtimeDir),
    captureName: name,
    startedAtUtc,
    endedAtUtc: summary.endedAtUtc,
    game: {
      id: identity?.game?.id ?? null,
      version: identity?.game?.version ?? null,
      title: identity?.game?.title ?? null,
    },
    ppsspp: {
      name: identity?.ppsspp?.name ?? null,
      version: identity?.ppsspp?.version ?? null,
      debuggerUrl: client.url,
    },
    module: identity?.module
      ? {
          name: identity.module.name,
          base: identity.module.address,
          baseHex: `0x${identity.module.address.toString(16).toUpperCase().padStart(8, '0')}`,
          size: identity.module.size,
        }
      : null,
    state: identity?.state ?? 'UNKNOWN',
    guards: identity?.guards ?? null,
    guardWords: identity?.guardWords ?? null,
    profile: {
      name: profile.name,
      path: relativePath(runtimeDir, profile.file),
      sha256: profile.sha256,
      normalizedSha256: profile.normalizedSha256,
      fields: profile.fields.map((field) => ({
        name: field.name,
        base: field.base,
        offset: `0x${field.offset.toString(16).toUpperCase()}`,
        type: field.type,
      })),
      binding: profile.binding
        ? {
            breakpointRva: `0x${profile.binding.breakpointRva.toString(16).toUpperCase()}`,
            registers: profile.binding.registers,
          }
        : null,
    },
    entity: entityAddress === null
      ? null
      : {address: entityAddress, addressHex: `0x${entityAddress.toString(16).toUpperCase().padStart(8, '0')}`},
    bases: Object.fromEntries(
      Object.entries(baseAddresses ?? {}).map(([base, address]) => [
        base,
        {address, addressHex: `0x${address.toString(16).toUpperCase().padStart(8, '0')}`},
      ]),
    ),
    binding,
    readPlan: plan,
    cpuAtStart: identity?.cpu ?? null,
    requestedSeconds: seconds,
    observedSeconds,
    sampleCount,
    attemptCount: attempts,
    missedSamples,
    missedReasons: Object.fromEntries(missedReasons),
    meanSampleRateHz: summary.sampleRateHz,
    sampleIntervalTargetMs: intervalMs,
    sampleIntervalMs: intervals.length
      ? {
          min: Math.min(...intervals),
          mean: intervals.reduce((acc, value) => acc + value, 0) / intervals.length,
          max: Math.max(...intervals),
        }
      : null,
    ticks: summary.ticks,
    clockFrozen: summary.clockFrozen,
    warnings: summary.warnings,
    derivedAssumptions: {
      tickRateHz: TICK_RATE_HZ_ASSUMED,
      note: 'Only used to express tick spans as emulated seconds; raw ticks are always recorded.',
    },
    identityCheckIntervalMs: identityCheckMs,
    identityChecks,
    aborted,
    abortReason,
    stoppedByUser,
    stopReason,
    artifacts: {
      samplesCsv: 'samples.csv',
      samplesNdjson: 'samples.ndjson',
      summaryJson: 'summary.json',
    },
    memoryReadOnly: true,
    debuggerControlUsed: binding !== null,
    notes: summary.notes,
  };

  const manifestPath = path.join(dir, 'manifest.json');
  const summaryPath = path.join(dir, 'summary.json');
  fs.writeFileSync(manifestPath, `${JSON.stringify(manifest, null, 2)}\n`);
  fs.writeFileSync(summaryPath, `${JSON.stringify(summary, null, 2)}\n`);

  return {dir, manifestPath, summaryPath, manifest, summary, aborted, abortReason, identityInvalidated};
}

// Re-verifies that the module is still unique and still at the same base, and
// that the guard words still describe the same recognized state.
export async function recheckIdentity(client, identity) {
  if (!identity?.module) throw new Error('no captured module identity to re-check');
  const modules = await client.request('hle.module.list');
  const candidates = (modules.modules ?? []).filter(
    (module) => module.name === identity.module.name && module.isActive,
  );
  if (candidates.length !== 1) {
    throw new Error(`active module "${identity.module.name}" is no longer uniquely present`);
  }
  const module = candidates[0];
  if (module.address !== identity.module.address) {
    throw new Error(
      `module base changed: 0x${identity.module.address.toString(16).toUpperCase()} -> ` +
        `0x${module.address.toString(16).toUpperCase()}`,
    );
  }
  const guards = await readGuards(client, module.address);
  const classification = classifyState(guards, module.address);
  return {
    moduleBase: module.address,
    guards: Object.fromEntries(Object.entries(guards).map(([key, value]) => [key, value.word])),
    state: classification.state,
    stateReasons: classification.reasons,
  };
}
