---
title: "에이전트 기반 게임 기획서"
date: 2025-10-25T16:35:00+09:00
tags: ["Unity", "Game Development", "PRD", "Bullet Heaven", "Task Master", "Vampire Survivors", "Steam", "TDD"]
categories: ["GameDev"]
draft: false
description: "7일 개발 스프린트로 완성하는 뱀파이어 서바이버류 3D 게임 - 에이전트 시스템 기반 자동화 개발"
---

## 개요

**DNDLite** - 뱀파이어 서바이버류 3D Bullet Heaven 게임

7일 개발 스프린트로 MVP 완성, Steam 배포 목표

**핵심 가치**:
- 자동 전투 + 만족스러운 성장
- 단순 조작, 복잡한 전략
- 10-15분 런 타임
- 메타 진행도 기반 반복 플레이

## 프로젝트 스펙

```yaml
플랫폼: Steam (Windows PC)
엔진: Unity 6000.2.9f1 + URP
장르: 3D Bullet Heaven / Survivor-like
타임라인: 7일 (1일 8-10시간, 솔로 개발)
개발 방법: 에이전트 기반 자동화 + TDD 워크플로우
```

## 10대 핵심 시스템

### 1. 플레이어 캐릭터

**기능**: 이동, 체력, 무기 시스템

**구성**:
- WASD 3D 이동 (Y축 고정/지형 추종)
- 충돌 감지 캐릭터 컨트롤러
- 데미지/죽음 상태 관리
- XP 수집 + 레벨업
- 데미지/힐링 비주얼 피드백
- 애니메이션 상태 머신

### 2. 자동 무기

**기능**: 가장 가까운 적 자동 공격

**구성**:
- 투사체 스폰 무기 베이스 클래스
- Physics.OverlapSphere 기반 타겟 감지
- 투사체 오브젝트 풀링
- 무기 타입: 투사체, 빔, 궤도형, 범위형
- 무기 스탯: 데미지, 연사속도, 사거리, 투사체 개수
- 타입별 비주얼/오디오 피드백

### 3. 적 스폰

**기능**: 난이도 증가하는 웨이브 스폰

**구성**:
- 맵 경계 웨이브 스폰
- 적 오브젝트 풀링
- 시간 기반 난이도 스케일링
- 적 타입: 근접 추격, 원거리, 탱커
- 일정 간격 보스/엘리트 스폰
- 게임 시간에 따라 스폰 속도 증가

### 4. 적 AI

**기능**: 이동 및 공격 행동

**구성**:
- NavMesh 기반 경로 찾기 OR 벡터 이동
- 플레이어 추격
- 접촉 공격(근접) / 투사체(원거리)
- 체력 및 죽음 처리
- 죽을 때 XP 젬 드롭
- 래그돌 / 디졸브 죽음 효과

### 5. 레벨업 및 업그레이드

**기능**: 레벨업으로 캐릭터 강화

**구성**:
- 적 처치로 XP 수집
- 레벨업 시 일시정지 + 업그레이드 선택
- 레벨당 3-4개 랜덤 업그레이드 카드
- 업그레이드: 신규 무기, 스탯 증가, 무기 진화
- ScriptableObject 기반 업그레이드 DB
- UI 카드 선택 인터페이스

### 6. 게임 루프

**기능**: 게임 상태 관리 (메뉴, 플레이, 일시정지, 게임오버)

**구성**:
- 게임 상태 머신
- 생존 시간 타이머
- 일시정지 기능
- 승리/패배 조건
- 런 통계 추적
- 씬 관리 (부가형 로딩)

### 7. 비주얼 이펙트

**기능**: 무기, 히트, 죽음 파티클

**구성**:
- 풀링된 파티클 시스템
- 히트 임팩트, 폭발, 트레일
- 임팩트 이벤트 시 화면 흔들림
- 데미지 숫자 스폰
- 포스트 프로세싱 (블룸, 컬러 그레이딩)

### 8. UI

**기능**: HUD, 메뉴, 업그레이드 선택

