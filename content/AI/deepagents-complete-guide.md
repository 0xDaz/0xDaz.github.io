---
title: "DeepAgents 완벽 가이드: Claude Code 아키텍처로 복잡한 AI 에이전트 구축"
date: 2025-10-28T00:17:06+09:00
draft: false
tags: ["DeepAgents", "LangGraph", "AI Agent", "Claude Code", "Python", "LangChain", "AI"]
categories: ["AI"]
description: "Claude Code의 아키텍처를 일반화한 DeepAgents 프레임워크로 복잡한 AI 에이전트를 구축하는 방법. Planning, Sub-agents, Filesystem, Prompt 등 핵심 기능 완벽 정리"
---

## 🎯 DeepAgents란?

DeepAgents는 Claude Code의 아키텍처를 일반화한 AI 에이전트 프레임워크. LangGraph 위에 구축되어 복잡한 작업을 효과적으로 처리 가능

### 핵심 문제

기존 에이전트는 "shallow" - 단순한 LLM → Tool 루프만 반복
- 복잡한 작업 시 실패
- 컨텍스트 윈도우 오버플로우
- 작업 추적 불가
- 하위 작업 위임 불가

### 영감의 원천

- **Claude Code**: 체계적인 작업 분해와 파일 시스템 활용
- **Deep Research**: 복잡한 리서치 작업 처리
- **Manus**: 전문화된 하위 에이전트 활용

### 4가지 핵심 요소

1. **Planning Tool** - 작업을 체계적으로 분해하고 추적
2. **Sub-agents** - 전문화된 하위 에이전트로 작업 위임
3. **File System** - 컨텍스트 오프로드와 메모리 관리
4. **Detailed Prompt** - 도메인별로 최적화된 상세 프롬프트

---

## 🔍 기존 Agent vs Deep Agent

### 기존 Agent (Shallow)

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

문제점:
- 단순 반복 루프
- 작업 분해 없음
- 컨텍스트 오버플로우
- 진행 상황 추적 불가
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
    │  (작업 분해)      │
    └────────┬──────────┘
             │
             ▼
    ┌────────────────────┐
    │   Filesystem       │
    │  (컨텍스트 관리)   │
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
    │  (전문화된 작업)   │
    └────────────────────┘

장점:
✓ 체계적 작업 분해
✓ 컨텍스트 격리
✓ 진행 상황 추적
✓ 전문화된 처리
```

---

## 🛠️ 4가지 핵심 기능

### 1️⃣ Planning Tool

`write_todos` 도구로 작업을 체계적으로 분해하고 추적

**예시: Todo 리스트**
```python
[
    {
        "content": "DeepAgents 문서 분석",
        "status": "completed",
        "activeForm": "DeepAgents 문서 분석 중"
    },
    {
        "content": "핵심 기능 요약",
        "status": "in_progress",
        "activeForm": "핵심 기능 요약 중"
    },
    {
        "content": "코드 예제 작성",
        "status": "pending",
        "activeForm": "코드 예제 작성 중"
    }
]
```

**장점**
- 복잡한 작업을 관리 가능한 단위로 분해
- 진행 상황 실시간 추적
- 중간 결과 저장으로 재시작 용이

---

### 2️⃣ File System

4가지 파일 도구로 컨텍스트 관리

```python
# 파일 시스템 도구
- ls()              # 파일 목록 조회
- read_file(path)   # 파일 읽기
- write_file(path, content)  # 파일 쓰기
- edit_file(path, old, new)  # 파일 편집
```

**목적**
- 컨텍스트 윈도우 오버플로우 방지
- 장기 메모리로 활용
- 중간 결과 저장

**워크플로우 예시**
```
1. 리서치 시작
   ↓
2. write_file("research_plan.txt", "...")
   ↓
3. 각 항목 조사
   ↓
4. write_file("findings_1.txt", "...")
   ↓
5. 모든 파일 읽고 종합
   ↓
