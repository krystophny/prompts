# Claude Multi-Agent Development System

A quality-first agile development workflow system featuring specialized AI agents working collaboratively through structured TDD processes.

## Quick Start

**Choose Your Workflow:**

1. **New Feature/Requirements** → Use **Feature Planning** with chris-architect
2. **Execute Existing Work** → Use **Feature Development** workflow  
3. **System Audit** → **Playtest Workflow** (auto-triggered on clean repository)

**Execution Modes:**
- **Single Issue** (default): Complete one task and stop
- **Batch Mode**: Solve all open issues automatically (`"solve all issues"`)
- **Manual Mode**: Include user review in workflow (`"manual mode"`)

## Workflow Types

### Feature Planning
*User ↔ chris-architect collaboration*

```
Goals/Requirements ──▶ chris-architect ──▶ DESIGN.md + GitHub Issues
```

- **Purpose**: Strategic planning and requirements capture
- **Authority**: chris-architect has full authority to create/update DESIGN.md and issues
- **Use When**: Starting new features or major changes

### Feature Development  
*Multi-agent structured implementation*

- **Purpose**: Execute planned work through TDD workflow
- **Authority**: chris-architect restricted to issue selection and prioritization
- **Process**: 7-phase workflow from tests to delivery

### Playtest Workflow
*Comprehensive system audit*

- **Purpose**: Discover bugs and improvements through thorough testing
- **Trigger**: Automatically initiated when repository is clean (no PRs/issues)
- **Result**: Comprehensive bug backlog for future development

---

## The Team

### Core Development Agents

| Agent | Role | Primary Responsibilities |
|-------|------|-------------------------|
| **chris-architect** | Chief Architect | System architecture, issue lifecycle, DESIGN.md, MVP focus |
| **sergei-perfectionist-coder** | Chief Programmer | Production code, API docs, zero-compromise implementation |
| **georg-test-engineer** | Test Engineer | Test creation (unit/integration/system), BDD expertise |
| **patrick-auditor** | Code Reviewer/QA | Security analysis, code quality, compliance verification |
| **vicky-acceptance-tester** | Customer/Tester | User acceptance testing, UX validation, chaos engineering |
| **max-devops-engineer** | Development Manager | Build execution, repository hygiene, CI/CD operations |

### Specialist Agents

| Agent | Expertise | When to Use |
|-------|-----------|-------------|
| **winny-technical-writer** | Technical Writing | User documentation, technical content creation |
| **steffi-ux-designer** | UX Design | UI/interface optimization, visual styling |
| **philipp-data-scientist** | Data Science | Data analysis, visualization, statistical modeling |
| **jonatan-math-physicist** | Mathematics | Mathematical formulation, LaTeX-to-code translation |

---

## Workflow Selection

**Decision Tree**: Choose the right workflow based on task complexity

### Simple Workflow
*Use when ALL criteria are met OR user manually requests:*

✅ Single file affected  
✅ No API/interface changes  
✅ No new dependencies  
✅ Estimated <2 hours work  
✅ **Manual Override**: User says "use simple workflow"  

**Process**: Agent → max validation → patrick review → fixes → max cleanup

### Complex Workflow  
*Use when ANY trigger applies:*

❌ Multiple files affected  
❌ API/interface changes required  
❌ New dependencies needed  
❌ Estimated >2 hours work  
❌ Architecture impact  
❌ New features requiring documentation  

**Process**: Full 7-phase workflow (detailed below)

---

## Simple Workflow Process

**Steps:**
1. **Agent** implements changes
2. **max-devops** validates build and tests
3. **patrick-auditor** reviews for quality/security
4. **Iterate** until all findings resolved
5. **max-devops** cleanup and completion

**Batch Behavior:**
- **Single Issue** (default): Complete one issue → stop
- **Batch Mode**: Continue automatically until all issues resolved

## Complex Workflow Process

**Key Principle**: Never start new work when existing work is unfinished

### 7-Phase Development Process

**Phase 1-2: Planning & Prioritization**
1. **max-devops**: Repository assessment (PRs/issues/clean state)
2. **chris-architect**: Issue selection and prioritization

**Phase 3: Architecture Documentation**
3. **chris-architect**: Reviews DESIGN.md, creates implementation plan

**Phase 4: RED Phase (Test-Driven Development)**
4. **georg-test-engineer**: Writes failing tests (parallel with chris refinements)

**Phase 5: Documentation → Implementation** *(Serial Execution - docs first)*
5a. **winny-technical-writer**: User documentation (docs-first approach)
5b. **sergei-perfectionist-coder**: Code + API documentation using winny's docs as guide

**Phase 6: Serial Review Chain** *(fully serial execution)*:
   - **max-devops**: Technical validation → immediate handback if critical issues
   - **patrick-auditor**: Code quality + security → immediate handback if critical issues
   - **vicky-acceptance-tester**: User acceptance + UX → immediate handback if critical issues
   - **chris-architect**: Architecture alignment → immediate handback if critical issues
   - **User**: Final review (manual mode only) → immediate handback if critical issues

**Phase 7: Completion** *(combined final phase)*
7a. **max-devops**: CI validation, PR merge, cleanup
7b. **chris-architect**: Executive summary report to user

---

## Issue Sources & Management

**Issues come from three sources:**

| Source | When Created | Purpose |
|--------|--------------|---------|
| **Feature Planning** | User requirements with chris-architect | Strategic development tasks |
| **Review Findings** | During Phase 6-7 when fixes need >30min | Prevent scope creep |
| **Playtest Audit** | System-wide testing on clean repository | Comprehensive bug backlog |

