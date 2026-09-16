"""Read Codex discovery through its local app-server; never print credentials."""
import json
import pathlib
import queue
import shutil
import subprocess
import threading
import sys
import tomllib

sys.stdout.reconfigure(encoding='utf-8')

root = pathlib.Path(__file__).resolve().parents[1]
codex = shutil.which('codex')
if not codex:
    raise SystemExit('Codex not found')
process = subprocess.Popen([codex, 'app-server'], cwd=root, stdin=subprocess.PIPE,
                           stdout=subprocess.PIPE, stderr=subprocess.DEVNULL,
                           text=True, encoding='utf-8')
messages = queue.Queue()

def read_messages():
    for line in process.stdout:
        try:
            messages.put(json.loads(line))
        except json.JSONDecodeError:
            pass
    messages.put({'eof': True})

threading.Thread(target=read_messages, daemon=True).start()

def request(identity, method, params):
    process.stdin.write(json.dumps({'id': identity, 'method': method, 'params': params}) + '\n')
    process.stdin.flush()
    while True:
        message = messages.get(timeout=45)
        if message.get('eof'):
            raise RuntimeError('Codex app-server closed')
        if message.get('id') == identity:
            if 'error' in message:
                raise RuntimeError(message['error'])
            return message.get('result')

try:
    request(1, 'initialize', {'clientInfo': {'name': 'agency-inspector', 'version': '1.0'},
                              'capabilities': {'experimentalApi': True}})
    process.stdin.write(json.dumps({'method': 'initialized'}) + '\n')
    process.stdin.flush()
    result = request(2, 'config/read', {'cwd': str(root), 'includeLayers': True})
    config = result.get('config', {})
    print(json.dumps({'agents': config.get('agents'), 'layers': [
        {'name': layer.get('name'), 'disabledReason': layer.get('disabledReason')}
        for layer in result.get('layers', [])]}, ensure_ascii=False))
    result = request(3, 'skills/list', {'cwds': [str(root)], 'forceReload': True})
    found = []
    for entry in result.get('data', []):
        for skill in entry.get('skills', []):
            if str(root).lower() in str(skill.get('path', '')).lower():
                found.append({'name': skill.get('name'), 'path': skill.get('path'), 'enabled': skill.get('enabled')})
    print(json.dumps({'projectSkills': found}, ensure_ascii=False))
    expected_roles = {'game_designer', 'tech_lead', 'gameplay_engineer', 'ui_engineer',
                      'technical_artist', 'qa_studio', 'economy_analytics', 'release_growth'}
    assert expected_roles <= config.get('agents', {}).keys(), 'Missing role registrations'
    assert len(found) == 5 and all(item.get('enabled') for item in found), 'Skills discovery failed'
    for role in expected_roles:
        layer = tomllib.loads((root / '.codex' / 'agents' / (role + '.toml')).read_text(encoding='utf-8'))
        assert layer['mcp_servers']['Roblox_Studio']['enabled'] == (role == 'qa_studio'), role
    print('PASS: eight registered roles, five enabled skills, declared role MCP configuration.')
    print('NOT VERIFIED: effective MCP isolation; CLI 0.154.0 ignores role MCP overrides. Use start-agency.ps1 and runtime smoke.')
finally:
    process.terminate()
    try:
        process.wait(timeout=5)
    except subprocess.TimeoutExpired:
        process.kill()
