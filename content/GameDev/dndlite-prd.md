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

- [Task Master AI](https://github.com/cyanheads/task-master)
- [Unity MCP](https://github.com/unitymcp/unitymcp)

---

## PRD 원문

{{< details "DNDLite PRD 전체 문서 보기" >}}

```text
# DNDLite - 3D Bullet Heaven Game PRD
# 7-Day Development Sprint

# Overview
DNDLite is a 3D Bullet Heaven game inspired by Vampire Survivors, targeting Steam PC platform. The game features automatic weapon firing, enemy waves, character progression, and RPG-lite mechanics in a 3D environment. Development timeline is 7 days (1 week) with 8-10 hour daily work capacity for solo development.

**Target Platform**: Steam (Windows PC)
**Engine**: Unity 6000.2.9f1 with URP (Universal Render Pipeline)
**Genre**: 3D Bullet Heaven / Survivor-like
**Timeline**: 7 days (MVP focus)

**Core Value Proposition**:
- Fast-paced automatic combat with satisfying progression
- Simple controls, complex emergent gameplay
- Quick gameplay loops (10-15 minute runs)
- Replayable with meta-progression

# Core Features

## 1. Player Character System
**What it does**: Player-controlled character with movement, health, and weapon systems
**Why it's important**: Core gameplay foundation - everything builds on this
**How it works**:
- WASD movement in 3D space (locked Y-axis or terrain-following)
- Character controller with collision detection
- Health system with damage/death states
- XP collection and level-up system
- Visual feedback for damage/healing
- Animation state machine (idle, run, hurt, death)

## 2. Automatic Weapon System
**What it does**: Weapons fire automatically at nearest enemies
**Why it's important**: Core combat mechanic - defines the "auto-shooter" genre
**How it works**:
- Weapon base class with projectile spawning
- Target detection (Physics.OverlapSphere for nearest enemy)
- Projectile pooling system
- Multiple weapon types (projectile, beam, orbital, area)
- Weapon stats: damage, fire rate, range, projectile count
- Visual and audio feedback per weapon type

## 3. Enemy Spawning System
**What it does**: Spawns enemy waves with increasing difficulty
**Why it's important**: Provides challenge and progression curve
**How it works**:
- Wave-based spawning at map boundaries
- Enemy pool system (object pooling)
- Difficulty scaling over time
- Enemy types with different behaviors (melee chase, ranged, tanky)
- Boss/elite spawns at intervals
- Spawn rate increases with game time

## 4. Enemy AI System
**What it does**: Enemy movement and attack behaviors
**Why it's important**: Creates engaging combat scenarios
**How it works**:
- Simple NavMesh-based pathfinding OR direct vector movement
- Chase player behavior
- Attack on contact (melee) or projectile (ranged)
- Health and death handling
- Drop XP gems on death
- Ragdoll or dissolve death effects

## 5. Level-Up and Upgrade System
**What it does**: Character gains power through level-ups
**Why it's important**: Core progression loop - player motivation
**How it works**:
- XP collection from defeated enemies
- Level-up triggers pause with upgrade choices
- 3-4 random upgrade cards per level
- Upgrades include: new weapons, stat boosts, weapon evolutions
- ScriptableObject-based upgrade database
- UI card selection interface

## 6. Game Loop Management
**What it does**: Manages game states (menu, playing, paused, game over)
**Why it's important**: Controls flow and user experience
**How it works**:
- Game state machine
- Timer system (survival time tracking)
- Pause functionality
- Victory/defeat conditions
- Run statistics tracking
- Scene management (additive loading)

## 7. Visual Effects System
**What it does**: Particle effects for weapons, hits, deaths
**Why it's important**: Juice and feedback - makes combat satisfying
**How it works**:
- Pooled particle systems
- Hit impacts, explosions, trails
- Screen shake on impactful events
- Damage numbers spawning
- Post-processing effects (bloom, color grading)

## 8. UI System
**What it does**: HUD, menus, upgrade selection interface
**Why it's important**: Information display and player input
**How it works**:
- Health bar, XP bar, timer display
- Level-up card selection UI
- Pause menu with resume/quit
- Game over screen with stats
- Main menu with start/settings/quit
- TextMeshPro for all text

## 9. Audio System
**What it does**: Sound effects and background music
**Why it's important**: Enhances atmosphere and feedback
**How it works**:
- AudioManager singleton with pooling
- Layered music system
- SFX for weapons, hits, level-up, death
- Volume controls in settings
- Audio mixer groups

## 10. Steam Integration (Basic)
**What it does**: Steam initialization and basic SDK features
**Why it's important**: Required for Steam deployment
**How it works**:
- Steamworks.NET plugin
- Steam initialization check
- Achievements (basic set)
- Steam Input support
- Cloud save preparation (future)

# User Experience

## User Personas
**Primary**: Core gamer (20-35), enjoys roguelite/roguelike games, familiar with Vampire Survivors, seeks quick gaming sessions, plays on PC

## Key User Flows

### First-Time Player Flow:
1. Launch game → Main Menu
2. Click "Start" → Brief tutorial overlay (movement/survival basics)
3. Spawn in arena → Auto-fire begins → Collect XP
4. First level-up → Choose upgrade (guided)
5. Continue until death → Stats screen → Retry

### Experienced Player Flow:
1. Main Menu → Start
2. Immediate gameplay
3. Strategic upgrade choices at level-ups
4. Push for longer survival times
5. Unlock meta-progression (future)

## UI/UX Considerations
- Minimal HUD clutter (corners only)
- Large, readable text (TextMeshPro)
- Clear visual hierarchy on upgrade cards
- Responsive controls (no input lag)
- Satisfying feedback (screen shake, particles, sound)
- Pause accessible anytime (ESC key)
- Color-coded rarities (common/rare/epic)

# Technical Architecture

## System Components

### Core Systems:
1. **GameManager** (Singleton)
   - Game state machine
   - Scene management
   - Timer/wave tracking

2. **InputManager** (Singleton)
   - Unity Input System wrapper
   - Action mapping (movement, pause, interact)

3. **AudioManager** (Singleton)
   - SFX pooling
   - Music playback
   - Volume control

4. **ObjectPoolManager** (Singleton)
   - Generic pooling system
   - Pools: projectiles, enemies, particles, damage numbers

5. **UpgradeManager**
   - Upgrade database (ScriptableObject)
   - Random selection logic
   - Upgrade application

6. **EnemySpawner**
   - Wave configuration (ScriptableObject)
   - Spawn point management
   - Difficulty scaling

### Gameplay Components:
1. **PlayerController** (MonoBehaviour)
   - Movement (CharacterController)
   - Health/XP tracking
   - Weapon management
   - Input handling

2. **WeaponBase** (Abstract MonoBehaviour)
   - Fire rate timer
   - Target acquisition
   - Projectile spawning
   - Upgrade stats

3. **EnemyController** (MonoBehaviour)
   - Movement AI
   - Health/damage
   - Attack behavior
   - Death handling

4. **Projectile** (MonoBehaviour)
   - Movement
   - Collision detection
   - Lifetime management
   - Damage application

## Data Models

### ScriptableObjects:
- **WeaponData**: Base stats (damage, fireRate, range, projectileSpeed, etc.)
- **EnemyData**: Health, speed, damage, XP value, model reference
- **UpgradeData**: Type (weapon/stat), rarity, description, effects
- **WaveConfig**: Enemy types, spawn rates, timing
- **AudioClipGroup**: Randomized SFX variants

### Serialized Classes:
- **PlayerStats**: Health, moveSpeed, XP, level, equipped weapons
- **GameStats**: Survival time, kills, damage dealt, upgrades taken
- **SaveData**: Meta-progression (future), unlocks, settings

## APIs and Integrations
- **Unity Input System**: Player input handling
- **Unity NavMesh** (optional): Enemy pathfinding
- **TextMeshPro**: UI text rendering
- **Steamworks.NET**: Steam platform integration
- **Unity Analytics** (optional): Telemetry

## Infrastructure Requirements
- **Unity Version**: 6000.2.9f1
- **Render Pipeline**: URP
- **Build Target**: Windows Standalone (64-bit)
- **Minimum Specs**: Windows 10, 4GB RAM, DX11 GPU
- **Git LFS**: For large assets (textures, audio, models)

# Development Roadmap

## Phase 1: Core Prototype (Days 1-2)
**Goal**: Playable vertical slice - player can move, shoot, enemies spawn and die

### Day 1 - Foundation:
- Unity project structure (Assets/_Project folders)
- Player character controller with movement
- Basic weapon (auto-fire projectile)
- Single enemy type (chase AI)
- Object pooling for projectiles
- Basic health/damage system
- Simple arena environment

**Deliverable**: Player can move and shoot enemies that chase them

### Day 2 - Game Loop:
- Enemy spawner system
- XP gem collection
- Level-up trigger
- Basic upgrade UI (choose 1 of 3 stat boosts)
- Death/game over state
- Timer and wave progression
- Second weapon type

**Deliverable**: Complete gameplay loop from start to death with progression

## Phase 2: Core Mechanics (Days 3-4)
**Goal**: Depth and variety - multiple weapons/enemies/upgrades

### Day 3 - Weapon & Enemy Variety:
- 4-5 weapon types (projectile, beam, orbital, area, piercing)
- Weapon upgrade system (level up existing weapons)
- 3-4 enemy types (melee, ranged, tank, fast)
- Enemy pooling system
- Difficulty scaling algorithm
- Basic VFX (muzzle flash, hit impacts)

**Deliverable**: Variety in combat scenarios, replayability emerging

### Day 4 - Progression Systems:
- Upgrade database (10-15 upgrades)
- Weapon evolution system (combine/upgrade paths)
- Rarity tiers (common/rare/epic)
- Boss/elite enemy spawns
- Advanced player stats (crit, area, speed multipliers)
- Meta-progression foundation (unlock system structure)

**Deliverable**: Strategic depth in upgrade choices, meaningful progression

## Phase 3: Polish & Content (Days 5-6)
**Goal**: Game feel and presentation

### Day 5 - Juice & Feedback:
- Particle systems (all weapons, deaths, level-ups)
- Screen shake system
- Damage numbers
- Post-processing (bloom, vignette, color grading)
- Sound effects (weapons, hits, level-up, death)
- Background music (layered, intensity-based)
- Animation polish (player, enemies)

**Deliverable**: Satisfying, impactful combat feel

### Day 6 - UI & Content:
- Main menu (start, settings, quit)
- Pause menu
- HUD design (health, XP, timer, weapon icons)
- Level-up card UI polish
- Game over stats screen
- Settings (audio, graphics, controls)
- Tutorial overlay/tooltips
- Additional weapons/enemies/upgrades (expand to 20+ upgrades)

**Deliverable**: Complete UI flow, polished presentation

## Phase 4: Build & Test (Day 7)
**Goal**: Shippable Steam build

### Day 7 - Integration & Testing:
- Steamworks.NET integration
- Steam build configuration
- Performance optimization (60 FPS target)
- Bug fixing (critical issues)
- Balance tuning (difficulty curve, upgrade power)
- Build automation (CI/CD setup)
- Playtesting and iteration
- Final QA pass

**Deliverable**: Steam-ready build, tested and balanced

# Logical Dependency Chain

## Foundation → Visibility → Depth → Polish

### Tier 1 (Must Build First):
1. **Project Structure** - All development depends on this
2. **Player Controller** - Core interaction point
3. **Basic Weapon** - Immediate visible feedback
4. **Enemy AI** - Something to interact with
5. **Object Pooling** - Performance foundation

### Tier 2 (Build Next for Playability):
6. **Enemy Spawner** - Continuous challenge
7. **Health/Damage System** - Win/lose conditions
8. **XP/Level System** - Progression hook
9. **Basic Upgrade UI** - Player choice/agency
10. **Game State Management** - Flow control

### Tier 3 (Add Depth):
11. **Multiple Weapons** - Variety
12. **Multiple Enemies** - Complexity
13. **Upgrade Database** - Strategic choices
14. **Difficulty Scaling** - Challenge curve
15. **ScriptableObject Architecture** - Data-driven design

### Tier 4 (Polish & Completeness):
16. **VFX & Particles** - Feedback and juice
17. **Audio System** - Atmosphere
18. **UI Polish** - Presentation
19. **Menus & Flow** - User experience
20. **Steam Integration** - Platform requirement

## Atomic Feature Scoping

Each feature should be:
- **Buildable in 1-3 hours** (for solo dev)
- **Testable independently** (unit/integration tests)
- **Shippable incrementally** (can merge to main)
- **Improvable later** (refactor-friendly)

Example: Weapon System
- Atomic v1: Single projectile weapon with auto-fire
- Improvement v2: Add weapon stats (damage, fire rate)
- Improvement v3: Add target prioritization
- Improvement v4: Add weapon upgrade system
- Improvement v5: Add multiple weapon types

# Risks and Mitigations

## Technical Challenges

### Risk: Performance degradation with many entities
**Mitigation**:
- Implement object pooling from Day 1
- Use Unity Profiler early and often
- Target 60 FPS with 200+ entities on screen
- Consider ECS/DOTS if performance issues persist

### Risk: NavMesh performance overhead
**Mitigation**:
- Use simple vector-based movement for basic enemies
- Reserve NavMesh for complex AI only
- Test with 100+ enemies before committing to NavMesh

### Risk: Unity Input System complexity
**Mitigation**:
- Create simple wrapper (InputManager)
- Use pre-configured action maps
- Test on multiple input devices early

### Risk: Steamworks integration issues
**Mitigation**:
- Use Steamworks.NET (proven plugin)
- Test Steam initialization on Day 1
- Use App ID 480 for development
- Keep Steam features minimal (init + achievements only)

## MVP Scoping Risks

### Risk: Scope creep (too many features)
**Mitigation**:
- Strict 7-day timeline enforcement
- MVP features ONLY (no meta-progression, no multiple characters)
- Cut content, not quality (fewer weapons/enemies, but polished)
- Daily check-ins against timeline

### Risk: Over-engineering early systems
**Mitigation**:
- "Make it work, then make it good, then make it fast"
- Avoid premature optimization
- Refactor in dedicated time blocks (end of Day 2, 4, 6)
- Single-responsibility principle for all classes

### Risk: Art/asset bottleneck (no artist)
**Mitigation**:
- Use Unity primitives (cubes, spheres, capsules) with materials
- Free asset packs (Kenney, Unity Asset Store freebies)
- Particle effects > complex models
- Prioritize gameplay over visuals

## Resource Constraints

### Risk: Solo development fatigue
**Mitigation**:
- 8-10 hour daily work blocks (sustainable pace)
- Built-in buffer time each day (20% for unknowns)
- Focus on core loop first (playable by Day 2)
- Celebrate daily milestones

### Risk: Knowledge gaps (Unity 6, URP, Steamworks)
**Mitigation**:
- Use Context7 for Unity/Hugo documentation (MANDATORY before implementation)
- Keep backup resources (Unity docs, forums)
- Timebox research (1 hour max per unknown)
- Prefer proven solutions over experimental

### Risk: Integration issues between systems
**Mitigation**:
- Follow CLAUDE.md architecture patterns
- Use ScriptableObject events for decoupling
- Test integrations immediately (don't batch)
- Version control discipline (commit after each feature)

# Appendix

## Unity Project Structure

```
Assets/
├── _Project/
│   ├── Scripts/
│   │   ├── Core/           # GameManager, ObjectPooler, etc.
│   │   ├── Player/         # PlayerController, PlayerStats, etc.
│   │   ├── Weapons/        # WeaponBase, Projectile, weapon types
│   │   ├── Enemies/        # EnemyController, EnemyAI, enemy types
│   │   ├── Systems/        # UpgradeSystem, SpawnSystem, etc.
│   │   ├── UI/             # Menus, HUD, upgrade cards
│   │   └── Utilities/      # Extensions, helpers, pooling
│   ├── Prefabs/
│   │   ├── Player/
│   │   ├── Weapons/
│   │   ├── Enemies/
│   │   ├── VFX/
│   │   └── UI/
│   ├── Data/               # ScriptableObjects
│   │   ├── Weapons/
│   │   ├── Enemies/
│   │   ├── Upgrades/
│   │   └── Waves/
│   ├── Scenes/
│   │   ├── _Persistent.unity    # GameManager, AudioManager
│   │   ├── MainMenu.unity
│   │   └── Gameplay.unity
│   ├── Materials/
│   ├── Audio/
│   │   ├── Music/
│   │   └── SFX/
│   └── VFX/
└── Plugins/
    └── Steamworks.NET/
```

## Key Dependencies

- **Unity Input System** (com.unity.inputsystem)
- **TextMeshPro** (com.unity.textmeshpro)
- **Universal RP** (com.unity.render-pipelines.universal)
- **Steamworks.NET** (via Asset Store or GitHub)

## Performance Targets

- **FPS**: 60 (consistent, vsync on)
- **Frame Budget**: 16.67ms
- **Entity Count**: 200+ enemies on screen
- **Memory**: <512MB heap
- **Build Size**: <500MB

## Testing Checklist

### Functional Tests:
- [ ] Player movement in all directions
- [ ] Weapon firing and hit detection
- [ ] Enemy spawning and AI
- [ ] XP collection and level-up
- [ ] Upgrade selection and application
- [ ] Death and restart flow
- [ ] Pause and resume
- [ ] Audio playback
- [ ] Settings persistence

### Performance Tests:
- [ ] 60 FPS with 200+ enemies
- [ ] No GC allocations in Update loops
- [ ] Object pooling functioning
- [ ] Memory stable over 30-minute run

### Integration Tests:
- [ ] Steam initialization
- [ ] Steam achievements triggering
- [ ] Build runs on clean Windows install
- [ ] Input works with keyboard + gamepad

## Asset Sources (Free)

- **3D Models**: Kenney.nl, Unity Asset Store (free section)
- **Audio**: Freesound.org, OpenGameArt.org
- **VFX**: Unity Particle Pack (free), Polygonal Particle FX (free)
- **Fonts**: Google Fonts (SIL Open Font License)

## Success Criteria

### Minimum Viable Product (Day 7):
- ✅ Player can move and survive
- ✅ 3+ weapon types
- ✅ 3+ enemy types
- ✅ 10+ upgrade choices
- ✅ Difficulty scales over time
- ✅ Complete UI flow (menu → game → death → retry)
- ✅ Audio and VFX present
- ✅ Steam build launches
- ✅ 60 FPS performance
- ✅ 10-15 minute average run time

### Stretch Goals (if time permits):
- ⭐ 5+ weapon types with evolutions
- ⭐ Boss enemy encounters
- ⭐ Multiple arena environments
- ⭐ Character selection (2+ characters)
- ⭐ Meta-progression (persistent unlocks)
- ⭐ Achievements (10+)

## Daily Review Questions

At end of each day, assess:
1. Did I complete today's deliverable?
2. Are there blockers for tomorrow?
3. Is the timeline still realistic?
4. Do I need to cut scope?
5. Is the game fun yet?

## References

- Unity Documentation: https://docs.unity3d.com/
- Vampire Survivors (reference game)
- Steamworks.NET: https://steamworks.github.io/
- Unity Input System: https://docs.unity3d.com/Packages/com.unity.inputsystem@latest/

---

**Document Version**: 1.0
**Last Updated**: 2025-10-25
**Sprint Timeline**: 7 Days (2025-10-25 to 2025-10-31)
**Project Code**: DNDLite
```

{{< /details >}}
