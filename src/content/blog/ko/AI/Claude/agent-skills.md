---
title: "Claude Skills"
pubDate: 2025-10-24T15:00:00+09:00
tags: ["Claude", "AI", "Skills", "Claude Code", "Anthropic", "Office", "PDF", "Excel", "Word", "PowerPoint"]
categories: ["AI"]
keywords: ["Claude Skills", "Claude Code", "AI Skills", "Anthropic", "Office Tools", "PDF Processing", "Excel", "Word", "PowerPoint", "AI Assistant"]
draft: false
---


## 개요

Claude Skills는 쉽게 말해 agent에게 사용할 도구를 제공하는 기능

자연어로 생성 가능하고 Python 스크립트 코드도 지원하기 때문에 사실상 활용도가 무궁무진함

Description만 적어놓고 Just-In-Time 방식으로 불러오기 때문에 컨텍스트 및 토큰 절약에도 유리

### Skills의 특징

- **Composable**: 여러 스킬을 함께 사용 가능
- **Portable**: 모든 Claude 제품에서 동일한 형식 사용
- **Efficient**: 필요한 것만 로드
- **Powerful**: 실행 가능한 코드 포함 가능

### 사용 가능한 곳

- Claude Desktop (Pro, Max, Team, Enterprise)
- Claude Code
- Claude API (Messages API, /v1/skills endpoint)

### skill-creator 스킬

공식 마켓플레이스에서 제공하는 플러그인을 설치하면 skill-creator 스킬이 제공됨

자연어 기반으로 Claude Code 스킬 양식에 맞는 스킬을 생성 가능해서 굉장히 유용

Claude한테 직접 만들어 달라고 하면 이상한 디렉토리에 만드는 경우가 많음

### 마켓 플레이스 추가 방법

```bash
/plugin marketplace add anthropics/skills
```

### 문서 관련 스킬

MS 문서 파싱은 생각보다 어렵고 번거로운 편인데, 공식 문서 관련 스킬들이 꽤 유용함
- **docx**: Word 문서 생성, 편집, 분석 (변경 추적, 주석, 서식 보존, 텍스트 추출)
- **pdf**: PDF 조작 (텍스트/테이블 추출, PDF 생성, 병합/분할, 양식 처리)
- **pptx**: PowerPoint 프레젠테이션 생성, 편집, 분석 (레이아웃, 템플릿, 차트, 슬라이드 자동 생성)
- **xlsx**: Excel 스프레드시트 생성, 편집, 분석 (수식, 서식, 데이터 분석, 시각화)

### 비공식 CLI

- [claude-skills-cli](https://github.com/spences10/claude-skills-cli)

## 참고 링크

- [Introducing Agent Skills - Anthropic](https://www.anthropic.com/news/skills)
- [Claude Skills Documentation](https://docs.anthropic.com)
- [claude-skills-cli GitHub](https://github.com/spences10/claude-skills-cli)
