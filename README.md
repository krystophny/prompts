# Quality-driven Agent Development System (QADS)

A multi-agent software development system featuring specialized AI agents working through structured TDD workflows with quality gates and rapid feedback cycles.

## Quick Start

**You have complete control** - override any workflow, decision, or process with your explicit direction.

```bash
# Basic usage examples
"Use simple workflow for this complex change"
"Work on issue #123" 
"Manual review mode" 
"Batch mode - solve all issues"
```

## Workflow Types

### Feature Planning
*User ↔ chris-architect collaboration*

Strategic planning and requirements capture. chris-architect has full authority to create/update DESIGN.md and issues based on your requirements.

### Feature Development  
*Structured implementation workflow*

**Simple Workflow:** Single file, <2 hours → Implementation → Serial Review → Cleanup

**Complex Workflow:** Multi-file, >2 hours → Full 7-phase TDD process with documentation-first implementation

### Playtest Workflow
*System audit for defects only*

Automatically triggered when repository is clean (no PRs/issues). Comprehensive system audit to discover broken functionality only - never creates feature requests.

## The Team

| Agent | Role | Primary Focus |
|-------|------|---------------|
| **chris-architect** | Chief Architect | System architecture, issue lifecycle, MVP focus |
| **sergei-perfectionist-coder** | Chief Programmer | Production code, zero-compromise implementation |
| **georg-test-engineer** | Test Engineer | Test creation, BDD expertise |
| **patrick-auditor** | Code Reviewer/QA | Code quality principles (SOLID, KISS, YAGNI, DRY), security analysis |
| **vicky-acceptance-tester** | Customer/Tester | User acceptance testing, UX validation |
| **max-devops-engineer** | Development Manager | Build execution, repository hygiene, CI/CD |
| **winny-technical-writer** | Technical Writer | User documentation |

**Specialists:** steffi-ux-designer, philipp-data-scientist, jonatan-math-physicist

## Execution Modes

| Mode | Trigger | Behavior |
|------|---------|----------|
| **Single Issue** (default) | Standard | Complete one issue → stop |
| **Batch Mode** | "solve all issues" | Autonomous execution until all resolved |
| **Manual Review** | "manual mode" | User participates as final reviewer |
| **Automatic Review** (default) | Standard/Batch | All agent reviews autonomous |

## Core Principles

**Quality Standards:**
- TDD workflow with meaningful test coverage
- MVP focus: highest quality minimum viable product  
- Zero shortcuts: 100% completion, no placeholders
- Code quality: SOLID, KISS, SRP, DRY principles

**Definition of Done:**
✅ All tests pass ✅ CI green ✅ Documentation updated ✅ All reviews passed ✅ Repository cleaner than found

## Documentation

| Resource | Description |
|----------|-------------|
| [Claude Code Docs](https://docs.anthropic.com/en/docs/claude-code/common-workflows) | Official documentation |
| `CLAUDE.md` | Complete workflow specifications |
| `PROMPTS.md` | Agent workflow prompts and commands |

---

*Quality-driven Agent Development System (QADS) - Structured TDD workflow for quality-first development*