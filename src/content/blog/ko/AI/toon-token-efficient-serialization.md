---
title: "TOON - LLM을 위한 토큰 효율적인 직렬화 포맷"
description: "JSON 대비 30-60% 토큰 절감을 제공하는 LLM 친화적 직렬화 포맷 TOON의 특징과 활용법"
pubDate: 2025-11-06T01:58:19+09:00
tags: ["TOON", "LLM", "Token-Optimization", "Serialization", "AI"]
categories: ["AI"]
draft: false
---

## TOON이란

TOON(Token-Oriented Object Notation)은 LLM을 위해 설계된 토큰 효율적인 직렬화 포맷. JSON 대비 30-60% 토큰 절감 효과를 제공하면서도 LLM이 정확하게 파싱 가능한 구조 제공

## 왜 TOON인가

**JSON의 문제점**:
- Verbose한 문법 (중괄호, 쉼표, 인용부호)
- 동일한 구조 반복 시 비효율적
- 토큰 비용 증가 (OpenAI GPT-4: $30/1M tokens)

**TOON의 해결책**:
- 최소한의 문법 (들여쓰기 기반)
- 테이블 형식으로 배열 표현
- LLM 친화적 guardrails (명시적 길이와 필드명)

## 주요 특징

### 토큰 효율성

30-60% 토큰 절감 효과:

```
JSON:  850 tokens
TOON:  340 tokens (60% 절감)
```

### LLM Guardrails

명시적 구조 정의로 파싱 정확도 향상:

```toon
users[3]  # 배열 길이 명시
| id | name      | email
| 1  | Alice     | alice@example.com
| 2  | Bob       | bob@example.com
| 3  | Charlie   | charlie@example.com
```

### 최소한의 문법

- 들여쓰기로 계층 구조 표현 (YAML 방식)
- 테이블 형식으로 동일 구조 배열 표현 (CSV 방식)
- 인용부호 불필요 (공백 포함 시에만 필요)

## 벤치마크 결과

**토큰 효율성** (GPT-4 tokenizer):

| 데이터 타입 | JSON | TOON | 절감률 |
|------------|------|------|--------|
| 단순 객체 배열 | 850 | 340 | 60% |
| 중첩 구조 | 1250 | 625 | 50% |
| Tabular 데이터 | 2100 | 840 | 60% |

**파싱 정확도**:

- JSON: 98.5%
- TOON: 96.8%

LLM이 TOON을 정확하게 파싱 가능

## 사용 예제

### 객체 표현

**JSON**:
```json
{
  "name": "John Doe",
  "age": 30,
  "email": "john@example.com",
  "address": {
    "city": "New York",
    "country": "USA"
  }
}
```

**TOON**:
```toon
name: John Doe
age: 30
email: john@example.com
address
  city: New York
  country: USA
```

### 배열 - Primitive

**JSON**:
```json
{
  "tags": ["typescript", "node", "cli"]
}
```

**TOON**:
```toon
tags[3]: typescript, node, cli
```

### 배열 - Tabular

**JSON**:
```json
{
  "users": [
    {"id": 1, "name": "Alice", "role": "admin"},
    {"id": 2, "name": "Bob", "role": "user"},
    {"id": 3, "name": "Charlie", "role": "user"}
  ]
}
```

**TOON**:
```toon
users[3]
| id | name    | role
| 1  | Alice   | admin
| 2  | Bob     | user
| 3  | Charlie | user
```

## 설치 및 사용

### NPM 패키지

```bash
npm install toon-serializer
```

```javascript
import { toTOON, fromTOON } from 'toon-serializer';

const data = {
  users: [
    { id: 1, name: 'Alice' },
    { id: 2, name: 'Bob' }
  ]
};

// JSON → TOON
const toon = toTOON(data);
console.log(toon);

// TOON → JSON
const json = fromTOON(toon);
console.log(json);
```

### CLI

```bash
# JSON → TOON
toon convert input.json -o output.toon

# TOON → JSON
toon convert input.toon -o output.json --reverse

# 토큰 비교
toon compare input.json
```

## 언제 TOON 사용이 유리한가

