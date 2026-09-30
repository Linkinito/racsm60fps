// Shared helpers for the RACSM Runtime Observer.
// Game memory is never written. v0.2 may briefly control debugger execution
// while it owns and removes one temporary address-binding breakpoint.
import crypto from 'node:crypto';
import fs from 'node:fs';
import path from 'node:path';

export const OBSERVER_NAME = 'racsm-observer';
export const OBSERVER_VERSION = '0.2.0';

export function sha256Buffer(buffer) {
  return crypto.createHash('sha256').update(buffer).digest('hex');
}

export function sha256Text(text) {
  return sha256Buffer(Buffer.from(text, 'utf8'));
}

export function sha256File(file) {
  return sha256Buffer(fs.readFileSync(file));
}

export function sha256Json(value) {
  return sha256Text(stableStringify(value));
}

// Deterministic JSON rendering, used for profile/comparison hashing.
export function stableStringify(value) {
  if (value === null || typeof value !== 'object') return JSON.stringify(value);
  if (Array.isArray(value)) return `[${value.map((item) => stableStringify(item)).join(',')}]`;
  const keys = Object.keys(value).sort();
  return `{${keys.map((key) => `${JSON.stringify(key)}:${stableStringify(value[key])}`).join(',')}}`;
}

// Host-side monotonic clock (nanoseconds since process start).
export function monotonicNs() {
  return Number(process.hrtime.bigint());
}

// Millisecond sleep with better-than-timer-granularity accuracy on Windows.
// Both setTimeout and Atomics.wait wake on the Windows timer granularity
// (~15.6 ms), so the wait is chunked, then finished with short setImmediate
// polls, then a bounded spin. Measured: a 20 ms target lands at ~20-22 ms
// instead of ~31 ms with a plain timer.
const sleepCell = typeof SharedArrayBuffer === 'function' ? new Int32Array(new SharedArrayBuffer(4)) : null;
const COARSE_TIMER_MARGIN_MS = 16;

export function sleepMs(ms) {
  const totalMs = Math.max(0, ms);
  if (totalMs === 0) return Promise.resolve();
  const deadlineNs = monotonicNs() + totalMs * 1e6;
  return (async () => {
    for (;;) {
      const remainingNs = deadlineNs - monotonicNs();
      if (remainingNs <= 0) return;
      const remainingMs = remainingNs / 1e6;
      if (sleepCell && remainingMs > COARSE_TIMER_MARGIN_MS + 2) {
        Atomics.wait(sleepCell, 0, 0, Math.floor(remainingMs - COARSE_TIMER_MARGIN_MS));
        continue;
      }
      if (remainingMs > 2) {
        await new Promise((resolve) => setImmediate(resolve));
        continue;
      }
      while (monotonicNs() < deadlineNs) {
        /* bounded spin for the last ~2 ms */
      }
      return;
    }
  })();
}

export function nowIso() {
  return new Date().toISOString();
}

export function hexWord(value) {
  return `0x${(value >>> 0).toString(16).padStart(8, '0')}`;
}

export function hexAddress(value) {
  return `0x${BigInt(value).toString(16).toUpperCase().padStart(8, '0')}`;
}

export function parseAddress(text) {
  if (typeof text === 'number') {
    if (Number.isInteger(text) && text >= 0 && text <= 0xffffffff) return text;
    throw new Error(`Invalid 32-bit address: ${text}`);
  }
  const cleaned = String(text ?? '').trim().replace(/_/g, '');
  let value = Number.NaN;
  if (/^0x[0-9a-f]+$/i.test(cleaned)) value = Number.parseInt(cleaned.slice(2), 16);
  else if (/^[0-9]+$/.test(cleaned)) value = Number.parseInt(cleaned, 10);
  if (!Number.isInteger(value) || value < 0 || value > 0xffffffff) {
    throw new Error(`Invalid 32-bit address: ${text} (expected decimal or 0x... form)`);
  }
  return value;
}

// Offsets/RVAs are 32-bit but must stay small enough to point inside a module.
export function parseOffset(text) {
  const value = parseAddress(text);
  if (value > 0x01000000) throw new Error(`Invalid offset/RVA: ${text}`);
  return value;
}

export function parseSeconds(text) {
  const cleaned = String(text ?? '').trim();
  const match = /^([0-9]+(?:\.[0-9]+)?)\s*(s|ms)?$/i.exec(cleaned);
  if (!match) throw new Error(`Invalid duration: ${text} (expected seconds, e.g. 10 or 2.5)`);
  const raw = Number.parseFloat(match[1]);
  const seconds = (match[2] ?? '').toLowerCase() === 'ms' ? raw / 1000 : raw;
  if (!Number.isFinite(seconds) || seconds <= 0) throw new Error(`Duration must be > 0 seconds: ${text}`);
  if (seconds > 3600) throw new Error(`Duration too long (max 3600 s): ${text}`);
  return seconds;
}

export function safeName(name) {
  const cleaned = String(name ?? '');
  if (!/^[A-Za-z0-9][A-Za-z0-9._-]{0,63}$/.test(cleaned)) {
    throw new Error(
      `Invalid name "${name}": use 1-64 characters from A-Z a-z 0-9 . _ - (must start with a letter or digit)`,
    );
  }
  return cleaned;
}

export function ensureDir(dir) {
  fs.mkdirSync(dir, { recursive: true });
  return dir;
}

export function csvEscape(value) {
  if (value === null || value === undefined) return '';
  const text = String(value);
  if (/[",\r\n]/.test(text)) return `"${text.replaceAll('"', '""')}"`;
  return text;
}

// Shortest round-trip representation of a JS number; empty string for non-finite.
export function formatValue(value) {
  if (typeof value !== 'number' || !Number.isFinite(value)) return '';
  return String(value);
}

export function relativePath(from, to) {
  const rel = path.relative(from, to);
  return rel === '' ? '.' : rel.split(path.sep).join('/');
}
