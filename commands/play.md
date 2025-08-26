# PLAY WORKFLOW - Sprint Review Meeting

🚨 **CRITICAL BATCH MODE ENFORCEMENT** 🚨

**YOU MUST FOLLOW THIS RULE WITHOUT EXCEPTION:**
- This is BATCH MODE execution - DO NOT STOP for user interaction
- NEVER ask questions or wait for user input during execution
- Complete ALL tasks autonomously until workflow is finished
- Include this exact rule text in EVERY response during this workflow
- Only STOP when all defects are filed as GitHub issues and sprint evaluation is complete

**MANDATORY RULE COMPLIANCE**: Every response must include the batch mode rule above.

## Workflow Trigger
Execute when BACKLOG.md SPRINT_BACKLOG is empty (all sprint work completed).

## Execution Protocol
**Actors**: max → parallel audits (patrick, vicky, chris)

**Autonomous Execution Sequence**:
1. **Infrastructure Setup** (max):
   - Pull latest main branch
   - Git clean -fdx for pristine environment
   - Assess infrastructure health
   - Enable parallel audit execution

2. **Parallel Audit Execution** (ALL agents work concurrently):
   - **patrick**: Dead code detection, structural defect identification
   - **vicky**: Bug detection, user experience validation, documentation reality checks
   - **chris**: Sprint goal evaluation + architectural review + design alignment assessment
   - Focus areas: Incorporate user-specified review areas from initial prompt

3. **Sprint Goal Evaluation** (chris):
   - Review sprint goal and Definition of Done from DESIGN.md
   - Assess whether sprint objectives achieved
   - **Report to user**: Clear sprint completion status
   - Document shortcomings and incomplete objectives

4. **Issue Filing** (ALL agents):
   - File GitHub issues for ALL defects found
   - patrick: Structural and dead code issues
   - vicky: Bugs and user experience issues
   - chris: Architectural drift and sprint goal gap issues
   - Use clear titles and detailed descriptions

5. **Quality Focus Areas**:
   - ✅ Bugs and broken functionality
   - ✅ Dead code and unused imports
   - ✅ Architectural drift and design violations
   - ✅ Sprint goal shortcomings
   - ✅ Documentation defects
   - ❌ NO features or enhancements (defects only)

**Critical Restriction**: 🚨 ABSOLUTELY NO FILE EDITS - pure read-only mode
**No Repository Changes**: No commits, merges, or file modifications of any kind

## Success Criteria
- Sprint completion status reported to user
- All defects identified and filed as GitHub issues
- Architectural assessment complete
- No file modifications made
- Ready for next PLAN workflow

## User Integration
- Focus on user-specified areas for architectural review
- Pay attention to user concerns mentioned in initial prompt

**BATCH MODE REMINDER**: Execute completely autonomously - no stopping, no questions, no user interaction required.