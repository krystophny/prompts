#!/usr/bin/env bash
# Fully autonomous issue loop orchestrator powered by Codex CLI (non-interactive)
# - Cleans to main (no untracked)
# - Checks relevance and may auto-close
# - Creates branch
# - Uses Codex CLI to implement fix (non-interactive)
# - Opens PR, self-review loop with Codex, decides success
# - Merge policy: auto-merge only when --all is set; otherwise require manual check
# - Returns to clean main at the end of each iteration
#
# Usage:
#   scripts/issue_orchestrate_auto.sh [--label <name>|--all] [--limit N] [--squash|--rebase|--merge] [--repo owner/name]
# Env:
#   TEST_CMD Optional local test command (e.g., "make test-ci"), used in prompts
#

# Prevent accidental sourcing (which would cause 'exit' to close the caller shell)
if [[ "${BASH_SOURCE[0]}" != "$0" ]]; then
  echo "This script must be executed, not sourced. Run: scripts/issue_orchestrate_auto.sh [--label <name>|--all] [--limit N] [--squash|--rebase|--merge]" >&2
  return 2
fi

set -euo pipefail
trap 'echo "[orchestrate] Interrupted by user (Ctrl+C)." >&2; exit 130' INT
# Helpful error trap to diagnose unexpected exits under set -e
trap 'rc=$?; echo "[orchestrate][ERR] exit=$rc at line ${LINENO}; last cmd: \"${BASH_COMMAND}\"" >&2' ERR
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

# Debug flag (can be toggled via --debug or DEBUG=1)
debug=${DEBUG:-0}
if [[ $debug -eq 1 ]]; then
  set -x
fi

label=""     # default: all open issues (filtered by --label when provided)
limit=999999
merge_method="--squash"
repo_override=""
auto_merge=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --label) label="$2"; shift 2;;
    --all) label=""; auto_merge=true; shift 1;;
    --limit) limit="$2"; shift 2;;
    --merge|--squash|--rebase) merge_method="$1"; shift 1;;
    --repo) repo_override="$2"; shift 2;;
    --debug) debug=1; shift 1;;
    *) echo "Unknown arg: $1" >&2; exit 2;;
  esac
done

# Re-evaluate debug after parsing flags
if [[ $debug -eq 1 ]]; then
  set -x
fi

# If a repository override is provided, make gh target it by default
if [[ -n "$repo_override" ]]; then
  export GH_REPO="$repo_override"
  echo "[orchestrate] gh repo override: $GH_REPO" >&2
fi

need() { command -v "$1" >/dev/null 2>&1 || { echo "Missing dependency: $1" >&2; exit 1; }; }
need gh
need codex

# Ensure Ctrl+C (SIGINT) reaches child processes run under `timeout`.
# Use `--foreground` when available so users can abort cleanly.
if timeout --help 2>&1 | grep -q -- '--foreground'; then
  TIMEOUT=(timeout --foreground)
else
  TIMEOUT=(timeout)
fi

# Standard test timeout enforcement
: "${TEST_TIMEOUT:=300s}"

# Longer defaults to keep Codex runs alive (fewer restarts)
: "${CODEX_REBASE_TIMEOUT:=120m}"
: "${CODEX_PR_TIMEOUT:=30m}"
: "${CODEX_CI_FIX_TIMEOUT:=180m}"
: "${CODEX_FIX_TIMEOUT:=90m}"
# Hard cap for local tests. If tests exceed this, treat as hang/too slow.
: "${LOCAL_TEST_TIMEOUT:=${TEST_TIMEOUT}}"

# Lightweight per-issue context (carried across separate Codex exec calls)
context_file_for_issue() {
  local inum="$1"; echo "/tmp/codex_issue_${inum}.context";
}
append_context() {
  local inum="${1-}"; shift || true
  local msg="$*"
  local f; f=$(context_file_for_issue "${inum:-}")
  printf "[%s] %s\n" "$(date -Iseconds)" "$msg" >>"$f" 2>/dev/null || true
}

# Banner: resolved repo
echo "[orchestrate] repo_root=$(pwd) remote=$(git remote get-url origin 2>/dev/null || echo 'none')" >&2

