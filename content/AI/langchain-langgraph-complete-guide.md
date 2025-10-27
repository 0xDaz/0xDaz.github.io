---
title: "LangChain과 LangGraph 완벽 가이드: AI 에이전트 개발의 모든 것"
date: 2025-10-27T23:55:34+09:00
draft: false
tags: ["LangChain", "LangGraph", "AI Agent", "RAG", "LLM", "Python"]
categories: ["AI"]
description: "LangChain과 LangGraph의 핵심 개념부터 실전 활용까지, AI 에이전트 개발을 위한 완벽 가이드. RAG, 에이전트 패턴, Unity 게임 적용 사례 포함"
---

## 🎯 Part 1: LangChain 소개

### LangChain이란

LLM 기반 애플리케이션 구축을 위한 오픈소스 프레임워크. 복잡한 AI 워크플로우를 체이닝 패턴으로 간소화

**핵심 특징:**
- **실시간 데이터 증강**: RAG를 통한 최신 정보 활용
- **모델 상호 운용성**: OpenAI, Anthropic, Cohere 등 다양한 LLM 지원
- **모듈화된 구성**: 재사용 가능한 컴포넌트 조합

### 왜 LangChain인가

```python
# LangChain 없이 (vanilla code)
response = openai.ChatCompletion.create(
    model="gpt-4",
    messages=[{"role": "user", "content": prompt}]
)
result = response.choices[0].message.content

# LangChain 사용
from langchain_openai import ChatOpenAI
from langchain_core.prompts import ChatPromptTemplate

chain = ChatPromptTemplate.from_template("Translate {text} to {language}") | ChatOpenAI(model="gpt-4")
result = chain.invoke({"text": "Hello", "language": "Korean"})
```

**장점:**
- ✅ 코드 간결화 (체이닝으로 가독성 향상)
- ✅ 모델 교체 용이 (추상화 계층 제공)
- ✅ 프로덕션 기능 내장 (재시도, 로깅, 모니터링)

### 핵심 개념

**1. 체이닝 (Chaining)**
```python
chain = prompt | model | output_parser
result = chain.invoke(input_data)
```

**2. 모듈화**
- **Prompts**: 재사용 가능한 프롬프트 템플릿
- **Models**: LLM 추상화 계층
- **Output Parsers**: 구조화된 출력 파싱
- **Retrievers**: 벡터 DB 검색 인터페이스

**3. 주요 사용 사례**
- 🔍 RAG (Retrieval-Augmented Generation)
- 💬 챗봇 및 대화형 시스템
- 📝 문서 요약 및 Q&A
- 🤖 에이전트 (도구 사용)

### LangChain 생태계

```
┌─────────────────────────────────────────┐
│         LangChain Ecosystem             │
├─────────────────────────────────────────┤
│ LangChain Core                          │
│ - 기본 추상화 (Chains, Prompts, Models) │
│                                         │
│ LangSmith                               │
│ - 디버깅, 모니터링, 평가 플랫폼          │
│                                         │
│ LangGraph                               │
│ - 복잡한 멀티 에이전트 워크플로우        │
│                                         │
│ LangGraph Platform                      │
│ - LangGraph 앱 배포 및 호스팅           │
└─────────────────────────────────────────┘
```

### 기본 예제: Simple LLM Chain

```python
from langchain_openai import ChatOpenAI
from langchain_core.prompts import ChatPromptTemplate
from langchain_core.output_parsers import StrOutputParser

# 1. 프롬프트 템플릿 정의
prompt = ChatPromptTemplate.from_messages([
    ("system", "You are a helpful translator."),
    ("user", "Translate '{text}' to {language}")
])

# 2. 모델 초기화
model = ChatOpenAI(model="gpt-4", temperature=0)

# 3. 출력 파서
parser = StrOutputParser()

# 4. 체인 구성
translation_chain = prompt | model | parser

# 5. 실행
result = translation_chain.invoke({
    "text": "Hello, world!",
    "language": "Korean"
})
print(result)  # "안녕하세요, 세상!"
```

---

## 🏗️ Part 2: LangChain 아키텍처

### 1. Basic LLM Chain 구조

```
Input
  │
  ▼
┌────────────────┐
│ Prompt Template│
│  (변수 삽입)    │
└────────┬───────┘
         │
         ▼
┌────────────────┐
│  LLM Model     │
│  (추론 실행)    │
└────────┬───────┘
         │
         ▼
┌────────────────┐
│ Output Parser  │
│  (결과 파싱)    │
└────────┬───────┘
         │
         ▼
      Output
```

**코드 구현:**
```python
from langchain_openai import ChatOpenAI
from langchain_core.prompts import ChatPromptTemplate
from langchain_core.output_parsers import StrOutputParser

# 체인 구성 (LCEL: LangChain Expression Language)
chain = (
    ChatPromptTemplate.from_template("Tell me a joke about {topic}")
    | ChatOpenAI(model="gpt-4")
    | StrOutputParser()
)

# 스트리밍 실행
for chunk in chain.stream({"topic": "programming"}):
    print(chunk, end="", flush=True)
```

### 2. RAG (Retrieval-Augmented Generation) 아키텍처

RAG는 두 단계로 구성:

**Phase 1: Indexing (오프라인)**
```
Documents
    │
    ▼
┌──────────────────┐
│  Document Loader │  ← PDF, HTML, DB 등
│  (문서 로딩)      │
└─────────┬────────┘
          │
          ▼
┌──────────────────┐
│   Text Splitter  │  ← RecursiveCharacterTextSplitter
│   (청크 분할)     │     chunk_size=1000, overlap=200
└─────────┬────────┘
          │
          ▼
┌──────────────────┐
│  Embedding Model │  ← OpenAI, Cohere 등
│  (벡터 변환)      │     text → [0.1, 0.3, ...]
└─────────┬────────┘
          │
          ▼
┌──────────────────┐
│   Vector Store   │  ← Chroma, Pinecone, FAISS
│  (벡터 DB 저장)   │
└──────────────────┘
```

