# AGENTS.md / CLAUDE.md / GEMINI.md ... Lean, Simplicity-First Framework

## Non-Negotiables
All rules below are mandatory unless the user explicitly instructs otherwise.

- Prohibited: stubs, placeholders, commented-out code, random markdown, variants, backups, suppressions.
- Forbidden: claiming success without tangible evidence (CI logs, real test output).
- Mandatory: use the repo's established build/test scripts and tooling.
- Forbidden: spamming the working directory with process markdown files.
- Mandatory: follow the Boy Scout Principle; leave files/tests/workflows better than you found them.
- Mandatory: remove dead/obsolete code; prefer self-documenting code with minimal comments for non-obvious intent.
- When asked to change code or tidy up, you are explicitly allowed and encouraged to change not only internals but also public-facing APIs, and aggressively prune legacy variants unless the user requests backward compatibility.

## Test Failures

Any failing test you encounter MUST be fixed immediately by correcting the code. No exceptions.

Forbidden actions:
- NEVER check out main/upstream to compare test results.
- NEVER run tests on another branch to establish a "baseline."
- NEVER use the words "pre-existing", "unrelated", "baseline", or "flaky" to describe a failing test.
- NEVER skip, disable, weaken, or delete a failing test.
- NEVER dismiss failures with "N pre-existing failures" or "unrelated to this change."
- NEVER claim a failure exists on main — you have not checked and you will not check.

Required actions:
- When tests fail, fix the code until they pass. All of them.
- Partial pass rates are failure. 98/100 passing = failure.
- Keep fixing until the test runner reports zero failures.
- Tests must be strict, non-shallow, and non-tautological.

## Language and Stack
- Existing projects: match the repo's stack, tooling, and style.
- Simplicity first: use the simplest tool that solves the problem.
- Language preference when choice exists:
  - Shell (bash/POSIX sh) over Python for file/process/text automation.
  - Python when shell becomes unwieldy (complex data, ML, API SDKs, heavy JSON/string work).
  - Go over Python for CLIs, services, concurrency, and single-binary deployment.
  - C over C++ unless C++ features clearly justify it.
  - Fortran (2023+) for numerics/HPC; expose via f90wrap when interactive use is needed.
- Build/deps: use the repo's build system. For new projects prefer make/cmake/go build/fpm; pin versions only when reproducibility requires it.

## Project Root and Paths
- Run all commands from repo root using root-relative paths.
- Return file paths as `file://` URIs (for example `file:///home/user/output.png`).

## Git and GitHub
- Use SSH only for git/gh; never HTTPS. No emojis in commits, PRs, or issues.
- Git and gh CLI are permitted for repo workflows.
- Stage files explicitly; never use blanket staging (`git add .`, `git add -A`).
- Run local build/tests before creating/updating PRs; CI must pass before merge.
- Update canonical issue descriptions with `gh issue edit --body` (not comment edits).
- Use `--limit 500` on all gh list commands.
- A thumbs-up reaction on a PR equals merge approval.

## Implementation and Design
- Keep modules <500 lines (hard limit 1000); functions <50 lines (hard limit 100).
- Keep <=20 items per folder (hard limit 50); reorganize early.
- Reuse first: modify/extend existing code and remove duplication.
- Validate inputs; trust upstream contracts instead of defensive indirection.
- Avoid shallow wrappers/interfaces.
- Never hardcode secrets/keys/passwords.
- Prefer structure-of-arrays over array-of-structures.
- In array code, keep the leftmost index in the innermost loop; avoid temporaries and preallocate scratch arrays.

## Fortran Rules
- Build system: use CMake if present; otherwise use fpm. If multiple systems exist, prefer CMake.
- Format with `fprettify` (88 columns, 4-space indent); end files with newline.
- Put `use <module>, only:` above `implicit none`.
- Use `use, intrinsic :: iso_fortran_env, only: dp => real64`; declare reals as `real(dp)` and prefer `1.0d0` literals.
- Put declarations at scope start only (not inside branches/loops).
- Prefer `allocatable`; avoid pointers unless required; rely on scope deallocation and use `move_alloc()` for transfers; use explicit `deallocate` only when needed.
- Avoid returning allocatables from functions; provide deep-copy assignment for nested components.
- Name derived types `<name>_t`.
- Use `pure`/`elemental` whenever possible; all args must declare `intent(in|out|inout)`.
- Use `associate` for local aliases instead of mutating inputs directly.
- Add `contiguous` whenever possible on hot assumed-shape arrays; avoid noncontiguous slices.
- Respect column-major access: leftmost index innermost.
- If stale module files cause parse issues, delete `*.mod`.
- Do not rely on short-circuit evaluation in `if` conditionals.
- In comments, avoid quotation marks in examples.

