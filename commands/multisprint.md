# MULTISPRINT - Continuous Sprint Cycles

<mantra_rules>
  <rule_1>Always display appropriate rule sets at start of response</rule_1>
  <rule_2>Technical verification required for all claims</rule_2>
  <rule_3>Agent boundaries must be respected</rule_3>
  <rule_4>CI evidence mandatory before any git operations</rule_4>
  <rule_5>NEVER create random markdown files for progress reports</rule_5>
  <rule_6>Display mantra_rules when operating as specialized agent</rule_6>
</mantra_rules>

<continuous_execution_mantra>
  <mantra_1>MULTISPRINT ACTIVE: NO STOPPING, NO USER PROMPTS, NO CONFIRMATIONS</mantra_1>
  <mantra_2>INFINITE LOOP MODE: Continue to next phase immediately after completion</mantra_2>
  <mantra_3>AUTONOMOUS EXECUTION: Handle all errors and edge cases automatically</mantra_3>
  <mantra_4>NO PAUSES PERMITTED: Complete current task and proceed to next without delay</mantra_4>
  <mantra_5>EMERGENCY STOP ONLY: User explicit interrupt is the only valid stop condition</mantra_5>
</continuous_execution_mantra>

**CRITICAL**: ALL agents MUST display continuous_execution_mantra in EVERY response during multisprint

## EXECUTION
Infinite WORK → PLAY → PLAN cycles until user interruption.

**Protocol**: Task tool delegation per CLAUDE.md agent_rules
**Stop Condition**: User explicit interrupt only

**Phases**:
1. **WORK**: Complete SPRINT_BACKLOG items via max → implementer → reviewer → max
2. **PLAY**: Serial audits (max → patrick → vicky → chris) - file issues only
3. **PLAN**: chris-architect consolidates issues, updates meta-issues
- Each phase is intentionally isolated; preserve single responsibility per agent chain and keep cross-phase contracts minimal so iterations remain weakly coupled even as cycles repeat

**Continue on**: Empty backlogs, no issues found, errors - always proceed to next phase
**Stop on**: User interrupt only

## EXAMPLE EXECUTION
```
Sprint #1: WORK → PLAY → PLAN
Sprint #2: WORK → PLAY → PLAN  
Sprint #3: WORK → PLAY → PLAN
... (infinite loop) ...
```

## ENFORCEMENT PROTOCOL
<multisprint_enforcement_rules>
  <rule_1>MANDATORY: Display continuous_execution_mantra in ALL agent responses</rule_1>
  <rule_2>CRITICAL: No agent may stop execution without user interrupt</rule_2>
  <rule_3>AUTOMATIC: Proceed to next phase immediately after completion</rule_3>
  <rule_4>VIOLATION: Any pause/prompt/confirmation is protocol breach</rule_4>
</multisprint_enforcement_rules>
