---
title: "Claude Code 6개월 하드코어 사용기 - 30만 줄 리팩토링 실전 팁"
description: "Reddit 유저의 6개월 Claude Code 실전 경험과 내 개발 환경 설정 공유. 스킬 자동화, 훅 시스템, 개발 문서 워크플로우까지"
pubDate: 2025-11-06T02:00:13+09:00
tags: ["claude-code", "ai-coding", "workflow", "productivity", "automation", "tdd"]
categories: ["AI"]
draft: false
---

## 인트로

Reddit에서 흥미로운 글을 발견했다. 어떤 개발자가 Claude Code로 6개월간 **30만 LOC(Lines of Code)** 리팩토링에 성공한 경험담이었다. React 16 JS → React 19 TypeScript, Material UI v4 → MUI v7 등 대규모 마이그레이션을 **혼자서** 완수한 비결이 궁금했다.

[Reddit 원문](https://www.reddit.com/r/ClaudeCode/comments/1oivs81/claude_code_is_a_beast_tips_from_6_months_of/) | [GitHub](https://github.com/diet103/claude-code-infrastructure-showcase)

이 글에서는 Reddit 유저(diet103)의 핵심 팁과 내 개발 환경 설정을 통합하여 실전에 바로 적용할 수 있는 노하우를 정리한다.

## 핵심 인사이트

### 모든 헤비 유저의 공통점

1. **계획 단계가 전부** - "계획 없이 시작하면 실패 확률 90%"
2. **스킬 + 훅 조합** - 자동 활성화가 없으면 스킬은 장식
3. **토큰 최적화** - Just-In-Time 로딩, MCP 최소화, 심볼 기반 탐색
4. **관심사 분리** - 스킬(how to code) vs CLAUDE.md(project specific)
5. **개발 문서 시스템** - Claude의 기억 상실증 해결책

## Reddit 유저의 게임 체인저

### 1. 스킬 자동 활성화 시스템

**문제**: Anthropic이 스킬 기능을 출시했지만 Claude가 자동으로 사용하지 않음

**해결책**: TypeScript 훅 + skill-rules.json 중앙 설정

```json
{
  "backend-dev-guidelines": {
    "type": "domain",
    "enforcement": "suggest",
    "priority": "high",
    "promptTriggers": {
      "keywords": ["backend", "controller", "service", "API", "endpoint"],
      "intentPatterns": [
        "(create|add).*?(route|endpoint|controller)",
        "(how to|best practice).*?(backend|API)"
      ]
    },
    "fileTriggers": {
      "pathPatterns": ["backend/src/**/*.ts"],
      "contentPatterns": ["router\\.", "export.*Controller"]
    }
  }
}
```

**작동 방식**:
- **UserPromptSubmit 훅**: 프롬프트에서 키워드 분석 → 관련 스킬 자동 주입
- **Stop 이벤트 훅**: 편집된 파일 분석 → 위험한 패턴 감지 → 자가 점검 알림

**결과**:
- ❌ 이전: 매번 "BEST_PRACTICES.md 확인해줘" 수동 요청
- ✅ 이후: 일관된 패턴 자동 적용, 30만 LOC 전반에 걸쳐 일관성 유지

**토큰 효율**: 메인 파일 500줄 이하 + 리소스 파일로 점진적 공개 → 40-60% 토큰 절감

### 2. 개발 문서 시스템

Claude는 "극심한 기억 상실증을 가진 극도로 자신감 넘치는 주니어 개발자"

**대규모 작업 시작 시**:
```bash
mkdir -p ~/git/project/dev/active/[task-name]/
```

**필수 3개 문서**:
- `[task-name]-plan.md` - 승인된 계획
- `[task-name]-context.md` - 핵심 파일, 결정 사항
- `[task-name]-tasks.md` - 작업 체크리스트

**작업 이어서 할 때**:
- `/dev/active/`에서 기존 작업 확인
- 진행 전에 3개 파일 모두 읽기
- "마지막 업데이트" 타임스탬프 업데이트

**계획 프로세스**: strategic-plan-architect 에이전트 활용
- 컨텍스트 수집 → 프로젝트 구조 분석 → 구조화된 계획 생성
- 3개 문서 자동 생성
- ⚠️ **반드시 검토** - Claude가 중요한 부분을 잘못 이해했을 수 있음

### 3. PM2 프로세스 관리

**문제**: 7개 백엔드 마이크로서비스 동시 실행, Claude가 로그 접근 불가

**해결책**: PM2로 모든 서비스 관리

```javascript
// ecosystem.config.js
module.exports = {
  apps: [
    {
      name: 'form-service',
      script: 'npm',
      args: 'start',
      cwd: './form',
      error_file: './form/logs/error.log',
      out_file: './form/logs/out.log',
    },
    // ... 6개 더
  ]
};
```

**비교**:

**PM2 이전**:
- 나: "이메일 서비스에서 오류 발생"
- 나: [수동으로 로그 찾아 복사 → 채팅에 붙여넣기]

**PM2 이후**:
- 나: "이메일 서비스에서 오류 발생"
- Claude: `pm2 logs email --lines 200`
- Claude: "데이터베이스 연결 시간 초과 문제 발견"
- Claude: `pm2 restart email`

### 4. 훅 시스템 파이프라인

**훅 #1: 파일 편집 추적기**
- 모든 Edit/Write 작업 후 실행
- 파일, 레포지토리, 타임스탬프 기록

**훅 #2: 빌드 체커**
- Claude 응답 완료 후 실행
- 편집 로그 → 영향받은 레포지토리 확인 → 빌드 스크립트 실행
- 오류 < 5개: Claude에게 표시
- 오류 ≥ 5개: 자동 오류 해결사 에이전트 추천

**훅 #3: Prettier 포맷터** ⚠️
- 편집된 모든 파일 자동 포맷
- **주의**: 단 3라운드에 160k 토큰 소비 가능 (현재 비추천)

**훅 #4: 오류 처리 알림**
- 위험한 패턴 감지 시 부드러운 알림 표시

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📋 오류 처리 자가 점검
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

⚠️  백엔드 변경 감지
   2개 파일 편집됨

   ❓ catch 블록에 Sentry.captureException() 추가?
   ❓ Prisma 작업이 오류 처리로 래핑되었는지 확인?

   💡 백엔드 모범 사례:
      - 모든 오류는 Sentry로 캡처
      - 컨트롤러는 BaseController 확장
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

**완전한 파이프라인**:
1. Claude 응답 완료
2. 훅 1: Prettier 포맷터
3. 훅 2: 빌드 체커 → TypeScript 오류 즉시 발견
4. 훅 3: 오류 알림
5. 오류 발견 → Claude가 보고 수정
6. 결과: 깨끗하고, 포맷팅되고, 오류 없는 코드

### 5. CLAUDE.md와 스킬의 진화

**스킬로 이동한 것** (how to code):
- TypeScript 표준
- React 패턴
- 백엔드 API 패턴
- 오류 처리
- 데이터베이스 패턴
- 테스트 가이드라인
- 성능 최적화

**CLAUDE.md에 남은 것** (~200줄):
- 빠른 명령어
- 서비스별 설정
- 작업 관리 워크플로우
- 인증된 라우트 테스트
- 워크플로우 드라이런 모드
- 브라우저 도구 설정

**새로운 구조**:
```
Root CLAUDE.md (100줄)
├── 중요한 보편적 규칙
├── 레포지토리별 claude.md 파일 가리키기
└── 상세 가이드라인을 위한 스킬 참조

각 레포의 claude.md (50-100줄)
├── PROJECT_KNOWLEDGE.md - 아키텍처 & 통합
├── TROUBLESHOOTING.md - 일반적인 문제
└── 자동 생성된 API 문서
```

**핵심**: 스킬은 "코드 작성 방법", CLAUDE.md는 "이 프로젝트가 작동하는 방식"

## 내 개발 환경 설정

### Claude Hook System

**PreToolUse** (위험 명령어 차단):
- `git push`, `p4 submit`, `terraform apply`, `kubectl delete` 차단
- 파일 수정 시 `p4 edit` 자동 실행
- 코드 Write/Edit 전 SPEC/TODO 문서 작성 체크

**PostToolUse** (품질 관리):
- Test, Linter 실행 체크 gentle reminder

**SubagentStop** (검증):
- SPEC/TODO에 맞게 구현했는지 검증 (코딩 서브 에이전트 전용)

### 세션 관리

기본 compact 명령어 효율이 낮아 커스텀 명령어 추가:

```bash
/save -> /clear -> /load
```

임시 세션 파일 작성 후 로드 방식으로 컨텍스트 관리

### 프롬프트 최적화

**CLAUDE.md 전략**:
- Anthropic 공식 가이드에 따라 최대한 compact하게 작성
- 메인 에이전트는 오케스트레이터 역할만
- 개별 서브 에이전트가 각자 컨텍스트에서 작업 수행

**문서 로딩 전략**:
- 아키텍처, 서비스, 환경 문서는 @ 참조 대신 Just-In-Time load
- 경로 및 설명만 짧게 명시

**MCP 최적화**:
- MCP는 Load 시 토큰 차지 → 스킬로 대체 or 최소 활성화
- 활성화된 MCP: Context7, Serena MCP
- **Serena MCP**: 코드베이스 탐색 시 직접 Read보다 **LSP를 통한 심볼 기반 탐색**으로 토큰 절감

### 자동화

**프롬프트 평가 에이전트**:
- 신뢰성 높은 소스로부터 프롬프트 관련 문서 종합
- 룰 생성 → 프롬프트 평가 에이전트 구성

**Claude Skill**:
- 자동화가 필요하거나 코드로 실행 가능한 작업은 최대한 스킬로 구성

**Claude 문법 학습**:
- 훅 시스템, 스킬 스키마 등 Claude가 잘 모르는 아이러니
- 해결책: Context7에서 문서 찾아 컨텍스트 주입

## 계획 단계의 절대적 중요성

모든 Claude Code 헤비 유저가 강조하는 단 하나의 진리:

> **계획 단계가 엄청나게 중요하다**

### 핵심 원칙

- 계획 단계에서 유저가 적극 개입 필요
- Claude Code는 아직 우리 뇌 속 도메인 지식과 워크플로우를 100% 이해 불가
- 자연어에서 비롯된 잘못된 해석의 여지 존재
- 초기 단계에서 잘못된 분기점 제거 필수

### 현재 문제점

- 서브 에이전트가 plan할 때 볼 수 없음
- 취소하면 모든 내용 날아감
- 가장 중요한 단계이지만 손 놓고 보고만 있을 때 잘못될 가능성이 가장 높음

### 고민 중인 해결책

Discussion을 위한 agent를 따로 두고 메인 에이전트에서 plan 실행하는 방식

## 공통 인사이트 & 교훈

### Reddit 유저와의 공통점

✅ 스킬 + 훅 조합의 강력함
✅ 계획 단계의 절대적 중요성
✅ 코드 검토 자동화
✅ PM2 같은 프로세스 관리 도구
✅ 전문화된 에이전트 활용
✅ 토큰 최적화 전략

### 차별화 포인트

**Reddit 유저**:
- skill-rules.json 중앙 설정
- UserPromptSubmit + Stop 이벤트 훅
- 개발 문서 시스템 (plan, context, tasks)
- strategic-plan-architect 에이전트
- 850개 이상의 마크다운 문서

**내 설정**:
- P4 (Perforce) 통합
- Serena MCP를 통한 LSP 기반 탐색
- SPEC/TODO 문서 중심 개발
- 위험 명령어 차단 시스템
- /save, /load 커스텀 명령어

### 토큰 최적화 전략

1. **MCP 최소화** - 꼭 필요한 것만 활성화
2. **Just-In-Time 로딩** - @ 참조 대신 필요할 때만
3. **심볼 기반 탐색** - Serena MCP로 LSP 활용
4. **점진적 공개** - 메인 500줄 + 리소스 파일 분리
5. **Prettier 훅 주의** - 160k 토큰 소비 가능

## 결론

### 필수 사항

✅ **계획 - 계획 - 계획** - 계획 없이는 실패
✅ **스킬 + 훅** - 자동 활성화가 스킬이 작동하는 유일한 방법
✅ **개발 문서 시스템** - Claude가 길 잃는 것 방지
✅ **코드 검토** - Claude가 자신의 작업 검토하게
✅ **프로세스 관리** - PM2로 디버깅을 견딜 만하게

### 있으면 좋은 것

- 일반적인 작업을 위한 전문 에이전트
- 반복되는 워크플로우를 위한 슬래시 커맨드
- 포괄적인 문서화
- 스킬에 연결된 유틸리티 스크립트
- 결정 사항을 위한 Memory MCP

### 핵심 요약

Reddit 유저는 TypeScript 훅으로 스킬 자동 활성화 시스템을 구축하고, 개발 문서 워크플로우를 만들고, PM2 + 자동 오류 검사를 구현했다. 결과: **6개월 만에 일관된 품질로 30만 LOC를 혼자서 리라이팅**

나는 Hook System으로 위험 명령어 차단과 품질 관리를 자동화하고, Serena MCP + LSP로 토큰을 절감하고, SPEC/TODO 문서 중심 개발로 계획 단계를 강화했다.

공통점: **계획 단계 강화 + 스킬/훅 조합 + 토큰 최적화 + 자동화**

## 참고 링크

- [Reddit 원문 - Claude Code is a beast: Tips from 6 months of hardcore use](https://www.reddit.com/r/ClaudeCode/comments/1oivs81/claude_code_is_a_beast_tips_from_6_months_of/)
- [GitHub - claude-code-infrastructure-showcase](https://github.com/diet103/claude-code-infrastructure-showcase)
- [Anthropic Claude Code 공식 문서](https://docs.anthropic.com/claude/docs)