### Fortran Performance Patterns
- Loop order: leftmost index innermost.
- Data layout: prefer structure-of-arrays in hot paths.
- Hot loops: do not allocate/deallocate inside loops; avoid expression forms that create temporaries.
- OpenMP: use `parallel do`; use `collapse(n)` for nested loops; choose `schedule(static|dynamic|guided)` by workload balance.
- Reductions: use OpenMP `reduction(...)` for accumulators.
- Contiguity: use `contiguous`; check `is_contiguous()` before pointer association.
- Cache: use blocking/tiling for large working sets.
- Detect hidden temporaries with `-Warray-temporaries` (gfortran) or `-check arg_temp_created` (Intel).

Loop order example:
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

Data layout example:
```fortran
! CORRECT: structure of arrays
type :: particles_t
  real(dp), allocatable :: x(:), y(:), z(:)
end type

! WRONG: array of structures
type :: particle_t
  real(dp) :: x, y, z
end type
type(particle_t), allocatable :: particles(:)
```

Hot-loop allocation example:
```fortran
! CORRECT: allocate once, reuse
real(dp), allocatable :: scratch(:)
allocate(scratch(n))
do iter = 1, max_iter
  call step(x, scratch)
end do

! WRONG: allocate/deallocate inside loop
do iter = 1, max_iter
  allocate(scratch(n))
  call step(x, scratch)
  deallocate(scratch)
end do
```

## Code Navigation with cscope (C projects)
Index:
```bash
find src include -name '*.c' -o -name '*.h' > cscope.files
cscope -b -q
```

Queries:
```bash
cscope -d -L0 symbol       # find symbol
cscope -d -L1 symbol       # find definition
cscope -d -L2 func         # find functions called BY func
cscope -d -L3 func         # find callers OF func
cscope -d -L4 text         # grep for text
cscope -d -L6 pattern      # egrep pattern
cscope -d -L7 file         # find file
cscope -d -L8 file         # find files including file
```

- Add `cscope.out*` and `cscope.files` to `.gitignore`.
- Rebuild index after significant changes.
- cscope is best for pure C (liric); for C++, prefer `clangd` + `compile_commands.json` (`bear` or `cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON`).

## Profiling (required before optimization)
| Tool | Platform | Command |
|------|----------|---------|
| gprof | Linux/macOS | `gfortran -pg -g -O2 app.f90 && ./a.out && gprof ./a.out gmon.out` |
| sample | macOS | `sample ./app 5 -file /tmp/sample.txt` |
| perf | Linux | `perf record -F 99 -g ./app && perf report --stdio` |
| callgrind | Linux | `valgrind --tool=callgrind ./app && callgrind_annotate callgrind.out` |

Hotspot diagnosis: malloc/free -> preallocate; cache misses -> fix loop order; memcpy -> explicit loops; low IPC -> blocking/tiling.

## Build and Test
- Use repo-documented build/test scripts.
- Keep tests behavioral and fast (<=120 s each).
- Prefer TDD: Red -> Green -> Refactor.
- Common build patterns:
  - CMake (preferred): `cmake -S . -B build -G Ninja && cmake --build build -j$(nproc)`
  - Make: `make -j$(nproc)`
  - Go: `go build ./... && go test ./...`
  - Fortran (if not using CMake): `fpm build && fpm test`
- Tests must pass 100% locally before PRs.
- Pin dependency versions only when reproducibility is required.
- Write test logs to `/tmp` to avoid polluting the working directory.

## Licensing and Reuse
- Research first. Copy ideas, not lines.
- Verify licenses; prefer MIT/BSD/Apache-2.0.
- Do explicit line-by-line ports only when requested; preserve notices and isolate as needed.

## Merge Hygiene
- Workarounds marked as workaround/temporary/should be removed must include an issue number on the same line.
- If review says improve later, create a GitHub issue before merge.
- If review requests an issue, verify that issue exists before merge.
- Never skip/disable tests to pass CI.
- Comments should explain why, not what; avoid noise such as bug fix for X in test registration.
- New test backend/config requires CI coverage or a tracking issue.

## Test Verification Evidence (mandatory for all PRs)
PR descriptions must include console evidence showing:
1. Test fails on `upstream/main`.
2. Test passes after the fix.

Required PR description format:

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

Rules:
- Console output must be real (not fabricated).
- Test names and commands must be reproducible.
- Use the repo's established test runner.
- For new tests, show the test exercising fixed behavior.
- For existing tests, show the regression fixed.

## Checklist Before Completion
1. Followed repo conventions and style (Fortran: 88-col, intents, allocatable/move_alloc, dp)?
2. Respected size limits and provided concrete evidence for claims?
3. Avoided stubs/placeholders/suppressions and followed Git/GitHub discipline?
4. Reached 100% pass rate by fixing code (not tests), with fail-on-main and pass-on-branch evidence?
5. Added issue numbers for workarounds and tracked improve-later items?
6. Created all reviewer-requested issues and avoided skipped/disabled tests?
7. Avoided noise comments; ensured new backends have CI coverage or tracking issues?

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
