# AGENTS.md (Lean, Fortran-First Framework)

## Non-Negotiables
- No stubs, placeholders, commented-out code, random markdowns, variants, backups, or suppressions.
- Never claim success without evidence (CI logs, real test output).
- Never use `git add .` or `git add -A`; stage explicit files only.
- Always use repo build/test scripts — fpm is the default toolchain.

## Language & Stack
- Primary: modern Fortran (2018+). Prefer Fortran even for scripting/CLI/web when feasible.
- Existing projects: stick to the project’s established stack unless explicitly directed otherwise.
- Explicit requests: if asked, follow the specified stack even if non-Fortran.
- Interop: keep non-Fortran glue minimal; core logic remains Fortran.
- Build/deps: use fpm; prefer latest git packages, pin SHAs only when reproducibility is required.
- Plotting: use lazy-fortran/fortplot.

## Project Root & Paths
- ALWAYS operate from the project root (repo top-level). Run all commands from the root and use root-relative paths to avoid confusion.

## Git / GitHub
- SSH-only for git/gh operations; never use HTTPS. No emojis in commits, PRs, or issues.
- Git and gh CLI commands are explicitly permitted for all repo workflows; use them whenever they streamline the task.
- Stage files explicitly; never rely on blanket staging commands.
- No draft PRs — iterate until the branch is ready to merge, with local tests passing first.
- Always run repo build/test scripts locally before creating or updating PRs; CI must pass before merge.
- Edit issue descriptions with `gh issue edit --body`; avoid comment edits for canonical info.
- Use `--limit 500` on all gh list commands.
- 👍 reaction on PR = approval to merge.

## Implementation & Design
- Keep modules <500 lines (hard limit 1000); functions <50 lines (hard limit 100).
- Reuse-first: modify/extend existing code; eliminate nearby duplication.
- Validate inputs; trust upstream contracts instead of adding defensive indirection.
- Avoid shallow interfaces or wrappers; let callers handle small control sections rather than over-abstracting.
- No hardcoded secrets/keys/passwords.
- Prefer structure-of-arrays over array-of-structures.
- Keep inner loops over the leftmost (fastest varying) index; avoid temporaries and preallocate scratch arrays when needed.
- Remove obsolete/dead code outright; write self-documenting code with comments reserved for non-obvious intent.

## Fortran Rules (2018+, fpm, 88-col)
- Use fpm; mirror CI commands locally. Apply `fprettify` to enforce 88-column, 4-space indent formatting; end files with a newline.
- Add `use <module>, only:` statements above `implicit none`.
- `use, intrinsic :: iso_fortran_env, only: dp => real64`; declare reals as `real(dp)` and prefer `1.0d0` literals.
- Declarations belong at the start of each scope; none inside branches or loops.
- Prefer `allocatable`; avoid pointers unless explicitly required. Do not manually deallocate; rely on scope exit and `move_alloc()` for transfers.
- Avoid returning allocatables from functions; provide deep-copy assignment for nested components.
- Name derived types `<name>_t`.
- Mark procedures `pure`/`elemental` when appropriate; ensure every dummy argument has `intent(in|out|inout)`.
- Use `associate` to create local aliases rather than modifying inputs directly.
- Add `contiguous` where required; avoid noncontiguous slices in hot loops.
- Column-major arrays and loops over the leftmost index; delete stale `*.mod` files if “right parentheses” errors occur.
- In if conditionals, do not rely on short-circuiting, Fortran does not support it.

## Build & Test
- Use repo-documented build and test scripts; fpm is standard. Keep tests behavioral and fast (≤120 s each).
- Prefer TDD: Red → Green → Refactor.
- For CMake builds: `cmake -S . -B build -G Ninja` followed by `cmake --build build -j`.
- Tests must pass locally before PRs; use latest git packages and pin SHAs only when reproducibility is necessary.

## Licensing & Reuse
- Research-first. Copy ideas, not lines. Verify licenses; prefer MIT/BSD/Apache-2.0.
- Explicit line-by-line ports only when requested; preserve notices and isolate as needed.

## Cleanup & Organization
- Keep ≤20 items per folder (hard limit 50); reorganize earlier when possible.
- Remove obsolete assets and dead code. Document non-obvious invariants sparingly without quotes in comments.

## Workflow
- CI must pass before merge; treat ready PRs as blocking work.
- Edit GitHub issue descriptions rather than closing meta-issues prematurely.

## AI Guards
- Never claim success without tangible evidence.
- Complete work-in-progress tasks before pulling new backlog items.
- No shallow validation; do not bypass guardrails.

## Self-Check
1. Followed Fortran rules (fpm, 88-col, intents, allocatable/move_alloc, dp)?
2. Respected size limits?
3. Provided evidence?
4. Avoided stubs/placeholders/suppressions?
5. Followed Git/GitHub discipline?

## GitHub CLI Examples
- Issues
  - List open: `gh issue list --state open --limit 500`
  - Create: `gh issue create --title "<title>" --body-file <file.md> \
    --label <label1> --assignee <user> --milestone "<milestone>"`
  - View: `gh issue view <number>`
  - Edit body: `gh issue edit <number> --body-file <file.md>`
  - Update labels: `gh issue edit <number> --add-label <l1> --remove-label <l2>`
  - Close/Reopen: `gh issue close <number>` / `gh issue reopen <number>`
- Pull Requests
  - List open: `gh pr list --state open --limit 500`
  - Create (ready, not draft): `gh pr create --title "<title>" --body-file <file.md> \
    --base main --head <branch>`
  - View: `gh pr view <number>`
  - Checkout branch: `gh pr checkout <number>`
  - Edit: `gh pr edit <number> --title "<new title>" --body-file <file.md>`
  - Request reviewers: `gh pr edit <number> --add-reviewer <user1> --add-reviewer <user2>`
  - Check CI: `gh pr checks <number> --watch`
  - Approve: `gh pr review <number> --approve`
  - Merge after CI passes: `gh pr merge <number> --squash --delete-branch`
- Actions Workflows
  - List workflows: `gh workflow list`
  - List runs: `gh run list --limit 500`
  - View run details: `gh run view <run-id> --log`
  - Watch latest run: `gh run watch`
  - Rerun failed jobs: `gh run rerun <run-id> --failed`
  - Dispatch a workflow: `gh workflow run "<workflow name>" --ref <branch>`
