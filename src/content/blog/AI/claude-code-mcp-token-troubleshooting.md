---
title: "Claude Code MCP Server Token Troubleshooting"
pubDate: 2025-10-27T01:43:09+09:00
draft: false
tags: ["Claude Code", "MCP", "Optimization", "Troubleshooting"]
categories: ["AI"]
description: "Resolving 50k+ token consumption issue during Claude Code MCP server initial load"
---


## Problem

After connecting multiple MCP servers to Claude Code, session start consumed over 50k tokens in initial load. Continuous token usage warnings

## Initial MCP Setup

7 MCP servers initially connected:

| MCP Server | Protocol | Purpose |
|---------|---------|------|
| **Linear** | HTTP | Issue, project, cycle management - Team collaboration hub |
| **GitHub** | HTTP | Issue, PR, commit management - Code search and review |
| **Playwright** | stdio | Browser automation, Asset Store crawling, screenshot testing |
| **Context7** | stdio | Unity/Hugo/Steam API latest documentation search |
| **mcp-obsidian** | Python | Obsidian note management, dev log auto-recording |
| **UnityMCP** | Python | Direct Unity Editor control, Scene/GameObject/Script management |
| **task-master-ai** | stdio | Local task breakdown, state tracking, TDD workflow |

## Root Cause

- **Initial Context Load Cost**: All MCP servers send tool/resource info at session start
- **Duplicate Features**: GitHub MCP vs GitHub CLI, Linear vs task-master-ai overlap
- **Unused Servers**: mcp-obsidian actual utilization low
- **Always Load vs Load on Demand**: Even rarely-used features like Playwright always loaded

## Optimization Strategy

### 1. Remove Duplicates

**Linear** → Manual management + task-master-ai
- External issue tracking managed directly in Linear web
- Agent work sufficient with local task-master-ai

**GitHub MCP** → Replace with GitHub CLI(`gh`)
- Use `gh` commands instead of MCP
- Selectively call only needed features

### 2. JIT (Just-In-Time) Loading

**Playwright** → Convert to Claude Skill
- Remove from MCP, convert to `playwright-skill` Skill
- Load only when browser automation needed

### 3. Remove Unused Servers

**mcp-obsidian** → Delete
- Actual usage frequency near zero
- Manually write notes when needed

### 4. Per-Server Optimization Options

**task-master-ai** → Set `"TASK_MASTER_TOOLS": "core"`
- Lightweight mode loading only essential tools
- Provide core features only: `get_tasks`, `next_task`, `set_task_status`

## Final Configuration

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

## Results

- **Initial Token Usage**: 50k+ → Estimated reduction to under 10k
- **Essential Features Maintained**: Context7 (docs), UnityMCP (Unity control), task-master-ai (task management)
- **Flexibility Secured**: Can extend features via Skill system when needed

## Key Lessons

1. **MCP Isn't Everything**: Need diverse tool combinations - CLI, Skills, direct calls
2. **Consider Initial Load Cost**: Connecting all features via MCP increases context consumption
3. **Analyze Usage Patterns**: Distinguish always-needed vs occasionally-needed features
4. **Check Per-Server Optimization Options**: Many MCP servers provide lightweight modes
