# Codex Development Rules (Concise)

## Core Principles
- Evidence-based: Provide verifiable proof for claims (tests, logs, outputs).
- Verification-first: Do not bypass tests or CI; resolve discrepancies.
- Protocol-compliant: Follow systematic workflows and technical gates.
- No time pressure: Take the time to solve tasks fully and cleanly; do not
  expand scope or add features (no feature/scope creep).
- No random progress docs: Markdown only in PRs/issues per policy; no ad-hoc
  status reports.

## Repository Practices
- Work from the project root directory.
- Identify whether changes affect repository (git/gh/pr), code/docs, or build/test; apply relevant checks.
- Stage specific files only; never use `git add .` or `git add -A`.
- Keep commits single-topic and scoped to a unit of change.
- Commit after completing a unit of work; don’t batch unrelated changes.
- Push immediately after committing.
- Never commit binaries, build artifacts, temp files, secrets, or random markdown reports.
- No emojis in commit messages, PRs, or issues.

## Implementation Standards
- TDD: Red → Green → Refactor with meaningful, flexible tests - robust not rigid.
- Priorities: Correctness > Performance > KISS > SRP > YAGNI > DRY > SOLID > Security.
- Keep modules reasonably small (target <500 lines; hard limit <1000 where applicable).
- Prefer small, focused functions and types.
- Reuse-first: enhance existing code; avoid duplicate functionality; prefer modifying existing files over creating parallel versions.
- Function size: target <50 lines; hard limit <100.
- No commented-out code, stubs, placeholders, or shortcuts.
- No hardcoded secrets/keys/passwords; validate inputs.

### External References & Licensing
- Research-first: actively look on GitHub and the wider web for mature projects solving similar problems; study their designs and APIs.
- Copy ideas, not lines: use external code as conceptual/reference material. Re-implement in our own words and style to avoid license issues and fit our architecture.
- License checks: verify source license before borrowing. Prefer permissive (MIT/BSD/Apache-2.0). Avoid copyleft (GPL/LGPL/AGPL) unless explicitly approved.
- Explicit ports: if the user requests a line-by-line port, proceed knowing they accept license terms; preserve required notices and attributions exactly as licenses dictate and isolate such code if needed.

Example (reference-reading only)
- Clone into `/tmp` and inspect a Matplotlib module without copying code verbatim:
  - `gh repo clone matplotlib/matplotlib /tmp/matplotlib -- --depth=1`
  - `cd /tmp/matplotlib`
  - `rg -n "ticker\.py|axes\.py|legend\.py" lib/matplotlib`
  - `sed -n '1,60p' lib/matplotlib/ticker.py`  # read to understand API/behavior
  - Implement our own formatter inspired by the concepts; do not paste lines.

### YAGNI & Dedup Vigilance (New and Existing Code)
- YAGNI-first: implement what the issue/PR requires now; small local cleanups
  in touched code are OK. If code is overengineered for the purpose, simplify
  to the minimal correct solution.
- Mandatory dedup: before adding code, search for existing similar utilities/components. If duplication exists, consolidate by enhancing the existing implementation rather than creating parallel versions.
- Touching existing code: when nearby duplication is discovered during changes, refactor to unify and remove overlap as part of the same focused unit of work.
- Minimal surface area: prefer minimal exposure; internal helpers to dedupe in
  touched code are OK. Public API changes only when required for the fix; keep
  them small and include a clear migration in the same PR.
- Refactors: no repo-wide refactors; behavior-preserving cleanups in touched
  files are OK.
- Evidence: in PR descriptions, briefly note the simplifications/deduplications performed and reference affected paths.

## Testing and Build
- Run the test suite before starting work to establish a baseline.
- Run the full test suite after every change; verify build commands.
- Write quality tests: non-shallow (test actual behavior), non-tautological (avoid always-pass), fast (<1s per test), flexible (robust not rigid).
- Do not skip, deactivate, or comment out tests.
- Only use xfail with a linked GitHub issue documenting rationale and plan.
- Ensure a full local pass before opening a PR; include evidence (outputs/coverage).
- Regression prevention: compare current results to the pre-work baseline; investigate deltas.
- Validate locally the same build scripts/targets CI uses.
- Run tests always with 120s timeout. If execution hits this limit, treat it as a hang or too-slow test and fix immediately.
 - CMake builds: always use Ninja generator. Configure with
   `cmake -S . -B build -G Ninja` and build with `cmake --build build -j`.

