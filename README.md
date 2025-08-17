# Quality-driven Agent Development System (QADS)

A multi-agent software development system featuring specialized AI agents working through structured TDD workflows with quality gates and rapid feedback cycles.

## Quick Start

**You have complete control** - override any workflow, decision, or process with your explicit direction.

**Choose your workflow:**
- **Feature Planning** → Strategic planning with chris-architect  
- **Feature Development** → Structured implementation (simple/complex)
- **Playtest Workflow** → System audit for defects only

**Execution modes:**
- Single Task (default): Complete one task and stop
- Batch Mode: Solve all issues automatically until repository clean
- Manual Review: Include your review at any stage

**Override examples:**
- "Use simple workflow for this complex change"
- "Work on issue #123" | "Just fix this quickly"
- "Manual review mode" | "Skip all reviews"

## Workflow Types

### Feature Planning
*User ↔ chris-architect collaboration*

```
Goals/Requirements ──▶ chris-architect ──▶ DESIGN.md + GitHub Issues
```

- Strategic planning and requirements capture
- chris-architect has full authority to create/update DESIGN.md and issues
- Use when starting new features or major changes

### Feature Development  
*Structured implementation workflow*

- Execute planned work through TDD process
- Automatic workflow selection: simple (single file, <2hrs) or complex (multi-file, >2hrs)
- Quality gates with multi-stage reviews and immediate handback on critical findings

### Playtest Workflow
*System audit for defects only*

```
Clean Repository ──▶ Automatic Trigger ──▶ System Audit ──▶ DEFECT Backlog
```

⚠️ **Defects only** - Never creates issues for new features or scope expansion
- Automatically triggered when repository is clean (no PRs/issues)
- Serial audit by all agents to discover broken functionality only
- Files GitHub issues with severity labels: [CRITICAL], [BUG], [SECURITY], [TECHNICAL-DEBT], [DOCS]

## The Team

**Core Development Agents:**

| Agent | Role | Primary Responsibilities |
|-------|------|-------------------------|
| **chris-architect** | Chief Architect | System architecture, issue lifecycle, DESIGN.md, MVP focus |
| **sergei-perfectionist-coder** | Chief Programmer | Production code, API docs, zero-compromise implementation |
| **georg-test-engineer** | Test Engineer | Test creation (unit/integration/system), BDD expertise |
| **patrick-auditor** | Code Reviewer/QA | Security analysis, code quality, compliance verification |
| **vicky-acceptance-tester** | Customer/Tester | User acceptance testing, UX validation |
| **max-devops-engineer** | Development Manager | Build execution, repository hygiene, CI/CD operations |
| **winny-technical-writer** | Technical Writer | User documentation, technical content creation |

**Specialist Agents:** steffi-ux-designer, philipp-data-scientist, jonatan-math-physicist

## Workflow Selection

### Simple Workflow (Auto-selected OR your override)

**Criteria:** Single file, no API changes, no new dependencies, <2 hours

**Process:** Implementation → Serial Review Chain → Cleanup
- Serial Review: max validation → patrick code quality → chris architecture
- Immediate handback on critical findings, autonomous minor fixes

### Complex Workflow (Auto-selected OR your override)

**Criteria:** Multiple files, API changes, new dependencies, >2 hours, architecture impact

**Process:** Full 7-phase workflow with TDD, documentation-first implementation, and comprehensive review chain

## Simple Workflow Process

**Phases:**
1. **Implementation**: sergei-perfectionist-coder implements changes
2. **Serial Review**: max validation → patrick code quality → chris architecture
3. **Completion**: max cleanup and completion

**Findings Protocol:**
- CRITICAL → immediate handback to sergei → restart review chain
- MINOR → reviewer fixes autonomously within scope or files issue

**Manual Review Mode:** User participates as final reviewer (when requested)

**Batch Mode:** Continue until all issues resolved (can run indefinitely due to playtest)

## Complex Workflow Process

**7-Phase Development Process:**

**Phase 1-2: Planning**
1. **max**: Repository assessment (handles existing PRs/branches/issues/untracked files)
2. **chris-architect**: Issue selection and prioritization (if needed)

**Phase 3-4: Design & Tests**
3. **chris-architect**: DESIGN.md review, implementation plan
4. **georg-test-engineer**: Test-driven development, writes failing tests

