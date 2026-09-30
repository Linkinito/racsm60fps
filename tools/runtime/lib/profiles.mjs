// Measurement profiles: which fields to sample, defined by JSON files so new
// profiles can be added without touching the observer code.
import fs from 'node:fs';
import path from 'node:path';
import {parseOffset, sha256File, sha256Json} from './util.mjs';

export const FIELD_TYPES = Object.freeze({
  float32: {size: 4, read: 'readFloatLE'},
  float64: {size: 8, read: 'readDoubleLE'},
  int32: {size: 4, read: 'readInt32LE'},
  uint32: {size: 4, read: 'readUInt32LE'},
  int16: {size: 2, read: 'readInt16LE'},
  uint16: {size: 2, read: 'readUInt16LE'},
  int8: {size: 1, read: 'readInt8'},
  uint8: {size: 1, read: 'readUInt8'},
});

export const FIELD_BASES = Object.freeze(['entity', 'object', 'pvar', 'module']);

// Coalescing limits for block reads: merge nearby fields, but keep each
// memory.read small enough to stay cheap and bounded.
const MAX_BLOCK_BYTES = 0x400;
const MAX_BLOCK_GAP = 0x40;

export function profilesDir(projectRoot) {
  return path.join(projectRoot, 'tools', 'runtime', 'profiles');
}

export function listProfiles(projectRoot) {
  const dir = profilesDir(projectRoot);
  if (!fs.existsSync(dir)) return [];
  return fs
    .readdirSync(dir)
    .filter((file) => file.toLowerCase().endsWith('.json'))
    .map((file) => path.basename(file, '.json'))
    .sort();
}

export function loadProfile(projectRoot, name) {
  const available = listProfiles(projectRoot);
  const file = path.join(profilesDir(projectRoot), `${name}.json`);
  if (!fs.existsSync(file)) {
    throw new Error(`Unknown profile "${name}". Available profiles: ${available.join(', ') || '(none)'}`);
  }
  const raw = fs.readFileSync(file, 'utf8');
  let parsed;
  try {
    parsed = JSON.parse(raw);
  } catch (error) {
    throw new Error(`Profile ${file} is not valid JSON: ${error.message}`);
  }
  if (typeof parsed.name !== 'string' || parsed.name !== name) {
    throw new Error(`Profile ${file} must declare "name": "${name}" (found ${JSON.stringify(parsed.name)})`);
  }
  if (!Array.isArray(parsed.fields) || parsed.fields.length === 0) {
    throw new Error(`Profile ${file} must declare a non-empty "fields" array`);
  }

  const seen = new Set();
  const fields = parsed.fields.map((field, index) => {
    const where = `fields[${index}]`;
    if (typeof field?.name !== 'string' || !/^[A-Za-z_][A-Za-z0-9_]*$/.test(field.name)) {
      throw new Error(`${where}.name must be an identifier-like string`);
    }
    if (seen.has(field.name)) throw new Error(`${where}.name "${field.name}" is duplicated`);
    seen.add(field.name);
    const type = String(field.type ?? '').toLowerCase();
    const typeSpec = FIELD_TYPES[type];
    if (!typeSpec) {
      throw new Error(
        `${where}.type "${field.type}" is unsupported (allowed: ${Object.keys(FIELD_TYPES).join(', ')})`,
      );
    }
    const base = String(field.base ?? 'entity').toLowerCase();
    if (!FIELD_BASES.includes(base)) {
      throw new Error(`${where}.base "${field.base}" is unsupported (allowed: ${FIELD_BASES.join(', ')})`);
    }
    const offset = parseOffset(field.offset);
    return {name: field.name, offset, type, base, size: typeSpec.size, read: typeSpec.read};
  });

  let binding = null;
  if (parsed.binding !== undefined) {
    if (!parsed.binding || typeof parsed.binding !== 'object' || Array.isArray(parsed.binding)) {
      throw new Error(`Profile ${file} binding must be an object`);
    }
    const breakpointRva = parseOffset(parsed.binding.breakpointRva);
    const rawRegisters = parsed.binding.registers;
    if (!rawRegisters || typeof rawRegisters !== 'object' || Array.isArray(rawRegisters)) {
      throw new Error(`Profile ${file} binding.registers must map bases to GPR names`);
    }
    const registers = {};
    for (const [base, rawRegister] of Object.entries(rawRegisters)) {
      if (!['object', 'pvar'].includes(base)) {
        throw new Error(`Profile ${file} binding register base "${base}" is unsupported`);
      }
      const register = String(rawRegister ?? '').replace(/^\$/, '').toLowerCase();
      if (!/^(?:a[0-3]|v[01]|s[0-7]|t[0-9]|gp|sp|fp|ra)$/.test(register)) {
        throw new Error(`Profile ${file} binding register "${rawRegister}" is not a supported GPR name`);
      }
      registers[base] = register;
    }
    for (const base of new Set(fields.map((field) => field.base).filter((base) => ['object', 'pvar'].includes(base)))) {
      if (!registers[base]) throw new Error(`Profile ${file} needs binding.registers.${base}`);
    }
    binding = {breakpointRva, registers};
  }

  const normalized = {
    name: parsed.name,
    binding,
    fields: fields.map(({name, offset, type, base}) => ({name, offset, type, base})),
  };
  return {
    name: parsed.name,
    description: typeof parsed.description === 'string' ? parsed.description : null,
    file,
    sha256: sha256File(file),
    normalizedSha256: sha256Json(normalized),
    binding,
    fields,
  };
}