**Phase 2: Retrieval + Generation (온라인)**
```
User Query: "Unity에서 AI 에이전트 구현 방법?"
    │
    ▼
┌──────────────────┐
│  Query Embedding │  ← 쿼리를 벡터로 변환
│                  │     "Unity AI..." → [0.2, 0.5, ...]
└─────────┬────────┘
          │
          ▼
┌──────────────────┐
│  Similarity      │  ← 코사인 유사도 계산
│  Search (Top-K)  │     가장 관련성 높은 K개 청크 반환
└─────────┬────────┘
          │
          ▼
┌──────────────────┐
│  Context + Query │  ← Retrieved docs + Original query
│  (프롬프트 구성)  │     "Based on: [docs], answer: [query]"
└─────────┬────────┘
          │
          ▼
┌──────────────────┐
│   LLM Generate   │  ← GPT-4로 답변 생성
│                  │
└─────────┬────────┘
          │
          ▼
       Answer
```

**RAG 전체 코드:**
```python
from langchain_community.document_loaders import PyPDFLoader
from langchain_text_splitters import RecursiveCharacterTextSplitter
from langchain_openai import OpenAIEmbeddings, ChatOpenAI
from langchain_chroma import Chroma
from langchain_core.prompts import ChatPromptTemplate
from langchain.chains import create_retrieval_chain
from langchain.chains.combine_documents import create_stuff_documents_chain

# === Phase 1: Indexing ===
# 1. 문서 로딩
loader = PyPDFLoader("unity_documentation.pdf")
docs = loader.load()

# 2. 텍스트 분할
text_splitter = RecursiveCharacterTextSplitter(
    chunk_size=1000,
    chunk_overlap=200
)
splits = text_splitter.split_documents(docs)

# 3. 임베딩 및 벡터 저장
vectorstore = Chroma.from_documents(
    documents=splits,
    embedding=OpenAIEmbeddings()
)

# === Phase 2: Retrieval + Generation ===
# 4. Retriever 생성
retriever = vectorstore.as_retriever(search_kwargs={"k": 3})

# 5. 프롬프트 템플릿
prompt = ChatPromptTemplate.from_messages([
    ("system", "Answer using the following context:\n\n{context}"),
    ("user", "{input}")
])

# 6. 체인 구성
llm = ChatOpenAI(model="gpt-4")
document_chain = create_stuff_documents_chain(llm, prompt)
retrieval_chain = create_retrieval_chain(retriever, document_chain)

# 7. 쿼리 실행
response = retrieval_chain.invoke({
    "input": "Unity에서 NavMesh를 사용한 AI 이동 구현 방법?"
})
print(response["answer"])
```

### 3. Agent 아키텍처

자율적 의사결정 루프:

```
User Query
    │
    ▼
┌─────────────────────────────────────┐
│          Agent Loop                 │
│  ┌──────────────────────────────┐  │
│  │ 1. Think (다음 행동 결정)     │  │
│  │    LLM: "검색 도구 사용 필요" │  │
│  └──────────┬───────────────────┘  │
│             │                       │
│             ▼                       │
│  ┌──────────────────────────────┐  │
│  │ 2. Act (도구 실행)           │  │
│  │    Tool: search("Unity AI")  │  │
│  └──────────┬───────────────────┘  │
│             │                       │
│             ▼                       │
│  ┌──────────────────────────────┐  │
│  │ 3. Observe (결과 분석)       │  │
│  │    Result: [search results]  │  │
│  └──────────┬───────────────────┘  │
│             │                       │
│             ▼                       │
│        충분한가?                    │
│       /        \                    │
│     Yes        No ──┐               │
│      │              │               │
│      ▼              │               │
│   Final Answer ◄────┘               │
└─────────────────────────────────────┘
```

**Agent 코드:**
```python
from langchain.agents import create_openai_functions_agent, AgentExecutor
from langchain_openai import ChatOpenAI
from langchain_core.prompts import ChatPromptTemplate, MessagesPlaceholder
from langchain_community.tools import DuckDuckGoSearchRun

# 1. 도구 정의
tools = [
    DuckDuckGoSearchRun(name="web_search"),
]

# 2. 프롬프트 (agent_scratchpad 필수)
prompt = ChatPromptTemplate.from_messages([
    ("system", "You are a helpful assistant."),
    ("user", "{input}"),
    MessagesPlaceholder(variable_name="agent_scratchpad"),
])

# 3. Agent 생성
llm = ChatOpenAI(model="gpt-4", temperature=0)
agent = create_openai_functions_agent(llm, tools, prompt)

# 4. Executor로 래핑 (루프 실행 담당)
agent_executor = AgentExecutor(agent=agent, tools=tools, verbose=True)

# 5. 실행
result = agent_executor.invoke({
    "input": "Unity 2023 LTS의 새로운 기능은?"
})
print(result["output"])
```

---

## 🔀 Part 3: LangGraph 소개

### LangGraph란

그래프 기반으로 복잡한 AI 에이전트를 구축하는 프레임워크. **순환 그래프(cyclic graph)**로 상태 머신 구현

**핵심 특징:**
- **순환 워크플로우**: 루프, 조건부 분기, 재시도 로직
- **명시적 상태 관리**: TypedDict로 상태 추적
- **체크포인트**: 실행 중 상태 저장 및 복원
- **Human-in-the-Loop**: 사람의 승인/수정 지점 삽입

### LangChain vs LangGraph 비교

