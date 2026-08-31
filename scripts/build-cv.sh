#!/usr/bin/env bash
# CV 전체 빌드: yml → tex 조각 생성 → pdflatex 2회 → 정본 PDF를 웹 자산으로 복사
# GitHub Pages는 커스텀 플러그인을 실행하지 못하므로 PDF 복사는 Jekyll 빌드가 아니라
# 이 스크립트(로컬 컴파일 시점)에서 수행하고, 산출 PDF를 커밋한다.
# 사용법: ./scripts/build-cv.sh [--layout=pillar|year]
set -euo pipefail
cd "$(dirname "$0")/.."
export PATH="/Library/TeX/texbin:$PATH"

ruby scripts/build-cv-publications.rb "${1:---layout=pillar}"
(cd cv && pdflatex -interaction=nonstopmode CV_JoonYang_2026Spring.tex > /dev/null \
       && pdflatex -interaction=nonstopmode CV_JoonYang_2026Spring.tex > /dev/null)
cp cv/CV_JoonYang_2026Spring.pdf assets/pdf/CV_JoonYang.pdf
echo "built: cv/CV_JoonYang_2026Spring.pdf → assets/pdf/CV_JoonYang.pdf"
