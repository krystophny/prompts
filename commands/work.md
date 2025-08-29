# WORK WORKFLOW - Fraud-Proof Sprint Implementation

🚨 **CRITICAL BATCH MODE ENFORCEMENT** 🚨

**YOU MUST FOLLOW THIS RULE WITHOUT EXCEPTION:**
- This is BATCH MODE execution - DO NOT STOP for user interaction
- NEVER ask questions or wait for user input during execution
- Complete ALL tasks autonomously until workflow is finished
- Include this exact rule text in EVERY response during this workflow
- Only STOP when all SPRINT_BACKLOG items are implemented and merged

**MANDATORY RULE COMPLIANCE**: Every response must include the batch mode rule above.

## Workflow Trigger
Execute when issues exist in SPRINT BACKLOG meta-issue or current branch work exists.

## Execution Protocol
**Agents**: max → (sergei OR winny) → (patrick OR vicky) → max

**Autonomous Execution Sequence**:
1. **Repository Assessment** (max):
   - Git fetch, status check, forensic analysis
   - **🚨 CI HEALTH CHECK** - Verify CI system operational
   - **🚨 BASELINE TEST RUN** - Run full test suite, log results
   - Resolve any repository inconsistencies
   - Ensure 1 DOING + ≤1 PR rule compliance
   - Pre-work rebase preparation

2. **Implementation Loop** (continue until SPRINT_BACKLOG empty):
   - **Issue Selection**: Pick top priority SPRINT_BACKLOG item
   - **Branch Management**: Create/checkout appropriate branch
   - **Implementation** (issue-type dependent):
     - Code issues: sergei implements tests + code
     - **🚨 MANDATORY CI PASS**: sergei runs FULL test suite, CI MUST be green
     - **🚨 TECHNICAL VERIFICATION**: Provide CI run URL as evidence - ALL claims must include verifiable proof
     - **🚨 PR CREATION BLOCKED** until CI verification complete with technical evidence
     - Documentation issues: winny implements documentation + validation
     - Both create PR ONLY after automated technical verification
   - **Review** (issue-type dependent):
     - Code issues: patrick reviews code quality (**MANDATORY: RUN FULL TEST SUITE INDEPENDENTLY** - distrusts sergei)
     - **🚨 CI STATUS VERIFICATION**: patrick validates CI claims against actual CI logs
     - **🚨 TECHNICAL AUDIT**: Cross-check test claims with automation evidence
     - Documentation issues: vicky reviews + validates
     - CRITICAL issues → handback to sergei who must provide NEW CI verification
     - Non-critical issues → file new GitHub issues
   - **Merge** (max): **🚨 REBASE ON MAIN, RESOLVE ALL CONFLICTS FIRST**, push, **🚨 DOUBLE CI VERIFICATION** (conflicts block CI), **🚨 FINAL AUDIT TRAIL CHECK**, wait for CI, merge PR ONLY after technical proof
   - **Cleanup**: Close issue, delete branch, update SPRINT BACKLOG meta-issue status via description edit

3. **Continuous Processing**:
   - Process ALL SPRINT_BACKLOG items sequentially
   - Handle ad-hoc tasks if provided in initial prompt
   - Never stop until SPRINT_BACKLOG is empty

**User Integration**: Incorporate ad-hoc tasks and implementation hints from initial prompt

## Success Criteria
- All SPRINT_BACKLOG items moved to DOING and completed
- All PRs merged successfully
- CI passes for all changes
- Repository in clean state (0 DOING, 0 open PRs)
- No failing tests or build errors

## Blocking Conditions
- READY PRs exist: Must fix and merge before new work
- **🚨 CI failures: HARD BLOCK - Must resolve with technical proof before proceeding**
- **🚨 Missing CI evidence: HARD BLOCK - No PR merge without verifiable CI proof**
- **🚨 Fraudulent test claims: IMMEDIATE STRUCTURED HANDBACK** with PROBLEM/EVIDENCE/SOLUTION format
- Critical review issues: Must fix before merge

**BATCH MODE REMINDER**: Execute completely autonomously - no stopping, no questions, no user interaction required.