6. write_file("final_report.txt", "...")
```

**메모리 구분**
- **단기 메모리**: 메시지 히스토리 (자동 관리)
- **장기 메모리**: 파일 시스템 (명시적 저장)

---

### 3️⃣ Sub Agents

`task` 도구로 전문화된 하위 에이전트 생성

**컨텍스트 격리 + 전문화**
```
Main Agent
    │
    ├─► Sub-agent 1 (Research)
    │       └─► 특정 주제 심층 조사
    │
    ├─► Sub-agent 2 (Coding)
    │       └─► 코드 작성 및 테스트
    │
    └─► Sub-agent 3 (Writing)
            └─► 문서 작성 및 편집
```

**워크플로우 다이어그램**
```
┌──────────────────────┐
│    Main Agent        │
│  "AI 에이전트 조사"  │
└──────────┬───────────┘
           │
           ├──► task("LangChain 조사", research_agent)
           │      └─► "LangChain은..."
           │
           ├──► task("LangGraph 조사", research_agent)
           │      └─► "LangGraph는..."
           │
           └──► task("비교 분석", analysis_agent)
                  └─► "두 프레임워크의 차이는..."
```

**장점**
- 각 하위 에이전트는 독립적 컨텍스트
- 전문화된 도구와 프롬프트 사용
- 병렬 실행 가능

---

### 4️⃣ Detailed Prompt

Claude Code의 시스템 프롬프트 기반

**구조**
```python
system_prompt = """
당신은 [역할]입니다.

## 목표
[구체적인 목표]

## 사용 가능한 도구
[도구 목록과 사용법]

## 작업 프로세스
1. [단계 1]
2. [단계 2]
...

## 제약사항
- [제약사항 1]
- [제약사항 2]

## 예시
[구체적인 예시]
"""
```

**도메인별 커스터마이징**
- Research Agent: 정보 수집 및 분석에 집중
- Coding Agent: 코드 작성 및 테스트 강조
- Writing Agent: 명확하고 체계적인 문서 작성

---

## 🚀 설치 및 기본 사용법

### 설치

```bash
# pip 사용
pip install deep-agents

# uv 사용 (권장)
uv pip install deep-agents

# poetry 사용
poetry add deep-agents
```

### 기본 예제: 리서치 에이전트

#### 1단계: 도구 정의

```python
from langchain_core.tools import tool

@tool
def search(query: str) -> str:
    """웹 검색을 수행합니다."""
    # 실제 검색 API 호출
    return f"'{query}'에 대한 검색 결과..."

@tool
def scrape(url: str) -> str:
    """웹페이지를 스크래핑합니다."""
    # 실제 스크래핑 로직
    return f"{url}의 내용..."
```

#### 2단계: 시스템 프롬프트

```python
system_prompt = """
당신은 전문 리서치 에이전트입니다.

## 목표
주어진 주제에 대해 철저히 조사하고 종합적인 보고서 작성

## 프로세스
1. 주제 분석 및 작업 분해 (write_todos 사용)
2. 각 하위 주제별로 정보 수집 (search, scrape 사용)
3. 중간 결과를 파일로 저장 (write_file 사용)
4. 모든 정보를 종합하여 최종 보고서 작성

## 제약사항
- 모든 정보의 출처를 명시
- 객관적이고 균형잡힌 시각 유지
- 중요한 발견은 반드시 파일로 저장
"""
```

#### 3단계: Agent 생성

```python
from deep_agents import Agent

agent = Agent(
    model="claude-3-5-sonnet-20241022",
    tools=[search, scrape],
    system_prompt=system_prompt
)
```

#### 4단계: 실행

```python
result = agent.invoke(
    "DeepAgents 프레임워크에 대해 조사하고 보고서 작성"
)

print(result["messages"][-1].content)
```

### 내부 동작 플로우

```
User: "DeepAgents 조사"
    ↓
[Planning]
Agent: write_todos([
    "DeepAgents 문서 찾기",
    "핵심 기능 분석",
    "예제 코드 수집",
    "보고서 작성"
])
    ↓