**Phase 5: Documentation-First Implementation**
5. **winny-technical-writer**: User documentation
6. **sergei-perfectionist-coder**: Code + API docs using winny's guidance

**Phase 6: Serial Review Chain**
- **max**: Technical validation → **patrick**: Code quality + security → **vicky**: User acceptance + UX → **chris**: Architecture alignment
- **User**: Final review (manual review mode only)
- **Critical findings**: Immediate handback to sergei → restart review chain

**Phase 7: Completion**
- **max**: Repository cleanup, CI validation, PR merge
- **chris**: Executive summary report

## Issue Management

**Issue Sources:**

| Source | Purpose | Labels Used |
|--------|---------|-------------|
| **Feature Planning** | Strategic development tasks | All labels allowed |
| **Review Findings** | Prevent scope creep (fixes >30min) | [BUG], [TECHNICAL-DEBT] |
| **Playtest Audit** | DEFECT backlog only | [CRITICAL], [BUG], [SECURITY], [TECHNICAL-DEBT], [DOCS] |

**Management:**
- **Boy Scout Rule**: Clean up minor issues within competence bounds
- **Fix or File**: Critical → fix immediately, Minor → fix autonomously or file issue
- **Your Control**: Override selection, specify issues, or provide custom tasks

---

## Core Principles

**Quality Standards:**
- TDD workflow with meaningful test coverage
- MVP focus: highest quality minimum viable product
- Zero shortcuts: 100% completion, no placeholders
- Code quality: SOLID, KISS, SRP, DRY principles

**Workflow Modes:**

| Execution Mode | Trigger | Behavior |
|----------------|---------|----------|
| **Single Issue** (default) | Standard | Complete one issue → stop |
| **Batch Mode** | "solve all issues" | Continue until all resolved (typically infinite) |

| Review Mode | Trigger | Behavior |
|-------------|---------|----------|
| **Automatic** (default) | Standard | All agent reviews autonomous |
| **Manual Review** | "manual mode" | User participates as final reviewer |

**Definition of Done:**
✅ All tests pass ✅ CI green ✅ Documentation updated ✅ All reviews passed ✅ Repository cleaner than found

## Documentation

**QADS applies proven quality practices at micro-scale** - every issue and PR follows structured protocols with quality gates, multi-stage reviews, and rapid feedback cycles.

