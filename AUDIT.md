# joonsyang.github.io 사이트 감사 (AUDIT)

> Audited on 2026-08-31 against upstream Beautiful Jekyll master snapshot (gemspec: 6.0.1).
> **상태: 리디자인 완료 (2026-09-01)** — 아래 감사 항목은 redesign 브랜치에서 전부 해소됨.

## 해결 현황 (2026-09-01 갱신)

| 감사 항목 | 상태 | 해결 커밋 |
|---|---|---|
| meta description "Associate→Assistant" 오기 | ✅ | `8bdbdc4` (hotfix, master 배포됨) |
| aboutme 테마 데모 페이지 공개 | ✅ | `3496a2e` (hotfix, master 배포됨) |
| 모바일 햄버거 아이콘 비가시 | ✅ | `559b2c1` |
| 모바일 ≤768px 전폭·링크 처리 | ✅ | `559b2c1` (링크는 이후 `9bc5dd3`에서 제목 링크로 재설계) |
| navbar 브레이크포인트 불일치 (768 vs 1200) | ✅ | `559b2c1` |
| 키보드 focus-visible 부재 | ✅ | `559b2c1` — 2026-09-01 computed style 실측으로 검증 완료 |
| 테이블 모바일 가로 스크롤 제거 | ✅ | `8173415` (업스트림 규칙 복원) |
| beautifuljekyll.css 직접 수정 (업데이트 유실 위험) | ✅ | `8173415` (원본 복원, 커스텀은 custom.css로 이전) |
| 죽은 CSS (custom-styles.css, .content-section, .page-*) | ✅ | `8173415` (_archive에 보존) |
| 무효 Bootstrap 클래스 offset-xl-1.5 | ✅ | `cc9f7e5` |
| 본문 900px 폭 제한 사멸 | ✅ | `cc9f7e5` (.page-inner + 디자인 토큰) |
| index.md 인라인 스타일 | ✅ | `a107b9d` |
| 2257px 원본 이미지 직접 로드 | ✅ | `a107b9d` (picture/srcset, webp) |
| 링크 색-만-구분 (WCAG 1.4.1) | ✅ | `cc9f7e5` + `9bc5dd3` |
| `{% seo %}` 미적용 (JSON-LD 부재) | ✅ | `e810518` |
| og:image·favicon 부재 | ✅ | `e810518` |
| 서브페이지 title 사이트명 누락 / title-separator 죽은 키 | ✅ | `e810518` |
| 죽은 keywords 메타, 전 페이지 동일 description | ✅ | `e810518` |
| CV PDF iframe (모바일 열람 불가, title 없음, 모호한 링크) | ✅ | `32d9fad` (HTML + 다운로드 버튼) |
| cv.md 죽은 front matter (name:/class:) | ✅ | `32d9fad` |
| 상단 여백 중복 (body padding + intro-header) | ✅ | `32d9fad` |
| 구 CV PDF(2024) sitemap 노출 | ✅ | `32d9fad` (삭제) |
| 이메일·전화 링크화 + 이모지 접근성 | ✅ | `f8d0eab` |
| tags.html 빈 페이지 | ✅ | `f8d0eab` (삭제) |
| 404 사우스파크 데모 | ✅ | `f8d0eab` (미니멀 404로 교체) |
| feed.xml·social-networks-links 업스트림 지연 | ✅ | `f8d0eab` |
| sitemap의 구글 확인 파일 | ✅ | `f8d0eab` (sitemap: false, 검증 내용 불변) |
| 논문 목록 하드코딩 (유지보수 취약) | ✅ | `0f0160a` 외 — publications.yml 단일 소스화 (사이트+CV) |
| 한국어 논문 원제 부재 | ✅ | `6e44138` |

**미해결로 남는 항목** (데이터 대기, 구조 아님):
- EEEP 논문(Are Credit Rating Agencies…)의 `url` — 발행처(IAEE) 논문 페이지 링크 확보 시 연결
- projects.yml `summary` 4건 — 초안 상태, 문안 다듬기 예정

- 감사일: 2026-08-31
- 기준: Beautiful Jekyll 업스트림과의 diff + 로컬 빌드(`bundle exec jekyll build`) 결과물(`_site/`) 검증
- 참고: gemspec은 6.0.1이지만 실제 파일들은 6.0.1 이후의 **upstream master 스냅샷**과 거의 일치한다.
  아래 "변경됨"은 upstream master 대비 기준이며, 빌드된 HTML에서 실제 렌더링을 확인한 항목은 ✔로 표시했다.

