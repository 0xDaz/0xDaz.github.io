---
title: "DeepAgents Complete Guide: Building Complex AI Agents with Claude Code Architecture"
pubDate: 2025-10-28T00:17:06+09:00
draft: false
tags: ["DeepAgents", "LangGraph", "AI Agent", "Claude Code", "Python", "LangChain", "AI"]
categories: ["AI"]
description: "How to build complex AI agents with DeepAgents framework that generalizes Claude Code's architecture. Complete guide to Planning, Sub-agents, Filesystem, Prompt and more"
---


## 🎯 What is DeepAgents?

DeepAgents is an AI agent framework that generalizes Claude Code's architecture. Built on top of LangGraph to effectively handle complex tasks

### Core Problem

Traditional agents are "shallow" - just repeat simple LLM → Tool loop
- Fail on complex tasks
- Context window overflow
- Can't track tasks
- Can't delegate subtasks

### Inspiration Sources

- **Claude Code**: Systematic task decomposition and filesystem utilization
- **Deep Research**: Handling complex research tasks
- **Manus**: Utilizing specialized sub-agents

### 4 Core Elements

1. **Planning Tool** - Systematically decompose and track tasks
2. **Sub-agents** - Delegate to specialized sub-agents
3. **File System** - Context offload and memory management
4. **Detailed Prompt** - Domain-optimized detailed prompts

---

## 🔍 Traditional Agent vs Deep Agent

### Traditional Agent (Shallow)

```
┌─────────────────────────────────────┐
│         User Query                  │
└───────────┬─────────────────────────┘
            │
            ▼
    ┌───────────────┐
    │      LLM      │◄──┐
    └───────┬───────┘   │
            │           │
            ▼           │
    ┌───────────────┐   │
    │     Tool      │───┘
    └───────────────┘

Problems:
- Simple repeat loop
- No task decomposition
- Context overflow
- Can't track progress
```

### Deep Agent

```
┌─────────────────────────────────────┐
│         User Query                  │
└───────────┬─────────────────────────┘
            │
            ▼
    ┌───────────────────┐
    │   Planning Tool   │
    │  (Task decompose) │
    └────────┬──────────┘
             │
             ▼
    ┌────────────────────┐
    │   Filesystem       │
    │  (Context manage)  │
    └────────┬───────────┘
             │
             ▼
    ┌────────────────────┐
    │   Main Agent       │◄──────┐
    └────────┬───────────┘       │
             │                   │
             ▼                   │
    ┌────────────────────┐       │
    │   Sub-agent        │───────┘
    │  (Specialized)     │
    └────────────────────┘

Advantages:
✓ Systematic task decomposition
✓ Context isolation
✓ Progress tracking
✓ Specialized processing
```

---

## 🛠️ 4 Core Features

### 1️⃣ Planning Tool

`write_todos` tool for systematic task decomposition and tracking

**Example: Todo List**
```python
[
    {
        "content": "Analyze DeepAgents docs",
        "status": "completed",
        "activeForm": "Analyzing DeepAgents docs"
    },
    {
        "content": "Summarize key features",
        "status": "in_progress",
        "activeForm": "Summarizing key features"
    },
    {
        "content": "Write code examples",
        "status": "pending",
        "activeForm": "Writing code examples"
    }
]
```

**Advantages**
- Decompose complex tasks into manageable units
- Track progress in real-time
- Save intermediate results for easy restart

---

### 2️⃣ File System

4 file tools for context management

```python
# Filesystem tools
- ls()              # List files
- read_file(path)   # Read file
- write_file(path, content)  # Write file
- edit_file(path, old, new)  # Edit file
```

**Purpose**
- Prevent context window overflow
- Use as long-term memory
- Save intermediate results

**Workflow Example**
```
1. Start research
   ↓
2. write_file("research_plan.txt", "...")
   ↓
3. Investigate each item
   ↓
4. write_file("findings_1.txt", "...")
   ↓
5. Read all files and synthesize
   ↓
6. write_file("final_report.txt", "...")
```

**Memory Distinction**
- **Short-term Memory**: Message history (auto-managed)
- **Long-term Memory**: File system (explicit save)

---

### 3️⃣ Sub Agents

`task` tool creates specialized sub-agents

