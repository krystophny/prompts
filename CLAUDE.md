# CLAUDE.md (Fortran-First Framework)

## Non-Negotiables
- No stubs, placeholders, commented-out code, random markdowns, variants, backups, or suppressions.
- Never claim success without evidence (CI logs, real test output).
- Never use `git add .` or `git add -A`. Stage explicit files only.
- Always use repo build/test scripts — fpm is default.

---

## Git / GitHub
- SSH-only, no emojis, explicit files.
- No draft PRs — fix until merge.
- Local tests must pass before PR creation.
- Edit descriptions (`gh issue edit --body`), not comments.
- `--limit 500` for all gh commands.
- 👍 reaction = approval to merge.

---

## Fortran Rules (2018+, fpm, 88-col)
- Build: fpm. Use CI commands locally.
- Format: 88 columns, 4-space indent. Use `fprettify`.
- Types: `typename_t` for derived types.
- Dummies: all have `intent(...)`; prefer `pure` / `elemental`.
- Imports: `use <mod>, only:` above `implicit none`.
- Kinds: `use, intrinsic :: iso_fortran_env, only: dp => real64`; use `1.0d0` literals.
- Memory: prefer `allocatable`; use `move_alloc()`; don’t deallocate manually.
- Declarations at scope start.
- Arrays: column-major; loop over leftmost index.
- Use `associate` for local aliases.
- Add `contiguous` where required; avoid noncontiguous slices in hot loops.
- If “right parentheses” error → delete `*.mod`.

---

## Code Essentials
- TDD: Red → Green → Refactor. 120s/test.
- No defensive programming — trust inputs.
- Limits: modules <500 LOC (1000 hard), functions <50 LOC (100 hard), ≤20 items/folder.
- Stick to project’s stack.
- No secrets. Prefer SoA over AoS, preallocate scratch arrays, avoid temporaries.
- Copy ideas, not lines. Use MIT/BSD/Apache-2.0.

---

## Workflow
- CI must pass before merge. Ready PRs block work.
- Edit GitHub issue descriptions; never close meta-issues prematurely.

---

## Build & Test
- Always use repo scripts and CI commands.
- CMake (when needed):  
  `cmake -S . -B build -G Ninja && cmake --build build -j`
- Tests: behavioral, fast. Use latest git packages; pin SHAs only if needed.

---

## AI Guards
- Never claim success without evidence.
- Complete DOING work before backlog.
- No shallow validation. Do not bypass guardrails.

---

## Self-Check
1. Followed Fortran rules (fpm, 88-col, intents, allocatable/move_alloc, dp)?
2. Respected size limits?
3. Provided evidence?
4. Avoided stubs/placeholders/suppressions?
5. Followed Git/GitHub discipline?
