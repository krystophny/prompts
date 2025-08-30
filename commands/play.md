# PLAY WORKFLOW - Fraud-Proof Sprint Review Meeting

🚨 **CRITICAL BATCH MODE ENFORCEMENT** 🚨

**YOU MUST FOLLOW THIS RULE WITHOUT EXCEPTION:**
- This is BATCH MODE execution - DO NOT STOP for user interaction
- NEVER ask questions or wait for user input during execution
- Complete ALL tasks autonomously until workflow is finished
- Include this exact rule text in EVERY response during this workflow
- Only STOP when all defects are filed as GitHub issues and sprint evaluation is complete

**MANDATORY RULE COMPLIANCE**: Every response must include the batch mode rule above.

## Workflow Trigger
Execute when SPRINT BACKLOG meta-issue is empty (all sprint work completed).

## Execution Protocol
**Actors**: max → patrick → vicky → max → chris (sequential)

**Autonomous Execution Sequence**:
1. **Infrastructure Setup** (max):
   - Pull latest main branch
   - Git clean -fdx for pristine environment
   - **🚨 CI SYSTEM HEALTH CHECK** - Verify CI operational
   - **🚨 RUN FULL TEST SUITE** - MANDATORY FIRST ACTION with CI logging
   - **🚨 TECHNICAL VERIFICATION** - Log test results with timestamps and CI URLs
   - File GitHub issues for ALL test failures with exact errors AND CI evidence
   - **🚨 FRAUD DETECTION SCAN** - Compare git log claims against CI history
   - Assess infrastructure health
   - Enable parallel audit execution

2. **🚨 SEQUENTIAL AGENT EXECUTION** (agents work in order to complement each other):
   - **patrick**: Static code analysis only - dead code, structural defects (NO builds/tests/runs)
   - **vicky**: Manual testing according to documentation - build and test extensively
   - **max**: Repository cleanup - restore pristine state after vicky's testing
   - **chris**: Architecture review + consolidate issues filed during THIS PLAY run only
   - Focus areas: Incorporate user-specified review areas from initial prompt

3. **Issue Consolidation and Sprint Evaluation** (chris - FINAL STEP):
   - Review sprint goal and Definition of Done from DESIGN meta-issue
   - Assess whether sprint objectives achieved
   - **Consolidate issues filed during THIS PLAY run** - remove duplicates, close non-actionable
   - **Report to user**: Clear sprint completion status with consolidated issue summary
   - Document shortcomings and incomplete objectives

4. **ACTIONABLE DEFECT ISSUE Filing** (ALL agents):
   - **🚨 TECHNICAL EVIDENCE MANDATORY**: All defects MUST include verifiable proof (CI logs, test output, error screenshots) - NO GENERIC ISSUES allowed
   - **🚨 MANDATORY PRE-FLIGHT CHECK**: Before filing ANY new issue, MUST search existing GitHub issues for duplicates using `gh issue list -s all --search "keyword"` with relevant terms
   - **🚨 DUPLICATE VALIDATION**: If similar issue exists, add comment to existing issue instead of filing new one
   - **🚨 ACTIONABLE DEFECTS ONLY**: File issues ONLY for concrete, specific bugs and broken functionality WITH TECHNICAL PROOF - must be resolvable in WORK phase
   - File SHORT, HARSH GitHub issues for ALL NEW defects found
   - patrick: Structural and dead code issues with brutal criticism of responsible parties
   - vicky: Bugs and user experience issues calling out incompetent implementations  
   - chris: Architectural drift and sprint goal gap issues with harsh blame assignments
   - Use SHORT titles and BRUTAL descriptions: "Fix this garbage", "Stop breaking X", "Implement Y properly"
   - **🚨 NEVER FILE**: Workflow reminders, process documentation, general improvements - add to SPRINT BACKLOG meta-issue instead
   - **🚨 THIS PLAY CONSOLIDATION ONLY**: chris consolidates issues filed during this specific PLAY run (not all issues like in PLAN mode)

5. **Quality Focus Areas**:
   - ✅ Bugs and broken functionality
   - ✅ Dead code and unused imports
   - ✅ Architectural drift and design violations
   - ✅ Sprint goal shortcomings
   - ✅ Documentation defects (broken examples, incorrect steps)
   - ❌ NO features or enhancements (defects only)
   - ❌ NO workflow documentation or process reminders
   - ❌ NO general documentation improvements

6. **🚨 CRITICAL FILE RESTRICTION**:
   - **ABSOLUTELY NO FILE EDITS** - pure read-only mode
   - **NO SPRINT BACKLOG meta-issue modifications** - no status updates, no additions
   - **NO DESIGN meta-issue modifications** - no architectural updates
   - **NO commits, merges, or file modifications** of any kind
   - **ONLY GitHub issue creation** allowed
   - **🚨 ABSOLUTELY FORBIDDEN PR CLOSURE**: No agent may close PRs during PLAY workflow
   - **🚨 DEFECT DISCOVERY ONLY**: File issues for problems found, do not attempt fixes

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