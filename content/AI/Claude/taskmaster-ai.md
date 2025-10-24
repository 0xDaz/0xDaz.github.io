---
title: "Taskmaster AI: AI 주도 개발을 위한 작업 관리 시스템"
date: 2025-10-25T01:45:00+09:00
tags: ["Claude", "MCP", "Taskmaster", "Task Management", "AI Development", "Cursor", "Claude Code"]
categories: ["AI"]
draft: false
---

## 개요

Taskmaster AI는 AI 주도 개발을 위한 작업 관리 시스템

Cursor, Claude Code 등 AI 에디터와 완벽하게 통합되어 PRD 파싱부터 작업 확장, 의존성 관리까지 자동화

프롬프트만으로 복잡한 프로젝트를 체계적으로 관리 가능

## 주요 특징

### 1. PRD 자동 파싱
- 텍스트 PRD 문서를 읽고 자동으로 작업 생성
- AI가 프로젝트 복잡도 분석하여 적절한 작업 수 결정
- 작업별 우선순위, 의존성, 테스트 전략 자동 생성

### 2. 스마트 작업 확장
- 복잡도 분석 기반 자동 하위 작업 생성
- 단일 작업 또는 전체 작업 일괄 확장 가능
- Research 모드로 최신 베스트 프랙티스 반영

### 3. 작업 범위 조정
- `scope-up`: 작업 복잡도 증가
- `scope-down`: 작업 복잡도 감소
- Light, Regular, Heavy 강도 선택 가능

### 4. Research 모드
- Perplexity AI 연동 최신 정보 조회
- 프로젝트 컨텍스트 포함 맞춤형 리서치
- 작업에 자동 첨부 가능

### 5. 태그 시스템
- Git 브랜치별 작업 관리
- 태그 간 작업 이동, 복사 지원
- 의존성 유지/제거 옵션

### 6. TDD Autopilot (베타)
- RED-GREEN-COMMIT 사이클 자동화
- 테스트 결과 검증 및 커밋 자동화
- Git 브랜치 자동 생성/관리

## 요구사항

최소 1개 이상의 API 키 필요 (아래 중 택일):

- Anthropic API Key (Claude)
- OpenAI API Key
- Google Gemini API Key
- Perplexity API Key (Research 모드)
- xAI API Key
- OpenRouter API Key
- Claude Code CLI (API 키 불필요)
- Codex CLI (ChatGPT 구독 OAuth)

## 설치 방법

### Cursor 원클릭 설치

