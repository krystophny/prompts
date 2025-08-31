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

  ISSUE_NUM="$inum" codex exec --dangerously-bypass-approvals-and-sandbox --cd "$PWD" --search - <<EOF
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
    PR_NUM="$pr_num" ISSUE_NUM="$inum" codex exec --dangerously-bypass-approvals-and-sandbox --cd "$PWD" --search - <<EOF
$prompt
EOF

    # If nothing changed in this round, we can stop (best-effort heuristic)
    if git diff --quiet && git diff --cached --quiet; then
      echo "[Codex Review] No local changes detected after round $round." >&2
      break
    fi
    # Ensure changes are committed and pushed, if any are pending
    if ! git diff --cached --quiet; then
      # Stage only reported files in index already; if none, fall back to porcelain list
      mapfile -t changed < <(git status --porcelain | awk '{print $2}')
      for f in "${changed[@]}"; do git add -- "$f"; done
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

  # Create and switch to branch (also pushes)
  branch=$("$self_dir/issue_branch.sh" "$inum")
  echo "Branch: $branch"

  # Run Codex autonomous fix loop (non-interactive) on this branch
  codex_fix_issue "$inum"

  # Auto-commit any changes (stage specific files only)
  if ! git diff --quiet || ! git diff --cached --quiet || [[ -n "$(git ls-files --others --exclude-standard)" ]]; then
    mapfile -t changed < <(git status --porcelain | awk '{print $2}')
    if (( ${#changed[@]} > 0 )); then
      for f in "${changed[@]}"; do git add -- "$f"; done
      git commit -m "fix: attempt to resolve issue #$inum (auto)"
      git push
    fi
  fi

  pr_url=$(open_pr_if_missing "$inum")
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
      echo "CI not successful for PR #$pr_number; cleaning up." >&2
      "$self_dir/pr_cleanup.sh" "$pr_number"
    fi
  else
    echo "Could not resolve PR number for URL: $pr_url" >&2
  fi

  ensure_clean_main
  ((count++))
  if (( count >= limit )); then break; fi

done

echo "Autonomous issue processing complete (processed $count)."
