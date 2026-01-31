# AGENTS.md (Lean, Simplicity-First Framework)

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
- MANDATORY: use repo's established build/test scripts and tooling
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
- **Existing projects**: ALWAYS stick to the project's established stack, tooling, and style. Consistency with the repo trumps personal preference.
- **Simplicity first**: Prefer the simplest tool that solves the problem. Avoid over-engineering.
- **Language selection** (for new projects or when choice exists):
  - **Shell (bash/POSIX sh)**: Prefer over Python for file operations, process orchestration, text processing (grep/sed/awk), and simple automation.
  - **Python**: Only when shell becomes unwieldy - complex data structures, ML, APIs with good Python SDKs, or heavy string/JSON manipulation.
  - **Go**: Prefer over Python for CLI tools, web services, concurrent workloads, or anything needing single-binary deployment.
  - **C**: Prefer over C++ for systems code, embedded, or libraries unless C++ features (RAII, templates, std containers) provide clear advantage.
  - **Fortran (2018+)**: For numerics/HPC; expose to Python via f90wrap when interactive use needed.
- **Tool selection** (prefer simpler options):
  - **Make** over CMake/Meson when plain Make suffices
  - **SQLite** over PostgreSQL/MySQL for local or embedded storage
  - **Static HTML/CSS** over JS frameworks for simple pages
  - **curl/wget** in shell over HTTP libraries for simple requests
  - **cron** over complex schedulers for periodic tasks
  - **rsync** over custom sync solutions
  - **Standard library** over external dependencies when possible
- **Avoid**: TypeScript when JS suffices, Rust when C/Go suffices, YAML when JSON works, ORMs when raw SQL is clearer, microservices when a monolith works.
- **Build/deps**: Use the repo's established build system. For new projects, prefer simple tools (make, cmake, go build, fpm for Fortran). Pin dependency versions only when reproducibility is required.

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

## Fortran Rules (when working with Fortran code)
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

## Fortran Performance Patterns (when working with Fortran code)

**Column-major loop order** - leftmost index innermost for cache efficiency:
```fortran
! CORRECT: row (i) varies fastest in inner loop
do k = 1, nz
    do j = 1, ny
        do i = 1, nx
            a(i, j, k) = b(i, j, k) + c(i, j, k)
        end do
    end do
end do

! WRONG: column-major violation, cache thrashing
do i = 1, nx
    do j = 1, ny
        do k = 1, nz
            a(i, j, k) = b(i, j, k) + c(i, j, k)
        end do
    end do
end do
```

**Structure-of-Arrays (SoA)** - keeps data contiguous per field:
```fortran
! CORRECT: Structure-of-Arrays
type :: particles_t
    real(dp), allocatable :: x(:), y(:), z(:)
    real(dp), allocatable :: vx(:), vy(:), vz(:)
    real(dp), allocatable :: mass(:)
end type

! WRONG: Array-of-Structures, poor cache utilization
type :: particle_t
    real(dp) :: x, y, z, vx, vy, vz, mass
end type
type(particle_t), allocatable :: particles(:)
```

**OpenMP parallel loops** - collapse for nested loops, schedule for load balance:
```fortran
! static: uniform work per iteration, minimal overhead
!$omp parallel do collapse(2) private(i, j, k) schedule(static)
do k = 1, nz
    do j = 1, ny
        do i = 1, nx
            a(i, j, k) = b(i, j, k) * factor
        end do
    end do
end do
!$omp end parallel do

! dynamic: variable work per iteration, better load balance
!$omp parallel do schedule(dynamic, 16) private(i)
do i = 1, n
    call variable_cost_work(i)
end do
!$omp end parallel do

! guided: decreasing chunk sizes, good for unknown load patterns
!$omp parallel do schedule(guided) private(i)
do i = 1, n
    call unpredictable_work(i)
end do
!$omp end parallel do
```

**OpenMP reduction** - for accumulating values:
```fortran
total = 0.0d0
!$omp parallel do reduction(+:total) private(i)
do i = 1, n
    total = total + x(i) * y(i)
end do
!$omp end parallel do
```

**Contiguous arrays** - required for assumed-shape in hot paths:
```fortran
subroutine process_field(field, nx, ny, nz)
    integer, intent(in) :: nx, ny, nz
    real(dp), intent(inout), contiguous :: field(:,:,:)
    integer :: i, j, k

    !$omp parallel do collapse(2) private(i, j, k)
    do k = 1, nz
        do j = 1, ny
            do i = 1, nx
                field(i, j, k) = field(i, j, k) * 2.0d0
            end do
        end do
    end do
    !$omp end parallel do
end subroutine

! Runtime check before assigning non-contiguous data
if (is_contiguous(array_slice)) then
    contiguous_ptr => array_slice
end if
```
Prefer `allocatable` over `pointer` - pointers risk aliasing and force compiler temporaries.

