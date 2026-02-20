#!/usr/bin/env bash
# Fully autonomous issue loop orchestrator powered by Codex CLI or Claude Code (non-interactive)
# - Cleans to main (no untracked)
# - Checks relevance and may auto-close
# - Creates branch
# - Uses Codex CLI or Claude Code to implement fix (non-interactive)
# - Opens PR, self-review loop with Codex/Claude, decides success
# - Merge policy: auto-merge only when --all is set; otherwise require manual check
# - Returns to clean main at the end of each iteration
# - ABSOLUTELY FORBIDDEN: spamming working directory with process documentation in Markdown files
#
# 🚨 CRITICAL COMPLIANCE REQUIREMENT 🚨
# ALL review phases MUST STRICTLY validate compliance against BOTH project CLAUDE.md/AGENTS.md
# AND user CLAUDE.md/AGENTS.md with ZERO tolerance for ANY violations
#
# Usage:
#   scripts/orchestrate.sh [ISSUE_NUMBER] [--label <name>|--all] [--limit N] [--squash|--rebase|--merge] [--repo owner/name]
#     [--worker claude|codex|gemini] [--reviewer claude|codex|gemini]
#     [--worker-model MODEL] [--reviewer-model MODEL]
#     [--worker-profile PROFILE] [--reviewer-profile PROFILE]
#     [--worker-effort low|medium|high|xhigh] [--reviewer-effort low|medium|high|xhigh]
#     [--worker-enable-features f1,f2] [--reviewer-enable-features f1,f2]
#     [--worker-disable-features f1,f2] [--reviewer-disable-features f1,f2]
# Env:
#   TEST_CMD         Optional local test command (e.g., "make test-ci"), used in prompts
#   BATCH_MODE       Batch execution mode (1=true default, 0=false single-pass)
#   DEBUG            Debug output mode (1=true default, 0=false)
#   WORKER_TOOL      Tool for implementation work (claude, codex, gemini); default: codex
#   REVIEWER_TOOL    Tool for reviews (claude, codex, gemini); default: codex
#   WORKER_MODEL     Model override for worker tool (e.g., o3, claude-sonnet-4-20250514)
#   REVIEWER_MODEL   Model override for reviewer tool
#                    When unset with Codex, ~/.codex/config.toml defaults are used.
#   WORKER_PROFILE   Codex config profile for worker tool (when worker is codex)
#   REVIEWER_PROFILE Codex config profile for reviewer tool (when reviewer is codex)
#   WORKER_EFFORT    Codex reasoning effort override for worker (low|medium|high|xhigh)
#   REVIEWER_EFFORT  Codex reasoning effort override for reviewer (low|medium|high|xhigh)
#   WORKER_ENABLE_FEATURES  Comma-separated Codex feature flags to enable for worker
#   REVIEWER_ENABLE_FEATURES Comma-separated Codex feature flags to enable for reviewer
#   WORKER_DISABLE_FEATURES Comma-separated Codex feature flags to disable for worker
#   REVIEWER_DISABLE_FEATURES Comma-separated Codex feature flags to disable for reviewer
#

# Prevent accidental sourcing (which would cause 'exit' to close the caller shell)
if [[ "${BASH_SOURCE[0]}" != "$0" ]]; then
  echo "This script must be executed, not sourced. Run: scripts/orchestrate.sh [ISSUE_NUMBER] [--label <name>|--all] [--limit N] [--squash|--rebase|--merge]" >&2
  return 2
fi

set -euo pipefail
rc=0
trap 'echo "[orchestrate] Interrupted by user (Ctrl+C)." >&2; exit 130' INT
# Helpful error trap to diagnose unexpected exits under set -e
trap 'rc=$?; echo "[orchestrate][ERR] exit=$rc at line ${LINENO}; last cmd: \"${BASH_COMMAND}\"" >&2' ERR

