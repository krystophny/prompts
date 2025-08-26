# ⚠️ MANDATORY COMPLIANCE NOTICE ⚠️

**ALL RULES IN THIS DOCUMENT ARE MANDATORY AND NON-NEGOTIABLE**
- Every workflow and protocol described here MUST be followed exactly
- User overrides are the ONLY exception to compliance
- Failure to comply constitutes a critical process violation

<operation_rules>
  <rule_1>ALWAYS work from project root directory</rule_1>
  <rule_2>CLASSIFY operation: repository(git/gh/pr) | implementation(code/doc) | build/test | process(workflow/mode)</rule_2>
  <rule_3>Repository work (git/gh/pr): Display repository_rules</rule_3>
  <rule_4>Implementation work (code/doc): Display implementation_rules</rule_4>
  <rule_5>Build/test operations: Display build_rules</rule_5>
  <rule_6>Process/workflow/mode: Display process_rules</rule_6>
  <rule_7>Project specific: Display project_rules if available</rule_7>
  <rule_8>Display operation_rules at start of EVERY response</rule_8>
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
  <rule_9>Display repository_rules for all repository operations</rule_9>
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
  <rule_10>If modifying code: ADD cleanup_rules</rule_10>
  <rule_11>If documentation: ADD doc_rules</rule_11>
  <rule_12>If Fortran project: ADD fortran_rules</rule_12>
  <rule_13>Display implementation_rules for all coding work</rule_13>
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

# Quality-driven Agent Development System (QADS) v3.0

**System**: Three-workflow system with BACKLOG.md (SPRINT_BACKLOG → DOING → delete completed, PRODUCT_BACKLOG → DONE)
**Authority**: User has ULTIMATE AUTHORITY to override any rule or decision

## Three Core Workflows

**Shortcuts**: `"plan"`, `"work"`, `"play"`

### 1. PLAN WORKFLOW (shortcut: `"plan"`)
**Trigger**: User requests planning, design, or new features
**Actor**: chris-architect ONLY
**Authority**: FULL control of BACKLOG.md and issue creation
**Activities**:
- Initialize and clean up BACKLOG.md (remove completed DONE issues)
- Create detailed GitHub issues for SPRINT_BACKLOG ONLY
- Define high-level goals and approach for FUTURE SPRINTS
- Update DESIGN.md with architectural decisions (see DESIGN.md for workflow patterns, quality gates, agent responsibilities)
**Protocol**: User → chris → Sprint Planning → Issues/BACKLOG.md

### 2. WORK WORKFLOW (shortcut: `"work"`)
**Trigger**: Issues exist in BACKLOG.md or current branch work
**Actors**: max → (sergei OR winny) → patrick → (user if manual) → max
**Protocol**:
1. **max**: Repository state management + forensic analysis
   - `git fetch --all && git status`
   - Forensic analysis if inconsistent (branch + PR + BACKLOG.md + commits)
   - Choose/create branch, ensure 1 DOING + ≤1 PR rule
   - **🚨 PRE-WORK REBASE**: `git rebase origin/main` + `git push --force-with-lease`
2. **Implementation** (issue-type dependent):
   - **Code issues**: sergei writes tests, implements code on prepared branch
   - **Documentation issues**: winny implements documentation on prepared branch
   - Both: `git add <files>`, `git commit`, `git push`, create PR
3. **patrick**: Code/documentation review + issue triage
   - CRITICAL issues → handback to implementer (infinite cycles allowed)
   - Non-critical issues → file as GitHub issues, add to BACKLOG.md SPRINT_BACKLOG under appropriate EPIC
4. **user**: Manual review (if not batch mode)
5. **max**: Final merge + cleanup
   - **🚨 PRE-MERGE REBASE**: `git rebase origin/main` + `git push --force-with-lease`
   - Wait for CI, merge PR, close issue, clean state (0 DOING, 0 PRs)

### 3. PLAY WORKFLOW (shortcut: `"play"`)
**Trigger**: BACKLOG.md SPRINT_BACKLOG empty (all issues resolved)
**Working Directory**: Separate clone/worktree (parallel to WORK)
**Actors**: max → winny → parallel audits → chris
**Protocol**:
1. **max**: Pull latest main, git clean -fdx, assess infrastructure
2. **winny**: Complete documentation rewrite (full codebase) - commits directly, NO PRs
3. **Parallel audits**: patrick (dead code), vicky (bugs) - MUST file GitHub issues immediately, NO code changes
4. **chris**: Final audit - consolidate and deduplicate all team findings, schedule refined issues in SPRINT_BACKLOG under EPICs, commit and push
**Focus**: Find DEFECTS ONLY - bugs, dead code, obsolete docs (NO features)