[Taskmaster AI MCP 설치](https://smithery.ai/server/@upstash/taskmaster-ai)

설치 후 API 키를 실제 값으로 교체 필요

### Claude Code CLI

```bash
claude mcp add taskmaster-ai -- npx -y task-master-ai
```

### 수동 설치

**Cursor/Windsurf** (`~/.cursor/mcp.json` 또는 `~/.codeium/windsurf/mcp_config.json`):

```json
{
  "mcpServers": {
    "task-master-ai": {
      "command": "npx",
      "args": ["-y", "task-master-ai"],
      "env": {
        "ANTHROPIC_API_KEY": "YOUR_ANTHROPIC_API_KEY",
        "PERPLEXITY_API_KEY": "YOUR_PERPLEXITY_API_KEY",
        "OPENAI_API_KEY": "YOUR_OPENAI_KEY",
        "GOOGLE_API_KEY": "YOUR_GOOGLE_KEY"
      }
    }
  }
}
```

**VS Code** (`.vscode/mcp.json`):

```json
{
  "servers": {
    "task-master-ai": {
      "command": "npx",
      "args": ["-y", "task-master-ai"],
      "env": {
        "ANTHROPIC_API_KEY": "YOUR_ANTHROPIC_API_KEY"
      },
      "type": "stdio"
    }
  }
}
```

### 도구 로딩 최적화

컨텍스트 윈도우 사용량 조절 가능:

```json
{
  "env": {
    "TASK_MASTER_TOOLS": "core"
  }
}
```

**옵션:**
- `all` (기본): 36개 도구, ~21,000 토큰
- `standard`: 15개 도구, ~10,000 토큰
- `core` 또는 `lean`: 7개 도구, ~5,000 토큰
- 쉼표로 구분된 도구 목록

## 초기 설정

### 1. 프로젝트 초기화

AI 채팅창에서:
```
Initialize taskmaster-ai in my project
```

또는 CLI:
```bash
task-master init --rules cursor,windsurf
```

### 2. 모델 설정

```
Change the main, research and fallback models to claude-sonnet-4, perplexity-sonar-pro, gpt-4o respectively
```

Claude Code 사용 시:
```
Change the main model to claude-code/sonnet
```

### 3. PRD 작성

`.taskmaster/docs/prd.txt`에 요구사항 작성

예시 템플릿은 `.taskmaster/templates/example_prd.txt` 참고

## 사용 예시

### PRD 파싱

```
Can you parse my PRD at .taskmaster/docs/prd.txt?
```

### 다음 작업 확인

```
What's the next task I should work on?
```

### 작업 구현

```
Can you help me implement task 3?
```

### 작업 확장

```
Can you help me expand task 4?
```

### 복잡도 분석

```
Analyze the complexity of all pending tasks
```

### 리서치

```
Research the latest best practices for implementing JWT authentication with Node.js
```

특정 파일 컨텍스트 포함:
```
Research React Query v5 migration strategies for our current API implementation in src/api.js
```

### 작업 이동 (크로스 태그)

```bash
# Backlog에서 In-Progress로 이동
task-master move --from=5 --from-tag=backlog --to-tag=in-progress

# 여러 작업 의존성 포함 이동
task-master move --from=5,6,7 --from-tag=backlog --to-tag=done --with-dependencies
```

## CLI 명령어

```bash
# 프로젝트 초기화
task-master init

# PRD 파싱
task-master parse-prd your-prd.txt

# 작업 목록
task-master list

# 다음 작업 조회
task-master next

# 특정 작업 조회
task-master show 1,3,5

# 작업 확장
task-master expand --id=5 --num=8

# 전체 작업 확장
task-master expand-all

# 복잡도 분석
task-master analyze

# 리서치
task-master research "latest Next.js 15 features"

# 태그 관리
task-master tags list
task-master tags add feature-auth
task-master tags use feature-auth

# 작업 상태 변경
task-master status --id=5 --status=done

# 파일 생성
task-master generate
```

## TDD Autopilot 워크플로우

```bash
# 워크플로우 시작
task-master autopilot start --task-id=5

# 다음 단계 확인
task-master autopilot next

# 테스트 실행 후 페이즈 완료
task-master autopilot complete-phase --test-results='{"total":10,"passed":0,"failed":10}'

# 커밋
task-master autopilot commit

# 워크플로우 종료
task-master autopilot finalize
```

## 프로젝트 구조

```
.taskmaster/
├── config.json           # 프로젝트 설정
├── tasks/
│   ├── tasks.json        # 전체 작업 데이터
│   └── 01.md             # 개별 작업 파일
├── docs/
│   ├── prd.txt           # 요구사항 문서
│   └── research/         # 리서치 결과
└── reports/
    └── task-complexity-report.json
```

## 작업 구조

```json
{
  "id": 1,
  "title": "작업 제목",
  "description": "작업 설명",
  "details": "구현 세부사항",
  "status": "pending",
  "priority": "high",
  "dependencies": [2, 3],
  "testStrategy": "테스트 전략",
  "subtasks": [
    {
      "id": "1.1",
      "title": "하위 작업",
      "status": "done"
    }
  ]
}
```

**상태값:**
- `pending`: 대기
- `in-progress`: 진행 중
- `review`: 리뷰
- `done`: 완료
- `deferred`: 연기
- `cancelled`: 취소

## 문제 해결

### 초기화 실패

```bash
# Node.js로 직접 실행
node node_modules/task-master-ai/scripts/init.js
```

### MCP 서버 재설정

```bash
# 기존 제거
claude mcp remove taskmaster-ai

# 재추가
claude mcp add taskmaster-ai -- npx -y task-master-ai
```

### 모델 변경 안됨

API 키가 MCP 설정의 `env` 섹션에 있는지 확인

또는 프로젝트 루트의 `.env` 파일에 추가

## 라이선스

MIT License with Commons Clause

**허용:**
- 개인, 상업, 학술 용도 사용
- 코드 수정
- 복사본 배포
- Taskmaster 기반 제품 제작 및 판매

**금지:**
- Taskmaster 자체 판매
- 호스팅 서비스 제공
- 경쟁 제품 제작

## 참고 링크

- [GitHub Repository](https://github.com/eyaltoledano/claude-task-master)
- [공식 문서](https://github.com/eyaltoledano/claude-task-master/tree/main/docs)
- [Discord 커뮤니티](https://discord.gg/taskmaster)
- [Smithery 설치](https://smithery.ai/server/@upstash/taskmaster-ai)
