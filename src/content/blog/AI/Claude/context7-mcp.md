---
title: "Context7 MCP: Inject Latest Docs into AI Coding Assistant"
description: "MCP server that injects real-time library documentation into LLMs. Eliminates AI hallucination by providing accurate API references and code examples."
pubDate: 2025-10-25T01:30:00+09:00
tags: ["Claude", "MCP", "Context7", "Claude Code", "Claude Desktop", "Cursor", "Windsurf"]
categories: ["AI"]
keywords: ["Context7", "MCP Server", "Claude Code", "Real-time Documentation", "AI Coding", "Cursor IDE", "Windsurf", "Claude Desktop", "Model Context Protocol", "API Documentation"]
draft: false
---


## Overview

Context7 MCP is Model Context Protocol server that injects latest library documentation into LLMs in real-time

AI performs work referencing current version's accurate documentation and code examples, not old training data

Can generate accurate code without hallucination just by adding `use context7` to prompt

## Existing Problems

### AI Coding Limitations

- Based on 1-2 year old training data
- Generates outdated API examples
- Confidently recommends non-existent functions
- Doesn't reflect latest library changes

### Context7 Solution

Inject library documentation into prompt in real-time

Reference accurate version-specific APIs

Provide structured latest code examples

## Key Features

### 1. Real-time Doc Injection
- Auto-search latest version-specific docs
- Direct insertion into prompt context
- No tab switching needed

### 2. Accurate Code Generation
- Eliminate hallucination
- Use actually working APIs
- Reflect best practices

### 3. Simple Usage
- Add `use context7` to prompt
- Or set auto-execution rules
- Can directly specify library ID

## Requirements

- Node.js >= v18.0.0
- MCP client (Cursor, Claude Code, VS Code, etc.)
- Context7 API Key (optional, for higher rate limit)

## Installation

### Cursor

Add to `~/.cursor/mcp.json`:

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

### Smithery One-Click Install

Immediate install with Install MCP Server button in Cursor 1.0+

## Core Tools

### resolve-library-id
Convert regular library name to Context7 compatible ID

**Parameters:**
- `libraryName` (required): Library name

### get-library-docs
Fetch library documentation

**Parameters:**
- `context7CompatibleLibraryID` (required): Context7 compatible ID (e.g. `/mongodb/docs`)
- `topic` (optional): Filter by specific topic (e.g. "routing", "hooks")
- `tokens` (optional): Max tokens to return (default 5000)

## Usage Examples

### Basic Usage

```
Create a Next.js middleware that checks for a valid JWT in cookies
and redirects unauthenticated users to `/login`. use context7
```

Context7 automatically:
1. Search latest Next.js docs
2. Extract JWT auth-related docs
3. Generate code based on latest API

### Direct Library ID

```
Implement basic authentication with Supabase.
use library /supabase/supabase for API and docs.
```

Skip library matching step, directly load docs

### Auto-Execution Rules

Add to `.windsurfrules` (Windsurf) or `CLAUDE.md` (Claude Code):

```
Always use context7 when I need code generation, setup or configuration steps,
or library/API documentation. This means you should automatically use the
Context7 MCP tools to resolve library id and get library docs without me
having to explicitly ask.
```

Context7 automatically works on all code-related questions thereafter

## Environment Variables

Can manage API Key as environment variable:

```bash
# .env
CONTEXT7_API_KEY=your_api_key_here
```

MCP configuration:
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

## Proxy Configuration

In HTTPS proxy environment, use standard environment variables:

```bash
export https_proxy=http://proxy.example.com:8080
export HTTPS_PROXY=http://proxy.example.com:8080
```

## CLI Options

### Transport Mode
```bash
--transport <stdio|http>
```
- `stdio`: Default
- `http`: Auto-provide HTTP and SSE endpoints

### Port Specification (HTTP mode)
```bash
--port <number>
```
Default: 3000

### API Key
```bash
--api-key <key>
```

**Usage Examples:**
```bash
# HTTP transport, port 8080
npx @upstash/context7-mcp --transport http --port 8080

# stdio transport, specify API key
npx @upstash/context7-mcp --transport stdio --api-key YOUR_API_KEY
```

## Verification

```bash
# Check MCP server list
claude mcp list

# Context7 details
claude mcp get context7
```

## Supported Platforms

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
- Other MCP-compatible clients

## API Key Issuance (Optional)

Issue API Key for higher rate limit and private repository access:

1. Visit [context7.com/dashboard](https://context7.com/dashboard)
2. Create account (free)
3. Issue and copy API Key
4. Add to MCP configuration

## Troubleshooting

### Module Not Found Error
Check Node.js version (v18+ required):
```bash
node --version
```

### ESM Resolution Issues
Add `"type": "module"` to package.json or update Node.js

### TLS/Certificate Issues
Check proxy settings or `NODE_TLS_REJECT_UNAUTHORIZED=0` (dev environment only)

## Project Contribution

Context7 is community contribution project

Can add new libraries

Refer to [Project Addition Guide](https://github.com/upstash/context7)

## Cautions

### SSE Protocol Support Ended
- Server-Sent Events transport method deprecated
- HTTP or stdio recommended
- Will be removed in future release

### Security
- Keep API Key secure
- Don't commit to public repositories
- Use environment variables or secure storage

### Community Project
- Doc accuracy not guaranteed
- Use Report button for suspicious content
- Use own judgment

## References

- [Context7 Official Site](https://context7.com)
- [Context7 GitHub](https://github.com/upstash/context7)
- [Context7 Dashboard](https://context7.com/dashboard)
- [Model Context Protocol](https://modelcontextprotocol.io/)
- [Discord Community](https://discord.gg/context7)
