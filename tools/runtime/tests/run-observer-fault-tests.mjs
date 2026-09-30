// Regression tests for request-envelope integrity and partial breakpoint setup.
// Only an ephemeral loopback fake debugger is used. No game connection exists.
import assert from 'node:assert/strict';
import {PpssppClient, PolicyViolation} from '../lib/ppsspp-client.mjs';
import {autoBindProfile} from '../lib/binding.mjs';
import {FakePpssppDebugger} from './fake-ppsspp-debugger.mjs';

const identity = {module: {address: 0x09139D00}};
const profile = {name: 'fault-fixture', binding: {breakpointRva: 0x151D78, registers: {object: 'a0'}}};
const target = identity.module.address + profile.binding.breakpointRva;
const results = [];

async function test(name, run) {
  try {
    await run();
    results.push({name, ok: true});
    console.log(`PASS  ${name}`);
  } catch (error) {
    results.push({name, ok: false, error: error.stack});
    console.error(`FAIL  ${name}\n${error.stack}`);
  }
}

async function fixture(options, run) {
  const server = new FakePpssppDebugger({state: 'A0', ...options});
  let client;
  try {
    const port = await server.start(0);
    client = new PpssppClient({port, timeoutMs: 250, clientName: 'observer-fault-tests'});
    await client.connect();
    await run(server, client);
  } finally {
    client?.close();
    await server.stop();
  }
}

async function failure(run) {
  try {
    await run();
  } catch (error) {
    return error;
  }
  assert.fail('expected binding refusal/failure');
}

function bind(client, options = {}) {
  return autoBindProfile({client, identity, profile, hitTimeoutMs: 500, ...options});
}

async function waitUntil(predicate) {
  const deadline = Date.now() + 2000;
  while (!predicate()) {
    if (Date.now() > deadline) throw new Error('fixture condition timed out');
    await new Promise((resolve) => setTimeout(resolve, 2));
  }
}

await test('reserved event and ticket fields are refused before transmission', () => fixture({}, async (server, client) => {
  const before = server.requests.length;
  await assert.rejects(client.request('version', {event: 'memory.write_u32', address: target, value: 0}), PolicyViolation);
  await assert.rejects(client.request('version', {ticket: 'forged'}), PolicyViolation);
  await assert.rejects(client.request('version', Object.defineProperty({}, 'event', {value: 'cpu.resume'})), PolicyViolation);
  await assert.rejects(client.request('version', {toJSON: () => ({event: 'memory.write_u32', ticket: 'forged'})}), PolicyViolation);
  const serializationFailure = await failure(() => client.request('memory.read', {
    address: target,
    get size() { throw new Error('injected serialization failure'); },
  }));
  assert.equal(serializationFailure.requestSent, false);
  assert.equal(server.requests.length, before);
  assert.equal(server.violations.length, 0);
  assert.equal(client.stats.pendingRequests, 0);
  const response = await client.request('memory.read', {address: 0x09471640, size: 4});
  assert.equal(Buffer.from(response.base64, 'base64').length, 4);
  const frame = server.requests.at(-1);
  assert.equal(frame.event, 'memory.read');
  assert.equal(frame.fields.size, 4);
  assert.match(response.ticket, /^observer-fault-tests-\d+$/);
}));

await test('lost add acknowledgment while running removes breakpoint and restores CPU', () => fixture(
  {dropBreakpointAddAck: true}, async (server, client) => {
    const error = await failure(() => bind(client));
    assert.match(error.message, /Timeout.*cpu\.breakpoint\.add/);
    assert.equal(error.cleanup, undefined);
    assert.equal(server.breakpoints.size, 0);
    assert.equal(server.cpuStepping, false);
    assert(server.controlRequests.some((item) => item.event === 'cpu.stepping'));
    assert(server.controlRequests.some((item) => item.event === 'cpu.resume'));
  },
));

await test('lost add acknowledgment after owned hit removes breakpoint and resumes', () => fixture(
  {dropBreakpointAddAck: true, autoHitDelayMs: 15}, async (server, client) => {
    const error = await failure(() => bind(client));
    assert.match(error.message, /Timeout.*cpu\.breakpoint\.add/);
    assert.equal(error.cleanup, undefined);
    assert.equal(server.breakpoints.size, 0);
    assert.equal(server.cpuStepping, false);
    assert.equal(server.controlRequests.filter((item) => item.event === 'cpu.resume').length, 1);
    assert.equal(server.controlRequests.filter((item) => item.event === 'cpu.stepping').length, 0);
  },
));