| 특성 | LangChain | LangGraph |
|------|-----------|-----------|
| **구조** | 선형 체인 (Linear) | 순환 그래프 (Cyclic) |
| **상태 관리** | 암시적 (체인 간 전달) | 명시적 (TypedDict) |
| **조건부 로직** | 간단한 분기 | 복잡한 조건부 흐름 |
| **루프** | 제한적 | 네이티브 지원 |
| **체크포인트** | 없음 | 내장 (시간 여행 가능) |
| **Human-in-the-Loop** | 수동 구현 필요 | 내장 기능 |
| **사용 사례** | RAG, 단순 체인 | 멀티 에이전트, 복잡한 워크플로우 |
| **코드 복잡도** | 낮음 | 중간~높음 |

**예시: LangChain은 폭포수, LangGraph는 미로**

```
LangChain:  A → B → C → D (직선)

LangGraph:  A → B ⇄ C → D
              ↓     ↑
              E ────┘
            (순환, 재시도, 조건부)
```

### 언제 LangGraph를 사용할까

**LangGraph 적합:**
- ✅ 멀티 에이전트 협업 (Agent A가 Agent B 호출)
- ✅ 재시도/검증 로직 (답변 검증 후 재생성)
- ✅ Human-in-the-Loop (사람 승인 필요)
- ✅ 복잡한 상태 추적 (대화 히스토리, 컨텍스트)

**LangChain 적합:**
- ✅ 단순 RAG 파이프라인
- ✅ 일회성 체인 (번역, 요약)
- ✅ 빠른 프로토타이핑

---

## 🧩 Part 4: LangGraph 핵심 개념

### 1. State (상태)

TypedDict로 정의된 공유 데이터:

```python
from typing import TypedDict, Annotated
from langgraph.graph import add_messages

class State(TypedDict):
    messages: Annotated[list, add_messages]  # 메시지 누적
    context: str                              # 추가 컨텍스트
    retry_count: int                          # 재시도 횟수
```

**Reducer 함수 (add_messages):**
- 기본 동작: 덮어쓰기 (`state["key"] = value`)
- Reducer: 커스텀 업데이트 로직 (`add_messages`는 리스트에 append)

### 2. Nodes (노드)

작업 단위 (함수 또는 Runnable):

```python
def node_function(state: State) -> dict:
    """노드는 State를 받아 업데이트할 dict 반환"""
    messages = state["messages"]
    # 작업 수행
    response = llm.invoke(messages)
    return {"messages": [response]}
```

**특징:**
- 순수 함수 (side-effect 최소화)
- State 읽기 및 업데이트
- 동기/비동기 모두 지원

### 3. Edges (엣지)

노드 간 연결:

**Normal Edge (무조건 실행):**
```python
graph.add_edge("node_a", "node_b")  # A 실행 후 항상 B
```

**Conditional Edge (조건부):**
```python
def router(state: State) -> str:
    """다음 노드 이름을 반환"""
    if state["retry_count"] > 3:
        return "end"
    return "retry"

graph.add_conditional_edges(
    "validation",
    router,
    {"retry": "generation", "end": END}
)
```

### 4. Graph Builder 패턴

```python
from langgraph.graph import StateGraph, END

# 1. 그래프 정의
graph = StateGraph(State)

# 2. 노드 추가
graph.add_node("input", input_node)
graph.add_node("process", process_node)
graph.add_node("output", output_node)

# 3. 엣지 추가
graph.set_entry_point("input")
graph.add_edge("input", "process")
graph.add_conditional_edges("process", router)
graph.add_edge("output", END)

# 4. 컴파일
app = graph.compile()

# 5. 실행
result = app.invoke({"messages": [("user", "Hello")]})
```

### 5. 실행 기능

**Streaming (실시간 출력):**
```python
for event in app.stream({"messages": [("user", "Hello")]}):
    print(event)
```

**Checkpointing (상태 저장):**
```python
from langgraph.checkpoint.memory import MemorySaver

memory = MemorySaver()
app = graph.compile(checkpointer=memory)

# 스레드별 상태 유지
config = {"configurable": {"thread_id": "thread-1"}}
app.invoke(input, config=config)
```

**Human-in-the-Loop:**
```python
from langgraph.checkpoint.memory import MemorySaver

app = graph.compile(checkpointer=MemorySaver(), interrupt_before=["human_review"])

# 실행이 human_review 전에 중단
result = app.invoke(input, config=config)

# 사람이 승인 후 재개
app.invoke(None, config=config)
```

**Time-Travel (과거 상태로 복귀):**
```python
# 모든 체크포인트 조회
checkpoints = app.get_state_history(config)

# 특 checkpoint로 복귀
past_config = {"configurable": {"thread_id": "thread-1", "checkpoint_id": "abc123"}}
app.invoke(None, config=past_config)
```

---

## 🎨 Part 5: LangGraph 워크플로우 패턴

### 1. Prompt Chaining (순차 처리)

```
Input → Step1 → Step2 → Step3 → Output
```

**ASCII 다이어그램:**
```
   START
     │
     ▼
┌─────────┐
│  Step1  │  Outline 생성
└────┬────┘
     │
     ▼
┌─────────┐
│  Step2  │  Draft 작성
└────┬────┘
     │
     ▼
┌─────────┐
│  Step3  │  Refine
└────┬────┘
     │
     ▼
    END
```

**코드:**
```python
from langgraph.graph import StateGraph, END

class State(TypedDict):
    input: str
    outline: str
    draft: str
    final: str

def step1(state):
    outline = llm.invoke(f"Create outline for: {state['input']}")
    return {"outline": outline}

def step2(state):
    draft = llm.invoke(f"Write draft based on: {state['outline']}")
    return {"draft": draft}

def step3(state):
    final = llm.invoke(f"Refine: {state['draft']}")
    return {"final": final}

graph = StateGraph(State)
graph.add_node("step1", step1)
graph.add_node("step2", step2)
graph.add_node("step3", step3)
graph.set_entry_point("step1")
graph.add_edge("step1", "step2")
graph.add_edge("step2", "step3")
graph.add_edge("step3", END)

app = graph.compile()
```

