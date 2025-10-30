---
title: "Augmented Coding과 TDD: AI 시대에 규율이 이기는 이유"
description: "Kent Beck이 52년 경력 끝에 다시 찾은 TDD, LLM 개발의 가드레일로 작동하는 이유, 그리고 Vibe Coding이 위험한 이유"
pubDate: 2025-10-31T01:21:36+09:00
tags: ["TDD", "AI", "LLM", "Kent Beck", "Augmented Coding", "Software Engineering"]
categories: ["AI"]
draft: false
---

## Vibe Coding vs Augmented Coding

AI 코딩 도구가 보편화되면서 개발 방식이 두 갈래로 나뉘는 중.

한쪽은 **Vibe Coding**. LLM이 생성한 코드를 검토하지 않고 "코드가 존재한다는 사실조차 잊는" 접근. Andrej Karpathy가 2025년 2월 대중화. 빠른 프로토타이핑에는 좋지만 긴 피드백 루프와 높은 수준의 명세만으로 작업.

반대쪽은 **Augmented Coding**. 코드 품질, 복잡도, 테스트, 커버리지를 신경 쓰는 방식. 수작업 코딩과 동일한 기준: 작동하는 깔끔한 코드. 짧은 피드백 루프, 상세한 명세, 커밋 전 코드 완전 이해.

차이가 중요한 이유? 최근 18명 CTO 대상 설문조사 결과 **16명이 AI 생성 코드로 인한 프로덕션 장애 경험**. 기술의 차이가 아니라 규율의 차이.

## Kent Beck과 TDD가 만나는 지점

52년 경력의 Kent Beck이 AI 코딩 도구로 다시 활력을 찾음. 하지만 Vibe Coding 방식은 아님.

그의 Substack 에세이 "Augmented Coding: Beyond the Vibes"에서 핵심 주장: **TDD가 AI 에이전트와 작업할 때 슈퍼파워가 됨**.

TDD는 AI 모델이 제멋대로 작동하지 못하도록 막는 가드레일 역할. 그의 접근:

- AI가 검증 없이 앞서가지 못하도록 제어
- 경고 신호 감시 (예상 밖 기능, 비활성화된 테스트)
- 설계 제어는 인간 개발자가 유지
- 작고 명확한 태스크로 빠른 피드백 루프 구성

실제 경험도 이를 뒷받침. B+ tree 프로젝트 처음 두 번은 복잡도가 쌓이며 실패. 더 강한 설계 제어와 TDD 규율을 적용했을 때만 성공.

## AI 개발에 TDD가 잘 맞는 이유

### 1. LLM의 과신 검증

LLM은 "deceptive confidence"라는 특성이 있음. 겉보기엔 맞지만 미묘하게 틀린 코드를 자신 있게 생성. 테스트는 정확성을 사전 정의된 기준으로 검증하며, 코드 리뷰에서 놓칠 수 있는 오류를 잡는 안전망.

### 2. 실행 가능한 spec

테스트는 구체적이고 실행 가능한 spec으로 기능. 자연어 설명보다 명확하게 요구사항 전달. 연구 결과도 확인: 테스트 케이스를 포함하면 LLM 코드 생성 성공률이 크게 올라감.

### 3. 구조화된 프로세스

TDD는 개발을 "일단 생성하고 기도"에서 "정확성 정의 후 생성"으로 바꿈. 인간이 품질 기준과 설계 제약을 정의하면, AI는 그 가드레일 안에서 구현.

### 4. 작은 컨텍스트 = 높은 정확도

TDD는 문제를 작은 단계로 쪼갬. 작은 컨텍스트 윈도우는 정확도 향상. 짧은 completion은 높은 품질로 이어짐. LLM 작동 방식과 완벽한 궁합.

### 5. 즉각적 피드백

실행 가능한 테스트는 즉시 검증. 모든 코드를 수동으로 검토할 필요 없음. 프로덕션 전에 오류 포착. 피드백 루프가 며칠에서 몇 초로 단축.

### 6. 인간 통제권 유지

개발자 역할이 바뀜: 요구사항 정의 → 결과 검증. TDD는 이 검증에 가장 효과적. AI 시대에 더욱 중요해진 방법론.

## 학계도 동의

최근 ACM/IEEE 연구 "Test-Driven Development and LLM-based Code Generation"이 Kent Beck의 실무 경험을 확인. 테스트가 LLM의 요구사항 이해를 돕는다는 것. TDD를 LLM 보조 개발의 "유망한 패러다임"으로 평가.

데이터가 직관을 뒷받침: 구조화된 test-driven 접근이 검증 없는 생성보다 나은 코드 생산.

## 황금률

Kent Beck의 Augmented Coding 황금률: **"정확히 무엇을 하는지 설명할 수 없으면 커밋하지 않는다"**

AI를 불신하자는 게 아님. 도구가 강력해질수록 엔지니어링 규율이 더 중요해진다는 것. Vibe Coding은 해커톤이나 PoC에 적합. 하지만 프로덕션 코드베이스와 복잡한 시스템은 TDD 규율을 갖춘 Augmented Coding이 답.

## 실전 조언

AI 코딩 도구 사용할 때:

1. **테스트 먼저** - 생성 전에 정확성 정의
2. **작은 단위** - 테스트 하나, 기능 하나
3. **전부 리뷰** - 생성된 모든 코드 이해
4. **이상 징후 감시** - AI가 테스트 비활성화하거나 예상 밖 기능 추가하면 중단
5. **설계 통제권** - 설계는 인간, 구현은 AI
6. **계속 테스트** - Red → Green → Refactor, 매번

AI 시대는 엉성한 코드를 의미하지 않음. 규율이 그 어느 때보다 중요하다는 의미. TDD가 그 규율을 제공.

52년 경력의 Kent Beck이 AI와 TDD 가드레일이 필요하다면, 우리도 필요.

## 참고자료

- [Kent Beck's CLAUDE.md - TDD with AI Guide](https://github.com/KentBeck/BPlusTree3/blob/main/rust/docs/CLAUDE.md)
- [Kent Beck, "Augmented Coding: Beyond the Vibes" (Substack)](https://tidyfirst.substack.com/p/augmented-coding-beyond-the-vibes)
- "Test-Driven Development and LLM-based Code Generation" (ACM/IEEE Research)
- CTO Survey on AI-Caused Production Disasters (2025)
