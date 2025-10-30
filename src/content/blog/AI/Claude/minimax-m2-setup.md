---
title: "Using MiniMax M2 with Claude Code"
description: "Setup MiniMax M2 in Claude Code. 2x faster than Sonnet 4.5, 8% of the price. Anthropic API compatible. Free until November 7th."
pubDate: 2025-10-29T22:40:00+09:00
draft: false
tags: ["Claude Code", "MiniMax M2", "Setup", "Free", "API"]
categories: ["AI"]
---

## MiniMax M2

MiniMax's open-source AI model from China (Released October 2025)

**Features:**
- 2x faster than Claude Sonnet 4.5
- 8% of the price ($0.30/M input, $1.20/M output)
- Anthropic API compatible
- **Free until November 7th**

## Setup Guide

### 1. Get API Key

Create an account and obtain API key at [MiniMax Platform](https://platform.minimax.io)

### 2. Configure Settings

`.claude/settings.local.json`:

```json
{
  "env": {
    "ANTHROPIC_BASE_URL": "https://api.minimaxi.com/anthropic",
    "ANTHROPIC_AUTH_TOKEN": "<MINIMAX_API_KEY>",
    "API_TIMEOUT_MS": "3000000",
    "CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC": 1,
    "ANTHROPIC_MODEL": "MiniMax-M2",
    "ANTHROPIC_SMALL_FAST_MODEL": "MiniMax-M2",
    "ANTHROPIC_DEFAULT_SONNET_MODEL": "MiniMax-M2",
    "ANTHROPIC_DEFAULT_OPUS_MODEL": "MiniMax-M2",
    "ANTHROPIC_DEFAULT_HAIKU_MODEL": "MiniMax-M2"
  }
}
```

### 3. Settings Priority

1. `.claude/settings.local.json` (personal, git-ignored)
2. `.claude/settings.json` (project-shared)
3. `~/.claude/settings.json` (global)

### 4. Restart Claude Code

Save the configuration file and start a new session

## Local Deployment

```bash
# Hugging Face
huggingface-cli download MiniMax-AI/MiniMax-M2

# Ollama
ollama run minimax-m2
```

## References

- [Official Announcement](https://www.minimax.io/news/minimax-m2)
- [GitHub](https://github.com/MiniMax-AI/MiniMax-M2)
- [Hugging Face](https://huggingface.co/MiniMax-AI/MiniMax-M2)
- [Claude Code Documentation](https://docs.claude.com/en/docs/claude-code/settings)