**TOON 추천 상황**:

1. **Tabular 데이터 전송**
   - 동일한 구조의 객체 배열
   - 데이터베이스 쿼리 결과
   - CSV와 유사한 데이터

2. **LLM 입력 데이터**
   - Prompt에 컨텍스트 포함
   - RAG 시스템의 문서 청크
   - Function calling 파라미터

3. **토큰 비용 절감이 중요한 경우**
   - 대량 API 호출
   - Streaming 응답
   - Fine-tuning 데이터셋

**JSON이 더 나은 상황**:

1. **중첩이 많은 복잡한 구조**
   - 깊은 계층 구조
   - 불규칙한 데이터 형태

2. **기존 인프라와 호환성**
   - JSON 기반 API
   - 표준 라이브러리 사용

3. **사람이 자주 편집하는 데이터**
   - 설정 파일
   - 메타데이터

## JSON vs TOON 실전 비교

### 사용자 목록 (100명)

**JSON**: 8,500 tokens
```json
[
  {"id": 1, "name": "Alice", "email": "alice@example.com", "role": "admin"},
  {"id": 2, "name": "Bob", "email": "bob@example.com", "role": "user"},
  ...
]
```

**TOON**: 3,400 tokens (60% 절감)
```toon
users[100]
| id  | name    | email                | role
| 1   | Alice   | alice@example.com    | admin
| 2   | Bob     | bob@example.com      | user
...
```

**비용 절감** (GPT-4 기준):
- JSON: $0.255 (8,500 tokens × $30/1M)
- TOON: $0.102 (3,400 tokens × $30/1M)
- 절감액: $0.153 per request (60%)

월 100만 요청 시: **$153,000 절감**

## 한계점 및 고려사항

**제한사항**:

1. **생태계 성숙도**
   - 신규 포맷으로 도구 부족
   - 커뮤니티 지원 제한적

2. **LLM 의존성**
   - LLM이 TOON 파싱 능력 필요
   - 파싱 오류 가능성 (약 3%)

3. **복잡한 구조 처리**
   - 깊은 중첩 구조는 JSON이 더 명확
   - 불규칙한 데이터는 효율 감소

**Best Practices**:

1. **점진적 도입**
   - 병목 구간부터 적용
   - JSON 백업 유지

2. **검증 강화**
   - 파싱 후 스키마 검증
   - 오류 처리 로직 필수

3. **문서화**
   - TOON 스키마 명시
   - 변환 예제 제공

## 실전 활용 시나리오

### RAG 시스템 최적화

```python
# Before (JSON)
context = json.dumps(documents)  # 15,000 tokens

# After (TOON)
context = to_toon(documents)     # 6,000 tokens
# → 60% 토큰 절감, 더 많은 문서 포함 가능
```

### Function Calling

```javascript
// Before (JSON)
const params = {
  users: [...],  // 1,200 tokens
};

// After (TOON)
const params = toTOON({
  users: [...],  // 480 tokens
});
// → 더 많은 파라미터 전달 가능
```

### Streaming 응답 최적화

```typescript
// TOON으로 스트리밍 시 대역폭 절감
stream.pipe(toonSerializer).pipe(response);
```

## 결론

TOON은 LLM 시대에 최적화된 직렬화 포맷. 토큰 효율성이 중요한 상황에서 JSON 대비 30-60% 비용 절감 가능

**핵심 장점**:
- 토큰 효율성 (30-60% 절감)
- LLM 친화적 구조
- 최소한의 문법

**적용 권장**:
- Tabular 데이터
- LLM 입력 컨텍스트
- 토큰 비용 최적화 필요 시

**신중한 접근 필요**:
- 생태계 성숙도 고려
- 검증 로직 필수
- 점진적 도입 권장

## 참고 링크

- [TOON GitHub Repository](https://github.com/anthropics/toon)
- [TOON Specification](https://github.com/anthropics/toon/blob/main/SPEC.md)
- [Token Efficiency Benchmark](https://github.com/anthropics/toon/blob/main/BENCHMARK.md)
- [NPM Package](https://www.npmjs.com/package/toon-serializer)
