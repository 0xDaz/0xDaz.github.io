# 0xDaz.github.io

개인 개발 블로그

## 프로젝트 정보

- **프레임워크**: Astro 5.15
- **타입스크립트**: Strict 모드
- **배포**: GitHub Pages

## 🚀 Project Structure

```text
├── public/
│   ├── images/          # 블로그 이미지
│   └── fonts/           # 웹 폰트
├── src/
│   ├── components/      # Astro 컴포넌트
│   ├── content/
│   │   └── blog/        # 블로그 포스트 (Markdown)
│   ├── layouts/         # 페이지 레이아웃
│   ├── pages/           # 라우팅
│   └── styles/          # 글로벌 스타일
├── astro.config.mjs
├── package.json
└── tsconfig.json
```

## 📝 콘텐츠

블로그 포스트는 `src/content/blog/` 디렉토리에 카테고리별로 정리되어 있습니다:
- `AI/` - AI 개발 관련 포스트
- `GameDev/` - 게임 개발 포스트
- `Env/` - 개발 환경 설정

## 🧞 Commands

| Command                   | Action                                           |
| :------------------------ | :----------------------------------------------- |
| `npm install`             | Installs dependencies                            |
| `npm run dev`             | Starts local dev server at `localhost:4321`      |
| `npm run build`           | Build your production site to `./dist/`          |
| `npm run preview`         | Preview your build locally, before deploying     |
| `npm run astro ...`       | Run CLI commands like `astro add`, `astro check` |
| `npm run astro -- --help` | Get help using the Astro CLI                     |

## 배포

`main` 브랜치에 푸시하면 GitHub Actions가 자동으로 빌드 및 배포합니다.

## 기술 스택

- **Astro**: 5.15.1
- **MDX**: 4.3.8
- **RSS**: 4.0.13
- **Sitemap**: 3.6.0
- **Sharp**: 0.34.3 (이미지 최적화)

## 참고 링크

- [Astro 공식 문서](https://docs.astro.build)
- [Content Collections](https://docs.astro.build/en/guides/content-collections/)
