---
title: "Claude Skills"
pubDate: 2025-10-24T15:00:00+09:00
tags: ["Claude", "AI", "Skills", "Claude Code", "Anthropic", "Office", "PDF", "Excel", "Word", "PowerPoint"]
categories: ["AI"]
keywords: ["Claude Skills", "Claude Code", "AI Skills", "Anthropic", "Office Tools", "PDF Processing", "Excel", "Word", "PowerPoint", "AI Assistant"]
draft: false
---


## Overview

Claude Skills simply provide tools for agents to use

Can be created with natural language and supports Python script code, so essentially unlimited applications

Only description written and loads Just-In-Time, advantageous for context and token savings

### Skill Characteristics

- **Composable**: Can use multiple skills together
- **Portable**: Uses same format across all Claude products
- **Efficient**: Only loads what's needed
- **Powerful**: Can include executable code

### Available In

- Claude Desktop (Pro, Max, Team, Enterprise)
- Claude Code
- Claude API (Messages API, /v1/skills endpoint)

### skill-creator Skill

Installing plugin from official marketplace provides skill-creator skill

Very useful as can create skills matching Claude Code skill format based on natural language

Claude often creates in wrong directory if asked directly

### Adding Marketplace

```bash
/plugin marketplace add anthropics/skills
```

### Document-Related Skills

MS document parsing is harder than expected, but official document skills are quite useful
- **docx**: Create, edit, analyze Word documents (track changes, comments, preserve formatting, extract text)
- **pdf**: Manipulate PDFs (extract text/tables, create PDFs, merge/split, handle forms)
- **pptx**: Create, edit, analyze PowerPoint presentations (layouts, templates, charts, auto-generate slides)
- **xlsx**: Create, edit, analyze Excel spreadsheets (formulas, formatting, data analysis, visualization)

### Unofficial CLI

- [claude-skills-cli](https://github.com/spences10/claude-skills-cli)

## References

- [Introducing Agent Skills - Anthropic](https://www.anthropic.com/news/skills)
- [Claude Skills Documentation](https://docs.anthropic.com)
- [claude-skills-cli GitHub](https://github.com/spences10/claude-skills-cli)
