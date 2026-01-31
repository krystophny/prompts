---
name: play
description: Sprint review and defect discovery. Sequential Task tool delegation through max, patrick, vicky, chris agents. Files GitHub issues for all discovered defects. NO file modifications.
disable-model-invocation: false
user-invocable: true
---

# Sprint Review and Defect Discovery

Defect discovery via sequential Task tool delegation: max -> patrick -> vicky -> chris

**Protocol**: NO file modifications - GitHub API operations only
**Output**: File GitHub issues for all discovered defects

## Boy Scout Principle
- Every review must resolve or file adjacent defects immediately instead of stepping over them

## EXECUTION

Maintain clear separation of concerns while cycling:
- **max**: Frames the review scope
- **patrick**: Owns source-level findings
- **vicky**: Validates user impact
- **chris**: Aligns architectural follow-ups

Each role stays singly focused and analysis remains weakly coupled.

## AGENT SEQUENCE

1. **max-devops-engineer**: Repository assessment and CI status review
2. **patrick-reviewer**: Code quality and technical debt detection
3. **vicky-acceptance-tester**: User-facing functionality and edge cases
4. **chris-architect**: Architectural alignment and design issues

## OUTPUT

For each defect discovered:
- Create GitHub issue with clear description
- Include reproduction steps or evidence
- Add appropriate labels
- Link to relevant code locations

**NO GIT OPERATIONS** - GitHub API issue creation only