export function describeField(field) {
  return `${field.name} = ${field.base}+0x${field.offset.toString(16).toUpperCase()} (${field.type})`;
}

// Builds the concrete read plan for one capture: absolute addresses plus
// coalesced memory.read blocks.
export function buildReadPlan(
  profile,
  {
    entityAddress = null,
    objectAddress = null,
    pvarAddress = null,
    moduleBase = null,
    moduleSize = null,
    baseAddresses = null,
  } = {},
) {
  const resolvedBases = {
    entity: baseAddresses?.entity ?? entityAddress,
    object: baseAddresses?.object ?? objectAddress,
    pvar: baseAddresses?.pvar ?? pvarAddress,
    module: baseAddresses?.module ?? moduleBase,
  };
  const groups = new Map();
  for (const field of profile.fields) {
    const groupBase = resolvedBases[field.base];
    if (!Number.isInteger(groupBase)) {
      throw new Error(
        `Field "${field.name}" needs a ${field.base} base address; ` +
          (field.base === 'module'
            ? 'no active module base'
            : field.base === 'entity'
              ? 'no active entity (run "entity 0x...")'
              : `profile target has not been auto-bound (${field.base})`),
      );
    }
    if (field.base === 'module' && Number.isInteger(moduleSize) && field.offset + field.size > moduleSize) {
      throw new Error(
        `Field "${field.name}" (module+0x${field.offset.toString(16)}) falls outside the active module size`,
      );
    }
    const address = groupBase + field.offset;
    if (!groups.has(field.base)) groups.set(field.base, []);
    groups.get(field.base).push({...field, address, baseAddress: groupBase});
  }

  const blocks = [];
  for (const [base, fields] of groups) {
    const sorted = [...fields].sort((a, b) => a.address - b.address);
    let current = null;
    for (const field of sorted) {
      if (
        current &&
        field.address - (current.start + current.size) <= MAX_BLOCK_GAP &&
        field.address + field.size - current.start <= MAX_BLOCK_BYTES
      ) {
        current.fields.push({field, relativeOffset: field.address - current.start});
        current.size = Math.max(current.size, field.address + field.size - current.start);
        continue;
      }
      current = {
        base,
        start: field.address,
        size: field.size,
        fields: [{field, relativeOffset: 0}],
      };
      blocks.push(current);
    }
  }

  return {
    profile: profile.name,
    profileNormalizedSha256: profile.normalizedSha256,
    entityAddress,
    moduleBase,
    baseAddresses: Object.fromEntries(
      Object.entries(resolvedBases).filter(([, value]) => Number.isInteger(value)),
    ),
    fields: blocks.flatMap((block) =>
      block.fields.map(({field}) => ({
        name: field.name,
        base: field.base,
        offset: `0x${field.offset.toString(16).toUpperCase()}`,
        type: field.type,
        address: field.address,
        addressHex: `0x${field.address.toString(16).toUpperCase().padStart(8, '0')}`,
      })),
    ),
    blocks: blocks.map((block) => ({
      base: block.base,
      address: block.start,
      addressHex: `0x${block.start.toString(16).toUpperCase().padStart(8, '0')}`,
      size: block.size,
      fields: block.fields.map(({field}) => field.name),
      fieldRefs: block.fields.map(({field, relativeOffset}) => ({
        name: field.name,
        read: field.read,
        relativeOffset,
      })),
    })),
  };
}

// One sample: every planned block is read once (single request per block).
// A failing block fails the whole sample; the caller records the miss.
export async function sampleProfile(client, plan) {
  const values = {};
  for (const block of plan.blocks) {
    const raw = await client.request('memory.read', {
      address: block.address,
      size: block.size,
      replacements: false,
    });
    if (typeof raw.base64 !== 'string') throw new Error(`memory.read at ${block.addressHex} returned no base64 payload`);
    const buffer = Buffer.from(raw.base64, 'base64');
    if (buffer.length < block.size) {
      throw new Error(`memory.read at ${block.addressHex} returned ${buffer.length} bytes, expected ${block.size}`);
    }
    for (const fieldRef of block.fieldRefs) {
      values[fieldRef.name] = buffer[fieldRef.read](fieldRef.relativeOffset);
    }
  }
  return values;
}
