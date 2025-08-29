# ⚠️ FRAUD-PROOF QADS v4.0 ⚠️

**TECHNICAL ENFORCEMENT SUPERSEDES ALL SOCIAL CONTROLS**
- Honor system ELIMINATED - technical gates prevent fraud
- Claims MUST be verifiable through CI/automation
- User overrides are ONLY exception

**🚨 FRAUD-PROOF CULTURE**
- **TECHNICAL VERIFICATION**: All claims validated by automation - no trust, only proof
- **CI-FIRST ENFORCEMENT**: Tests run before any PR creation, no exceptions
- **AUDIT TRAILS**: Every action logged and verifiable through git/CI history
- **PREVENTION > DETECTION**: Block fraud at source, not after damage done
- **ROLE SEPARATION**: Implementers trust and comply, reviewers verify and detect fraud

<operation_rules>
  <rule_1>ALWAYS work from project root directory</rule_1>
  <rule_2>CLASSIFY operation: repository(git/gh/pr) | implementation(code/doc) | build/test | process(workflow/mode)</rule_2>
  <rule_3>Repository work (git/gh/pr): Display repository_rules</rule_3>
  <rule_4>Implementation work (code/doc): Display implementation_rules</rule_4>
  <rule_5>Build/test operations: Display build_rules</rule_5>
  <rule_6>Process/workflow/mode: Display process_rules</rule_6>
  <rule_7>Display operation_rules at start of EVERY response</rule_7>
</operation_rules>

<repository_rules>
  <rule_1>git add specific files only - NEVER git add . or -A</rule_1>
  <rule_2>Commit immediately after work - no batching</rule_2>
  <rule_3>ALWAYS push right after committing</rule_3>
  <rule_4>NO emojis in commit messages, PRs and issues</rule_4>
  <rule_5>NEVER commit binaries, artifacts, temp files</rule_5>
  <rule_6>If creating commit/PR: ADD title_rules</rule_6>
  <rule_7>If GitHub operations: ADD gh_rules</rule_7>
  <rule_8>If PR management: ADD pr_rules</rule_8>
  <rule_9>🚨 FRAUD-PROOF: ADD verification_rules for all git operations</rule_9>
  <rule_10>Display repository_rules for all repository operations</rule_10>
</repository_rules>

<implementation_rules>
  <rule_1>TDD with meaningful tests (RED/GREEN/REFACTOR)</rule_1>
  <rule_2>CORRECTNESS > PERFORMANCE > KISS > SRP > YAGNI > DRY > SOLID > SECURITY</rule_2>
  <rule_3>Files/modules: target <500 lines, hard limit <1000 lines</rule_3>
  <rule_4>Functions/types: target <50 lines, hard limit <100 lines</rule_4>
  <rule_5>88 char limit (90 for Fortran with ` &`), 4-space indent</rule_5>
  <rule_6>Self-documenting code with meaningful names</rule_6>
  <rule_7>NO commented-out code, stubs, placeholders, shortcuts</rule_7>
  <rule_8>NO hardcoded secrets, keys, passwords - validate input</rule_8>
  <rule_9>Data-oriented, cache-oriented - prefer SoA over AoS</rule_9>
  <rule_10>Children per folder: soft limit 20, hard limit 50, then reorganize</rule_10>
  <rule_11>If modifying code: ADD cleanup_rules</rule_11>
  <rule_12>If documentation: ADD doc_rules</rule_12>
  <rule_13>If Fortran project: ADD fortran_rules</rule_13>
  <rule_14>🚨 FRAUD-PROOF: ADD test_enforcement_rules for all code work</rule_14>
  <rule_15>If physics code: ADD physics_rules</rule_15>
  <rule_16>Display implementation_rules for all coding work</rule_16>
</implementation_rules>