### 2. Parallelization (병렬 처리)

```
         ┌─ Task1 ─┐
Input ──┼─ Task2 ──┼─ Aggregate → Output
         └─ Task3 ─┘
```

**ASCII 다이어그램:**
```
       START
         │
         ▼
    ┌─────────┐
    │  Fanout │
    └────┬────┘
         │
    ┌────┼────┐
    │    │    │
    ▼    ▼    ▼
 ┌───┐┌───┐┌───┐
 │ T1││ T2││ T3│  (병렬 실행)
 └─┬─┘└─┬─┘└─┬─┘
   │    │    │
   └────┼────┘
        │
        ▼
   ┌─────────┐
   │  Fanin  │  (결과 병합)
   └────┬────┘
        │
        ▼
       END
```

**코드:**
```python
from langgraph.graph import StateGraph, END
from langgraph.constants import Send

class State(TypedDict):
    query: str
    results: list[str]

def parallel_search(state):
    # Send API로 병렬 노드 생성
    return [
        Send("search_web", {"query": state["query"]}),
        Send("search_db", {"query": state["query"]}),
        Send("search_docs", {"query": state["query"]})
    ]

def search_web(state):
    result = web_search(state["query"])
    return {"results": [result]}

def search_db(state):
    result = db_query(state["query"])
    return {"results": [result]}

def search_docs(state):
    result = doc_search(state["query"])
    return {"results": [result]}

def aggregate(state):
    combined = "\n".join(state["results"])
    return {"final": combined}

graph = StateGraph(State)
graph.add_node("fanout", parallel_search)
graph.add_node("search_web", search_web)
graph.add_node("search_db", search_db)
graph.add_node("search_docs", search_docs)
graph.add_node("aggregate", aggregate)

graph.set_entry_point("fanout")
graph.add_edge("search_web", "aggregate")
graph.add_edge("search_db", "aggregate")
graph.add_edge("search_docs", "aggregate")
graph.add_edge("aggregate", END)

app = graph.compile()
```

### 3. Routing (분류 및 라우팅)

```
         ┌─ Route A
Input ──Router
         └─ Route B
```

**ASCII 다이어그램:**
```
      START
        │
        ▼
   ┌─────────┐
   │ Router  │  (쿼리 분류)
   └────┬────┘
        │
    ┌───┴───┐
    │       │
    ▼       ▼
┌───────┐ ┌───────┐
│ Math  │ │General│
│Solver │ │  QA   │
└───┬───┘ └───┬───┘
    │       │
    └───┬───┘
        │
        ▼
       END
```

**코드:**
```python
def router(state):
    query = state["query"]
    classification = llm.invoke(f"Classify query: {query}. Reply 'math' or 'general'")
    if "math" in classification.lower():
        return "math"
    return "general"

def math_solver(state):
    answer = solve_math(state["query"])
    return {"answer": answer}

def general_qa(state):
    answer = llm.invoke(state["query"])
    return {"answer": answer}

graph = StateGraph(State)
graph.add_node("router", lambda s: s)
graph.add_node("math", math_solver)
graph.add_node("general", general_qa)

graph.set_entry_point("router")
graph.add_conditional_edges(
    "router",
    router,
    {"math": "math", "general": "general"}
)
graph.add_edge("math", END)
graph.add_edge("general", END)

app = graph.compile()
```

### 4. Orchestrator-Worker (동적 작업 분배)

```
Orchestrator → [Worker1, Worker2, ...] → Orchestrator
     ↓                                         ↓
  계획 수립                                  결과 통합
```

**ASCII 다이어그램:**
```
       START
         │
         ▼
  ┌─────────────┐
  │Orchestrator │  "3개 서브태스크 생성"
  └──────┬──────┘
         │
     [Send API]
         │
    ┌────┼────┐
    │    │    │
    ▼    ▼    ▼
  ┌───┐┌───┐┌───┐
  │W1 ││W2 ││W3 │  (동적 생성)
  └─┬─┘└─┬─┘└─┬─┘
    │    │    │
    └────┼────┘
         │
         ▼
  ┌─────────────┐
  │Orchestrator │  결과 통합
  └──────┬──────┘
         │
         ▼
        END
```

**코드:**
```python
def orchestrator(state):
    if "tasks" not in state:
        # 초기 계획
        plan = llm.invoke(f"Break down: {state['query']}")
        tasks = parse_tasks(plan)
        return {"tasks": tasks}
    else:
        # 결과 통합
        final = combine_results(state["worker_results"])
        return {"final": final}

def worker(state):
    task = state["current_task"]
    result = execute_task(task)
    return {"worker_results": [result]}

graph = StateGraph(State)
graph.add_node("orchestrator", orchestrator)
graph.add_node("worker", worker)

def route_after_orchestrator(state):
    if "tasks" in state and not state.get("worker_results"):
        # 작업자들에게 분배
        return [Send("worker", {"current_task": t}) for t in state["tasks"]]
    return "end"

graph.set_entry_point("orchestrator")
graph.add_conditional_edges("orchestrator", route_after_orchestrator)
graph.add_edge("worker", "orchestrator")

app = graph.compile()
```

### 5. Evaluator-Optimizer (반복 개선)

```
Generate → Evaluate → Refine → Evaluate → ...
    ↑                    │
    └────────────────────┘ (재시도 루프)
```

