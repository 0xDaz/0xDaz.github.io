---
title: "Claude Code MCP 서버 토큰 관련 트러블 슈팅"
date: 2025-10-27T01:43:09+09:00
draft: false
tags: ["Claude Code", "MCP", "최적화", "트러블슈팅"]
categories: ["AI"]
description: "Claude Code MCP 서버 초기 로드시 5만+ 토큰 소모 문제 해결 과정"
---

## 문제 상황

Claude Code에 여러 MCP 서버 연결 후 세션 시작 시 5만 토큰 이상 초기 로드에 소모. 지속적인 토큰 사용량 경고 발생

## 기존 MCP 설정

초기 7개 MCP 서버 연결 상태:

| MCP 서버 | 프로토콜 | 용도 |
|---------|---------|------|
| **Linear** | HTTP | 이슈, 프로젝트, 사이클 관리 - 팀 협업 중앙 허브 |
| **GitHub** | HTTP | 이슈, PR, 커밋 관리 - 코드 검색 및 리뷰 |
| **Playwright** | stdio | 브라우저 자동화, Asset Store 크롤링, 스크린샷 테스팅 |
| **Context7** | stdio | Unity/Hugo/Steam API 최신 문서 검색 |
| **mcp-obsidian** | Python | Obsidian 노트 관리, 개발 로그 자동 기록 |
| **UnityMCP** | Python | Unity Editor 직접 제어, Scene/GameObject/Script 관리 |
| **task-master-ai** | stdio | 로컬 작업 분해, 상태 추적, TDD 워크플로우 |

## 문제 원인

- **초기 컨텍스트 로드 비용**: 모든 MCP 서버가 세션 시작 시 툴/리소스 정보 전송
- **중복 기능**: GitHub MCP와 GitHub CLI, Linear와 task-master-ai 기능 중복
- **미사용 서버**: mcp-obsidian 실제 활용도 낮음
- **항상 로드 vs 필요시 로드**: Playwright 같은 가끔 사용하는 기능도 항상 로드

## 최적화 전략

### 1. 중복 제거

**Linear** → 수동 관리 + task-master-ai 활용
- 외부 이슈 트래킹은 Linear 웹에서 직접 관리
- Agent 작업은 로컬 task-master-ai로 충분

**GitHub MCP** → GitHub CLI(`gh`) 대체
- MCP 대신 `gh` 명령어 사용
- 필요한 기능만 선택적 호출 가능

### 2. JIT(Just-In-Time) 로딩

**Playwright** → Claude Skill 전환
- MCP에서 제거하고 `playwright-skill` Skill로 전환
- 브라우저 자동화 필요시에만 로드

### 3. 미사용 서버 제거

**mcp-obsidian** → 삭제
- 실제 사용 빈도 거의 없음
- 필요시 수동으로 노트 작성

### 4. 서버별 최적화 옵션

**task-master-ai** → `"TASK_MASTER_TOOLS": "core"` 설정
- 필수 툴만 로드하는 경량 모드
- `get_tasks`, `next_task`, `set_task_status` 등 핵심 기능만 제공

## 최종 설정

```json
{
  "mcpServers": {
    "context7": {
      "command": "npx",
      "args": ["-y", "@context7/mcp"]
    },
    "UnityMCP": {
      "command": "python",
      "args": ["-m", "unitymcp"]
    },
    "task-master-ai": {
      "command": "npx",
      "args": ["-y", "task-master-ai"],
      "env": {
        "TASK_MASTER_TOOLS": "core",
        "ANTHROPIC_API_KEY": "..."
      }
    }
  }
}
```

## 결과

- **초기 토큰 사용량**: 5만+ → 추정 1만 이하로 감소
- **필수 기능 유지**: Context7 (문서), UnityMCP (Unity 제어), task-master-ai (작업 관리)
- **유연성 확보**: Skill 시스템으로 필요시 기능 확장 가능

## 핵심 교훈

1. **MCP는 만능이 아님**: CLI, Skill, 직접 호출 등 다양한 도구 조합 필요
2. **초기 로드 비용 고려**: 모든 기능을 MCP로 연결하면 컨텍스트 소모 증가
3. **사용 패턴 분석**: 항상 필요한 기능 vs 가끔 필요한 기능 구분
4. **서버별 최적화 옵션 확인**: 많은 MCP 서버가 경량 모드 제공
