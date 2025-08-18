# Quality-driven Agent Development System (QADS)

A multi-agent software development system featuring specialized AI agents working through structured TDD workflows with quality gates and rapid feedback cycles.

## Quick Start

**You have complete control** - override any workflow, decision, or process with your explicit direction.

```bash
# User Override Examples
"Use simple workflow for this complex change"
"Work on issue #123"  # bypasses chris-architect selection
"Manual review mode"   # adds user review step
"Batch mode"           # autonomous execution until all issues resolved
"Skip patrick review" # customizes review chain
"Just implement, skip documentation" # process customization
```

## Workflow Types

### 1. Feature Planning
*User ↔ chris-architect collaboration*

**When**: New goals, features, or design requirements need translation into actionable work
**Authority**: chris-architect has FULL authority to create/update DESIGN.md and GitHub issues based on your requirements
**Focus**: MVP delivery with feature creep prevention

### 2. Feature Development  
*Structured implementation workflow*

**Decision Tree** - Workflow automatically selected based on:

**Simple Workflow** (4 phases):
- ✅ Single file affected
- ✅ No API/interface changes  
- ✅ No new dependencies
- ✅ Estimated <2 hours work
- ✅ **USER OVERRIDE**: "Use simple workflow" for ANY task

**Complex Workflow** (7 phases):
- ❌ Multiple files affected
- ❌ API/interface changes required
- ❌ New dependencies needed
- ❌ Estimated >2 hours work
- ❌ Architecture impact
- ❌ New features requiring documentation
- ✅ **USER OVERRIDE**: "Use complex workflow" for ANY task

### 3. Playtest Workflow
*System audit for defects only*

**When**: Clean repository state (all PRs merged, all issues closed)
**Purpose**: Discover DEFECTS ONLY - bugs, broken functionality, security vulnerabilities
**Constraint**: NEVER files issues for new features or enhancements
**Trigger**: Automatically initiated when repository is clean

## The Team

| Agent | Role | Phase Position | Primary Focus |
|-------|------|----------------|---------------|
| **max-devops-engineer** | Development Manager | Phase 1 (Mandatory) | Repository state assessment, build operations, conflict resolution |
| **chris-architect** | Chief Architect | Phase 2 & Final Review | System architecture, issue lifecycle, goal completion verification |
| **georg-test-engineer** | Test Engineer | Phase 4 (RED) | Test assessment and implementation |
| **sergei-perfectionist-coder** | Chief Programmer | Phase 5 | Production code, API documentation |
| **patrick-auditor** | Code Reviewer/QA | Phase 6.2 | Code quality (SOLID, KISS, YAGNI, DRY), security analysis |
| **winny-technical-writer** | Technical Writer | Phase 6.3 | User documentation of validated implementation |
| **vicky-acceptance-tester** | Customer/Tester | Phase 6.4 | Documentation-reality validation, user workflow testing |

**Key Workflow Features:**
- **Phase 1 Mandatory**: max-devops always assesses repository state first
- **Documentation Chain**: winny documents validated code → vicky tests docs against reality
- **Smart Handback**: vicky → winny (minor doc fixes) | vicky → sergei (major code-doc mismatches)

**Specialists:** steffi-ux-designer, philipp-data-scientist, jonatan-math-physicist

## Execution Modes

**Execution Modes:**
| Mode | Trigger | Behavior |
|------|---------|----------|
| **Single Issue** (default) | Standard request | Complete one issue → Executive Summary → STOP |
| **Batch Mode** | "batch mode" or "solve all issues" | Autonomous execution until repository clean |

**Review Modes:**
| Mode | When Used | Behavior |
|------|-----------|----------|
| **Automatic Review** (default) | Standard/Batch mode | All agent reviews proceed autonomously |
| **Manual Review** | "batch mode with manual review" | User participates as final reviewer after all agents |

**Critical Batch Mode Rules:**
- **NEVER STOP FOR USER INTERACTION** - runs completely autonomously
- **AUTOMATIC REVIEW DEFAULT** - unless user explicitly requests manual review
- **CONTINUOUS EXECUTION** - works through all issues until repository is clean
- **AUTO-PLAYTEST** - triggers playtest when clean, may create infinite cycle of issue resolution

## Workflow Phases

**Simple Workflow (4 phases):**
1. **Phase 1**: max-devops repository assessment (MANDATORY)
2. **Phase 2**: sergei-perfectionist-coder implementation  
3. **Phase 3**: Serial review chain (max → patrick → chris)
4. **Phase 4**: max-devops cleanup and completion

**Complex Workflow (7 phases):**
1. **Phase 1**: max-devops repository assessment (MANDATORY)
2. **Phase 2**: chris-architect work prioritization
3. **Phase 3**: chris-architect architecture documentation
4. **Phase 4**: georg-test-engineer test implementation (RED phase)
5. **Phase 5**: sergei-perfectionist-coder code implementation
6. **Phase 6**: Documentation-validated review chain:
   - 6.1: max-devops technical validation
   - 6.2: patrick-auditor code quality review  
   - 6.3: winny-technical-writer documents validated implementation
   - 6.4: vicky-acceptance-tester validates docs against reality
   - 6.5: chris-architect final architecture review
   - 6.6: User review (manual review mode only)
7. **Phase 7**: max-devops + chris-architect completion

## Core Principles

**Quality Standards:**
- TDD workflow with meaningful test coverage
- MVP focus: highest quality minimum viable product  
- Zero shortcuts: 100% completion, no placeholders
- Code quality: SOLID, KISS, SRP, DRY principles
- Boy Scout Rule: Leave everything cleaner than you found it

**Definition of Done:**
✅ All tests pass ✅ CI green ✅ Documentation updated ✅ All reviews passed ✅ Repository cleaner than found ✅ User acceptance validated

## Documentation

| Resource | Description |
|----------|-------------|
| [Claude Code Docs](https://docs.anthropic.com/en/docs/claude-code/common-workflows) | Official documentation |
| `CLAUDE.md` | Complete workflow specifications |
| `PROMPTS.md` | Agent workflow prompts and commands |

---

*Quality-driven Agent Development System (QADS) - Structured TDD workflow for quality-first development*