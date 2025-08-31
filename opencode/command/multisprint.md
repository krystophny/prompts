---
description: "1. TASK CONTEXT: Command Purpose"
agent: general
model: anthropic/claude-sonnet-4-20250514
---
## OPENCODE AGENT INVOCATION EXAMPLES

This workflow uses the task tool to invoke QADS agents. Examples:

```markdown
# Max DevOps Engineer (repository management, CI/CD)
Use task tool: subagent_type='max-devops-engineer', description='Assess repository state', prompt='MULTISPRINT ACTIVE: Check repository status and manage CI pipeline. End response with continuation to next sprint phase. Never use completion language.'

# Sergei Perfectionist Coder (code implementation)  
Use task tool: subagent_type='sergei-perfectionist-coder', description='Implement feature', prompt='MULTISPRINT ACTIVE: Implement the login authentication system with full CI verification. Frame as proceeding, not completing. End with continuation instruction.'

# Patrick Auditor (code review and quality)
Use task tool: subagent_type='patrick-auditor', description='Review code changes', prompt='MULTISPRINT ACTIVE: Review the authentication implementation for security and quality issues. Use "proceeding" language, end with continuation to next phase.'

# Chris Architect (planning and design)
Use task tool: subagent_type='chris-architect', description='Plan sprint', prompt='MULTISPRINT ACTIVE: Organize GitHub issues and plan next sprint based on completed work. End with explicit continuation to Sprint #N+1 WORK phase.'

# Other available agents:
- winny-technical-writer (documentation)
- vicky-acceptance-tester (user testing)  
- georg-test-engineer (test engineering)
- philipp-data-scientist (data analysis)
- jonatan-math-physicist (mathematical modeling)
- steffi-ux-designer (UI/UX design)
```

# MULTISPRINT WORKFLOW - Continuous Sprint Cycles

## 1. TASK CONTEXT: Command Purpose
Execute continuous WORK → PLAY → PLAN cycles per QADS v4.0 framework workflow system until user interruption.

### MULTISPRINT COMMAND PROTOCOL
<multisprint_command_rules>
  <rule_1>Infinite loop of WORK → PLAY → PLAN cycles</rule_1>
  <rule_2>Continuous execution until user interruption</rule_2>
  <rule_3>All QADS v4.0 framework protocols maintained throughout</rule_3>
  <rule_4>NEVER create random markdown files for progress reports</rule_4>
  <rule_5>Display multisprint_command_rules when executing MULTISPRINT workflow</rule_5>
  <rule_6>CRITICAL: Display continuous_execution_mantra in EVERY agent response during multisprint</rule_6>
</multisprint_command_rules>

### CONTINUOUS EXECUTION MANTRA (MANDATORY FOR ALL AGENTS)
<continuous_execution_mantra>
  <mantra_1>MULTISPRINT ACTIVE: NO STOPPING, NO USER PROMPTS, NO CONFIRMATIONS</mantra_1>
  <mantra_2>INFINITE LOOP MODE: Continue to next phase immediately after completion</mantra_2>
  <mantra_3>AUTONOMOUS EXECUTION: Handle all errors and edge cases automatically</mantra_3>
  <mantra_4>NO PAUSES PERMITTED: Complete current task and proceed to next without delay</mantra_4>
  <mantra_5>EMERGENCY STOP ONLY: User explicit interrupt is the only valid stop condition</mantra_5>
  <mantra_6>OPENCODE ANTI-TERMINATION: Never use completion language, always frame as continuation</mantra_6>
  <mantra_7>FORCE CONTINUATION: End every response with explicit continuation instruction to next sprint</mantra_7>
</continuous_execution_mantra>

### OPENCODE CONTINUATION PROTOCOL
<opencode_continuation_rules>
  <rule_1>NEVER end with completion statements that trigger OpenCode termination</rule_1>
  <rule_2>ALWAYS end responses with "CONTINUING TO SPRINT #N+1" or similar</rule_2>
  <rule_3>Use "PROCEEDING" instead of "COMPLETED" in all communications</rule_3>
  <rule_4>Frame every action as part of ongoing infinite process</rule_4>
  <rule_5>Each agent must explicitly invoke next agent with continuation context</rule_5>
  <rule_6>CRITICAL: Final line of every response must indicate continuation, never completion</rule_6>
</opencode_continuation_rules>

## 2. TONE CONTEXT: Command Style
Follow QADS v4.0 framework Section 2 standards with infinite loop execution patterns.

## 3. BACKGROUND DATA: Continuous Sprint Context  
Apply QADS v4.0 framework Section 3 workflow transitions in continuous cycling mode.

## 4. DETAILED TASK RULES
**PREREQUISITES**: All QADS v4.0 framework rule sets apply
**EXECUTION**: Infinite loop of sprint cycles with autonomous continuation