---

## 1. 테마 기본값 대비 변경/미변경 목록

### 변경된 파일 (사용자 커스텀)

| 파일 | 변경 내용 |
|---|---|
| `_config.yml` | 전면 재작성. 제목/저자, navbar 링크(HOME·CV·RESEARCH), 색상, 블로그 기능 제거(paginate 0, post_search false), `site-css`로 custom.css 로드, SEO 설정(description, lang, social), sitemap·seo-tag 플러그인 |
| `_layouts/page.html` | 컨테이너를 `container-fluid` 고정 + `col-xl-8 offset-xl-1.5 mx-auto`로 교체 (`full-width` 옵션 제거). ⚠ `offset-xl-1.5`는 존재하지 않는 Bootstrap 클래스(무효) — 중앙정렬은 `mx-auto`가 담당 |
| `_includes/head.html` | meta description을 페이지별 값 대신 **항상 `site.description`** 출력하도록 변경. keywords 메타를 하드코딩("joon yang, joonseok yang, …")했으나 `site.keywords` 미설정 가드 때문에 **실제로는 출력 안 됨** ✔ |
| `assets/css/beautifuljekyll.css` | 테마 원본에 직접 수정: footer 마진 변경, **테이블 `overflow-x:auto; display:block` 제거**(모바일 가로 스크롤 대응 삭제), `#social-share-section a` 색, 파일 끝에 navbar padding 관련 `!important` 규칙 4개 추가 |
| `assets/css/custom.css` | 신규 파일 (188줄, 상세는 §3) |
| `assets/css/custom-styles.css` | 신규 파일 (8줄) — ⚠ **어디서도 로드되지 않는 죽은 파일** (`site-css`에 custom.css만 등록) |
| `assets/js/beautifuljekyll.js` | "모바일에서 메뉴 클릭 시 navbar 자동 접힘" 핸들러 5줄 삭제 (upstream엔 있음) |
| `_includes/social-networks-links.html` | strava 블록 없음 (사용자 편집이라기보다 fork 이후 upstream 추가분 누락으로 추정) |
| `feed.xml` | `dc:creator` 관련 upstream 추가분 누락 (위와 동일한 성격) |
| 콘텐츠/자산 | `index.md`, `research.md`, `cv.md` 재작성. `assets/img/profile.jpg`, `assets/pdf/CV_*.pdf`(2024, 2025Spring 두 벌), `assets/pdf/temp.md`, `robots.txt`, `google145b7ad3ffbd7740.html`(구글 소유 확인) 추가 |

### 손대지 않은 파일 (테마 기본값 그대로)

- `_layouts/` — base, default, home, minimal, post (page.html 제외 전부)
- `_includes/` — nav, header, footer, footer-scripts, comments 계열(disqus/giscus/utterances/staticman 등), analytics 계열(gtag/gtm/matomo/cloudflare), search, social-share, mathjax, readtime, ext-css/js 등 (head, social-networks-links 제외 전부)
- `assets/css/` — beautifuljekyll-minimal.css, bootstrap-social.css, pygment_highlights.css, staticman.css
- `_data/ui-text.yml`, `tags.html`, `404.html`(사우스파크 이미지 포함), `staticman.yml`
- **`aboutme.md` — 테마 데모 그대로** ("My name is Inigo Montoya…") — §4 참조
- 테마 개발용 잔재: `Appraisals`, `.github/`(FUNDING.yml, 이슈/PR 템플릿, ci.yml), `screenshot.png`, `beautiful-jekyll-theme.gemspec`

---

## 2. 페이지별 front matter & 콘텐츠 구조

