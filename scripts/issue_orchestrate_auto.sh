#!/usr/bin/env bash
#!/usr/bin/env bash
# Fully autonomous issue loop orchestrator powered by Codex CLI (non-interactive)
# - Cleans to main (no untracked)
# - Checks relevance and may auto-close
# - Creates branch
# - Uses Codex CLI to implement fix (non-interactive)
# - Opens PR, self-review loop with Codex, decides success
# - If success: wait for CI, merge, issue closed by "fixes #N"; else cleanup PR/branch
# - Returns to clean main at the end of each iteration
#
# Usage:
#   scripts/issue_orchestrate_auto.sh [--label <name>|--all] [--limit N] [--merge|--squash|--rebase]
# Env:
#   TEST_CMD Optional local test command (e.g., "make test-ci"), used in prompts
#
set -euo pipefail
self_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Resolve repository root preference order:
# 1) REPO_DIR if provided; 2) current working directory's repo; 3) scripts' repo; 4) scripts/..
repo_root="${REPO_DIR:-}"
if [[ -z "$repo_root" ]]; then
  if repo_root=$(git rev-parse --show-toplevel 2>/dev/null); then
    :
  elif repo_root=$(git -C "$self_dir" rev-parse --show-toplevel 2>/dev/null); then
    :
  else
    repo_root="$(cd "$self_dir/.." && pwd)"
  fi
fi
cd "$repo_root"

label=""     # default all issues
limit=999999
merge_method="--merge"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --label) label="$2"; shift 2;;
    --all) label=""; shift 1;;
    --limit) limit="$2"; shift 2;;
    --merge|--squash|--rebase) merge_method="$1"; shift 1;;
    *) echo "Unknown arg: $1" >&2; exit 2;;
  esac
done

need() { command -v "$1" >/dev/null 2>&1 || { echo "Missing dependency: $1" >&2; exit 1; }; }
need gh
need codex

# Banner: resolved repo
echo "[orchestrate] repo_root=$(pwd) remote=$(git remote get-url origin 2>/dev/null || echo 'none')" >&2

has_untracked() { [[ -n "$(git ls-files --others --exclude-standard)" ]]; }
has_mods() { ! git diff --quiet || ! git diff --cached --quiet; }
print_dirty() { echo "Working tree has changes:" >&2; git status --short >&2 || true; }

ensure_clean_main() {
  if has_mods || has_untracked; then
    print_dirty
    git reset --hard
    git clean -fd
  fi
  git fetch origin
  local cur
  cur=$(git rev-parse --abbrev-ref HEAD || echo "")
  if [[ "$cur" != "main" ]]; then git checkout main; fi
  git pull --rebase origin main
}

# --- Codex autonomous loops ---
codex_fix_issue() {
  local inum="$1"; shift || true
  # Non-interactive Codex session to implement the fix on current branch
  # Provide tight instructions consistent with Codex Development Rules
  local prompt
  prompt=$(cat << 'EOF'
You are an autonomous coding agent running under Codex CLI in a Git repository.

Goal: Resolve the currently assigned GitHub issue in this repository on the current branch, then push commits.

Constraints (Codex Development Rules - concise):
- Evidence-based; run tests/linters; show logs when relevant.
- Full autonomy; do not ask for confirmations. No random markdown reports.
- Keep changes minimal, single-topic, with clear commit messages.
- Do not reformat or touch unrelated files. No secrets. Validate inputs.
- TDD preference when practical; correctness first. Don’t skip tests.
- Use existing build/test scripts; if none, add minimal scripts next to code.
- Never use `git add .`; stage only changed files you intend to commit.

Repository workflow to follow exactly:
1) Establish baseline: detect and run available tests, e.g., `make test-ci`, `pytest`, `fpm test`, `npm test`. Save short summaries to stdout.
2) Investigate the issue (# injected via environment below). Reproduce locally if feasible.
3) Implement the fix in small steps. Keep functions small; avoid unrelated refactors. Update docs if necessary.
4) Add or adjust tests to prove the fix (when feasible) and run them locally to green.
5) Stage specific files changed (no `git add .`). Commit with Conventional Commit style `fix: ... (fixes #<ISSUE_NUM>)` as appropriate. Push to the tracking branch.
6) Summarize what changed and which tests were run in your final message.