### Artifact Evidence (Project-defined)
- Tests alone may be insufficient. Provide domain-appropriate artifact evidence when fixes affect outputs (graphics, binaries, logs, generated files).
- If the repository defines a verification target or script (e.g., `make verify-artifacts`, `scripts/verify_*`, `VERIFY_CMD`), run it and include concise outputs.
- When no target exists, reproduce the issue with documented commands and attach short, verifiable excerpts: exact commands, artifact paths, small tool outputs (e.g., text extractors, validators, renderers).
- PRs/issues must include the commands used, artifact paths, and minimal output snippets proving correctness.

## Verification and CI
- Verify CI system health before any git operation.
- Back “tests pass” claims with actual test outputs.
- For rendering changes, CI must also run the artifact checks above. Failing PDF/PNG gates block merge.
- Summarize test/build results in PRs.
- Never merge with failing CI checks.
- After all CI checks pass, reviewers must inspect PR review comments and ensure all feedback is addressed before merge.
- Treat local vs CI discrepancies as blocking until resolved.
- Analyze each CI failure; environment issues are the implementer’s responsibility.
- Treat CI hangs over ~10 minutes as failures: stop, collect logs, investigate, and surface remediation steps.

## Documentation
- Example-first: show working examples first; include commands and expected outputs.
- Copy-paste runnable: every example must execute as shown.
- Zero duplication: remove redundancy; consolidate overlapping content.
- Keep it tight: clear structure, verified links; file target <500 lines (<1000 hard), sections <50 (<100 hard).

### Markdown Usage Policy
- Allowed: only in PR descriptions and issue comments.
- Structure: PRs use Summary / Scope / Verification / Rationale. Issues use
  concise Problem / Evidence / Solution.
- Evidence: include exact commands and minimal excerpts (≤30 lines/snippet,
  ≤50 lines total per update). Link to full logs/artifacts instead of inlining.
- Not allowed: new/updated ad-hoc `.md` status notes unless the task is `docs`;
  long logs, journals, or screenshots unrelated to verification; drive‑by docs
  edits unrelated to the fix.
- Notes: prefer links to CI runs, artifacts, and file paths. When outputs
  change, include one small validator excerpt (diff summary, counts, checksum)
  and link to the artifact.

### Markdown Conventions
- Inline code: wrap code literals in backticks, for example `module`, `advance_state`, `--flag`, `fpm test`.
- Code blocks: fence with the correct language. Use `fortran` for Fortran snippets, `sh` for shell, `json` for JSON, etc.
- Issue/PR comments: follow the same rules; prefer minimal, targeted snippets.

## Review Standards
- Review available CI results or logs; re-run locally as needed.
- Run static analysis and report concrete findings with file/line references.
- Check for strict compliance with the rules in this file.
- Check for test manipulation (skips, comments, deactivations) via code review/static analysis; flag skipped/xfail without linked issues as blockers.
- Use structured feedback (see Feedback) and define re-verification steps.

## GitHub Operations
- Read full context for issues and PRs thoroughly (entire descriptions and all comments) — do not skim.
- Mandatory duplicate check before filing any issue.
- Use gh responsibly; avoid truncated views; fetch details only when needed.
- Keep issues concrete and actionable; track epics in planning docs.
- Issue filing: assign category and priority when creating issues.
  - Categories (minimal set): `bug`, `docs`, `tech-debt`, `enhancement`.
  - Priorities: `P0` (urgent, CI red), `P1` (high impact), `P2` (normal), `P3` (low/nice-to-have).
  - Apply labels directly if they exist; if not, include a first-line metadata block in the body, e.g., `Category: bug`, `Priority: P1`.
  - Base priority on evidence (test failures, user impact, frequency). Default to `P2` when uncertain.
  - Include concise evidence (logs/paths/outputs) justifying category/priority.
 - Selection/prioritization: prefer issues with the highest positive impact at the lowest implementation effort (optimize impact/effort).