has_untracked() { [[ -n "$(git ls-files --others --exclude-standard)" ]]; }
has_mods() { ! git diff --quiet || ! git diff --cached --quiet; }
print_dirty() { echo "Working tree has changes:" >&2; git status --short >&2 || true; }

# Detect whether a rebase is in progress
rebase_in_progress() {
  [[ -d .git/rebase-merge || -d .git/rebase-apply ]]
}

# Attempt to rebase the feature branch onto base and, if conflicts arise,
# instruct Codex to resolve them autonomously. Push with --force-with-lease.
# Returns 0 when branch is rebased and conflict-free, 1 otherwise.
rebase_and_resolve_conflicts() {
  local pr_num="${1-}"; shift || true
  local branch="$1"; shift || true
  local pr_json base merge_state
  pr_json=$(gh pr view "${pr_num:-}" --json baseRefName,mergeStateStatus 2>/dev/null || true)
  if [[ -z "$pr_json" || "$pr_json" == "null" ]]; then
    return 0
  fi
  base=$(echo "$pr_json" | jq -r '.baseRefName')
  merge_state=$(echo "$pr_json" | jq -r '.mergeStateStatus')
  case "$merge_state" in
    BEHIND|DIRTY)
      echo "[rebase] PR #${pr_num:-?} is $merge_state relative to $base. Rebasing $branch onto origin/$base" >&2
      git fetch origin "$base" "$branch" || true
      git checkout "$branch"
      if git rebase "origin/$base"; then
        git push --force-with-lease
        return 0
      fi
      # Conflicts: hand off to Codex to resolve and continue rebase
      local attempt=1 max_attempts=10
      while rebase_in_progress && (( attempt <= max_attempts )); do
        echo "[rebase] Conflicts during rebase (attempt $attempt/$max_attempts). Handing to Codex." >&2
        local conflicted
        conflicted=$(git diff --name-only --diff-filter=U || true)
        local prompt history cf inum
        # Best-effort: include recent context lines if available
        inum=$(infer_issue_from_current_branch || true)
        history=""
        if [[ -n "${inum:-}" ]]; then
          cf=$(context_file_for_issue "${inum:-}"); [[ -f "$cf" ]] && history=$(tail -n 200 "$cf" 2>/dev/null || true)
        fi
        prompt=$(cat << EOF
You are resolving an in-progress Git rebase with merge conflicts.

Goal: Resolve all conflicts cleanly, preserve both intended changes, and complete the rebase. Then run tests locally to ensure correctness, stage specific files, and continue the rebase.

Rules:
- Do NOT abort the rebase. Fix conflicts file-by-file.
- Keep changes minimal; do not reformat unrelated code. No random markdown reports.
- Stage only resolved files explicitly (no `git add .`).
- After resolving all conflicts, run `git rebase --continue`.
- If tests fail post-continue, create follow-up fix commits on the branch and push.

Tips:
- Use conflict markers (<<<<<<<, =======, >>>>>>>) to identify sections.
- If a file can be resolved by choosing one side entirely, do so deliberately.
- When both changes should be kept, integrate them carefully and compile/tests locally.

Context (recent log):
${history}
EOF
        )
        CONFLICTED_FILES="$conflicted" BRANCH="$branch" BASE="$base" "${TIMEOUT[@]}" "${CODEX_REBASE_TIMEOUT:-45m}" codex exec --dangerously-bypass-approvals-and-sandbox --cd "$repo_root" - <<EOF
$prompt
EOF
        # If still conflicted, let Codex try again next loop; otherwise continue
        if rebase_in_progress; then
          # Ensure any resolved files are staged; try to continue
          if git rebase --continue; then :; fi
        fi
        ((attempt++))
      done
      if ! rebase_in_progress; then
        git push --force-with-lease
        return 0
      fi
      echo "[rebase] Unable to complete rebase automatically after $max_attempts attempts." >&2
      return 1
      ;;
    *)
      return 0
      ;;
  esac
}

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

# List open PRs likely created by this automation (branch name pattern)
list_open_codex_prs() {
  gh pr list --state open --json number,headRefName --jq '.[] | select(.headRefName|test("^fix/issue-")) | .number' 2>/dev/null || true
}