**ASCII 다이어그램:**
```
      START
        │
        ▼
   ┌─────────┐
   │Generate │  초기 답변 생성
   └────┬────┘
        │
        ▼
   ┌─────────┐
   │Evaluate │  품질 평가
   └────┬────┘
        │
     Pass?
    ┌───┴───┐
   Yes     No
    │       │
    │       ▼
    │  ┌─────────┐
    │  │ Refine  │  개선
    │  └────┬────┘
    │       │
    │       └──────┐
    │              │
    ▼              ▼
   END      ┌─────────┐
            │Evaluate │
            └─────────┘
              (루프)
```

**코드:**
```python
class State(TypedDict):
    query: str
    answer: str
    score: float
    retry_count: int

def generate(state):
    answer = llm.invoke(state["query"])
    return {"answer": answer, "retry_count": state.get("retry_count", 0)}

def evaluate(state):
    score = llm.invoke(f"Rate quality (0-10): {state['answer']}")
    return {"score": float(score)}

def refine(state):
    improved = llm.invoke(f"Improve: {state['answer']}")
    return {
        "answer": improved,
        "retry_count": state["retry_count"] + 1
    }

def should_continue(state):
    if state["score"] >= 8 or state["retry_count"] >= 3:
        return "end"
    return "refine"

graph = StateGraph(State)
graph.add_node("generate", generate)
graph.add_node("evaluate", evaluate)
graph.add_node("refine", refine)

graph.set_entry_point("generate")
graph.add_edge("generate", "evaluate")
graph.add_conditional_edges(
    "evaluate",
    should_continue,
    {"refine": "refine", "end": END}
)
graph.add_edge("refine", "evaluate")

app = graph.compile()
```

### 6. Agent (자율 에이전트)

```
Think → Act → Observe → Think → ...
  ↑              │
  └──────────────┘ (도구 사용 루프)
```

**ASCII 다이어그램:**
```
       START
         │
         ▼
    ┌─────────┐
    │  Agent  │  "무엇을 할까?"
    └────┬────┘
         │
    ┌────┴────┐
    │         │
Finish?      No
    │         │
   Yes        ▼
    │    ┌─────────┐
    │    │  Tool   │  검색, 계산 등
    │    └────┬────┘
    │         │
    │         ▼
    │    ┌─────────┐
    │    │  Agent  │  "결과 분석"
    │    └────┬────┘
    │         │
    └─────────┴────┐
                   │
                   ▼
                  END
```

**코드:**
```python
from langchain.agents import create_openai_functions_agent
from langchain_core.messages import HumanMessage

class AgentState(TypedDict):
    messages: Annotated[list, add_messages]

def call_agent(state):
    response = agent_executor.invoke({"input": state["messages"][-1].content})
    return {"messages": [HumanMessage(content=response["output"])]}

def should_continue(state):
    last_message = state["messages"][-1]
    if "FINAL ANSWER" in last_message.content:
        return "end"
    return "continue"

graph = StateGraph(AgentState)
graph.add_node("agent", call_agent)
graph.set_entry_point("agent")
graph.add_conditional_edges(
    "agent",
    should_continue,
    {"continue": "agent", "end": END}
)

app = graph.compile()
```

---

## 💻 Part 6: 실전 코드 예제

### 예제 1: 간단한 챗봇 with 루프

**요구사항:** 대화 히스토리 유지, 무한 대화 가능

```python
from typing import Annotated
from langchain_openai import ChatOpenAI
from langchain_core.messages import HumanMessage, SystemMessage
from langgraph.graph import StateGraph, END
from langgraph.graph.message import add_messages
from langgraph.checkpoint.memory import MemorySaver

# 1. State 정의
class ChatState(TypedDict):
    messages: Annotated[list, add_messages]

# 2. Chatbot 노드
def chatbot(state: ChatState):
    llm = ChatOpenAI(model="gpt-4", temperature=0.7)
    response = llm.invoke(state["messages"])
    return {"messages": [response]}

# 3. 그래프 구성
graph = StateGraph(ChatState)
graph.add_node("chatbot", chatbot)
graph.set_entry_point("chatbot")
graph.add_edge("chatbot", END)

# 4. 메모리 추가 (대화 히스토리)
memory = MemorySaver()
app = graph.compile(checkpointer=memory)

# 5. 실행 (스레드별 상태 유지)
config = {"configurable": {"thread_id": "user-123"}}

# 첫 메시지
response1 = app.invoke(
    {"messages": [HumanMessage(content="안녕? 내 이름은 철수야")]},
    config=config
)
print(response1["messages"][-1].content)
# "안녕하세요 철수님! 무엇을 도와드릴까요?"

# 두 번째 메시지 (이전 대화 기억)
response2 = app.invoke(
    {"messages": [HumanMessage(content="내 이름이 뭐였지?")]},
    config=config
)
print(response2["messages"][-1].content)
# "철수님이세요!"
```

**실행 흐름:**
```
┌─ Invoke 1 ──────────────────┐
│ Input: "안녕? 내 이름은 철수"│
│   ↓                         │
│ [Checkpoint Save]           │
│   ↓                         │
│ Output: "안녕하세요 철수님!"│
└─────────────────────────────┘

┌─ Invoke 2 ──────────────────┐
│ [Checkpoint Load]           │
│   ↓                         │
│ Input: "내 이름이 뭐였지?"  │
│   ↓                         │
│ Context: 이전 대화 포함     │
│   ↓                         │
│ Output: "철수님이세요!"     │
└─────────────────────────────┘
```

### 예제 2: RAG + Self-Correction Agent

**요구사항:** 답변 검증 후 부족하면 재검색