usage() {
  cat <<'EOF'
Usage:
  scripts/orchestrate.sh [ISSUE_NUMBER|--issue N] [options]

Options:
  --label NAME                     Process only issues with label
  --all                            Enable batch mode (default; exits when no open issues remain)
  --single-pass                    Disable batch mode and run one pass
  --limit N                        Max issue passes in --all mode
  --squash|--rebase|--merge        Merge strategy (default: --squash)
  --repo OWNER/NAME                Override GH target repo
  --worker TOOL                    Implementer tool: claude|codex|gemini (default: codex)
  --reviewer TOOL                  Reviewer tool: claude|codex|gemini (default: codex)
  --worker-model MODEL             Worker model override
  --reviewer-model MODEL           Reviewer model override
  --worker-profile PROFILE         Codex worker profile override
  --reviewer-profile PROFILE       Codex reviewer profile override
  --worker-effort LEVEL            Codex worker reasoning: low|medium|high|xhigh
  --reviewer-effort LEVEL          Codex reviewer reasoning: low|medium|high|xhigh
  --worker-enable-features LIST    Comma-separated Codex feature flags to enable
  --reviewer-enable-features LIST  Comma-separated Codex feature flags to enable
  --worker-disable-features LIST   Comma-separated Codex feature flags to disable
  --reviewer-disable-features LIST Comma-separated Codex feature flags to disable
  --debug                          Enable debug tracing (default)
  --no-debug                       Disable debug tracing
  -h, --help                       Show this help

Defaults:
  - Worker and reviewer both use Codex.
  - Batch mode is enabled.
  - Debug output is enabled.
  - Model/effort/profile are inherited from ~/.codex/config.toml unless overridden.
EOF
}

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

# Debug flag (enabled by default; can be disabled via --no-debug or DEBUG=0)
debug=${DEBUG:-1}

# shellcheck disable=SC2034
label=""     # default: all open issues (filtered by --label when provided)
# shellcheck disable=SC2034
limit=999999
# shellcheck disable=SC2034
merge_method="--squash"
repo_override=""
batch_mode="${BATCH_MODE:-1}"
if [[ "$batch_mode" == "0" ]]; then
  auto_merge=false
else
  auto_merge=true
fi
all_explicit=false
single_issue=""
worker_tool="${WORKER_TOOL:-codex}"
reviewer_tool="${REVIEWER_TOOL:-codex}"
worker_model="${WORKER_MODEL:-}"
reviewer_model="${REVIEWER_MODEL:-}"
worker_profile="${WORKER_PROFILE:-}"
reviewer_profile="${REVIEWER_PROFILE:-}"
worker_effort="${WORKER_EFFORT:-}"
reviewer_effort="${REVIEWER_EFFORT:-}"
worker_enable_features="${WORKER_ENABLE_FEATURES:-}"
reviewer_enable_features="${REVIEWER_ENABLE_FEATURES:-}"
worker_disable_features="${WORKER_DISABLE_FEATURES:-}"
reviewer_disable_features="${REVIEWER_DISABLE_FEATURES:-}"

while [[ $# -gt 0 ]]; do
  case "$1" in
    -h|--help)
      usage
      exit 0
      ;;
    --label)
      # shellcheck disable=SC2034
      label="$2"
      shift 2
      ;;
    --all)
      # shellcheck disable=SC2034
      label=""
      auto_merge=true
      all_explicit=true
      shift 1
      ;;
    --single-pass)
      auto_merge=false
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
    --no-debug) debug=0; shift 1;;
    --worker)
      if [[ ! "$2" =~ ^(claude|codex|gemini)$ ]]; then
        echo "Invalid --worker value: $2 (must be claude, codex, or gemini)" >&2
        exit 2
      fi
      worker_tool="$2"
      shift 2
      ;;
    --reviewer)
      if [[ ! "$2" =~ ^(claude|codex|gemini)$ ]]; then
        echo "Invalid --reviewer value: $2 (must be claude, codex, or gemini)" >&2
        exit 2
      fi
      reviewer_tool="$2"
      shift 2
      ;;
    --worker-model)
      worker_model="$2"
      shift 2
      ;;
    --reviewer-model)
      reviewer_model="$2"
      shift 2
      ;;
    --worker-profile)
      worker_profile="$2"
      shift 2
      ;;
    --reviewer-profile)
      reviewer_profile="$2"
      shift 2
      ;;
    --worker-effort)
      worker_effort="$2"
      shift 2
      ;;
    --reviewer-effort)
      reviewer_effort="$2"
      shift 2
      ;;
    --worker-enable-features)
      worker_enable_features="$2"
      shift 2
      ;;
    --reviewer-enable-features)
      reviewer_enable_features="$2"
      shift 2
      ;;
    --worker-disable-features)
      worker_disable_features="$2"
      shift 2
      ;;
    --reviewer-disable-features)
      reviewer_disable_features="$2"
      shift 2
      ;;
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

