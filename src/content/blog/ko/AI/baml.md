---
title: "BAML - AI 프롬프트를 타입 안전한 함수로"
pubDate: 2025-10-25T01:30:00+09:00
tags: ["AI", "LLM", "BAML", "Tool", "Prompt Engineering"]
categories: ["AI"]
keywords: ["BAML", "Type-Safe Prompts", "Prompt Engineering", "AI LLM", "Claude Code", "Type Safety", "Function-based Prompts", "AI Development", "Python", "TypeScript"]
draft: false
---


## 개요

**BAML**(Basically a Made-up Language)은 신뢰할 수 있는 AI 워크플로우를 구축하기 위한 프롬프팅 언어

핵심 원칙: LLM 프롬프트를 타입이 있는 입력과 출력을 가진 함수로 취급

## 기존 방식의 문제점

대부분의 개발자는 f-string으로 프롬프트 작성

```python
# 문제가 많은 방식
prompt = f"Analyze this text: {user_input}"
response = llm.generate(prompt)
```

**주요 문제:**

1. **타입 안전성 없음** - 런타임 전까지 오류 발견 불가
2. **유지보수 어려움** - 프롬프트가 코드에 섞여 있음
3. **테스트 곤란** - 전체 앱 실행 없이 프롬프트만 테스트 불가
4. **재사용 불가** - 언어 간 공유 불가능
5. **버전 관리 어려움** - 변경 이력 추적 복잡

## BAML의 해결책

### 타입 안전성

```baml
class Sentiment {
  emotion string
  confidence float
}

function AnalyzeText(text: string) -> Sentiment {
  client GPT4
  prompt #"
    Analyze the sentiment of: {{ text }}
    Return emotion and confidence score.
  "#
}
```

IDE 자동완성과 컴파일 타임 타입 체크 제공

### 분리된 구조

프롬프트를 별도 `.baml` 파일로 관리

코드와 프롬프트 분리로 가독성과 유지보수성 향상

### 즉시 테스트

VSCode 플레이그라운드에서 앱 실행 없이 프롬프트 테스트 가능

변경사항 즉시 확인 및 반복 작업 속도 향상

### 다중 언어 지원

Python, TypeScript, Ruby, Go에서 동일한 BAML 파일 사용

```python
# Python
from baml_client import b

result = b.AnalyzeText("I love this!")
print(result.emotion)
```

```typescript
// TypeScript
import { b } from './baml_client'

const result = await b.AnalyzeText("I love this!")
console.log(result.emotion)
```

### 스트리밍 지원

타입 안전한 부분 업데이트 스트리밍

```python
async for partial in b.stream.AnalyzeText("Long text..."):
    if partial.emotion:
        print(f"Current emotion: {partial.emotion}")
```

### 쉬운 모델 전환

한 줄로 LLM 모델 변경 가능

```baml
function AnalyzeText(text: string) -> Sentiment {
  client Claude  // GPT4에서 Claude로 변경
  prompt #"..."#
}
```

## Unity 게임 개발 활용 사례

### NPC 대화 생성

```baml
class NPCDialogue {
  text string
  emotion string
  action string?
}

function GenerateNPCResponse(
  context: string,
  player_action: string
) -> NPCDialogue {
  client GPT4
  prompt #"
    NPC context: {{ context }}
    Player did: {{ player_action }}
    Generate appropriate response with emotion and optional action.
  "#
}
```

### 동적 퀘스트 생성

플레이어 레벨과 진행도에 맞는 퀘스트 자동 생성

타입 안전성으로 게임 로직과 안전하게 통합

### 플레이어 행동 분석

플레이어 패턴 분석하여 난이도 조정 및 개인화 경험 제공

### 게임 밸런스 제안

게임 데이터 분석하여 밸런스 개선 제안 생성

## 개발 도구 활용 사례

### 코드 리뷰 자동화

```baml
class CodeReview {
  issues string[]
  suggestions string[]
  severity string
}

function ReviewCode(code: string) -> CodeReview {
  client GPT4
  prompt #"
    Review this code and provide:
    - List of issues
    - Improvement suggestions
    - Overall severity (low/medium/high)

    Code: {{ code }}
  "#
}
```

### 문서 생성

코드로부터 자동으로 문서 생성

타입 안전성으로 일관된 형식 보장

### 버그 분석

에러 로그와 스택 트레이스 분석하여 원인 파악 및 해결 방안 제시

## 주요 장점 정리

- **완전한 타입 안전성** - IDE 자동완성과 컴파일 타임 체크
- **분리된 파일 구조** - `.baml` 파일로 깔끔한 조직화
- **즉시 테스트** - VSCode 플레이그라운드
- **다중 언어 지원** - Python, TypeScript, Ruby, Go
- **타입 안전 스트리밍** - 부분 업데이트 지원
- **간편한 모델 전환** - 한 줄로 LLM 변경
- **오픈 소스** - Apache 2.0 라이선스

## 참고 링크

- [BAML 공식 사이트](https://www.boundaryml.com/)
- [BAML GitHub](https://github.com/BoundaryML/baml)
- [BAML 문서](https://docs.boundaryml.com/)
