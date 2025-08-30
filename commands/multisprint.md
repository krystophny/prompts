# MULTISPRINT WORKFLOW - Continuous Sprint Cycles

## 1. TASK CONTEXT
Execute continuous WORK → PLAY → PLAN cycles per CLAUDE.md workflow system until user interruption.

## 2. TONE CONTEXT
Follow CLAUDE.md Section 2 standards with infinite loop execution patterns.

## 3. BACKGROUND DATA  
Apply CLAUDE.md Section 3 workflow transitions in continuous cycling mode.

## 4. DETAILED TASK RULES
**PREREQUISITES**: All CLAUDE.md rule sets apply
**EXECUTION**: Infinite loop of sprint cycles with autonomous continuation

## 5. EXAMPLES
Reference CLAUDE.md Section 5 for workflow patterns repeated in continuous cycles.

## 6. CONVERSATION HISTORY
Each cycle builds on previous findings per CLAUDE.md Section 6 workflow integration.

## 7. IMMEDIATE TASK
Execute infinite WORK → PLAY → PLAN loop using Task tool delegation per agent_rules.

## 8. THINKING STEP-BY-STEP
Apply CLAUDE.md Section 8 reasoning before each cycle iteration.

## 9. OUTPUT FORMATTING  
Use CLAUDE.md Section 9 structure for each completed cycle report.

## 10. PREFILLED RESPONSE
```
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

- Execute phases sequentially in infinite loop
- Complete each phase fully before proceeding
- Handle all errors and edge cases automatically
- No stopping for confirmations or clarifications
- Report progress but never pause execution
- After PLAN, IMMEDIATELY start next WORK phase
- Count sprints and report progress continuously
- Continue forever until forcibly interrupted

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