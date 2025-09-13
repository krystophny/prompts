# CLAUDE.md (Lean Fortran-First Framework)

## Non-Default Git/GitHub Behaviors
- git add specific files only - NEVER git add . or -A
- NO emojis in commit messages, PRs, issues
- NO draft PRs - create ready for review
- NEVER close PRs without merge - fix until success
- NEVER ADD COMMENTS TO ISSUES: edit descriptions via `gh issue edit --body`
- GitHub CLI: ALWAYS use `--limit 500` to avoid truncation (default is 30)

## Fortran-Specific
- Primary: modern Fortran (2018+), prefer even for scripting/CLI/web
- Build: fpm; plotting: lazy-fortran/fortplot
- Imports: `use <modulename>, only:`; above `implicit none`
- Kinds: `use, intrinsic :: iso_fortran_env, only: dp => real64`
- typename_t for derived types; NO transfer - use move_alloc()
- NEVER return allocatables from functions
- fpm.toml: autodiscover for app/test/example
- If "right parentheses" error: delete *.mod files
- Column-major arrays: innermost loop over leftmost index
- Strings: use trim() - no C-style null termination

## Non-Default Code Rules
- NO RANDOM MARKDOWN FILES
- NO DUPLICATE FUNCTIONALITY - modify existing files
- NO DEFENSIVE PROGRAMMING - trust inputs, assume happy path

## Workflow Restrictions
- PLAN mode: NO git operations (only GitHub issue edits)
- PLAY mode: NO git operations, find defects only
- Meta-issues (SPRINT/PRODUCT BACKLOG, DESIGN): edit descriptions, never close

## AI Failure Prevention
- Verify all imports/APIs exist before using
- Never claim tests pass without CI evidence
- Use project build systems, not ad hoc compilation