Notes:
- You may use `gh issue view $ISSUE_NUM` to read the issue details.
- If no tests exist, create minimal targeted ones (don’t add frameworks unless already present).
- If you can’t reproduce or fix, reduce scope to prepare the branch with best-effort changes and stop.
EOF
  )

  ISSUE_NUM="$inum" timeout "${CODEX_FIX_TIMEOUT:-30m}" codex exec --dangerously-bypass-approvals-and-sandbox --cd "$repo_root" - <<EOF
$prompt
EOF
}

codex_pr_self_review() {
  local pr_num="$1"; shift || true
  local inum="$1"; shift || true
  local max_rounds=3
  local round
  for round in $(seq 1 $max_rounds); do
    echo "[Codex Review] Round $round on PR #$pr_num" >&2
    local prompt
    prompt=$(cat << 'EOF'
You are an autonomous reviewer/developer using Codex CLI.

Task: Self-review the open Pull Request for this branch, make necessary code or test improvements, and push additional commits if needed.

Process:
1) Inspect PR details and diff: you can use `gh pr view $PR_NUM --json files,headRefName,baseRefName,number,author,body,url` and fetch changed files.
2) Run local tests and linters; fix failures.
3) Apply targeted improvements (tests, docs, code) to raise quality while staying within the PR scope.
4) Stage specific files only, commit with clear messages, and push.
5) If no further changes are needed, end gracefully.

Rules:
- No broad refactors; minimal, focused changes. No random markdown reports.
- Keep functions under 50 lines when practical; follow project style.
- Don’t skip tests; keep everything reproducible.
EOF
    )
    PR_NUM="$pr_num" ISSUE_NUM="$inum" timeout "${CODEX_REVIEW_TIMEOUT:-20m}" codex exec --dangerously-bypass-approvals-and-sandbox --cd "$repo_root" - <<EOF
$prompt
EOF

    # If nothing changed in this round, we can stop (best-effort heuristic)
    if git diff --quiet && git diff --cached --quiet; then
      echo "[Codex Review] No local changes detected after round $round." >&2
      break
    fi
    # Ensure changes are committed and pushed, if any are pending
    if ! git diff --cached --quiet; then
      while IFS= read -r -d '' rec; do
        code=${rec:0:2}; path=${rec:3}
        case "$code" in
          D*|*D) git rm -- "$path" || true ;;
          R*) IFS= read -r -d '' newpath || true; [[ -n "$newpath" ]] && { git rm -- "$path" || true; git add -- "$newpath" || true; } ;;
          *) git add -- "$path" || true ;;
        esac
      done < <(git status --porcelain -z)
      git commit -m "chore: self-review improvements (#$pr_num)"
      git push
    fi
  done
}

open_pr_if_missing() {
  local inum="$1"
  local existing
  existing=$(gh pr list --search "in:title #$inum in:body #$inum" --json number --jq '.[].number' || true)
  if [[ -z "$existing" ]]; then
    "$self_dir/issue_open_pr.sh" "$inum" | tail -n1
  else
    gh pr view "$existing" --json url --jq '.url'
  fi
}

find_existing_pr_number() {
  local inum="$1"
  gh pr list --search "in:title #$inum in:body #$inum" --json number --jq '.[].number' 2>/dev/null | head -n1
}

checkout_pr_branch() {
  local pr_num="$1"
  local branch
  branch=$(gh pr view "$pr_num" --json headRefName --jq '.headRefName')
  git fetch origin "$branch":"$branch" || true
  if git show-ref --verify --quiet "refs/heads/$branch"; then
    git checkout "$branch"
    git pull --rebase origin "$branch" || true
  else
    git checkout -b "$branch" --track "origin/$branch" || git checkout "$branch"
  fi
  echo "$branch"
}

# Stage precise set of changes, handling deletes/renames
stage_all_changes() {
  while IFS= read -r -d '' rec; do
    code=${rec:0:2}; path=${rec:3}
    case "$code" in
      D*|*D) git rm -- "$path" || true ;;
      R*) IFS= read -r -d '' newpath || true; [[ -n "$newpath" ]] && { git rm -- "$path" || true; git add -- "$newpath" || true; } ;;
      *) git add -- "$path" || true ;;
    esac
  done < <(git status --porcelain -z)
}

