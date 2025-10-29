---
title: "Agent-Based Game Design Document"
pubDate: 2025-10-25T16:35:00+09:00
tags: ["Unity", "Game Development", "PRD", "Bullet Heaven", "Task Master", "Vampire Survivors", "Steam", "TDD"]
categories: ["GameDev"]
draft: false
description: "Vampire survivors-like 3D game completed in 7-day development sprint - Agent system-based automated development"
---


## Overview

Vampire survivors-like 3D Bullet Heaven game

Complete MVP in 7-day development sprint, target Steam deployment

**Core Values**:
- Automatic combat + satisfying growth
- Simple controls, complex strategy
- 10-15 minute run time
- Repeated play based on meta-progression

## Project Specs

```yaml
Platform: Steam (Windows PC)
Engine: Unity 6000.2.9f1 + URP
Genre: 3D Bullet Heaven / Survivor-like
Timeline: 7 days (8-10 hours/day, solo dev)
Method: Agent-based automation + TDD workflow
```

## 10 Core Systems

### 1. Player Character

**Function**: Movement, health, weapon system

**Components**:
- WASD 3D movement (Y-axis fixed/terrain following)
- Collision detection character controller
- Damage/death state management
- XP collection + level-up
- Damage/healing visual feedback
- Animation state machine

### 2. Automatic Weapons

**Function**: Auto-attack nearest enemy

**Components**:
- Projectile spawn weapon base class
- Physics.OverlapSphere-based target detection
- Projectile object pooling
- Weapon types: Projectile, beam, orbital, area
- Weapon stats: Damage, fire rate, range, projectile count
- Type-specific visual/audio feedback

### 3. Enemy Spawn

**Function**: Wave spawn with increasing difficulty

**Components**:
- Map boundary wave spawn
- Enemy object pooling
- Time-based difficulty scaling
- Enemy types: Melee chase, ranged, tank
- Boss/elite spawn at intervals
- Spawn rate increase with game time

### 4. Enemy AI

**Function**: Movement and attack behavior

**Components**:
- NavMesh-based pathfinding OR vector movement
- Player chase
- Contact attack (melee) / projectile (ranged)
- Health and death handling
- XP gem drop on death
- Ragdoll / dissolve death effects

### 5. Level-Up and Upgrades

**Function**: Character enhancement through level-up

**Components**:
- XP collection from enemy kills
- Pause + upgrade selection on level-up
- 3-4 random upgrade cards per level
- Upgrades: New weapons, stat increases, weapon evolutions
- ScriptableObject-based upgrade DB
- UI card selection interface

### 6. Game Loop

**Function**: Game state management (menu, play, pause, game over)

**Components**:
- Game state machine
- Survival time timer
- Pause function
- Victory/defeat conditions
- Run statistics tracking
- Scene management (additive loading)

### 7. Visual Effects

**Function**: Weapon, hit, death particles

**Components**:
- Pooled particle systems
- Hit impacts, explosions, trails
- Screen shake on impact events
- Damage number spawn
- Post-processing (bloom, color grading)

### 8. UI

**Function**: HUD, menus, upgrade selection

**Components**:
- Health bar, XP bar, timer display
- Level-up card selection UI
- Pause menu (resume/quit)
- Game over statistics screen
- Main menu (start/settings/exit)
- TextMeshPro-based text

### 9. Audio

**Function**: Sound effects and background music

**Components**:
- AudioManager singleton with object pooling
- Layered music system
- Weapon, hit, level-up, death SFX
- Volume controls in settings
- Audio Mixer groups

### 10. Steam Integration

**Function**: Steam initialization and SDK features

**Components**:
- Steamworks.NET plugin
- Steam initialization check
- Basic achievements
- Steam Input support
- Cloud save preparation (future)

## 7-Day Development Roadmap

### Phase 1: Core Prototype (Day 1-2)

**Goal**: Playable vertical slice

**Day 1 - Foundation**:
- Unity project structure
- Player character controller + movement
- Basic weapon (auto-fire projectile)
- Single enemy type (chase AI)
- Projectile object pooling
- Basic health/damage system
- Simple arena environment

**Day 2 - Game Loop**:
- Enemy spawner system
- XP gem collection
- Level-up trigger
- Basic upgrade UI (choose 1 of 3 stat increases)
- Death/game over state
- Timer + wave progression
- Second weapon type

**Deliverable**: Complete gameplay loop from start to death with progression

### Phase 2: Core Mechanics (Day 3-4)

**Goal**: Depth and variety - diverse weapons/enemies/upgrades