**구성**:
- 체력바, XP바, 타이머 표시
- 레벨업 카드 선택 UI
- 일시정지 메뉴 (재개/종료)
- 게임오버 통계 화면
- 메인 메뉴 (시작/설정/종료)
- TextMeshPro 기반 텍스트

### 9. 오디오

**기능**: 효과음 및 배경음악

**구성**:
- 오브젝트 풀링 기반 AudioManager 싱글톤
- 레이어드 음악 시스템
- 무기, 히트, 레벨업, 죽음 SFX
- 설정의 볼륨 컨트롤
- Audio Mixer 그룹

### 10. Steam 통합

**기능**: Steam 초기화 및 SDK 기능

**구성**:
- Steamworks.NET 플러그인
- Steam 초기화 체크
- 기본 업적
- Steam Input 지원
- 클라우드 세이브 준비 (향후)

## 7일 개발 로드맵

### Phase 1: 코어 프로토타입 (Day 1-2)

**목표**: 플레이 가능한 수직 슬라이스

**Day 1 - 기초**:
- Unity 프로젝트 구조
- 플레이어 캐릭터 컨트롤러 + 이동
- 기본 무기 (자동발사 투사체)
- 단일 적 타입 (추격 AI)
- 투사체 오브젝트 풀링
- 기본 체력/데미지 시스템
- 간단한 아레나 환경

**Day 2 - 게임 루프**:
- 적 스포너 시스템
- XP 젬 수집
- 레벨업 트리거
- 기본 업그레이드 UI (3개 중 1개 스탯 증가 선택)
- 죽음/게임오버 상태
- 타이머 + 웨이브 진행도
- 두 번째 무기 타입

**Deliverable**: 시작부터 죽음까지 완전한 게임플레이 루프 + 진행도

### Phase 2: 핵심 메카닉 (Day 3-4)

**목표**: 깊이와 다양성 - 다양한 무기/적/업그레이드

**Day 3 - 무기 & 적 다양성**:
- 4-5개 무기 타입 (투사체, 빔, 궤도형, 범위형, 관통형)
- 무기 업그레이드 시스템 (기존 무기 레벨업)
- 3-4개 적 타입 (근접, 원거리, 탱커, 빠른)
- 적 풀링 시스템
- 난이도 스케일링 알고리즘
- 기본 VFX (머즐 플래시, 히트 임팩트)

**Day 4 - 진행도 시스템**:
- 업그레이드 DB (10-15개 업그레이드)
- 무기 진화 시스템 (조합/업그레이드 경로)
- 레어도 티어 (일반/레어/에픽)
- 보스/엘리트 적 스폰
- 고급 플레이어 스탯 (크리티컬, 범위, 속도 배수)
- 메타 진행도 기초 (언락 시스템 구조)

**Deliverable**: 업그레이드 선택의 전략적 깊이, 의미 있는 진행도

### Phase 3: 폴리싱 & 콘텐츠 (Day 5-6)

**목표**: 게임 감각과 프레젠테이션

**Day 5 - Juice & 피드백**:
- 파티클 시스템 (모든 무기, 죽음, 레벨업)
- 화면 흔들림 시스템
- 데미지 숫자
- 포스트 프로세싱 (블룸, 비네트, 컬러 그레이딩)
- 효과음 (무기, 히트, 레벨업, 죽음)
- 배경음악 (레이어드, 강도 기반)
- 애니메이션 폴리싱 (플레이어, 적)

**Day 6 - UI & 콘텐츠**:
- 메인 메뉴 (시작, 설정, 종료)
- 일시정지 메뉴
- HUD 디자인 (체력, XP, 타이머, 무기 아이콘)
- 레벨업 카드 UI 폴리싱
- 게임오버 통계 화면
- 설정 (오디오, 그래픽, 컨트롤)
- 튜토리얼 오버레이/툴팁
- 추가 무기/적/업그레이드 (20+ 업그레이드로 확장)

**Deliverable**: 완전한 UI 플로우, 폴리싱된 프레젠테이션