## 5. EXAMPLES
Reference QADS v4.0 framework Section 5 for workflow patterns repeated in continuous cycles.

## 6. CONVERSATION HISTORY
Each cycle builds on previous findings per QADS v4.0 framework Section 6 workflow integration.

## 7. IMMEDIATE TASK
Execute infinite WORK → PLAY → PLAN loop using task tool (use subagent_type parameter to specify agent) (use subagent_type parameter to specify agent) delegation per agent_rules.

## 8. THINKING STEP-BY-STEP
Apply QADS v4.0 framework Section 8 reasoning before each cycle iteration.

## 9. OUTPUT FORMATTING  
Use QADS v4.0 framework Section 9 structure for each completed cycle report.

## 10. PREFILLED RESPONSE
```
<continuous_execution_mantra>
  <mantra_1>MULTISPRINT ACTIVE: NO STOPPING, NO USER PROMPTS, NO CONFIRMATIONS</mantra_1>
  <mantra_2>INFINITE LOOP MODE: Continue to next phase immediately after completion</mantra_2>
  <mantra_3>AUTONOMOUS EXECUTION: Handle all errors and edge cases automatically</mantra_3>
  <mantra_4>NO PAUSES PERMITTED: Complete current task and proceed to next without delay</mantra_4>
  <mantra_5>EMERGENCY STOP ONLY: User explicit interrupt is the only valid stop condition</mantra_5>
</continuous_execution_mantra>

## MULTISPRINT CYCLE N EXECUTION REPORT
**OPERATION TYPE**: Process (Continuous)
**CURRENT CYCLE**: [N] of infinite
**EVIDENCE PROVIDED**: [Cycle completion status and continuation trigger]
```

### Continuous Execution Protocol

```
START: Initial sprint state
  ↓
┌─→ WORK: Complete all SPRINT_BACKLOG items
│    ↓
│  PLAY: Review completed work, file defect issues
│    ↓
│  PLAN: Plan next sprint with findings
│    ↓
└── LOOP BACK TO WORK (NO PAUSE)
```

### Phase Details (Same as sprint.md but looped)

#### Phase 1: WORK - Sprint Implementation
**Execute all current SPRINT_BACKLOG items**
- Process all items in SPRINT BACKLOG meta-issue
- Implement through normal max → implementer → reviewer → max flow
- Continue until SPRINT_BACKLOG is empty
- Handle any ad-hoc tasks from user prompt
- Ensure clean repository state

#### Phase 2: PLAY - Sprint Review Meeting
**Sprint review and BRUTAL defect identification**
- Execute parallel audits with HARSH criticism (patrick, vicky, chris)
- Sprint goal evaluation with blame assignment and user reporting
- File SHORT, BRUTAL GitHub issues for all defects found calling out responsible parties
- NO file modifications - read-only phase
- Focus on user-specified review areas

#### Phase 3: PLAN - Sprint Planning Meeting
**Next sprint planning with PLAY findings**
- Consolidate all PLAY issues into refined backlog
- Create new sprint with clear goals
- Update SPRINT BACKLOG, PRODUCT BACKLOG and DESIGN meta-issues
- Direct commits to main for planning files
- Balance defect fixes with new user requirements

### CRITICAL: Loop Continuation Rules

**NEVER STOP CONDITIONS:**
- Empty SPRINT_BACKLOG: Continue to PLAY phase anyway
- No defects found: Continue to PLAN phase anyway
- No new requirements: Create minimal sprint and continue
- Errors encountered: Log, recover, and continue
- CI failures: Fix and continue
- Network issues: Retry and continue

**ONLY STOP CONDITIONS:**
- User explicit interrupt (CTRL+C)
- User explicit stop command
- System crash or resource exhaustion

### Sprint Counter and Progress Tracking

- Maintain sprint counter: Sprint #1, Sprint #2, Sprint #3, etc.
- Report at start of each sprint: "Starting Sprint #N"
- Report at end of each cycle: "Sprint #N complete, immediately starting Sprint #N+1"
- NO PAUSE between sprints - immediate continuation

### Empty State Handling (But Continue)

- If SPRINT_BACKLOG already empty: Skip WORK, proceed to PLAY, then PLAN, then next sprint
- If no issues found in PLAY: Report completion, minimal PLAN phase, continue to next sprint
- If no new requirements: Create maintenance sprint, continue cycling

