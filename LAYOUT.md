# LAYOUT.md - Hugo 블로그 구조 가이드

이 파일은 Hugo PaperMod 테마 기반 블로그의 구조와 커스터마이징 방법을 설명

## 프로젝트 정보

- **타입**: Hugo 정적 사이트 생성기
- **테마**: PaperMod (Git submodule)
- **배포**: GitHub Pages (GitHub Actions 자동 배포)
- **URL**: https://0xDaz.github.io
- **Hugo 버전 요구사항**: >= 0.146.0

---

## 디렉토리 구조

```
C:\Dev\0xD.github.io\
├── .github/
│   └── workflows/
│       └── hugo.yml              # GitHub Actions 워크플로우 (자동 배포)
│
├── archetypes/                   # 콘텐츠 템플릿 (hugo new content 시 사용)
│   ├── default.md                # 기본 템플릿
│   └── post.md                   # 포스트 템플릿 (사용자 정의)
│
├── assets/                       # 빌드 시 처리되는 리소스
│   └── css/
│       └── extended/
│           └── custom.css        # **사용자 정의 CSS** (테마 오버라이드)
│
├── content/                      # 모든 콘텐츠 파일 (.md)
│   ├── AI/                       # AI 관련 포스트
│   │   ├── _index.md             # 카테고리 인덱스 페이지
│   │   ├── agentic-rag.md
│   │   ├── baml.md
│   │   └── Claude/               # 하위 카테고리
│   │       ├── agent-skills.md
│   │       ├── context7-mcp.md
│   │       ├── github-mcp-server.md
│   │       ├── playwright-mcp.md
│   │       └── taskmaster-ai.md
│   │
│   └── Env/                      # 환경 설정 관련 포스트
│       ├── _index.md
│       └── everythingtoolbar.md
│
├── layouts/                      # **사용자 정의 레이아웃** (테마 오버라이드)
│   └── partials/
│       └── home_info.html        # 홈페이지 프로필 영역 커스터마이징
│
├── static/                       # 정적 파일 (빌드 시 그대로 복사)
│   ├── images/                   # 이미지 파일
│   │   ├── everythingtoolbar.gif
│   │   └── og-image.png          # Open Graph 이미지
│   ├── robots.txt                # 검색 엔진 크롤러 설정
│   └── googledef2b6219595c813.html  # Google Search Console 인증
│
├── themes/                       # Hugo 테마 디렉토리
│   └── PaperMod/                 # PaperMod 테마 (Git submodule)
│       ├── layouts/              # 테마 기본 레이아웃
│       │   ├── _default/
│       │   │   ├── baseof.html   # 기본 HTML 템플릿
│       │   │   ├── list.html     # 리스트 페이지 (홈, 카테고리, 태그)
│       │   │   └── single.html   # 단일 포스트 페이지
│       │   └── partials/
│       │       ├── home_info.html     # 홈 프로필 영역 (오버라이드됨)
│       │       ├── social_icons.html  # 소셜 아이콘
│       │       ├── header.html        # 헤더
│       │       └── footer.html        # 푸터
│       ├── assets/
│       │   └── css/              # 테마 기본 CSS
│       └── i18n/                 # 다국어 지원 파일
│
├── hugo.toml                     # **Hugo 메인 설정 파일**
├── CLAUDE.md                     # Claude Code 블로그 작성 스타일 가이드
├── LAYOUT.md                     # 이 파일 - 블로그 구조 가이드
└── README.md                     # 프로젝트 README

```

---

## Hugo 템플릿 우선순위 (Lookup Order)

Hugo는 파일을 다음 순서로 찾음:

1. **프로젝트 루트** (`layouts/`)
2. **테마 디렉토리** (`themes/PaperMod/layouts/`)

**예시**: `home_info.html` 파일 탐색 순서
```
1. layouts/partials/home_info.html          ← 우선 (현재 사용 중)
2. themes/PaperMod/layouts/partials/home_info.html  ← 테마 기본값
```

**중요**: 테마 파일을 직접 수정하지 말 것. 항상 프로젝트 루트에 동일한 경로로 파일을 생성하여 오버라이드

---

## 페이지 렌더링 흐름

### 1. 홈페이지 (`/`)

