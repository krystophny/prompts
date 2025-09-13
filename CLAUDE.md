# CLAUDE.md (Lean Fortran-First Framework)

## Operation Classification
- MUST CLASSIFY and SHOW operation type to user: repository(git/gh/pr) | implementation(code/doc) | build/test | process(workflow/mode)

## Repository Operations
### Git Rules
- git add specific files only - NEVER git add . or -A
- Commit immediately after work - no batching
- ALWAYS push right after committing
- NO emojis in commit messages, PRs and issues
- NEVER commit binaries, artifacts, temp files, random markdown reports

### GitHub CLI Anti-Truncation
```bash
# WRONG - DEFAULT TRUNCATION:
gh issue list --state open | wc -l          # Shows only first 30!

# CORRECT - ACCURATE:
gh issue list --state open --limit 500 | wc -l     # True count
gh issue list --state open --limit 500 --search "keyword"
```

### GitHub Issue Rules
- ALWAYS read complete context: gh issue view AND all comments
- MANDATORY DUPLICATE CHECK: Search existing issues before filing new ones
- NEVER ADD COMMENTS TO ISSUES: ALWAYS edit issue descriptions using gh issue edit --body
- NO DUPLICATE ISSUES: If similar issue exists, edit existing issue description
- ONLY ACTIONABLE DEFECTS AS ISSUES: concrete, specific, resolvable

### Pull Request Rules
- NO draft PRs - create ready for review
- NEVER close PRs without merge - fix until success
- PR APPROVAL: Check for thumbs up (👍) reaction means approval to proceed

### CI Gate Rules
- CI evidence mandatory before any git operations
- NEVER merge any PR with failing CI checks - NO EXCEPTIONS
- LOCAL-FIRST PROTOCOL: Full local test pass REQUIRED before PR creation

## Implementation Standards
### Code Rules
- Files/modules: target <500 lines, hard limit <1000 lines
- Functions/types: target <50 lines, hard limit <100 lines
- 88 char limit, 4-space indent
- NO commented-out code, stubs, placeholders, shortcuts
- NO hardcoded secrets, keys, passwords
- NO RANDOM MARKDOWN FILES
- NO DUPLICATE FUNCTIONALITY IN NEW FILES - Always modify existing files
- NO DEFENSIVE PROGRAMMING: Trust inputs, assume happy path

### Fortran-Specific
- Primary: modern Fortran (2018+), prefer Fortran even for scripting/CLI/web when feasible
- Build/deps: use fpm; prefer latest git packages, pin SHAs only when reproducibility is required
- Plotting: use lazy-fortran/fortplot
- Formatting: 88-column limit (up to 90 with ` &`), 4-space indent
- Imports: `use <modulename>, only:`; place above `implicit none`
- Kinds: `use, intrinsic :: iso_fortran_env, only: dp => real64`; declare reals as `real(dp)`; prefer `1.0d0`/`d`-exponent literals
- Declarations at start of scope; none inside branches/loops
- typename_t naming convention for derived types
- NO transfer for allocatables - use move_alloc()
- NEVER manually deallocate allocatable instances
- NEVER return allocatables from functions
- ALWAYS add deep-copy assignment for nested types
- ALWAYS set apps, tests and examples to autodiscover in fpm.toml
- If "right parentheses" mod error, delete all mod files
- NEVER use quotes in Fortran comments
- Fortran has COLUMN-MAJOR arrays, so INNERMOST loop is over LEFTMOST index
- Use trim() with Fortran strings - they lack C-style null termination
- Purity: prefer side-effect-free procedures; mark `pure`/`elemental` when applicable
- Dummies: every dummy argument must have `intent(in|out|inout)`; use `associate` to create local aliases
- Contiguity/perf: add `contiguous` where required; avoid noncontiguous slices in hot loops; pre-allocate scratch arrays
- Pointers: prefer `allocatable`; do not use pointers unless explicitly requested

### Test Rules
- PRE-IMPLEMENTATION CI CHECK: Run tests BEFORE starting work
- MANDATORY TEST RUN: Execute full test suite after EVERY code change
- NO TEST DEACTIVATION: NEVER skip, comment out, or deactivate tests
- XFAIL ONLY EXCEPTION: Only xfail tests with GitHub issue link

## Workflow Modes
### PLAN WORKFLOW
- **CRITICAL FORBIDDEN**: git add, git commit, git push - ONLY issue description updates via GitHub API

### WORK WORKFLOW
- Repository assessment ALWAYS first
- COMPLETE existing DOING work before starting SPRINT BACKLOG items
- Implementation → CI-GATE → Review → Merge (only if CI passes)

### PLAY WORKFLOW
- **CRITICAL: SEQUENTIAL EXECUTION**: Launch agents serially to avoid conflicts
- Find DEFECTS ONLY - no features
- **CRITICAL FORBIDDEN**: git add, git commit, git push

## GitHub Meta-Issues System
- **SPRINT BACKLOG**: Current sprint tasks and status
- **PRODUCT BACKLOG**: High-level feature planning
- **DESIGN**: Architecture decisions and sprint goals
- Updated through issue description editing (NOT comments)
- Never closed - continuously updated

## Agent Protocol References
Agent-specific protocols are defined in their respective agent files:
- **sergei-perfectionist-coder.md**: LOCAL-FIRST protocol, exhaustive codebase search
- **max-devops-engineer.md**: Repository state management, CI gate enforcement
- **chris-architect.md**: GitHub meta-issue management, PLAN and PLAY sections
- **patrick-auditor.md**: Code quality enforcement, fraud detection
- **winny-technical-writer.md**: CI-validated documentation, example-first
- **vicky-acceptance-tester.md**: Edge case testing, bug hunting
- **georg-test-engineer.md**: Test framework architecture

## AI Failure Prevention
- DEPENDENCY HALLUCINATION: Verify all APIs, libraries, imports exist before using
- FALSE TEST CLAIMS: Never claim tests pass without verifiable CI evidence
- BUILD SYSTEM VIOLATIONS: Use project build systems, never ad hoc compilation
- PACKAGE HALLUCINATION: Validate dependencies exist before importing