# Run local tests with auto-detection or TEST_CMD; returns 0 on pass
run_local_tests() {
  local cmd=""; local log="/tmp/codex_local_tests_$$.log"; local rc
  if [[ -n "${TEST_CMD:-}" ]]; then cmd="$TEST_CMD"; fi
  if [[ -z "$cmd" && -f Makefile && $(grep -cE '^test-ci:' Makefile) -gt 0 ]]; then cmd="make test-ci"; fi
  if [[ -z "$cmd" && command -v fpm >/dev/null 2>&1 ]]; then cmd="fpm test"; fi
  if [[ -z "$cmd" && command -v pytest >/dev/null 2>&1 ]]; then cmd="pytest -q"; fi
  if [[ -z "$cmd" && -f package.json && command -v npm >/dev/null 2>&1 ]]; then cmd="npm test --silent"; fi
  if [[ -z "$cmd" && command -v ctest >/dev/null 2>&1 ]]; then cmd="ctest --output-on-failure"; fi
  if [[ -z "$cmd" && -f Makefile ]]; then cmd="make test"; fi
  if [[ -z "$cmd" ]]; then
    echo "[tests] No known test runner found; treating as pass (noop)." >&2
    return 0
  fi
  echo "[tests] Running: $cmd" >&2
  if timeout "${LOCAL_TEST_TIMEOUT:-20m}" bash -lc "$cmd" >"$log" 2>&1; then
    rc=0
  else
    rc=$?
  fi
  tail -n 50 "$log" >&2 || true
  rm -f "$log" || true
  return $rc
}

codex_ci_fix_loop() {
  local pr_num="$1"; shift || true
  local inum="$1"; shift || true
  local branch="$1"; shift || true
  local max_attempts=10
  local attempt=1
  while (( attempt <= max_attempts )); do
    echo "[CI Fix] Attempt $attempt on PR #$pr_num (branch $branch)" >&2
    local prompt
    prompt=$(cat << 'EOF'
You are operating on a PR with failing CI.

Task: Diagnose the CI failures, read GitHub Actions logs, fix issues locally, push commits, and re-trigger CI until green.

Steps:
1) Inspect latest CI runs for the branch: `gh run list --branch "$BRANCH" --event pull_request --json databaseId,workflowName,status,conclusion,htmlUrl --limit 5` and view logs for failed jobs using `gh run view <run-id> --json jobs --log`.
2) Reproduce locally (run tests/linters/build) and fix the root cause. Keep changes minimal and scoped to this PR.
3) Add/adjust tests as needed to prevent regression; run locally to green.
4) Stage specific files only; commit with clear message; push.
5) If there is nothing actionable (external flake), document minimal retry (e.g., rebase to retrigger) and proceed.

Rules:
- No random markdown reports. Put evidence in commit messages or PR body if appropriate.
- Do not broaden scope. Keep functions small and style consistent.
EOF
    )
    PR_NUM="$pr_num" ISSUE_NUM="$inum" BRANCH="$branch" timeout "${CODEX_CI_FIX_TIMEOUT:-20m}" codex exec --dangerously-bypass-approvals-and-sandbox --cd "$repo_root" - <<EOF
$prompt
EOF

    # If Codex produced changes, ensure they are committed and pushed
    if ! git diff --quiet || ! git diff --cached --quiet; then
      while IFS= read -r -d '' rec; do
        code=${rec:0:2}; path=${rec:3}
        case "$code" in
          D*|*D) git rm -- "$path" || true ;;
          R*) IFS= read -r -d '' newpath || true; [[ -n "$newpath" ]] && { git rm -- "$path" || true; git add -- "$newpath" || true; } ;;
          *) git add -- "$path" || true ;;
        esac
      done < <(git status --porcelain -z)
      if ! git diff --cached --quiet; then
        git commit -m "fix(ci): address CI failures on PR #$pr_num"
        git push
      fi
    fi

    echo "Waiting for CI after attempt $attempt..." >&2
    status_line=$("$self_dir/pr_ci_status.sh" "$pr_num" --watch || true)
    echo "$status_line" >&2
    conclusion=$(echo "$status_line" | awk '{for(i=1;i<=NF;i++){if($i ~ /^conclusion=/){print substr($i,12)}}}')
    if [[ "$conclusion" == "success" ]]; then
      return 0
    fi
    ((attempt++))
  done
  return 1
}

# Fetch issues
if [[ -n "$label" ]]; then
  issues=$(gh issue list --state open --label "$label" --json number --limit 500 --jq '.[].number' || true)
else
  issues=$(gh issue list --state open --json number --limit 500 --jq '.[].number' || true)
fi
if [[ -z "${issues:-}" ]]; then
  echo "No open issues to process." >&2
  exit 0
fi

