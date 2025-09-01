#!/usr/bin/env bash
# Merge a PR if CI is green and branch up to date
# Usage: scripts/pr_merge.sh <pr_number> [--squash|--rebase|--merge]

# Prevent accidental sourcing (which would cause 'exit' to close the caller shell)
if [[ "${BASH_SOURCE[0]}" != "$0" ]]; then
  echo "This script must be executed, not sourced. Run: scripts/pr_merge.sh <pr_number> [--squash|--rebase|--merge]" >&2
  return 2
fi

set -euo pipefail
trap 'echo "[merge] Interrupted by user (Ctrl+C)." >&2; exit 130' INT

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <pr_number> [--rebase|--merge|--squash]" >&2
  exit 2
fi

pr_num="$1"; shift || true
method="--squash"
case "${1:-}" in
  --rebase|--merge|--squash) method="$1" ;;
esac

if ! command -v gh >/dev/null 2>&1; then
  echo "gh CLI not found. Install and run 'gh auth login'." >&2
  exit 1
fi

# Ensure checks are passing (best-effort gate; branch protection is authoritative)
echo "Monitoring PR checks for #$pr_num..." >&2
if gh pr checks "$pr_num" --watch; then
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

# Final safety: ensure PR is mergeable and not behind or conflicted
merge_state=$(gh pr view "$pr_num" --json mergeStateStatus --jq '.mergeStateStatus' 2>/dev/null || echo "")
case "$merge_state" in
  CLEAN|HAS_HOOKS|UNKNOWN|'') : ;;
  *)
    echo "PR is not in a mergeable state: $merge_state. Resolve (rebase) before merging." >&2
    exit 1
    ;;
esac

# Merge with the chosen strategy (prefer squash). Retry with --squash if merge commits are disallowed
set +e
gh pr merge "$pr_num" "$method" --delete-branch --admin=false
rc=$?
set -e
if [[ $rc -ne 0 && "$method" == "--merge" ]]; then
  echo "[merge] Repository disallows merge commits. Retrying with --squash..." >&2
  gh pr merge "$pr_num" --squash --delete-branch --admin=false
fi