```
baseof.html (기본 HTML 구조)
    ↓
header.html (네비게이션, 다크모드 토글)
    ↓
list.html (메인 콘텐츠 영역)
    ├─ home_info.html (프로필 정보) ← 커스터마이징됨
    │   └─ social_icons.html (GitHub 버튼)
    └─ 포스트 리스트 (post-entry)
    ↓
footer.html (푸터)
```

**렌더링 조건** (`list.html:50-52`):
```go
{{- if and .IsHome site.Params.homeInfoParams (eq $paginator.PageNumber 1) }}
{{- partial "home_info.html" . }}
{{- end }}
```
- `.IsHome`: 홈페이지일 때만
- `site.Params.homeInfoParams`: 설정이 있을 때만
- `$paginator.PageNumber 1`: 첫 페이지일 때만

### 2. 포스트 페이지 (`/posts/example/`)

```
baseof.html
    ↓
header.html
    ↓
single.html
    ├─ breadcrumbs.html
    ├─ post_meta.html (날짜, 읽기 시간, 태그)
    ├─ toc.html (목차)
    ├─ 본문 콘텐츠
    └─ share_icons.html (공유 버튼 - 현재 비활성화)
    ↓
footer.html
```

### 3. 카테고리/태그 페이지 (`/categories/ai/`)

```
baseof.html
    ↓
header.html
    ↓
list.html (home_info 없음, 포스트 리스트만)
    ↓
footer.html
```

---

## 현재 적용된 커스터마이징

### 1. 홈페이지 프로필 레이아웃 (`layouts/partials/home_info.html`)

**목적**: 프로필 정보와 GitHub 버튼을 타이틀 옆에 배치

**원본 구조** (테마 기본):
```html
<article class="first-entry home-info">
    <header class="entry-header">
        <h1>{{ .Title }}</h1>
    </header>
    <div class="entry-content">
        {{ .Content }}
    </div>
    <footer class="entry-footer">
        {{ partial "social_icons.html" }}  ← 푸터에 위치
    </footer>
</article>
```

**커스터마이징된 구조**:
```html
<article class="first-entry home-info">
    <header class="entry-header">
        <div class="home-title-container">  ← Flexbox 컨테이너 추가
            <h1>{{ .Title }}</h1>
            <div class="home-social-icons">
                {{ partial "social_icons.html" (dict "align" "right") }}  ← 타이틀 옆에 배치
            </div>
        </div>
    </header>
    <div class="entry-content">
        {{ .Content }}
    </div>
</article>
```

**변경 사항**:
- `home-title-container` div 추가: 타이틀과 소셜 아이콘을 가로로 배치
- 소셜 아이콘을 `footer`에서 `header` 안으로 이동
- `footer` 섹션 제거 (중복 방지)

### 2. 홈페이지 레이아웃 스타일 (`assets/css/extended/custom.css`)

**목적**: GitHub 버튼을 타이틀 baseline에 정렬하고 프로필-포스트 간격 최소화

```css
/* 타이틀과 소셜 아이콘 컨테이너 */
.home-title-container {
    display: flex;
    align-items: baseline;          /* 텍스트 baseline 정렬 (center → baseline) */
    justify-content: flex-start;    /* 좌측 정렬 (space-between → flex-start) */
    gap: 0.5rem;                    /* 타이틀과 버튼 사이 간격 */
}

/* 타이틀 자체 스타일 */
.home-title-container h1 {
    margin: 0;
    flex: 0 1 auto;                 /* 자동 크기 조절 */
}

/* 소셜 아이콘 래퍼 */
.home-social-icons {
    display: flex;
    align-items: center;
    flex: 0 0 auto;                 /* 고정 크기 */
}

/* 소셜 아이콘 내부 컨테이너 */
.home-social-icons .social-icons {
    margin: 0;
    display: flex;
    align-items: center;
}

/* 소셜 아이콘 링크 */
.home-social-icons .social-icons a {
    padding: 0;
    display: flex;
    align-items: center;
}

/* 아이콘 SVG 크기 */
.home-social-icons .social-icons a svg {
    width: 20px;
    height: 20px;
}

/* 프로필과 포스트 리스트 간격 최소화 */
.home-info {
    margin-bottom: 0.25rem !important;  /* 1rem → 0.25rem */
}

.home-info .entry-content {
    margin-bottom: 0;
}

.home-info .entry-header {
    margin-bottom: 0.5rem;
}

/* 모바일 대응 */
@media screen and (max-width: 768px) {
    .home-title-container {
        flex-direction: column;     /* 세로 배치 */
        align-items: flex-start;
        gap: 0.5rem;
    }

    .home-social-icons {
        align-self: flex-start;
    }
}
```

