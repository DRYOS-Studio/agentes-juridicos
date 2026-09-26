#!/usr/bin/env bash
# R2: os seis agentes de cálculo de entrada trazem o bloco de scripts/python-block.md,
# idêntico, e nenhum usa `python3 -c`. Os demais agentes podem conter exemplos Python
# próprios; eles não fazem parte deste check de compatibilidade do pacote.
# Uso: scripts/check-python-block.sh [--write]   (--write aplica o bloco onde ele diverge)
set -euo pipefail
cd "$(dirname "$0")/.."
CALC="acao-alimentos acao-vicio-produto-servico aposentadoria-tempo-contribuicao bpc-loas calculo-verbas-rescisorias reclamacao-trabalhista-inicial"
python3 - "$CALC" "${1:-}" <<'PY'
import sys, re, pathlib
calc, write = sys.argv[1].split(), sys.argv[2] == '--write'
block = pathlib.Path('scripts/python-block.md').read_text().strip()
bad = 0
for n in calc:
    p = pathlib.Path(f'plugins/agentes-juridicos/agents/{n}.md'); s = p.read_text()
    if write:
        s = re.sub(r'<!-- python:inicio -->.*?<!-- python:fim -->\n\n', '', s, flags=re.S)
        s = re.sub(r'```python\npython3 -c "\n(.*?)\n"\n```', r'```python\n\1\n```', s, flags=re.S)
        assert s.count('```python\n') == 1, n
        s = s.replace('```python\n', block + '\n\n```python\n', 1)
        p.write_text(s)
    found = re.findall(r'<!-- python:inicio -->.*?<!-- python:fim -->', s, flags=re.S)
    if found != [block]: print(f'R2 FAIL: {n} sem o bloco (ou divergente)'); bad += 1
    if 'python3 -c' in s: print(f'R2 FAIL: {n} ainda usa python3 -c'); bad += 1
    if '\\$' in s: print(f'R2 FAIL: {n} tem \\$ (resto de citação do shell)'); bad += 1
    # O código tem de rodar como arquivo .py (é assim que o bloco manda rodar).
    import subprocess, tempfile
    for code in re.findall(r'```python\n(.*?)\n```', s, flags=re.S):
        with tempfile.NamedTemporaryFile('w', suffix='.py', delete=False) as t: t.write(code)
        r = subprocess.run([sys.executable, t.name], capture_output=True, text=True)
        if r.returncode != 0: print(f'R2 FAIL: {n} código não roda: {r.stderr.strip().splitlines()[-1:]}'); bad += 1
        elif 'R$' not in r.stdout and 'R\\$' in r.stdout: print(f'R2 FAIL: {n} imprime R\\$'); bad += 1
print('R2 ok: bloco idêntico em', len(calc), 'agentes' if not bad else '')
sys.exit(1 if bad else 0)
PY
