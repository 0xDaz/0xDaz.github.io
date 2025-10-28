---
title: "Context7 MCP: AI 코딩 어시스턴트에 최신 문서 주입"
pubDate: 2025-10-25T01:30:00+09:00
tags: ["Claude", "MCP", "Context7", "Claude Code", "Claude Desktop", "Cursor", "Windsurf"]
categories: ["AI"]
draft: false
---

## 개요

Context7 MCP는 LLM에 최신 라이브러리 문서를 실시간으로 주입하는 Model Context Protocol 서버

AI가 오래된 학습 데이터가 아닌, 현재 버전의 정확한 문서와 코드 예제를 참조하여 작업 수행

프롬프트에 `use context7` 추가만으로 hallucination 없는 정확한 코드 생성 가능

## 기존 문제점

### AI 코딩의 한계

- 1~2년 전 학습 데이터 기반
- 구버전 API 예제 생성
- 존재하지 않는 함수 자신 있게 추천
- 최신 라이브러리 변경사항 반영 안 됨

### Context7의 해결책

프롬프트에 라이브러리 문서를 실시간으로 주입

버전별 정확한 API 참조

구조화된 최신 코드 예제 제공

## 주요 특징

### 1. 실시간 문서 주입
- 최신 버전별 문서 자동 검색
- 프롬프트 컨텍스트에 직접 삽입
- 별도 탭 전환 불필요

### 2. 정확한 코드 생성
- Hallucination 제거
- 실제 작동하는 API 사용
- 베스트 프랙티스 반영

### 3. 간단한 사용법
- 프롬프트에 `use context7` 추가
- 또는 자동 실행 규칙 설정
- 라이브러리 ID 직접 지정 가능

## 요구사항

- Node.js >= v18.0.0
- MCP 클라이언트 (Cursor, Claude Code, VS Code 등)
- Context7 API Key (선택, 높은 rate limit용)

## 설치 방법

### Cursor

`~/.cursor/mcp.json`에 추가:

**Remote Server (HTTP):**
```json
{
  "mcpServers": {
    "context7": {
      "url": "https://mcp.context7.com/mcp",
      "headers": {
        "CONTEXT7_API_KEY": "YOUR_API_KEY"
      }
    }
  }
}
```

**Local Server:**
```json
{
  "mcpServers": {
    "context7": {
      "command": "npx",
      "args": ["-y", "@upstash/context7-mcp", "--api-key", "YOUR_API_KEY"]
    }
  }
}
```

### Claude Code CLI

**Remote Server:**
```bash
claude mcp add --transport http context7 https://mcp.context7.com/mcp --header "CONTEXT7_API_KEY: YOUR_API_KEY"
```

**Local Server:**
```bash
claude mcp add context7 -- npx -y @upstash/context7-mcp --api-key YOUR_API_KEY
```

### Smithery 원클릭 설치

Cursor 1.0 이상에서 Install MCP Server 버튼으로 즉시 설치 가능

## 핵심 도구

### resolve-library-id
일반 라이브러리 이름을 Context7 호환 ID로 변환

**파라미터:**
- `libraryName` (필수): 라이브러리 이름

### get-library-docs
라이브러리 문서 가져오기

**파라미터:**
- `context7CompatibleLibraryID` (필수): Context7 호환 ID (예: `/mongodb/docs`)
- `topic` (선택): 특정 주제로 필터링 (예: "routing", "hooks")
- `tokens` (선택): 반환할 최대 토큰 수 (기본 5000)

## 사용 예시

### 기본 사용

```
Create a Next.js middleware that checks for a valid JWT in cookies
and redirects unauthenticated users to `/login`. use context7
```

Context7가 자동으로:
1. Next.js 최신 문서 검색
2. JWT 인증 관련 문서 추출
3. 최신 API 기반 코드 생성

### 라이브러리 ID 직접 지정

```
Implement basic authentication with Supabase.
use library /supabase/supabase for API and docs.
```

