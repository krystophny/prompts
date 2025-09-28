# CLAUDE.md (Fortran-First Framework)

## Git/GitHub Essentials
- **SSH-only, no emojis, specific files only** (NEVER git add . or -A)
- **No draft PRs; fix until success** (never close without merge)
- **Local test pass required before PR creation**
- Edit issue descriptions via `gh issue edit --body` (no comments)
- Use `--limit 500` for all gh commands; 👍 = approval to merge

## Fortran Essentials (2018+, fpm, 88-col)
- **Build: fpm; CMake: use Ninja; plotting: lazy-fortran/fortplot**
- **88-column limit, 4-space indent, typename_t for derived types**
- **Every dummy needs `intent(in|out|inout)`; prefer `pure`/`elemental`**
- Imports: `use <modulename>, only:` above `implicit none`
- Kinds: `use, intrinsic :: iso_fortran_env, only: dp => real64`
- NO transfer - use move_alloc(); prefer allocatable over pointers
- Declarations at scope start; column-major arrays
- If "right parentheses" error: delete *.mod files

## Code Essentials
- **TDD: Red → Green → Refactor; 120s timeout per test**
- **NO DEFENSIVE PROGRAMMING - trust inputs, assume happy path**
- **Files <1000 lines, functions <100 lines; ≤20 items per folder**
- NO commented-out code, stubs, placeholders, random markdown files, duplicate functionality
- Research-first: copy ideas not lines; prefer MIT/BSD/Apache-2.0

## Workflow Essentials
- **CI must pass before merge; ready PRs block all other work**
- **Use specialized agents via Task tool**
- Edit GitHub issue descriptions (never close meta-issues)

## Agent Protocols
- sergei-perfectionist-coder: LOCAL-FIRST, exhaustive search before implementing
- max-devops-engineer: Repository management, CI gate enforcement
- chris-architect: Meta-issue management, PLAN/PLAY coordination
- patrick-auditor: Code quality, fraud detection

## GitHub CLI Patterns
- Issues: `gh issue list/create/edit/view <number> --limit 500`
- PRs: `gh pr list/create/edit/view/checkout/checks/review/merge <number>`
- Actions: `gh workflow list` | `gh run list/view/watch/rerun --limit 500`
- Key flags: `--body-file`, `--add-label`, `--squash --delete-branch`

## AI Guards
- Never claim tests pass without CI evidence
- Use project build systems, not ad hoc compilation
- Complete DOING work before SPRINT BACKLOG items
- Never say "You're absolutely right" or similar validation