# Quality-driven Agent Development System (QADS)

A quality-driven multi-agent software development system featuring specialized AI agents working collaboratively through structured TDD processes.

## Quick Start

**Choose Your Workflow:**

1. **New Feature/Requirements** → Use **Feature Planning** with chris-architect
2. **Execute Existing Work** → Use **Feature Development** workflow  
3. **System Audit** → **Playtest Workflow** (auto-triggered on clean repository)

**Execution Modes:**
- **Single Issue** (default): Complete one task and stop
- **Batch Mode**: Solve all open issues automatically (`"solve all issues"`) - 🤖 Fully autonomous
- **Manual Review**: Include user review in workflow (`"manual mode"`) - Independent of execution mode

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

```
Clean Repository ──▶ Automatic Trigger ──▶ System Audit ──▶ Issue Backlog
```

- **Purpose**: Discover defects and improvements through exhaustive system exploration
- **Trigger**: Automatically initiated when repository is clean (no PRs/issues)
- **Process**: Serial audit by all agents to build comprehensive bug backlog
- **Result**: GitHub issues labeled by severity for future development

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

**Process**: sergei-perfectionist-coder → Serial Review Chain → fixes → max cleanup
- **Serial Review Chain**: max validation (FIRST REVIEWER) → patrick review → chris-architect final review
- **Manual Review Mode**: User participates as final reviewer (only when explicitly requested)

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

**Phases:**
1. **Phase 1**: sergei-perfectionist-coder implements changes
2. **Phase 2**: Serial Review Chain (max validation (FIRST REVIEWER) → patrick review → chris-architect final review)
3. **Phase 3**: max cleanup and completion

**Manual Review Mode**: User participates as final reviewer (only when explicitly requested)

**Findings Protocol**: CRITICAL → immediate handback | MAJOR/MINOR → Fix Now (<30min) or File Issue
**CRITICAL HANDBACK**: sergei fixes → return to FIRST reviewer (max) → restart entire review chain from beginning
**Iteration**: Repeat phases until all findings resolved

**Batch Behavior:**
- **Single Issue** (default): Complete one issue → stop
- **Batch Mode**: Continue automatically until ALL issues resolved (⚠️ Can run indefinitely - see Batch Mode section)

## Complex Workflow Process

**Key Principle**: Never start new work when existing work is unfinished

### 7-Phase Development Process

**Phase 1-2: Planning & Prioritization**
1. **max**: Repository assessment (non-draft PRs → review phase | draft PRs → implementation | remote branches → test phase | open issues → selection)
2. **chris-architect**: Issue selection and prioritization (if no existing work found)

**Phase 3: Architecture Documentation**
3. **chris-architect**: Reviews DESIGN.md, creates implementation plan

**Phase 4: RED Phase (Test-Driven Development)**
4. **georg-test-engineer**: Writes failing tests and opens draft PR (parallel with chris refinements)

**Phase 5: Documentation → Implementation** *(Serial Execution - docs first)*
5. **Implementation Phase** (docs-first approach):
   - **winny-technical-writer**: User documentation 
   - **sergei-perfectionist-coder**: Code + API documentation using winny's docs as guide

**Phase 6: Serial Review Chain** *(fully serial execution)*:
   - **max**: Technical validation (FIRST REVIEWER) → immediate handback if critical issues
   - **patrick-auditor**: Code quality + security → immediate handback if critical issues
   - **vicky-acceptance-tester**: User acceptance + UX → immediate handback if critical issues
   - **chris-architect**: Architecture alignment → immediate handback if critical issues
   - **User**: Final review (manual review mode only) → immediate handback if critical issues

**Phase 7: Completion** *(combined final phase)*
7a. **max**: CI validation, PR merge, cleanup
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

**Execution Modes:**

| Mode | Trigger | Behavior |
|------|---------|----------|
| **Single Issue** (default) | Standard operation | Complete one issue → stop |
| **Batch Mode** ⚠️ | User says "solve all issues" | 🤖 Fully autonomous - Continue until ALL issues resolved (typically infinite due to playtest) |

**Review Modes (Independent):**

| Mode | Trigger | Behavior |
|------|---------|----------|
| **Automatic Review** (default) | Standard operation | All agents complete review autonomously |
| **Manual Review** | User says "manual mode" | User participates as final reviewer in workflow |

**Valid Combinations:**
- Single Issue + Automatic Review (DEFAULT)
- Single Issue + Manual Review
- Batch Mode + Automatic Review  
- Batch Mode + Manual Review

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

## Playtest Workflow Process

**When Triggered**: Repository is clean (zero PRs, zero issues)

**Example Trigger**:
```bash
$ gh pr list
# No open pull requests

$ gh issue list  
# No open issues

# → Playtest Workflow automatically initiates
```

**Serial Audit Phases**:
1. **max-devops-engineer**: Repository health check, build validation, CI verification
2. **patrick-auditor**: Security audit, code quality review, technical debt identification  
3. **vicky-acceptance-tester**: Exhaustive user testing, stress testing, edge case exploration
4. **chris-architect**: Architecture review, design consistency validation, strategic assessment
5. **All agents**: File issues for discovered defects at appropriate severity levels
6. **max-devops-engineer**: Ensure all findings documented as GitHub issues

**Issue Labels Created**:
- `[CRITICAL]` - System-breaking issues requiring immediate attention
- `[IMPROVEMENT]` - Enhancement opportunities  
- `[TECHNICAL-DEBT]` - Code quality and maintainability issues
- `[UX]` - User experience improvements
- `[DOCS]` - Documentation gaps or errors
- `[SECURITY]` - Security vulnerabilities or hardening opportunities

**Completion Modes**:
- **Single Mode** (default): After playtest → chris-architect Executive Summary → STOP
- **Batch Mode**: After playtest → immediately continue resolving ALL discovered issues → triggers new playtest when clean → potentially infinite cycle

---

## Batch Mode Behavior

⚠️ **CRITICAL WARNING**: Batch mode typically runs indefinitely because the playtest workflow discovers new issues each time the repository becomes clean. Only use batch mode when you have significant time available.

**Activation**: User explicitly requests `"solve all open issues"` or `"fix all issues"`

**Example Usage**:
```bash
# User says: "solve all open issues"
# → Triggers batch mode for ALL workflows
```

**Batch Mode Logic**:

⚠️ **WARNING**: Batch mode can run indefinitely because playtest workflow usually discovers new issues

1. **Workflow Continuation**: After completing ANY issue → return to PHASE 1 (max-devops assessment)
2. **Automatic Playtest Trigger**: When repository is clean (zero issues), playtest workflow automatically runs
3. **Issue Replenishment**: Playtest typically discovers new issues and files them as GitHub issues
4. **Infinite Cycle Potential**: New issues → batch continues → clean repository → playtest → more issues → repeat
5. **Rare Termination**: Batch only stops when playtest discovers ZERO issues (very rare)
6. **Final Summary Only**: Executive Summary delivered only after playtest finds zero issues

**Works With All Workflows**:
- **Simple Workflow Batch**: Complete simple issue → assess repository → continue if issues remain
- **Complex Workflow Batch**: Complete complex issue → assess repository → continue if issues remain  
- **Playtest + Batch**: Clean repository triggers playtest → creates issues → immediately resolves ALL issues → clean repository → playtest again → potentially infinite

**Batch Mode Flow**:
```
⚠️ WARNING: Can run indefinitely due to playtest replenishment

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

---

## Visual Workflow Guides

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