**Context Isolation + Specialization**
```
Main Agent
    │
    ├─► Sub-agent 1 (Research)
    │       └─► Deep investigation of specific topic
    │
    ├─► Sub-agent 2 (Coding)
    │       └─► Write and test code
    │
    └─► Sub-agent 3 (Writing)
            └─► Write and edit documents
```

**Workflow Diagram**
```
┌──────────────────────┐
│    Main Agent        │
│  "Research AI agents"│
└──────────┬───────────┘
           │
           ├──► task("Research LangChain", research_agent)
           │      └─► "LangChain is..."
           │
           ├──► task("Research LangGraph", research_agent)
           │      └─► "LangGraph is..."
           │
           └──► task("Comparative analysis", analysis_agent)
                  └─► "Differences between frameworks..."
```

**Advantages**
- Each sub-agent has independent context
- Uses specialized tools and prompts
- Can execute in parallel

---

### 4️⃣ Detailed Prompt

Based on Claude Code's system prompt

**Structure**
```python
system_prompt = """
You are [role].

## Goal
[Specific goal]

## Available Tools
[Tool list and usage]

## Work Process
1. [Step 1]
2. [Step 2]
...

## Constraints
- [Constraint 1]
- [Constraint 2]

## Examples
[Specific examples]
"""
```

**Domain-specific Customization**
- Research Agent: Focus on information gathering and analysis
- Coding Agent: Emphasize code writing and testing
- Writing Agent: Clear and systematic document creation

---

## 🚀 Installation and Basic Usage

### Installation

```bash
# Using pip
pip install deep-agents

# Using uv (recommended)
uv pip install deep-agents

# Using poetry
poetry add deep-agents
```

### Basic Example: Research Agent

#### Step 1: Define Tools

```python
from langchain_core.tools import tool

@tool
def search(query: str) -> str:
    """Perform web search."""
    # Actual search API call
    return f"Search results for '{query}'..."

@tool
def scrape(url: str) -> str:
    """Scrape webpage."""
    # Actual scraping logic
    return f"Content of {url}..."
```

#### Step 2: System Prompt

```python
system_prompt = """
You are a professional research agent.

## Goal
Thoroughly research given topic and write comprehensive report

## Process
1. Analyze topic and decompose tasks (use write_todos)
2. Gather information for each subtopic (use search, scrape)
3. Save intermediate results as files (use write_file)
4. Synthesize all information and write final report

## Constraints
- Cite all information sources
- Maintain objective and balanced perspective
- Save important findings as files
"""
```

#### Step 3: Create Agent

```python
from deep_agents import Agent

agent = Agent(
    model="claude-3-5-sonnet-20241022",
    tools=[search, scrape],
    system_prompt=system_prompt
)
```

#### Step 4: Execute

```python
result = agent.invoke(
    "Research DeepAgents framework and write report"
)

print(result["messages"][-1].content)
```

### Internal Operation Flow

```
User: "Research DeepAgents"
    ↓
[Planning]
Agent: write_todos([
    "Find DeepAgents docs",
    "Analyze core features",
    "Collect example code",
    "Write report"
])
    ↓
[Task 1]
Agent: search("DeepAgents framework")
    → write_file("docs.txt", "...")
    ↓
[Task 2]
Agent: read_file("docs.txt")
    → Extract core features
    → write_file("features.txt", "...")
    ↓
[Task 3]
Agent: search("DeepAgents examples")
    → write_file("examples.txt", "...")
    ↓
[Task 4]
Agent: read_file("docs.txt")
       read_file("features.txt")
       read_file("examples.txt")
    → Comprehensive analysis
    → write_file("final_report.txt", "...")
```

---

## 🧩 Middleware Architecture

DeepAgents adopts modular middleware structure

```
┌─────────────────────────────────────┐
│          User Input                 │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│     TodoListMiddleware              │
│  - write_todos tool                 │
│  - Task decomposition and tracking  │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│    FilesystemMiddleware             │
│  - ls, read_file, write_file, edit  │
│  - Context offload                  │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│    SubAgentMiddleware               │
│  - task tool                        │
│  - Execute sub-agents               │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│       Core Agent Logic              │
│  - LLM + Custom Tools               │
└─────────────────────────────────────┘
```

### TodoListMiddleware

Handles task decomposition and tracking

