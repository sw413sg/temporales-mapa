#!/usr/bin/env bash
# Publica data/resultados.json actualizado en GitHub Pages (repo sw413sg/temporales-mapa)
set -euo pipefail
cd "$(dirname "$0")"
python3 -m json.tool data/resultados.json >/dev/null || { echo "resultados.json inválido"; exit 1; }
[ -d .git ] || { echo "Falta repo git: git init -b main && git remote add origin https://github.com/sw413sg/temporales-mapa.git"; exit 1; }
git add data/resultados.json
git diff --cached --quiet && { echo "Sin cambios"; exit 0; }
git commit -m "Actualizar resultados ($(date '+%Y-%m-%d %H:%M'))"
[ -n "${GITHUB_TOKEN:-}" ] || { echo "Falta GITHUB_TOKEN en el entorno"; exit 1; }
git -c credential.helper= -c credential.helper='!f(){ echo username=x-access-token; echo "password=$GITHUB_TOKEN"; }; f' push origin main
echo "Publicado: https://sw413sg.github.io/temporales-mapa/"