validate_effort() {
  local role="$1" effort="$2"
  if [[ -z "$effort" ]]; then
    return 0
  fi
  if [[ ! "$effort" =~ ^(low|medium|high|xhigh)$ ]]; then
    echo "Invalid --${role}-effort value: $effort (must be low, medium, high, or xhigh)" >&2
    exit 2
  fi
}

validate_effort "worker" "$worker_effort"
validate_effort "reviewer" "$reviewer_effort"

if [[ -z "$reviewer_model" && "$reviewer_tool" == "$worker_tool" && -n "$worker_model" ]]; then
  reviewer_model="$worker_model"
fi
if [[ -z "$reviewer_profile" && "$reviewer_tool" == "$worker_tool" && -n "$worker_profile" ]]; then
  reviewer_profile="$worker_profile"
fi
if [[ -z "$reviewer_effort" && "$reviewer_tool" == "$worker_tool" && -n "$worker_effort" ]]; then
  reviewer_effort="$worker_effort"
fi
if [[ -z "$reviewer_enable_features" && "$reviewer_tool" == "$worker_tool" && -n "$worker_enable_features" ]]; then
  reviewer_enable_features="$worker_enable_features"
fi
if [[ -z "$reviewer_disable_features" && "$reviewer_tool" == "$worker_tool" && -n "$worker_disable_features" ]]; then
  reviewer_disable_features="$worker_disable_features"
fi

if [[ -n "$single_issue" && "$all_explicit" == true ]]; then
  echo "[orchestrate] Warning: ignoring --all when a specific ISSUE_NUMBER is provided." >&2
  auto_merge=false
fi

# Re-evaluate debug after parsing flags
export debug
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

# Check tools are available
for tool in "$worker_tool" "$reviewer_tool"; do
  case "$tool" in
    claude) need claude ;;
    codex) need codex ;;
    gemini) need gemini ;;
  esac
done

export WORKER_TOOL="$worker_tool"
export REVIEWER_TOOL="$reviewer_tool"
export WORKER_MODEL="$worker_model"
export REVIEWER_MODEL="$reviewer_model"
export WORKER_PROFILE="$worker_profile"
export REVIEWER_PROFILE="$reviewer_profile"
export WORKER_EFFORT="$worker_effort"
export REVIEWER_EFFORT="$reviewer_effort"
export WORKER_ENABLE_FEATURES="$worker_enable_features"
export REVIEWER_ENABLE_FEATURES="$reviewer_enable_features"
export WORKER_DISABLE_FEATURES="$worker_disable_features"
export REVIEWER_DISABLE_FEATURES="$reviewer_disable_features"

echo "[orchestrate] Using $worker_tool${worker_model:+ model=$worker_model}${worker_profile:+ profile=$worker_profile}${worker_effort:+ effort=$worker_effort} for work, $reviewer_tool${reviewer_model:+ model=$reviewer_model}${reviewer_profile:+ profile=$reviewer_profile}${reviewer_effort:+ effort=$reviewer_effort} for review (debug=${debug}, batch=${auto_merge})" >&2

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
          echo "Reached --limit $limit; exiting (batch mode)." >&2
          break
        fi
        if ! issues_remaining; then
          echo "No open issues remain that match criteria; exiting (batch mode)." >&2
          break
        fi
        continue
      fi

      if ! issues_remaining; then
        echo "No open issues remain that match criteria; exiting (batch mode)." >&2
        break
      fi

      ((idle_attempts+=1))
      echo "No actionable PR found this pass; retrying (batch mode)." >&2
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
