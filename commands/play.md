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
   - **🚨 RUN FULL TEST SUITE** - MANDATORY FIRST ACTION
   - File GitHub issues for ALL test failures with exact errors
   - Assess infrastructure health
   - Enable parallel audit execution

2. **Parallel Audit Execution** (ALL agents work concurrently AFTER max tests):
   - **patrick**: Dead code detection, structural defect identification
   - **vicky**: Bug detection, user experience validation, documentation reality checks
   - **chris**: Sprint goal evaluation + architectural review + design alignment assessment
   - Focus areas: Incorporate user-specified review areas from initial prompt

3. **Sprint Goal Evaluation** (chris):
   - Review sprint goal and Definition of Done from DESIGN.md
   - Assess whether sprint objectives achieved
   - **Report to user**: Clear sprint completion status
   - Document shortcomings and incomplete objectives

4. **BRUTAL Issue Filing** (ALL agents):
   - File SHORT, HARSH GitHub issues for ALL defects found
   - patrick: Structural and dead code issues with brutal criticism of responsible parties
   - vicky: Bugs and user experience issues calling out incompetent implementations  
   - chris: Architectural drift and sprint goal gap issues with harsh blame assignments
   - Use SHORT titles and BRUTAL descriptions: "Fix this garbage", "Stop breaking X", "Implement Y properly"

5. **Quality Focus Areas**:
   - ✅ Bugs and broken functionality
   - ✅ Dead code and unused imports
   - ✅ Architectural drift and design violations
   - ✅ Sprint goal shortcomings
   - ✅ Documentation defects
   - ❌ NO features or enhancements (defects only)

6. **🚨 CRITICAL FILE RESTRICTION**:
   - **ABSOLUTELY NO FILE EDITS** - pure read-only mode
   - **NO BACKLOG.md modifications** - no status updates, no additions
   - **NO DESIGN.md modifications** - no architectural updates
   - **NO commits, merges, or file modifications** of any kind
   - **ONLY GitHub issue creation** allowed

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