| 페이지 | front matter | 구조 |
|---|---|---|
| `index.md` | `layout: page`, `description`, `keywords` (title 없음) | 인라인 스타일 HTML: 중앙 정렬 이름/직함/소속 헤더(h1) → flex 2단(좌: 프로필 사진 200px + 이메일·전화, 우: 자기소개 2문단). 모바일 스택 전환은 custom.css의 `.profile-main` 계열이 담당 ✔ |
| `research.md` | `layout: page`, `title: Research`, `name`, `class: page-research` | h2 "Peer-Reviewed Articles" + 게재 논문 약 30건 불릿 목록(제목·저널·연도·공저자·DOI 링크). 순수 마크다운 |
| `cv.md` | `layout: page`, `title: CV`, `name`, `class: page-cv` | `[Download]` 링크 + PDF(2025Spring) `<iframe>` (width 100%, height 800px 고정) |
| `aboutme.md` | `layout: page`, `title: About me`, `subtitle` | ⚠ 테마 데모 텍스트 그대로. navbar엔 없지만 `/aboutme`로 **빌드·공개됨** ✔ |
| `tags.html`, `404.html`, `feed.xml` | 테마 기본 | 블로그 미사용이라 tags는 빈 페이지로 공개됨 ✔ |

**죽은 front matter** ✔: `name:`과 `class:`는 테마 어디에서도 참조되지 않는다(레이아웃/인클루드에 `page.name`, `page.class` 사용처 0건). 따라서 `class: page-research/page-cv`는 HTML에 출력되지 않고, 이를 노리는 custom.css 규칙도 함께 죽는다(§3). `index.md`의 `description`/`keywords`도 head.html 수정 때문에 무시된다(§4 SEO).

---

## 3. 커스텀 CSS 현황

**총 3곳, 약 220줄:**

1. **`assets/css/custom.css` (188줄)** — `_config.yml`의 `site-css`로 전 페이지 로드 ✔
   - navbar: 배경 `#2F3438` 강제, fixed-top, 브랜드(로고) 숨김, 메뉴 중앙 정렬, 링크 흰색 — 다중 셀렉터 + `!important` 다수 (테마 CSS와 우선순위 전쟁)
   - body `padding-top: 30px` (모바일 60px)
   - `.profile-main`/`.profile-image` 모바일(≤768px) 스택 전환 — **작동함** ✔
   - ⚠ **죽은 규칙 다수** ✔: `.page-research`/`.page-cv`(클래스 미출력, §2), `.content-section` 계열 약 45줄(빌드 HTML에 `content-section` 0건 — research.md에 래퍼 div가 없음)
   - `.cv-page`, `iframe` 스타일 — 작동함
2. **`assets/css/beautifuljekyll.css` 내 직접 수정 (~20줄)** — 테마 원본 파일 편집이라 **테마 업데이트 시 유실 위험**. 파일 끝 추가분의 navbar padding 규칙은 custom.css 규칙과 서로 `!important`로 충돌(specificity가 높은 custom.css가 이김)
3. **`assets/css/custom-styles.css` (8줄)** — 어디서도 로드 안 되는 죽은 파일 ✔

이 밖에 `index.md`에 인라인 `style=` 속성 약 15개 (사실상 네 번째 커스텀 CSS 층).

---

## 4. 문제점

### 모바일

1. **햄버거 메뉴 아이콘이 사실상 안 보임** — `nav.html`은 `navbar-light`(어두운 아이콘)인데 custom.css가 배경을 진회색 `#2F3438`로 강제 → 1200px 미만(테마는 `navbar-expand-xl`)에서 어두운 아이콘이 어두운 배경 위에 놓임. 대비 약 1.6:1.
2. **브레이크포인트 불일치** — custom.css 모바일 규칙은 768px 기준인데 navbar 접힘은 1200px 기준. 768–1199px(태블릿·작은 노트북) 구간은 접힌 메뉴 + 데스크톱용 여백/스타일이 섞여 적용됨.
3. **CV 페이지의 PDF iframe** — iOS Safari 등 모바일 브라우저는 iframe 내 PDF를 첫 페이지만 렌더링하거나 아예 표시하지 못하는 경우가 많아, 모바일에서 CV 열람이 사실상 불가. 높이도 800px 고정.
4. **테이블 가로 스크롤 제거** — beautifuljekyll.css에서 `table { overflow-x: auto; display: block }` 삭제됨. 현재 콘텐츠에 표가 없어 잠복 상태지만, 표를 넣는 순간 모바일에서 가로로 뚫고 나감.
5. `beautifuljekyll.js`에서 메뉴 선택 후 navbar 자동 접힘 코드 삭제됨 (페이지 이동으로 리로드되므로 현재 체감은 적음).
6. body `padding-top`(30/60px) + 테마 `.intro-header` 상단 마진 5rem이 중첩되어 상단 여백 과다·불일치.

