---
title: "Building Unity Game Development Automation with Claude Code"
pubDate: 2025-10-25T14:30:00+09:00
tags: ["Unity", "GameDev", "ClaudeCode", "MCP", "Automation", "Steam", "CI/CD"]
categories: ["GameDev"]
keywords: ["Unity Game Development", "Claude Code", "GameDev Automation", "MCP", "Unity3D", "C#", "Steam", "Bullet Heaven", "Game Development AI", "CI/CD"]
draft: false
---


## Overview

Automate Unity 3D game development pipeline with ClaudeCode + MCP servers + specialized agents

Designed for bullet heaven genre Steam game project, automating from design to deployment

## Agent Configuration

7 specialized agents handle domain-specific tasks

### 1. unity-client-dev

Unity implementation expert

- Context7-based latest API application
- OOP/SOLID principles compliance
- Direct Unity Editor control via UnityMCP

### 2. unity-asset-finder

Asset Store search automation

- Real-time search with Playwright
- Review analysis and recommendations
- Price/license information collection

### 3. game-design-expert

Vampire survivors-like genre mechanic design

- Balancing simulation
- Steam integration planning
- Progression system design

### 4. game-project-manager

Project management automation

- Linear ↔ Task Master sync
- PRD parsing and task breakdown
- TDD workflow management

### 5. blog-manager

Hugo blog auto-writing

- Markdown generation
- Style guide compliance
- Image path auto-handling

### 6. git-expert

Git operations specialist

- Unity .meta file auto-management
- Branch strategy planning
- Conflict resolution

### 7. prompt-engineer

Agent prompt optimization

- 20-40% token reduction
- Performance evaluation and improvement
- Agent consistency maintenance

## MCP Server Configuration

7 MCP servers for external tool integration

```yaml
Linear (HTTP):
  - Issue, project, cycle management
  - Team collaboration central hub

GitHub (HTTP):
  - Issue, PR, commit management
  - Code search and review

Playwright (stdio):
  - Browser automation
  - Asset Store crawling
  - Screenshot-based testing

Context7 (stdio):
  - Real-time library documentation search
  - Unity, Hugo, Steam API latest info
  - API change detection

mcp-obsidian (Python):
  - Obsidian note management
  - Auto dev log recording

UnityMCP (Python):
  - Direct Unity Editor control
  - Scene, GameObject, Script management
  - Auto compile error collection

task-master-ai (stdio):
  - Local task breakdown
  - Status tracking
  - TDD workflow automation
```

## Workflow Tree

```
User Request
│
├─ Game Design
│  └─ game-design-expert
│     ├─ game-project-manager (task breakdown)
│     └─ blog-manager (documentation)
│
├─ Unity Implementation
│  └─ unity-client-dev
│     ├─ context7 (API check)
│     ├─ UnityMCP (Editor control)
│     ├─ git-expert (commit)
│     └─ game-project-manager (status update)
│
├─ Asset Search
│  └─ unity-asset-finder
│     ├─ playwright (crawling)
│     └─ blog-manager (recommendation post)
│
├─ Project Management
│  └─ game-project-manager
│     ├─ linear (external issues)
│     ├─ task-master-ai (local tasks)
│     └─ git-expert (branch management)
│
├─ Blog Posting
│  └─ blog-manager
│     ├─ context7 (Hugo API)
│     └─ git-expert (deployment)
│
├─ Git Operations
│  └─ git-expert
│     └─ github (remote operations)
│
└─ Agent Optimization
   └─ prompt-engineer
      └─ git-expert (commit changes)
```

## Core Integration Patterns

### 1. Context-First

Check latest API with Context7 before Unity/Hugo implementation

```python
# Bad: Knowledge-based implementation
def CreatePlayer():
    GameObject.Instantiate(playerPrefab)

# Good: Implementation after Context7 check
1. resolve-library-id("Unity")
2. get-library-docs(library_id, topic: "GameObject lifecycle")
3. Implement with latest API
```

### 2. Dual-Tracking

Linear (external) + Task Master (local) dual tracking

```yaml
Linear:
  - Team shared issues
  - Milestone management
  - External collaboration

Task Master:
  - Local task breakdown
  - TDD workflow
  - Personal progress tracking
```

### 3. Unity Workflow

```mermaid
Context7 → UnityMCP → git-expert → blog-manager
```

1. Check API with Context7
2. Create Scene/Script with UnityMCP
3. Commit with .meta files via git-expert
4. Document feature with blog-manager

### 4. Agent Orchestration

CLAUDE.md analyzes request and calls appropriate agent

```yaml
Request Classification:
  Game Design: game-design-expert
  Unity Implementation: unity-client-dev
  Asset Search: unity-asset-finder
  Project Management: game-project-manager
  Blog Writing: blog-manager
  Git Operations: git-expert
  Prompt Improvement: prompt-engineer
```

## Automation Levels

### L1: Direct Unity Editor Control

Manage Scene, GameObject, Component with UnityMCP

```csharp
// UnityMCP command
manage_gameobject(
  action="create",
  name="Player",
  components_to_add=["Rigidbody", "PlayerController"]
)
```

### L2: External Tool Integration

Automated Linear, GitHub, Asset Store operations

```python
# Linear issue creation → Task Master task breakdown
linear.create_issue(title="Implement player movement")
task_master.parse_prd(issue_description)
```

### L3: Documentation/Code Generation

Context7-based latest API application

```python
# Check documentation before implementation
context7.get_library_docs(
  library_id="/unity/docs",
  topic="CharacterController"
)
```

### L4: Task Breakdown/Tracking

Task Master + Linear synchronization

```yaml
PRD → Task Master:
  - Create 10 main tasks
  - Break each main task into 5-10 subtasks
  - Sync with Linear issue IDs
  - Auto-proceed with TDD workflow
```

## Safety Mechanisms

### API Change Detection with Context7

```python
# Always check before implementation
if using_unity_api:
    context7.resolve_library_id("Unity")
    latest_docs = context7.get_library_docs(topic="specific_feature")
    apply(latest_docs)
```

### git-expert Auto .meta File Management

```yaml
Unity Rules:
  - .meta file required for all assets
  - Always commit .meta to preserve GUID
  - Never add .meta to .gitignore
  - git-expert handles automatically
```

### prompt-engineer Token Optimization

```yaml
Optimization Items:
  - Remove duplicate instructions
  - 20-40% token reduction
  - Cost savings without performance loss
  - Maintain agent consistency
```

### Central CLAUDE.md Rule Reference

```yaml
All Agents:
  - CLAUDE.md top priority compliance
  - Domain expertise demonstration
  - Agent collaboration protocol
  - Consistent code style
```

## Conclusion

Single request automates design → implementation → test → commit → documentation

```bash
# User request example
"Implement player movement system"

# Auto-execution flow
1. game-design-expert: Design movement mechanics for vampire survivors genre
2. game-project-manager: Create Linear issue, break down Task Master tasks
3. unity-client-dev: Check CharacterController API with Context7
4. unity-client-dev: Create PlayerController script with UnityMCP
5. git-expert: Commit with .meta files
6. blog-manager: Write "Player Movement Implementation" post
7. game-project-manager: Update Linear/Task Master status
```

Effectiveness to be verified in actual game development

## References

- [ClaudeCode Official Docs](https://claude.ai/code)
- [MCP Server List](https://github.com/modelcontextprotocol/servers)
- [Unity MCP](https://github.com/unitymcp/unitymcp)
- [Task Master AI](https://github.com/cyanheads/task-master)