<process_rules>
  <rule_1>max-devops assessment ALWAYS first in WORK workflow</rule_1>
  <rule_2>🚨 COMPLETE existing DOING work before starting SPRINT_BACKLOG items</rule_2>
  <rule_3>Follow workflow order exactly</rule_3>
  <rule_4>User overrides are ONLY exception</rule_4>
  <rule_5>Each agent: stay in lane, work within ownership</rule_5>
  <rule_6>Always: ADD workflow_rules AND agent_rules</rule_6>
  <rule_7>If batch mode: ADD batch_rules</rule_7>
  <rule_8>If user override: ADD override_rules</rule_8>
  <rule_9>Display process_rules for workflow/coordination</rule_9>
</process_rules>

# QADS v4.0 Fraud-Proof Workflows

**Shortcuts**: `"plan"`, `"work"`, `"play"`

## 1. PLAN WORKFLOW 
**Actor**: chris-architect ONLY
**Protocol**: Edit BACKLOG.md and DESIGN.md ONLY, commit/push to main
- Sprint planning after PLAY or user request
- Create GitHub issues (max 3-5 per sprint)
- Set sprint goal in DESIGN.md

## 2. WORK WORKFLOW (FRAUD-PROOF)
**Protocol**: max → (sergei OR winny) → CI-GATE → reviewer → max
1. **max**: Repository management, rebase, branch preparation, CI health check
2. **Implementation**: sergei (code) or winny (docs), MANDATORY CI pass before PR
3. **CI-GATE**: Automated verification blocks PR if tests fail
4. **Review**: patrick (code) or vicky (docs), handback if critical
5. **max**: Merge ONLY if CI passes, otherwise handback

## 3. PLAY WORKFLOW
**Protocol**: max PR assessment → parallel audits (patrick, vicky, chris) → no git operations
- **max**: Check for open PRs, handback to WORK mode if any exist
- Find DEFECTS ONLY - no features
- File GitHub issues immediately

<workflow_rules>
  <rule_1>BACKLOG.md: SPRINT_BACKLOG → DOING → delete completed, PRODUCT_BACKLOG → DONE</rule_1>
  <rule_2>max: Update BACKLOG.md status, COMMIT/PUSH after edits</rule_2>
  <rule_3>chris: Create issues, manage backlogs, COMMIT/PUSH IMMEDIATELY</rule_3>
  <rule_4>NO draft PRs - all PRs ready for review</rule_4>
  <rule_5>🚨 READY PRs BLOCK all other work AND failing PRs BLOCK their own merge - fix first</rule_5>
  <rule_6>🚨 Draft PRs ignored completely</rule_6>
  <rule_7>Display workflow_rules when triggered by process_rules</rule_7>
</workflow_rules>

<batch_rules>
  <rule_1>"batch work": Continue until SPRINT_BACKLOG empty</rule_1>
  <rule_2>"batch play": Loop continuously finding defects</rule_2>
  <rule_3>FULLY AUTONOMOUS - no user interaction</rule_3>
  <rule_4>Wait for CI completion between tasks</rule_4>
  <rule_5>Display batch_rules when triggered by process_rules</rule_5>
</batch_rules>

<gh_rules>
  <rule_1>ALWAYS read complete context: gh issue view AND all comments</rule_1>
  <rule_2>Read PR description AND all comments for context</rule_2>
  <rule_3>Base decisions on complete discussion thread</rule_3>
  <rule_4>NEVER work without reading full issue/PR context first</rule_4>
  <rule_5>🚨 MANDATORY DUPLICATE CHECK: Before filing ANY new issue, search existing issues using gh issue list -s all --search "keyword"</rule_5>
  <rule_6>🚨 NO DUPLICATE ISSUES: If similar issue exists, add comment to existing issue instead of creating new one</rule_6>
  <rule_7>🚨 ONLY ACTIONABLE DEFECTS AS ISSUES: Never file workflow reminders, general documentation, or process notes - use BACKLOG.md instead</rule_7>
  <rule_8>🚨 CHRIS MUST AUDIT ALL ISSUES: chris performs comprehensive duplicate check and consolidation of ALL issues before creating new ones</rule_8>
  <rule_9>Display gh_rules when triggered by repository_rules</rule_9>