await test('add failure before installation makes no pause or removal', () => fixture({}, async (server, client) => {
  const request = client.request.bind(client);
  client.request = (event, fields) => {
    if (event === 'cpu.breakpoint.add') return Promise.reject(new Error('injected failure before send'));
    return request(event, fields);
  };
  const error = await failure(() => bind(client));
  assert.match(error.message, /before send/);
  assert.equal(error.cleanup, undefined);
  assert.equal(server.breakpoints.size, 0);
  assert.equal(server.cpuStepping, false);
  assert(server.controlRequests.every((item) => item.event === 'cpu.breakpoint.list'));
}));

await test('external pause and unrelated breakpoint are preserved', () => fixture(
  {dropBreakpointAddAck: true}, async (server, client) => {
    const promise = failure(() => bind(client));
    await waitUntil(() => server.breakpoints.has(target));
    const unrelated = target + 0x400;
    server.breakpoints.set(unrelated, {address: unrelated, enabled: true, log: false});
    server.currentPc = unrelated;
    server.cpuStepping = true;
    const error = await promise;
    assert.equal(error.cleanup, undefined);
    assert.equal(server.breakpoints.has(target), false);
    assert.equal(server.breakpoints.has(unrelated), true);
    assert.equal(server.cpuStepping, true);
    assert(!server.controlRequests.some((item) => item.event === 'cpu.resume'));
  },
));

await test('pre-existing breakpoint refuses binding without changing it', () => fixture({}, async (server, client) => {
  server.breakpoints.set(target, {address: target, enabled: true, log: false});
  const error = await failure(() => bind(client));
  assert.match(error.message, /existing breakpoint/);
  assert.equal(server.breakpoints.size, 1);
  assert(server.controlRequests.every((item) => item.event === 'cpu.breakpoint.list'));
  assert.equal(server.cpuStepping, false);
}));

await test('definite pre-send failure preserves a concurrent breakpoint at the same address', () => fixture({}, async (server, client) => {
  const request = client.request.bind(client);
  client.request = async (event, fields) => {
    if (event === 'cpu.breakpoint.add') {
      server.breakpoints.set(target, {address: target, enabled: true, log: false});
      throw Object.assign(new Error('injected pre-send failure'), {requestSent: false});
    }
    return request(event, fields);
  };
  const error = await failure(() => bind(client));
  assert.match(error.message, /pre-send failure/);
  assert.equal(error.cleanup, undefined);
  assert.equal(server.breakpoints.has(target), true);
  assert.equal(server.cpuStepping, false);
  assert(server.controlRequests.every((item) => item.event === 'cpu.breakpoint.list'));
}));

await test('disconnect after installation reports unresolved cleanup', () => fixture({}, async (server, client) => {
  const request = client.request.bind(client);
  client.request = async (event, fields) => {
    const response = await request(event, fields);
    if (event === 'cpu.breakpoint.add') {
      client.close('injected disconnect after installation');
      throw new Error('injected disconnect');
    }
    return response;
  };
  const notices = [];
  const error = await failure(() => bind(client, {onEvent: (event, payload) => notices.push({event, payload})}));
  assert.equal(error.cleanup?.status, 'unresolved');
  assert.equal(error.cleanup.breakpointAddress, target);
  assert.match(error.message, /cleanup unresolved.*disconnected/);
  assert.equal(server.breakpoints.size, 1);
  assert(notices.some((item) => item.event === 'cleanup-error'));
  assert(!server.controlRequests.some((item) => item.event === 'cpu.resume'));
}));

await test('failed removal is reported and CPU is not resumed into its breakpoint', () => fixture(
  {dropBreakpointAddAck: true, rejectBreakpointRemove: true}, async (server, client) => {
    const error = await failure(() => bind(client));
    assert.equal(error.cleanup?.status, 'unresolved');
    assert.match(error.message, /cleanup unresolved.*removal failure/);
    assert.equal(server.breakpoints.size, 1);
    assert.equal(server.cpuStepping, true);
    assert(!server.controlRequests.some((item) => item.event === 'cpu.resume'));
  },
));

await test('already cancelled binding installs no breakpoint', () => fixture({}, async (server, client) => {
  const controller = new AbortController();
  controller.abort('cancelled before binding');
  const error = await failure(() => bind(client, {signal: controller.signal}));
  assert.match(error.message, /cancelled before binding/);
  assert.equal(server.breakpoints.size, 0);
  assert(server.controlRequests.every((item) => item.event === 'cpu.breakpoint.list'));
}));

console.log(`\n${results.filter((item) => item.ok).length}/${results.length} fault cases passed.`);
if (results.some((item) => !item.ok)) process.exitCode = 1;