```python
from deep_agents.middleware import TodoListMiddleware

# Automatically adds write_todos tool
middleware = TodoListMiddleware()

# Todo list structure
{
    "content": "Task content",           # What to do
    "status": "pending",                 # pending/in_progress/completed
    "activeForm": "Performing task"      # Display when in progress
}
```

**Features**
- Provides `write_todos(todos: list)` tool
- Auto-tracks progress
- Displays current status as message

---

### FilesystemMiddleware

Handles file system management

```python
from deep_agents.middleware import FilesystemMiddleware

# Auto-adds 4 file tools
middleware = FilesystemMiddleware(
    workspace_dir="./workspace"  # Working directory
)

# Provided tools
- ls()                          # File list
- read_file(path: str)          # Read file
- write_file(path: str, content: str)  # Write file
- edit_file(path: str, old: str, new: str)  # Edit file
```

**Memory Distinction**
- **Short-term Memory**: Message history
  - Recent conversation content
  - Auto-managed
  - Context window limited

- **Long-term Memory**: File system
  - Permanent storage of important info
  - Explicit save required
  - No capacity limit

**Usage Pattern**
```python
# 1. Save intermediate results
write_file("research_notes.txt", "...")

# 2. Read later
notes = read_file("research_notes.txt")

# 3. Update content
edit_file("research_notes.txt",
          "old content",
          "new content")
```

---

### SubAgentMiddleware

Handles sub-agent management

```python
from deep_agents.middleware import SubAgentMiddleware

# Auto-adds task tool
middleware = SubAgentMiddleware(
    subagents={
        "research": research_agent,
        "coding": coding_agent,
        "writing": writing_agent
    }
)

# Usage
task(
    instruction="Research LangChain",
    agent_name="research"
)
```

**Context Isolation**
```
Main Agent (Context A)
    │
    ├─► Sub-agent 1 (Context B)
    │       - Independent message history
    │       - Independent file system
    │
    └─► Sub-agent 2 (Context C)
            - Independent message history
            - Independent file system
```

**Advantages**
- Each sub-agent starts with clean context
- Prevents confusion with unnecessary info
- Can execute in parallel

---

## 🔧 Advanced Features

### 1️⃣ SubAgent Customization

#### Method 1: Dictionary Approach

```python
from deep_agents import Agent

# Define sub-agents
research_agent = Agent(
    model="claude-3-5-sonnet-20241022",
    tools=[search, scrape],
    system_prompt="Professional research agent..."
)

coding_agent = Agent(
    model="claude-3-5-sonnet-20241022",
    tools=[run_code, test_code],
    system_prompt="Professional coding agent..."
)

# Register with main agent
main_agent = Agent(
    model="claude-3-5-sonnet-20241022",
    tools=[],
    subagents={
        "research": research_agent,
        "coding": coding_agent
    }
)
```

#### Method 2: CompiledSubAgent (Advanced)

Directly provide LangGraph graph

```python
from deep_agents import Agent, CompiledSubAgent

# Create custom LangGraph graph
custom_graph = create_custom_graph()
compiled = custom_graph.compile()

# Wrap with CompiledSubAgent
custom_subagent = CompiledSubAgent(
    name="custom",
    graph=compiled
)

# Register with main agent
main_agent = Agent(
    model="claude-3-5-sonnet-20241022",
    subagents={
        "custom": custom_subagent
    }
)
```

---

### 2️⃣ Long-term Memory

Cross-thread memory sharing using Store

```python
from deep_agents import Agent
from langgraph.checkpoint.memory import MemorySaver

# Create store
store = MemorySaver()

# Pass store when creating agent
agent = Agent(
    model="claude-3-5-sonnet-20241022",
    tools=[search],
    store=store
)

# First conversation
result1 = agent.invoke(
    "Research DeepAgents",
    config={"configurable": {"thread_id": "1"}}
)

# Second conversation (same thread_id)
result2 = agent.invoke(
    "Summarize previous research",
    config={"configurable": {"thread_id": "1"}}
)
# → Remembers first conversation content
```

**Store Advantages**
- Cross-thread state sharing
- Persistent memory
- Can use database backend

---

### 3️⃣ Human-in-the-Loop

Stop at points requiring human review

