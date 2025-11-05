---
title: "TOON - Token-Efficient Serialization Format for LLMs"
description: "LLM-friendly serialization format achieving 30-60% token savings compared to JSON while maintaining parsing accuracy"
pubDate: 2025-11-06T02:01:40+09:00
tags: ["TOON", "LLM", "Token-Optimization", "Serialization", "AI"]
categories: ["AI"]
draft: false
---

## What is TOON?

TOON (Token-Oriented Object Notation) is a token-efficient serialization format designed specifically for LLMs. It achieves 30-60% token savings compared to JSON while maintaining accurate parsing by LLMs through structured guardrails.

## Why TOON?

**JSON's Limitations**:
- Verbose syntax (braces, commas, quotes)
- Inefficient for repetitive structures
- High token costs (OpenAI GPT-4: $30/1M tokens)

**TOON's Solution**:
- Minimal syntax (indentation-based)
- Tabular array representation
- LLM-friendly guardrails (explicit lengths and field names)

## Key Features

### Token Efficiency

30-60% token savings achieved:

```
JSON:  850 tokens
TOON:  340 tokens (60% reduction)
```

### LLM Guardrails

Explicit structure definitions improve parsing accuracy:

```toon
users[3]  # Array length specified
| id | name      | email
| 1  | Alice     | alice@example.com
| 2  | Bob       | bob@example.com
| 3  | Charlie   | charlie@example.com
```

### Minimal Syntax

- Indentation-based hierarchy (YAML-style)
- Tabular format for uniform arrays (CSV-style)
- Quotes optional (only needed for whitespace-containing values)

## Benchmark Results

**Token Efficiency** (GPT-4 tokenizer):

| Data Type | JSON | TOON | Savings |
|-----------|------|------|---------|
| Simple Object Array | 850 | 340 | 60% |
| Nested Structure | 1250 | 625 | 50% |
| Tabular Data | 2100 | 840 | 60% |

**Parsing Accuracy**:

- JSON: 98.5%
- TOON: 96.8%

LLMs can accurately parse TOON format.

## Usage Examples

### Object Representation

**JSON**:
```json
{
  "name": "John Doe",
  "age": 30,
  "email": "john@example.com",
  "address": {
    "city": "New York",
    "country": "USA"
  }
}
```

**TOON**:
```toon
name: John Doe
age: 30
email: john@example.com
address
  city: New York
  country: USA
```

### Arrays - Primitive

**JSON**:
```json
{
  "tags": ["typescript", "node", "cli"]
}
```

**TOON**:
```toon
tags[3]: typescript, node, cli
```

### Arrays - Tabular

**JSON**:
```json
{
  "users": [
    {"id": 1, "name": "Alice", "role": "admin"},
    {"id": 2, "name": "Bob", "role": "user"},
    {"id": 3, "name": "Charlie", "role": "user"}
  ]
}
```

**TOON**:
```toon
users[3]
| id | name    | role
| 1  | Alice   | admin
| 2  | Bob     | user
| 3  | Charlie | user
```

## Installation and Usage

### NPM Package

```bash
npm install toon-serializer
```

```javascript
import { toTOON, fromTOON } from 'toon-serializer';

const data = {
  users: [
    { id: 1, name: 'Alice' },
    { id: 2, name: 'Bob' }
  ]
};

// JSON → TOON
const toon = toTOON(data);
console.log(toon);

// TOON → JSON
const json = fromTOON(toon);
console.log(json);
```

### CLI

```bash
# JSON → TOON
toon convert input.json -o output.toon

# TOON → JSON
toon convert input.toon -o output.json --reverse

# Token comparison
toon compare input.json
```

## When to Use TOON

**TOON Recommended**:

1. **Tabular Data Transfer**
   - Uniform object arrays
   - Database query results
   - CSV-like data

2. **LLM Input Data**
   - Context in prompts
   - Document chunks in RAG systems
   - Function calling parameters

3. **Token Cost Optimization**
   - High-volume API calls
   - Streaming responses
   - Fine-tuning datasets

**JSON Better For**:

1. **Complex Nested Structures**
   - Deep hierarchies
   - Irregular data shapes

2. **Existing Infrastructure Compatibility**
   - JSON-based APIs
   - Standard library usage

3. **Human-Edited Data**
   - Configuration files
   - Metadata

## JSON vs TOON Real-World Comparison

### User List (100 users)

**JSON**: 8,500 tokens
```json
[
  {"id": 1, "name": "Alice", "email": "alice@example.com", "role": "admin"},
  {"id": 2, "name": "Bob", "email": "bob@example.com", "role": "user"},
  ...
]
```

**TOON**: 3,400 tokens (60% reduction)
```toon
users[100]
| id  | name    | email                | role
| 1   | Alice   | alice@example.com    | admin
| 2   | Bob     | bob@example.com      | user
...
```

**Cost Savings** (GPT-4 pricing):
- JSON: $0.255 (8,500 tokens × $30/1M)
- TOON: $0.102 (3,400 tokens × $30/1M)
- Savings: $0.153 per request (60%)

1 million monthly requests: **$153,000 saved**

## Limitations and Considerations

**Constraints**:

1. **Ecosystem Maturity**
   - New format with limited tooling
   - Restricted community support

2. **LLM Dependency**
   - Requires LLM parsing capability
   - ~3% parsing error possibility

3. **Complex Structure Handling**
   - Deep nesting clearer with JSON
   - Irregular data reduces efficiency

**Best Practices**:

1. **Gradual Adoption**
   - Start with bottleneck areas
   - Maintain JSON backups

2. **Enhanced Validation**
   - Schema validation after parsing
   - Mandatory error handling logic

3. **Documentation**
   - Specify TOON schemas
   - Provide conversion examples

## Real-World Use Cases

### RAG System Optimization

```python
# Before (JSON)
context = json.dumps(documents)  # 15,000 tokens

# After (TOON)
context = to_toon(documents)     # 6,000 tokens
# → 60% token reduction, more documents can be included
```

### Function Calling

```javascript
// Before (JSON)
const params = {
  users: [...],  // 1,200 tokens
};

// After (TOON)
const params = toTOON({
  users: [...],  // 480 tokens
});
// → More parameters can be passed
```

### Streaming Response Optimization

```typescript
// Bandwidth reduction with TOON streaming
stream.pipe(toonSerializer).pipe(response);
```

## Conclusion

TOON is an optimized serialization format for the LLM era. It enables 30-60% cost reduction compared to JSON in token-sensitive scenarios.

**Core Benefits**:
- Token efficiency (30-60% reduction)
- LLM-friendly structure
- Minimal syntax

**Recommended Applications**:
- Tabular data
- LLM input context
- Token cost optimization needs

**Cautious Approach Needed**:
- Consider ecosystem maturity
- Mandatory validation logic
- Gradual adoption recommended

## References

- [TOON GitHub Repository](https://github.com/anthropics/toon)
- [TOON Specification](https://github.com/anthropics/toon/blob/main/SPEC.md)
- [Token Efficiency Benchmark](https://github.com/anthropics/toon/blob/main/BENCHMARK.md)
- [NPM Package](https://www.npmjs.com/package/toon-serializer)
