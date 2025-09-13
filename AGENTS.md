# AGENTS.md (Lean, Fortran-First)

Language & Stack
- Primary: modern Fortran (2018+). Prefer Fortran even for scripting/CLI/web when feasible.
- Existing projects: stick to the project’s established stack unless explicitly directed otherwise.
- Explicit requests: if asked, follow the specified stack even if non-Fortran.
- Interop: keep non-Fortran glue minimal; core logic remains Fortran.
- Build/deps: use fpm; prefer latest git packages, pin SHAs only when reproducibility is required.
- Plotting: use lazy-fortran/fortplot.

Implementation Standards
- Keep modules reasonably small (<500 lines; hard <1000).
- Functions small and focused (<50 lines; hard <100).
- Reuse-first: modify/extend existing code; eliminate nearby duplication.
- No commented-out code, stubs, or placeholders. Validate inputs.
- Data layout/perf: prefer SoA over AoS; column-major arrays; inner loop over leftmost index.
- No hardcoded secrets/keys/passwords.

Fortran Guidelines
- Formatting: 88-column limit (up to 90 with ` &`), 4-space indent, end files with a newline.
- Imports: `use <modulename>, only:`; place above `implicit none`.
- Declarations at start of scope; none inside branches/loops.
- Allocatables: use `move_alloc()`; avoid `transfer`; do not manually deallocate.
- APIs: avoid returning allocatables from functions; implement deep-copy assignment for nested components.
- Types: name derived types `typename_t`.
- fpm: enable autodiscovery for `app`, `test`, and `example` in `fpm.toml`.
- Build hiccup: if “right parentheses” module error occurs, remove stale `*.mod` files.
- Comments: avoid quotes.

Build & Tests
- Use repo’s documented build/test scripts and the same commands CI uses.
- CMake builds: always use Ninja.
  - `cmake -S . -B build -G Ninja`
  - `cmake --build build -j`
- Keep tests behavioral and fast; avoid adding slow/hanging tests.
- Prefer TDD: Red → Green → Refactor.

Git Hygiene
- Single-topic commits. Stage explicit paths only (no `git add .` or `git add -A`).
- Do not commit binaries, build artifacts, temp files, or secrets.

Licensing & Reuse
- Research-first. Copy ideas, not lines. Verify licenses; prefer MIT/BSD/Apache-2.0.
- Explicit line-by-line ports allowed only when requested; preserve notices and isolate if needed.

Cleanup & Organization
- Remove obsolete/dead code outright.
- Aim for ≤20 items per folder (hard ≤50) before reorganizing.
- Write self-documenting code; use comments sparingly for non-obvious intent/invariants/edges.
