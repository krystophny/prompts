#!/usr/bin/env bash
# Merge a PR if CI is green and branch up to date
# Usage: scripts/pr_merge.sh <pr_number> [--rebase|--merge|--squash]
set -euo pipefail
trap 'echo "[merge] Interrupted by user (Ctrl+C)." >&2; exit 130' INT

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <pr_number> [--rebase|--merge|--squash]" >&2
  exit 2
fi

pr_num="$1"; shift || true
method="--merge"
case "${1:-}" in
  --rebase|--merge|--squash) method="$1" ;;
esac

if ! command -v gh >/dev/null 2>&1; then
  echo "gh CLI not found. Install and run 'gh auth login'." >&2
  exit 1
fi

# Ensure checks are passing (best-effort gate; branch protection is authoritative)
# If there are no required checks, proceed to merge.
required_json=$(gh pr checks "$pr_num" --required --json bucket 2>/dev/null || echo "[]")
required_count=$(echo "$required_json" | jq -r 'length' 2>/dev/null || echo 0)
if [[ "$required_count" -eq 0 ]]; then
  echo "No required checks on PR #$pr_num; proceeding to merge." >&2
else
  echo "Waiting for required checks on PR #$pr_num..." >&2
  if gh pr checks "$pr_num" --required --watch; then
    echo "CI: success" >&2
  else
    rc=$?
    if [[ $rc -eq 8 ]]; then
      echo "CI checks still pending. Aborting merge." >&2
    else
      echo "CI not successful (exit $rc). Aborting merge." >&2
    fi
    exit 1
  fi
fi

# Final safety: ensure PR is mergeable and not behind or conflicted
merge_state=$(gh pr view "$pr_num" --json mergeStateStatus --jq '.mergeStateStatus' 2>/dev/null || echo "")
case "$merge_state" in
  CLEAN|HAS_HOOKS|UNKNOWN|'') : ;;
  *)
    echo "PR is not in a mergeable state: $merge_state. Resolve (rebase) before merging." >&2
    exit 1
    ;;
esac

# Merge with the chosen strategy
gh pr merge "$pr_num" "$method" --delete-branch --admin=false