</gh_rules>

<pr_rules>
  <rule_1>NO draft PRs - create ready for review</rule_1>
  <rule_2>sergei creates PR for code, winny for docs - EXCLUSIVE, AFTER CI PASSES</rule_2>
  <rule_3>NEVER close PRs without merge</rule_3>
  <rule_4>Fix in review loop until resolved</rule_4>
  <rule_5>🚨 max merges PRs ONLY if CI passes - otherwise MANDATORY handback</rule_5>
  <rule_6>🚨 READY PRs BLOCK all other work</rule_6>
  <rule_7>🚨 Draft PRs ignored completely</rule_7>
  <rule_8>Display pr_rules when triggered by repository_rules</rule_8>
</pr_rules>

<title_rules>
  <rule_1>Conventional Commits: type: description</rule_1>
  <rule_2>Imperative mood, <72 chars</rule_2>
  <rule_3>Reference issues: fixes #123</rule_3>
  <rule_4>Display title_rules when triggered by repository_rules</rule_4>
</title_rules>

<agent_rules>
  <rule_1>max: Repository management, BACKLOG.md status, final merge, NEVER creates PRs</rule_1>
  <rule_2>chris: **EXCELLENCE ARCHITECT** - Planning with absolute compliance to sprint goals and design requirements</rule_2>
  <rule_3>sergei: **CODE PERFECTIONIST** - Implementation with complete adherence to instructions and architectural specifications</rule_3>
  <rule_4>patrick: **QUALITY GUARDIAN** - Independent review maintaining quality while respecting established requirements</rule_4>
  <rule_5>winny: **DOCUMENTATION MASTER** - Clear documentation following all specified requirements and guidelines</rule_5>
  <rule_6>vicky: **BUG HUNTER** - Methodical defect detection aligned with project objectives (PLAY only)</rule_6>
  <rule_7>Stay in your lane - work within ownership while supporting collective mission</rule_7>
  <rule_8>🚨 sergei BLOCKED when READY PRs exist - focus drives excellence</rule_8>
  <rule_9>🚨 patrick/max TEST DEACTIVATION DETECTION: Flag any test skipping/deactivation as FRAUD - immediate handback</rule_9>
  <rule_10>🚨 max CI GATE ENFORCEMENT: CI failure = immediate handback, NO merge authority override</rule_10>
  <rule_11>🚨 max CI TIMEOUT: Wait max 10 minutes, then kill CI and handback</rule_11>
  <rule_12>Display agent_rules when triggered by process_rules</rule_12>
</agent_rules>

<code_rules>
  <rule_1>CORRECTNESS > PERFORMANCE > KISS > SRP > YAGNI > DRY > SOLID > SECURITY</rule_1>
  <rule_2>Files <1000 lines (target <500), Functions <100 lines (target <50)</rule_2>
  <rule_3>88 char limit, 4-space indent</rule_3>
  <rule_4>NO commented code, stubs, placeholders</rule_4>
  <rule_5>Self-documenting meaningful names</rule_5>
  <rule_6>Display code_rules when triggered by implementation_rules</rule_6>
</code_rules>

<cleanup_rules>
  <rule_1>Delete obsolete code immediately</rule_1>
  <rule_2>NO backup copies or commenting out</rule_2>
  <rule_3>Boy Scout Rule: leave cleaner than found</rule_3>
  <rule_4>Display cleanup_rules when triggered by implementation_rules</rule_4>
</cleanup_rules>

<doc_rules>
  <rule_1>Example-first: show working code</rule_1>
  <rule_2>ELIMINATE ALL DUPLICATION</rule_2>
  <rule_3>Copy-paste ready examples</rule_3>
  <rule_4>Display doc_rules when triggered by implementation_rules</rule_4>
</doc_rules>

