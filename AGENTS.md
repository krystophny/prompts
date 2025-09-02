# Codex Development Rules (Concise)

## Core Principles
- Evidence-based: Provide verifiable proof for claims (tests, logs, outputs).
- Verification-first: Do not bypass tests or CI; resolve discrepancies.
- Protocol-compliant: Follow systematic workflows and technical gates.
- No time pressure: Take the time to solve tasks fully and cleanly; do not
  expand scope or add features (no feature/scope creep).
- No random progress docs: Do not create ad-hoc markdown status reports.

## Repository Practices
- Work from the project root directory.
- Identify whether changes affect repository (git/gh/pr), code/docs, or build/test; apply relevant checks.
- Stage specific files only; never use `git add .` or `git add -A`.
- Keep commits single-topic and scoped to a unit of change.
- Commit after completing a unit of work; don’t batch unrelated changes.
- Push immediately after committing.
- Never commit binaries, build artifacts, temp files, secrets, or random markdown reports.
- No emojis in commit messages, PRs, or issues.
 - Non-interactive git: disable editors. Prefix commands with
   `git -c core.editor=true -c sequence.editor=true …` and use `-m`/`--no-edit`
   where applicable to avoid `$EDITOR` hangs.

## Implementation Standards
- TDD: Red → Green → Refactor with meaningful tests.
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
- YAGNI-first: implement only what the issue/PR requires now. If code is overengineered for the purpose, simplify it to the minimal correct solution.
- Mandatory dedup: before adding code, search for existing similar utilities/components. If duplication exists, consolidate by enhancing the existing implementation rather than creating parallel versions.
- Touching existing code: when nearby duplication is discovered during changes, refactor to unify and remove overlap as part of the same focused unit of work.
- Minimal surface area: avoid adding new public APIs unless strictly necessary; prefer extending internal helpers. If an API change is needed, keep it small and provide a clear migration in the same PR.
- Evidence: in PR descriptions, briefly note the simplifications/deduplications performed and reference affected paths.

## Testing and Build
- Run the test suite before starting work to establish a baseline.
- Run the full test suite after every change; verify build commands.
- Do not skip, deactivate, or comment out tests.
- Only use xfail with a linked GitHub issue documenting rationale and plan.
- Ensure a full local pass before opening a PR; include evidence (outputs/coverage).
- Regression prevention: compare current results to the pre-work baseline; investigate deltas.
- Validate locally the same build scripts/targets CI uses.
- Run tests always with 120s timeout. If execution hits this limit, treat it as a hang or too-slow test and fix immediately.
 - CMake builds: always use Ninja generator. Configure with
   `cmake -S . -B build -G Ninja` and build with `cmake --build build -j`.

## Verification and CI
- Verify CI system health before any git operation.
- Back “tests pass” claims with actual test outputs.
- Summarize test/build results in PRs.
- Never merge with failing CI checks.
- Treat local vs CI discrepancies as blocking until resolved.
- Analyze each CI failure; environment issues are the implementer’s responsibility.
- Treat CI hangs over ~10 minutes as failures: stop, collect logs, investigate, and surface remediation steps.

## Documentation
- Example-first: show working examples first; include commands and expected outputs.
- Copy-paste runnable: every example must execute as shown.
- Zero duplication: remove redundancy; consolidate overlapping content.
- Keep it tight: clear structure, verified links; file target <500 lines (<1000 hard), sections <50 (<100 hard).

## Review Standards
- Review available CI results or logs; re-run locally as needed.
- Run static analysis and report concrete findings with file/line references.
- Check for strict compliance with the rules in this file.
- Check for test manipulation (skips, comments, deactivations) via code review/static analysis; flag skipped/xfail without linked issues as blockers.
- Use structured feedback (see Feedback) and define re-verification steps.

## GitHub Operations
- Read full context for issues and PRs (descriptions and all comments).
- Mandatory duplicate check before filing any issue.
- Use accurate GitHub CLI queries to avoid truncation:
  - `gh issue list --state open --limit 500`
  - `gh issue list --state open --limit 500 --search "keyword"`
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