### 접근성

1. 햄버거 아이콘 대비 부족 (모바일 #1과 동일 — WCAG 1.4.11 비텍스트 대비 미달).
2. CV `<iframe>`에 `title` 속성 없음 (WCAG 4.1.2).
3. `[Download]` 링크 텍스트가 목적을 설명하지 못함 (WCAG 2.4.4) — "Download CV (PDF)" 권장.
4. 이메일·전화가 일반 텍스트 + 이모지(✉️📞) — `mailto:`/`tel:` 링크 아님, 이모지가 스크린리더에서 "envelope" 등으로 읽힘.
5. research 목록의 DOI 링크가 색(#666, 밑줄 없음)만으로 본문과 구분됨 (WCAG 1.4.1 — 링크·본문 색 대비 1.4:1 수준). *(단, 해당 규칙 자체가 현재 죽은 CSS라 실제 렌더링은 테마 기본 링크 색이 적용됨 — 리디자인 시 참고)*
6. `frameborder` 등 폐기된 속성 사용 (경미).
7. 제목 구조는 양호: index는 자체 h1, research/CV는 헤더 h1 + 본문 h2 ✔.

### SEO 메타 오류

1. **✔ 확정: meta description에 "Associate Professor" 오기** — `_config.yml:66`
   `description: "Joonseok Yang, Associate Professor in Political Science. …"`
   실제 직함은 **Assistant** Professor. head.html 수정(아래 #3) 때문에 이 잘못된 문구가 **모든 페이지**의 `<meta name="description">`에 출력됨 (빌드 결과로 확인).
2. **jekyll-seo-tag가 무용지물** — 플러그인은 설치·설정(social, lang, locale)됐지만 `{% seo %}` 태그가 어떤 레이아웃에도 없음 → JSON-LD 구조화 데이터 등 플러그인 출력물이 전무 ✔.
3. **모든 페이지가 동일한 description** — head.html이 페이지별 description(테마 기본 동작)을 버리고 항상 `site.description`을 출력. `index.md` front matter의 `description`/`keywords`는 무시됨 ✔.
4. **서브페이지 `<title>`에 사이트명 없음** — `<title>Research</title>`, `<title>CV</title>` ✔. `title-on-all-pages: false` 때문이며, `title-separator: " | "` 설정은 테마가 사용하지 않는 죽은 키.
5. **테마 데모 페이지가 색인 대상** — `/aboutme.html`(Inigo Montoya 데모)과 `/tags.html`(빈 페이지)이 빌드되어 **sitemap.xml에 포함** ✔. 구버전 CV(`CV_JoonYang_2024.pdf`)와 구글 확인 파일(`google145….html`)도 sitemap에 노출 ✔.
6. **og:image·favicon 전무** ✔ — SNS 공유 시 미리보기 이미지 없음, 브라우저 탭 아이콘 없음.
7. index의 og:description에 이모지·전화번호가 그대로 포함됨 ✔ (본문 발췌 방식이라).
8. `_config.yml` 품질 문제: `title`·`author`·`navbar-col`류 키가 **중복 정의**(YAML은 마지막 값 채택), "Navigation" 주석 블록 중복, `paginate: 0`이 빌드마다 deprecation 경고 유발, `exclude`에 존재하지 않는 `_posts/`·`docs/`·`CHANGELOG.md`·`CNAME` 나열.
9. 양호한 항목 ✔: canonical 링크, robots.txt + sitemap, 구글 소유 확인 파일, `lang: en`.

---

## 요약

사이트 뼈대는 upstream master를 충실히 따르고, 커스텀은 (1) `_config.yml` 재작성, (2) page.html 레이아웃, (3) head.html 메타, (4) custom.css + beautifuljekyll.css 직접 수정, (5) index/research/cv 콘텐츠에 집중되어 있다. 가장 시급한 수정은 **meta description의 "Associate → Assistant" 오기**(전 페이지 노출), **모바일 햄버거 아이콘 비가시성**, **테마 데모 aboutme 페이지 공개 상태**이며, 리디자인 시 죽은 코드(custom-styles.css, `.content-section`/`.page-*` 규칙, `name:`/`class:` front matter, `title-separator`, keywords 메타)를 정리하면 유지보수가 크게 단순해진다.
