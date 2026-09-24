#!/usr/bin/env bash
# G1–G3 (G4 mora em tests/guide-sync.js no repo do site). Uso: scripts/check-pack.sh [source-do-marketplace]
# source default = este diretório; depois do push: DRYOS-Studio/agentes-juridicos
set -euo pipefail
cd "$(dirname "$0")/.."
SRC="${1:-$PWD}"
EXPECTED="acao-alimentos acao-cdc-pratica-abusiva acao-vicio-produto-servico aposentadoria-tempo-contribuicao bpc-loas calculo-verbas-rescisorias divorcio-consensual reclamacao-trabalhista-inicial"

# G1
claude plugin validate --strict . >/dev/null
claude plugin validate --strict plugins/agentes-juridicos >/dev/null
echo "G1 ok: validate --strict"

# G2: exatamente os 8, arquivo == name do frontmatter
got=""
for f in plugins/agentes-juridicos/agents/*.md; do
  n=$(sed -n 's/^name: *//p' "$f" | head -1)
  [ "$n.md" = "$(basename "$f")" ] || { echo "G2 FAIL: $f tem name=$n"; exit 1; }
  got="$got $n"
done
[ "$(echo $got | tr ' ' '\n' | sort | xargs)" = "$EXPECTED" ] || { echo "G2 FAIL: pacote =$got"; exit 1; }
echo "G2 ok: 8 agentes"

# G3: instala num config vazio usando os comandos do README
add=$(grep -oE '/plugin marketplace add [^ `]+' README.md | head -1 || true)
inst=$(grep -oE '/plugin install [^ `]+' README.md | head -1 || true)
[ -n "$add" ] && [ -n "$inst" ] || { echo "G3 FAIL: README sem comandos"; exit 1; }
id=${inst#/plugin install }
cfg=$(mktemp -d); trap 'rm -rf "$cfg"' EXIT
export CLAUDE_CONFIG_DIR="$cfg"
claude plugin marketplace add "$SRC" >/dev/null
claude plugin install "$id" >/dev/null
inv=$(claude plugin details "$id" | grep -E '^\s+Agents \(')
for a in $EXPECTED; do echo "$inv" | grep -q "$a" || { echo "G3 FAIL: $a não carregou"; exit 1; }; done
echo "$inv" | grep -q 'Agents (8)' || { echo "G3 FAIL: $inv"; exit 1; }
[ "$SRC" = "$PWD" ] || [ "${add#/plugin marketplace add }" = "$SRC" ] || { echo "G3 FAIL: README diz $add"; exit 1; }
echo "G3 ok: $id instalado, 8 agentes"
