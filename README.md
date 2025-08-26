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

### 3. Complete Sprint Cycle Example

```bash
# Sprint implementation - work through current BACKLOG.md items  
./bin/work
# Result: max prepares → implementer codes → reviewer validates → max merges

# Sprint review meeting - parallel defect audits (no code changes)
./bin/play 
# Result: patrick/vicky/chris file defect issues, no repository modifications

# Sprint planning meeting - consolidate findings into next sprint
./bin/plan
# Result: PLAY issues consolidated → next sprint BACKLOG.md → DESIGN.md updated
```

### Workflow Shortcuts

The workflow shortcuts are executable shell scripts that validate your environment and guide you through proper workflow execution:

- **`./bin/plan`**: Validates git repository, guides planning workflow activation
- **`./bin/work`**: Validates BACKLOG.md exists, guides implementation workflow 
- **`./bin/play`**: Validates environment, warns if SPRINT_BACKLOG items remain, guides quality audit

Each script performs environment checks and provides clear next steps for invoking the corresponding workflow through Claude Code.

Use `./test-shortcuts.sh` to validate all shortcuts are working correctly and match documented behavior.

## Core Workflows

### Planning Workflow (`"plan"`) - Sprint Planning Meeting
- **Agent**: chris-architect ONLY
- **Purpose**: Post-PLAY sprint planning meeting incorporating review findings
- **Input**: PLAY findings + user requirements + existing BACKLOG.md EPICs
- **File Permissions**: EXCLUSIVE edit access to BACKLOG.md and DESIGN.md, commits directly to main
- **🚨 CRITICAL**: NO code changes - planning files only
- **Output**: Next sprint plan, sprint goal, Definition of Done, refined issues

```bash
"plan"
# Sprint Planning: PLAY findings → Issue consolidation → BACKLOG.md + DESIGN.md edits → Direct commit to main
```

### Work Workflow (`"work"`) - Sprint Implementation
- **Agents**: max → implementer → reviewer → max  
- **Purpose**: Implement sprint backlog items with user ad-hoc tasks integration
- **Issue Types**: Code issues (sergei + patrick), Documentation issues (winny + vicky)
- **User Integration**: Incorporates ad-hoc tasks and implementation hints
- **Output**: Production-ready code/documentation merged to main

```bash
"work"
# Implementation: Repository assessment → Implementation + user hints → Review → Merge
```

### Play Workflow (`"play"`) - Sprint Review Meeting
- **Agents**: max → parallel audits (patrick, vicky, chris)
- **Purpose**: Sprint review meeting - evaluate sprint goals and detect defects
- **chris Special Role**: Evaluates sprint goal completion and reports to user
- **User Integration**: Reviews focus on user-specified areas of concern
- **🚨 CRITICAL**: ABSOLUTELY NO FILE EDITS - pure read-only issue identification
- **Output**: GitHub issues filed, sprint completion report to user

```bash
"play"
# Sprint Review: Sprint goal evaluation → Parallel defect audits → Issue filing → NO file modifications
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

### Sprint Review Agents (PLAY workflow - Parallel Audits)
- **patrick-auditor**: Dead code detection and structural defect filing
- **vicky-acceptance-tester**: Bug detection and user experience issue filing  
- **chris-architect**: Architectural review and design alignment issue filing

### Documentation Implementation Agent (WORK workflow)
- **winny-technical-writer**: Documentation implementation and updates (documentation issues only)
- **vicky-acceptance-tester**: Documentation review and validation

### Additional Specialists (available for both workflows)
- **georg-test-engineer**: Testing strategy and implementation
- **jonatan-math-physicist**: Mathematical and physics code translation
- **philipp-data-scientist**: Data analysis, visualization, statistical modeling
- **steffi-ux-designer**: User interface design and user experience optimization

## Agent Ownership Matrix

Clear responsibilities across all three workflow phases:

| Agent | PLAN | WORK | PLAY |
|-------|------|------|------|
| **chris** | Sprint planning, file edits, commits to main | Architecture guidance | Sprint evaluation, architectural review |
| **max** | - | Repository management, merges | Infrastructure setup |
| **sergei** | - | Code implementation, PR creation | - |
| **winny** | - | Doc implementation, PR creation | - |
| **patrick** | - | Code review | Dead code detection |
| **vicky** | - | Doc review | Bug detection |

### Key Distinctions:
- **PLAN**: Only chris edits files (BACKLOG.md + DESIGN.md), commits directly to main
- **WORK**: Standard PR workflow with branch protection for all implementations
- **PLAY**: NO file edits - pure read-only issue identification phase

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