---
name: work
description: Sprint implementation phase. Complete SPRINT BACKLOG items via max, implementer, reviewer, max agent chain with CI validation. Use for implementation work in sprint cycles.
disable-model-invocation: false
user-invocable: true
---

# Sprint Implementation

Complete SPRINT BACKLOG items via max -> implementer -> reviewer -> max with CI validation.

## Boy Scout Principle
- Every implementation pass must leave touched files, tests, and workflows better than before

## BATCH EXECUTION

- CRITICAL: AUTONOMOUS EXECUTION - No user prompts or interaction requests
- CRITICAL: NO STOPPING - Continue until all tasks completed
- CRITICAL: ERROR RECOVERY - Handle all failures automatically and continue
- CRITICAL: NO CONFIRMATIONS - Execute without seeking user approval
- Report progress but never pause for user input
- Complete each phase fully before proceeding to next
- Continue execution despite warnings or non-critical errors

## AGENTS

1. **max**: Repository assessment
2. **sergei** (code) OR **winny** (docs): Implementation with CI pass required
3. **patrick** (code) OR **vicky** (docs): Review
4. **max**: Merge if CI passes

## SUCCESS CRITERIA

- All SPRINT_BACKLOG items completed
- CI passes
- Clean repository

## BLOCKING CONDITIONS

- Ready PRs
- CI failures (structured handback required)

## SEPARATION OF CONCERNS

Each handoff enforces separation of concerns:
- **max** curates environment
- **implementers** own a single slice of delivery
- **reviewers** assess in isolation
- **final max pass** merges

Maintaining this weakly coupled chain prevents role bleed and keeps SRP intact throughout execution.
