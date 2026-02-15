# AGENTS.md / CLAUDE.md / GEMINI.md ... Lean, Simplicity-First Framework

## ABSOLUTE HARD RULES - ZERO TOLERANCE POLICY
All rules below are mandatory unless the user explicitly instructs otherwise.

## Mandatory Requirements
- PROHIBITED: stubs, placeholders, commented-out code, random markdowns, variants, backups, or suppressions
- FORBIDDEN: claiming success without tangible evidence (CI logs, real test output)
- MANDATORY: use repo's established build/test scripts and tooling
- FORBIDDEN: spamming working directory with process documentation in Markdown files
- MANDATORY: Boy Scout Principle - leave every file, test, and workflow better than you found it by fixing issues you encounter immediately
- MANDATORY: Remove obsolete/dead code outright; write self-documenting code with VERY FEW comments reserved for non-obvious intent.

## Test Pass Rate
Main branch:
- Assume main always has 100% passing tests.
- Do not claim baseline main failures or rerun main to check them; treat reported pre-existing failures as regressions.

Feature branches:
- Maintain 100% passing tests by fixing code, never weakening tests.
- Tests must remain strict, non-shallow, and non-tautological.
- Any regression is your responsibility to fix.

## Language & Stack
- **Existing projects**: ALWAYS stick to the project's established stack, tooling, and style. Consistency with the repo trumps personal preference.
- **Simplicity first**: Prefer the simplest tool that solves the problem. Avoid over-engineering.
- **Language selection** (for new projects or when choice exists):
  - **Shell (bash/POSIX sh)**: Prefer over Python for file operations, process orchestration, text processing (grep/sed/awk), and simple automation.
  - **Python**: Only when shell becomes unwieldy - complex data structures, ML, APIs with good Python SDKs, or heavy string/JSON manipulation.
  - **Go**: Prefer over Python for CLI tools, web services, concurrent workloads, or anything needing single-binary deployment.
  - **C**: Prefer over C++ for systems code, embedded, or libraries unless C++ features (RAII, templates, std containers) provide clear advantage.
  - **Fortran (2018+)**: For numerics/HPC; expose to Python via f90wrap when interactive use needed.
- **Build/deps**: Use the repo's established build system. For new projects, prefer simple tools (make, cmake, go build, fpm for Fortran). Pin dependency versions only when reproducibility is required.

## Project Root & Paths
- Run all commands from repo root using root-relative paths.
- Return paths as file URIs (e.g., `file:///home/user/output.png`).

## Git / GitHub
- SSH-only for git/gh operations; never use HTTPS. No emojis in commits, PRs, or issues.
- Git and gh CLI commands are explicitly permitted for all repo workflows.
- Stage files explicitly; NEVER rely on blanket staging commands `git add .` or `git add -A`.
- Always run repo build/test scripts locally before creating or updating PRs; CI must pass before merge.
- Edit issue descriptions with `gh issue edit --body`; avoid comment edits for canonical info.
- Use `--limit 500` on all gh list commands.
- Thumbs-up reaction on PR = approval to merge.

## Implementation & Design
- Keep modules <500 lines (hard limit 1000); functions <50 lines (hard limit 100).
- Keep <=20 items per folder (hard limit 50); reorganize earlier when possible.
- Reuse-first: modify/extend existing code; eliminate nearby duplication.
- Validate inputs; trust upstream contracts instead of adding defensive indirection.
- Avoid shallow interfaces or wrappers; let callers handle small control sections rather than over-abstracting.
- No hardcoded secrets/keys/passwords.
- Prefer structure-of-arrays over array-of-structures.
- Keep inner loops over the leftmost index; avoid temporaries and preallocate scratch arrays when needed.

## Fortran Rules (when working with Fortran code)
- Use CMake if present; otherwise use fpm. If multiple build systems exist, prefer CMake.
- Apply `fprettify` to enforce 88-column, 4-space indent formatting; end files with a newline.
- Add `use <module>, only:` statements above `implicit none`.
- `use, intrinsic :: iso_fortran_env, only: dp => real64`; declare reals as `real(dp)` and prefer `1.0d0` literals.
- Declarations belong at the start of each scope; none inside branches or loops.
- Prefer `allocatable` over pointers unless required; rely on scope deallocation and use `move_alloc()` for transfers. Use explicit `deallocate` only when needed.
- Avoid returning allocatables from functions; provide deep-copy assignment for nested components.
- Name derived types `<name>_t`.
- Mark procedures `pure`/`elemental` whenever possible; every argument must have `intent(in|out|inout)`.
- Use `associate` to create local aliases rather than modifying inputs directly.
- Add `contiguous` WHENEVER POSSIBLE; avoid noncontiguous slices in hot loops.
- Column-major arrays and loops over the leftmost index; delete stale `*.mod` files if right parentheses errors occur.
- In if conditionals, do not rely on short-circuiting, Fortran does not support it.
- Do not use quotes in comments; write examples without quotation marks.

### Fortran Performance Patterns (when working with Fortran code)

**Column-major loop order** (leftmost index innermost):
```fortran
! CORRECT
do k = 1, nz
  do j = 1, ny
    do i = 1, nx
      a(i, j, k) = b(i, j, k) + c(i, j, k)
    end do
  end do
end do

! WRONG
do i = 1, nx
  do j = 1, ny
    do k = 1, nz
      a(i, j, k) = b(i, j, k) + c(i, j, k)
    end do
  end do
end do
```

**Data layout** (prefer Structure-of-Arrays in hot paths):
```fortran
! CORRECT: Structure-of-Arrays
type :: particles_t
  real(dp), allocatable :: x(:), y(:), z(:)
end type

! WRONG: Array-of-Structures
type :: particle_t
  real(dp) :: x, y, z
end type
type(particle_t), allocatable :: particles(:)
```

