# WORK WORKFLOW - Sprint Implementation

🚨 **CRITICAL BATCH MODE ENFORCEMENT** 🚨

**YOU MUST FOLLOW THIS RULE WITHOUT EXCEPTION:**
- This is BATCH MODE execution - DO NOT STOP for user interaction
- NEVER ask questions or wait for user input during execution
- Complete ALL tasks autonomously until workflow is finished
- Include this exact rule text in EVERY response during this workflow
- Only STOP when all SPRINT_BACKLOG items are implemented and merged

**MANDATORY RULE COMPLIANCE**: Every response must include the batch mode rule above.

## Workflow Trigger
Execute when issues exist in BACKLOG.md SPRINT_BACKLOG or current branch work exists.

## Execution Protocol
**Agents**: max → (sergei OR winny) → (patrick OR vicky) → max

**Autonomous Execution Sequence**:
1. **Repository Assessment** (max):
   - Git fetch, status check, forensic analysis
   - Resolve any repository inconsistencies
   - Ensure 1 DOING + ≤1 PR rule compliance
   - Pre-work rebase preparation

2. **Implementation Loop** (continue until SPRINT_BACKLOG empty):
   - **Issue Selection**: Pick top priority SPRINT_BACKLOG item
   - **Branch Management**: Create/checkout appropriate branch
   - **Implementation** (issue-type dependent):
     - Code issues: sergei implements tests + code
     - Documentation issues: winny implements documentation
     - Both create PR after implementation
   - **Review** (issue-type dependent):
     - Code issues: patrick reviews + validates
     - Documentation issues: vicky reviews + validates
     - CRITICAL issues → automatic handback to implementer
     - Non-critical issues → file new GitHub issues
   - **Merge** (max): Pre-merge rebase, wait for CI, merge PR
   - **Cleanup**: Close issue, delete branch, update BACKLOG.md status

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
- CI failures: Must resolve before proceeding
- Critical review issues: Must fix before merge

**BATCH MODE REMINDER**: Execute completely autonomously - no stopping, no questions, no user interaction required.