```python
agent = Agent(
    model="claude-3-5-sonnet-20241022",
    tools=[dangerous_tool],
    interrupt_on=["dangerous_tool"]  # Stop before calling this tool
)

# Execute
for chunk in agent.stream("Perform dangerous operation"):
    print(chunk)
    # Stops before dangerous_tool call

# Check state
state = agent.get_state(config)

# Resume after approval
agent.update_state(config, {"approved": True})
result = agent.invoke(None, config)  # Resume
```

**Workflow**
```
User: "Delete database"
    ↓
Agent: dangerous_tool("DELETE * FROM users")
    ↓
[INTERRUPT]
    ↓
System: "Approval required. Continue?"
    ↓
User: "Approve" / "Reject"
    ↓
[RESUME] / [CANCEL]
```

**Usage Examples**
```python
# Dangerous operations
- File deletion
- Database modification
- API calls (cost-incurring)
- Email sending

# Important decisions
- Code deployment
- Report submission
- Payment processing
```

---

### 4️⃣ MCP Integration

Use Model Context Protocol tools

```python
from mcp import ClientSession, StdioServerParameters
from mcp.client.stdio import stdio_client

# Connect MCP server
server_params = StdioServerParameters(
    command="uvx",
    args=["mcp-server-fetch"]
)

async def create_agent_with_mcp():
    async with stdio_client(server_params) as (read, write):
        async with ClientSession(read, write) as session:
            await session.initialize()

            # Get MCP tools
            tools = await session.list_tools()

            # Create agent
            agent = Agent(
                model="claude-3-5-sonnet-20241022",
                tools=tools
            )

            # Execute
            result = await agent.ainvoke(
                "Fetch webpage"
            )
```

**MCP Server Examples**
- `mcp-server-fetch`: Fetch web pages
- `mcp-server-filesystem`: File system access
- `mcp-server-sqlite`: SQLite database
- `mcp-server-github`: GitHub API

**Advantages**
- Standardized tool interface
- Diverse external service integration
- Reusable tools

---

## 💡 Real Example: Complex Research Agent

Comprehensive example showing full workflow

### Tool Definition

```python
from langchain_core.tools import tool
from langchain_community.tools import DuckDuckGoSearchRun

@tool
def search(query: str) -> str:
    """Perform web search."""
    ddg = DuckDuckGoSearchRun()
    return ddg.run(query)

@tool
def scrape(url: str) -> str:
    """Scrape webpage."""
    import requests
    from bs4 import BeautifulSoup

    response = requests.get(url)
    soup = BeautifulSoup(response.content, 'html.parser')
    return soup.get_text()[:5000]  # First 5000 chars only

@tool
def analyze(text: str) -> dict:
    """Analyze text."""
    return {
        "length": len(text),
        "words": len(text.split()),
        "sentences": text.count('.')
    }
```

### Sub-agent Definition

```python
from deep_agents import Agent

# Research Sub-agent
research_agent = Agent(
    model="claude-3-5-sonnet-20241022",
    tools=[search, scrape],
    system_prompt="""
    Professional research agent

    ## Goal
    Thoroughly research given topic

    ## Process
    1. Gather information from various sources
    2. Prioritize reliable sources
    3. Extract key information
    4. Organize results in structured format
    """
)

# Analysis Sub-agent
analysis_agent = Agent(
    model="claude-3-5-sonnet-20241022",
    tools=[analyze],
    system_prompt="""
    Professional analysis agent

    ## Goal
    Analyze collected information and derive insights

    ## Process
    1. Identify data patterns
    2. Extract key insights
    3. Draw conclusions
    4. Write actionable recommendations
    """
)
```

### Main Agent Definition

```python
main_agent = Agent(
    model="claude-3-5-sonnet-20241022",
    tools=[],
    subagents={
        "research": research_agent,
        "analysis": analysis_agent
    },
    system_prompt="""
    Project manager agent

    ## Goal
    Manage and complete complex research projects

    ## Process
    1. Decompose project into subtasks (write_todos)
    2. Delegate each task to appropriate sub-agent (task)
    3. Save intermediate results as files (write_file)
    4. Synthesize all results and write final report

    ## Sub-agents
    - research: Information gathering specialist
    - analysis: Data analysis specialist

    ## Constraints
    - Save all important information as files
    - Update todo status after each task
    - Final report must be saved to final_report.txt
    """
)
```

### Execution

