---
title: "GitHub MCP Server"
pubDate: 2025-10-25T01:00:00+09:00
tags: ["Claude", "MCP", "GitHub", "Claude Code", "Claude Desktop", "Docker"]
categories: ["AI"]
draft: false
---

## 개요

GitHub MCP Server는 Claude에서 GitHub API를 직접 활용할 수 있게 해주는 Model Context Protocol 서버

리포지토리 조회, 이슈 관리, PR 생성 등 GitHub 작업을 Claude 대화 중에 바로 수행 가능

## 설치 방법

### Claude Code CLI

#### Remote Server (Streamable HTTP)

```bash
claude mcp add --transport http github https://api.githubcopilot.com/mcp -H "Authorization: Bearer YOUR_GITHUB_PAT"
```

환경변수 사용:
```bash
claude mcp add --transport http github https://api.githubcopilot.com/mcp -H "Authorization: Bearer $(grep GITHUB_PAT .env | cut -d '=' -f2)"
```

#### Local Server (Docker)

```bash
claude mcp add github -e GITHUB_PERSONAL_ACCESS_TOKEN=YOUR_GITHUB_PAT -- docker run -i --rm -e GITHUB_PERSONAL_ACCESS_TOKEN ghcr.io/github/github-mcp-server
```

환경변수 사용:
```bash
claude mcp add github -e GITHUB_PERSONAL_ACCESS_TOKEN=$(grep GITHUB_PAT .env | cut -d '=' -f2) -- docker run -i --rm -e GITHUB_PERSONAL_ACCESS_TOKEN ghcr.io/github/github-mcp-server
```

#### Binary 직접 설치

1. [릴리스 페이지](https://github.com/github/github-mcp-server/releases)에서 바이너리 다운로드
2. PATH에 추가
3. 설정 추가:

```bash
claude mcp add-json github '{"command": "github-mcp-server", "args": ["stdio"], "env": {"GITHUB_PERSONAL_ACCESS_TOKEN": "YOUR_GITHUB_PAT"}}'
```

### Claude Desktop

Claude Desktop에서는 Docker 기반 로컬 서버 사용 필요

**설정 파일 위치:**
- macOS: `~/Library/Application Support/Claude/claude_desktop_config.json`
- Windows: `%APPDATA%\Claude\claude_desktop_config.json`
- Linux: `~/.config/Claude/claude_desktop_config.json`

**설정 추가:**

```json
{
  "mcpServers": {
    "github": {
      "command": "docker",
      "args": [
        "run",
        "-i",
        "--rm",
        "-e",
        "GITHUB_PERSONAL_ACCESS_TOKEN",
        "ghcr.io/github/github-mcp-server"
      ],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "YOUR_GITHUB_PAT"
      }
    }
  }
}
```

설정 후 Claude Desktop 재시작 필요

## 검증

```bash
# 설치된 MCP 서버 목록 확인
claude mcp list

# GitHub MCP 서버 상세 정보
claude mcp get github
```

## Personal Access Token 발급

1. GitHub Settings → Developer settings → Personal access tokens → Tokens (classic)
2. Generate new token (classic)
3. Scopes: `repo` 권한 필수
4. 토큰 생성 후 안전하게 보관

## 문제 해결

### Docker Pull 실패

```bash
docker logout ghcr.io
docker pull ghcr.io/github/github-mcp-server
```

### MCP 서버 재설정

```bash
# 기존 설정 제거
claude mcp remove github

# 다시 추가
claude mcp add github ...
```

### 로그 확인

**Claude Code:**
- `/mcp` 명령어 사용

**Claude Desktop:**
- macOS: `~/Library/Logs/Claude/mcp-server-*.log`
- Windows: `%APPDATA%\Claude\logs\`

## 주의사항

- npm 패키지 `@modelcontextprotocol/server-github`는 2025년 4월부터 deprecated
- Claude Desktop에서 Docker 기반 MCP 서버 호환성 이슈 보고됨
- Remote server는 Streamable HTTP 지원하는 Claude 버전 필요

## Configuration Scope

Claude Code에서 MCP 설정 범위 지정 가능:

- `-s user`: 모든 프로젝트에서 사용
- `-s project`: `.mcp.json` 파일로 공유
- 기본값: local (현재 프로젝트만)

## 참고 링크

- [GitHub MCP Server Repository](https://github.com/github/github-mcp-server)
- [Model Context Protocol Documentation](https://modelcontextprotocol.io/)
- [GitHub Personal Access Tokens](https://github.com/settings/tokens)
