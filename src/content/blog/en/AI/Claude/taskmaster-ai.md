---
title: "Taskmaster AI: Task Management System for AI-Driven Development"
pubDate: 2025-10-25T01:45:00+09:00
tags: ["Claude", "MCP", "Taskmaster", "Task Management", "AI Development", "Cursor", "Claude Code"]
categories: ["AI"]
keywords: ["TaskMaster AI", "AI Project Management", "Task Automation", "Claude Code", "MCP", "Cursor", "PRD Parsing", "AI Development", "Task Management", "Project Automation"]
draft: false
---


## Overview

Taskmaster AI is task management system for AI-driven development

Perfectly integrated with AI editors like Cursor and Claude Code, automates PRD parsing to task expansion and dependency management

Can systematically manage complex projects with just prompts

## Key Features

### 1. Auto PRD Parsing
- Read text PRD docs and auto-generate tasks
- AI analyzes project complexity to determine appropriate task count
- Auto-generate priority, dependencies, test strategy per task

### 2. Smart Task Expansion
- Auto-generate subtasks based on complexity analysis
- Expand single task or batch expand all
- Research mode reflects latest best practices

### 3. Task Scope Adjustment
- `scope-up`: Increase task complexity
- `scope-down`: Decrease task complexity
- Choose Light, Regular, Heavy intensity

### 4. Research Mode
- Query latest info via Perplexity AI integration
- Customized research including project context
- Auto-attach to tasks

### 5. Tag System
- Task management per Git branch
- Support task move/copy between tags
- Maintain/remove dependencies option

### 6. TDD Autopilot (Beta)
- Automate RED-GREEN-COMMIT cycle
- Verify test results and auto-commit
- Auto-create/manage Git branches

## Requirements

Minimum 1 API key required (choose one):

- Anthropic API Key (Claude)
- OpenAI API Key
- Google Gemini API Key
- Perplexity API Key (Research mode)
- xAI API Key
- OpenRouter API Key
- Claude Code CLI (no API key needed)
- Codex CLI (ChatGPT subscription OAuth)

## Installation

### Cursor One-Click Install