# If any open PRs exist, process them first and exit to avoid parallelizing issues
process_any_open_codex_prs_first() {
  local prs
  prs=$(list_open_codex_prs | tr '\n' ' ')
  if [[ -n "${prs// /}" ]]; then
    echo "[gate] Found open PR(s) on fix/issue-* branches: $prs" >&2
    for pr in $prs; do
      local branch inum
      branch=$(checkout_pr_branch "$pr")
      # Try to infer issue number for context
      inum=$(infer_issue_from_current_branch || echo "0")
      process_existing_pr "$pr" "$inum" "$branch"
      ensure_clean_main
    done
    # After handling open PRs, continue only if none remain; otherwise exit
    # Continue to iterate new issues even if PRs remain open.
    # Rationale: caller requested `--all`; prefer throughput over strict serialization.
    local remaining
    remaining=$(list_open_codex_prs | tr '\n' ' ')
    if [[ -n "${remaining// /}" ]]; then
      echo "[gate] PRs still open after processing: $remaining; continuing to new issues." >&2
    else
      echo "[gate] All open PRs handled; continuing to new issues." >&2
    fi
  fi
}

# Process an existing PR end-to-end: review, rebase if needed, wait for checks, merge or remediate
process_existing_pr() {
  local pr_number="${1-}"; shift || true
  local inum="${1-}"; shift || true
  local branch="$1"; shift || true

  # Self-review loop with Codex to refine PR
  codex_pr_self_review "$pr_number" "$inum"

  # Move PR out of draft if still draft
  if gh pr view "$pr_number" --json isDraft --jq '.isDraft' | grep -qi true; then
    gh pr ready "$pr_number" || true
  fi

  # Ensure branch is up to date and conflict-free relative to base before watching checks
  rebase_and_resolve_conflicts "$pr_number" "$branch" || true
  # Watch checks; auto-merge if --all was provided, otherwise handoff for manual review
  echo "Waiting for CI on PR #$pr_number" >&2
  if gh pr checks "$pr_number" --watch; then
    if [[ "$auto_merge" == true ]]; then
      if maybe_merge_pr "$pr_number"; then
        echo "Merged PR #$pr_number via $merge_method." >&2
        codex_post_merge_close_issue "$pr_number" "$inum"
      else
        echo "Auto-merge failed or not allowed for PR #$pr_number; leaving open for manual follow-up." >&2
      fi
    else
      echo "CI green for PR #$pr_number. Manual check required before merge (no --all)." >&2
    fi
  else
    echo "CI not successful for PR #$pr_number; handing back to Codex for remediation." >&2
    if codex_ci_fix_loop "$pr_number" "$inum" "$branch"; then
      if [[ "$auto_merge" == true ]]; then
        if maybe_merge_pr "$pr_number"; then
          echo "Merged PR #$pr_number via $merge_method after remediation." >&2
          codex_post_merge_close_issue "$pr_number" "$inum"
        else
          echo "Auto-merge failed or not allowed for PR #$pr_number after remediation; leaving open." >&2
        fi
      else
        echo "CI turned green after remediation for PR #$pr_number. Manual check required before merge (no --all)." >&2
      fi
    else
      echo "CI still failing after remediation attempts; cleaning up PR #$pr_number." >&2
      cleanup_pr "$pr_number"
    fi
  fi
}

# Merge a PR safely if allowed; returns 0 on successful merge
maybe_merge_pr() {
  local pr_num="$1"
  # Ensure not draft
  if gh pr view "$pr_num" --json isDraft --jq '.isDraft' | grep -qi true; then
    gh pr ready "$pr_num" || true
  fi
  # Check mergeable state
  local merge_state
  merge_state=$(gh pr view "$pr_num" --json mergeStateStatus --jq '.mergeStateStatus' 2>/dev/null || echo "")
  case "$merge_state" in
    CLEAN|HAS_HOOKS|UNKNOWN|'') : ;;
    *)
      echo "[merge] PR #$pr_num not mergeable state: $merge_state" >&2
      return 1
      ;;
  esac
  # Attempt merge with selected method; fall back to --squash if needed
  set +e
  gh pr merge "$pr_num" "$merge_method" --delete-branch --admin=false
  local rc=$?
  if [[ $rc -ne 0 && "$merge_method" != "--squash" ]]; then
    echo "[merge] Retry with --squash for PR #$pr_num" >&2
    gh pr merge "$pr_num" --squash --delete-branch --admin=false
    rc=$?
  fi
  set -e
  return $rc
}