[Task 1]
Agent: search("DeepAgents framework")
    → write_file("docs.txt", "...")
    ↓
[Task 2]
Agent: read_file("docs.txt")
    → 핵심 기능 추출
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
    → 종합 분석
    → write_file("final_report.txt", "...")
```

---

## 🧩 Middleware 아키텍처

DeepAgents는 모듈식 미들웨어 구조 채택

```
┌─────────────────────────────────────┐
│          User Input                 │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│     TodoListMiddleware              │
│  - write_todos tool                 │
│  - 작업 분해 및 추적                │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│    FilesystemMiddleware             │
│  - ls, read_file, write_file, edit  │
│  - 컨텍스트 오프로드                │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│    SubAgentMiddleware               │
│  - task tool                        │
│  - 하위 에이전트 실행               │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│       Core Agent Logic              │
│  - LLM + Custom Tools               │
└─────────────────────────────────────┘
```

### TodoListMiddleware

작업 분해 및 추적 담당

```python
from deep_agents.middleware import TodoListMiddleware

# 자동으로 write_todos 도구 추가
middleware = TodoListMiddleware()

# Todo 리스트 구조
{
    "content": "작업 내용",           # 무엇을 할 것인가
    "status": "pending",             # pending/in_progress/completed
    "activeForm": "작업 내용 수행 중" # 진행 중일 때 표시
}
```

**기능**
- `write_todos(todos: list)` 도구 제공
- 진행 상황 자동 추적
- 현재 상태를 메시지로 표시

---

### FilesystemMiddleware

파일 시스템 관리 담당

```python
from deep_agents.middleware import FilesystemMiddleware

# 4가지 파일 도구 자동 추가
middleware = FilesystemMiddleware(
    workspace_dir="./workspace"  # 작업 디렉토리
)

# 제공되는 도구
- ls()                          # 파일 목록
- read_file(path: str)          # 파일 읽기
- write_file(path: str, content: str)  # 파일 쓰기
- edit_file(path: str, old: str, new: str)  # 파일 편집
```

**메모리 구분**
- **단기 메모리** (Short-term): 메시지 히스토리
  - 최근 대화 내용
  - 자동으로 관리됨
  - 컨텍스트 윈도우 제한 있음

- **장기 메모리** (Long-term): 파일 시스템
  - 중요한 정보 영구 저장
  - 명시적으로 저장 필요
  - 용량 제한 없음

**사용 패턴**
```python
# 1. 중간 결과 저장
write_file("research_notes.txt", "...")

# 2. 나중에 다시 읽기
notes = read_file("research_notes.txt")

# 3. 내용 업데이트
edit_file("research_notes.txt",
          "old content",
          "new content")
```

---

### SubAgentMiddleware

하위 에이전트 관리 담당

```python
from deep_agents.middleware import SubAgentMiddleware

# task 도구 자동 추가
middleware = SubAgentMiddleware(
    subagents={
        "research": research_agent,
        "coding": coding_agent,
        "writing": writing_agent
    }
)

# 사용법
task(
    instruction="LangChain에 대해 조사",
    agent_name="research"
)
```

**컨텍스트 격리**
```
Main Agent (Context A)
    │
    ├─► Sub-agent 1 (Context B)
    │       - 독립적인 메시지 히스토리
    │       - 독립적인 파일 시스템
    │
    └─► Sub-agent 2 (Context C)
            - 독립적인 메시지 히스토리
            - 독립적인 파일 시스템
```

**장점**
- 각 하위 에이전트는 깨끗한 컨텍스트로 시작
- 불필요한 정보로 혼란 방지
- 병렬 실행 가능

---

## 🔧 고급 기능

### 1️⃣ SubAgent 커스터마이징

#### 방법 1: 딕셔너리 방식

```python
from deep_agents import Agent

# 하위 에이전트 정의
research_agent = Agent(
    model="claude-3-5-sonnet-20241022",
    tools=[search, scrape],
    system_prompt="전문 리서치 에이전트..."
)

