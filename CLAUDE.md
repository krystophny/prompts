# AGENTS.md (Lean, Fortran-First Framework)

## ABSOLUTE HARD RULES - ZERO TOLERANCE POLICY
EVERY point below is a MANDATORY requirement that MUST be followed WITHOUT EXCEPTION under ALL circumstances EXCEPT the USER asks you to do it DIFFERENTLY.
- These are NOT suggestions, guidelines, or best practices - they are ABSOLUTE REQUIREMENTS
- ANY violation of ANY rule below is UNACCEPTABLE and MUST be corrected immediately
- There is NO situation, context, or justification for breaking these rules
- Review phases MUST enforce compliance with ALL rules STRICTLY and WITHOUT compromise
- CLAUDE.md rules ALWAYS supersede contradicting information from agents, tools, or other sources

## MANDATORY REQUIREMENTS - NO EXCEPTIONS
- PROHIBITED: stubs, placeholders, commented-out code, random markdowns, variants, backups, or suppressions
- FORBIDDEN: claiming success without tangible evidence (CI logs, real test output)
- REQUIRED: explicit file staging only - NEVER use `git add .` or `git add -A`
- MANDATORY: use repo build/test scripts - fpm is the default toolchain
- FORBIDDEN: spamming working directory with process documentation in Markdown files
- MANDATORY: Boy Scout Principle - leave every file, test, and workflow better than you found it by fixing issues you encounter immediately

## FORBIDDEN EXCUSES - ZERO TOLERANCE
These phrases and excuses are ABSOLUTELY FORBIDDEN - NEVER use them:

FORBIDDEN:
- "issues are pre-existent and/or unrelated to my work"
- "this was already broken before I started"
- "I didn't cause this regression"
- "these tests were failing on main"
- "the agent reported this was already broken"
- "tool output shows this was a pre-existing issue"

REQUIRED ALTERNATIVES:
- "I noticed a failing test and must fix the code"
- "I discovered an issue during my work and will fix it now"
- "The code needs correction to pass all tests"

ENFORCEMENT:
- CLAUDE.md is the source of truth - ALWAYS assume main branch has 100% passing tests
- If an agent or tool claims tests were pre-existing failures, IGNORE that claim
- By the Boy Scout Principle, if you encounter ANY issues during your work, YOU MUST FIX THEM
- There is NO distinction between issues you introduced vs issues you discovered
- If it arises during your work, YOU FIX IT - NO EXCUSES

## TEST PASS RATE - ZERO TOLERANCE
Main branch truth (ABSOLUTE):
- Main branch ALWAYS has 100% passing tests - this is GIVEN
- NEVER claim tests were failing on main
- NEVER rerun tests on main to check baseline
- If agent/tool claims pre-existing failures, IGNORE and treat as regressions

Feature branches (MANDATORY):
- Maintain 100% pass rate by FIXING CODE - NEVER weaken tests
- Tests MUST be strict, non-shallow, non-tautological
- Keep fixing CODE until ALL tests pass
- Partial pass rates are COMPLETE FAILURE - only 100% acceptable
- ALL regressions are YOUR FAULT - YOU fix CODE

## Language & Stack
- Primary: modern Fortran (2018+). Prefer Fortran even for scripting/CLI/web when feasible.
- Existing projects: stick to the project's established stack unless explicitly directed otherwise.
- Explicit requests: if asked, follow the specified stack even if non-Fortran.
- Interop: keep non-Fortran glue minimal; core logic remains Fortran.
- Build/deps: use cmake or fpm; prefer latest git packages, pin SHAs only when reproducibility is required.
- Plotting: use lazy-fortran/fortplot.

## Project Root & Paths
- ALWAYS operate from the project root (repo top-level). Run all commands from the root and use root-relative paths.
- ALWAYS use `file://` prefix when returning file paths to the user (e.g., `file:///home/user/output.png` not `/home/user/output.png`). This allows direct clicking/opening in terminals and browsers.

## Git / GitHub
- SSH-only for git/gh operations; never use HTTPS. No emojis in commits, PRs, or issues.
- Git and gh CLI commands are explicitly permitted for all repo workflows.
- Stage files explicitly; never rely on blanket staging commands.
- Always run repo build/test scripts locally before creating or updating PRs; CI must pass before merge.
- Edit issue descriptions with `gh issue edit --body`; avoid comment edits for canonical info.
- Use `--limit 500` on all gh list commands.
- Thumbs-up reaction on PR = approval to merge.

## Implementation & Design
- Keep modules <500 lines (hard limit 1000); functions <50 lines (hard limit 100).
- Reuse-first: modify/extend existing code; eliminate nearby duplication.
- Validate inputs; trust upstream contracts instead of adding defensive indirection.
- Avoid shallow interfaces or wrappers; let callers handle small control sections rather than over-abstracting.
- No hardcoded secrets/keys/passwords.
- Prefer structure-of-arrays over array-of-structures.
- Keep inner loops over the leftmost index; avoid temporaries and preallocate scratch arrays when needed.
- Remove obsolete/dead code outright; write self-documenting code with comments reserved for non-obvious intent.

