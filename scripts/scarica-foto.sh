#!/usr/bin/env bash
# Scarica in img/ tutte le foto di Cort di Quèla da beb.it e aggiorna index.html.
# Uso (dalla cartella del repo):  bash scripts/scarica-foto.sh
set -euo pipefail
cd "$(dirname "$0")/.."
CDN="https://dhqbz5vfue3y3.cloudfront.net"
mkdir -p img
curl -fsSL -A "Mozilla/5.0" https://beb.it/cortdiquela/it/ \
  | grep -oE 'fotobbit/39867/[0-9]/[A-Za-z0-9_.-]+\.jpg' | sort -u > /tmp/foto.txt
echo "Trovate $(wc -l < /tmp/foto.txt) foto"
while read -r p; do
  f="img/$(basename "$p")"
  [ -f "$f" ] || curl -fsSL -A "Mozilla/5.0" "$CDN/$p" -o "$f" && echo "ok $f"
done < /tmp/foto.txt
# punta index.html alle copie locali (og:image e JSON-LD restano assoluti)
sed -i.bak "/og:image\|@context/!s#$CDN/fotobbit/39867/[45]/#img/#g" index.html && rm -f index.html.bak
echo "Fatto. Controlla con: ls -lh img/"