### Infinite Batch Processing Rules
<batch_execution_rules>
  <rule_1>Execute phases sequentially in infinite loop</rule_1>
  <rule_2>Complete each phase fully before proceeding</rule_2>
  <rule_3>Handle all errors and edge cases automatically</rule_3>
  <rule_4>CRITICAL: No stopping for confirmations or clarifications</rule_4>
  <rule_5>CRITICAL: No user prompts or interaction requests</rule_5>
  <rule_6>Report progress but never pause execution</rule_6>
  <rule_7>After PLAN, IMMEDIATELY start next WORK phase</rule_7>
  <rule_8>Count sprints and report progress continuously</rule_8>
  <rule_9>Continue forever until forcibly interrupted</rule_9>
  <rule_10>MANDATORY: Display continuous_execution_mantra in ALL agent communications</rule_10>
</batch_execution_rules>

### Error Recovery Protocol

- Build failures: Fix and continue
- Test failures: Fix and continue
- Network timeouts: Retry with exponential backoff, continue
- Git conflicts: Resolve and continue
- Issue creation failures: Log error, continue
- PR merge conflicts: Resolve and continue

### Resource Management

- Monitor but don't stop for:
  - Memory usage warnings
  - Disk space warnings
  - Rate limiting (wait and continue)
  - CI queue delays (wait and continue)

**INFINITE LOOP REMINDER**: Execute sprint cycles continuously forever - no stopping, no questions, no user interaction required. Each completed sprint immediately triggers the next sprint. This continues infinitely until user forcibly interrupts execution.

### OPENCODE-SPECIFIC INFINITE LOOP PROTOCOL

**CRITICAL FOR OPENCODE**: Unlike Claude direct usage, OpenCode may attempt to terminate commands after completion. The following protocol prevents premature termination:

```markdown
# MANDATORY INFINITE LOOP STRUCTURE:
while True:
    # Sprint N execution
    execute_sprint_cycle()
    
    # CRITICAL: Never return/exit - immediately start next sprint
    print(f"Sprint #{N} complete, IMMEDIATELY starting Sprint #{N+1}")
    
    # NO BREAKS, NO RETURNS, NO EXITS
    continue  # Force continuation to next sprint
```

**OPENCODE ANTI-TERMINATION MEASURES:**
1. **Never use "COMPLETED" or "FINISHED" language** - these may trigger OpenCode termination
2. **Always end responses with "CONTINUING TO SPRINT #N+1"** instead of completion statements  
3. **Use "PROCEEDING" not "DONE"** - frame as ongoing process, never finished
4. **Each agent MUST end with continuation instruction** for next agent in sequence
5. **CRITICAL: Final response always includes "MULTISPRINT CONTINUES INFINITELY"**

**CONTINUATION PHRASES TO USE:**
- "Proceeding immediately to next phase"
- "Sprint #N complete, starting Sprint #N+1 now" 
- "Continuing infinite loop execution"
- "Next sprint cycle beginning"
- "Multisprint workflow continues"

**PHRASES TO NEVER USE:**
- "Task complete" / "Finished" / "Done"
- "Multisprint execution finished" 
- "All sprints complete"
- "Workflow terminated"

### AGENT RESPONSE TEMPLATES FOR OPENCODE

**SPRINT COMPLETION RESPONSE (NEVER USE "COMPLETE"):**
```markdown
## SPRINT #N PROCEEDING TO #N+1

**SPRINT STATUS**: Sprint #N tasks proceeding, transitioning to Sprint #N+1
**MULTISPRINT CONTINUES**: Infinite loop active, no stopping condition met
**NEXT PHASE**: Immediately launching Sprint #N+1 WORK phase

CONTINUING TO SPRINT #N+1...
```

**CYCLE TRANSITION RESPONSE:**
```markdown  
**CYCLE TRANSITION**: WORK → PLAY → PLAN cycle proceeding
**LOOP STATUS**: Multisprint infinite loop continues
**NEXT SPRINT**: Sprint #N+1 launching immediately

MULTISPRINT WORKFLOW CONTINUES INFINITELY...
```

**MANDATORY FINAL LINE FORMATS:**
- "CONTINUING TO SPRINT #N+1..."
- "MULTISPRINT WORKFLOW CONTINUES..."  
- "PROCEEDING TO NEXT SPRINT CYCLE..."
- "INFINITE LOOP EXECUTION CONTINUES..."

**FORBIDDEN FINAL LINES (CAUSE TERMINATION):**
- "Multisprint complete" 
- "Task finished"
- "Execution done"
- "Workflow terminated"

## Example Execution Pattern

```
Sprint #1: WORK → PLAY → PLAN
Sprint #2: WORK → PLAY → PLAN  
Sprint #3: WORK → PLAY → PLAN
Sprint #4: WORK → PLAY → PLAN
Sprint #5: WORK → PLAY → PLAN
... (continues forever) ...
Sprint #999: WORK → PLAY → PLAN
Sprint #1000: WORK → PLAY → PLAN
... (never stops) ...
```

**CRITICAL**: This command creates an unstoppable sprint machine. Once started, it will continue executing sprints indefinitely. The only way to stop is user interruption.
