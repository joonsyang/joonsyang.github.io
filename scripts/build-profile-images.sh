#!/usr/bin/env bash
# 홈 프로필 웹용 이미지 생성 스크립트
# 소스: pic/Yang_Pic.jpg (2257x2527 마스터 원본)
# 출력: assets/img/profile-{800,1600}.{jpg,webp} — 4:5 세로 크롭, 얼굴 상단 1/3
# 요구: ImageMagick 7 (brew install imagemagick)
#
# 크롭 조정법: 원본에서 4:5 비율은 2021x2527(전체 높이 사용)이며,
#   CROP_X를 키우면 프레임이 오른쪽으로, 줄이면 왼쪽으로 이동한다 (0~236).
#   세로를 더 타이트하게 하려면 CROP_H를 줄이고 CROP_W=CROP_H*4/5, CROP_Y로 상단 위치 조정.
set -euo pipefail
cd "$(dirname "$0")/.."

SRC="pic/Yang_Pic.jpg"
OUT_DIR="assets/img"
CROP_W=2021   # 4:5 너비 (2527 * 4/5)
CROP_H=2527   # 전체 높이
CROP_X=118    # 수평 중앙: (2257-2021)/2
CROP_Y=0

for W in 1600 800; do
  magick "$SRC" -crop "${CROP_W}x${CROP_H}+${CROP_X}+${CROP_Y}" +repage \
    -resize "${W}x" -strip -quality 82 "$OUT_DIR/profile-${W}.jpg"
  magick "$SRC" -crop "${CROP_W}x${CROP_H}+${CROP_X}+${CROP_Y}" +repage \
    -resize "${W}x" -strip -quality 80 "$OUT_DIR/profile-${W}.webp"
done

ls -lh "$OUT_DIR"/profile-*