# Post-merge: delegate to Codex to ensure issue is closed, add brief summary
codex_post_merge_close_issue() {
  local pr_num="$1"; shift || true
  local issue_num="$1"; shift || true
  local prompt
  prompt=$(cat << 'EOF'
You are operating in a Git repository with GitHub CLI.

Task: Verify PR and issue status post-merge and ensure the referenced issue is closed.

Steps:
1) Verify PR $PR_NUM is merged: `gh pr view $PR_NUM --json state,isDraft,mergedAt,url`.
2) Check issue $ISSUE_NUM state. If still open, close it: `gh issue close $ISSUE_NUM --comment "Resolved by PR #$PR_NUM"`.
3) If PR title/body did not include "fixes #$ISSUE_NUM", add a PR comment noting the linkage for audit.
4) Print a one-line summary: "closed #$ISSUE_NUM via PR #$PR_NUM".

Rules:
- Be concise. No extra markdown reports. Use gh CLI only.
- Do not reopen issues. Only close if PR is merged.
EOF
  )
  PR_NUM="$pr_num" ISSUE_NUM="$issue_num" "${TIMEOUT[@]}" "${CODEX_PR_TIMEOUT:-10m}" codex exec --dangerously-bypass-approvals-and-sandbox --cd "$repo_root" - <<EOF
$prompt
EOF
}

# Infer issue number from current branch or its PR (best-effort)
infer_issue_from_current_branch() {
  local cur
  cur=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "")
  if [[ -z "$cur" || "$cur" == "main" ]]; then
    return 1
  fi
  # Try branch naming: fix/issue-123-...
  local n
  n=$(echo "$cur" | sed -nE 's/.*issue-([0-9]+).*/\1/p' || true)
  if [[ -n "$n" ]]; then
    echo "$n"
    return 0
  fi
  # Try PR for this branch; extract first referenced issue number from title/body
  local pr_json
  pr_json=$(gh pr list --head "$cur" --json number,title,body --limit 1 2>/dev/null || true)
  if [[ -n "$pr_json" && "$pr_json" != "[]" ]]; then
    local ref
    ref=$(echo "$pr_json" | jq -r '.[0] | ((.title // "") + "\n" + (.body // ""))' \
      | grep -Eo '#[0-9]+' | head -n1 | tr -d '#')
    if [[ -n "$ref" ]]; then
      echo "$ref"
      return 0
    fi
  fi
  return 1
}

# If starting on a non-main branch, run the workflow for that branch until PR merge
progress_current_branch_if_needed() {
  local cur
  cur=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "")
  if [[ -z "$cur" || "$cur" == "main" ]]; then
    return 0
  fi
  local inum
  if ! inum=$(infer_issue_from_current_branch); then
    echo "[orchestrate] On branch '$cur' but could not infer related issue; skipping special handling." >&2
    return 0
  fi
  echo "[orchestrate] Continuing current branch '$cur' for issue #$inum before iterating issues." >&2

  # Ensure we stay on the current branch
  git fetch origin "$cur":"$cur" || true
  if git show-ref --verify --quiet "refs/heads/$cur"; then
    git checkout "$cur" && git pull --rebase origin "$cur" || true
  else
    git checkout -b "$cur" --track "origin/$cur" || git checkout "$cur"
  fi

  # Check for an existing PR first to avoid duplicating work
  local pr_number pr_url
  pr_number=$(gh pr list --head "$cur" --json number --limit 1 --jq '.[0].number' 2>/dev/null || true)
  if [[ -n "$pr_number" ]]; then
    pr_url=$(gh pr view "$pr_number" --json url --jq '.url' 2>/dev/null || echo "")
    echo "PR: ${pr_url:-#${pr_number}} (existing)" >&2
    process_existing_pr "$pr_number" "$inum" "$cur"
  else
    # No PR yet; assess whether implementation might already be complete
    if run_local_tests; then
      # Only create a PR if there are commits ahead of main; otherwise implement first
      git fetch origin main >/dev/null 2>&1 || true
      ahead=$(git rev-list --count "origin/main..HEAD" 2>/dev/null || echo 0)
      if [[ "${ahead:-0}" -gt 0 ]]; then
        pr_url=$(open_pr_if_missing "$inum")
        if [[ -n "$pr_url" ]]; then echo "PR: $pr_url" >&2; fi
        if pr_number=$(gh pr view "$pr_url" --json number --jq '.number' 2>/dev/null); then
          process_existing_pr "$pr_number" "$inum" "$cur"
        else
          echo "Could not resolve PR number for URL: $pr_url" >&2
        fi
      else
        echo "[pre-PR] Tests pass locally but no commits yet; implementing first." >&2
        codex_fix_issue "$inum"
      fi
    else
      # Local tests failing: run Codex autonomous implementation loop before opening PR
      local pre_attempt=1; local pre_max=3
      while (( pre_attempt <= pre_max )); do
        echo "[pre-PR] Local tests failing; handing back to Codex (attempt $pre_attempt/$pre_max)" >&2
        codex_fix_issue "$inum"
        if ! git diff --quiet || ! git diff --cached --quiet || [[ -n "$(git ls-files --others --exclude-standard)" ]]; then
          stage_all_changes
          if ! git diff --cached --quiet; then
            git commit -m "fix: continue resolving issue #$inum (pre-PR)"
            git push
          fi
        fi
        if run_local_tests; then break; fi
        ((pre_attempt++))
      done
      pr_url=$(open_pr_if_missing "$inum")
      if [[ -n "$pr_url" ]]; then echo "PR: $pr_url" >&2; fi
      if pr_number=$(gh pr view "$pr_url" --json number --jq '.number' 2>/dev/null); then
        process_existing_pr "$pr_number" "$inum" "$cur"
      else
        echo "Could not resolve PR number for URL: $pr_url" >&2
      fi
    fi
  fi

  # Return to a clean main to continue with normal iteration
  ensure_clean_main
}

