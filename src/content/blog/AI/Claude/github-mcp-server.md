---
title: "GitHub MCP Server"
description: "Enable Claude to use GitHub API directly. Query repos, manage issues, create PRs from conversation. Remote and Docker-based local server support."
pubDate: 2025-10-25T01:00:00+09:00
tags: ["Claude", "MCP", "GitHub", "Claude Code", "Claude Desktop", "Docker"]
categories: ["AI"]
keywords: ["GitHub MCP Server", "MCP", "GitHub", "Claude Code", "Claude Desktop", "Docker", "Version Control", "GitHub Integration", "Code Repository", "CI/CD"]
draft: false
---


## Overview

GitHub MCP Server enables Claude to directly use GitHub API via Model Context Protocol server

Can perform GitHub operations like repository queries, issue management, PR creation directly in Claude conversation

## Installation

### Claude Code CLI

#### Remote Server (Streamable HTTP)

```bash
claude mcp add --transport http github https://api.githubcopilot.com/mcp -H "Authorization: Bearer YOUR_GITHUB_PAT"
```

Using environment variable:
```bash
claude mcp add --transport http github https://api.githubcopilot.com/mcp -H "Authorization: Bearer $(grep GITHUB_PAT .env | cut -d '=' -f2)"
```

#### Local Server (Docker)

```bash
claude mcp add github -e GITHUB_PERSONAL_ACCESS_TOKEN=YOUR_GITHUB_PAT -- docker run -i --rm -e GITHUB_PERSONAL_ACCESS_TOKEN ghcr.io/github/github-mcp-server
```

Using environment variable:
```bash
claude mcp add github -e GITHUB_PERSONAL_ACCESS_TOKEN=$(grep GITHUB_PAT .env | cut -d '=' -f2) -- docker run -i --rm -e GITHUB_PERSONAL_ACCESS_TOKEN ghcr.io/github/github-mcp-server
```

#### Direct Binary Install

1. Download binary from [release page](https://github.com/github/github-mcp-server/releases)
2. Add to PATH
3. Add configuration:

```bash
claude mcp add-json github '{"command": "github-mcp-server", "args": ["stdio"], "env": {"GITHUB_PERSONAL_ACCESS_TOKEN": "YOUR_GITHUB_PAT"}}'
```

### Claude Desktop

Claude Desktop requires Docker-based local server

**Configuration File Location:**
- macOS: `~/Library/Application Support/Claude/claude_desktop_config.json`
- Windows: `%APPDATA%\Claude\claude_desktop_config.json`
- Linux: `~/.config/Claude/claude_desktop_config.json`

**Add Configuration:**

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

Restart Claude Desktop after configuration

## Verification

```bash
# Check installed MCP server list
claude mcp list

# GitHub MCP server details
claude mcp get github
```

## Personal Access Token Issuance

1. GitHub Settings → Developer settings → Personal access tokens → Tokens (classic)
2. Generate new token (classic)
3. Scopes: `repo` permission required
4. Save token securely after generation

## Troubleshooting

### Docker Pull Failure

```bash
docker logout ghcr.io
docker pull ghcr.io/github/github-mcp-server
```

### MCP Server Reconfiguration

```bash
# Remove existing configuration
claude mcp remove github

# Add again
claude mcp add github ...
```

### Log Check

**Claude Code:**
- Use `/mcp` command

**Claude Desktop:**
- macOS: `~/Library/Logs/Claude/mcp-server-*.log`
- Windows: `%APPDATA%\Claude\logs\`

## Cautions

- npm package `@modelcontextprotocol/server-github` deprecated since April 2025
- Claude Desktop reported Docker-based MCP server compatibility issues
- Remote server requires Claude version supporting Streamable HTTP

## Configuration Scope

Can specify MCP configuration scope in Claude Code:

- `-s user`: Use across all projects
- `-s project`: Share with `.mcp.json` file
- Default: local (current project only)

## References

- [GitHub MCP Server Repository](https://github.com/github/github-mcp-server)
- [Model Context Protocol Documentation](https://modelcontextprotocol.io/)
- [GitHub Personal Access Tokens](https://github.com/settings/tokens)