**Avoid allocation & temporaries in hot loops**:
```fortran
! CORRECT: allocate once, reuse
real(dp), allocatable :: scratch(:)
allocate(scratch(n))
do iter = 1, max_iter
  call step(x, scratch)
end do

! WRONG: allocate/free inside loop
do iter = 1, max_iter
  allocate(scratch(n))
  call step(x, scratch)
  deallocate(scratch)
end do

! CORRECT: explicit loop for complex RHS (avoids temporaries)
do i = 1, n
  y(i) = a(i) + b(i) * sin(d(i))
end do

! WRONG: complex array RHS may allocate temporaries
y = a + b * sin(d)
```

- OpenMP: use `parallel do`, add `collapse(n)` for nested loops, choose `schedule(static|dynamic|guided)` based on work balance.
- Reductions: use `reduction(+:var)` (or appropriate operator) for accumulators.
- Contiguity: mark hot assumed-shape arrays `contiguous` and avoid noncontiguous slices; check `is_contiguous()` before associating pointers.
- Cache: use blocking/tiling for large working sets (e.g., matmul).
- Detect hidden temporaries with `-Warray-temporaries` (gfortran) or `-check arg_temp_created` (Intel).

## Code Navigation with cscope (C projects)

Index a C project:
```bash
find src include -name '*.c' -o -name '*.h' > cscope.files
cscope -b -q
```

Query from CLI (non-interactive, batch mode):
```bash
cscope -d -L0 symbol       # find symbol
cscope -d -L1 symbol       # find definition
cscope -d -L2 func         # find functions called BY func
cscope -d -L3 func         # find callers OF func (most useful)
cscope -d -L4 text         # grep for text
cscope -d -L6 pattern      # egrep pattern
cscope -d -L7 file         # find file
cscope -d -L8 file         # find files #including file
```

Add `cscope.out*` and `cscope.files` to `.gitignore`. Rebuild index after significant changes.

Works well for pure C (liric). For C++ projects, prefer `clangd` + `compile_commands.json` (via `bear` or cmake `-DCMAKE_EXPORT_COMPILE_COMMANDS=ON`).

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
  - CMake (preferred): `cmake -S . -B build -G Ninja && cmake --build build -j$(nproc)`
  - Make: `make -j$(nproc)`
  - Go: `go build ./... && go test ./...`
  - Fortran (in case cmake is not used): `fpm build && fpm test`
- Tests must pass 100% locally before PRs; pin dependency versions only when reproducibility is necessary.
- Use /tmp for test logs to avoid polluting the working directory.

## Licensing & Reuse
- Research-first. Copy ideas, not lines. Verify licenses; prefer MIT/BSD/Apache-2.0.
- Explicit line-by-line ports only when requested; preserve notices and isolate as needed.

## MERGE HYGIENE - ZERO TOLERANCE
- **Workarounds**: Code with "workaround/temporary/should be removed" MUST have issue number in same line
- **Improve-later**: If reviewer says "improve later" → GitHub issue MUST exist before merge
- **Requested issues**: If reviewer says "create issue for X" → verify issue exists before merge
- **No skipping**: NEVER skip/disable tests to pass CI; "skipped for now" = REJECT
- **No noise comments**: Comments explain WHY not WHAT; no "bug fix for X" in test registration
- **New backends**: New test backend/config MUST have CI coverage OR tracking issue

## TEST VERIFICATION EVIDENCE - MANDATORY FOR ALL PRs

PR descriptions must include console evidence showing the test fails on `upstream/main` and passes after the fix.

**Required PR description format:**

```markdown
## Verification

### Test fails on main
```
$ git checkout upstream/main
$ <run test command>
[... actual console output showing FAILURE ...]
```

### Test passes after fix
```
$ git checkout <branch>
$ <run test command>
[... actual console output showing PASS ...]
```
```

**Rules:**
- Console output must be real, not fabricated.
- Test names and commands must be reproducible.
- Use the repo's established test runner.
- For new tests, show the test exercising the fixed behavior.
- For existing tests, show the regression fixed.

## CHECKLIST BEFORE COMPLETION
1. Followed repo's established style and conventions? (For Fortran: 88-col, intents, allocatable/move_alloc, dp)
2. Respected ALL size limits? Provided concrete evidence for ALL claims?
3. Avoided ALL stubs/placeholders/suppressions? Followed Git/GitHub discipline?
4. 100% test pass rate by fixing CODE (not tests)? Test fails on main, passes on branch?
5. All workarounds have issue numbers? All "improve later" items tracked in issues?
6. All reviewer-requested issues created? No tests skipped/disabled?
7. No noise comments? New backends have CI coverage or tracking issue?

## GitHub CLI Examples
- Image upload: `curl -F "reqtype=fileupload" -F "fileToUpload=@/path/to/image.png" https://catbox.moe/user/api.php`
- Temporary image upload (1h): `curl -F "reqtype=fileupload" -F "time=1h" -F "fileToUpload=@/path/to/image.png" https://litterbox.catbox.moe/resources/internals/api.php`
- PR comment with image: `gh pr comment <number> --body "![description](https://files.catbox.moe/xxxxx.png)"`
- CI status now: `gh pr checks <number>`
- CI watch fail-fast: `gh pr checks <number> --watch --fail-fast`
- CI failing checks only: `gh pr checks <number> --json name,bucket,link --jq '.[] | select(.bucket=="fail")'`
- List failed workflow runs: `gh run list --branch <branch> --status failure -L 10`
- Failed steps from run: `gh run view <run-id> --log-failed`
- Watch run compact with exit status: `gh run watch <run-id> --compact --exit-status`