# --- Codex autonomous loops ---
codex_fix_issue() {
  local inum="${1-}"; shift || true
  # Non-interactive Codex session to implement the fix on current branch
  # Provide tight instructions consistent with Codex Development Rules
  local prompt history cf
  history=""
  cf=$(context_file_for_issue "${inum:-}"); [[ -f "$cf" ]] && history=$(tail -n 200 "$cf" 2>/dev/null || true)
  prompt=$(cat << EOF
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
 - Before making changes, check whether a PR already exists for this branch and assess progress to avoid duplicate work. If the implementation appears complete and tests pass, skip coding and proceed to PR review/merge workflow.

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

Context (recent log):
${history}
EOF
  )

  ISSUE_NUM="${inum:-}" "${TIMEOUT[@]}" "${CODEX_FIX_TIMEOUT:-60m}" codex exec --dangerously-bypass-approvals-and-sandbox --cd "$repo_root" - <<EOF
$prompt
EOF
}

codex_pr_self_review() {
  local pr_num="${1-}"; shift || true
  local inum="${1-}"; shift || true
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
    PR_NUM="${pr_num:-}" ISSUE_NUM="$inum" "${TIMEOUT[@]}" "${CODEX_REVIEW_TIMEOUT:-60m}" codex exec --dangerously-bypass-approvals-and-sandbox --cd "$repo_root" - <<EOF
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
      git commit -m "chore: self-review improvements (#${pr_num:-unknown})"
      git push
    fi
  done
}

