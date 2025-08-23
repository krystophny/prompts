# Quality-driven Agent Development System (QADS) v3.0

An agent-based development system with three core workflows optimized for Claude Code.

## Quick Setup

```bash
# Copy system files to Claude config
cp CLAUDE.md ~/.claude/
cp -r agents/ ~/.claude/
cp -r commands/ ~/.claude/
```

## Core Workflows

```bash
"plan"         # Planning workflow - chris creates issues
"work"         # Implementation workflow - max→sergei→patrick→max  
"play"         # Quality audit workflow - find defects only

"batch work"   # Autonomous TODO processing until empty
"batch play"   # Continuous defect detection loop
```

## Workflow Details

**PLAN**: chris-architect creates issues and maintains BACKLOG.md priorities  
**WORK**: max prepares branches → sergei implements → patrick reviews → max merges  
**PLAY**: Complete quality audit - winny docs + parallel audits (patrick/vicky)

## Key Features

- **Agent Specialization**: Each agent has clear ownership and constraints
- **State Management**: BACKLOG.md tracks TODO → DOING → DONE progression  
- **Quality Gates**: Mandatory code review and CI completion
- **Batch Processing**: Autonomous execution for high-velocity workflows

## Quality Standards

- **Code**: CORRECTNESS > PERFORMANCE > KISS > SRP > YAGNI > DRY  
- **Size**: Files <1000 lines, Functions <100 lines
- **Git**: Conventional commits, specific file staging, immediate push
- **Testing**: TDD with RED/GREEN/REFACTOR cycles

## Agent Roles

- **chris**: Planning, issues, BACKLOG.md, architecture  
- **max**: Repository management, branch prep, CI, merge  
- **sergei**: Code implementation, commits, PR creation  
- **patrick**: Code review, quality gates, issue filing  
- **winny**: Documentation rewrite (PLAY workflow)  
- **vicky**: Bug detection, issue filing (PLAY workflow)

## Documentation

- **CLAUDE.md**: Complete system specification with all rules  
- **agents/**: Individual agent personas and constraints  
- **commands/**: Legacy workflow commands (deprecated)  
- **PROMPTS.md**: Historical development patterns

---

*For complete details, see `CLAUDE.md`. User has ultimate authority over all workflows and rules.*