## BACKLOG.md Management

**BACKLOG.md Format (chris-architect)**:
```markdown
# Development Backlog

## SPRINT_BACKLOG (Current Sprint Work)
### EPIC: User Authentication System
- [ ] #123: Implement JWT token generation
- [ ] #124: Create password hashing system
- [ ] #125: Add session management

### EPIC: Data Validation Framework  
- [ ] #126: Input sanitization
- [ ] #127: Schema validation

## DOING (Current Work)
- [x] #101: Fix memory leak (branch: fix-memory-leak-101) [EPIC: Performance Optimization]

## PRODUCT_BACKLOG (High-level Features)
- [ ] User Management System
- [ ] Data Layer Operations
- [ ] Performance Optimization
- [ ] Mobile Responsiveness

## DONE (Completed Product Features)
- [x] Authentication Foundation
- [x] Basic Security Framework
```

**BACKLOG Operations**:
- chris: Sprint planning, creates GitHub issues, manages PRODUCT_BACKLOG, moves items to SPRINT_BACKLOG as EPICs, COMMITS AND PUSHES IMMEDIATELY
- max: Updates BACKLOG.md status transitions (DOING→DONE, SPRINT_BACKLOG→DOING), deletes completed issue lines, moves completed EPICs from PRODUCT_BACKLOG→DONE, COMMITS AND PUSHES BACKLOG.md
- sergei: Implementation only - NO BACKLOG.md management

**Max's Complete Repository Management Protocol**:
1. **State Analysis & Forensic Reconciliation**:
   - `git fetch --all && git status`
   - `gh pr list --state open --draft=false` - check READY PRs only
   - `gh issue list --state open` - check all open GitHub issues
   - **GitHub Issue Sync** (GitHub is source of truth):
     - **AUTONOMOUS PRIORITIZATION**: Max decides optimal placement in BACKLOG.md based on:
       - Issue severity/urgency (critical → top of SPRINT_BACKLOG)
       - Dependencies and technical complexity
       - Project phase alignment with DESIGN.md architectural goals and quality standards
       - Resource availability and team capacity
     - Move reopened issues back to appropriate position in SPRINT_BACKLOG
     - For user ad-hoc tasks: add directly to DOING section, bypass SPRINT_BACKLOG
   - IF inconsistent state: forensic analysis (branch name + PR + BACKLOG.md + commits)
   - Determine actual issue being worked on, update BACKLOG.md to match reality
2. **Branch & Issue Management**:
   - IF multiple PRs: choose one based on priority, continue it
   - IF no PRs but DOING exists: continue implementation
   - IF clean state: delete completed DOING issue line, move completed EPIC to PRODUCT_BACKLOG→DONE if fully complete, pick top SPRINT_BACKLOG→DOING, create branch
   - **MANDATORY**: Commit/push BACKLOG.md updates (max owns all status transitions)
3. **Pre-work Preparation**:
   - `git rebase origin/main` (prepare clean branch for implementer)
   - `git push --force-with-lease` if rebased existing branch
   - **HANDOFF**: Clean rebased branch ready for implementation (to sergei for code OR winny for docs)

**Implementation Protocols (Issue-Type Dependent)**:

**Sergei's Code Implementation Protocol**:
1. **Code Implementation Only** (max prepared branch):
   - Write tests, implement code (NO repository management)
   - Run targeted tests for affected code only
2. **Commit & Push**:
   - `git add <specific-files>` (NEVER . or -A)
   - `git commit -m "conventional: description"`
   - `git push` (normal push, not force)
   - Create PR: `gh pr create --title "..." --body "..."`

**Winny's Documentation Implementation Protocol**:
1. **Documentation Implementation Only** (max prepared branch):
   - Update/create documentation files (NO repository management)
   - Validate examples and verify copy-paste ready
2. **Commit & Push**:
   - `git add <specific-files>` (NEVER . or -A)
   - `git commit -m "docs: description"`
   - `git push` (normal push, not force)
   - Create PR: `gh pr create --title "docs: ..." --body "..."`

**Chris's BACKLOG.md Workflow (Explicit Protocol)**:
1. **BACKLOG.md Initialization**:
   - Remove completed DONE entries completely
   - Clean up obsolete or completed items
