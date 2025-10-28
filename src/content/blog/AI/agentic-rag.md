---
title: "Agentic RAG란 무엇인가"
pubDate: 2025-10-25T14:30:00+09:00
tags: ["AI", "RAG", "Agentic RAG", "BAML", "LLM"]
categories: ["AI"]
draft: false
description: "전통적 RAG와 Agentic RAG의 차이점과 자율적 의사결정의 핵심"
---

## RAG 기본 개념

RAG(Retrieval-Augmented Generation)는 LLM의 답변에 외부 지식을 결합하는 기술

기본 동작:
1. 사용자 질문 입력
2. 관련 문서 검색
3. 검색된 문서 + 질문을 LLM에 전달
4. LLM이 답변 생성

한계: 항상 동일한 검색 방식 사용, 상황에 따른 최적화 불가

## 전통적 RAG vs Agentic RAG

### 전통적 RAG

```
질문 → 벡터 검색 → 문서 → LLM → 답변
```

특징:
- 고정된 파이프라인
- 항상 벡터 검색 실행
- 단순하고 빠름
- 예측 가능한 동작

문제점:
- 모든 질문에 검색이 필요한가?
- 벡터 검색만으로 충분한가?
- 여러 소스가 필요할 때는?

### Agentic RAG

```
질문 → AI Agent → 도구 선택 (벡터 검색 / SQL / API / 검색 생략) → 답변
```

특징:
- 동적 파이프라인
- AI가 상황별 도구 선택
- 복잡하지만 유연함
- 최적화된 답변 생성

핵심 차이:
| 항목 | 전통적 RAG | Agentic RAG |
|------|-----------|-------------|
| 검색 여부 | 항상 검색 | 필요시만 검색 |
| 도구 선택 | 고정 (벡터 검색) | 동적 (여러 도구 중 선택) |
| 복잡도 | 낮음 | 높음 |
| 속도 | 빠름 | 상대적으로 느림 |
| 유연성 | 낮음 | 높음 |

## 왜 "Agentic"인가 - 자율적 의사결정

**Agent** = 자율적으로 판단하고 도구를 선택하는 AI

핵심 능력:
1. **상황 판단**: "이 질문은 문서 검색이 필요한가?"
2. **도구 선택**: "벡터 검색? SQL? API 호출?"
3. **체인 실행**: "먼저 A 조회 → 결과로 B 검색"

예시 시나리오:
```
질문: "회사 창립일은 언제야?"
→ Agent: 벡터 검색으로 회사 문서 확인

질문: "2 + 2는?"
→ Agent: 검색 불필요, 직접 답변

질문: "지난달 매출 상위 5개 제품은?"
→ Agent: SQL 쿼리 실행 필요

질문: "서울 날씨 + 우리 매장 위치"
→ Agent: 날씨 API 호출 + 벡터 검색 조합
```

## 실제 동작 예시

### 전통적 RAG
```python
# 모든 질문에 동일한 처리
def traditional_rag(question):
    docs = vector_search(question)  # 항상 실행
    return llm(question + docs)
```

### Agentic RAG
```python
# AI가 도구 선택
def agentic_rag(question):
    # AI가 판단: 어떤 도구가 필요한가?
    tools = agent.select_tools(question)

    results = []
    for tool in tools:
        if tool == "vector_search":
            results.append(vector_search(question))
        elif tool == "sql":
            results.append(sql_query(question))
        elif tool == "api":
            results.append(api_call(question))

    return llm(question + results)
```

## Agentic RAG의 도구들

Agent가 선택 가능한 도구 예시:

**검색 도구**
- `vector_search`: 의미 기반 문서 검색
- `keyword_search`: 키워드 기반 검색
- `hybrid_search`: 벡터 + 키워드 조합

**데이터 도구**
- `sql_query`: 구조화된 데이터 조회
- `graph_query`: 관계형 데이터 탐색
- `nosql_query`: 비구조화 데이터 조회

**외부 도구**
- `web_search`: 실시간 웹 검색
- `api_call`: 외부 API 호출
- `calculator`: 수학 계산

**메타 도구**
- `no_tool`: 도구 불필요, LLM만 사용
- `multi_tool`: 여러 도구 순차/병렬 실행

## 언제 사용해야 할까

### Agentic RAG 사용 권장

✅ 다양한 데이터 소스 (문서 + DB + API)
✅ 복잡한 멀티스텝 질의
✅ 상황별 최적화 필요
✅ 비용보다 정확도 우선

예시:
- 기업 내부 검색: 문서 + HR DB + 프로젝트 관리 시스템
- 금융 분석: 재무제표 + 시장 데이터 API + 뉴스
- 고객 지원: FAQ + 주문 DB + 재고 시스템

### 전통적 RAG 사용 권장

✅ 단일 데이터 소스 (문서만)
✅ 단순한 질의 패턴
✅ 빠른 응답 필요
✅ 정확도보다 속도/비용 우선

예시:
- 문서 기반 챗봇
- 단순 FAQ 시스템
- 프로토타입 개발

## 핵심 요약

**전통적 RAG**: 고정 파이프라인, 빠르고 단순
- 항상 벡터 검색 → LLM
- 예측 가능, 구현 쉬움

**Agentic RAG**: 동적 파이프라인, 유연하고 강력
- AI가 도구 선택 → 상황별 최적화
- 복잡하지만 정확도 높음

**Agent의 핵심**: 자율적 의사결정
- 상황 판단 → 도구 선택 → 실행

**선택 기준**: 복잡도 vs 유연성 트레이드오프
- 단순 사용: 전통적 RAG
- 복잡 사용: Agentic RAG

---

**출처**: [ai-that-works GitHub](https://github.com/ai-that-works/ai-that-works/tree/main/2025-10-21-agentic-rag-context-engineering)
