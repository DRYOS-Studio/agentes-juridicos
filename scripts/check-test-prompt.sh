#!/usr/bin/env bash
# G5: o prompt de teste do README, colado como está, aciona o agente divorcio-consensual.
# Custa uma execução real (conta logada). Uso: scripts/check-test-prompt.sh [arquivo-com-prompt]
set -euo pipefail
cd "$(dirname "$0")/.."
if [ -n "${1:-}" ]; then prompt=$(cat "$1"); else
  prompt=$(awk '/<!-- teste:inicio -->/{f=1;next}/<!-- teste:fim -->/{f=0}f' README.md | sed '/^```/d')
fi
[ -n "$prompt" ] || { echo "G5 FAIL: README sem bloco de teste"; exit 1; }
work=$(mktemp -d); out="$work/stream.jsonl"
(cd "$work" && claude -p "$prompt" --plugin-dir "$OLDPWD/plugins/agentes-juridicos" \
  --setting-sources project --strict-mcp-config --output-format stream-json --verbose \
  --max-turns 3 --no-session-persistence >"$out" 2>&1) || true
if python3 - "$out" <<'PY'
import json, sys
for line in open(sys.argv[1]):
    try: m = json.loads(line)
    except ValueError: continue
    for c in (m.get('message') or {}).get('content') or []:
        if isinstance(c, dict) and c.get('type') == 'tool_use' and 'divorcio-consensual' in str(c.get('input', {}).get('subagent_type', '')):
            print('G5 ok: tool_use', c['name'], c['input']['subagent_type']); sys.exit(0)
sys.exit(1)
PY
then rm -rf "$work"; else echo "G5 FAIL: nenhum tool_use para divorcio-consensual (log: $out)"; exit 1; fi
