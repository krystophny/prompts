# AGENTS.md (Lean, Fortran-First Framework)

## 🚨 ABSOLUTE HARD RULES - ZERO TOLERANCE POLICY 🚨
**EVERY point below is a MANDATORY requirement that MUST be followed WITHOUT EXCEPTION under ALL circumstances.**
- These are NOT suggestions, guidelines, or best practices - they are ABSOLUTE REQUIREMENTS
- ANY violation of ANY rule below is UNACCEPTABLE and MUST be corrected immediately
- There is NO situation, context, or justification for breaking these rules
- Review phases MUST enforce compliance with ALL rules STRICTLY and WITHOUT compromise

## MANDATORY REQUIREMENTS - ABSOLUTELY NO EXCEPTIONS
- **PROHIBITED**: stubs, placeholders, commented-out code, random markdowns, variants, backups, or suppressions - NEVER create these under ANY circumstances
- **FORBIDDEN**: claiming success without tangible evidence (CI logs, real test output) - ALWAYS provide proof
- **REQUIRED**: explicit file staging only - NEVER use `git add .` or `git add -A` - ALWAYS stage individual files explicitly
- **MANDATORY**: use repo build/test scripts - fpm is the default toolchain - NO exceptions
- **ABSOLUTELY FORBIDDEN**: spamming working directory with process documentation in Markdown files - NEVER create these
- **MANDATORY**: Boy Scout Principle - leave every file, test, and workflow better than you found it by fixing pre-existing issues you encounter immediately

## 🚨 TEST PASS RATE - ABSOLUTE ZERO TOLERANCE 🚨
**EVERY test MUST pass - NO EXCEPTIONS - NO EXCUSES - NO WAY OUT**

### MAIN BRANCH - SACRED GROUND
- **ASSUME 100% PASS RATE**: Main branch ALWAYS has 100% passing tests - this is GIVEN/ASSUMED
- **NEVER claim tests were failing on main**: ALL failures you see are regressions YOU introduced

### FEATURE BRANCHES - ZERO REGRESSION TOLERANCE
- **MAINTAIN 100% OF EXISTING TESTS**: MUST NOT introduce ANY regressions - existing tests stay green
- **FIX THE CODE UNTIL TESTS PASS**: Achieve 100% pass rate by FIXING CODE - NEVER weaken/change tests
- **TESTS ARE STRICT AND NON-NEGOTIABLE**: Tests MUST be strict, non-shallow, non-tautological - NO tweaking tests to pass
- **WORK UNTIL NEW TESTS PASS 100%**: Keep iterating CODE until ALL tests pass - NO EXCEPTIONS
- **ABSOLUTELY FORBIDDEN**: Partial pass rates (80%, 90%, 99%) are COMPLETE FAILURE - ONLY 100% acceptable
- **NO WAY OUT**: You MUST fix EVERY single CODE failure - NO sugarcoating, NO rationalization, NO bypass
- **FIX ALL REGRESSIONS ALWAYS**: Continue fixing CODE until 100% pass rate achieved - NO stopping until ALL tests green

### ENFORCEMENT
- **ALL REGRESSIONS ARE YOUR FAULT**: YOU broke CODE, YOU fix CODE - NO EXCUSES
- **ZERO EXCUSE TOLERANCE**: Feature branches MUST maintain 100% pass rate by fixing CODE throughout development
- **NEVER WEAKEN TESTS**: ABSOLUTELY FORBIDDEN to achieve pass rate by weakening/changing/removing tests

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
- Column-major arrays and loops over the leftmost index; delete stale `*.mod` files if right parentheses errors occur.
- In if conditionals, do not rely on short-circuiting, Fortran does not support it.
- Do not use quotes in comments; write examples without quotation marks.