open_pr_if_missing() {
  local inum="$1"
  # If a PR already exists for this issue, return its URL
  local existing pr_url
  existing=$(gh pr list --search "in:title #${inum:-} in:body #${inum:-}" --json number --jq '.[].number' 2>/dev/null || true)
  if [[ -n "$existing" ]]; then
    gh pr view "$existing" --json url --jq '.url'
    return 0
  fi

  # Only attempt PR creation when the branch is ahead of base
  git fetch origin main >/dev/null 2>&1 || true
  local ahead
  ahead=$(git rev-list --count "origin/main..HEAD" 2>/dev/null || echo 0)
  if [[ "${ahead:-0}" -eq 0 ]]; then
    echo ""  # no commits yet; let caller continue implementation
    return 0
  fi

  # Delegate PR creation to Codex with explicit instructions; echo only the URL
  local prompt out url
  prompt=$(cat << 'EOF'
You are operating in a Git repository with GitHub CLI installed.

Task: Open a Pull Request from the current branch to `main` for the referenced issue.

Requirements:
- Read the issue title with `gh issue view $ISSUE_NUM --json title --jq '.title'`.
- Construct PR title: `fix: <issue-title-truncated-to-64> (fixes #$ISSUE_NUM)`.
- Create the PR as draft with a concise body template (summary/evidence placeholders).
- Use `gh pr create` targeting base `main` and the current branch.
- At the end, print ONLY the PR URL (no extra text).

Notes:
- If a PR already exists, print its URL and exit.
- If PR creation fails for any reason, do not print anything.
EOF
  )
  ISSUE_NUM="${inum:-}" "${TIMEOUT[@]}" "${CODEX_PR_TIMEOUT:-10m}" codex exec --dangerously-bypass-approvals-and-sandbox --cd "$repo_root" - <<EOF
$prompt
EOF
  out=$?
  # Best-effort: fetch latest PR for this branch and return its URL
  pr_url=$(gh pr list --head "$(git rev-parse --abbrev-ref HEAD)" --json url --limit 1 --jq '.[0].url' 2>/dev/null || true)
  if [[ -n "$pr_url" ]]; then
    echo "$pr_url"
    append_context "${inum:-}" "PR opened: $pr_url"
  else
    echo ""  # no PR created or could not resolve URL; let caller proceed
  fi
  return 0
}

find_existing_pr_number() {
  local inum="$1"
  gh pr list --search "in:title #${inum:-} in:body #${inum:-}" --json number --jq '.[].number' 2>/dev/null | head -n1
}

checkout_pr_branch() {
  local pr_num="${1-}"
  local branch
  branch=$(gh pr view "${pr_num:-}" --json headRefName --jq '.headRefName')
  git fetch origin "$branch":"$branch" || true
  if git show-ref --verify --quiet "refs/heads/$branch"; then
    git checkout "$branch"
    git pull --rebase origin "$branch" || true
  else
    git checkout -b "$branch" --track "origin/$branch" || git checkout "$branch"
  fi
  echo "$branch"
}

# Create or checkout a feature branch for an issue and push it
create_issue_branch() {
  local issue_num="$1"
  # Ensure clean tree
  if ! git diff --quiet || ! git diff --cached --quiet; then
    echo "Working tree not clean. Commit or stash first." >&2
    return 1
  fi
  # Sync main
  git fetch origin
  git checkout main
  git pull --rebase origin main
  # Derive slug from issue title
  local title slug branch
  title=$(gh issue view "$issue_num" --json title --jq '.title' 2>/dev/null || echo "")
  if [[ -z "$title" ]]; then
    echo "Failed to get issue title for #${issue_num}" >&2
    return 1
  fi
  slug=$(echo "$title" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g; s/^-+|-+$//g' | cut -c1-40)
  branch="fix/issue-${issue_num}-${slug}"
  if git rev-parse --verify "$branch" >/dev/null 2>&1; then
    git checkout "$branch"
  else
    git checkout -b "$branch"
  fi
  git push -u origin "$branch" >/dev/null 2>&1 || true
  echo "$branch"
}

# Close PR and delete related branches (local + remote)
cleanup_pr() {
  local pr_num="$1"
  local branch
  branch=$(gh pr view "$pr_num" --json headRefName --jq '.headRefName')
  gh pr close "$pr_num" --delete-branch=false
  git fetch origin
  if git ls-remote --exit-code --heads origin "$branch" >/dev/null 2>&1; then
    git push origin --delete "$branch" || true
  fi
  if git show-ref --verify --quiet "refs/heads/$branch"; then
    local current
    current=$(git rev-parse --abbrev-ref HEAD)
    if [[ "$current" == "$branch" ]]; then
      git checkout main
    fi
    git branch -D "$branch" || true
  fi
  echo "Cleaned up branch $branch for PR #$pr_num" >&2
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
  if [[ -n "${TEST_CMD:-}" ]]; then
    cmd="$TEST_CMD"
  else
    echo "[tests] Skipping local full-suite run (delegated to Codex/CI)." >&2
    return 0
  fi
  echo "[tests] Running (explicit): $cmd" >&2
  if "${TIMEOUT[@]}" "${LOCAL_TEST_TIMEOUT}" bash -lc "$cmd" >"$log" 2>&1; then rc=0; else rc=$?; fi
  if [[ $rc -eq 124 ]]; then echo "[tests] Timeout reached (${LOCAL_TEST_TIMEOUT})." >&2; fi
  tail -n 50 "$log" >&2 || true
  rm -f "$log" || true
  return $rc
}

codex_ci_fix_loop() {
  local pr_num="${1-}"; shift || true
  local inum="${1-}"; shift || true
  local branch="$1"; shift || true
  local max_attempts=10
  local attempt=1
  while (( attempt <= max_attempts )); do
    echo "[CI Fix] Attempt $attempt on PR #$pr_num (branch $branch)" >&2
    # Ensure branch is rebased on base and conflicts are resolved before CI
    rebase_and_resolve_conflicts "$pr_num" "$branch" || true
    local prompt history cf
    history=""
    cf=$(context_file_for_issue "${inum:-}"); [[ -f "$cf" ]] && history=$(tail -n 200 "$cf" 2>/dev/null || true)
    prompt=$(cat << EOF
You are operating on a PR with failing CI.

Task: Diagnose the CI failures, read GitHub Actions logs, fix issues locally, push commits, and re-trigger CI until green.

Steps:
1) Inspect latest CI runs for the branch: `gh run list --branch "$BRANCH" --event pull_request --json databaseId,workflowName,status,conclusion,url --limit 5` and view logs for failed jobs using `gh run view <run-id> --json jobs --log`.
2) Reproduce locally (run tests/linters/build) and fix the root cause. Keep changes minimal and scoped to this PR.
3) Add/adjust tests as needed to prevent regression; run locally to green.
4) Stage specific files only; commit with clear message; push.
5) If there is nothing actionable (external flake), document minimal retry (e.g., rebase to retrigger) and proceed.
6) Monitor PR checks until completion with: `gh pr checks <PR#> --watch` (prefer this over generic "wait for CI on GitHub").

