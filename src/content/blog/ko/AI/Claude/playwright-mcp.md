---
title: "Playwright MCP: LLM을 위한 브라우저 자동화 도구"
pubDate: 2025-10-25T01:18:00+09:00
tags: ["Claude", "MCP", "Playwright", "Browser Automation", "Claude Code", "Claude Desktop"]
categories: ["AI"]
keywords: ["Playwright MCP", "Browser Automation", "MCP Server", "Claude Code", "Web Automation", "Testing", "Playwright", "Claude Desktop", "Browser Testing", "AI Automation"]
draft: false
---


## 개요

Playwright MCP는 Model Context Protocol 서버로, LLM이 브라우저를 자동화할 수 있게 해주는 도구

스크린샷 대신 접근성 트리(accessibility tree)를 사용하여 빠르고 가볍게 동작

비전 모델 불필요, 구조화된 데이터로 작동하며 결정론적 도구 적용 가능

## 주요 특징

### 1. 빠르고 가벼움
- 픽셀 기반 입력 대신 접근성 트리 사용
- 스크린샷 처리보다 훨씬 빠른 응답 속도
- 적은 리소스로 브라우저 제어

### 2. LLM 친화적
- 비전 모델 불필요
- 구조화된 데이터로 작동
- 텍스트 기반 요소 식별

### 3. 결정론적 도구 적용
- 스크린샷 기반 방식의 모호함 제거
- 명확한 요소 선택
- 안정적인 자동화 워크플로우

## 요구사항

- Node.js 18 이상
- MCP 클라이언트 (VS Code, Cursor, Windsurf, Claude Desktop 등)

## 설치 방법

### 표준 설정 (대부분의 MCP 클라이언트)

```json
{
  "mcpServers": {
    "playwright": {
      "command": "npx",
      "args": ["@playwright/mcp@latest"]
    }
  }
}
```

### Claude Code CLI

```bash
claude mcp add playwright npx @playwright/mcp@latest
```

## 설정 옵션

### 브라우저 선택
```bash
--browser <chrome|firefox|webkit|msedge>
```

### 헤드리스 모드
```bash
--headless
```

### 디바이스 에뮬레이션
```bash
--device "iPhone 13"
```

### 사용자 프로필 위치
```bash
--user-data-dir /path/to/profile
```

### 격리 세션
```bash
--isolated
```

### 브라우저 확장 연결
```bash
--extension
```

## 사용자 프로필 모드

### 1. 영구 프로필 (Persistent Profile)
- 로그인 정보 저장
- 쿠키 및 세션 유지
- `--user-data-dir` 옵션 사용

### 2. 격리 모드 (Isolated)
- 매 세션마다 초기화
- 깨끗한 브라우저 상태
- `--isolated` 옵션 사용

### 3. 브라우저 확장 (Browser Extension)
- 기존 브라우저 탭에 연결
- 실시간 상호작용
- `--extension` 옵션 사용

## 핵심 도구

### 기본 자동화

#### browser_navigate
- URL로 이동
- 웹 페이지 로드

#### browser_click
- 요소 클릭
- 버튼, 링크 상호작용

#### browser_type
- 텍스트 입력
- 폼 필드 작성

#### browser_snapshot
- 접근성 스냅샷 캡처
- 스크린샷보다 효율적
- 구조화된 페이지 데이터 제공

#### browser_fill_form
- 여러 폼 필드 동시 입력
- 효율적인 폼 작성

#### browser_select_option
- 드롭다운 옵션 선택
- Select 요소 제어

### 탭 관리

#### browser_tabs
- 브라우저 탭 생성, 전환, 닫기
- 멀티탭 워크플로우 지원

### 정보 수집

#### browser_console_messages
- 콘솔 로그 확인
- 디버깅 정보 수집

#### browser_network_requests
- 네트워크 요청 목록
- API 호출 모니터링

### 고급 기능

#### browser_evaluate
- JavaScript 실행
- 커스텀 스크립트 실행

#### browser_file_upload
- 파일 업로드
- 파일 선택 다이얼로그 처리

#### browser_handle_dialog
- alert, confirm, prompt 처리
- 다이얼로그 자동 응답

#### browser_wait_for
- 특정 조건 대기
- 요소 나타날 때까지 대기

## 선택적 기능 (Opt-in)

### Vision 기능
```bash
--caps=vision
```
- 좌표 기반 클릭
- 이미지 인식 기능

### PDF 생성
```bash
--caps=pdf
```
- 페이지를 PDF로 저장
- 문서 아카이빙

### 테스팅
```bash
--caps=testing
```
- 로케이터 생성
- 요소 검증

### 트레이싱
```bash
--caps=tracing
```
- 실행 추적 기록
- 디버깅 및 분석

## 사용 사례

### 웹 자동화
- 반복 작업 자동화
- 데이터 입력 자동화
- 폼 제출 자동화

### 웹 스크래핑
- 구조화된 데이터 추출
- 동적 콘텐츠 수집
- 로그인 필요한 페이지 접근

### 테스팅
- E2E 테스트 자동화
- UI 검증
- 크로스 브라우저 테스팅

### 모니터링
- 웹사이트 상태 확인
- 변경사항 추적
- 자동 알림

## Playwright MCP를 사용하는 이유

### 구조화된 데이터 기반
- LLM이 웹 페이지를 구조화된 데이터로 이해
- 스크린샷보다 정확한 요소 식별
- 빠른 처리 속도

### 높은 신뢰성
- 스크린샷 기반 방식보다 안정적
- 명확한 요소 선택
- 재현 가능한 자동화

### 복잡한 워크플로우 지원
- 로그인 세션 유지
- 브라우저 상태 관리
- 멀티스텝 자동화

### 다양한 활용
- 테스팅
- 스크래핑
- 자동화 작업
- 모니터링

## 검증

```bash
# MCP 서버 목록 확인
claude mcp list

# Playwright MCP 상세 정보
claude mcp get playwright
```

## 참고 링크

- [Playwright MCP GitHub](https://github.com/microsoft/playwright-mcp)
- [Playwright Documentation](https://playwright.dev/)
- [Model Context Protocol](https://modelcontextprotocol.io/)