## Build & Test
- Use repo-documented build and test scripts; fpm is standard. Keep tests behavioral and fast (≤120 s each).
- **MANDATORY: 100% TEST PASS RATE ON MAIN** - main branch ALWAYS has 100% passing tests - ASSUMED AS GIVEN
- **FEATURE BRANCHES: ZERO REGRESSION TOLERANCE** - MUST maintain 100% pass rate of existing tests throughout development
- **FIX CODE UNTIL TESTS PASS** - achieve 100% by fixing CODE - NEVER weaken/change tests to pass
- **TESTS ARE STRICT**: Tests MUST be strict, non-shallow, non-tautological - NO tweaking tests
- **WORK UNTIL CODE PASSES 100%** - keep fixing CODE in feature branch until ALL tests pass - NO EXCEPTIONS
- **CRITICAL: ALL test regressions are YOUR FAULT** - YOU broke CODE, YOU fix CODE - NO EXCUSES
- **ZERO EXCUSE TOLERANCE: NEVER claim tests were failing before** - ALL failures are CODE regressions YOU introduced
- **ABSOLUTELY FORBIDDEN: Partial pass rates (80%, 90%, 99%)** - COMPLETE FAILURE - ONLY 100% acceptable - NO WAY OUT
- **NEVER WEAKEN TESTS**: ABSOLUTELY FORBIDDEN to achieve pass rate by weakening/changing/removing tests
- Prefer TDD: Red → Green → Refactor.
- For CMake builds: `cmake -S . -B build -G Ninja` followed by `cmake --build build -j`.
- Tests must pass 100% locally before PRs; use latest git packages and pin SHAs only when reproducibility is necessary.

## Licensing & Reuse
- Research-first. Copy ideas, not lines. Verify licenses; prefer MIT/BSD/Apache-2.0.
- Explicit line-by-line ports only when requested; preserve notices and isolate as needed.

## Cleanup & Organization
- Keep ≤20 items per folder (hard limit 50); reorganize earlier when possible.
- Remove obsolete assets and dead code. Document non-obvious invariants sparingly without quotes in comments.

## Workflow
- CI must pass before merge; treat ready PRs as blocking work.
- Edit GitHub issue descriptions rather than closing meta-issues prematurely.

## AI COMPLIANCE ENFORCEMENT - MANDATORY FOR ALL OPERATIONS
- **ABSOLUTELY FORBIDDEN**: claiming success without tangible evidence - ALWAYS provide concrete proof
- **REQUIRED**: complete ALL work-in-progress tasks before pulling new backlog items - NO exceptions
- **MANDATORY**: thorough validation - NEVER bypass guardrails or perform shallow checks
- **CRITICAL**: Review phases MUST validate compliance against BOTH project CLAUDE.md AND user CLAUDE.md/AGENTS.md STRICTLY
- **REQUIRED**: ZERO tolerance for ANY rule violations - ALL violations MUST be corrected immediately

## MANDATORY COMPLIANCE VALIDATION - MUST PASS BEFORE COMPLETION
**EVERY item below MUST be validated and PASS before ANY task completion:**
1. **MANDATORY**: Followed ALL Fortran rules (fpm, 88-col, intents, allocatable/move_alloc, dp) WITHOUT exception?
2. **REQUIRED**: Respected ALL size limits WITHOUT compromise?
3. **CRITICAL**: Provided concrete evidence for ALL claims?
4. **ABSOLUTELY REQUIRED**: Avoided ALL stubs/placeholders/suppressions COMPLETELY?
5. **MANDATORY**: Followed Git/GitHub discipline STRICTLY?
6. **CRITICAL**: Validated against project CLAUDE.md/AGENTS.md STRICTLY?
7. **REQUIRED**: Validated against user CLAUDE.md/AGENTS.md STRICTLY?
8. **MANDATORY**: ZERO tolerance policy enforced - ALL violations corrected?
9. **CRITICAL: 100% TEST PASS RATE ACHIEVED BY FIXING CODE** - ALL tests passing (existing AND new) - achieved by fixing CODE not tests - NO exceptions - NO partial pass rates?
10. **ZERO EXCUSE ENFORCEMENT** - NEVER claimed tests were failing before - maintained 100% by fixing CODE - worked until CODE passes all tests 100%?
11. **ZERO REGRESSION TOLERANCE** - MUST NOT introduce ANY CODE regressions in feature branches - existing tests MUST stay green throughout?
12. **TESTS REMAIN STRICT** - NEVER weakened/changed/removed tests to achieve pass rate - tests stayed strict, non-shallow, non-tautological?

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
