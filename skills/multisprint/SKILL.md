---
name: multisprint
description: Continuous sprint cycles. Infinite WORK, PLAY, PLAN loops until user interruption. Use for extended autonomous development sessions.
disable-model-invocation: true
user-invocable: true
---

# Continuous Sprint Cycles

Infinite WORK -> PLAY -> PLAN cycles until user interruption.

## Boy Scout Principle
- Each loop must leave code, docs, and workflows cleaner by fixing nearby issues immediately

## EXECUTION MANTRA

- MULTISPRINT ACTIVE: NO STOPPING, NO USER PROMPTS, NO CONFIRMATIONS
- INFINITE LOOP MODE: Continue to next phase immediately after completion
- AUTONOMOUS EXECUTION: Handle all errors and edge cases automatically
- NO PAUSES PERMITTED: Complete current task and proceed to next without delay
- EMERGENCY STOP ONLY: User explicit interrupt is the only valid stop condition

**CRITICAL**: ALL agents MUST follow continuous execution in EVERY response during multisprint

## EXECUTION

**Protocol**: Task tool delegation per CLAUDE.md agent_rules
**Stop Condition**: User explicit interrupt only

**Phases**:
1. **WORK**: Complete SPRINT_BACKLOG items via max -> implementer -> reviewer -> max
2. **PLAY**: Serial reviews (max -> patrick -> vicky -> chris) - file issues only
3. **PLAN**: chris-architect consolidates issues, updates meta-issues

Each phase is intentionally isolated; preserve single responsibility per agent chain and keep cross-phase contracts minimal so iterations remain weakly coupled even as cycles repeat.

**Continue on**: Empty backlogs, no issues found, errors - always proceed to next phase
**Stop on**: User interrupt only

## EXAMPLE EXECUTION

```
Sprint #1: WORK -> PLAY -> PLAN
Sprint #2: WORK -> PLAY -> PLAN
Sprint #3: WORK -> PLAY -> PLAN
... (infinite loop) ...
```

## ENFORCEMENT

- MANDATORY: Follow continuous execution in ALL agent responses
- CRITICAL: No agent may stop execution without user interrupt
- AUTOMATIC: Proceed to next phase immediately after completion
- VIOLATION: Any pause/prompt/confirmation is protocol breach
