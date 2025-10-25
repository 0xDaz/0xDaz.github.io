---
title: "ClaudeCode로 Unity 게임 개발 자동화 구축"
date: 2025-10-25T14:30:00+09:00
tags: ["Unity", "GameDev", "ClaudeCode", "MCP", "Automation", "Steam", "CI/CD"]
categories: ["Env"]
draft: false
---

## 개요

ClaudeCode + MCP 서버 + 전문 에이전트로 Unity 3D 게임 개발 파이프라인 자동화

뱀파이어 서바이버류(bullet heaven) 장르 Steam 게임 프로젝트를 대상으로 설계부터 배포까지 자동화

## 에이전트 구성

7개 전문 에이전트가 도메인별로 업무 처리

### 1. unity-client-dev

Unity 구현 전문가

- Context7 기반 최신 API 적용
- OOP/SOLID 원칙 준수
- UnityMCP로 Editor 직접 제어

### 2. unity-asset-finder

Asset Store 검색 자동화

- Playwright로 실시간 검색
- 리뷰 분석 및 추천
- 가격/라이선스 정보 수집

### 3. game-design-expert

뱀서류 장르 메카닉 설계

- 밸런싱 시뮬레이션
- Steam 통합 기획
- 진행도 시스템 설계

### 4. game-project-manager

프로젝트 관리 자동화

- Linear ↔ Task Master 동기화
- PRD 파싱 및 작업 분해
- TDD 워크플로우 관리

### 5. blog-manager

Hugo 블로그 자동 작성

- 마크다운 생성
- 스타일 가이드 준수
- 이미지 경로 자동 처리

### 6. git-expert

Git 작업 전담

- Unity .meta 파일 자동 관리
- 브랜치 전략 수립
- 충돌 해결

### 7. prompt-engineer

에이전트 프롬프트 최적화

- 토큰 20-40% 절감
- 성능 평가 및 개선
- 에이전트 간 일관성 유지

## MCP 서버 구성

7개 MCP 서버로 외부 도구 연동

```yaml
Linear (HTTP):
  - 이슈, 프로젝트, 사이클 관리
  - 팀 협업 중앙 허브

GitHub (HTTP):
  - 이슈, PR, 커밋 관리
  - 코드 검색 및 리뷰

Playwright (stdio):
  - 브라우저 자동화
  - Asset Store 크롤링
  - 스크린샷 기반 테스팅

Context7 (stdio):
  - 실시간 라이브러리 문서 검색
  - Unity, Hugo, Steam API 최신 정보
  - API 변경 감지

mcp-obsidian (Python):
  - Obsidian 노트 관리
  - 개발 로그 자동 기록

UnityMCP (Python):
  - Unity Editor 직접 제어
  - Scene, GameObject, Script 관리
  - 컴파일 에러 자동 수집

task-master-ai (stdio):
  - 로컬 작업 분해
  - 상태 추적
  - TDD 워크플로우 자동화
```

## 워크플로우 트리

```
사용자 요청
│
├─ 게임 기획
│  └─ game-design-expert
│     ├─ game-project-manager (작업 분해)
│     └─ blog-manager (문서화)
│
├─ Unity 구현
│  └─ unity-client-dev
│     ├─ context7 (API 확인)
│     ├─ UnityMCP (Editor 제어)
│     ├─ git-expert (커밋)
│     └─ game-project-manager (상태 업데이트)
│
├─ 에셋 검색
│  └─ unity-asset-finder
│     ├─ playwright (크롤링)
│     └─ blog-manager (추천 포스트)
│
├─ 프로젝트 관리
│  └─ game-project-manager
│     ├─ linear (외부 이슈)
│     ├─ task-master-ai (로컬 작업)
│     └─ git-expert (브랜치 관리)
│
├─ 블로그 포스팅
│  └─ blog-manager
│     ├─ context7 (Hugo API)
│     └─ git-expert (배포)
│
├─ Git 작업
│  └─ git-expert
│     └─ github (원격 작업)
│
└─ 에이전트 최적화
   └─ prompt-engineer
      └─ git-expert (변경 커밋)
```

## 핵심 통합 패턴

### 1. Context-First

Unity/Hugo 구현 전 Context7로 최신 API 확인

```python
# Bad: 지식 기반 구현
def CreatePlayer():
    GameObject.Instantiate(playerPrefab)

# Good: Context7 확인 후 구현
1. resolve-library-id("Unity")
2. get-library-docs(library_id, topic: "GameObject lifecycle")
3. 최신 API로 구현
```