coding_agent = Agent(
    model="claude-3-5-sonnet-20241022",
    tools=[run_code, test_code],
    system_prompt="전문 코딩 에이전트..."
)

# 메인 에이전트에 등록
main_agent = Agent(
    model="claude-3-5-sonnet-20241022",
    tools=[],
    subagents={
        "research": research_agent,
        "coding": coding_agent
    }
)
```

#### 방법 2: CompiledSubAgent (고급)

직접 LangGraph 그래프 제공

```python
from deep_agents import Agent, CompiledSubAgent

# 커스텀 LangGraph 그래프 생성
custom_graph = create_custom_graph()
compiled = custom_graph.compile()

# CompiledSubAgent로 감싸기
custom_subagent = CompiledSubAgent(
    name="custom",
    graph=compiled
)

# 메인 에이전트에 등록
main_agent = Agent(
    model="claude-3-5-sonnet-20241022",
    subagents={
        "custom": custom_subagent
    }
)
```

---

### 2️⃣ 장기 메모리 (Long-term Memory)

Store를 사용한 스레드 간 메모리 공유

```python
from deep_agents import Agent
from langgraph.checkpoint.memory import MemorySaver

# Store 생성
store = MemorySaver()

# Agent 생성 시 store 전달
agent = Agent(
    model="claude-3-5-sonnet-20241022",
    tools=[search],
    store=store
)

# 첫 번째 대화
result1 = agent.invoke(
    "DeepAgents에 대해 조사",
    config={"configurable": {"thread_id": "1"}}
)

# 두 번째 대화 (같은 thread_id)
result2 = agent.invoke(
    "이전 조사 내용 요약해줘",
    config={"configurable": {"thread_id": "1"}}
)
# → 첫 번째 대화 내용 기억함
```

**Store의 장점**
- 스레드 간 상태 공유
- 영구적인 메모리
- 데이터베이스 백엔드 사용 가능

---

### 3️⃣ Human-in-the-Loop

사람의 검토가 필요한 지점에서 중단

```python
agent = Agent(
    model="claude-3-5-sonnet-20241022",
    tools=[dangerous_tool],
    interrupt_on=["dangerous_tool"]  # 이 도구 호출 전 중단
)

# 실행
for chunk in agent.stream("위험한 작업 수행"):
    print(chunk)
    # dangerous_tool 호출 전에 중단됨

# 상태 확인
state = agent.get_state(config)

# 승인 후 재개
agent.update_state(config, {"approved": True})
result = agent.invoke(None, config)  # 재개
```

**워크플로우**
```
User: "데이터베이스 삭제"
    ↓
Agent: dangerous_tool("DELETE * FROM users")
    ↓
[INTERRUPT]
    ↓
System: "승인이 필요합니다. 계속하시겠습니까?"
    ↓
User: "승인" / "거부"
    ↓
[RESUME] / [CANCEL]
```

**사용 예시**
```python
# 위험한 작업
- 파일 삭제
- 데이터베이스 수정
- API 호출 (비용 발생)
- 이메일 전송

# 중요한 결정
- 코드 배포
- 리포트 제출
- 결제 진행
```

---

### 4️⃣ MCP 통합

Model Context Protocol 도구 사용

```python
from mcp import ClientSession, StdioServerParameters
from mcp.client.stdio import stdio_client

# MCP 서버 연결
server_params = StdioServerParameters(
    command="uvx",
    args=["mcp-server-fetch"]
)

async def create_agent_with_mcp():
    async with stdio_client(server_params) as (read, write):
        async with ClientSession(read, write) as session:
            await session.initialize()

            # MCP 도구 가져오기
            tools = await session.list_tools()

            # Agent 생성
            agent = Agent(
                model="claude-3-5-sonnet-20241022",
                tools=tools
            )

            # 실행
            result = await agent.ainvoke(
                "웹페이지 가져오기"
            )