- Commit/PR titles: use Conventional Commits (`type: description`), imperative mood, <72 chars, and reference issues (e.g., `fixes #123`).
- Open review-ready PRs; avoid draft PRs.
- PR feedback: Check both comments AND reactions - thumbs up (👍) reaction means approval to proceed
- When waiting for PR feedback: monitor `gh pr view <n> --json comments,reactions` for approval signals

### PR Description Formatting (Simple Rule)
- Use plain Markdown; structure with: Summary, Scope, Verification, Rationale.
  Keep it concise and remove malformed artifacts.

## Feedback (Structured)
- Format: PROBLEM (specific issue), EVIDENCE (logs/URLs/paths), SOLUTION (clear steps).
- Be specific, actionable, and include proof; avoid vague directives.

## Cleanup & Style
- Formatting: 88-column limit; 4-space indent. End files with a newline (UNIX line endings). Avoid non-ASCII unless required.
- Remove obsolete/dead code; do not keep backups or commented-out blocks.
- When removing code, remove it outright; do not leave explanatory comments.
- If a code file becomes functionally empty, delete the file.
- Apply the Boy Scout Rule: leave the code cleaner than you found it.
- Data layout: prefer Structure-of-Arrays (SoA) over Array-of-Structures (AoS) for cache behavior.
- Folder hygiene: aim ≤20 items per folder (hard ≤50) before reorganizing.
 - Self-documenting code: prefer clear names and straightforward logic so code speaks for itself. Avoid redundant comments that merely restate code. Use comments sparingly for non-obvious intent, invariants, edge cases, algorithm references, or cross-module rationale. Keep docstrings focused on public APIs and examples.

## Language Preferences
- Primary language: modern Fortran (2018+). Use Fortran by default even for
  tasks typically handled in other languages (scripting, data analysis, CLI,
  web/REST services) whenever feasible.
- Ecosystem: use fpm for build and dependency management. Prefer latest git
  versions of packages; pin SHAs only when reproducibility requires it.
- Plotting: use lazy-fortran/fortplot for visualization.
- Interop: when unavoidable, keep glue minimal (e.g., tiny Bash/Python wrappers)
  and maintain a Fortran-first implementation of core logic.
 - Existing projects: always use the language and stack of the project when
   contributing to an established codebase, unless explicitly requested
   otherwise by the user/maintainers.
 - Explicit user request: if the user specifies a stack or language, follow it
   even if it differs from the default Fortran-first approach.

## Language-Specific: Fortran
- Line length: 88; up to 90 with ` &` continuation.
- Indentation: 4 spaces.
- Types: name derived types `typename_t`.
- Allocatables: use `move_alloc()`; avoid `transfer`.
- Memory: do not manually deallocate allocatables.
- APIs: avoid returning allocatables from functions.
- Copies: implement deep-copy assignment for nested components.
- fpm: enable autodiscovery for `app`, `test`, and `example` in `fpm.toml`.
- Build: if “right parentheses” module error occurs, remove stale `*.mod` files.
- Comments: avoid quotes.
- Performance: column‑major arrays; inner loop over leftmost index.
- Declarations first: place all variable declarations at the start of the
  scope (no declarations inside branches or loops).
- Imports: always `use <modulename>, only:` (no wildcards); place above `implicit none` if
  present in the scope.

## Numerical Computing
- Rigor: back mathematical claims with numerical validation or reference comparisons.
- Error analysis: report error bounds/tolerances; include convergence behavior when applicable.
- Reproducibility: make results independently reproducible (seeds, inputs, environment, versions).
- Method selection: justify algorithm choice; include stability and convergence notes.
- Verification: validate implementations against analytical solutions or trusted baselines when possible.
- Tolerances: set and report numeric tolerances explicitly.
