#!/usr/bin/env bash
# 파비콘 래스터 세트 생성: assets/img/favicon.svg (A안: #2F3438 바탕 + 흰 세리프 JY) 기준
# SVG 텍스트 렌더링을 위해 Chrome 헤드리스로 500px 래스터 후 ImageMagick으로 축소
# 요구: Google Chrome, ImageMagick 7
set -euo pipefail
cd "$(dirname "$0")/.."
CHROME="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
TMP=$(mktemp -d)
"$CHROME" --headless=new --disable-gpu --window-size=500,500 \
  --screenshot="$TMP/favicon-500.png" "file://$(pwd)/assets/img/favicon.svg" 2>/dev/null
magick "$TMP/favicon-500.png" -resize 180x180 assets/img/apple-touch-icon.png
magick "$TMP/favicon-500.png" -resize 32x32 assets/img/favicon-32.png
rm -rf "$TMP"
ls -l assets/img/favicon* assets/img/apple-touch-icon.png
