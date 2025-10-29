---
title: "Playwright MCP: Browser Automation for LLMs"
pubDate: 2025-10-25T01:18:00+09:00
tags: ["Claude", "MCP", "Playwright", "Browser Automation", "Claude Code", "Claude Desktop"]
categories: ["AI"]
keywords: ["Playwright MCP", "Browser Automation", "MCP Server", "Claude Code", "Web Automation", "Testing", "Playwright", "Claude Desktop", "Browser Testing", "AI Automation"]
draft: false
---


## Overview

Playwright MCP is Model Context Protocol server enabling LLMs to automate browsers

Operates fast and lightweight using accessibility tree instead of screenshots

No vision model needed, works with structured data, deterministic tool application possible

## Key Features

### 1. Fast and Lightweight
- Uses accessibility tree instead of pixel-based input
- Much faster response than screenshot processing
- Controls browser with minimal resources

### 2. LLM-Friendly
- No vision model needed
- Works with structured data
- Text-based element identification

### 3. Deterministic Tool Application
- Removes ambiguity of screenshot-based approaches
- Clear element selection
- Stable automation workflows

## Requirements

- Node.js 18+
- MCP client (VS Code, Cursor, Windsurf, Claude Desktop, etc.)

## Installation

### Standard Configuration (Most MCP Clients)

```json
{
  "mcpServers": {
    "playwright": {
      "command": "npx",
      "args": ["@playwright/mcp@latest"]
    }
  }
}
```

### Claude Code CLI

```bash
claude mcp add playwright npx @playwright/mcp@latest
```

## Configuration Options

### Browser Selection
```bash
--browser <chrome|firefox|webkit|msedge>
```

### Headless Mode
```bash
--headless
```

### Device Emulation
```bash
--device "iPhone 13"
```

### User Profile Location
```bash
--user-data-dir /path/to/profile
```

### Isolated Session
```bash
--isolated
```

### Browser Extension Connection
```bash
--extension
```

## User Profile Modes

### 1. Persistent Profile
- Save login information
- Maintain cookies and sessions
- Use `--user-data-dir` option

### 2. Isolated Mode
- Initialize every session
- Clean browser state
- Use `--isolated` option

### 3. Browser Extension
- Connect to existing browser tab
- Real-time interaction
- Use `--extension` option

## Core Tools

### Basic Automation

#### browser_navigate
- Navigate to URL
- Load web page

#### browser_click
- Click element
- Interact with buttons, links

#### browser_type
- Type text
- Fill form fields

#### browser_snapshot
- Capture accessibility snapshot
- More efficient than screenshot
- Provides structured page data

#### browser_fill_form
- Fill multiple form fields simultaneously
- Efficient form completion

#### browser_select_option
- Select dropdown option
- Control Select elements

### Tab Management

#### browser_tabs
- Create, switch, close browser tabs
- Support multi-tab workflows

### Information Gathering

#### browser_console_messages
- Check console logs
- Collect debugging information

#### browser_network_requests
- Network request list
- Monitor API calls

### Advanced Features

#### browser_evaluate
- Execute JavaScript
- Run custom scripts

#### browser_file_upload
- Upload files
- Handle file selection dialog

#### browser_handle_dialog
- Handle alert, confirm, prompt
- Auto-respond to dialogs

#### browser_wait_for
- Wait for specific conditions
- Wait until element appears

## Optional Features (Opt-in)

### Vision Feature
```bash
--caps=vision
```
- Coordinate-based clicking
- Image recognition

### PDF Generation
```bash
--caps=pdf
```
- Save page as PDF
- Document archiving

### Testing
```bash
--caps=testing
```
- Generate locators
- Validate elements

### Tracing
```bash
--caps=tracing
```
- Record execution trace
- Debugging and analysis

## Use Cases

### Web Automation
- Automate repetitive tasks
- Automate data entry
- Automate form submission

### Web Scraping
- Extract structured data
- Collect dynamic content
- Access login-required pages

### Testing
- Automate E2E tests
- UI validation
- Cross-browser testing

### Monitoring
- Check website status
- Track changes
- Auto-notifications

## Why Use Playwright MCP

### Structured Data Based
- LLM understands web pages as structured data
- More accurate element identification than screenshots
- Fast processing speed

### High Reliability
- More stable than screenshot-based approaches
- Clear element selection
- Reproducible automation

### Complex Workflow Support
- Maintain login sessions
- Manage browser state
- Multi-step automation

### Diverse Applications
- Testing
- Scraping
- Automation tasks
- Monitoring

## Verification

```bash
# Check MCP server list
claude mcp list

# Playwright MCP details
claude mcp get playwright
```

## References

- [Playwright MCP GitHub](https://github.com/microsoft/playwright-mcp)
- [Playwright Documentation](https://playwright.dev/)
- [Model Context Protocol](https://modelcontextprotocol.io/)