### 2. Dual-Tracking

Linear(외부) + Task Master(로컬) 이중 추적

```yaml
Linear:
  - 팀 공유 이슈
  - 마일스톤 관리
  - 외부 협업

Task Master:
  - 로컬 작업 분해
  - TDD 워크플로우
  - 개인 진행도 추적
```

### 3. Unity 워크플로우

```mermaid
Context7 → UnityMCP → git-expert → blog-manager
```

1. Context7로 API 확인
2. UnityMCP로 Scene/Script 생성
3. git-expert로 .meta 파일 포함 커밋
4. blog-manager로 기능 문서화

### 4. 에이전트 오케스트레이션

CLAUDE.md가 요청 분석 후 적절한 에이전트 호출

```yaml
요청 분류:
  게임 기획: game-design-expert
  Unity 구현: unity-client-dev
  에셋 검색: unity-asset-finder
  프로젝트 관리: game-project-manager
  블로그 작성: blog-manager
  Git 작업: git-expert
  프롬프트 개선: prompt-engineer
```

## 자동화 레벨

### L1: Unity Editor 직접 제어

UnityMCP로 Scene, GameObject, Component 관리

```csharp
// UnityMCP 명령
manage_gameobject(
  action="create",
  name="Player",
  components_to_add=["Rigidbody", "PlayerController"]
)
```

### L2: 외부 도구 연동

Linear, GitHub, Asset Store 자동 작업

```python
# Linear 이슈 생성 → Task Master 작업 분해
linear.create_issue(title="플레이어 이동 구현")
task_master.parse_prd(issue_description)
```

### L3: 문서/코드 생성

Context7 기반 최신 API 적용

```python
# 구현 전 문서 확인
context7.get_library_docs(
  library_id="/unity/docs",
  topic="CharacterController"
)
```

### L4: 작업 분해/추적

Task Master + Linear 동기화

```yaml
PRD → Task Master:
  - 대작업 10개 생성
  - 각 대작업 5-10개 하위 작업 분해
  - Linear 이슈와 ID 동기화
  - TDD 워크플로우 자동 진행
```

## 안전 장치

### Context7로 API 변경 감지

```python
# 구현 전 항상 확인
if using_unity_api:
    context7.resolve_library_id("Unity")
    latest_docs = context7.get_library_docs(topic="specific_feature")
    apply(latest_docs)
```

### git-expert의 .meta 파일 자동 관리

```yaml
Unity 규칙:
  - 모든 에셋에 .meta 파일 필수
  - GUID 보존 위해 .meta 항상 커밋
  - .gitignore에 .meta 추가 금지
  - git-expert가 자동 처리
```

### prompt-engineer의 토큰 최적화

```yaml
최적화 항목:
  - 중복 지시문 제거
  - 토큰 20-40% 절감
  - 성능 저하 없이 비용 절감
  - 에이전트 간 일관성 유지
```

### CLAUDE.md 중앙 규칙 참조

```yaml
모든 에이전트:
  - CLAUDE.md 최우선 준수
  - 도메인 전문성 발휘
  - 에이전트 간 협업 프로토콜
  - 일관된 코드 스타일
```

## 결론

단일 요청으로 설계 → 구현 → 테스트 → 커밋 → 문서화까지 자동화

```bash
# 사용자 요청 예시
"플레이어 이동 시스템 구현해줘"

# 자동 실행 플로우
1. game-design-expert: 뱀서류 장르에 맞는 이동 메카닉 설계
2. game-project-manager: Linear 이슈 생성, Task Master 작업 분해
3. unity-client-dev: Context7로 CharacterController API 확인
4. unity-client-dev: UnityMCP로 PlayerController 스크립트 생성
5. git-expert: .meta 파일 포함 커밋
6. blog-manager: "플레이어 이동 구현" 포스트 작성
7. game-project-manager: Linear/Task Master 상태 업데이트
```

실제 게임 개발에서 효과 검증 예정

## 참고 링크

- [ClaudeCode 공식 문서](https://claude.ai/code)
- [MCP 서버 목록](https://github.com/modelcontextprotocol/servers)
- [Unity MCP](https://github.com/unitymcp/unitymcp)
- [Task Master AI](https://github.com/cyanheads/task-master)