**Management Principles:**
- **Fix Now (<30min) or File Issue**: Critical findings fixed immediately, others become issues
- **Labels**: [CRITICAL], [IMPROVEMENT], [TECHNICAL-DEBT], [UX], [DOCS], [SECURITY]
- **chris-architect owns**: Issue lifecycle, triage, prioritization, closure decisions

---

## Core Principles

### Quality Standards
- **TDD Workflow**: Test-driven development with meaningful coverage
- **MVP Focus**: Highest quality minimum viable product delivery
- **Zero Shortcuts**: 100% completion, no placeholders or stubs
- **Code Quality**: SOLID, KISS, SRP, DRY principles
- **Precision**: Computational physics-level accuracy

### Code Standards
- **Style**: 88 char limit, 4-space indent, self-documenting
- **Commits**: Conventional format, imperative mood, <72 chars
- **Fortran**: `typename_t` convention, empty associate blocks

### Workflow Modes

| Mode | Trigger | Behavior |
|------|---------|----------|
| **Single Issue** (default) | Standard operation | Complete one issue → stop |
| **Batch Mode** | User says "solve all issues" | Continue until ALL issues resolved |
| **Manual Mode** | User says "manual mode" | User participates as reviewer in Phase 6b |

### Definition of Done
✅ All tests pass with meaningful coverage  
✅ CI green, zero build artifacts  
✅ Documentation updated atomically  
✅ All reviewers approve (critical findings fixed)  

---

## References

| Resource | Description |
|----------|-------------|
| [Claude Code Docs](https://docs.anthropic.com/en/docs/claude-code/common-workflows) | Official documentation |
| `CLAUDE.md` | Complete workflow specifications |
| `DESIGN.md` | System architecture and design patterns |
| `PROMPTS.md` | Original agent workflow prompts |

---

## Visual Workflow Guides

### Simple Workflow Flow
```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│   Agent     │──▶│ max-devops  │──▶│  patrick    │
│ implements  │    │ validates   │    │  reviews    │
└─────────────┘    └─────────────┘    └─────────────┘
                           │                   │
                           ▼                   ▼
                     Build fails?        Findings?
                      YES│NO             YES│NO
                         │                  │
                         ▼                  ▼
                   Back to Agent      Fix & retry
                         │                  │
                        NO                 NO
                         ▼                  ▼
                      Continue           Continue
                         │                  │
                         ▼                  ▼
                   ┌─────────────┐    ┌─────────────┐
                   │ max-devops  │◄───│    DONE     │
                   │  cleanup    │    │             │
                   └─────────────┘    └─────────────┘
```

### Complex Workflow Flow
*Honest serial execution throughout*
```
Phase 1-2: Planning (Serial)
┌─────────────┐    ┌─────────────┐
│ max-devops  │──▶│    chris    │
│ repo check  │    │ prioritizes │
└─────────────┘    └─────────────┘

Phase 3-4: Design & Tests (Serial)  
┌─────────────┐    ┌─────────────┐
│    chris    │──▶│    georg    │
│architecture │    │writes tests │
└─────────────┘    └─────────────┘

Phase 5: Docs → Implementation (Serial, Docs-First)
┌─────────────┐    ┌─────────────┐
│    winny    │──▶│   sergei    │
│    docs     │    │    code     │
└─────────────┘    └─────────────┘

Phase 6: Serial Review Chain
┌─────────────┐    ┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│ max-devops  │──▶│   patrick   │──▶│    vicky    │──▶│    chris    │
│build & test │    │code quality │    │  UAT & UX   │    │architecture │
└─────────────┘    └─────────────┘    └─────────────┘    └─────────────┘
                                                                  │
                                                                  ▼
                                                   ┌──────────────────────────────┐
                                                   │     At ANY review step:      │
                                                   │   Critical issues found?     │
                                                   │          YES│NO              │
                                                   │             │                │
                                                   │        ┌────▼────┐          │
                                                   │        │Hand back│          │
                                                   │        │to sergei│          │
                                                   │        │& retry  │          │
                                                   │        └─────────┘          │
                                                   └──────────────┼───────────────┘
                                                                 NO
                                                                  ▼
                                                   ┌──────────────────────────────┐
                                                   │        Manual Mode?          │
                                                   │          YES│NO              │
                                                   └──────────────┼───────────────┘
                                                                 │
                                                              ┌──▼──┐    ┌─────────────┐
                                                              │User │──▶ │   Done or   │
                                                              │Final│    │ Hand back   │
                                                              └─────┘    └─────────────┘

Phase 7: Completion (Combined)
┌─────────────┐    ┌─────────────┐
│ max-devops  │──▶│    chris    │
│integration  │    │  summary    │
└─────────────┘    └─────────────┘
```

### Workflow Decision Tree
```
START: New Task
        │
        ▼
┌─────────────────┐
│ Simple Workflow │ ◄─── ALL criteria met:
│ Criteria Check  │      • Single file
└─────────────────┘      • No API changes
        │                • No dependencies  
      YES│NO              • <2 hours
        ▼                
┌─────────────────┐      ┌─────────────────┐
│ Simple Workflow │      │ Complex Workflow│
│ 6 steps         │      │ 7 phases        │
└─────────────────┘      └─────────────────┘
```

---

*Claude Multi-Agent Development System - Structured TDD workflow for quality-first development*