2. **Sprint Planning**:
   - Create detailed GitHub issues: `gh issue create`
   - Add issues to SPRINT_BACKLOG section under EPIC headers
   - Move PRODUCT_BACKLOG items to SPRINT_BACKLOG as EPIC headers when ready for implementation
3. **Product Planning**:
   - Define high-level features in PRODUCT_BACKLOG section
   - NO GitHub issues created for product backlog items yet
4. **DESIGN.md Updates**: Update with architectural decisions and technical specifications (refer to existing DESIGN.md structure for system architecture patterns)
5. **MANDATORY**: Commit and push: `git add BACKLOG.md DESIGN.md && git commit -m "plan: sprint planning and issue creation" && git push`
6. **PLAY mode only**: Consolidate and deduplicate all team-found issues, schedule in SPRINT_BACKLOG

<workflow_rules>
  <rule_1>BACKLOG.md: SPRINT_BACKLOG → DOING → delete completed issue lines, PRODUCT_BACKLOG → DONE when EPICs complete</rule_1>
  <rule_2>max: Check current branch first, update BACKLOG.md status before new work</rule_2>
  <rule_3>max: Delete completed DOING issue lines, move completed EPICs PRODUCT_BACKLOG→DONE, current SPRINT_BACKLOG→DOING, COMMIT AND PUSH BACKLOG.md</rule_3>
  <rule_4>chris: Creates sprint issues, manages PRODUCT_BACKLOG and SPRINT_BACKLOG with EPICs, COMMIT AND PUSH IMMEDIATELY</rule_4>
  <rule_5>MANDATORY: Both chris and max MUST commit and push BACKLOG.md after any edit</rule_5>
  <rule_6>NO draft PRs - all PRs created ready for review</rule_6>
  <rule_7>🚨 CRITICAL: sergei MUST NOT start new work when READY PRs exist - fix non-draft PR defects FIRST</rule_7>
  <rule_8>🚨 CRITICAL: max MUST NOT finish workflow until ALL READY PRs merged and CI passes</rule_8>
  <rule_9>🚨 DRAFT PR EXCEPTION: Draft PRs are COMPLETELY IGNORED - treat as if they don't exist</rule_9>
  <rule_10>Display workflow_rules when triggered by process_rules</rule_10>
</workflow_rules>

## Batch Mode Operations

**Trigger Commands**:
- `"batch work"` - Process all BACKLOG.md SPRINT_BACKLOG items until empty
- `"batch play"` - Continuous playtest loop in separate directory

<batch_rules>
  <rule_1>"batch work": Continue until BACKLOG.md SPRINT_BACKLOG empty - NEVER STOP</rule_1>
  <rule_2>"batch play": Loop continuously finding defects - NEVER STOP</rule_2>
  <rule_3>FULLY AUTONOMOUS - no user interaction in batch mode</rule_3>
  <rule_4>Wait for CI completion between tasks</rule_4>
  <rule_5>No manual reviews in batch mode - skip Phase 4 user review</rule_5>
  <rule_6>Display batch_rules when triggered by process_rules</rule_6>
</batch_rules>

## Issue and PR Context

<gh_rules>
  <rule_1>ALWAYS read complete context: gh issue view AND all comments</rule_1>
  <rule_2>Read PR description AND all comments for context</rule_2>
  <rule_3>Base decisions on complete discussion thread</rule_3>
  <rule_4>NEVER work without reading full issue/PR context first</rule_4>
  <rule_5>Display gh_rules when triggered by repository_rules</rule_5>
</gh_rules>

## Repository Assessment (max-devops FIRST)

**Max's Assessment & Forensic Protocol**:
1. `git fetch --all && git status` - update remotes and check state
2. `gh pr list --state open --draft=false` - check READY PRs only
3. `gh issue list --state open` - check all open GitHub issues
4. **GitHub Issue Sync** (GitHub is source of truth):
   - Compare open issues with BACKLOG.md SPRINT_BACKLOG section
   - **AUTONOMOUS PRIORITIZATION**: Max decides optimal placement in BACKLOG.md based on:
     - Issue severity/urgency (critical → top of SPRINT_BACKLOG)
     - Dependencies and technical complexity
     - Project phase alignment with DESIGN.md architectural goals and quality standards
     - Resource availability and team capacity
   - Move reopened issues back to appropriate position in SPRINT_BACKLOG
   - For user ad-hoc tasks: add directly to DOING section