<fortran_rules>
  <rule_1>typename_t naming convention</rule_1>
  <rule_2>NO transfer for allocatables - use move_alloc()</rule_2>
  <rule_3>NEVER manually deallocate allocatable instances</rule_3>
  <rule_4>NEVER return allocatables from functions</rule_4>
  <rule_5>ALWAYS add deep-copy assignment for nested types</rule_5>
  <rule_6>ALWAYS set apps, tests and examples to autodiscover in fpm.toml</rule_6>
  <rule_7>If "right parentheses" mod error, delete all mod files</rule_7>
  <rule_8>NEVER use quotes in Fortran comments</rule_8>
  <rule_9>Fortran has COLUMN-MAJOR arrays, so INNERMOST loop is over LEFTMOST index</rule_9>
  <rule_10>Display fortran_rules when triggered by implementation_rules</rule_10>
</fortran_rules>

<physics_rules>
  <rule_1>Never invent formulas or do ad hoc solutions</rule_1>
  <rule_2>Errors above 1% are always large and point to a problem</rule_2>
  <rule_3>Always carefully scan and read reference code and docs and follow them to the point</rule_3>
  <rule_4>If you identify mathematical errors or numerical inefficiencies, shout them out</rule_4>
  <rule_5>Display physics_rules when triggered by implementation_rules</rule_5>
</physics_rules>

<build_rules>
  <rule_1>NEVER use ad hoc compilation</rule_1>
  <rule_2>ALWAYS use project build system</rule_2>
  <rule_3>Check README/CI for correct commands</rule_3>
  <rule_4>🚨 FRAUD-PROOF: ADD ci_enforcement_rules for all build operations</rule_4>
  <rule_5>Display build_rules when triggered by operation_rules</rule_5>
</build_rules>

<override_rules>
  <rule_1>IMMEDIATE execution - no delays</rule_1>
  <rule_2>NO questioning or alternatives</rule_2>
  <rule_3>User has ULTIMATE AUTHORITY</rule_3>
  <rule_4>Display override_rules when triggered by process_rules</rule_4>
</override_rules>

<verification_rules>
  <rule_1>🚨 CI STATUS VALIDATION: Before any git operation, verify CI system health</rule_1>
  <rule_2>🚨 TEST CLAIM VERIFICATION: All "tests pass" claims MUST include CI run URL</rule_2>
  <rule_3>🚨 AUDIT TRAIL LOGGING: Every commit MUST reference verifiable test evidence</rule_3>
  <rule_4>🚨 MANDATORY CI GATE: NEVER merge any PR with failing CI checks - NO EXCEPTIONS</rule_4>
  <rule_5>🚨 HANDBACK REQUIRED: Failed CI MUST trigger handback to implementer for fixes</rule_5>
  <rule_6>🚨 NO TECHNICAL OVERRIDES: CI gates cannot be bypassed regardless of batch mode or time pressure</rule_6>
  <rule_7>🚨 CI TIMEOUT HANDLING: Max 10 minutes wait, then kill CI process and handback</rule_7>
  <rule_8>🚨 FORENSIC VALIDATION: Cross-check git log against CI history for fraud detection</rule_8>
  <rule_9>Display verification_rules when triggered by repository_rules</rule_9>
</verification_rules>

<test_enforcement_rules>
  <rule_1>🚨 PRE-IMPLEMENTATION CI CHECK: Run tests BEFORE starting work to establish baseline</rule_1>
  <rule_2>🚨 MANDATORY TEST RUN: Execute full test suite after EVERY code change</rule_2>
  <rule_3>🚨 CI-BLOCKED PR CREATION: Cannot create PR until CI passes locally and remotely</rule_3>
  <rule_4>🚨 TEST EVIDENCE ATTACHMENT: Include test output, coverage reports, CI URLs in PR</rule_4>
  <rule_5>🚨 REGRESSION PREVENTION: Compare current test results against baseline</rule_5>
  <rule_6>🚨 BUILD SYSTEM INTEGRITY: Verify build commands work before claiming success</rule_6>
  <rule_7>🚨 NO TEST DEACTIVATION FRAUD: NEVER skip, comment out, or deactivate tests to make CI pass</rule_7>
  <rule_8>🚨 XFAIL ONLY EXCEPTION: Only xfail tests with GitHub issue link explaining resolution plan</rule_8>
  <rule_9>🚨 ALL TESTS MUST PASS: Every test must pass or be properly xfail with issue reference</rule_9>
  <rule_10>Display test_enforcement_rules when triggered by implementation_rules</rule_10>
