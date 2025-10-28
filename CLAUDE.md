# CLAUDE.md - 블로그 작성 가이드

이 파일은 Claude Code가 블로그 포스트를 작성할 때 참고하는 스타일 가이드입니다.

## 프로젝트 정보

**프로젝트명**: 0xDaz.github.io
**타입**: Hugo 정적 블로그
**테마**: PaperMod
**주제**: GameDevLog (게임 개발 로그)

**중요**: 블로그 구조 및 커스터마이징 정보는 `LAYOUT.md` 참조

## 블로그 포스트 작성 스타일

### 말투 및 문체

**간결하고 직설적 표현:**
- ❌ "-이다/-해야 한다/-할 수 있다" → ✅ 체언 종결, "-음/-필요/-가능"
- 마침표(.) 생략

**예시:**
```markdown
❌ Windows에는 대안이 없었다 → ✅ Windows에는 대안이 없었음
❌ 먼저 설치해야 한다 → ✅ 먼저 설치 필요
❌ 사용할 수 있다 → ✅ 사용 가능
```

### Front Matter 형식

```yaml
---
title: "포스트 제목"
date: YYYY-MM-DDTHH:MM:SS+09:00
tags: ["Tag1", "Tag2", "Tag3"]
categories: ["Category"]
draft: false
---
```

**날짜/시간 작성 규칙:**
- 형식: `YYYY-MM-DDTHH:MM:SS+09:00` (ISO 8601)
- **반드시 현재 시간 또는 과거 시간 사용**
- 미래 시간 사용 시 Hugo에서 포스트가 표시되지 않음
- 예시: `2025-10-25T01:30:00+09:00`

**태그 작성 원칙:**
- 관련된 툴/기술명을 구체적으로 포함
- 일반적인 카테고리(Windows, Tool 등)와 구체적인 이름(Raycast, EverythingToolbar 등) 모두 포함

### 포스트 구조

```markdown
## 개요
간단한 설명 (2-3문장)

[이미지가 있다면 여기 배치]

## 특징
- 핵심 기능 나열

## 설치 방법 / 사용법
단계별로 명확하게

## 참고 링크
- 공식 사이트
- GitHub 등
```

### 이미지 사용

**경로**: `/images/파일명.확장자`

**위치**: static/images/ 디렉토리

**삽입 형식**:
```markdown
![설명](/images/filename.gif)
```

## 구조

`content/Env/` - 개발 환경 설정 | `content/posts/` - 일반 포스트

## 명령어

로컬 서버: `hugo server -D`
새 포스트: `hugo new content [경로]/[파일명].md`
빌드: `hugo --minify`

## Git & 배포

1. 작성 → 2. 테스트 (`hugo server -D`) → 3. 커밋/푸시 → 4. GitHub Actions 자동 배포

**주의:**
- draft: false (배포 필수)
- 이미지: static/images/
- 파일명: 소문자-하이픈 (예: everythingtoolbar.md)
