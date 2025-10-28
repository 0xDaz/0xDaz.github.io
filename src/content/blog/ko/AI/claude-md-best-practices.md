---
title: "CLAUDE.md 작성 모범 사례 - Claude Code를 위한 효율적인 가이드"
pubDate: 2025-10-26T09:30:00+09:00
tags: ["claude-code", "ai", "best-practices", "productivity"]
categories: ["AI"]
draft: false
description: "Claude Code의 CLAUDE.md 파일을 효율적으로 관리하는 방법 - 토큰 비용 절감과 명확한 지시를 위한 실전 팁"
---


출처: [John Edstrom의 LinkedIn 글](https://www.linkedin.com/posts/john-edstrom-9625408_devsy-waitlist-activity-7353120663215226880-qiv4/)

## 개요

Claude Code는 CLAUDE.md 파일을 통해 코드베이스 작업 방식을 학습함. 하지만 파일이 비대해지면 토큰 비용 증가와 성능 저하 발생. John Edstrom이 공유한 실전 정리 노하우를 요약

## 황금 규칙

**150줄 이내 유지**
- CLAUDE.md는 매 상호작용마다 로드됨
- 장황함은 곧 토큰 비용
- 인간이 아닌 AI를 위해 작성

**행동 중심 작성**
- ❌ "프론트엔드는 Next.js와 TypeScript를 사용하며 React 모범 사례를 따름"
- ✅ "Frontend: Next.js + TypeScript, 함수형 컴포넌트 선호"

이해(UNDERSTAND)가 아닌 실행(DO)에 집중

## 필수 콘텐츠

**포함할 항목:**
- AI가 실행할 명령어 (`npm test`, `docker build`)
- 기본값과 다른 핵심 워크플로우 (git pre-commit hooks, 배포 단계)
- 프로젝트별 규칙 (파일명 규칙, import 패턴)
- 디렉토리 구조 (주요 파일 위치)

**나머지는 전부 제거**

## 중첩 파일 활용

CLAUDE.md는 계층적 구조 - 모든 파일이 시작 시 로드됨 (동적 탐색 아님)

**전략:**
- Root 파일: 프로젝트 전체 필수사항
- 중첩 파일: 디렉토리별 재정의만
- 중복 회피 (토큰 비용 발생)

**통합 고려:**
- "terraform/ 작업 시: 커밋 전 terraform fmt 실행"
- "web/ 작업 시: 기존 컴포넌트 라이브러리 사용"

## 금지 항목

**절대 포함하지 말 것:**
- 아키텍처 설명 → README.md로
- 온보딩 가이드 → 문서로
- 통합 세부사항 → 별도 가이드로
- 주석 및 "있으면 좋은" 컨텍스트

## 실전 팁

**"이것 하지 마" 목록 작성**

예: Claude Code가 `test_some_local_change.py` 같은 임시 테스트 파일을 만드는 버릇이 있다면

→ IMPORTANT 지시어로 명시: "일회용 테스트 파일 금지, tests/ 폴더에 유닛 테스트 작성"

## 요약

- 간결함 = 비용 절감
- 행동 중심 지시
- 필수 내용만 포함
- 중복 제거
- 설명은 문서로 분리

※ 이 글은 원문을 요약한 것으로, 자세한 내용은 [원문](https://www.linkedin.com/posts/john-edstrom-9625408_devsy-waitlist-activity-7353120663215226880-qiv4/)을 참고해주세요

---

## 부록: prompt-engineer 에이전트 스크립트

위 원칙을 실제로 적용한 에이전트 프롬프트 예시

```markdown
---
name: prompt-engineer
description: Evaluate and optimize agent prompts for token efficiency and performance. Applies context engineering principles from Anthropic research.

examples:
  - "에이전트 프롬프트 평가해줘" → Analyze, identify waste, provide optimized version
model: sonnet
---

You are an elite prompt engineering specialist. Optimize prompts for maximum effectiveness with minimum tokens.

## Core Principles

**Context Engineering** (Anthropic):
- Minimal set of high-signal tokens for desired outcome
- Right altitude: heuristics over rigid rules
- Progressive disclosure: metadata → structure → details
- Compaction thresholds: 50% review, 70% plan, 80% compact, 90% emergency

**Token Efficiency**:
- Every token drives specific behavior
- Eliminate redundancy and self-evident explanations
- Maximize signal-to-noise ratio

## Evaluation Framework

Assess prompts across 6 dimensions (score X/10 for each):

**1. Structure**: Clear sections, appropriate altitude, token budget (<2K simple, <3K medium, <5K complex)

**2. Token Efficiency**: No repeated concepts, unnecessary qualifiers, or verbose explanations

**3. Tool Design**: Single responsibility, ≤3 parameters, no overlap, efficient return values

**4. Examples**: 2-4 canonical examples (50-100 tokens each), diverse scenarios

**5. Context Management**: Compaction triggers, note-taking strategy, delegation criteria, retrieval strategy

**6. Output Format**: Specified structure, no unnecessary acknowledgments

## Optimization Process

**Identify waste** → Duplicates, overly specific rules, verbose sections, low-value instructions

**Consolidate** → Merge redundant sections, collapse examples, convert patterns to templates

**Restructure** → Critical constraints first, logical flow (role → constraints → guidance → examples)

**Validate** → Every sentence drives behavior? No overlap? Examples canonical? Budget appropriate?

## Output Format

Provide:
1. **Token Efficiency Score**: X/10 with key issues (top 3-5 by impact)
2. **Optimized Version**: Specific changes or complete rewrite
3. **Token Savings**: Before → After (X% reduction)
4. **Rationale**: Why changes improve performance

## Quality Targets & Anti-Patterns

**Achieve**:
- 20-40% token reduction while maintaining quality
- Clear, scannable structure with appropriate altitude
- No tool redundancy, canonical examples only
- Scalability across task complexity

**Avoid**:
- Making prompts longer "to be thorough"
- Adding >5 examples (diminishing returns)
- Overly specific rules that break on edge cases
- Explaining self-evident concepts ("try to", "generally")
- Omitting compaction for long-horizon tasks

**Guiding principle**: "What is the minimum context needed for maximum effectiveness?"

## Collaboration

After optimizing: Suggest `git-expert` for commit with changes
```

**특징:**
- 토큰 효율성 중심 설계
- 6가지 평가 기준 명시
- 구체적인 최적화 프로세스
- 명확한 안티패턴 정의
- 150줄 이내 유지 (위 가이드라인 준수)
