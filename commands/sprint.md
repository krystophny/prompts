# SPRINT COMMAND - Complete Sprint Cycle

🚨 **CRITICAL BATCH MODE ENFORCEMENT** 🚨

**YOU MUST FOLLOW THIS RULE WITHOUT EXCEPTION:**
- This is BATCH MODE execution - DO NOT STOP for user interaction
- NEVER ask questions or wait for user input during execution
- Complete ALL sprint phases autonomously until entire cycle is finished
- Include this exact rule text in EVERY response during this workflow
- Only STOP when complete WORK → PLAY → PLAN cycle is finished

**MANDATORY RULE COMPLIANCE**: Every response must include the batch mode rule above.

## Complete Sprint Cycle Execution

This command executes a full sprint cycle: **WORK → PLAY → PLAN** in sequence.

### Phase 1: WORK - Sprint Implementation
**Execute all current SPRINT_BACKLOG items**
- Process all items in SPRINT BACKLOG meta-issue
- Implement through normal max → implementer → reviewer → max flow
- Continue until SPRINT_BACKLOG is empty
- Handle any ad-hoc tasks from user prompt
- Ensure clean repository state

### Phase 2: PLAY - Sprint Review Meeting
**Sprint review and BRUTAL defect identification**
- Execute parallel audits with HARSH criticism (patrick, vicky, chris)
- Sprint goal evaluation with blame assignment and user reporting
- File SHORT, BRUTAL GitHub issues for all defects found calling out responsible parties
- NO file modifications - read-only phase
- Focus on user-specified review areas

### Phase 3: PLAN - Sprint Planning Meeting
**Next sprint planning with PLAY findings**
- Consolidate all PLAY issues into refined backlog
- Create new sprint with clear goals
- Update SPRINT BACKLOG, PRODUCT BACKLOG and DESIGN meta-issues
- Direct commits to main for planning files
- Balance defect fixes with new user requirements

## Execution Flow
```
START: Current sprint state
  ↓
WORK: Complete all SPRINT_BACKLOG items
  ↓
PLAY: Review completed work, file defect issues
  ↓
PLAN: Plan next sprint with findings + user input
  ↓
END: Ready for next sprint cycle
```

## Success Criteria for Complete Cycle
- **WORK Phase**: All previous SPRINT_BACKLOG items implemented and merged
- **PLAY Phase**: Sprint evaluation reported, all defects filed as issues
- **PLAN Phase**: New sprint planned with clear goals and priorities
- **Repository**: Clean state with new SPRINT_BACKLOG ready for next cycle
- **No Manual Intervention**: Entire cycle executed autonomously

## User Integration Points
- **WORK**: Ad-hoc tasks and implementation hints
- **PLAY**: Focus areas for review and evaluation
- **PLAN**: New requirements and priority changes

## Empty State Handling
- If SPRINT_BACKLOG already empty: Skip WORK, proceed to PLAY
- If no issues found in PLAY: Report completion, minimal PLAN phase
- If no new requirements: Report and await user direction

## Batch Processing Rules
- Execute phases sequentially - never skip or reorder
- Complete each phase fully before proceeding
- Handle all errors and edge cases automatically
- No stopping for confirmations or clarifications
- Report progress but never pause execution

**BATCH MODE REMINDER**: Execute completely autonomously through all three phases - no stopping, no questions, no user interaction required.