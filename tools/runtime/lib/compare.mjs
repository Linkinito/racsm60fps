// Comparison of two captures: data only, never a gameplay verdict.
import fs from 'node:fs';
import path from 'node:path';
import {OBSERVER_NAME, OBSERVER_VERSION, ensureDir, nowIso, relativePath, sha256File} from './util.mjs';

const DERIVED_METRICS = ['start', 'end', 'min', 'max', 'mean', 'delta', 'slopePerSecond'];

export function loadCapture(measurementsDir, name) {
  const dir = path.join(measurementsDir, name);
  const manifestPath = path.join(dir, 'manifest.json');
  const summaryPath = path.join(dir, 'summary.json');
  if (!fs.existsSync(manifestPath) || !fs.existsSync(summaryPath)) {
    throw new Error(
      `Capture "${name}" is incomplete: ${relativePath(process.cwd(), dir)} must contain manifest.json and summary.json`,
    );
  }
  const manifest = JSON.parse(fs.readFileSync(manifestPath, 'utf8'));
  const summary = JSON.parse(fs.readFileSync(summaryPath, 'utf8'));
  return {
    name,
    dir,
    manifest,
    summary,
    manifestSha256: sha256File(manifestPath),
    summarySha256: sha256File(summaryPath),
  };
}

function metricEntry(a, b) {
  const bothNumbers = typeof a === 'number' && typeof b === 'number' && Number.isFinite(a) && Number.isFinite(b);
  let ratio = null;
  let ratioInvalidReason = null;
  if (!bothNumbers) {
    ratioInvalidReason = 'both values must be finite numbers';
  } else if (Math.abs(a) <= 1e-12) {
    ratioInvalidReason = 'A is zero (ratio undefined)';
  } else if (Math.sign(a) !== Math.sign(b)) {
    ratioInvalidReason = 'values have opposite signs (ratio not meaningful)';
  } else {
    ratio = b / a;
  }
  return {
    a: a ?? null,
    b: b ?? null,
    ratioBOverA: ratio,
    ratioValid: ratio !== null,
    ratioInvalidReason,
    absoluteDifferenceBMinusA: bothNumbers ? b - a : null,
  };
}

