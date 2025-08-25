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

# Install workflow shortcuts (optional - for direct execution)
mkdir -p ~/bin
cp bin/* ~/bin/
export PATH="$PATH:$HOME/bin"  # Add to .bashrc/.zshrc for permanent use

# Verify installation
ls ~/.claude/CLAUDE.md ~/.claude/agents/ ~/.claude/commands/
ls ~/bin/plan ~/bin/work ~/bin/play

# Test workflow shortcuts (optional)
./test-shortcuts.sh
```

### 2. Basic Usage

```bash
# Start any new project with planning
./bin/plan

# Implement existing issues
./bin/work

# Find and fix defects  
./bin/play
```

### 3. Complete Example Workflow

```bash
# Planning phase - create issues and architecture
./bin/plan
# Result: GitHub issues created, BACKLOG.md updated with priorities

# Implementation phase - work through SPRINT_BACKLOG items  
./bin/work
# Result: max prepares branch → sergei implements → patrick reviews → max merges

# Quality audit phase - find remaining defects
./bin/play 
# Result: Documentation updated, defects filed as new issues
```

### Workflow Shortcuts

The workflow shortcuts are executable shell scripts that validate your environment and guide you through proper workflow execution:

- **`./bin/plan`**: Validates git repository, guides planning workflow activation
- **`./bin/work`**: Validates BACKLOG.md exists, guides implementation workflow 
- **`./bin/play`**: Validates environment, warns if SPRINT_BACKLOG items remain, guides quality audit

Each script performs environment checks and provides clear next steps for invoking the corresponding workflow through Claude Code.

Use `./test-shortcuts.sh` to validate all shortcuts are working correctly and match documented behavior.

## Core Workflows

### Planning Workflow (`"plan"`)
- **Agent**: chris-architect
- **Purpose**: Create GitHub issues and maintain BACKLOG.md with PRODUCT_BACKLOG and SPRINT_BACKLOG
- **Output**: EPIC-organized issues ready for implementation

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
- **Output**: Comprehensive audit results and updated SPRINT_BACKLOG

```bash
"play"
# Process: Documentation rewrite → Parallel defect audits → Issue filing
```

## Batch Processing

```bash
"batch work"   # Process all BACKLOG.md SPRINT_BACKLOG items autonomously
"batch play"   # Continuous defect detection until no issues found
```

## Key Features

- **Agent Specialization**: Each agent has clear ownership and constraints
- **Hierarchical Planning**: PRODUCT_BACKLOG (high-level features) → SPRINT_BACKLOG (detailed GitHub issues under EPICs)
- **State Management**: SPRINT_BACKLOG → DOING → delete completed, PRODUCT_BACKLOG → DONE when EPICs complete
- **Quality Gates**: Mandatory code review and CI completion
- **Batch Processing**: Autonomous execution for high-velocity workflows
- **Forensic Analysis**: Repository state reconciliation and branch management
- **Infinite Review Cycles**: Fix defects until perfect, no compromises
- **Test Execution Division**: sergei runs targeted tests, max runs full suite

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

### Test Execution Ownership
- **sergei-perfectionist**: Runs TARGETED TESTS ONLY for code being modified (fast iteration)
- **georg-test-engineer**: Creates tests, runs TARGETED TESTS ONLY for verification
- **max-devops**: Runs FULL TEST SUITE before merge (EXCLUSIVE responsibility)
- **Division Purpose**: Enables fast development while ensuring comprehensive validation

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
├── BACKLOG.md         # SPRINT_BACKLOG → DOING → delete, PRODUCT_BACKLOG → DONE
├── DESIGN.md          # Architecture, technical decisions, ADRs  
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
- Review BACKLOG.md SPRINT_BACKLOG section not empty

### Getting Help

1. **Read CLAUDE.md**: Complete specification with all rules
2. **Check agents/**: Individual agent capabilities and constraints  
3. **Review BACKLOG.md**: Current project state and priorities
4. **User override**: User has ultimate authority over all rules

---

**Production-Ready System**: QADS v3.0 is designed for high-velocity development with uncompromising quality standards. Follow the workflows exactly for optimal results.

*For complete technical details, see `CLAUDE.md`. User has ultimate authority over all workflows and rules.*