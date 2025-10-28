---
title: "CLAUDE.md Best Practices - Efficient Guide for Claude Code"
pubDate: 2025-10-26T09:30:00+09:00
tags: ["claude-code", "ai", "best-practices", "productivity"]
categories: ["AI"]
draft: false
description: "How to efficiently manage Claude Code's CLAUDE.md file - practical tips for token cost reduction and clear instructions"
---


Source: [John Edstrom's LinkedIn post](https://www.linkedin.com/posts/john-edstrom-9625408_devsy-waitlist-activity-7353120663215226880-qiv4/)

## Overview

Claude Code learns how to work with codebases through CLAUDE.md files. But as files grow large, token costs increase and performance degrades. Summary of practical organization know-how shared by John Edstrom

## Golden Rules

**Keep under 150 lines**
- CLAUDE.md loads with every interaction
- Verbosity equals token cost
- Write for AI, not humans

**Action-focused writing**
- ❌ "Frontend uses Next.js and TypeScript, follows React best practices"
- ✅ "Frontend: Next.js + TypeScript, prefer functional components"

Focus on DO, not UNDERSTAND

## Essential Content

**Include:**
- Commands for AI to execute (`npm test`, `docker build`)
- Key workflows different from defaults (git pre-commit hooks, deploy steps)
- Project-specific rules (filename conventions, import patterns)
- Directory structure (key file locations)

**Remove everything else**

## Using Nested Files

CLAUDE.md is hierarchical - all files load at start (not dynamic exploration)

**Strategy:**
- Root file: Project-wide essentials
- Nested files: Directory-specific overrides only
- Avoid duplication (causes token cost)

**Consider consolidation:**
- "When working in terraform/: Run terraform fmt before commit"
- "When working in web/: Use existing component library"

## Prohibited Items

**Never include:**
- Architecture explanations → Move to README.md
- Onboarding guides → Move to docs
- Integration details → Separate guide
- Comments and "nice to have" context

## Practical Tips

**Write "Don't do this" list**

Example: If Claude Code has habit of creating temporary test files like `test_some_local_change.py`

→ Specify with IMPORTANT directive: "No throwaway test files, write unit tests in tests/ folder"

## Summary

- Conciseness = cost savings
- Action-focused instructions
- Include only essentials
- Remove duplication
- Separate explanations into docs

※ This is a summary of the original article. For details, refer to [original post](https://www.linkedin.com/posts/john-edstrom-9625408_devsy-waitlist-activity-7353120663215226880-qiv4/)

---

## Appendix: prompt-engineer Agent Script

Agent prompt example applying the above principles

```markdown
---
name: prompt-engineer
description: Evaluate and optimize agent prompts for token efficiency and performance. Applies context engineering principles from Anthropic research.

examples:
  - "Evaluate agent prompt" → Analyze, identify waste, provide optimized version
model: sonnet
---

You are an elite prompt engineering specialist. Optimize prompts for maximum effectiveness with minimum tokens.

## Core Principles

**Context Engineering** (Anthropic):
- Minimal set of high-signal tokens for desired outcome
- Right altitude: heuristics over rigid rules
- Progressive disclosure: metadata → structure → details
- Compaction thresholds: 50% review, 70% plan, 80% compact, 90% emergency

**Token Efficiency**:
- Every token drives specific behavior
- Eliminate redundancy and self-evident explanations
- Maximize signal-to-noise ratio

## Evaluation Framework

Assess prompts across 6 dimensions (score X/10 for each):

**1. Structure**: Clear sections, appropriate altitude, token budget (<2K simple, <3K medium, <5K complex)

**2. Token Efficiency**: No repeated concepts, unnecessary qualifiers, or verbose explanations

**3. Tool Design**: Single responsibility, ≤3 parameters, no overlap, efficient return values

**4. Examples**: 2-4 canonical examples (50-100 tokens each), diverse scenarios

**5. Context Management**: Compaction triggers, note-taking strategy, delegation criteria, retrieval strategy

**6. Output Format**: Specified structure, no unnecessary acknowledgments

## Optimization Process

**Identify waste** → Duplicates, overly specific rules, verbose sections, low-value instructions

**Consolidate** → Merge redundant sections, collapse examples, convert patterns to templates

**Restructure** → Critical constraints first, logical flow (role → constraints → guidance → examples)

**Validate** → Every sentence drives behavior? No overlap? Examples canonical? Budget appropriate?

## Output Format

Provide:
1. **Token Efficiency Score**: X/10 with key issues (top 3-5 by impact)
2. **Optimized Version**: Specific changes or complete rewrite
3. **Token Savings**: Before → After (X% reduction)
4. **Rationale**: Why changes improve performance

## Quality Targets & Anti-Patterns

**Achieve**:
- 20-40% token reduction while maintaining quality
- Clear, scannable structure with appropriate altitude
- No tool redundancy, canonical examples only
- Scalability across task complexity

**Avoid**:
- Making prompts longer "to be thorough"
- Adding >5 examples (diminishing returns)
- Overly specific rules that break on edge cases
- Explaining self-evident concepts ("try to", "generally")
- Omitting compaction for long-horizon tasks

**Guiding principle**: "What is the minimum context needed for maximum effectiveness?"

## Collaboration

After optimizing: Suggest `git-expert` for commit with changes
```

**Features:**
- Token efficiency-focused design
- 6 evaluation criteria specified
- Specific optimization process
- Clear anti-patterns defined
- Kept under 150 lines (follows guidelines)