**Preallocated scratch arrays** - avoid allocation in hot loops:
```fortran
! CORRECT: allocate once, reuse
real(dp), allocatable :: scratch(:)
allocate(scratch(n))
do iter = 1, max_iter
    call compute_step(data, scratch, n)
end do

! WRONG: allocation inside loop
do iter = 1, max_iter
    allocate(scratch(n))
    call compute_step(data, scratch, n)
    deallocate(scratch)
end do
```

**Loop blocking/tiling** - for matmul and large arrays exceeding cache:
```fortran
! Matrix multiply: j-k-i order keeps B(k,j) in cache, A(i,k) stride-1
do j = 1, n
    do k = 1, n
        do i = 1, n
            c(i, j) = c(i, j) + a(i, k) * b(k, j)
        end do
    end do
end do

! Blocked version for large matrices
integer, parameter :: bs = 64
do jj = 1, n, bs
    do kk = 1, n, bs
        do j = jj, min(jj + bs - 1, n)
            do k = kk, min(kk + bs - 1, n)
                do i = 1, n
                    c(i, j) = c(i, j) + a(i, k) * b(k, j)
                end do
            end do
        end do
    end do
end do
```

**Array syntax vs explicit loops** - simple ops vectorize well, complex RHS may create temporaries:
```fortran
! GOOD: simple array syntax vectorizes efficiently
c = a + b
y = y + alpha * x

! RISKY: complex RHS may allocate temporary arrays
! Compiler must evaluate entire RHS before assignment
c = a + b * sin(d) + e * exp(f)  ! up to 3 temporaries possible

! SAFER for complex expressions: explicit loop avoids temporaries
do i = 1, n
    c(i) = a(i) + b(i) * sin(d(i)) + e(i) * exp(f(i))
end do
```
Use `-check arg_temp_created` (Intel) or `-Warray-temporaries` (gfortran) to detect hidden temporaries.

## Profiling (MANDATORY before optimization)

| Tool | Platform | Command |
|------|----------|---------|
| gprof | Linux/macOS | `gfortran -pg -g -O2 app.f90 && ./a.out && gprof ./a.out gmon.out` |
| sample | macOS | `sample ./app 5 -file /tmp/sample.txt` |
| perf | Linux | `perf record -F 99 -g ./app && perf report --stdio` |
| callgrind | Linux | `valgrind --tool=callgrind ./app && callgrind_annotate callgrind.out` |

**Hotspot diagnosis**: malloc/free → preallocate; cache misses → fix loop order; memcpy → explicit loops; low IPC → blocking/tiling

## Build & Test
- Use repo-documented build and test scripts. Keep tests behavioral and fast (≤120 s each).
- Prefer TDD: Red → Green → Refactor.
- Common build patterns:
  - CMake: `cmake -S . -B build -G Ninja && cmake --build build -j$(nproc)`
  - Make: `make -j$(nproc)`
  - Go: `go build ./... && go test ./...`
  - Fortran (fpm): `fpm build && fpm test`
- Tests must pass 100% locally before PRs; pin dependency versions only when reproducibility is necessary.
- Use /tmp for test logs to avoid polluting the working directory.

## NVHPC/nvfortran Setup (for Fortran GPU work)
For OpenACC GPU offloading: source HPC-X environment first (`hpcx-mt-init.sh && hpcx_load`), use full HPC-X `mpifort` (not stub wrapper), set `NVHPC_CUDA_HOME` if needed. NVHPC auto-builds HDF5/NetCDF/FFTW due to ABI incompatibility with gfortran-compiled libs.

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

## MERGE HYGIENE - ZERO TOLERANCE
- **Workarounds**: Code with "workaround/temporary/should be removed" MUST have issue number in same line
- **Improve-later**: If reviewer says "improve later" → GitHub issue MUST exist before merge
- **Requested issues**: If reviewer says "create issue for X" → verify issue exists before merge
- **No skipping**: NEVER skip/disable tests to pass CI; "skipped for now" = REJECT
- **No noise comments**: Comments explain WHY not WHAT; no "bug fix for X" in test registration
- **Test validity**: Test MUST fail on main AND pass on branch; identical behavior = invalid test
- **New backends**: New test backend/config MUST have CI coverage OR tracking issue

## CHECKLIST BEFORE COMPLETION
1. Followed repo's established style and conventions? (For Fortran: 88-col, intents, allocatable/move_alloc, dp)
2. Respected ALL size limits? Provided concrete evidence for ALL claims?
3. Avoided ALL stubs/placeholders/suppressions? Followed Git/GitHub discipline?
4. 100% test pass rate by fixing CODE (not tests)? Test fails on main, passes on branch?
5. All workarounds have issue numbers? All "improve later" items tracked in issues?
6. All reviewer-requested issues created? No tests skipped/disabled?
7. No noise comments? New backends have CI coverage or tracking issue?

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
