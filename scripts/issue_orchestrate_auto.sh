#!/usr/bin/env bash
# Fully autonomous issue loop orchestrator powered by Codex CLI or Claude Code (non-interactive)
# - Cleans to main (no untracked)
# - Checks relevance and may auto-close
# - Creates branch
# - Uses Codex CLI or Claude Code to implement fix (non-interactive)
# - Opens PR, self-review loop with Codex/Claude, decides success
# - Merge policy: auto-merge only when --all is set; otherwise require manual check
# - Returns to clean main at the end of each iteration
#
# Usage:
#   scripts/issue_orchestrate_auto.sh [ISSUE_NUMBER] [--label <name>|--all] [--limit N] [--squash|--rebase|--merge] [--repo owner/name] [--claude]
# Env:
#   TEST_CMD Optional local test command (e.g., "make test-ci"), used in prompts
#   CLAUDE_CODE Set to 1 to use Claude Code instead of Codex (alternative to --claude)
#

# Prevent accidental sourcing (which would cause 'exit' to close the caller shell)
if [[ "${BASH_SOURCE[0]}" != "$0" ]]; then
  echo "This script must be executed, not sourced. Run: scripts/issue_orchestrate_auto.sh [ISSUE_NUMBER] [--label <name>|--all] [--limit N] [--squash|--rebase|--merge]" >&2
  return 2
fi

set -euo pipefail
rc=0
trap 'echo "[orchestrate] Interrupted by user (Ctrl+C)." >&2; exit 130' INT
# Helpful error trap to diagnose unexpected exits under set -e
trap 'rc=$?; echo "[orchestrate][ERR] exit=$rc at line ${LINENO}; last cmd: \"${BASH_COMMAND}\"" >&2' ERR
self_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
scripts_dir="$self_dir"
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

# shellcheck disable=SC2034
label=""     # default: all open issues (filtered by --label when provided)
# shellcheck disable=SC2034
limit=999999
# shellcheck disable=SC2034
merge_method="--squash"
repo_override=""
auto_merge=false
single_issue=""
use_claude=${CLAUDE_CODE:-0}  # Can be set via env or --claude flag

while [[ $# -gt 0 ]]; do
  case "$1" in
    --label)
      # shellcheck disable=SC2034
      label="$2"
      shift 2
      ;;
    --all)
      # shellcheck disable=SC2034
      label=""
      auto_merge=true
      shift 1
      ;;
    --limit)
      if [[ ! "$2" =~ ^[0-9]+$ ]]; then
        echo "Invalid --limit value: $2" >&2
        exit 2
      fi
      limit="$2"
      shift 2
      ;;
    --merge|--squash|--rebase)
      # shellcheck disable=SC2034
      merge_method="$1"
      shift 1
      ;;
    --repo) repo_override="$2"; shift 2;;
    --debug) debug=1; shift 1;;
    --claude) use_claude=1; shift 1;;
    --issue) single_issue="$2"; shift 2;;
    --) shift; break;;
    -*) echo "Unknown arg: $1" >&2; exit 2;;
    *)
      if [[ "$1" =~ ^[0-9]+$ ]]; then
        single_issue="$1"; shift 1
      else
        echo "Unknown arg: $1" >&2; exit 2
      fi
      ;;
  esac
done

if [[ -n "$single_issue" && "$auto_merge" == true ]]; then
  echo "[orchestrate] Warning: ignoring --all when a specific ISSUE_NUMBER is provided." >&2
  auto_merge=false
fi

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
if [[ $use_claude -eq 1 ]]; then
  need claude
  echo "[orchestrate] Using Claude Code for AI operations" >&2
else
  need codex
  echo "[orchestrate] Using Codex for AI operations" >&2
fi

# Ensure Ctrl+C (SIGINT) reaches child processes run under `timeout`.
# Use `--foreground` when available so users can abort cleanly.
# shellcheck disable=SC2034
if timeout --help 2>&1 | grep -q -- '--foreground'; then
  TIMEOUT=(timeout --foreground)
else
  TIMEOUT=(timeout)
fi

# Sanitize text for inclusion in Codex prompts: strip ANSI, CRs, and cap size
# shellcheck disable=SC2329
sanitize_for_prompt() {
  sed -E -e 's/\x1B\[[0-9;]*[A-Za-z]//g' -e 's/\r//g' | head -c 4000
}

prompts_dir="$scripts_dir/prompts"
# shellcheck disable=SC2329
require_prompt() {
  local name="$1"
  local path="$prompts_dir/$name"
  if [[ ! -f "$path" ]]; then
    echo "[orchestrate] Missing prompt: $name" >&2
    exit 1
  fi
  printf '%s' "$path"
}
# shellcheck disable=SC2329
load_prompt() {
  local path
  path=$(require_prompt "$1")
  cat "$path"
}

# Standard test timeout enforcement
: "${TEST_TIMEOUT:=300s}"

# Codex execution timeouts (uniform 30m by default; override via env if needed)
: "${CODEX_REBASE_TIMEOUT:=30m}"
: "${CODEX_PR_TIMEOUT:=30m}"
: "${CODEX_BOOTSTRAP_TIMEOUT:=30m}"
: "${CODEX_CI_FIX_TIMEOUT:=30m}"
: "${CODEX_FIX_TIMEOUT:=30m}"
# Hard cap for local tests. If tests exceed this, treat as hang/too slow.
: "${LOCAL_TEST_TIMEOUT:=${TEST_TIMEOUT}}"

echo "[orchestrate] repo_root=$(pwd) remote=$(git remote get-url origin 2>/dev/null || echo 'none')" >&2

lib_path="$scripts_dir/lib/issue_orchestrate_core.sh"
if [[ ! -f "$lib_path" ]]; then
  echo "[orchestrate] Missing library: $lib_path" >&2
  exit 1
fi
# shellcheck disable=SC1090
source "$lib_path"

enforce_no_parallel_prs

gh_repo_effective=$(gh repo view --json nameWithOwner --jq .nameWithOwner 2>/dev/null || echo "")
[[ -n "$gh_repo_effective" ]] && echo "[orchestrate] gh repo: $gh_repo_effective" >&2
if [[ -n "$single_issue" ]]; then
  run_specific_issue_pass "$single_issue" || true
  echo "Done processing requested issue #$single_issue." >&2
  if ! issues_remaining; then
    echo "No open issues remain that match criteria; exiting (single issue)." >&2
  fi
  exit 0
else
  if [[ "$auto_merge" == true ]]; then
    passes_done=0
    idle_attempts=0
    while (( passes_done < limit )); do
      if run_issue_pass; then
        ((passes_done+=1))
        idle_attempts=0
        if (( passes_done >= limit )); then
          echo "Reached --limit $limit; exiting (--all)." >&2
          break
        fi
        if ! issues_remaining; then
          echo "No open issues remain that match criteria; exiting (--all)." >&2
          break
        fi
        continue
      fi

      if ! issues_remaining; then
        echo "No open issues remain that match criteria; exiting (--all)." >&2
        break
      fi

      ((idle_attempts+=1))
      echo "No actionable PR found this pass; retrying (--all)." >&2
      sleep 5
    done
    exit 0
  else
    run_issue_pass || true
    echo "Autonomous issue processing complete (single pass)." >&2
    if ! issues_remaining; then
      echo "No open issues remain that match criteria; exiting (single pass)." >&2
    fi
    exit 0
  fi
fi
