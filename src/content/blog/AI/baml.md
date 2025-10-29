---
title: "BAML - AI Prompts as Type-Safe Functions"
pubDate: 2025-10-25T01:30:00+09:00
tags: ["AI", "LLM", "BAML", "Tool", "Prompt Engineering"]
categories: ["AI"]
keywords: ["BAML", "Type-Safe Prompts", "Prompt Engineering", "AI LLM", "Claude Code", "Type Safety", "Function-based Prompts", "AI Development", "Python", "TypeScript"]
draft: false
---


## Overview

**BAML** (Basically a Made-up Language) is a prompting language for building reliable AI workflows

Core principle: Treat LLM prompts as functions with typed inputs and outputs

## Problems with Traditional Approach

Most developers write prompts with f-strings

```python
# Problematic approach
prompt = f"Analyze this text: {user_input}"
response = llm.generate(prompt)
```

**Key Problems:**

1. **No Type Safety** - Can't catch errors until runtime
2. **Hard to Maintain** - Prompts mixed with code
3. **Difficult to Test** - Can't test prompts without running entire app
4. **Not Reusable** - Can't share across languages
5. **Version Control Issues** - Complex change tracking

## BAML's Solution

### Type Safety

```baml
class Sentiment {
  emotion string
  confidence float
}

function AnalyzeText(text: string) -> Sentiment {
  client GPT4
  prompt #"
    Analyze the sentiment of: {{ text }}
    Return emotion and confidence score.
  "#
}
```

Provides IDE autocomplete and compile-time type checking

### Separated Structure

Manage prompts in separate `.baml` files

Separating code and prompts improves readability and maintainability

### Instant Testing

Test prompts in VSCode playground without running app

Immediately verify changes and speed up iteration

### Multi-Language Support

Use same BAML file across Python, TypeScript, Ruby, Go

```python
# Python
from baml_client import b

result = b.AnalyzeText("I love this!")
print(result.emotion)
```

```typescript
// TypeScript
import { b } from './baml_client'

const result = await b.AnalyzeText("I love this!")
console.log(result.emotion)
```

### Streaming Support

Type-safe partial update streaming

```python
async for partial in b.stream.AnalyzeText("Long text..."):
    if partial.emotion:
        print(f"Current emotion: {partial.emotion}")
```

### Easy Model Switching

Change LLM model in one line

```baml
function AnalyzeText(text: string) -> Sentiment {
  client Claude  // Changed from GPT4 to Claude
  prompt #"..."#
}
```

## Unity Game Development Use Cases

### NPC Dialogue Generation

```baml
class NPCDialogue {
  text string
  emotion string
  action string?
}

function GenerateNPCResponse(
  context: string,
  player_action: string
) -> NPCDialogue {
  client GPT4
  prompt #"
    NPC context: {{ context }}
    Player did: {{ player_action }}
    Generate appropriate response with emotion and optional action.
  "#
}
```

### Dynamic Quest Generation

Auto-generate quests matching player level and progress

Type safety ensures safe integration with game logic

### Player Behavior Analysis

Analyze player patterns for difficulty adjustment and personalized experience

### Game Balance Suggestions

Analyze game data to generate balance improvement suggestions

## Development Tool Use Cases

### Code Review Automation

```baml
class CodeReview {
  issues string[]
  suggestions string[]
  severity string
}

function ReviewCode(code: string) -> CodeReview {
  client GPT4
  prompt #"
    Review this code and provide:
    - List of issues
    - Improvement suggestions
    - Overall severity (low/medium/high)

    Code: {{ code }}
  "#
}
```

### Documentation Generation

Auto-generate documentation from code

Type safety ensures consistent format

### Bug Analysis

Analyze error logs and stack traces to identify causes and suggest solutions

## Key Advantages Summary

- **Complete Type Safety** - IDE autocomplete and compile-time checks
- **Separated File Structure** - Clean organization with `.baml` files
- **Instant Testing** - VSCode playground
- **Multi-Language Support** - Python, TypeScript, Ruby, Go
- **Type-Safe Streaming** - Partial update support
- **Easy Model Switching** - Change LLM in one line
- **Open Source** - Apache 2.0 license

## References

- [BAML Official Site](https://www.boundaryml.com/)
- [BAML GitHub](https://github.com/BoundaryML/baml)
- [BAML Documentation](https://docs.boundaryml.com/)