```python
from typing import TypedDict, Annotated
from langchain_openai import ChatOpenAI, OpenAIEmbeddings
from langchain_chroma import Chroma
from langchain_core.messages import HumanMessage
from langgraph.graph import StateGraph, END, add_messages

# 1. State 정의
class RAGState(TypedDict):
    query: str
    documents: list[str]
    answer: str
    grade: str
    retry_count: int

# 2. Retriever 노드
def retrieve(state: RAGState):
    vectorstore = Chroma(embedding_function=OpenAIEmbeddings())
    docs = vectorstore.similarity_search(state["query"], k=3)
    return {
        "documents": [doc.page_content for doc in docs],
        "retry_count": state.get("retry_count", 0)
    }

# 3. Generator 노드
def generate(state: RAGState):
    context = "\n".join(state["documents"])
    prompt = f"Context:\n{context}\n\nQuestion: {state['query']}"

    llm = ChatOpenAI(model="gpt-4")
    answer = llm.invoke([HumanMessage(content=prompt)])
    return {"answer": answer.content}

# 4. Grader 노드 (답변 평가)
def grade_answer(state: RAGState):
    llm = ChatOpenAI(model="gpt-4")
    prompt = f"""
    Question: {state['query']}
    Answer: {state['answer']}

    Is this answer good? Reply only 'good' or 'bad'.
    """
    grade = llm.invoke([HumanMessage(content=prompt)]).content.lower()
    return {"grade": grade}

# 5. Refine 노드 (재검색)
def refine_query(state: RAGState):
    llm = ChatOpenAI(model="gpt-4")
    improved_query = llm.invoke([
        HumanMessage(content=f"Rephrase for better search: {state['query']}")
    ]).content
    return {
        "query": improved_query,
        "retry_count": state["retry_count"] + 1
    }

# 6. Router (계속 vs 종료)
def should_continue(state: RAGState):
    if state["grade"] == "good" or state["retry_count"] >= 2:
        return "end"
    return "refine"

# 7. 그래프 구성
graph = StateGraph(RAGState)
graph.add_node("retrieve", retrieve)
graph.add_node("generate", generate)
graph.add_node("grade", grade_answer)
graph.add_node("refine", refine_query)

graph.set_entry_point("retrieve")
graph.add_edge("retrieve", "generate")
graph.add_edge("generate", "grade")
graph.add_conditional_edges(
    "grade",
    should_continue,
    {"refine": "refine", "end": END}
)
graph.add_edge("refine", "retrieve")

app = graph.compile()

# 8. 실행
result = app.invoke({
    "query": "Unity에서 NavMesh 사용법?",
    "retry_count": 0
})
print(result["answer"])
```

**실행 흐름 (Self-Correction):**
```
START
  │
  ▼
┌──────────┐
│ Retrieve │  docs = ["NavMesh basics", ...]
└────┬─────┘
     │
     ▼
┌──────────┐
│ Generate │  answer = "NavMesh는..."
└────┬─────┘
     │
     ▼
┌──────────┐
│  Grade   │  grade = "bad" (정보 부족)
└────┬─────┘
     │
     ▼
  "refine"
     │
     ▼
┌──────────┐
│  Refine  │  query = "Unity NavMesh 상세 가이드"
└────┬─────┘
     │
     ▼
┌──────────┐
│ Retrieve │  docs = [더 나은 문서들]
└────┬─────┘
     │
     ▼
┌──────────┐
│ Generate │  answer = "NavMesh는 Unity의..."
└────┬─────┘
     │
     ▼
┌──────────┐
│  Grade   │  grade = "good"
└────┬─────┘
     │
     ▼
    END
```

---

## 🚀 Part 7: 고급 기능

### 1. Human-in-the-Loop

**사용 사례:** 중요 결정 전 사람 승인 필요

```python
from langgraph.checkpoint.memory import MemorySaver
from langgraph.graph import StateGraph, END

class ApprovalState(TypedDict):
    request: str
    approval: str
    result: str

def generate_plan(state):
    plan = llm.invoke(f"Create plan for: {state['request']}")
    return {"approval": plan}

def execute_plan(state):
    result = execute(state["approval"])
    return {"result": result}

graph = StateGraph(ApprovalState)
graph.add_node("plan", generate_plan)
graph.add_node("human_review", lambda s: s)  # 사람 승인 노드
graph.add_node("execute", execute_plan)

graph.set_entry_point("plan")
graph.add_edge("plan", "human_review")
graph.add_edge("human_review", "execute")
graph.add_edge("execute", END)

# interrupt_before로 중단점 설정
memory = MemorySaver()
app = graph.compile(
    checkpointer=memory,
    interrupt_before=["human_review"]
)

# 실행
config = {"configurable": {"thread_id": "approval-1"}}
result = app.invoke({"request": "Delete all data"}, config=config)

# 상태 확인
state = app.get_state(config)
print(state.values["approval"])  # 계획 확인

# 사람이 승인 후 재개
app.invoke(None, config=config)  # 계속 실행
```

**플로우:**
```
START
  │
  ▼
Generate Plan
  │
  ▼
[INTERRUPT] ← 실행 중단, 사람 확인 대기
  │
(사람 승인)
  │
  ▼
Execute Plan
  │
  ▼
END
```

### 2. Streaming

**실시간 출력:**

```python
# 이벤트 스트리밍
for event in app.stream({"query": "Hello"}):
    print(event)
    # {"retrieve": {"documents": [...]}}
    # {"generate": {"answer": "..."}}

# 노드별 스트리밍
for node, output in app.stream(input, stream_mode="updates"):
    print(f"[{node}] {output}")
```

### 3. Parallel Execution (Send API)

**동적으로 병렬 노드 생성:**

```python
from langgraph.constants import Send

def fanout(state):
    tasks = ["task1", "task2", "task3"]
    return [Send("worker", {"task": t}) for t in tasks]

def worker(state):
    result = process(state["task"])
    return {"results": [result]}

graph = StateGraph(State)
graph.add_node("fanout", fanout)
graph.add_node("worker", worker)
graph.add_node("aggregate", aggregate)

graph.set_entry_point("fanout")
graph.add_edge("worker", "aggregate")
graph.add_edge("aggregate", END)

app = graph.compile()
```