### Phase 4: 빌드 & 테스트 (Day 7)

**목표**: 배포 가능한 Steam 빌드

**Day 7 - 통합 & 테스팅**:
- Steamworks.NET 통합
- Steam 빌드 설정
- 성능 최적화 (60 FPS 목표)
- 버그 수정 (크리티컬 이슈)
- 밸런스 튜닝 (난이도 커브, 업그레이드 파워)
- 빌드 자동화 (CI/CD 설정)
- 플레이테스팅 및 반복
- 최종 QA 패스

**Deliverable**: Steam 배포 가능 빌드, 테스트 및 밸런싱 완료

## 기술 아키텍처

### 코어 시스템

**싱글톤 매니저**:
1. GameManager - 게임 상태 머신, 씬 관리, 타이머/웨이브 추적
2. InputManager - Unity Input System 래퍼, 액션 매핑
3. AudioManager - SFX 풀링, 음악 재생, 볼륨 컨트롤
4. ObjectPoolManager - 범용 풀링 (투사체, 적, 파티클, 데미지 숫자)
5. UpgradeManager - 업그레이드 DB (ScriptableObject), 랜덤 선택, 적용
6. EnemySpawner - 웨이브 설정 (ScriptableObject), 스폰 포인트, 난이도 스케일링

### ScriptableObject 활용

```csharp
// 설정 데이터
- WeaponConfig
- EnemyConfig
- WaveConfig
- UpgradeConfig

// 이벤트 시스템
- GameEvent (SO 기반 메시징)
- RuntimeSet (공유 런타임 데이터)
```

## MVP 성공 기준 (Day 7)

- ✅ 플레이어 이동 및 생존
- ✅ 3개 이상 무기 타입
- ✅ 3개 이상 적 타입
- ✅ 10개 이상 업그레이드 선택지
- ✅ 시간에 따른 난이도 스케일링
- ✅ 완전한 UI 플로우 (메뉴 → 게임 → 죽음 → 재시작)
- ✅ 오디오 및 VFX 구현
- ✅ Steam 빌드 실행
- ✅ 60 FPS 성능
- ✅ 평균 런 타임 10-15분

## 에이전트 기반 자동화

이 프로젝트는 **에이전트 오케스트레이션 시스템**으로 개발 자동화

### 개발 워크플로우

```yaml
1. PRD 파싱:
   game-project-manager → Task Master 작업 분해

2. Unity 구현:
   unity-client-dev → Context7 API 확인 → UnityMCP 제어

3. 코드 커밋:
   git-expert → .meta 파일 자동 관리

4. 문서화:
   blog-manager → 개발 로그 자동 생성

5. 프로젝트 추적:
   Linear ↔ Task Master 동기화
```

### TDD 워크플로우

Task Master AI의 autopilot 모드 활용:

```bash
# 작업 시작
autopilot_start(taskId: "1")

# RED → GREEN → COMMIT 사이클
autopilot_next() → 테스트 작성 → complete_phase()
autopilot_next() → 구현 → complete_phase()
autopilot_commit() → 자동 커밋 메시지 생성

# 완료
autopilot_finalize()
```

## 성능 목표

```yaml
FPS: 60 (16.67ms 프레임 예산)
CPU: <10ms (게임플레이 코드)
GPU: <12ms (렌더링)
GC: 0 allocations per frame (게임플레이 중)

최적화 전략:
- Component 레퍼런스 Awake/Start 캐싱
- Update에서 GameObject.Find() / GetComponent() 금지
- 빈번한 인스턴스화는 오브젝트 풀링
- Update/FixedUpdate에서 제로 할당
```

## 참고 링크

- [DNDLite GitHub Repository](#) (TBD)
- [Task Master AI](https://github.com/cyanheads/task-master)
- [Unity MCP](https://github.com/unitymcp/unitymcp)
- [Steamworks.NET](https://steamworks.github.io)
- [Vampire Survivors](https://store.steampowered.com/app/1794680/Vampire_Survivors)