**Day 3 - Weapon & Enemy Variety**:
- 4-5 weapon types (projectile, beam, orbital, area, piercing)
- Weapon upgrade system (level up existing weapons)
- 3-4 enemy types (melee, ranged, tank, fast)
- Enemy pooling system
- Difficulty scaling algorithm
- Basic VFX (muzzle flash, hit impacts)

**Day 4 - Progression Systems**:
- Upgrade database (10-15 upgrades)
- Weapon evolution system (combination/upgrade paths)
- Rarity tiers (common/rare/epic)
- Boss/elite enemy spawns
- Advanced player stats (critical, area, speed multipliers)
- Meta-progression foundation (unlock system structure)

**Deliverable**: Strategic depth in upgrade choices, meaningful progression

### Phase 3: Polish & Content (Day 5-6)

**Goal**: Game feel and presentation

**Day 5 - Juice & Feedback**:
- Particle systems (all weapons, deaths, level-ups)
- Screen shake system
- Damage numbers
- Post-processing (bloom, vignette, color grading)
- Sound effects (weapons, hits, level-up, death)
- Background music (layered, intensity-based)
- Animation polish (player, enemies)

**Day 6 - UI & Content**:
- Main menu (start, settings, quit)
- Pause menu
- HUD design (health, XP, timer, weapon icons)
- Level-up card UI polish
- Game over statistics screen
- Settings (audio, graphics, controls)
- Tutorial overlay/tooltips
- Additional weapons/enemies/upgrades (expand to 20+ upgrades)

**Deliverable**: Complete UI flow, polished presentation

### Phase 4: Build & Test (Day 7)

**Goal**: Deployable Steam build

**Day 7 - Integration & Testing**:
- Steamworks.NET integration
- Steam build configuration
- Performance optimization (60 FPS target)
- Bug fixing (critical issues)
- Balance tuning (difficulty curve, upgrade power)
- Build automation (CI/CD setup)
- Playtesting and iteration
- Final QA pass

**Deliverable**: Steam-ready build, tested and balanced

## Technical Architecture

### Core Systems

**Singleton Managers**:
1. GameManager - Game state machine, scene management, timer/wave tracking
2. InputManager - Unity Input System wrapper, action mapping
3. AudioManager - SFX pooling, music playback, volume control
4. ObjectPoolManager - Generic pooling (projectiles, enemies, particles, damage numbers)
5. UpgradeManager - Upgrade DB (ScriptableObject), random selection, application
6. EnemySpawner - Wave config (ScriptableObject), spawn points, difficulty scaling

### ScriptableObject Usage

```csharp
// Configuration data
- WeaponConfig
- EnemyConfig
- WaveConfig
- UpgradeConfig

// Event system
- GameEvent (SO-based messaging)
- RuntimeSet (shared runtime data)
```

## MVP Success Criteria (Day 7)

- ✅ Player movement and survival
- ✅ 3+ weapon types
- ✅ 3+ enemy types
- ✅ 10+ upgrade choices
- ✅ Difficulty scales over time
- ✅ Complete UI flow (menu → game → death → restart)
- ✅ Audio and VFX implemented
- ✅ Steam build runs
- ✅ 60 FPS performance
- ✅ Average run time 10-15 minutes

## Agent-Based Automation

This project uses **agent orchestration system** for development automation

### Development Workflow

```yaml
1. PRD Parsing:
   game-project-manager → Task Master task breakdown

2. Unity Implementation:
   unity-client-dev → Context7 API check → UnityMCP control

3. Code Commit:
   git-expert → .meta file auto-management

4. Documentation:
   blog-manager → Auto-generate dev log

5. Project Tracking:
   Linear ↔ Task Master sync
```

### TDD Workflow

Utilize Task Master AI autopilot mode:

```bash
# Start task
autopilot_start(taskId: "1")

# RED → GREEN → COMMIT cycle
autopilot_next() → write tests → complete_phase()
autopilot_next() → implement → complete_phase()
autopilot_commit() → auto-generate commit message

# Complete
autopilot_finalize()
```

## Performance Goals

```yaml
FPS: 60 (16.67ms frame budget)
CPU: <10ms (gameplay code)
GPU: <12ms (rendering)
GC: 0 allocations per frame (during gameplay)

Optimization Strategy:
- Cache component references in Awake/Start
- No GameObject.Find() / GetComponent() in Update
- Object pooling for frequent instantiation
- Zero allocations in Update/FixedUpdate
```

## References

- [Task Master AI](https://github.com/cyanheads/task-master)
- [Unity MCP](https://github.com/unitymcp/unitymcp)

---

## Original PRD

<details>
<summary>View Full PRD Document</summary>

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

[Full PRD content from original Korean version...]
```

</details>
