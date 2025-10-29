---
title: "Claude Code에서 MiniMax M2 사용하기"
pubDate: 2025-10-29T22:40:00+09:00
draft: false
tags: ["Claude Code", "MiniMax M2", "설정", "무료", "API"]
categories: ["AI"]
---

## MiniMax M2

중국 MiniMax의 오픈소스 AI 모델 (2025년 10월 출시)

**특징:**
- Claude Sonnet 4.5 대비 2배 속도
- 가격 8% ($0.30/M input, $1.20/M output)
- Anthropic API 호환
- **11월 7일까지 무료**

## 설정 방법

### 1. API 키 발급

[MiniMax Platform](https://platform.minimax.io)에서 계정 생성 후 API 키 발급

### 2. 설정 파일 수정

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

### 3. 설정 파일 우선순위

1. `.claude/settings.local.json` (개인용, git-ignored)
2. `.claude/settings.json` (프로젝트 공유)
3. `~/.claude/settings.json` (전역)

### 4. Claude Code 재시작

설정 파일 저장 후 새 세션 시작

## 로컬 배포

```bash
# Hugging Face
huggingface-cli download MiniMax-AI/MiniMax-M2

# Ollama
ollama run minimax-m2
```

## 참고

- [공식 발표](https://www.minimax.io/news/minimax-m2)
- [GitHub](https://github.com/MiniMax-AI/MiniMax-M2)
- [Hugging Face](https://huggingface.co/MiniMax-AI/MiniMax-M2)
- [Claude Code 문서](https://docs.claude.com/en/docs/claude-code/settings)