```

**MCP 서버 예시**
- `mcp-server-fetch`: 웹 페이지 가져오기
- `mcp-server-filesystem`: 파일 시스템 접근
- `mcp-server-sqlite`: SQLite 데이터베이스
- `mcp-server-github`: GitHub API

**장점**
- 표준화된 도구 인터페이스
- 다양한 외부 서비스 통합
- 재사용 가능한 도구

---

## 💡 실전 예제: 복잡한 리서치 에이전트

전체 워크플로우를 보여주는 종합 예제

### 도구 정의

```python
from langchain_core.tools import tool
from langchain_community.tools import DuckDuckGoSearchRun

@tool
def search(query: str) -> str:
    """웹 검색을 수행합니다."""
    ddg = DuckDuckGoSearchRun()
    return ddg.run(query)

@tool
def scrape(url: str) -> str:
    """웹페이지를 스크래핑합니다."""
    import requests
    from bs4 import BeautifulSoup

    response = requests.get(url)
    soup = BeautifulSoup(response.content, 'html.parser')
    return soup.get_text()[:5000]  # 처음 5000자만

@tool
def analyze(text: str) -> dict:
    """텍스트를 분석합니다."""
    return {
        "length": len(text),
        "words": len(text.split()),
        "sentences": text.count('.')
    }
```

### 하위 에이전트 정의

```python
from deep_agents import Agent

# Research Sub-agent
research_agent = Agent(
    model="claude-3-5-sonnet-20241022",
    tools=[search, scrape],
    system_prompt="""
    전문 리서치 에이전트

    ## 목표
    주어진 주제에 대해 철저히 조사

    ## 프로세스
    1. 다양한 소스에서 정보 수집
    2. 신뢰할 수 있는 출처 우선
    3. 핵심 정보 추출
    4. 결과를 구조화된 형식으로 정리
    """
)

# Analysis Sub-agent
analysis_agent = Agent(
    model="claude-3-5-sonnet-20241022",
    tools=[analyze],
    system_prompt="""
    전문 분석 에이전트

    ## 목표
    수집된 정보를 분석하고 인사이트 도출

    ## 프로세스
    1. 데이터 패턴 파악
    2. 핵심 인사이트 추출
    3. 결론 도출
    4. 실행 가능한 제안 작성
    """
)
```

### 메인 에이전트 정의

```python
main_agent = Agent(
    model="claude-3-5-sonnet-20241022",
    tools=[],
    subagents={
        "research": research_agent,
        "analysis": analysis_agent
    },
    system_prompt="""
    프로젝트 매니저 에이전트

    ## 목표
    복잡한 리서치 프로젝트를 관리하고 완료

    ## 프로세스
    1. 프로젝트를 하위 작업으로 분해 (write_todos)
    2. 각 작업을 적절한 하위 에이전트에 위임 (task)
    3. 중간 결과를 파일로 저장 (write_file)
    4. 모든 결과를 종합하여 최종 보고서 작성

    ## 하위 에이전트
    - research: 정보 수집 전문
    - analysis: 데이터 분석 전문

    ## 제약사항
    - 모든 중요한 정보는 파일로 저장
    - 각 작업 완료 후 todo 상태 업데이트
    - 최종 보고서는 반드시 final_report.txt에 저장
    """
)
```

### 실행

```python
result = main_agent.invoke(
    """
    AI 에이전트 프레임워크 시장을 조사하고 분석 보고서 작성

    조사 항목:
    1. LangChain과 LangGraph의 차이
    2. DeepAgents의 핵심 기능
    3. 각 프레임워크의 장단점
    4. 사용 사례 및 적용 분야
    """
)

print(result["messages"][-1].content)
```

### 실행 흐름 다이어그램

```
User: "AI 에이전트 프레임워크 조사"
    ↓
