# 0xDaz.github.io - Astro Version

Hugo 블로그를 Astro로 전환한 버전입니다.

## 프로젝트 정보

- **프레임워크**: Astro 5.15
- **타입스크립트**: Strict 모드
- **배포**: GitHub Pages
- **원본**: Hugo + PaperMod 테마

## 마이그레이션 완료 항목

- ✅ 15개 블로그 포스트 마이그레이션 (DNDLITE 관련 콘텐츠 제외)
- ✅ 이미지 및 정적 파일 복사
- ✅ 카테고리/태그 시스템 설정
- ✅ RSS 피드 생성
- ✅ Sitemap 생성
- ✅ GitHub Actions 배포 설정

## 제외된 콘텐츠

- `prd-by-agent.md` (DNDLITE PRD 문서)
- `_index.md` 파일들 (카테고리 인덱스)

## 🚀 Project Structure

Inside of your Astro project, you'll see the following folders and files:

```text
├── public/
├── src/
│   ├── components/
│   ├── content/
│   ├── layouts/
│   └── pages/
├── astro.config.mjs
├── README.md
├── package.json
└── tsconfig.json
```

Astro looks for `.astro` or `.md` files in the `src/pages/` directory. Each page is exposed as a route based on its file name.

There's nothing special about `src/components/`, but that's where we like to put any Astro/React/Vue/Svelte/Preact components.

The `src/content/` directory contains "collections" of related Markdown and MDX documents. Use `getCollection()` to retrieve posts from `src/content/blog/`, and type-check your frontmatter using an optional schema. See [Astro's Content Collections docs](https://docs.astro.build/en/guides/content-collections/) to learn more.

Any static assets, like images, can be placed in the `public/` directory.

## 🧞 Commands

All commands are run from the root of the project, from a terminal:

| Command                   | Action                                           |
| :------------------------ | :----------------------------------------------- |
| `npm install`             | Installs dependencies                            |
| `npm run dev`             | Starts local dev server at `localhost:4321`      |
| `npm run build`           | Build your production site to `./dist/`          |
| `npm run preview`         | Preview your build locally, before deploying     |
| `npm run astro ...`       | Run CLI commands like `astro add`, `astro check` |
| `npm run astro -- --help` | Get help using the Astro CLI                     |

## 배포

`astro-migration` 브랜치에 푸시하면 GitHub Actions가 자동으로 빌드 및 배포합니다.

## 기술 스택

- **Astro**: 5.15.1
- **MDX**: 4.3.8
- **RSS**: 4.0.13
- **Sitemap**: 3.6.0
- **Sharp**: 0.34.3 (이미지 최적화)

## 참고 링크

- [Astro 공식 문서](https://docs.astro.build)
- [원본 Hugo 블로그](https://github.com/0xDaz/0xD.github.io)