[Taskmaster AI MCP Install](https://smithery.ai/server/@upstash/taskmaster-ai)

Need to replace API keys with actual values after install

### Claude Code CLI

```bash
claude mcp add taskmaster-ai -- npx -y task-master-ai
```

### Manual Install

**Cursor/Windsurf** (`~/.cursor/mcp.json` or `~/.codeium/windsurf/mcp_config.json`):

```json
{
  "mcpServers": {
    "task-master-ai": {
      "command": "npx",
      "args": ["-y", "task-master-ai"],
      "env": {
        "ANTHROPIC_API_KEY": "YOUR_ANTHROPIC_API_KEY",
        "PERPLEXITY_API_KEY": "YOUR_PERPLEXITY_API_KEY"
      }
    }
  }
}
```

### Tool Loading Optimization

Adjust context window usage:

```json
{
  "env": {
    "TASK_MASTER_TOOLS": "core"
  }
}
```

**Options:**
- `all` (default): 36 tools, ~21,000 tokens
- `standard`: 15 tools, ~10,000 tokens
- `core` or `lean`: 7 tools, ~5,000 tokens

## Initial Setup

### 1. Project Initialize

In AI chat:
```
Initialize taskmaster-ai in my project
```

Or CLI:
```bash
task-master init --rules cursor,windsurf
```

### 2. Model Configuration

```
Change the main, research and fallback models to claude-sonnet-4, perplexity-sonar-pro, gpt-4o respectively
```

For Claude Code:
```
Change the main model to claude-code/sonnet
```

### 3. Write PRD

Write requirements in `.taskmaster/docs/prd.txt`

Refer to `.taskmaster/templates/example_prd.txt` for example template

## Usage Examples

### Parse PRD

```
Can you parse my PRD at .taskmaster/docs/prd.txt?
```

### Check Next Task

```
What's the next task I should work on?
```

### Implement Task

```
Can you help me implement task 3?
```

### Expand Task

```
Can you help me expand task 4?
```

### Complexity Analysis

```
Analyze the complexity of all pending tasks
```

### Research

```
Research the latest best practices for implementing JWT authentication with Node.js
```

With specific file context:
```
Research React Query v5 migration strategies for our current API implementation in src/api.js
```

## Real Usage Example

Task management case from DNDLite Unity project:

```
> Show Task Master status

● Checking current Task Master status

● Overall Progress

  - Completed: 4/30 tasks (13.3%)
  - In Progress: 0
  - Pending: 26
  - Subtasks: 5/5 completed (100%)

  ✅ Completed Tasks

  Task 1: Setup Unity Project Structure ✓
  Task 2: Implement Core Singletons ✓
  Task 3: Create Player Character Controller ✓
  Task 5: Create Basic Projectile Weapon System ✓ (Just finished!)

  - Subtasks (5/5 completed):
    - 5.1: WeaponBase Abstract Class ✓
    - 5.2: Projectile Component with Physics ✓
    - 5.3: Automatic Targeting System ✓
    - 5.4: Fire Rate Timer and Weapon Stats ✓
    - 5.5: Object Pooling and Visual Effects ✓

  🎯 Next Recommended Task

  Task 4: Implement Object Pooling System
  - Priority: High
  - Complexity: 5
  - Dependencies: Task 2
```

Example shows Unity game project with 30 tasks:
- 4 tasks completed (project structure, core systems, player controller, weapon system)
- All 5 subtasks completed (detailed weapon system implementation)
- Recommends object pooling system as next task
- Auto-suggests task order based on dependencies

## CLI Commands

```bash
# Project initialize
task-master init

# Parse PRD
task-master parse-prd your-prd.txt

# List tasks
task-master list

# Next task
task-master next

# Show specific tasks
task-master show 1,3,5

# Expand task
task-master expand --id=5 --num=8

# Expand all tasks
task-master expand-all

# Analyze complexity
task-master analyze

# Research
task-master research "latest Next.js 15 features"

# Tag management
task-master tags list
task-master tags add feature-auth

# Change task status
task-master status --id=5 --status=done
```

## TDD Autopilot Workflow

```bash
# Start workflow
task-master autopilot start --task-id=5

# Check next step
task-master autopilot next

# Complete phase after test run
task-master autopilot complete-phase --test-results='{"total":10,"passed":0,"failed":10}'

# Commit
task-master autopilot commit

# Finalize workflow
task-master autopilot finalize
```

## Project Structure

```
.taskmaster/
├── config.json           # Project settings
├── tasks/
│   ├── tasks.json        # All task data
│   └── 01.md             # Individual task files
├── docs/
│   ├── prd.txt           # Requirements doc
│   └── research/         # Research results
└── reports/
    └── task-complexity-report.json
```

## Task Structure

```json
{
  "id": 1,
  "title": "Task title",
  "description": "Task description",
  "details": "Implementation details",
  "status": "pending",
  "priority": "high",
  "dependencies": [2, 3],
  "testStrategy": "Test strategy",
  "subtasks": [
    {
      "id": "1.1",
      "title": "Subtask",
      "status": "done"
    }
  ]
}
```

**Status values:**
- `pending`: Waiting
- `in-progress`: In progress
- `review`: Review
- `done`: Completed
- `deferred`: Deferred
- `cancelled`: Cancelled

## Troubleshooting

### Initialize Failure

```bash
# Run directly with Node.js
node node_modules/task-master-ai/scripts/init.js
```

### MCP Server Reconfigure

```bash
# Remove existing
claude mcp remove taskmaster-ai

# Re-add
claude mcp add taskmaster-ai -- npx -y task-master-ai
```

### Model Change Not Applied

Check if API keys are in `env` section of MCP config

Or add to `.env` file in project root

## License

MIT License with Commons Clause

**Allowed:**
- Personal, commercial, academic use
- Modify code
- Distribute copies
- Create and sell products based on Taskmaster

**Prohibited:**
- Sell Taskmaster itself
- Provide hosting service
- Create competing products

## References

- [GitHub Repository](https://github.com/eyaltoledano/claude-task-master)
- [Official Documentation](https://github.com/eyaltoledano/claude-task-master/tree/main/docs)
- [Discord Community](https://discord.gg/taskmaster)
- [Smithery Install](https://smithery.ai/server/@upstash/taskmaster-ai)
