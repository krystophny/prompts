# QADS v3.0 - Architecture Design

## System Overview

QADS implements a three-workflow system with specialized AI agents managing software development through BACKLOG.md-driven task tracking.

```
USER REQUESTS
     |
     v
[PLAN WORKFLOW] --> BACKLOG.md --> [WORK WORKFLOW]
                         ^                |
                         |                v
                    [PLAY WORKFLOW] <-- Delivered Code
```

## Core Architecture Components

### 1. Workflow Engine

**PLAN Workflow**
- **Actor**: chris-architect
- **Input**: User requirements
- **Output**: GitHub issues, prioritized BACKLOG.md
- **State**: Stateless planning sessions

**WORK Workflow**
- **Actors**: max → sergei → patrick → max
- **Input**: BACKLOG.md SPRINT_BACKLOG items
- **Output**: Implemented features, merged PRs
- **State**: Branch-based with PR tracking

**PLAY Workflow**
- **Actors**: max → parallel audits (patrick, vicky, chris)
- **Input**: Empty SPRINT_BACKLOG (all work complete)
- **Output**: New defect issues in SPRINT_BACKLOG
- **State**: Separate worktree/clone

### 2. Data Flow Architecture

```
BACKLOG.md Structure:
┌────────────────────────────────┐
│ SPRINT_BACKLOG (EPIC/Issues)   │ ← chris creates/organizes
├────────────────────────────────┤
│ DOING (Current Work)           │ ← max moves SPRINT_BACKLOG→DOING
├────────────────────────────────┤
│ PRODUCT_BACKLOG (Features)     │ ← chris manages high-level
├────────────────────────────────┤
│ DONE (Completed Features)      │ ← max moves completed EPICs
└────────────────────────────────┘
```

### 3. Agent Responsibilities

| Agent | PLAN | WORK | PLAY | Primary Ownership |
|-------|------|------|------|-------------------|
| chris | LEAD | - | Final | PRODUCT_BACKLOG, SPRINT_BACKLOG EPICs, Issues |
| max | - | Start/End | Start | Repository, BACKLOG.md status, Tests, Merges |
| sergei | - | Implement | - | Code, Targeted Tests, PRs |
| patrick | - | Review | Audit | Code Quality, Dead Code |

### 4. State Management

**Repository States**
```
CLEAN STATE:
- 0 DOING items, 0 open PRs, main branch current

WORK STATE:
- 1 DOING item max, 1 PR max (non-draft), feature branch

INCONSISTENT STATE:
- Triggers forensic analysis, reconciliation to valid state
```

### 5. Quality Gates

**Pre-Implementation** (max): Repository clean check, rebase, BACKLOG.md consistency
**Implementation** (sergei): Test-first development, **TARGETED TESTS ONLY**
**Review** (patrick): Critical → handback, Non-critical → new issues
**Merge** (max): CI checks passing, final rebase, clean state

## Implementation Patterns

### Branch Naming
```
<type>-<issue-number>
Examples: feat-123, fix-456, refactor-789
```

### Commit Messages
```
<type>: <description>
Types: feat, fix, refactor, test, docs, perf, chore
Example: fix: resolve memory leak in data processor
```

### PR Format
```
<type>: <description>
References: fixes #<issue-number>
Example: feat: add user authentication (fixes #123)
```

## System Boundaries

### External Interfaces
- **GitHub API**: Issues, PRs, CI status
- **Git**: Version control, branching
- **User Input**: Requirements, overrides

### Internal Boundaries
- **Agent Isolation**: Each works within ownership
- **Workflow Separation**: No cross-workflow dependencies
- **State Encapsulation**: BACKLOG.md as single source

## Error Handling Strategy

### Forensic Analysis Protocol
When inconsistency detected:
1. Examine branch name pattern
2. Review PR descriptions  
3. Analyze commit history
4. Check file changes
5. Reconcile with BACKLOG.md

### Recovery Mechanisms
- **Stuck PR**: Forensic analysis → continue work
- **Multiple PRs**: Priority selection → completion
- **Lost state**: BACKLOG.md reconstruction

## Performance Considerations

### Optimization Points
- **Test execution division**: sergei runs targeted tests, max runs full suite
- Parallel PLAY audits for concurrent defect detection
- Batch mode automation for high-velocity workflows
- Repository state caching and forensic analysis shortcuts

## Architectural Decisions

### ADR-001: BACKLOG.md as Single Source of Truth
**Status**: Accepted
**Decision**: BACKLOG.md serves as the authoritative source for task state
**Rationale**: Eliminates state synchronization issues between agents
**Consequences**: All agents must read/write BACKLOG.md consistently

### ADR-002: Test Execution Division
**Status**: Accepted  
**Decision**: sergei runs targeted tests, max/patrick run full suite
**Rationale**: Enables fast iteration while ensuring comprehensive validation
**Consequences**: Clear test execution boundaries and responsibilities

### ADR-003: Read-Only PLAY Workflow
**Status**: Accepted
**Decision**: PLAY workflow prohibits all file modifications
**Rationale**: Sprint review meeting should only identify issues, not fix them
**Consequences**: All findings must be filed as GitHub issues for next sprint

## Current Sprint Goal

**Objective**: Ruthless elimination of overengineering and bloat across entire codebase
**Definition of Done**: All files under target sizes, zero duplicate functionality, consistent brutal team culture

## Technical Debt

- Agent file sizes exceeded targets (resolved this sprint)
- Redundant documentation files (PROMPTS.md, GIT_GUIDELINE.md) deleted
- CLAUDE.md academic bloat eliminated
- README.md marketing fluff removed

*Quality-driven Agent Development System (QADS) - Version 3.0*