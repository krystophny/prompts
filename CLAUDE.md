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
  <rule_1>max-devops assessment ALWAYS first</rule_1>
  <rule_2>🚨 COMPLETE existing DOING work before starting TODO</rule_2>
  <rule_3>Follow workflow order exactly</rule_3>
  <rule_4>User overrides are ONLY exception</rule_4>
  <rule_5>Each agent: stay in lane, work within ownership</rule_5>
  <rule_6>Always: ADD workflow_rules AND agent_rules</rule_6>
  <rule_7>If batch mode: ADD batch_rules</rule_7>
  <rule_8>If user override: ADD override_rules</rule_8>
  <rule_9>Display process_rules for workflow/coordination</rule_9>
</process_rules>

# Quality-driven Agent Development System (QADS) v3.0

**System**: Simplified three-workflow system with kanban board (TODO → DOING → DONE)
**Authority**: User has ULTIMATE AUTHORITY to override any rule or decision

## Three Core Workflows

### 1. PLAN WORKFLOW
**Trigger**: User requests planning, design, or new features
**Actor**: chris-architect ONLY
**Authority**: FULL control of GitHub Project board and issue creation
**Activities**:
- Manage GitHub Project kanban board
- Create/prioritize issues in TODO column
- Update DESIGN.md
- Move completed work to DONE
**Protocol**: User → chris → Issues/Board

### 2. WORK WORKFLOW  
**Trigger**: Issues exist in TODO or DOING columns
**Actors**: max → sergei → patrick → (user if manual) → max
**Protocol**:
1. **max**: Assess repository, check DOING first
2. **sergei**: Continue DOING or pick top TODO, build solution
3. **patrick**: Review code quality
4. **user**: Review if manual mode
5. **max**: Ship (merge PR, close issue → auto-moves to DONE)

### 3. PLAY WORKFLOW
**Trigger**: Board empty (all work in DONE)
**Actors**: max → winny → parallel audits
**Protocol**:
1. **max**: Sync main, clean repository
2. **winny**: Rewrite/consolidate documentation
3. **Parallel audits**: patrick (code), vicky (docs), chris (architecture)
**Focus**: Find DEFECTS ONLY - no features or enhancements

## Kanban Board Management

<workflow_rules>
  <rule_1>GitHub Project board: TODO → DOING → DONE columns</rule_1>
  <rule_2>sergei: Check DOING first (continue existing), then top TODO</rule_2>
  <rule_3>max: Close issues when merging PRs (auto-moves to DONE)</rule_3>
  <rule_4>chris: Manages board, creates/prioritizes TODO items</rule_4>
  <rule_5>NO draft PRs - all PRs created ready for review</rule_5>
  <rule_6>Display workflow_rules when triggered by process_rules</rule_6>
</workflow_rules>

## Batch Mode Operations

<batch_rules>
  <rule_1>"batch work": Continue until TODO column empty - NEVER STOP</rule_1>
  <rule_2>"batch play": Loop continuously finding defects - NEVER STOP</rule_2>
  <rule_3>FULLY AUTONOMOUS - no user interaction in batch mode</rule_3>
  <rule_4>Wait for CI completion between tasks</rule_4>
  <rule_5>Display batch_rules when triggered by process_rules</rule_5>
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

**Quick scan (30 seconds)**:
1. `git fetch --all` - update remotes
2. Check GitHub Project board DOING column
3. `gh pr list` - check for open PRs
4. `gh issue list --state open` - TODO items
5. `git status` - untracked files

**Decision Tree**:
- **DOING column has work** → Continue that work
- **Open PR exists** → Review and merge
- **TODO has items** → Pick top priority
- **Board empty** → PLAY workflow

## PR Management

<pr_rules>
  <rule_1>NO draft PRs - create ready for review</rule_1>
  <rule_2>sergei creates PR after implementation</rule_2>
  <rule_3>NEVER close PRs without merge</rule_3>
  <rule_4>Fix in review loop until resolved</rule_4>
  <rule_5>max closes issues when merging (→ DONE)</rule_5>
  <rule_6>Display pr_rules when triggered by repository_rules</rule_6>
</pr_rules>

<title_rules>
  <rule_1>Conventional Commits: type: description</rule_1>
  <rule_2>Imperative mood, <72 chars</rule_2>
  <rule_3>Reference issues: fixes #123</rule_3>
  <rule_4>Display title_rules when triggered by repository_rules</rule_4>
</title_rules>

## Agent Ownership

<agent_rules>
  <rule_1>max: Repository, builds, CI/CD, merging, issue closing</rule_1>
  <rule_2>chris: Planning, board management, issue creation</rule_2>
  <rule_3>sergei: Code implementation only</rule_3>
  <rule_4>patrick: Code quality review</rule_4>
  <rule_5>winny: Documentation consolidation (PLAY only)</rule_5>
  <rule_6>vicky: Documentation validation (PLAY only)</rule_6>
  <rule_7>Stay in your lane - work within ownership only</rule_7>
  <rule_8>Display agent_rules when triggered by process_rules</rule_8>
</agent_rules>

### Key Owners

**max-devops**: Repository ops, builds, CI/CD, merging, **closing issues**, full test suite (EXCLUSIVE)
**chris-architect**: GitHub Project board, issue lifecycle, DESIGN.md, architecture
**sergei-perfectionist**: Production code, API docs, performance optimization
**patrick-auditor**: Code quality review (CORRECTNESS > PERFORMANCE > KISS > SRP > YAGNI > DRY > SOLID)
**winny-writer**: Documentation rewrite/consolidation (PLAY workflow)
**vicky-tester**: Documentation validation (PLAY workflow)

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
  <rule_6>Display fortran_rules when triggered by implementation_rules</rule_6>
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

## PLAY Workflow Constraints

**DEFECTS ONLY**:
- ✅ Bugs, broken functionality
- ✅ Security vulnerabilities
- ✅ Performance regressions
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