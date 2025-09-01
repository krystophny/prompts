#!/usr/bin/env bash
# Close PR and delete related branches (local + remote)
# Usage: scripts/pr_cleanup.sh <pr_number>

# Prevent accidental sourcing (which would cause 'exit' to close the caller shell)
if [[ "${BASH_SOURCE[0]}" != "$0" ]]; then
  echo "This script must be executed, not sourced. Run: scripts/pr_cleanup.sh <pr_number>" >&2
  return 2
fi

set -euo pipefail
trap 'echo "[cleanup] Interrupted by user (Ctrl+C)." >&2; exit 130' INT

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <pr_number>" >&2
  exit 2
fi

pr_num="$1"

if ! command -v gh >/dev/null 2>&1; then
  echo "gh CLI not found. Install and run 'gh auth login'." >&2
  exit 1
fi

branch=$(gh pr view "$pr_num" --json headRefName --jq '.headRefName')

# Close PR
gh pr close "$pr_num" --delete-branch=false

# Delete remote branch (if exists)
git fetch origin
if git ls-remote --exit-code --heads origin "$branch" >/dev/null 2>&1; then
  git push origin --delete "$branch"
fi

# Delete local branch (if exists)
if git show-ref --verify --quiet "refs/heads/$branch"; then
  current=$(git rev-parse --abbrev-ref HEAD)
  if [[ "$current" == "$branch" ]]; then
    git checkout main
  fi
  git branch -D "$branch"
fi

echo "Cleaned up branch $branch for PR #$pr_num"
