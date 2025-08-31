#!/usr/bin/env bash
# Poll and print CI status + URL for a PR
# Usage: scripts/pr_ci_status.sh <pr_number> [--watch]
set -euo pipefail

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

branch=$(gh pr view "$pr_num" --json headRefName --jq '.headRefName')

attempt=0
max_attempts=60
sleep_s=10

aggregate_status() {
  local pr="$1"
  # Prefer statusCheckRollup for authoritative required checks
  local pr_json
  pr_json=$(gh pr view "$pr" --json statusCheckRollup,url 2>/dev/null || true)
  if [[ -n "$pr_json" && "$pr_json" != "null" ]]; then
    local statuses
    statuses=$(echo "$pr_json" | jq -r '.statusCheckRollup // [] | length')
    if [[ "$statuses" != "0" ]]; then
      local any_in_progress any_failed url
      any_in_progress=$(echo "$pr_json" | jq -r '[.statusCheckRollup[] | select(.status != "COMPLETED")] | length')
      any_failed=$(echo "$pr_json" | jq -r '[.statusCheckRollup[] | select(.conclusion != null and .conclusion != "SUCCESS")] | length')
      url=$(gh pr view "$pr" --json url --jq '.url' 2>/dev/null || true)
      if [[ "$any_in_progress" != "0" ]]; then
        echo "status=in_progress conclusion= url=$url"
        return 2
      fi
      if [[ "$any_failed" != "0" ]]; then
        echo "status=completed conclusion=failure url=$url"
        return 0
      fi
      echo "status=completed conclusion=success url=$url"
      return 0
    fi
  fi
  # Fallback: most recent workflow run on branch
  run_json=$(gh run list --branch "$branch" --event pull_request --json databaseId,workflowName,headBranch,status,conclusion,htmlUrl --limit 5 2>/dev/null || true)
  if [[ -z "$run_json" || "$run_json" == "[]" ]]; then
    echo "No recent PR CI runs found for branch $branch" >&2
    return 1
  fi
  local status conclusion url
  status=$(echo "$run_json" | jq -r '.[0].status')
  conclusion=$(echo "$run_json" | jq -r '.[0].conclusion // ""')
  url=$(echo "$run_json" | jq -r '.[0].htmlUrl')
  echo "status=${status} conclusion=${conclusion} url=${url}"
  if [[ "$status" == "completed" ]]; then
    return 0
  else
    return 2
  fi
}

if [[ "$watch" == true ]]; then
  while (( attempt < max_attempts )); do
    if out=$(aggregate_status "$pr_num"); then
      echo "$out"
      exit 0
    else
      code=$?
      if [[ $code -eq 1 ]]; then
        echo "Waiting for CI to start... ($attempt/$max_attempts)" >&2
      else
        echo "CI running... ($attempt/$max_attempts)" >&2
      fi
      sleep "$sleep_s"
      ((attempt++))
    fi
  done
  echo "Timed out waiting for CI status." >&2
  exit 1
else
  aggregate_status "$pr_num" || exit 1
fi