```python
result = main_agent.invoke(
    """
    Research AI agent framework market and write analysis report

    Research items:
    1. Differences between LangChain and LangGraph
    2. Core features of DeepAgents
    3. Pros and cons of each framework
    4. Use cases and application areas
    """
)

print(result["messages"][-1].content)
```

---

## 🔗 Relationship with LangGraph

DeepAgents is a higher-level framework built on top of LangGraph

### LangGraph Features Available

```python
from deep_agents import Agent

agent = Agent(
    model="claude-3-5-sonnet-20241022",
    tools=[search]
)

# 1. Synchronous execution
result = agent.invoke("Perform search")

# 2. Streaming
for chunk in agent.stream("Perform search"):
    print(chunk)

# 3. Async execution
result = await agent.ainvoke("Perform search")

# 4. Async streaming
async for chunk in agent.astream("Perform search"):
    print(chunk)

# 5. State query
state = agent.get_state(config)
print(state["values"])
print(state["next"])

# 6. State update
agent.update_state(config, {"key": "value"})

# 7. State history
for state in agent.get_state_history(config):
    print(state)
```

### LangGraph Graph Access

```python
# Direct access to internal graph
graph = agent.graph

# Use LangGraph methods
compiled = graph.compile()
result = compiled.invoke(...)

# Visualization
from IPython.display import Image, display

display(Image(graph.get_graph().draw_mermaid_png()))
```

---

## 📊 Comparison and Summary

### Traditional Agent vs DeepAgents

| Item | Traditional Agent | DeepAgents |
|------|------------------|-----------|
| **Architecture** | Shallow (LLM → Tool loop) | Deep (Planning + Filesystem + SubAgents) |
| **Task Decomposition** | ❌ None | ✅ Systematic decomposition with write_todos |
| **Context Management** | ❌ Message history only | ✅ Offload with file system |
| **Complex Tasks** | ❌ Prone to failure | ✅ Handles effectively |
| **Subtask Delegation** | ❌ Impossible | ✅ Delegate to specialist agents with task tool |
| **Long-term Memory** | ❌ None | ✅ File system + Store |
| **Ease of Use** | Simple | Medium (more setup required) |

### When to Choose DeepAgents?

✅ **Choose DeepAgents**
- [ ] Complex multi-step tasks (research, coding, analysis, etc.)
- [ ] Concern about context window overflow
- [ ] Need task progress tracking
- [ ] Need specialized sub-agents
- [ ] Need long-term memory

❌ **Choose Traditional Agent**
- [ ] Simple tasks (single search, simple questions)
- [ ] Fast prototyping
- [ ] Start with minimal setup
- [ ] Can complete within context window

---

## 🎓 Key Summary

### DeepAgents' 4 Core Elements

1. **Planning Tool** (`write_todos`)
   - Decompose complex tasks into manageable units
   - Track progress in real-time
   - Easy restart with saved intermediate results

2. **File System** (`ls`, `read_file`, `write_file`, `edit_file`)
   - Prevent context window overflow
   - Use as long-term memory
   - Permanently save intermediate results

3. **Sub-agents** (`task` tool)
   - Delegate to specialized sub-agents
   - Prevent confusion with context isolation
   - Can execute in parallel

4. **Detailed Prompt**
   - Domain-optimized prompts
   - Define clear goals and processes
   - Include specific examples

### Installation and Getting Started

```bash
pip install deep-agents
```

```python
from deep_agents import Agent

agent = Agent(
    model="claude-3-5-sonnet-20241022",
    tools=[your_tools],
    system_prompt="Detailed prompt..."
)

result = agent.invoke("Perform complex task")
```

### Key Features

- **LangGraph-based**: All LangGraph features available
- **Modular Architecture**: Easy feature extension with Middleware
- **Human-in-the-Loop**: Human intervention at critical points
- **MCP Integration**: Standardized tool interface

### Application Areas

- Complex research projects
- Multi-step coding tasks
- Data analysis and report writing
- Project management and orchestration
- Long-running workflows

---

## References

- [DeepAgents GitHub](https://github.com/langchain-ai/deep-agents)
- [LangGraph Documentation](https://langchain-ai.github.io/langgraph/)
- [Claude Code](https://claude.ai/code)
- [Deep Research](https://www.anthropic.com/research/deep-research)

---

**Next Steps**
1. Install DeepAgents
2. Run basic examples
3. Customize domain-specific prompts
4. Add sub-agents
5. Apply to real projects
