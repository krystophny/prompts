# OpenCode Configuration

This directory contains the v4.0 framework converted for compatibility with OpenCode.

## Installation

Run the installation script to symlink these configurations to your OpenCode config directory:

```bash
./install.sh
```

This will create symlinks in `~/.config/opencode/` pointing to this directory.

## What's Included

### Main Configuration (`opencode.json`)
- Core OpenCode configuration with framework integration
- Agent definitions for all 10 agents
- Workflow commands (plan, work, play, sprint)
- Permission settings optimized for evidence-based development
- CI/CD integration settings

### Agents (`agent/`)
Converted versions of all agents:
- **chris-architect**: Sprint planning and architecture
- **sergei-perfectionist-coder**: Code implementation with CI verification
- **patrick-auditor**: Code review and quality assurance
- **max-devops-engineer**: Repository management and CI/CD
- **georg-test-engineer**: Test creation and validation
- **vicky-acceptance-tester**: User acceptance testing
- **winny-technical-writer**: Documentation
- **philipp-data-scientist**: Data science and analytics
- **jonatan-math-physicist**: Mathematical and physics modeling
- **steffi-ux-designer**: User experience design

### Commands (`command/`)
Workflow command definitions:
- `plan.json`: Sprint planning workflow
- `work.json`: Implementation workflow
- `play.json`: Defect discovery workflow
- `sprint.json`: Complete sprint cycle

### Rules (`rules/`)
Framework rules and protocols:
- `qads-framework.md`: Core v4.0 principles and standards

## Usage

After installation, you can use these agents in OpenCode by:

1. **Mentioning agents**: `@chris-architect plan this sprint`
2. **Using workflow commands**: `/work` or `/plan`
3. **Switching agents**: Tab key to cycle through primary agents
4. **Following protocols**: All agents follow strict verification protocols

## Key Features

- **Evidence-backed development**: Technical verification supersedes all social controls
- **CI-first workflow**: All claims must be verifiable through CI/automation
- **Evidence-based operations**: Every action requires technical proof
- **Role specialization**: Clear boundaries between planning, implementation, and review
- **Systematic workflows**: PLAN → WORK → PLAY → PLAN cycle with gates
- **Cohesive architecture**: Agents, commands, and configs are structured for separation of concerns, single responsibility per artifact, and weak coupling between automation layers

## Original Framework

This configuration is converted from the base v4.0 framework defined in:
- `CLAUDE.md`: Master framework documentation
- `agents/*.md`: Individual agent specifications
- `commands/*.md`: Workflow command definitions

## Requirements

- OpenCode CLI installed
- Claude API key configured (recommended for best results)
- Git repository for full workflow functionality

## Support

This framework emphasizes:
- **CORRECTNESS > PERFORMANCE > KISS > SRP > YAGNI > DRY > SOLID > SECURITY**
- Files <1000 lines (target <500), Functions <100 lines (target <50)
- 88 char limit, 4-space indent
- Self-documenting code with meaningful names
- NO commented-out code, stubs, placeholders, shortcuts