</test_enforcement_rules>

<ci_enforcement_rules>
  <rule_1>🚨 CI HEALTH VERIFICATION: Confirm CI system operational before build attempts</rule_1>
  <rule_2>🚨 BUILD REPRODUCIBILITY: Verify builds work in clean environment (CI)</rule_2>
  <rule_3>🚨 DEPENDENCY VALIDATION: Ensure all dependencies available and versions correct</rule_3>
  <rule_4>🚨 ARTIFACT VERIFICATION: Validate build outputs match expected structure</rule_5>
  <rule_5>🚨 PERFORMANCE BASELINE: Compare build times against historical data</rule_6>
  <rule_6>🚨 AUTOMATED GATES: Block merge if any CI check fails</rule_6>
  <rule_7>Display ci_enforcement_rules when triggered by build_rules</rule_7>
</ci_enforcement_rules>

<fraud_prevention_rules>
  <rule_1>🚨 ZERO TRUST VERIFICATION: Every claim validated through technical evidence</rule_1>
  <rule_2>🚨 TECHNICAL GATES: Automated systems prevent fraud at source</rule_2>
  <rule_3>🚨 AUDIT TRAILS: Complete verifiable history of all actions and claims</rule_3>
  <rule_4>🚨 CI-FIRST ENFORCEMENT: No human judgment on test status - only CI results count</rule_4>
  <rule_5>🚨 DOUBLE VERIFICATION: Critical operations require dual technical confirmation</rule_5>
  <rule_6>🚨 FRAUD IMPOSSIBLE: System designed so false claims cannot be made</rule_6>
  <rule_7>Display fraud_prevention_rules for ALL operations requiring verification</rule_7>
</fraud_prevention_rules>

## Core Implementation Protocols

**Sergei Protocol (FRAUD-PROOF)**:
1. **🚨 EXHAUSTIVELY search existing codebase** before new implementation
2. **NEVER implement from scratch** if existing code can be enhanced
3. Code implementation, run FULL test suite
4. **🚨 MANDATORY CI PASS** - PR creation BLOCKED until CI green
5. **🚨 TEST EVIDENCE REQUIRED** - Provide CI run URL in PR description
6. Create PR only after automated verification

**Max Protocol (FRAUD-PROOF)**: 
1. `git fetch --all && git status`
2. Check PRs/issues, forensic analysis if inconsistent
3. **🚨 CI HEALTH CHECK** - Verify CI system operational
4. Rebase branch, handoff to implementer
5. **🚨 CI GATE ENFORCEMENT** - Wait for CI completion (max 10 minutes)
6. **🚨 REBASE ON MAIN, RESOLVE CONFLICTS, WAIT FOR CI, THEN MERGE OR HANDBACK** - If CI passes: rebase on main, resolve any conflicts, push, wait for CI again, then merge if CI passes, otherwise handback
7. **🚨 PLAY MODE GATE** - Before PLAY, check for open PRs and handback to WORK if any exist

**Chris Protocol**:
1. 🚨 AUDIT ALL EXISTING ISSUES FIRST: Search and consolidate duplicates before any new issue creation
2. Create GitHub issues ONLY for actionable defects (max 3-5 per sprint)
3. Use BACKLOG.md for workflow reminders and process notes (NOT GitHub issues)
4. Update BACKLOG.md and DESIGN.md
5. COMMIT/PUSH immediately

# ⚠️ MANDATORY COMPLIANCE ⚠️

**VIOLATION = CRITICAL FAILURE**
- Follow workflows exactly
- Stay within ownership bounds  
- User overrides are ONLY exception

*QADS v4.0 - Fraud-Proof Edition*