┌─────────────────────────────────────┐
│  Main Agent (Project Manager)      │
└──────────────┬──────────────────────┘
               │
               ▼
    write_todos([
        "LangChain/LangGraph 조사",
        "DeepAgents 핵심 기능 조사",
        "장단점 비교 분석",
        "사용 사례 조사",
        "최종 보고서 작성"
    ])
               │
               ▼
    ┌──────────────────────┐
    │ Task 1: LangChain    │
    └──────────┬───────────┘
               │
               ▼
    task("LangChain 조사", "research")
        ↓
    ┌──────────────────────────────┐
    │  Research Sub-agent          │
    │  - search("LangChain")       │
    │  - scrape(url)               │
    │  - 결과 정리                 │
    └──────────┬───────────────────┘
               │
               ▼
    write_file("langchain_research.txt", "...")
               │
               ▼
    ┌──────────────────────┐
    │ Task 2: DeepAgents   │
    └──────────┬───────────┘
               │
               ▼
    task("DeepAgents 조사", "research")
        ↓
    ┌──────────────────────────────┐
    │  Research Sub-agent          │
    │  - search("DeepAgents")      │
    │  - scrape(docs)              │
    │  - 핵심 기능 추출           │
    └──────────┬───────────────────┘
               │
               ▼
    write_file("deepagents_research.txt", "...")
               │
               ▼
    ┌──────────────────────┐
    │ Task 3: 비교 분석    │
    └──────────┬───────────┘
               │
               ▼
    task("장단점 비교", "analysis")
        ↓
    ┌──────────────────────────────┐
    │  Analysis Sub-agent          │
    │  - read_file("langchain...")  │
    │  - read_file("deepagents...")│
    │  - 비교 분석 수행           │
    └──────────┬───────────────────┘
               │
               ▼
    write_file("comparison_analysis.txt", "...")
               │
               ▼
    ┌──────────────────────┐
    │ Task 4: 사용 사례    │
    └──────────┬───────────┘
               │
               ▼
    task("사용 사례 조사", "research")
        ↓
    ┌──────────────────────────────┐
    │  Research Sub-agent          │
    │  - search("use cases")       │
    │  - 실제 사례 수집           │
    └──────────┬───────────────────┘
               │
               ▼
    write_file("use_cases.txt", "...")
               │
               ▼
    ┌──────────────────────┐
    │ Task 5: 최종 보고서  │
    └──────────┬───────────┘
               │
               ▼
    read_file("langchain_research.txt")
    read_file("deepagents_research.txt")
    read_file("comparison_analysis.txt")
    read_file("use_cases.txt")
        ↓
    종합 분석 및 보고서 작성
        ↓
    write_file("final_report.txt", "...")
```

---

## 🔗 LangGraph와의 관계

DeepAgents는 LangGraph 위에 구축된 상위 레벨 프레임워크

### LangGraph 기능 사용 가능

```python
from deep_agents import Agent

agent = Agent(
    model="claude-3-5-sonnet-20241022",
    tools=[search]
)

# 1. 동기 실행
result = agent.invoke("검색 수행")

# 2. 스트리밍
for chunk in agent.stream("검색 수행"):
    print(chunk)

# 3. 비동기 실행
result = await agent.ainvoke("검색 수행")

# 4. 비동기 스트리밍
async for chunk in agent.astream("검색 수행"):
    print(chunk)

# 5. 상태 조회
state = agent.get_state(config)
print(state["values"])
print(state["next"])

# 6. 상태 업데이트
agent.update_state(config, {"key": "value"})

# 7. 상태 히스토리
for state in agent.get_state_history(config):
    print(state)
```

### LangGraph 그래프 접근

```python
# 내부 그래프 직접 접근
graph = agent.graph

# LangGraph 메서드 사용
compiled = graph.compile()
result = compiled.invoke(...)

# 시각화
from IPython.display import Image, display

display(Image(graph.get_graph().draw_mermaid_png()))
```

### 커스텀 노드 추가

```python
from langgraph.graph import StateGraph

# 기본 Agent 생성
agent = Agent(...)

# 내부 그래프 접근
graph = agent.graph

# 커스텀 노드 추가
def custom_node(state):
    # 커스텀 로직
    return {"messages": state["messages"]}

