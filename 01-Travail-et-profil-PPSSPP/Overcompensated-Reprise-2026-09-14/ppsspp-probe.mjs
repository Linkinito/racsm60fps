import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
const dir = path.dirname(fileURLToPath(import.meta.url));
const port = Number(process.argv[2]);
if (!Number.isInteger(port) || port < 1 || port > 65535) throw new Error('Usage: node ppsspp-probe.mjs PORT');
const endpoint = `ws://127.0.0.1:${port}/debugger`;
const report = { timestamp: new Date().toISOString(), endpoint, requests: [], connected: false };
let ws;
let serial = 0;
const pending = new Map();
function request(event, fields = {}) {
  if (!['version', 'game.status', 'memory.read_u32'].includes(event)) throw new Error('Read-only probe');
  const ticket = `probe-${++serial}`;
  return new Promise((resolve, reject) => {
    const timer = setTimeout(() => { pending.delete(ticket); reject(new Error(`Timeout: ${event}`)); }, 5000);
    pending.set(ticket, { resolve, reject, timer });
    ws.send(JSON.stringify({ event, ticket, ...fields }));
  }).then(result => { report.requests.push({ event, fields, result }); return result; });
}
try {
  ws = new WebSocket(endpoint, 'debugger.ppsspp.org');
  ws.addEventListener('message', ({ data }) => {
    try {
      const msg = JSON.parse(data);
      const p = pending.get(msg.ticket);
      if (p) { clearTimeout(p.timer); pending.delete(msg.ticket); msg.event === 'error' ? p.reject(new Error(msg.message)) : p.resolve(msg); }
    } catch (error) { report.messageError = String(error); }
  });
  await new Promise((resolve, reject) => {
    const timer = setTimeout(() => reject(new Error('Connection timeout')), 5000);
    ws.addEventListener('open', () => { clearTimeout(timer); resolve(); }, { once: true });
    ws.addEventListener('error', () => { clearTimeout(timer); reject(new Error('WebSocket connection failed')); }, { once: true });
  });
  report.connected = true;
  await request('version', { name: 'Overcompensated local probe', version: '0.1.0' });
  const status = await request('game.status');
  if (status.game?.id === 'UCES00420') {
    // Existing Kalidon cheat checks this module index; treat it as a candidate until correlated with profiler.
    await request('memory.read_u32', { address: 0x08841120 });
  }
} catch (error) { report.error = String(error); process.exitCode = 1; }
finally {
  for (const p of pending.values()) { clearTimeout(p.timer); }
  ws?.close();
  fs.mkdirSync(path.join(dir, 'connection'), { recursive: true });
  const output = path.join(dir, 'connection', `probe-${Date.now()}.json`);
  fs.writeFileSync(output, JSON.stringify(report, null, 2));
  console.log(JSON.stringify({ ...report, output }, null, 2));
}
