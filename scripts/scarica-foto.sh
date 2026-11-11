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
  f="img/$(basename "$p")"; case "$p" in */5/*) f="img/cover-$(basename "$p")";; esac
  [ -f "$f" ] || curl -fsSL -A "Mozilla/5.0" "$CDN/$p" -o "$f" && echo "ok $f"
done < /tmp/foto.txt
curl -fsSL -A "Mozilla/5.0" https://www.topbnb.it/img/banner/topbb-quadrato-1.png -o img/topbnb.png && echo "ok img/topbnb.png"
sed -i.bak "s#https://www.topbnb.it/img/banner/topbb-quadrato-1.png#img/topbnb.png#" index.html && rm -f index.html.bak
sed -i.bak "s#$CDN/fotobbit/39867/5/39867.jpg#img/cover-39867.jpg#" index.html && rm -f index.html.bak
# punta index.html alle copie locali (og:image e JSON-LD restano assoluti)
sed -i.bak "/og:image\|@context/!s#$CDN/fotobbit/39867/[45]/#img/#g" index.html && rm -f index.html.bak
echo "Fatto. Controlla con: ls -lh img/"
