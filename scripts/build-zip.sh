#!/usr/bin/env bash
# Gera o zip que o site publica em dryos.com.br/plugins/ (fonte `archive` do marketplace).
# Uso: scripts/build-zip.sh <dir-de-saída>   → imprime o caminho do zip e o sha256
set -euo pipefail
out="$(cd "${1:?dir de saída}" && pwd)"  # resolve antes de trocar de diretório
cd "$(dirname "$0")/.."
v=$(python3 -c 'import json;print(json.load(open("plugins/agentes-juridicos/.claude-plugin/plugin.json"))["version"])')
z="$out/agentes-juridicos-$v.zip"
rm -f "$z"
# A raiz do plugin fica 1 nível abaixo do topo do zip (aceito pela fonte archive).
(cd plugins && zip -qrX "$z" agentes-juridicos -x '*.DS_Store')
echo "$z"
shasum -a 256 "$z" | cut -d' ' -f1