count=0
for inum in $issues; do
  ensure_clean_main

  # Relevance check with auto-close if obsolete
  if "$self_dir/issue_check_relevance.sh" "$inum" --auto-close; then
    :
  else
    rc=$?
    if [[ $rc -eq 11 || $rc -eq 10 ]]; then
      continue
    fi
  fi

  echo "=== [AUTO] Processing issue #$inum ==="

  # Use existing PR/branch if present; otherwise create branch
  existing_pr=$(find_existing_pr_number "$inum" || true)
  if [[ -n "$existing_pr" ]]; then
    echo "Found existing PR #$existing_pr for issue #$inum; continuing work." >&2
    branch=$(checkout_pr_branch "$existing_pr")
    pr_url=$(gh pr view "$existing_pr" --json url --jq '.url')
  else
    # Prefer existing local/remote feature branch if present
    exist_branch=$(git branch --all --list "*fix/issue-${inum}-*" | head -n1 | sed 's#remotes/origin/##' | sed 's#^[* ]*##')
    if [[ -n "$exist_branch" ]]; then
      echo "Found existing branch $exist_branch; using it." >&2
      if git show-ref --verify --quiet "refs/heads/$exist_branch"; then
        git checkout "$exist_branch" && git pull --rebase || true
      else
        git fetch origin "$exist_branch":"$exist_branch" || true
        git checkout "$exist_branch" || git checkout -b "$exist_branch"
      fi
      branch="$exist_branch"
    else
      # Create and switch to branch (also pushes)
      branch=$("$self_dir/issue_branch.sh" "$inum")
    fi
  fi
  echo "Branch: $branch"

  # Run Codex autonomous fix loop (non-interactive) on this branch
  codex_fix_issue "$inum"

  # Auto-commit any changes (stage specific files only)
  if ! git diff --quiet || ! git diff --cached --quiet || [[ -n "$(git ls-files --others --exclude-standard)" ]]; then
    stage_all_changes
    if ! git diff --cached --quiet; then
      git commit -m "fix: attempt to resolve issue #$inum (auto)"
      git push
    fi
  fi

  # Strict pre-PR local test gate: attempt up to 3 local fix cycles before opening PR
  pre_attempt=1; pre_max=3
  while (( pre_attempt <= pre_max )); do
    if run_local_tests; then
      break
    fi
    echo "[pre-PR] Local tests failing; handing back to Codex (attempt $pre_attempt/$pre_max)" >&2
    codex_fix_issue "$inum"
    if ! git diff --quiet || ! git diff --cached --quiet || [[ -n "$(git ls-files --others --exclude-standard)" ]]; then
      stage_all_changes
      if ! git diff --cached --quiet; then
        git commit -m "fix: continue resolving issue #$inum (pre-PR)"
        git push
      fi
    fi
    ((pre_attempt++))
  done

  # Ensure PR exists
  if [[ -z "${pr_url:-}" ]]; then
    pr_url=$(open_pr_if_missing "$inum")
  fi
  echo "PR: $pr_url"

  if pr_number=$(gh pr view "$pr_url" --json number --jq '.number' 2>/dev/null); then
    # Self-review loop with Codex to refine PR
    codex_pr_self_review "$pr_number" "$inum"

    # Move PR out of draft if still draft
    if gh pr view "$pr_number" --json isDraft --jq '.isDraft' | grep -qi true; then
      gh pr ready "$pr_number" || true
    fi

    echo "Waiting for CI on PR #$pr_number" >&2
    status_line=$("$self_dir/pr_ci_status.sh" "$pr_number" --watch || true)
    echo "$status_line" >&2
    conclusion=$(echo "$status_line" | awk '{for(i=1;i<=NF;i++){if($i ~ /^conclusion=/){print substr($i,12)}}}')
    if [[ "$conclusion" == "success" ]]; then
      "$self_dir/pr_merge.sh" "$pr_number" "$merge_method"
    else
      echo "CI not successful for PR #$pr_number; handing back to Codex for remediation." >&2
      if codex_ci_fix_loop "$pr_number" "$inum" "$branch"; then
        echo "CI turned green after remediation. Merging PR #$pr_number." >&2
        "$self_dir/pr_merge.sh" "$pr_number" "$merge_method"
      else
        echo "CI still failing after remediation attempts; cleaning up PR #$pr_number." >&2
        "$self_dir/pr_cleanup.sh" "$pr_number"
      fi
    fi
  else
    echo "Could not resolve PR number for URL: $pr_url" >&2
  fi

  ensure_clean_main
  ((count++))
  if (( count >= limit )); then break; fi

done

echo "Autonomous issue processing complete (processed $count)."
