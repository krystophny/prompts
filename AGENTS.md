# AGENTS.md (Lean, Fortran-First)

Language & Stack
- Primary: modern Fortran (2018+). Prefer Fortran even for scripting/CLI/web when feasible.
- Existing projects: stick to the project’s established stack unless explicitly directed otherwise.
- Explicit requests: if asked, follow the specified stack even if non-Fortran.
- Interop: keep non-Fortran glue minimal; core logic remains Fortran.
- Build/deps: use fpm; prefer latest git packages, pin SHAs only when reproducibility is required.
- Plotting: use lazy-fortran/fortplot.

Project Root & Paths
- ALWAYS operate from the project root (repo top-level). Run all commands from the root and use root-relative paths to avoid path confusion.

Implementation Standards
- Keep modules reasonably small (<500 lines; hard <1000).
- Functions small and focused (<50 lines; hard <100).
- Reuse-first: modify/extend existing code; eliminate nearby duplication.
- No variants, fallback, or backups. Only one single good implementation.
- No commented-out code, stubs, or placeholders. Validate inputs.
- Data layout/perf: prefer SoA over AoS; column-major arrays; inner loop over leftmost index.
- No hardcoded secrets/keys/passwords.

Fortran Guidelines
- Formatting: 88-column limit (up to 90 with ` &`), 4-space indent, end files with a newline.
- Imports: `use <modulename>, only:`; place above `implicit none`.
- Kinds: `use, intrinsic :: iso_fortran_env, only: dp => real64`; declare reals as `real(dp)`; prefer `1.0d0`/`d`-exponent literals.
- Declarations at start of scope; none inside branches/loops.
- Allocatables: use `move_alloc()`; avoid `transfer`; do not manually deallocate.
- APIs: avoid returning allocatables from functions; implement deep-copy assignment for nested components.
- Types: name derived types `typename_t`.
- fpm: enable autodiscovery for `app`, `test`, and `example` in `fpm.toml`.
- Build hiccup: if “right parentheses” module error occurs, remove stale `*.mod` files.
- Comments: avoid quotes.
- Purity: prefer side-effect–free procedures; mark `pure`/`elemental` when applicable.
- Dummies: every dummy argument must have `intent(in|out|inout)`; use `associate` to create local aliases instead of modifying inputs.
- Contiguity/perf: add `contiguous` where required; avoid noncontiguous slices in hot loops; avoid temporaries; pre-allocate scratch arrays when needed.
- Pointers: prefer `allocatable`; do not use pointers unless explicitly requested.

Build & Tests
- Use repo’s documented build/test scripts and the same commands CI uses.
- CMake builds: always use Ninja.
  - `cmake -S . -B build -G Ninja`
  - `cmake --build build -j`
- Keep tests behavioral and fast; 120s timeout per test.
- Prefer TDD: Red → Green → Refactor.

Git Hygiene
- No emojis in commit messages, PRs, or issues.
- Use git over SSH for all remotes and operations; never use HTTPS.

Licensing & Reuse
- Research-first. Copy ideas, not lines. Verify licenses; prefer MIT/BSD/Apache-2.0.
- Explicit line-by-line ports allowed only when requested; preserve notices and isolate if needed.

Cleanup & Organization
- Remove obsolete/dead code outright.
- Aim for ≤20 items per folder (hard ≤50) before reorganizing.
- Write self-documenting code; use comments sparingly for non-obvious intent/invariants/edges.

GitHub CLI Examples
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