graph.add_node("custom", custom_node)
graph.add_edge("agent", "custom")

# 재컴파일
agent.graph = graph
```

---

## 📊 비교 및 정리

### 기존 Agent vs DeepAgents

| 항목 | 기존 Agent | DeepAgents |
|------|-----------|-----------|
| **아키텍처** | Shallow (LLM → Tool 루프) | Deep (Planning + Filesystem + SubAgents) |
| **작업 분해** | ❌ 없음 | ✅ write_todos로 체계적 분해 |
| **컨텍스트 관리** | ❌ 메시지 히스토리만 | ✅ 파일 시스템으로 오프로드 |
| **복잡한 작업** | ❌ 실패하기 쉬움 | ✅ 효과적으로 처리 |
| **하위 작업 위임** | ❌ 불가능 | ✅ task 도구로 전문 에이전트에 위임 |
| **장기 메모리** | ❌ 없음 | ✅ 파일 시스템 + Store |
| **사용 난이도** | 간단 | 중간 (더 많은 설정 필요) |

### 언제 DeepAgents를 선택할까?

✅ **DeepAgents 선택**
- [ ] 복잡한 다단계 작업 (리서치, 코딩, 분석 등)
- [ ] 컨텍스트 윈도우 오버플로우 우려
- [ ] 작업 진행 상황 추적 필요
- [ ] 전문화된 하위 에이전트 필요
- [ ] 장기 메모리 필요

❌ **기존 Agent 선택**
- [ ] 단순한 작업 (단일 검색, 간단한 질문)
- [ ] 빠른 프로토타이핑
- [ ] 최소한의 설정으로 시작
- [ ] 컨텍스트 윈도우 내에서 완료 가능

---

## 🎓 핵심 요약

### DeepAgents의 4가지 핵심 요소

1. **Planning Tool** (`write_todos`)
   - 복잡한 작업을 관리 가능한 단위로 분해
   - 진행 상황 실시간 추적
   - 중간 결과 저장으로 재시작 용이

2. **File System** (`ls`, `read_file`, `write_file`, `edit_file`)
   - 컨텍스트 윈도우 오버플로우 방지
   - 장기 메모리로 활용
   - 중간 결과 영구 저장

3. **Sub-agents** (`task` 도구)
   - 전문화된 하위 에이전트로 작업 위임
   - 컨텍스트 격리로 혼란 방지
   - 병렬 실행 가능

4. **Detailed Prompt**
   - 도메인별 최적화된 프롬프트
   - 명확한 목표와 프로세스 정의
   - 구체적인 예시 포함

### 설치 및 시작

```bash
pip install deep-agents
```

```python
from deep_agents import Agent

agent = Agent(
    model="claude-3-5-sonnet-20241022",
    tools=[your_tools],
    system_prompt="상세한 프롬프트..."
)

result = agent.invoke("복잡한 작업 수행")
```

### 주요 특징

- **LangGraph 기반**: 모든 LangGraph 기능 사용 가능
- **모듈식 아키텍처**: Middleware로 기능 확장 용이
- **Human-in-the-Loop**: 중요한 지점에서 사람 개입 가능
- **MCP 통합**: 표준화된 도구 인터페이스

### 적용 분야

- 복잡한 리서치 프로젝트
- 멀티 스텝 코딩 작업
- 데이터 분석 및 보고서 작성
- 프로젝트 관리 및 오케스트레이션
- 장기 실행 워크플로우

---

## 참고 자료

- [DeepAgents GitHub](https://github.com/langchain-ai/deep-agents)
- [LangGraph 문서](https://langchain-ai.github.io/langgraph/)
- [Claude Code](https://claude.ai/code)
- [Deep Research](https://www.anthropic.com/research/deep-research)

---

**다음 단계**
1. DeepAgents 설치
2. 기본 예제 실행
3. 도메인별 프롬프트 커스터마이징
4. 하위 에이전트 추가
5. 실제 프로젝트에 적용
