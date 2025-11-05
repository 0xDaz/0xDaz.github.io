---
title: "Claude Code Hardcore 6-Month Guide - 300K LOC Refactoring Tips"
description: "6-month Claude Code experience from Reddit user and my development setup. Skill automation, hook system, and dev docs workflow."
pubDate: 2025-01-06T02:00:13+09:00
tags: ["claude-code", "ai-coding", "workflow", "productivity", "automation", "tdd"]
categories: ["AI"]
draft: false
---

## Intro

Found an interesting post on Reddit. A developer successfully refactored **300K LOC (Lines of Code)** over 6 months using Claude Code. Curious about how they completed massive migrations **solo** - React 16 JS → React 19 TypeScript, Material UI v4 → MUI v7, etc.

[Reddit Original](https://www.reddit.com/r/ClaudeCode/comments/1oivs81/claude_code_is_a_beast_tips_from_6_months_of/) | [GitHub](https://github.com/diet103/claude-code-infrastructure-showcase)

This post consolidates core tips from the Reddit user (diet103) with my development setup to provide actionable know-how for immediate application.

## Core Insights

### What All Power Users Have in Common

1. **Planning is Everything** - "90% failure rate without planning"
2. **Skill + Hook Combo** - Skills are decoration without auto-activation
3. **Token Optimization** - Just-In-Time loading, MCP minimization, symbol-based navigation
4. **Separation of Concerns** - Skills (how to code) vs CLAUDE.md (project specific)
5. **Dev Docs System** - Solution to Claude's amnesia

## Reddit User's Game Changers

### 1. Skill Auto-Activation System

**Problem**: Anthropic released skill features, but Claude doesn't use them automatically

**Solution**: TypeScript hooks + centralized skill-rules.json config

```json
{
  "backend-dev-guidelines": {
    "type": "domain",
    "enforcement": "suggest",
    "priority": "high",
    "promptTriggers": {
      "keywords": ["backend", "controller", "service", "API", "endpoint"],
      "intentPatterns": [
        "(create|add).*?(route|endpoint|controller)",
        "(how to|best practice).*?(backend|API)"
      ]
    },
    "fileTriggers": {
      "pathPatterns": ["backend/src/**/*.ts"],
      "contentPatterns": ["router\\.", "export.*Controller"]
    }
  }
}
```

**How It Works**:
- **UserPromptSubmit Hook**: Analyzes prompt keywords → Auto-injects relevant skills
- **Stop Event Hook**: Analyzes edited files → Detects risky patterns → Self-check notification

**Results**:
- ❌ Before: Manual "Check BEST_PRACTICES.md" request every time
- ✅ After: Consistent patterns auto-applied, maintained consistency across 300K LOC

**Token Efficiency**: Main file <500 lines + progressive disclosure with resource files → 40-60% token savings

### 2. Dev Docs System

Claude is "an extremely confident junior developer with severe amnesia"

**Starting Large Tasks**:
```bash
mkdir -p ~/git/project/dev/active/[task-name]/
```

**3 Required Documents**:
- `[task-name]-plan.md` - Approved plan
- `[task-name]-context.md` - Key files, decisions
- `[task-name]-tasks.md` - Task checklist

**Resuming Work**:
- Check existing work in `/dev/active/`
- Read all 3 files before proceeding
- Update "last updated" timestamp

**Planning Process**: Use strategic-plan-architect agent
- Gather context → Analyze project structure → Generate structured plan
- Auto-generate 3 documents
- ⚠️ **Must Review** - Claude may misunderstand critical parts

### 3. PM2 Process Management

**Problem**: Running 7 backend microservices simultaneously, Claude can't access logs

**Solution**: Manage all services with PM2

```javascript
// ecosystem.config.js
module.exports = {
  apps: [
    {
      name: 'form-service',
      script: 'npm',
      args: 'start',
      cwd: './form',
      error_file: './form/logs/error.log',
      out_file: './form/logs/out.log',
    },
    // ... 6 more
  ]
};
```

**Comparison**:

**Before PM2**:
- Me: "Error in email service"
- Me: [Manually find log, copy → paste into chat]

**After PM2**:
- Me: "Error in email service"
- Claude: `pm2 logs email --lines 200`
- Claude: "Found database connection timeout issue"
- Claude: `pm2 restart email`

### 4. Hook System Pipeline

**Hook #1: File Edit Tracker**
- Runs after every Edit/Write operation
- Records file, repository, timestamp

**Hook #2: Build Checker**
- Runs after Claude response completes
- Edit log → Check affected repositories → Run build scripts
- Errors < 5: Show to Claude
- Errors ≥ 5: Recommend auto error resolver agent

**Hook #3: Prettier Formatter** ⚠️
- Auto-format all edited files
- **Warning**: Can consume 160k tokens in just 3 rounds (currently not recommended)

**Hook #4: Error Handling Notification**
- Display gentle reminder when risky patterns detected

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📋 Error Handling Self-Check
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

⚠️  Backend Changes Detected
   2 files edited

   ❓ Add Sentry.captureException() to catch blocks?
   ❓ Verify Prisma operations wrapped in error handling?

   💡 Backend Best Practices:
      - All errors captured by Sentry
      - Controllers extend BaseController
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

**Complete Pipeline**:
1. Claude response completes
2. Hook 1: Prettier formatter
3. Hook 2: Build checker → Instantly find TypeScript errors
4. Hook 3: Error notification
5. Errors found → Claude sees and fixes
6. Result: Clean, formatted, error-free code

### 5. CLAUDE.md and Skills Evolution

**Moved to Skills** (how to code):
- TypeScript standards
- React patterns
- Backend API patterns
- Error handling
- Database patterns
- Testing guidelines
- Performance optimization

**Kept in CLAUDE.md** (~200 lines):
- Quick commands
- Service-specific configs
- Task management workflow
- Authenticated route testing
- Workflow dry-run mode
- Browser tool setup

**New Structure**:
```
Root CLAUDE.md (100 lines)
├── Important universal rules
├── Point to repo-specific claude.md files
└── Reference skills for detailed guidelines

Each repo's claude.md (50-100 lines)
├── PROJECT_KNOWLEDGE.md - Architecture & integrations
├── TROUBLESHOOTING.md - Common issues
└── Auto-generated API docs
```

**Key Point**: Skills are "how to code", CLAUDE.md is "how this project works"

## My Development Setup

### Claude Hook System

**PreToolUse** (Block risky commands):
- Block `git push`, `p4 submit`, `terraform apply`, `kubectl delete`
- Auto-run `p4 edit` on file modifications
- Check SPEC/TODO document creation before code Write/Edit

**PostToolUse** (Quality control):
- Gentle reminder to check Test, Linter execution

**SubagentStop** (Validation):
- Verify implementation matches SPEC/TODO (coding subagent only)

### Session Management

Default compact command inefficiency led to custom commands:

```bash
/save -> /clear -> /load
```

Context management via temporary session file write/load

### Prompt Optimization

**CLAUDE.md Strategy**:
- Write as compact as possible per Anthropic official guide
- Main agent acts only as orchestrator
- Individual subagents work in their own context

**Document Loading Strategy**:
- Architecture, service, environment docs use Just-In-Time load instead of @ reference
- Only briefly specify path and description

**MCP Optimization**:
- MCP consumes tokens on Load → Replace with skills or minimize activation
- Activated MCPs: Context7, Serena MCP
- **Serena MCP**: Token savings via **LSP-based symbol navigation** instead of direct Read when exploring codebase

### Automation

**Prompt Evaluation Agent**:
- Synthesize prompt-related docs from reliable sources
- Generate rules → Configure prompt evaluation agent

**Claude Skill**:
- Configure as skills whenever automation needed or executable as code

**Claude Syntax Learning**:
- Ironic that Claude doesn't know hook system, skill schema well
- Solution: Find docs in Context7 and inject context

## Absolute Importance of Planning

The one truth all Claude Code power users emphasize:

> **The planning phase is tremendously important**

### Core Principles

- User must actively engage in planning phase
- Claude Code can't yet 100% understand domain knowledge and workflows in our heads
- Room for misinterpretation exists from natural language
- Must eliminate wrong branch points in early stage

### Current Issues

- Can't see when subagent plans
- Cancel loses all content
- Most important stage but highest risk when hands-off watching

### Solutions Under Consideration

Separate agent for Discussion, execute plan in main agent

## Common Insights & Lessons

### Common Ground with Reddit User

✅ Power of Skill + Hook combo
✅ Absolute importance of planning phase
✅ Code review automation
✅ Process management tools like PM2
✅ Specialized agent utilization
✅ Token optimization strategy

### Differentiation Points

**Reddit User**:
- Centralized skill-rules.json config
- UserPromptSubmit + Stop event hooks
- Dev docs system (plan, context, tasks)
- strategic-plan-architect agent
- 850+ markdown documents

**My Setup**:
- P4 (Perforce) integration
- LSP-based navigation via Serena MCP
- SPEC/TODO document-centric development
- Risky command blocking system
- /save, /load custom commands

### Token Optimization Strategies

1. **Minimize MCP** - Activate only what's necessary
2. **Just-In-Time Loading** - Only when needed instead of @ reference
3. **Symbol-Based Navigation** - Use LSP with Serena MCP
4. **Progressive Disclosure** - Main 500 lines + separate resource files
5. **Prettier Hook Caution** - Can consume 160k tokens

## Conclusion

### Must-Haves

✅ **Plan - Plan - Plan** - Failure without planning
✅ **Skill + Hooks** - Auto-activation is the only way skills work
✅ **Dev Docs System** - Prevent Claude from getting lost
✅ **Code Review** - Make Claude review own work
✅ **Process Management** - Make debugging tolerable with PM2

### Nice-to-Haves

- Specialized agents for common tasks
- Slash commands for repeated workflows
- Comprehensive documentation
- Utility scripts linked to skills
- Memory MCP for decisions

### Key Takeaway

Reddit user built skill auto-activation system with TypeScript hooks, created dev docs workflow, implemented PM2 + auto error checking. Result: **Solo rewriting of 300K LOC with consistent quality in 6 months**

I automated risky command blocking and quality control with Hook System, token savings with Serena MCP + LSP, strengthened planning phase with SPEC/TODO document-centric development.

Common ground: **Strengthen planning phase + Skill/Hook combo + Token optimization + Automation**

## References

- [Reddit Original - Claude Code is a beast: Tips from 6 months of hardcore use](https://www.reddit.com/r/ClaudeCode/comments/1oivs81/claude_code_is_a_beast_tips_from_6_months_of/)
- [GitHub - claude-code-infrastructure-showcase](https://github.com/diet103/claude-code-infrastructure-showcase)
- [Anthropic Claude Code Official Docs](https://docs.anthropic.com/claude/docs)