Rules:
- No random markdown reports. Put evidence in commit messages or PR body if appropriate.
- Do not broaden scope. Keep functions small and style consistent.

Context (recent log):
${history}
EOF
    )
    PR_NUM="${pr_num:-}" ISSUE_NUM="$inum" BRANCH="$branch" "${TIMEOUT[@]}" "${CODEX_CI_FIX_TIMEOUT:-60m}" codex exec --dangerously-bypass-approvals-and-sandbox --cd "$repo_root" - <<EOF
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
        git commit -m "fix(ci): address CI failures on PR #${pr_num:-unknown}"
        git push
      fi
    fi

    echo "Waiting for CI after attempt $attempt..." >&2
    if gh pr checks "${pr_num:-}" --watch; then
      return 0
    fi
    ((attempt++))
  done
  return 1
}

# Fetch issues
# Hard gate: do not proceed if any fix/issue-* PR is still open
process_any_open_codex_prs_first

# Show which repo gh targets
gh_repo_effective=$(gh repo view --json nameWithOwner --jq .nameWithOwner 2>/dev/null || echo "")
[[ -n "$gh_repo_effective" ]] && echo "[orchestrate] gh repo: $gh_repo_effective" >&2

fetch_open_issues() {
  if [[ -n "$label" ]]; then
    if [[ -n "$repo_override" ]]; then
      gh issue list -R "$repo_override" --state open --label "$label" --json number --limit 500 --jq '.[].number' || true
    else
      gh issue list --state open --label "$label" --json number --limit 500 --jq '.[].number' || true
    fi
  else
    if [[ -n "$repo_override" ]]; then
      gh issue list -R "$repo_override" --state open --json number --limit 500 --jq '.[].number' || true
    else
      gh issue list --state open --json number --limit 500 --jq '.[].number' || true
    fi
  fi
}