| Resource | Description |
|----------|-------------|
| [Claude Code Docs](https://docs.anthropic.com/en/docs/claude-code/common-workflows) | Official documentation |
| `CLAUDE.md` | Complete workflow specifications |
| `DESIGN.md` | System architecture and design patterns |
| `PROMPTS.md` | Original agent workflow prompts |

## Playtest & Batch Mode

### Playtest Workflow
**Triggered:** Repository is clean (zero PRs, zero issues)

**Process:**
1. **max**: Repository health, build validation, CI verification
2. **patrick**: Security audit, code quality, technical debt
3. **vicky**: User testing, stress testing, edge cases
4. **chris**: Architecture review, design consistency
5. **All agents**: File DEFECT issues only with severity labels

**Labels:** [CRITICAL], [BUG], [TECHNICAL-DEBT], [SECURITY], [DOCS]
**Forbidden:** [IMPROVEMENT], [ENHANCEMENT], [FEATURE], [UX]

### Batch Mode
**Warning:** Typically runs indefinitely due to playtest discovering new defects

**Activation:** "solve all open issues" or "fix all issues"

**Logic:**
1. Complete issue → Repository assessment
2. More issues? → Continue workflow
3. No issues? → Automatic playtest
4. Playtest discovers defects → Repeat cycle
5. Rare termination when playtest finds zero issues

---

## Visual Workflow Guides

### Batch Mode Flow
```
WARNING: Can run indefinitely due to playtest replenishment

Start → Complete Issue → Repository Assessment → Issues Remain? 
  ▲                                                      │
  │                                                   YES│NO
  │                                                      │
  │            Continue Workflow Cycle ◄─────────────────┘
  │                     ▲                               │
  │                     │                              NO
  │                     │                               ▼
  │               ┌─────────────┐              ┌─────────────────┐
  │               │New Issues   │              │  PLAYTEST       │
  │               │Created      │              │  WORKFLOW       │
  │               │(Usually)    │              │  (Automatic)    │
  │               └─────────────┘              └─────────────────┘
  │                     ▲                               │
  │                     │                               ▼
  │               ┌─────────────────────────────────────────────┐
  │               │  Playtest Discovers Issues?                 │
  │               │          USUALLY YES │ RARELY NO            │
  │               └─────────────────────────────────────────────┘
  │                                      │
  └──────────────────────────────────────┘        RARELY NO
                                                       │
                                                       ▼
                                              Executive Summary
                                              (VERY RARE END)
```

### Simple Workflow Flow
```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│   sergei    │──▶│     max     │──▶│  patrick    │
│ implements  │    │ validates   │    │  reviews    │
└─────────────┘    └─────────────┘    └─────────────┘
                                              │
                                              ▼
                                    ┌──────────────────┐
                                    │  Manual Review?  │
                                    │      YES│NO      │
                                    └──────────────────┘
                                              │
                                           ┌──▼──┐    ┌─────────────┐
                                           │User │──▶ │   Done or   │
                                           │Final│    │ Hand back   │
                                           └─────┘    └─────────────┘
                                              │
                                              ▼
                                    ┌──────────────────────────────┐
                                    │     At ANY review phase:     │
                                    │   Critical issues found?     │
                                    │          YES│NO              │
                                    │             │                │
                                    │   ┌─────────▼─────────┐      │
                                    │   │Minor fixes within │      │
                                    │   │reviewer scope?    │      │
                                    │   │Fix autonomously   │      │
                                    │   │and commit cleanly │      │
                                    │   └─────────┬─────────┘      │
                                    │             │                │
                                    │        ┌────▼────┐          │
                                    │        │Hand back│          │
                                    │        │to sergei│          │
                                    │        │then FIRST│          │
                                    │        │reviewer  │          │
                                    │        └─────────┘          │
                                    └──────────────┼───────────────┘
                                                  NO
                                                   ▼
                                           ┌─────────────┐
                                           │     max     │
                                           │  cleanup    │
                                           └─────────────┘
```

### Complex Workflow Flow
*Honest serial execution throughout*
```
Phase 1-2: Planning (Serial)
┌─────────────┐    ┌─────────────┐
│     max     │──▶│    chris    │
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
│     max     │──▶│   patrick   │──▶│    vicky    │──▶│    chris    │
│build & test │    │code quality │    │  UAT & UX   │    │architecture │
└─────────────┘    └─────────────┘    └─────────────┘    └─────────────┘
                                                                  │
                                                                  ▼
                                                   ┌──────────────────────────────┐
                                                   │     At ANY review phase:     │
                                                   │   Critical issues found?     │
                                                   │          YES│NO              │
                                                   │             │                │
                                                   │   ┌─────────▼─────────┐      │
                                                   │   │Minor fixes within │      │
                                                   │   │reviewer scope?    │      │
                                                   │   │Fix autonomously   │      │
                                                   │   │and commit cleanly │      │
                                                   │   └─────────┬─────────┘      │
                                                   │             │                │
                                                   │        ┌────▼────┐          │
                                                   │        │Hand back│          │
                                                   │        │to sergei│          │
                                                   │        │then FIRST│          │
                                                   │        │reviewer  │          │
                                                   │        └─────────┘          │
                                                   └──────────────┼───────────────┘
                                                                 NO
                                                                  ▼
                                                   ┌──────────────────────────────┐
                                                   │     Manual Review Mode?     │
                                                   │          YES│NO              │
                                                   └──────────────┼───────────────┘
                                                                 │
                                                              ┌──▼──┐    ┌─────────────┐
                                                              │User │──▶ │   Done or   │
                                                              │Final│    │ Hand back   │
                                                              └─────┘    └─────────────┘

Phase 7: Completion (Combined)
┌─────────────┐    ┌─────────────┐
│     max     │──▶│    chris    │
│integration  │    │  summary    │
└─────────────┘    └─────────────┘
```

### Playtest Workflow Flow
```
Repository State Check
        │
        ▼
┌─────────────────────────────┐
│ Clean Repository?           │
│ • Zero PRs                  │ 
│ • Zero Issues               │
└─────────────────────────────┘
        │
      YES│NO
        │
        ▼                     
┌─────────────────────────────┐
│    PLAYTEST WORKFLOW        │
│       (Automatic)           │
└─────────────────────────────┘
        │
        ▼
┌─────────────────────────────┐
│ Serial Audit Process:       │
│ 1. max: Build/CI health     │
│ 2. patrick: Security/Quality │ 
│ 3. vicky: User Testing      │
│ 4. chris: Architecture      │
└─────────────────────────────┘
        │
        ▼
┌─────────────────────────────┐
│ All Agents:                 │
│ File Issues by Severity     │
│ [CRITICAL][IMPROVEMENT]     │
│ [TECHNICAL-DEBT][UX]        │
│ [DOCS][SECURITY]            │
└─────────────────────────────┘
        │
        ▼
┌─────────────────────────────┐
│    Batch Execution Mode?    │
│        YES│NO               │
└─────────────────────────────┘
             │
        ┌────▼─────┐         ┌──────────────────┐
        │ Continue │         │ Executive Summary│
        │ Workflow │         │     & STOP       │
        │  Cycles  │         └──────────────────┘
        │(INFINITE)│
        │ ⚠️ Loop │
        └──────────┘
```

### Batch Mode Flow
```
Batch Mode Trigger: "solve all issues"
        │
        ▼
┌─────────────────────────────┐
│    Repository Assessment    │
│    (max-devops check)       │
└─────────────────────────────┘
        │
        ▼
┌─────────────────────────────┐
│     Issues Exist?           │
│        YES│NO               │
└─────────────────────────────┘
             │
        ┌────▼─────┐         ┌──────────────────┐
        │ Execute  │         │ Final Executive  │
        │Workflow  │         │ Summary & STOP   │
        │for Issue │         └──────────────────┘
        └────┬─────┘                   ▲
             │                         │
             ▼                         │
┌─────────────────────────────┐        │
│    Issue Completed          │        │
│    Return to Assessment     │────────┘
│    (Workflow Continuation)  │     NO
└─────────────────────────────┘
             │
             ▼
┌─────────────────────────────┐
│   More Issues Remain?       │
│        YES│NO               │
└─────────────────────────────┘
             │
            YES
             │
             └──────────────────┐
                                │
                                ▼
        ┌─────────────────────────────┐
        │    Continue Cycle           │
        │    (MANDATORY until         │
        │     ALL issues resolved)    │
        └─────────────────────────────┘
```

### Workflow Decision Tree
```
START: Repository State
        │
        ▼
┌─────────────────┐
│ max Assessment  │
│ • PRs exist?    │
│ • Issues exist? │
│ • Clean slate?  │
└─────────────────┘
        │
    ┌───▼────────────────────────┐
    │                            │
    ▼            ▼               ▼
┌─────────┐ ┌─────────┐ ┌──────────────┐
│Continue │ │ Issue   │ │   PLAYTEST   │
│Existing │ │Selection│ │   WORKFLOW   │
│   PR    │ │& Branch │ │  (Automatic) │
└─────────┘ └─────────┘ └──────────────┘
                 │              │
                 ▼              ▼
        ┌─────────────────┐ ┌─────────────┐
        │ Simple Workflow │ │ Issue       │
        │ Criteria Check  │ │ Creation    │
        └─────────────────┘ └─────────────┘
                 │              │
               YES│NO            │
                 ▼              │
        ┌─────────────────┐     │
        │ Simple Workflow │     │
        │ 3 phases        │     │
        └─────────────────┘     │
                 │              │
                 │         ┌────▼────┐
                 │         │ Batch   │
                 │         │ Mode?   │
                 │         └────┬────┘
                 │              │
                 │           YES│NO
                 │              │
                 └──────────────┼─────────────────┐
                                │                 │
                                ▼                 ▼
                       ┌─────────────────┐ ┌─────────────┐
                       │ Complex Workflow│ │  Single     │
                       │ 7 phases        │ │  Task &     │
                       └─────────────────┘ │  STOP       │
                                           └─────────────┘

Note: Manual Review Mode can be combined with any workflow above
```

---

*Quality-driven Agent Development System (QADS) - Structured TDD workflow for quality-first development*