### PR Description Formatting (Simple Rule)
- Use plain Markdown only; no JSON/XML-like wrappers, angle brackets, or stray
  braces/quotes. Structure with these headings and bullets exactly:
  - Summary
  - Scope
  - Verification
  - Rationale
  Review generated text before submitting and remove any malformed artifacts
  (e.g., trailing `]}`, unmatched quotes, or template placeholders).

### gh CLI: Create PRs Safely
- Always pass the body via `--body-file` (not inline) to avoid shell quoting
  and formatting issues. Example:
  ```sh
  tmp=$(mktemp)
  cat >"$tmp" <<'MD'
  Summary
  - What changed in one or two lines.

  Scope
  - Files or areas touched; no code behavior changes.

  Verification
  - Why build/tests are unaffected or how verified locally.

  Rationale
  - Why this is needed now.
  MD
  gh pr create \
    --title "docs: tighten PR formatting guidance" \
    --body-file "$tmp" \
    --base main \
    --head "$(git rev-parse --abbrev-ref HEAD)"
  rm -f "$tmp"
  ```
- Do not pipe JSON to `gh api` for PR creation; use `gh pr create` with
  `--title` and `--body-file`.
- Avoid `--body` with long multiline strings; prefer a file to prevent
  accidental injection of braces, quotes, or angle brackets.

### gh CLI: Close Issues with Evidence Comment
- Always add a structured evidence comment before closing an issue. Use a body file to avoid formatting glitches.
  ```sh
  pr_num=123
  issue_num=123
  repo_url=$(gh repo view --json url --jq '.url')
  pr_url=$(gh pr view "$pr_num" --json url --jq '.url')
  merge_commit=$(gh pr view "$pr_num" --json mergeCommit --jq '.mergeCommit.oid')
  sha_short=${merge_commit:0:12}
  files=$(gh pr view "$pr_num" --json files --jq '[.files[]?.path] // []')

  tmp=$(mktemp)
  cat >"$tmp" <<'MD'
  Resolution
  - Issue closed after merge of the linked PR and verification of changes.

  Evidence
  - PR: __PR_URL__
  - Merge commit: __SHA_SHORT__ (__MERGE_COMMIT_URL__)
  - Files changed (first N):
  __FILE_LINKS__

  Links
  - PR overview: __PR_URL__
  - PR commits: __PR_COMMITS_URL__
  - PR diffs: __PR_FILES_URL__
  - CI/Checks: __CHECKS_URL__

  Notes
  - References use the merge commit to ensure stable, permanent links to the exact content merged.
  MD

  # Build per-file links (limit to 20 to keep it short)
  file_links=""
  echo "$files" | jq -r '.[]' | head -n 20 | while read -r f; do
    printf -- "- %s\n" "$repo_url/blob/$merge_commit/$f"
  done | while IFS= read -r line; do file_links+="$line\n"; done

  pr_files_url="$pr_url/files"
  pr_commits_url="$pr_url/commits"
  merge_commit_url="$repo_url/commit/$merge_commit"
  checks_url="$pr_url"

  # Substitute placeholders
  sed -i \
    -e "s|__PR_URL__|${pr_url//|/\|}|g" \
    -e "s|__SHA_SHORT__|${sha_short//|/\|}|g" \
    -e "s|__MERGE_COMMIT_URL__|${merge_commit_url//|/\|}|g" \
    -e "s|__PR_COMMITS_URL__|${pr_commits_url//|/\|}|g" \
    -e "s|__PR_FILES_URL__|${pr_files_url//|/\|}|g" \
    -e "s|__CHECKS_URL__|${checks_url//|/\|}|g" \
    -e "s|__FILE_LINKS__|${file_links//$'\n'/'\\n'}|g" "$tmp"

  gh issue comment "$issue_num" --body-file "$tmp"
  gh issue close "$issue_num" --reason completed
  rm -f "$tmp"
  ```
- Keep the comment concise and evidence-focused; avoid verbose narratives.

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
