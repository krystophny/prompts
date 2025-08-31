#!/usr/bin/env bash
#!/usr/bin/env bash
# Thin wrapper to wait for PR checks using GitHub CLI.
# Usage: scripts/pr_ci_status.sh <pr_number> [--watch]
set -euo pipefail
trap 'echo "[ci-status] Interrupted by user (Ctrl+C)." >&2; exit 130' INT

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <pr_number> [--watch]" >&2
  exit 2
fi

pr_num="$1"; shift || true
watch=false; [[ "${1:-}" == "--watch" ]] && watch=true

if ! command -v gh >/dev/null 2>&1; then
  echo "gh CLI not found. Install and run 'gh auth login'." >&2
  exit 1
fi

args=(pr checks "$pr_num" --required)
if [[ "$watch" == true ]]; then
  args+=(--watch)
fi

# Delegate directly to gh; propagate its exit code and output.
gh "${args[@]}"