라이브러리 매칭 단계 생략, 직접 문서 로드

### 자동 실행 규칙

`.windsurfrules` (Windsurf) 또는 `CLAUDE.md` (Claude Code)에 추가:

```
Always use context7 when I need code generation, setup or configuration steps,
or library/API documentation. This means you should automatically use the
Context7 MCP tools to resolve library id and get library docs without me
having to explicitly ask.
```

이후 모든 코드 관련 질문에서 자동으로 Context7 작동

## 환경 변수

API Key를 환경 변수로 관리 가능:

```bash
# .env
CONTEXT7_API_KEY=your_api_key_here
```

MCP 설정:
```json
{
  "mcpServers": {
    "context7": {
      "command": "npx",
      "args": ["-y", "@upstash/context7-mcp"],
      "env": {
        "CONTEXT7_API_KEY": "YOUR_API_KEY"
      }
    }
  }
}
```

## 프록시 설정

HTTPS 프록시 환경에서는 표준 환경 변수 사용:

```bash
export https_proxy=http://proxy.example.com:8080
export HTTPS_PROXY=http://proxy.example.com:8080
```

## CLI 옵션

### Transport 모드
```bash
--transport <stdio|http>
```
- `stdio`: 기본값
- `http`: HTTP 및 SSE 엔드포인트 자동 제공

### 포트 지정 (HTTP 모드)
```bash
--port <number>
```
기본값: 3000

### API Key
```bash
--api-key <key>
```

**사용 예시:**
```bash
# HTTP transport, 포트 8080
npx @upstash/context7-mcp --transport http --port 8080

# stdio transport, API key 지정
npx @upstash/context7-mcp --transport stdio --api-key YOUR_API_KEY
```

## 검증

```bash
# MCP 서버 목록 확인
claude mcp list

# Context7 상세 정보
claude mcp get context7
```

## 지원 플랫폼

- Cursor
- Claude Code
- Claude Desktop
- Windsurf
- VS Code (with Cline)
- Amp
- Zed
- Augment Code
- Roo Code
- Gemini CLI
- Qwen Coder
- Opencode
- JetBrains AI Assistant
- 기타 MCP 호환 클라이언트

## API Key 발급 (생략 가능)

더 높은 rate limit과 private 레포지토리 접근을 위한 API Key 발급:

1. [context7.com/dashboard](https://context7.com/dashboard) 접속
2. 계정 생성 (무료)
3. API Key 발급 및 복사
4. MCP 설정에 추가

## 문제 해결

### Module Not Found 오류
Node.js 버전 확인 (v18 이상 필요):
```bash
node --version
```

### ESM Resolution 이슈
package.json에 `"type": "module"` 추가 또는 Node.js 업데이트

### TLS/Certificate 이슈
프록시 설정 확인 또는 `NODE_TLS_REJECT_UNAUTHORIZED=0` (개발 환경만)

## 프로젝트 기여

Context7는 커뮤니티 기여 프로젝트

새로운 라이브러리 추가 가능

[프로젝트 추가 가이드](https://github.com/upstash/context7) 참고

## 주의사항

### SSE 프로토콜 지원 종료
- Server-Sent Events 전송 방식 deprecated
- HTTP 또는 stdio 사용 권장
- 향후 릴리스에서 제거 예정

### 보안
- API Key 안전하게 보관
- 공개 레포지토리에 커밋 금지
- 환경 변수 또는 보안 저장소 사용

### 커뮤니티 프로젝트
- 문서 정확성 보장 불가
- 의심스러운 콘텐츠 발견 시 Report 버튼 사용
- 사용 시 자체 판단 필요

## 참고 링크

- [Context7 공식 사이트](https://context7.com)
- [Context7 GitHub](https://github.com/upstash/context7)
- [Context7 Dashboard](https://context7.com/dashboard)
- [Model Context Protocol](https://modelcontextprotocol.io/)
- [Discord 커뮤니티](https://discord.gg/context7)
