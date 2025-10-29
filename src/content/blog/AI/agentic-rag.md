---
title: "What is Agentic RAG"
pubDate: 2025-10-25T14:30:00+09:00
tags: ["AI", "RAG", "Agentic RAG", "BAML", "LLM"]
categories: ["AI"]
draft: false
description: "Differences between traditional RAG and Agentic RAG, and the core of autonomous decision-making"
---


## RAG Basic Concept

RAG (Retrieval-Augmented Generation) combines external knowledge with LLM responses

Basic operation:
1. User question input
2. Search relevant documents
3. Pass retrieved documents + question to LLM
4. LLM generates answer

Limitation: Always uses same search method, no situation-based optimization

## Traditional RAG vs Agentic RAG

### Traditional RAG

```
Question → Vector Search → Documents → LLM → Answer
```

Characteristics:
- Fixed pipeline
- Always executes vector search
- Simple and fast
- Predictable behavior

Problems:
- Does every question need search?
- Is vector search alone sufficient?
- What about multiple sources?

### Agentic RAG

```
Question → AI Agent → Tool Selection (Vector Search / SQL / API / Skip Search) → Answer
```

Characteristics:
- Dynamic pipeline
- AI selects tools per situation
- Complex but flexible
- Generates optimized answers

Key Differences:
| Item | Traditional RAG | Agentic RAG |
|------|-----------------|-------------|
| Search Decision | Always search | Search only when needed |
| Tool Selection | Fixed (vector search) | Dynamic (choose from multiple tools) |
| Complexity | Low | High |
| Speed | Fast | Relatively slow |
| Flexibility | Low | High |

## Why "Agentic" - Autonomous Decision Making

**Agent** = AI that autonomously judges and selects tools

Core Capabilities:
1. **Situation Assessment**: "Does this question need document search?"
2. **Tool Selection**: "Vector search? SQL? API call?"
3. **Chain Execution**: "First query A → Use result to search B"

Example Scenarios:
```
Question: "When was the company founded?"
→ Agent: Check company documents with vector search

Question: "What's 2 + 2?"
→ Agent: No search needed, answer directly

Question: "Top 5 products by sales last month?"
→ Agent: Need to execute SQL query

Question: "Seoul weather + our store locations"
→ Agent: Combine weather API call + vector search
```

## Actual Operation Example

### Traditional RAG
```python
# Same processing for all questions
def traditional_rag(question):
    docs = vector_search(question)  # Always executes
    return llm(question + docs)
```

### Agentic RAG
```python
# AI selects tools
def agentic_rag(question):
    # AI decides: Which tools are needed?
    tools = agent.select_tools(question)

    results = []
    for tool in tools:
        if tool == "vector_search":
            results.append(vector_search(question))
        elif tool == "sql":
            results.append(sql_query(question))
        elif tool == "api":
            results.append(api_call(question))

    return llm(question + results)
```

## Agentic RAG Tools

Example tools the Agent can choose:

**Search Tools**
- `vector_search`: Semantic document search
- `keyword_search`: Keyword-based search
- `hybrid_search`: Vector + keyword combination

**Data Tools**
- `sql_query`: Structured data query
- `graph_query`: Relational data exploration
- `nosql_query`: Unstructured data query

**External Tools**
- `web_search`: Real-time web search
- `api_call`: External API calls
- `calculator`: Mathematical calculations

**Meta Tools**
- `no_tool`: No tool needed, LLM only
- `multi_tool`: Sequential/parallel tool execution

## When to Use

### Agentic RAG Recommended

✅ Multiple data sources (documents + DB + API)
✅ Complex multi-step queries
✅ Situation-specific optimization needed
✅ Accuracy over cost priority

Examples:
- Enterprise search: Documents + HR DB + project management system
- Financial analysis: Financial statements + market data API + news
- Customer support: FAQ + order DB + inventory system

### Traditional RAG Recommended

✅ Single data source (documents only)
✅ Simple query patterns
✅ Fast response required
✅ Speed/cost over accuracy priority

Examples:
- Document-based chatbot
- Simple FAQ system
- Prototype development

## Key Summary

**Traditional RAG**: Fixed pipeline, fast and simple
- Always vector search → LLM
- Predictable, easy implementation

**Agentic RAG**: Dynamic pipeline, flexible and powerful
- AI selects tools → Situation-specific optimization
- Complex but higher accuracy

**Agent Core**: Autonomous decision-making
- Situation assessment → Tool selection → Execution

**Selection Criteria**: Complexity vs flexibility tradeoff
- Simple use: Traditional RAG
- Complex use: Agentic RAG

---

**Source**: [ai-that-works GitHub](https://github.com/ai-that-works/ai-that-works/tree/main/2025-10-21-agentic-rag-context-engineering)
