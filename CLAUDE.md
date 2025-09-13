# CLAUDE.md (Lean Fortran-First Framework)

## Non-Default Git/GitHub Behaviors
- git add specific files only - NEVER git add . or -A
- NO emojis ANYWHERE - not in commit messages, PRs, issues, code, or any output
- NO draft PRs - create ready for review
- NEVER close PRs without merge - fix until success
- NEVER ADD COMMENTS TO ISSUES: edit descriptions via `gh issue edit --body`
- GitHub CLI: ALWAYS use `--limit 500` to avoid truncation (default is 30)

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

## Workflow Restrictions
- PLAN mode: NO git operations (only GitHub issue edits)
- PLAY mode: NO git operations, find defects only
- Meta-issues (SPRINT/PRODUCT BACKLOG, DESIGN): edit descriptions, never close

## AI Failure Prevention
- Verify all imports/APIs exist before using
- Never claim tests pass without CI evidence
- Use project build systems, not ad hoc compilation