export function compareCaptures(measurementsDir, nameA, nameB, {comparisonsDir} = {}) {
  const captureA = loadCapture(measurementsDir, nameA);
  const captureB = loadCapture(measurementsDir, nameB);

  const refusals = [];
  const {manifest: manifestA, summary: summaryA} = captureA;
  const {manifest: manifestB, summary: summaryB} = captureB;

  if (manifestA.profile?.name !== manifestB.profile?.name) {
    refusals.push(
      `profiles differ: "${manifestA.profile?.name}" vs "${manifestB.profile?.name}"`,
    );
  }
  if (manifestA.profile?.normalizedSha256 !== manifestB.profile?.normalizedSha256) {
    refusals.push(
      'profile contents differ (normalized hash mismatch) even though the name may match',
    );
  }
  const entityA = manifestA.entity?.address ?? null;
  const entityB = manifestB.entity?.address ?? null;
  if (entityA !== entityB) {
    refusals.push(
      `entity addresses differ: ${manifestA.entity?.addressHex ?? 'none'} vs ${manifestB.entity?.addressHex ?? 'none'}`,
    );
  }
  if (manifestA.game?.id !== manifestB.game?.id) {
    refusals.push(`game ids differ: ${manifestA.game?.id ?? 'none'} vs ${manifestB.game?.id ?? 'none'}`);
  }
  if (manifestA.game?.version !== manifestB.game?.version) {
    refusals.push(
      `game versions differ: ${manifestA.game?.version ?? 'none'} vs ${manifestB.game?.version ?? 'none'}`,
    );
  }
  if (manifestA.module?.name !== manifestB.module?.name) {
    refusals.push(`modules differ: ${manifestA.module?.name ?? 'none'} vs ${manifestB.module?.name ?? 'none'}`);
  }

  const outDir = path.join(comparisonsDir ?? path.join(measurementsDir, 'comparisons'), `${nameA}__vs__${nameB}`);
  const comparisonPath = path.join(outDir, 'comparison.json');
  const markdownPath = path.join(outDir, 'COMPARISON.md');

  if (refusals.length > 0) {
    return {ok: false, refusals, outDir, comparisonPath, markdownPath};
  }

  const overall = {
    requestedSeconds: metricEntry(manifestA.requestedSeconds, manifestB.requestedSeconds),
    observedSeconds: metricEntry(summaryA.observedSeconds, summaryB.observedSeconds),
    sampleCount: metricEntry(summaryA.sampleCount, summaryB.sampleCount),
    missedSamples: metricEntry(summaryA.missedSamples, summaryB.missedSamples),
    sampleRateHz: metricEntry(summaryA.sampleRateHz, summaryB.sampleRateHz),
    meanTickRateHz: metricEntry(summaryA.ticks?.meanTickRateHz ?? null, summaryB.ticks?.meanTickRateHz ?? null),
  };

  const fieldNames = [
    ...new Set([...Object.keys(summaryA.fields ?? {}), ...Object.keys(summaryB.fields ?? {})]),
  ];
  const fields = {};
  for (const fieldName of fieldNames) {
    const fieldA = summaryA.fields?.[fieldName] ?? {};
    const fieldB = summaryB.fields?.[fieldName] ?? {};
    fields[fieldName] = Object.fromEntries(
      DERIVED_METRICS.map((metric) => [
        metric,
        metricEntry(
          typeof fieldA[metric] === 'number' ? fieldA[metric] : null,
          typeof fieldB[metric] === 'number' ? fieldB[metric] : null,
        ),
      ]),
    );
  }

  const comparison = {
    tool: {name: OBSERVER_NAME, version: OBSERVER_VERSION},
    generatedAtUtc: nowIso(),
    captures: {
      a: captureView(captureA),
      b: captureView(captureB),
    },
    compatibility: {
      compatible: true,
      refusals: [],
      profile: manifestA.profile?.name ?? null,
      profileNormalizedSha256: manifestA.profile?.normalizedSha256 ?? null,
      entity: manifestA.entity ?? null,
      dynamicBases: [manifestA.bases ?? null, manifestB.bases ?? null],
      game: manifestA.game ?? null,
      moduleName: manifestA.module?.name ?? null,
      moduleBases: [manifestA.module?.baseHex ?? null, manifestB.module?.baseHex ?? null],
      notes: [
        'Module base is recorded but not used as a compatibility key: it is a runtime address, not module identity.',
        'Auto-bound object/pvar bases are recorded for provenance but may legitimately differ between matched runs.',
      ],
    },
    overall,
    fields,
    notes: [
      'Data only. No gameplay conclusion (no "correct", "bugged", pass or fail claim) is drawn here.',
      'Ratios are omitted when mathematically invalid; see ratioInvalidReason.',
      'Delta and slope are only meaningful for fields that are monotonic inside each capture window.',
    ],
  };

  ensureDir(outDir);
  fs.writeFileSync(comparisonPath, `${JSON.stringify(comparison, null, 2)}\n`);
  fs.writeFileSync(markdownPath, renderMarkdown(comparison));

  return {ok: true, refusals: [], outDir, comparisonPath, markdownPath, comparison};
}

function captureView(capture) {
  return {
    name: capture.name,
    dir: relativePath(process.cwd(), capture.dir),
    state: capture.manifest.state,
    game: capture.manifest.game,
    module: capture.manifest.module,
    entity: capture.manifest.entity,
    bases: capture.manifest.bases ?? null,
    binding: capture.manifest.binding ?? null,
    profile: capture.manifest.profile?.name ?? null,
    observedSeconds: capture.summary.observedSeconds,
    sampleCount: capture.summary.sampleCount,
    sampleRateHz: capture.summary.sampleRateHz,
    aborted: capture.manifest.aborted === true,
    abortReason: capture.manifest.abortReason ?? null,
    manifestSha256: capture.manifestSha256,
    summarySha256: capture.summarySha256,
    guards: capture.manifest.guards,
  };
}

function fmt(value) {
  if (typeof value !== 'number' || !Number.isFinite(value)) return 'n/a';
  if (Number.isInteger(value)) return String(value);
  return value.toPrecision(7);
}