**실행:**
```
  fanout
    │
 [Send API]
    │
┌───┼───┐
│   │   │
▼   ▼   ▼
W1  W2  W3  (병렬)
│   │   │
└───┼───┘
    │
aggregate
```

### 전체 아키텍처

```
┌─────────────────────────────────────────────────┐
│            LangGraph Application                │
├─────────────────────────────────────────────────┤
│                                                 │
│  ┌──────────────────────────────────────────┐  │
│  │         StateGraph                       │  │
│  │  ┌────┐  ┌────┐  ┌────┐  ┌────┐        │  │
│  │  │Node│→│Node│→│Node│→│Node│→END      │  │
│  │  └────┘  └────┘  └─┬──┘  └────┘        │  │
│  │                     │                    │  │
│  │                     └──────┐             │  │
│  │                            │             │  │
│  │                     [Conditional Edge]   │  │
│  └──────────────────────────────────────────┘  │
│                                                 │
│  ┌──────────────────────────────────────────┐  │
│  │         Checkpointer (MemorySaver)       │  │
│  │  - 상태 저장/복원                         │  │
│  │  - Human-in-the-Loop                    │  │
│  │  - Time Travel                          │  │
│  └──────────────────────────────────────────┘  │
│                                                 │
│  ┌──────────────────────────────────────────┐  │
│  │         Streaming                        │  │
│  │  - 실시간 이벤트 출력                     │  │
│  │  - 노드별 진행 상황                       │  │
│  └──────────────────────────────────────────┘  │
│                                                 │
│  ┌──────────────────────────────────────────┐  │
│  │         Parallel Execution (Send API)    │  │
│  │  - 동적 노드 생성                         │  │
│  │  - Map-Reduce 패턴                       │  │
│  └──────────────────────────────────────────┘  │
└─────────────────────────────────────────────────┘
```

---

## 🎮 Part 8: 실전 활용 사례 (Unity 게임)

### 1. Dynamic NPC Dialogue System

**요구사항:** NPC가 대화 히스토리를 기억하며 상황에 맞게 응답

```python
from langgraph.graph import StateGraph, END
from langgraph.checkpoint.memory import MemorySaver

class NPCState(TypedDict):
    player_name: str
    dialogue_history: Annotated[list, add_messages]
    npc_mood: str  # happy, angry, neutral
    quest_status: str

def npc_respond(state):
    context = f"""
    Player: {state['player_name']}
    Mood: {state['npc_mood']}
    Quest: {state['quest_status']}
    """
    prompt = f"{context}\nDialogue: {state['dialogue_history'][-1].content}"
    response = llm.invoke(prompt)

    return {"dialogue_history": [response]}

def update_mood(state):
    # 대화 내용 분석해서 기분 변화
    last_message = state["dialogue_history"][-1].content
    if "rude" in last_message.lower():
        return {"npc_mood": "angry"}
    return {"npc_mood": "happy"}

graph = StateGraph(NPCState)
graph.add_node("respond", npc_respond)
graph.add_node("update_mood", update_mood)

graph.set_entry_point("respond")
graph.add_edge("respond", "update_mood")
graph.add_edge("update_mood", END)

memory = MemorySaver()
app = graph.compile(checkpointer=memory)

# Unity에서 호출
config = {"configurable": {"thread_id": "npc-blacksmith-001"}}
result = app.invoke({
    "player_name": "Hero",
    "dialogue_history": [HumanMessage(content="무기 팔아?")],
    "npc_mood": "neutral",
    "quest_status": "not_started"
}, config=config)
```

**워크플로우:**
```
Player Input
     │
     ▼
┌─────────────┐
│ NPC Respond │  "어서오세요! 무기는 이쪽입니다"
└──────┬──────┘
       │
       ▼
┌─────────────┐
│Update Mood  │  mood = "happy"
└──────┬──────┘
       │
       ▼
  [Checkpoint Save]
       │
       ▼
  Unity Display
```

### 2. Dynamic Quest Generator

**요구사항:** 플레이어 레벨/선호도에 맞는 퀘스트 생성

```python
class QuestState(TypedDict):
    player_level: int
    preferences: list[str]  # ["combat", "exploration", "puzzle"]
    generated_quests: list[dict]
    selected_quest: dict

def generate_quest_ideas(state):
    prompt = f"""
    Player Level: {state['player_level']}
    Preferences: {state['preferences']}

    Generate 3 quest ideas.
    """
    ideas = llm.invoke(prompt)
    return {"generated_quests": parse_quests(ideas)}

def evaluate_quests(state):
    # 각 퀘스트의 적합도 평가
    scores = []
    for quest in state["generated_quests"]:
        score = calculate_fit(quest, state["preferences"])
        scores.append(score)

    best_idx = scores.index(max(scores))
    return {"selected_quest": state["generated_quests"][best_idx]}

def refine_quest(state):
    quest = state["selected_quest"]
    refined = llm.invoke(f"Add details to quest: {quest}")
    return {"selected_quest": refined}

graph = StateGraph(QuestState)
graph.add_node("generate", generate_quest_ideas)
graph.add_node("evaluate", evaluate_quests)
graph.add_node("refine", refine_quest)

graph.set_entry_point("generate")
graph.add_edge("generate", "evaluate")
graph.add_edge("evaluate", "refine")
graph.add_edge("refine", END)

app = graph.compile()
```