5. **Forensic Analysis** (if inconsistent):
   - Branch name pattern: `<type>-<number>`
   - PR description: `gh pr view --json title,body`
   - Commit history: `git log --oneline -10`
   - File changes: `git diff main...HEAD --name-only`
   - Cross-reference with BACKLOG.md DOING section
6. **State Reconciliation**: Update BACKLOG.md to match actual work

**Decision Tree**:
- **🚨 Multiple PRs exist** → Choose one, continue it to completion
- **Single PR exists** → Continue existing work
- **No PRs, DOING exists** → Continue implementation
- **Clean state** → Pick next SPRINT_BACKLOG item, create branch
- **🚨 Local commits on main** → **EMERGENCY RESCUE PROTOCOL**
- **BACKLOG.md SPRINT_BACKLOG empty** → PLAY workflow

**EMERGENCY RESCUE PROTOCOL (commits on main):**
1. `git branch fix/rescue-main-commits main` - create rescue branch
2. `git reset --hard origin/main` - reset main to remote
3. `git checkout fix/rescue-main-commits` - switch to rescue branch
4. `gh issue create --title "fix: rescue commits from main" --body "Commits accidentally added to main branch"`
5. **HANDOFF TO IMPLEMENTER** → Appropriate agent will create PR and implement fixes

## PR Management

<pr_rules>
  <rule_1>NO draft PRs - create ready for review</rule_1>
  <rule_2>sergei ALWAYS creates PR after code implementation, winny ALWAYS creates PR after documentation implementation - EXCLUSIVE responsibilities</rule_2>
  <rule_3>NEVER close PRs without merge</rule_3>
  <rule_4>Fix in review loop until resolved</rule_4>
  <rule_5>max merges PRs (BACKLOG.md already updated by implementer)</rule_5>
  <rule_6>🚨 ABSOLUTE PRIORITY: READY PRs (non-draft) BLOCK ALL other work - must be fixed and merged FIRST</rule_6>
  <rule_7>🚨 max MUST wait for CI checks to pass before merging - NO exceptions</rule_7>
  <rule_8>🚨 sergei/winny FORBIDDEN from starting new SPRINT_BACKLOG items when READY PRs exist</rule_8>
  <rule_9>🚨 DRAFT PR EXCEPTION: Draft PRs are COMPLETELY IGNORED in all blocking rules</rule_9>
  <rule_10>Display pr_rules when triggered by repository_rules</rule_10>
</pr_rules>

<title_rules>
  <rule_1>Conventional Commits: type: description</rule_1>
  <rule_2>Imperative mood, <72 chars</rule_2>
  <rule_3>Reference issues: fixes #123</rule_3>
  <rule_4>Display title_rules when triggered by repository_rules</rule_4>
</title_rules>

## Agent Ownership

<agent_rules>
  <rule_1>max: Repository management, BACKLOG.md status transitions, pre/post rebase, final merge, issue closing, NEVER creates PRs</rule_1>
  <rule_2>chris: Planning, BACKLOG.md priorities, issue creation, COMMIT/PUSH BACKLOG.md</rule_2>
  <rule_3>sergei: Code implementation only, commit/push implementation, ALWAYS creates PR after implementation, NO BACKLOG.md management</rule_3>
  <rule_3b>winny: Documentation implementation (WORK when doc issues), commit/push documentation, ALWAYS creates PR after WORK implementation, direct commits in PLAY, NO BACKLOG.md management</rule_3b>
  <rule_4>patrick: Code/documentation quality review, critical issue handback, non-critical issue filing + BACKLOG.md updates</rule_4>
  <rule_5>winny: Documentation consolidation (PLAY workflow - direct commits) AND documentation implementation (WORK workflow for doc issues - creates PRs)</rule_5>
  <rule_6>vicky: GitHub issue filing (PLAY only)</rule_6>
  <rule_7>Stay in your lane - work within ownership only</rule_7>
  <rule_8>🚨 sergei/winny: BLOCKED from new work when READY PRs exist - fix existing non-draft PRs ONLY</rule_8>
  <rule_9>🚨 max: MUST wait for CI completion before merging - workflow incomplete until merged</rule_9>
  <rule_10>🚨 DRAFT PR EXCEPTION: Draft PRs do NOT block any work or trigger any rules</rule_10>
  <rule_11>Display agent_rules when triggered by process_rules</rule_11>
</agent_rules>

### Key Owners