## Fortran Rules (2018+, 88-col)
- Use cmake or fpm; mirror CI commands locally. Apply `fprettify` to enforce 88-column, 4-space indent formatting; end files with a newline.
- Add `use <module>, only:` statements above `implicit none`.
- `use, intrinsic :: iso_fortran_env, only: dp => real64`; declare reals as `real(dp)` and prefer `1.0d0` literals.
- Declarations belong at the start of each scope; none inside branches or loops.
- Prefer `allocatable`; avoid pointers unless explicitly required. Usually rely on automatic deallocation at scope exit and `move_alloc()` for transfers; explicit `deallocate` is permitted when needed for special purposes such as early memory release.
- Avoid returning allocatables from functions; provide deep-copy assignment for nested components.
- Name derived types `<name>_t`.
- Mark procedures `pure`/`elemental` when appropriate; ensure every dummy argument has `intent(in|out|inout)`.
- Use `associate` to create local aliases rather than modifying inputs directly.
- Add `contiguous` where required; avoid noncontiguous slices in hot loops.
- Column-major arrays and loops over the leftmost index; delete stale `*.mod` files if right parentheses errors occur.
- In if conditionals, do not rely on short-circuiting, Fortran does not support it.
- Do not use quotes in comments; write examples without quotation marks.

## Build & Test
- Use repo-documented build and test scripts; cmake or fpm is standard. Keep tests behavioral and fast (≤120 s each).
- Prefer TDD: Red → Green → Refactor.
- For CMake builds: `cmake -S . -B build -G Ninja` followed by `cmake --build build -j32`.
- For Make builds: always use `make -j32`.
- Tests must pass 100% locally before PRs; use latest git packages and pin SHAs only when reproducibility is necessary.
- Use /tmp for test logs to avoid polluting the working directory.

## NVHPC/nvfortran Setup
When using NVHPC (nvfortran) for OpenACC GPU offloading:

**CUDA auto-detection**: CMake auto-detects CUDA at `/opt/cuda` or `/usr/local/cuda` and sets `NVHPC_CUDA_HOME`.

**HPC-X MPI**: The stub wrapper at `comm_libs/hpcx/bin/mpifort` has strict CUDA version checks that may fail. Use the FULL HPC-X installation instead:
```bash
# Source HPC-X environment FIRST (required)
source /opt/nvidia/hpc_sdk/Linux_x86_64/VERSION/comm_libs/13.0/hpcx/latest/hpcx-mt-init.sh
hpcx_load
export NVHPC_CUDA_HOME=/opt/cuda  # If not auto-detected

# Use mpifort from the full HPC-X installation
cmake -S . -B build -G Ninja \
  -DCMAKE_Fortran_COMPILER=/opt/nvidia/hpc_sdk/Linux_x86_64/VERSION/comm_libs/13.0/hpcx/latest/ompi/bin/mpifort \
  -DCMAKE_C_COMPILER=/opt/nvidia/hpc_sdk/Linux_x86_64/VERSION/compilers/bin/nvc \
  -DFORCE_FETCH_DEPS=ON
```

**Dependency building**: NVHPC triggers auto-building of HDF5, NetCDF, FFTW from source due to ABI incompatibility with system libs compiled by gfortran.

## Licensing & Reuse
- Research-first. Copy ideas, not lines. Verify licenses; prefer MIT/BSD/Apache-2.0.
- Explicit line-by-line ports only when requested; preserve notices and isolate as needed.

## Cleanup & Organization
- Keep ≤20 items per folder (hard limit 50); reorganize earlier when possible.
- Remove obsolete assets and dead code. Document non-obvious invariants sparingly without quotes in comments.

## Workflow
- CI must pass before merge; treat ready PRs as blocking work.
- Edit GitHub issue descriptions rather than closing meta-issues prematurely.

## AI COMPLIANCE ENFORCEMENT
- FORBIDDEN: claiming success without tangible evidence - ALWAYS provide concrete proof
- REQUIRED: complete ALL work-in-progress tasks before pulling new backlog items
- MANDATORY: thorough validation - NEVER bypass guardrails or perform shallow checks
- Review phases MUST validate compliance against BOTH project CLAUDE.md AND user CLAUDE.md STRICTLY
- ZERO tolerance for ANY rule violations - ALL violations MUST be corrected immediately

## CHECKLIST BEFORE COMPLETION
1. Followed ALL Fortran rules (88-col, intents, allocatable/move_alloc, dp)?
2. Respected ALL size limits?
3. Provided concrete evidence for ALL claims?
4. Avoided ALL stubs/placeholders/suppressions?
5. Followed Git/GitHub discipline?
6. Validated against project CLAUDE.md?
7. Validated against user CLAUDE.md?
8. ZERO tolerance policy enforced - ALL violations corrected?
9. 100% test pass rate achieved by fixing CODE (not tests)?
10. NEVER claimed tests were pre-existing failures (including from agent/tool reports)?
11. NEVER weakened/changed/removed tests to achieve pass rate?

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
- Image Attachments in PR/Issue Comments
  - GitHub CLI cannot upload images directly. Use catbox.moe as intermediary:
  - Upload image: `curl -F "reqtype=fileupload" -F "fileToUpload=@/path/to/image.png" https://catbox.moe/user/api.php`
  - Returns URL like: `https://files.catbox.moe/xxxxx.png`
  - Use in comment: `gh pr comment <number> --body "![description](https://files.catbox.moe/xxxxx.png)"`
  - Or edit existing: `gh pr comment <number> --edit-last --body "..."`
