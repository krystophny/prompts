# Quality-driven Agent Development System (QADS) v3.0

Production-ready agent-based development system with three core workflows optimized for Claude Code. QADS provides automated quality gates, specialized agent roles, and batch processing for high-velocity development.

## Quick Start

**Prerequisites**: Claude Code CLI with project directory access

### Installation

```bash
# Clone repository
git clone <repository-url>
cd prompts

# Install system-wide
cp CLAUDE.md ~/.claude/CLAUDE.md
cp -r agents/ ~/.claude/
cp -r commands/ ~/.claude/

# Optional: Install shortcuts
mkdir -p ~/bin
cp bin/* ~/bin/
export PATH="$PATH:$HOME/bin"

# Verify
ls ~/.claude/CLAUDE.md ~/.claude/agents/
```

### Basic Usage

```bash
./bin/plan    # Sprint planning
./bin/work    # Implementation
./bin/play    # Sprint review/defect detection
```

### Complete Sprint Cycle

```bash
./bin/work    # Implement BACKLOG.md items
./bin/play    # Find defects (read-only audit)
./bin/plan    # Plan next sprint with findings
```

## Core Workflows

### Planning (`"plan"`) - Sprint Planning Meeting
- **Agent**: chris-architect ONLY
- **Purpose**: Post-PLAY sprint planning with review findings
- **File Permissions**: EXCLUSIVE edit access to BACKLOG.md + DESIGN.md
- **🚨 CRITICAL**: NO code changes - planning files only

### Work (`"work"`) - Sprint Implementation  
- **Agents**: max → implementer → reviewer → max
- **Types**: Code (sergei + patrick), Docs (winny + vicky)
- **Output**: Production-ready code/docs merged to main

### Play (`"play"`) - Sprint Review Meeting
- **Agents**: max → parallel audits (patrick, vicky, chris)  
- **🚨 CRITICAL**: ABSOLUTELY NO FILE EDITS - read-only only
- **Output**: GitHub issues filed, sprint completion report

## Batch Processing

```bash
"batch work"   # Process all SPRINT_BACKLOG autonomously
"batch play"   # Continuous defect detection
```

## Key Features

- **Agent Specialization**: Clear ownership and constraints
- **Ruthless Culture**: Universal distrust with brutal feedback
- **Short Sprints**: Complex tasks broken into tiny pieces
- **Quality Gates**: Mandatory review with CI completion
- **Forensic Analysis**: Repository state reconciliation
- **Infinite Review Cycles**: Fix until perfect, no compromises

## Quality Standards

**Hierarchy**: CORRECTNESS > PERFORMANCE > KISS > SRP > YAGNI > DRY > SOLID > SECURITY

### Size Constraints
- **Files**: Target <500, Hard limit <1000 lines
- **Functions**: Target <50, Hard limit <100 lines
- **Line length**: 88 characters

### Test Execution
- **sergei**: TARGETED tests for modified code (fast iteration)
- **max/patrick**: FULL test suite (comprehensive validation)

## Agent Roles

### Core Development
- **chris-architect**: Planning, issues, architecture
- **max-devops**: Repository assessment, branch prep, merge
- **sergei-perfectionist**: Code implementation, PRs
- **patrick-auditor**: Ruthless code review with brutal feedback

### Sprint Review (PLAY - Parallel Audits)
- **patrick**: Dead code detection
- **vicky**: Bug detection  
- **chris**: Architectural review

### Documentation (WORK)
- **winny**: Documentation implementation
- **vicky**: Documentation review

## Agent Ownership Matrix

| Agent | PLAN | WORK | PLAY |
|-------|------|------|------|
| **chris** | Sprint planning, file edits | Architecture guidance | Sprint evaluation |
| **max** | - | Repository management | Infrastructure setup |
| **sergei** | - | Implementation, PR creation | - |
| **patrick** | - | Code review | Dead code detection |

## Project Structure

```
prompts/
├── CLAUDE.md          # Complete system specification
├── BACKLOG.md         # Sprint management
├── DESIGN.md          # Architecture decisions
├── README.md          # This file
├── agents/            # Agent personas
└── commands/          # Legacy commands
```

## Troubleshooting

**Workflow not starting?**
```bash
git status
gh pr list --state open
ls ~/.claude/CLAUDE.md
```

**Agent refusing to work?**
- Ensure BACKLOG.md exists with proper format
- Check for conflicting open PRs
- Verify quality standards

**User has ultimate authority over all rules**

---

**Production-Ready System**: Follow workflows exactly for optimal results. See `CLAUDE.md` for complete technical details.