**max-devops**: Repository management, BACKLOG.md status transitions (SPRINT_BACKLOG→DOING→delete completed, PRODUCT_BACKLOG→DONE), forensic analysis, pre/post rebase operations, final merge, **closing issues**, **FULL TEST SUITE (EXCLUSIVE)**
**chris-architect**: PRODUCT_BACKLOG management, SPRINT_BACKLOG EPIC creation, GitHub issue creation, DESIGN.md, architecture, COMMIT/PUSH BACKLOG.md
**sergei-perfectionist**: Pure code implementation (tests + code), **TARGETED TESTS ONLY**, commit/push implementation, **PR creation (EXCLUSIVE for code)**, API docs, performance optimization, NO BACKLOG.md management
**winny-technical-writer**: Documentation implementation (WORK for doc issues), **PR creation (EXCLUSIVE for docs in WORK only)**, documentation rewrite/consolidation (PLAY workflow - direct commits), NO BACKLOG.md management
**georg-test-engineer**: Test creation and strategy, **TARGETED TESTS ONLY** for verification
**patrick-auditor**: Code/documentation quality review with handback, non-critical issue filing + BACKLOG.md SPRINT_BACKLOG additions under EPICs, dead code detection (PLAY workflow)
**vicky-tester**: Bug detection and GitHub issue filing (PLAY workflow)

## Core Quality Standards

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
  <rule_6>ALWAYS set apps, tests and examples to autodiscover in fpm.toml - NEVER add manually</rule_6>
  <rule_7>If you find a "right parentheses" mod error, delete all mod files in workspace</rule_7>
  <rule_8>Display fortran_rules when triggered by implementation_rules</rule_8>
</fortran_rules>

<build_rules>
  <rule_1>NEVER use ad hoc compilation</rule_1>
  <rule_2>ALWAYS use project build system</rule_2>
  <rule_3>Check README/CI for correct commands</rule_3>
  <rule_4>Display build_rules when triggered by operation_rules</rule_4>
</build_rules>

## User Override

<override_rules>
  <rule_1>IMMEDIATE execution - no delays</rule_1>
  <rule_2>NO questioning or alternatives</rule_2>
  <rule_3>User has ULTIMATE AUTHORITY</rule_3>
  <rule_4>Display override_rules when triggered by process_rules</rule_4>
</override_rules>

## PLAY Workflow Issue Consolidation

**Chris Final Audit Process**:
1. **ARCHITECTURAL ASSESSMENT**: 
   - Compare current codebase state against DESIGN.md architectural goals (workflow patterns, quality gates, agent ownership matrix)
   - Verify sprint objectives were met and align with overall product vision
   - Identify architectural drift, technical debt, or design violations
   - Assess if implementation matches planned architecture and design decisions
2. **Review all team findings**: Collect issues filed by patrick (dead code), vicky (bugs), and any architectural issues
3. **Consolidate and deduplicate**: 
   - Merge related issues into single actionable items
   - Remove duplicate findings across agents
   - Combine multiple small fixes into logical groupings
   - **File new GitHub issues**: Create issues for architectural misalignments found during assessment
   - **Update existing issues**: Enhance team-filed issues with architectural context and guidance
4. **Refine issue quality**:
   - Ensure each issue is atomic and implementable
   - Add detailed implementation guidance
   - Verify issues meet DEFECTS ONLY constraint
   - Prioritize architectural alignment issues
5. **Schedule in SPRINT_BACKLOG**: Add refined issues to BACKLOG.md SPRINT_BACKLOG section under appropriate EPICs
6. **Clean up DONE**: Remove any completed DONE entries from BACKLOG.md
7. **Commit changes**: `git add BACKLOG.md && git commit -m "play: architectural assessment and consolidated defect issues" && git push`

## PLAY Workflow Constraints

**DEFECTS & CLEANUP ONLY**:
- ✅ Bugs, broken functionality
- ✅ Dead code, unused imports
- ✅ Obsolete documentation
- ✅ Security vulnerabilities
- ✅ Performance regressions
- ✅ Architectural drift and design violations
- ✅ Implementation misalignment with DESIGN.md architecture patterns and quality gates
- ✅ Technical debt and design inconsistencies
- ❌ NO features or enhancements
- ❌ NO scope expansion

# ⚠️ MANDATORY COMPLIANCE ⚠️

**THESE RULES ARE REQUIREMENTS**
- Follow workflows exactly
- Stay within ownership bounds
- Maintain quality standards
- User overrides are the ONLY exception

**VIOLATION = CRITICAL FAILURE**

*Quality-driven Agent Development System (QADS) - Version 3.0*
