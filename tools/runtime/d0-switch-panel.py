#!/usr/bin/env python3
"""Local two-button front end; delegates all game access to reviewed controllers."""
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
import argparse
import json
from pathlib import Path
import secrets
import subprocess
import sys
import threading
from datetime import datetime, timezone

ROOT = Path(__file__).resolve().parents[2]
HTML = Path(__file__).with_name('d0-switch-panel.html')


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--port', type=int, default=8767)
    parser.add_argument('--debugger-port', type=int, default=60907)
    parser.add_argument('--candidate', choices=('D0', 'D1'), default='D0')
    args = parser.parse_args()
    candidate = args.candidate.lower()
    html = HTML if candidate == 'd0' else HTML.with_name('d1-switch-panel.html')
    origin = f'http://127.0.0.1:{args.port}'
    token, busy = secrets.token_urlsafe(32), threading.Lock()

    class Handler(BaseHTTPRequestHandler):
        def log_message(self, *unused):
            pass

        def send(self, code, body, content_type='application/json'):
            self.send_response(code)
            self.send_header('Content-Type', content_type)
            self.send_header('Content-Length', str(len(body)))
            self.send_header('Cache-Control', 'no-store')
            self.send_header('X-Content-Type-Options', 'nosniff')
            self.end_headers(); self.wfile.write(body)

        def do_GET(self):
            if self.path != '/':
                return self.send(404, b'{}')
            page = html.read_text(encoding='utf-8').replace('__SESSION_TOKEN__', token)
            self.send(200, page.encode(), 'text/html; charset=utf-8')

        def do_POST(self):
            if self.path != '/switch' or self.headers.get('Origin') != origin or not secrets.compare_digest(self.headers.get('X-Session', ''), token):
                return self.send(403, b'{"error":"Request refused"}')
            try:
                size = int(self.headers.get('Content-Length', '0'))
                if not 0 < size <= 128:
                    raise ValueError('Invalid request size')
                target = json.loads(self.rfile.read(size))['target']
                if target not in ('status', 'A0', args.candidate):
                    raise ValueError('Invalid target')
            except (ValueError, KeyError, TypeError):
                return self.send(400, b'{"error":"Invalid request"}')
            if not busy.acquire(blocking=False):
                return self.send(409, b'{"error":"A switch is already in progress"}')
            try:
                name = datetime.now(timezone.utc).strftime('%Y%m%dT%H%M%S%fZ')+'-'+target
                directory = ROOT/f'research/live-tests/pokitaru/{candidate}-switch'/name
                process = subprocess.run([sys.executable,
                    str(ROOT/f'tools/runtime/switch-{candidate}-profile.py'), '--target', target,
                    '--out-dir', str(directory), '--port', str(args.debugger_port)],
                    capture_output=True, text=True, timeout=120)
                path = directory/'result.json'
                result = json.loads(path.read_bytes()) if path.exists() else {'status': 'UNRESOLVED', 'error': 'Controller failed; inspect local report'}
                # Return compact state; raw debugger evidence stays in the local report.
                compact = {k: result[k] for k in ('status', 'target', 'error', 'before', 'after', 'recovery') if k in result}
                self.send(200 if process.returncode == 0 else 422, json.dumps(compact).encode())
            except Exception:
                self.send(500, b'{"status":"UNRESOLVED","error":"Controller unavailable; verify current game profile"}')
            finally:
                busy.release()

    print(json.dumps({'panel': origin, 'scope': 'A0 / '+args.candidate}), flush=True)
    ThreadingHTTPServer(('127.0.0.1', args.port), Handler).serve_forever()


if __name__ == '__main__':
    main()
