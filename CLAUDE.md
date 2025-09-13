# CLAUDE.md (QADS Fortran-First Framework)

## Non-Default Git/GitHub Behaviors
- git add specific files only - NEVER git add . or -A
- NO emojis ANYWHERE - not in commit messages, PRs, issues, code, or any output
- NO draft PRs - create ready for review
- NEVER close PRs without merge - fix until success
- NEVER ADD COMMENTS TO ISSUES: edit descriptions via `gh issue edit --body`
- GitHub CLI: ALWAYS use `--limit 500` to avoid truncation (default is 30)
- LOCAL-FIRST: Full test pass REQUIRED before PR creation
- Thumbs up (👍) reaction = approval to merge

## Fortran-Specific
- Primary: modern Fortran (2018+), prefer even for scripting/CLI/web
- Build: fpm; plotting: lazy-fortran/fortplot; CMake: always use Ninja
- 88-column limit (90 with ` &`), 4-space indent, end files with newline
- Imports: `use <modulename>, only:`; above `implicit none`
- Kinds: `use, intrinsic :: iso_fortran_env, only: dp => real64`
- Declarations at start of scope; none inside branches/loops
- typename_t for derived types; NO transfer - use move_alloc()
- NEVER return allocatables from functions; add deep-copy assignment for nested
- Every dummy needs `intent(in|out|inout)`; use `associate` for local aliases
- Prefer `pure`/`elemental`; add `contiguous` where needed; prefer allocatable over pointers
- fpm.toml: autodiscover for app/test/example
- If "right parentheses" error: delete *.mod files
- Column-major arrays: innermost loop over leftmost index; prefer SoA over AoS
- Strings: use trim() - no C-style null termination; avoid quotes in comments

## Non-Default Code Rules
- Files <1000 lines, functions <100 lines; ≤20 items per folder (hard ≤50)
- NO commented-out code, stubs, placeholders; validate inputs
- NO RANDOM MARKDOWN FILES
- NO DUPLICATE FUNCTIONALITY - modify existing files
- NO DEFENSIVE PROGRAMMING - trust inputs, assume happy path
- TDD: Red → Green → Refactor; 120s timeout per test
- Research-first: copy ideas not lines; prefer MIT/BSD/Apache-2.0

## QADS Workflow System (plan | work | play)
- MUST CLASSIFY operations: repository(git/gh/pr) | implementation(code/doc) | build/test | process(workflow/mode)
- DELEGATION: Launch specialized agents via Task tool - respect agent boundaries
- PLAN mode: Architect only, NO git operations, only GitHub issue edits
- WORK mode: Repository → Implementation → CI-GATE → Review → Merge (CI must pass)
- PLAY mode: Serial agent execution, find defects only, NO git operations
- Meta-issues (SPRINT/PRODUCT BACKLOG, DESIGN): edit descriptions, never close
- CI GATE: NEVER merge failing PRs; handback to implementer if CI fails
- READY PRs BLOCK all other work; fix until success

## Agent Protocols (see agent-specific .md files)
- sergei-perfectionist-coder: LOCAL-FIRST, exhaustive search before implementing
- max-devops-engineer: Repository management, CI gate enforcement
- chris-architect: Meta-issue management, PLAN/PLAY coordination
- patrick-auditor: Code quality, fraud detection
- Others: winny, vicky, georg (see respective files)

## AI Failure Prevention
- Verify all imports/APIs exist before using
- Never claim tests pass without CI evidence
- Use project build systems, not ad hoc compilation
- Complete existing DOING work before starting SPRINT BACKLOG items
