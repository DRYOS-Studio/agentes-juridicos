#!/usr/bin/env bash
# G1–G3 (G4 mora em tests/guide-sync.js no repo do site). Uso: scripts/check-pack.sh [source-do-marketplace]
# source default = este diretório; o canal de produção é https://www.dryos.com.br/plugins/marketplace.json
set -euo pipefail
cd "$(dirname "$0")/.."
SRC="${1:-$PWD}"
EXPECTED_COUNT=50

# G1
claude plugin validate --strict . >/dev/null
claude plugin validate --strict plugins/agentes-juridicos >/dev/null
echo "G1 ok: validate --strict"

# G2: exatamente os 8, arquivo == name do frontmatter
got=""
count=0
for f in plugins/agentes-juridicos/agents/*.md; do
  count=$((count + 1))
  n=$(sed -n 's/^name: *//p' "$f" | head -1)
  [ "$n.md" = "$(basename "$f")" ] || { echo "G2 FAIL: $f tem name=$n"; exit 1; }
  got="$got $n"
done
[ "$count" -eq "$EXPECTED_COUNT" ] || { echo "G2 FAIL: esperado=$EXPECTED_COUNT, pacote=$count"; exit 1; }
echo "G2 ok: $count agentes"

# R4: a versão do plugin.json é a mesma do marketplace do repo
vp=$(python3 -c 'import json;print(json.load(open("plugins/agentes-juridicos/.claude-plugin/plugin.json"))["version"])')
vm=$(python3 -c 'import json;print([p for p in json.load(open(".claude-plugin/marketplace.json"))["plugins"] if p["name"]=="agentes-juridicos"][0]["version"])')
[ "$vp" = "$vm" ] || { echo "R4 FAIL: plugin.json=$vp marketplace=$vm"; exit 1; }
echo "R4 ok: versão $vp"

# G3: instala num config vazio o plugin que o deep link do README pede
inst=$(grep -oE 'install-plugin\?plugin=[a-z-]+' README.md | head -1 | sed 's/.*plugin=//' || true)
mkt=$(python3 -c 'import json;print(json.load(open(".claude-plugin/marketplace.json"))["name"])')
[ -n "$inst" ] || { echo "G3 FAIL: README sem o deep link install-plugin"; exit 1; }
id="$inst@$mkt"
cfg=$(mktemp -d); trap 'rm -rf "$cfg"' EXIT
export CLAUDE_CONFIG_DIR="$cfg"
claude plugin marketplace add "$SRC" >/dev/null
claude plugin install "$id" >/dev/null
inv=$(claude plugin details "$id" | grep -E '^\s+Agents \(')
echo "$inv" | grep -q "Agents ($EXPECTED_COUNT)" || { echo "G3 FAIL: $inv"; exit 1; }
echo "G3 ok: $id instalado, $EXPECTED_COUNT agentes"