function metricRow(label, entry) {
  const ratio = entry.ratioValid ? fmt(entry.ratioBOverA) : `n/a (${entry.ratioInvalidReason})`;
  return `| ${label} | ${fmt(entry.a)} | ${fmt(entry.b)} | ${ratio} | ${fmt(entry.absoluteDifferenceBMinusA)} |`;
}

function renderMarkdown(comparison) {
  const {captures, overall, fields} = comparison;
  const lines = [];
  lines.push(`# RACSM capture comparison — ${captures.a.name} (A) vs ${captures.b.name} (B)`);
  lines.push('');
  lines.push(`Generated: ${comparison.generatedAtUtc} by ${comparison.tool.name} v${comparison.tool.version}.`);
  lines.push('');
  lines.push('**Data only.** This report draws no gameplay conclusion: it does not state whether');
  lines.push('either state is correct, bugged, faster or slower in gameplay terms. It only');
  lines.push('reports the recorded measurements and their arithmetic relations.');
  lines.push('');
  lines.push('## Capture identity');
  lines.push('');
  lines.push('| Field | A | B |');
  lines.push('| --- | --- | --- |');
  const rows = [
    ['Capture', captures.a.name, captures.b.name],
    ['Directory', captures.a.dir, captures.b.dir],
    ['Recognized state', captures.a.state, captures.b.state],
    ['Game', `${captures.a.game?.id ?? 'n/a'} v${captures.a.game?.version ?? 'n/a'}`, `${captures.b.game?.id ?? 'n/a'} v${captures.b.game?.version ?? 'n/a'}`],
    ['Module', `${captures.a.module?.name ?? 'n/a'} @ ${captures.a.module?.baseHex ?? 'n/a'}`, `${captures.b.module?.name ?? 'n/a'} @ ${captures.b.module?.baseHex ?? 'n/a'}`],
    ['Entity', captures.a.entity?.addressHex ?? 'none', captures.b.entity?.addressHex ?? 'none'],
    ['Profile', captures.a.profile ?? 'n/a', captures.b.profile ?? 'n/a'],
    ['Requested duration', `${fmt(overall.requestedSeconds.a)} s`, `${fmt(overall.requestedSeconds.b)} s`],
    ['Observed duration', `${fmt(overall.observedSeconds.a)} s`, `${fmt(overall.observedSeconds.b)} s`],
    ['Samples', fmt(overall.sampleCount.a), fmt(overall.sampleCount.b)],
    ['Missed samples', fmt(overall.missedSamples.a), fmt(overall.missedSamples.b)],
    ['Sample rate', `${fmt(overall.sampleRateHz.a)} Hz`, `${fmt(overall.sampleRateHz.b)} Hz`],
  ];
  for (const [label, a, b] of rows) lines.push(`| ${label} | ${a} | ${b} |`);
  lines.push('');
  lines.push('Compatibility checks passed: same profile (normalized hash), same entity address,');
  lines.push('same game id/version, same module name. Module base is recorded for provenance only.');
  lines.push('');
  lines.push('## Overall metrics');
  lines.push('');
  lines.push('| Metric | A | B | B/A | B-A |');
  lines.push('| --- | --- | --- | --- | --- |');
  for (const [label, entry] of Object.entries(overall)) lines.push(metricRow(label, entry));
  lines.push('');
  lines.push('## Field metrics');
  for (const [fieldName, metrics] of Object.entries(fields)) {
    lines.push('');
    lines.push(`### ${fieldName}`);
    lines.push('');
    lines.push('| Metric | A | B | B/A | B-A |');
    lines.push('| --- | --- | --- | --- | --- |');
    for (const [metric, entry] of Object.entries(metrics)) lines.push(metricRow(metric, entry));
  }
  lines.push('');
  lines.push('## Provenance');
  lines.push('');
  lines.push(`- ${captures.a.name}: manifest sha256 \`${captures.a.manifestSha256}\`, summary sha256 \`${captures.a.summarySha256}\``);
  lines.push(`- ${captures.b.name}: manifest sha256 \`${captures.b.manifestSha256}\`, summary sha256 \`${captures.b.summarySha256}\``);
  lines.push('');
  return `${lines.join('\n')}\n`;
}