run_issue_pass() {
  local issues
  issues=$(fetch_open_issues)
  mapfile -t issues_arr <<< "$issues"
  if [[ ${#issues_arr[@]} -eq 0 ]]; then
    echo "No open issues to process." >&2
    return 1
  fi
  echo "[orchestrate] Issues to process: ${#issues_arr[@]} => ${issues_arr[*]}" >&2

  # Pre-loop: if we're starting on a non-main branch, finish its workflow first
  progress_current_branch_if_needed

  count=0
  for inum in "${issues_arr[@]}"; do
  # Reset per-iteration state to avoid leaking values across issues
  unset pr_url pr_number branch exist_branch existing_pr
  ensure_clean_main
  append_context "${inum:-}" "Start processing issue #${inum:-unknown} in repo $(git config --get remote.origin.url | sed 's#.*:##; s#.git$##')"

  # Relevance check with auto-close if obsolete
  if "$self_dir/issue_check_relevance.sh" "$inum" --auto-close; then
    :
  else
    rc=$?
    if [[ $rc -eq 11 || $rc -eq 10 ]]; then
      continue
    fi
  fi

  echo "=== [AUTO] Processing issue #${inum:-unknown} ==="

  # Use existing PR/branch if present; otherwise create branch
  existing_pr=$(find_existing_pr_number "$inum" || true)
  if [[ -n "$existing_pr" ]]; then
    echo "Found existing PR #$existing_pr for issue #${inum:-unknown}; continuing work (avoid duplicate implementation)." >&2
    branch=$(checkout_pr_branch "$existing_pr")
    pr_url=$(gh pr view "$existing_pr" --json url --jq '.url')
    if pr_number=$(gh pr view "$existing_pr" --json number --jq '.number' 2>/dev/null); then
      process_existing_pr "$pr_number" "$inum" "$branch"
      ensure_clean_main
      count=$((count+1))
      if (( count >= limit )); then break; fi
      continue
    fi
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
      # Create and switch to branch (also pushes). If this fails (e.g., issue no longer exists
      # or is inaccessible), skip gracefully instead of exiting the whole orchestrator.
      if ! branch=$(create_issue_branch "$inum"); then
        echo "[skip] Could not create branch for issue #${inum:-unknown} (likely closed/missing or GH error)." >&2
        ensure_clean_main
        count=$((count+1))
        if (( count >= limit )); then break; fi
        continue
      fi
    fi
  fi
  echo "Branch: $branch"

  # If no PR exists yet for this issue, only create after code changes exist
  if [[ -z "${pr_url:-}" ]]; then
    if run_local_tests; then
      git fetch origin main >/dev/null 2>&1 || true
      ahead=$(git rev-list --count "origin/main..HEAD" 2>/dev/null || echo 0)
      if [[ "${ahead:-0}" -gt 0 ]]; then
        pr_url=$(open_pr_if_missing "$inum")
        if [[ -n "$pr_url" ]]; then echo "PR: $pr_url" >&2; fi
        if pr_number=$(gh pr view "$pr_url" --json number --jq '.number' 2>/dev/null); then
          process_existing_pr "$pr_number" "$inum" "$branch"
          ensure_clean_main
          count=$((count+1))
          if (( count >= limit )); then break; fi
          continue
        fi
      fi
    fi
  fi

  # Otherwise, proceed with implementation loop to get local tests green, then PR
  codex_fix_issue "$inum"
  if ! git diff --quiet || ! git diff --cached --quiet || [[ -n "$(git ls-files --others --exclude-standard)" ]]; then
    stage_all_changes
    if ! git diff --cached --quiet; then
      git commit -m "fix: attempt to resolve issue #$inum (auto)"
      git push
    fi
  fi
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

  if [[ -z "${pr_url:-}" ]]; then
    pr_url=$(open_pr_if_missing "$inum")
  fi
  if [[ -n "$pr_url" ]]; then
    echo "PR: $pr_url"
    if pr_number=$(gh pr view "$pr_url" --json number --jq '.number' 2>/dev/null); then
      process_existing_pr "$pr_number" "${inum:-}" "$branch"
    else
      echo "Could not resolve PR number for URL: $pr_url" >&2
    fi
  else
    echo "[pre-PR] No PR created yet (likely no commits ahead). Continuing implementation." >&2
  fi

  ensure_clean_main
  count=$((count+1))
  echo "[orchestrate] Completed issue #${inum:-unknown} ($count/${#issues_arr[@]})." >&2
  if (( count >= limit )); then break; fi

  done
  echo "Issue pass complete (processed $count)." >&2
  return 0
}

if [[ "$auto_merge" == true ]]; then
  while true; do
    if ! run_issue_pass; then
      echo "All targeted issues resolved; exiting (--all)." >&2
      break
    fi
  done
else
  run_issue_pass || true
  echo "Autonomous issue processing complete (single pass)." >&2
fi