**핵심 변경 사항**:
1. **버튼 위치**: `justify-content: space-between` → `flex-start` (타이틀 바로 옆으로 이동)
2. **버튼 정렬**: `align-items: center` → `baseline` (텍스트 baseline에 맞춤)
3. **간격 최소화**: `margin-bottom: 1rem` → `0.25rem` (프로필-포스트 간격 축소)

### 3. Hugo 설정 (`hugo.toml`)

#### **프로필 정보 설정**

```toml
[params.homeInfoParams]
  Title = "0xDaz"
  Content = "📍 Seoul · 💼 Programmer · 📧 [esnetni2@gmail.com](mailto:esnetni2@gmail.com)"
```

- 홈페이지에 표시되는 프로필 정보
- Markdown 형식 지원 (이메일 링크 등)

#### **프로필 모드 비활성화**

```toml
[params.profileMode]
  enabled = false  # false: 포스트 리스트 표시, true: 프로필만 표시
```

**중요**:
- `profileMode.enabled = true`: 프로필만 표시, 포스트 숨김
- `profileMode.enabled = false`: 프로필 + 포스트 리스트 동시 표시 (현재 설정)

#### **소셜 아이콘 설정**

```toml
[[params.socialIcons]]
  name = "github"
  url = "https://github.com/0xDaz"
```

- Email 버튼 제거됨 (이전에 존재했으나 삭제)
- GitHub 버튼만 유지

#### **공유 버튼 비활성화**

```toml
showShareButtons = false  # X/Twitter, Telegram 등 공유 버튼 숨김
```

#### **메인 섹션 설정**

```toml
mainSections = ["ai", "env"]  # 홈페이지에 표시할 콘텐츠 섹션
```

---

## 테마 오버라이드 메커니즘

### CSS 오버라이드

1. **테마 기본 CSS**: `themes/PaperMod/assets/css/`
2. **확장 CSS**: `assets/css/extended/` ← **여기에 커스텀 CSS 작성**

PaperMod은 자동으로 `extended/` 디렉토리의 CSS를 로드

**중요**: `themes/PaperMod/assets/css/` 직접 수정 금지

### 레이아웃 오버라이드

1. **테마 기본 레이아웃**: `themes/PaperMod/layouts/`
2. **커스텀 레이아웃**: `layouts/` ← **여기에 동일 경로로 파일 생성**

**예시**:
```
themes/PaperMod/layouts/partials/home_info.html  (원본)
layouts/partials/home_info.html                  (오버라이드)
```

---

## 콘텐츠 작성 가이드

### Front Matter 형식

```yaml
---
title: "포스트 제목"
date: 2025-10-25T01:30:00+09:00  # ISO 8601 형식, 반드시 현재/과거 시간
tags: ["Tag1", "Tag2"]
categories: ["Category"]
draft: false                      # true: 숨김, false: 게시
description: "포스트 설명"         # 선택사항
---
```

**중요**:
- `date`: 미래 시간 사용 금지 (Hugo가 포스트 숨김)
- `draft: false`: 배포 시 반드시 false로 설정

### 이미지 사용

**위치**: `static/images/`

**삽입 방법**:
```markdown
![설명](/images/filename.gif)
```

**경로 규칙**:
- Markdown: `/images/` (static 생략)
- 실제 파일: `static/images/`

### 새 포스트 생성

```bash
hugo new content AI/new-post.md
```

생성된 파일은 `archetypes/post.md` 템플릿 사용

---

## 빌드 및 배포

### 로컬 개발

```bash
# 개발 서버 시작 (draft 포스트 포함)
hugo server -D

# 브라우저: http://localhost:1313
```

### 프로덕션 빌드

```bash
# public/ 디렉토리에 정적 사이트 생성
hugo --minify
```

### GitHub Pages 배포

1. **자동 배포**: `main` 브랜치에 push 시 GitHub Actions 자동 실행
2. **워크플로우**: `.github/workflows/hugo.yml`
3. **빌드 시간**: 1-2분
4. **URL**: https://0xDaz.github.io

