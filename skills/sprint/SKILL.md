---
name: sprint
description: Complete sprint cycle executing WORK, PLAY, PLAN phases. Autonomous batch execution with CI validation. Use to run a full sprint workflow.
disable-model-invocation: false
user-invocable: true
---

# Complete Sprint Cycle

Execute full WORK -> PLAY -> PLAN cycle per CLAUDE.md workflow system.

## Boy Scout Principle
- Each sprint cycle must leave every phase cleaner by fixing nearby issues immediately

## BATCH EXECUTION

- SPRINT BATCH MODE: NO USER PROMPTS, NO CONFIRMATIONS, NO STOPPING
- AUTONOMOUS EXECUTION: Complete all three phases without pause
- ERROR RECOVERY: Handle failures automatically and continue
- CONTINUOUS FLOW: WORK -> PLAY -> PLAN without interruption

## PREREQUISITES

All CLAUDE.md rule sets apply throughout.

## IMMEDIATE TASK

Execute WORK -> PLAY -> PLAN sequence:

1. **WORK**: Process SPRINT_BACKLOG via agents per workflow_rules
2. **PLAY**: Launch defect discovery via Task tool
3. **PLAN**: Execute chris-architect planning via Task tool

Keep handoffs crisp: each phase owns a single responsibility and consumes only the artifacts published by the prior phase to preserve separation of concerns and weak coupling across the sprint loop.

## OUTPUT FORMAT

```
## SPRINT CYCLE EXECUTION REPORT
**OPERATION TYPE**: Process
**WORKFLOW PHASES**: WORK -> PLAY -> PLAN
**EVIDENCE PROVIDED**: [CI URLs, GitHub issue summaries, completion status]
```