**워크플로우:**
```
Player Profile
     │
     ▼
┌──────────────┐
│  Generate    │  3개 퀘스트 아이디어
│  Quest Ideas │  - 고블린 토벌 (combat)
└──────┬───────┘  - 던전 탐험 (exploration)
       │          - 수수께끼 (puzzle)
       ▼
┌──────────────┐
│  Evaluate    │  preferences: ["combat"]
│   Quests     │  → 고블린 토벌 선택
└──────┬───────┘
       │
       ▼
┌──────────────┐
│  Refine      │  상세 정보 추가:
│   Quest      │  - 위치: 어두운 숲
└──────┬───────┘  - 보상: 100 gold, 경험치
       │          - 난이도: 레벨 5 권장
       ▼
Unity Quest System
```

### 3. Adaptive Difficulty Adjustment

**요구사항:** 플레이어 실력에 맞춰 실시간 난이도 조정

```python
class DifficultyState(TypedDict):
    player_stats: dict  # {"hp": 100, "damage": 50, ...}
    recent_deaths: int
    win_rate: float
    current_difficulty: float
    adjustment: str

def analyze_performance(state):
    # 최근 성과 분석
    if state["win_rate"] < 0.3:
        return {"adjustment": "decrease"}
    elif state["win_rate"] > 0.7:
        return {"adjustment": "increase"}
    return {"adjustment": "maintain"}

def calculate_difficulty(state):
    current = state["current_difficulty"]

    if state["adjustment"] == "decrease":
        new_difficulty = max(0.5, current - 0.1)
    elif state["adjustment"] == "increase":
        new_difficulty = min(2.0, current + 0.1)
    else:
        new_difficulty = current

    return {"current_difficulty": new_difficulty}

def apply_to_game(state):
    difficulty = state["current_difficulty"]
    # Unity로 전송할 파라미터 생성
    params = {
        "enemy_health_multiplier": difficulty,
        "enemy_damage_multiplier": difficulty,
        "spawn_rate_multiplier": difficulty
    }
    return {"game_params": params}

graph = StateGraph(DifficultyState)
graph.add_node("analyze", analyze_performance)
graph.add_node("calculate", calculate_difficulty)
graph.add_node("apply", apply_to_game)

graph.set_entry_point("analyze")
graph.add_edge("analyze", "calculate")
graph.add_edge("calculate", "apply")
graph.add_edge("apply", END)

app = graph.compile()

# Unity에서 주기적으로 호출 (예: 매 웨이브 종료 후)
result = app.invoke({
    "player_stats": {"hp": 80, "damage": 50},
    "recent_deaths": 5,
    "win_rate": 0.25,  # 25% 승률
    "current_difficulty": 1.0
})

print(result["current_difficulty"])  # 0.9 (감소)
```

**워크플로우:**
```
Game Session Data
     │
     ▼
┌───────────────┐
│   Analyze     │  win_rate = 25%
│  Performance  │  → adjustment = "decrease"
└───────┬───────┘
        │
        ▼
┌───────────────┐
│  Calculate    │  1.0 → 0.9 (난이도 감소)
│  Difficulty   │
└───────┬───────┘
        │
        ▼
┌───────────────┐
│  Apply to     │  enemy_health: ×0.9
│  Game         │  enemy_damage: ×0.9
└───────┬───────┘  spawn_rate: ×0.9
        │
        ▼
Unity Game Manager
     │
     ▼
Next Wave (더 쉬워짐)
```

---

## 📝 Part 9: 정리

### LangGraph 사용 시점

**✅ LangGraph 선택:**
- [ ] 순환 워크플로우 필요 (재시도, 루프)
- [ ] 복잡한 조건부 로직 (if-else가 많음)
- [ ] 멀티 에이전트 협업
- [ ] Human-in-the-Loop 필요
- [ ] 상태 체크포인트 (중단/재개)
- [ ] 동적 작업 분배 (Orchestrator-Worker)

**예시 코드 복잡도:**
```python
# LangGraph로 구현 (20줄)
graph = StateGraph(State)
graph.add_node("step1", step1)
graph.add_conditional_edges("step1", router)
app = graph.compile()
```

### LangChain 사용 시점

**✅ LangChain 선택:**
- [ ] 단순 선형 체인 (A → B → C)
- [ ] RAG 파이프라인 (검색 → 생성)
- [ ] 일회성 작업 (번역, 요약)
- [ ] 빠른 프로토타이핑
- [ ] 상태 관리 불필요

**예시 코드 복잡도:**
```python
# LangChain으로 구현 (5줄)
chain = prompt | model | parser
result = chain.invoke(input)
```

### 코드 비교

**동일한 작업 (RAG + 재시도):**

```python
# LangChain (재시도 수동 구현, 20줄)
for i in range(3):
    docs = retriever.get_relevant_documents(query)
    answer = chain.invoke({"context": docs, "query": query})
    if validate(answer):
        break

# LangGraph (워크플로우로 표현, 10줄)
graph = StateGraph(State)
graph.add_node("retrieve", retrieve)
graph.add_node("generate", generate)
graph.add_conditional_edges("generate", should_retry)
app = graph.compile()
```

### 핵심 요약

**LangChain:**
- 간단한 체이닝, RAG 파이프라인
- 프로토타이핑에 최적
- 코드 간결

**LangGraph:**
- 복잡한 워크플로우, 멀티 에이전트
- 프로덕션 기능 내장 (체크포인트, HITL)
- 순환 그래프로 유연성 확보

**선택 기준:**
```
단순 체인? → LangChain
순환 로직? → LangGraph
멀티 에이전트? → LangGraph
RAG만? → LangChain
상태 추적? → LangGraph
```

---

## 🔗 참고 자료

- [LangChain 공식 문서](https://python.langchain.com/)
- [LangGraph 공식 문서](https://langchain-ai.github.io/langgraph/)
- [LangSmith](https://smith.langchain.com/)
- [GitHub - LangChain](https://github.com/langchain-ai/langchain)
- [GitHub - LangGraph](https://github.com/langchain-ai/langgraph)

---