**배포 흐름**:
```
git push origin main
    ↓
GitHub Actions 트리거
    ↓
Hugo 빌드 (hugo --minify)
    ↓
gh-pages 브랜치에 배포
    ↓
GitHub Pages 업데이트
```

---

## 에이전트 수정 가이드

### 레이아웃 수정 시

1. **테마 파일 직접 수정 금지**: `themes/PaperMod/` 내부 파일 수정 불가
2. **오버라이드 파일 생성**: `layouts/` 에 동일 경로로 파일 생성
3. **테마 원본 참조**: `themes/PaperMod/layouts/` 파일을 참고하여 수정

**예시**:
```bash
# 헤더 커스터마이징
cp themes/PaperMod/layouts/partials/header.html layouts/partials/header.html
# layouts/partials/header.html 수정
```

### CSS 수정 시

1. **파일 위치**: `assets/css/extended/custom.css`
2. **!important 최소화**: 가능한 한 선택자 우선순위로 해결
3. **모바일 대응**: `@media screen and (max-width: 768px)` 필수 확인

### 설정 수정 시

1. **파일 위치**: `hugo.toml`
2. **TOML 문법**: 들여쓰기 주의 (탭 아닌 스페이스)
3. **배열 형식**: `[[params.socialIcons]]` - 대괄호 2개

### Git 커밋 시

1. **테마 디렉토리 제외**: `themes/PaperMod/` 내부 파일은 커밋하지 않음 (submodule)
2. **커밋 대상**: `layouts/`, `assets/`, `content/`, `hugo.toml` 만 커밋
3. **이미지 최적화**: 큰 이미지는 압축 후 커밋 (< 500KB 권장)

---

## 주요 파일 참조

| 파일 경로 | 역할 | 수정 방법 |
|----------|------|----------|
| `hugo.toml` | 블로그 전역 설정 | 직접 수정 |
| `layouts/partials/home_info.html` | 홈 프로필 영역 | 직접 수정 (오버라이드) |
| `assets/css/extended/custom.css` | 커스텀 스타일 | 직접 수정 |
| `themes/PaperMod/layouts/_default/list.html` | 리스트 페이지 템플릿 | 참고만 (오버라이드 시 `layouts/_default/list.html` 생성) |
| `themes/PaperMod/layouts/partials/social_icons.html` | 소셜 아이콘 템플릿 | 참고만 (오버라이드 시 `layouts/partials/social_icons.html` 생성) |
| `archetypes/post.md` | 새 포스트 템플릿 | 직접 수정 |
| `CLAUDE.md` | 블로그 작성 스타일 가이드 | 포스트 작성 시 참조 |

---

## 트러블슈팅

### 포스트가 보이지 않음

1. `draft: true` 확인 → `false` 로 변경
2. `date` 가 미래 시간인지 확인 → 현재/과거 시간으로 변경
3. `hugo server -D` 로 draft 포함 확인

### CSS 변경이 반영되지 않음

1. 브라우저 캐시 삭제 (Ctrl+Shift+R)
2. Hugo 서버 재시작
3. `assets/css/extended/` 경로 확인

### 테마 수정 사항이 사라짐

1. `themes/PaperMod/` 직접 수정했는지 확인
2. 오버라이드 파일(`layouts/`) 생성 필요

### 레이아웃이 깨짐

1. `home-title-container` 클래스 존재 확인
2. `custom.css` 로드 확인
3. 브라우저 개발자 도구로 CSS 적용 상태 확인

---

## 참고 자료

- **Hugo 공식 문서**: https://gohugo.io/documentation/
- **PaperMod 테마 위키**: https://github.com/adityatelange/hugo-PaperMod/wiki
- **PaperMod 설정 예시**: https://github.com/adityatelange/hugo-PaperMod/wiki/Installation
- **Hugo 템플릿 문법**: https://gohugo.io/templates/introduction/
- **Hugo Lookup Order**: https://gohugo.io/templates/lookup-order/

---

## 변경 이력

| 날짜 | 변경 사항 | 파일 |
|------|----------|------|
| 2025-10-25 | GitHub 버튼 baseline 정렬, 간격 최소화 | `custom.css` |
| 2025-10-25 | 홈 프로필 레이아웃 커스터마이징 | `home_info.html` |
| 2025-10-25 | 프로필 정보 추가, SNS 버튼 제거 | `hugo.toml` |
