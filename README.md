# Quality-driven Agent Development System (QADS) v3.0

A production-ready agent-based development system with three core workflows optimized for Claude Code. QADS provides automated quality gates, specialized agent roles, and batch processing capabilities for high-velocity development.

## Quick Start

**Prerequisites**: Claude Code CLI with project directory access

### 1. Installation

```bash
# Clone the repository
git clone <repository-url>
cd prompts

# Install system-wide configuration  
cp CLAUDE.md ~/.claude/CLAUDE.md
cp -r agents/ ~/.claude/
cp -r commands/ ~/.claude/

# Verify installation
ls ~/.claude/CLAUDE.md ~/.claude/agents/ ~/.claude/commands/
```

### 2. Basic Usage

```bash
# Start any new project with planning
"plan"

# Implement existing issues
"work" 

# Find and fix defects  
"play"
```

### 3. Complete Example Workflow

```bash
# Planning phase - create issues and architecture
"plan"
# Result: GitHub issues created, BACKLOG.md updated with priorities

# Implementation phase - work through TODO items  
"work"
# Result: max prepares branch → sergei implements → patrick reviews → max merges

# Quality audit phase - find remaining defects
"play" 
# Result: Documentation updated, defects filed as new issues
```

## Core Workflows

### Planning Workflow (`"plan"`)
- **Agent**: chris-architect
- **Purpose**: Create GitHub issues and maintain BACKLOG.md priorities
- **Output**: Ordered TODO items ready for implementation

```bash
"plan"
# Creates: GitHub issues, BACKLOG.md priorities, DESIGN.md updates
```

### Work Workflow (`"work"`)
- **Agents**: max → sergei → patrick → max  
- **Purpose**: Implement features and fix bugs through quality-gated process
- **Output**: Production-ready code merged to main

```bash
"work"
# Process: Repository assessment → Implementation → Code review → Merge
```

### Play Workflow (`"play"`)  
- **Agents**: max → winny → patrick/vicky → chris
- **Purpose**: Find defects, update documentation, file new issues
- **Output**: Comprehensive audit results and updated TODO backlog

```bash
"play"
# Process: Documentation rewrite → Parallel defect audits → Issue filing
```

## Batch Processing

```bash
"batch work"   # Process all BACKLOG.md TODO items autonomously
"batch play"   # Continuous defect detection until no issues found
```

## Key Features

- **Agent Specialization**: Each agent has clear ownership and constraints
- **State Management**: BACKLOG.md tracks TODO → DOING → DONE progression  
- **Quality Gates**: Mandatory code review and CI completion
- **Batch Processing**: Autonomous execution for high-velocity workflows
- **Forensic Analysis**: Repository state reconciliation and branch management
- **Infinite Review Cycles**: Fix defects until perfect, no compromises

## Quality Standards

**Code Quality Hierarchy**: CORRECTNESS > PERFORMANCE > KISS > SRP > YAGNI > DRY > SOLID > SECURITY

### Size Constraints
- **Files**: Target <500 lines, Hard limit <1000 lines
- **Functions**: Target <50 lines, Hard limit <100 lines  
- **Line length**: 88 characters (90 for Fortran with ` &`)

### Git Workflow
- **Commits**: Conventional format, specific file staging only
- **Branching**: Issue-based branches (`<type>-<number>`)
- **PRs**: Non-draft only, ready for immediate review

### Testing Requirements  
- **TDD**: RED/GREEN/REFACTOR cycles mandatory
- **Coverage**: Meaningful tests, not just coverage metrics
- **Validation**: Targeted tests for modified code only

## Agent Roles

### Core Development Agents
- **chris-architect**: Planning, GitHub issues, BACKLOG.md priorities, architecture
- **max-devops**: Repository assessment, forensic analysis, branch preparation, final merge  
- **sergei-perfectionist**: Code implementation, commits, PR creation, optimization
- **patrick-auditor**: Code review with handback, quality gates, issue triage

### Quality Audit Agents (PLAY workflow)
- **winny-technical-writer**: Documentation consolidation and rewrite
- **vicky-acceptance-tester**: Bug detection and GitHub issue filing
- **Additional specialists**: georg (testing), jonatan (math/physics), philipp (data), steffi (UX)

## Project Structure

```
prompts/
├── CLAUDE.md          # Complete system specification (MANDATORY)
├── BACKLOG.md         # TODO → DOING → DONE state management
├── README.md          # This file - onboarding and overview
├── PROMPTS.md         # Historical development patterns
├── agents/            # Individual agent personas and constraints
│   ├── chris-architect.md
│   ├── max-devops-engineer.md
│   ├── sergei-perfectionist-coder.md
│   └── ...
└── commands/          # Legacy workflow commands (deprecated)
    ├── README.md      # Migration guide to modern workflows
    └── ...
```

## Troubleshooting

### Common Issues

**Q: Workflow not starting properly?**
```bash
# Check repository state
git status
gh pr list --state open

# Verify CLAUDE.md installation
ls ~/.claude/CLAUDE.md
```

**Q: Agent refusing to work?**  
- Ensure BACKLOG.md exists with proper format
- Check for conflicting open PRs (max-devops will resolve)
- Verify all files follow quality standards

**Q: Batch mode stopping unexpectedly?**
- Check for CI failures blocking merge
- Ensure no manual intervention required
- Review BACKLOG.md TODO section not empty

### Getting Help

1. **Read CLAUDE.md**: Complete specification with all rules
2. **Check agents/**: Individual agent capabilities and constraints  
3. **Review BACKLOG.md**: Current project state and priorities
4. **User override**: User has ultimate authority over all rules

---

**Production-Ready System**: QADS v3.0 is designed for high-velocity development with uncompromising quality standards. Follow the workflows exactly for optimal results.

*For complete technical details, see `CLAUDE.md`. User has ultimate authority over all workflows and rules.*