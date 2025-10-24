# 0xD Blog

Hugo로 만든 개인 블로그입니다.

## 개발 환경 설정

### 로컬에서 실행하기

```bash
# 개발 서버 시작 (drafts 포함)
hugo server -D

# 브라우저에서 http://localhost:1313 접속
```

### 새 포스트 작성하기

```bash
# posts 디렉토리에 새 포스트 생성
hugo new content posts/post-title.md

# 생성된 파일을 편집하고 draft: true를 false로 변경
```

### 빌드하기

```bash
# 정적 사이트 빌드 (public/ 디렉토리에 생성됨)
hugo

# minify 옵션과 함께 빌드
hugo --minify
```

## 배포

GitHub에 push하면 GitHub Actions가 자동으로 빌드하고 GitHub Pages에 배포합니다.

### GitHub Pages 설정

1. GitHub 저장소 Settings > Pages로 이동
2. Source를 "GitHub Actions"로 선택
3. main 브랜치에 push하면 자동 배포

## 테마

이 블로그는 [PaperMod](https://github.com/adityatelange/hugo-PaperMod) 테마를 사용합니다.

## 디렉토리 구조

```
.
├── .github/
│   └── workflows/
│       └── hugo.yml        # GitHub Actions 워크플로우
├── archetypes/             # 콘텐츠 템플릿
├── content/                # 블로그 포스트 및 페이지
│   └── posts/              # 블로그 포스트
├── static/                 # 정적 파일 (이미지, CSS 등)
├── themes/                 # Hugo 테마
│   └── PaperMod/           # PaperMod 테마 (git submodule)
├── hugo.toml               # Hugo 설정 파일
└── README.md               # 이 파일
```

## 설정 파일

주요 설정은 `hugo.toml` 파일에서 관리합니다:

- `baseURL`: 블로그 URL
- `title`: 블로그 제목
- `params`: 테마 관련 설정

## 참고 자료

- [Hugo 문서](https://gohugo.io/documentation/)
- [PaperMod 테마 문서](https://github.com/adityatelange/hugo-PaperMod/wiki)
- [Hugo GitHub Actions](https://gohugo.io/hosting-and-deployment/hosting-on-github/)
