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
single_issue=""
use_claude=${CLAUDE_CODE:-0}  # Can be set via env or --claude flag

while [[ $# -gt 0 ]]; do
  case "$1" in
    --label) label="$2"; shift 2;;
    --all) label=""; auto_merge=true; shift 1;;
    --limit)
      if [[ ! "$2" =~ ^[0-9]+$ ]]; then
        echo "Invalid --limit value: $2" >&2
        exit 2
      fi
      limit="$2"
      shift 2
      ;;
    --merge|--squash|--rebase) merge_method="$1"; shift 1;;
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
if timeout --help 2>&1 | grep -q -- '--foreground'; then
  TIMEOUT=(timeout --foreground)
else
  TIMEOUT=(timeout)
fi

# Sanitize text for inclusion in Codex prompts: strip ANSI, CRs, and cap size
sanitize_for_prompt() {
  sed -E -e 's/\x1B\[[0-9;]*[A-Za-z]//g' -e 's/\r//g' | head -c 4000
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

# Lightweight per-issue context (carried across separate Codex exec calls)
context_file_for_issue() {
  local inum="${1-}"
  echo "/tmp/codex_issue_${inum}.context"
}
append_context() {
  local inum="${1-}"; shift || true
  local msg="$*"
  local f; f=$(context_file_for_issue "${inum:-}")
  printf "[%s] %s\n" "$(date -Iseconds)" "$msg" >>"$f" 2>/dev/null || true
}

# Per-PR state tracking to gate self-review until a second pass
pr_state_file() { echo "/tmp/codex_pr_${1}.state"; }
mark_first_pass_done() {
  local f; f=$(pr_state_file "$1")
  { [[ -f "$f" ]] || :; } && { grep -q '^first_pass_done=1' "$f" 2>/dev/null || echo 'first_pass_done=1' >>"$f"; }
}
is_first_pass_done() {
  local f; f=$(pr_state_file "$1")
  [[ -f "$f" ]] && grep -q '^first_pass_done=1' "$f" 2>/dev/null
}
mark_local_review_submitted() {
  local f; f=$(pr_state_file "$1")
  { [[ -f "$f" ]] || :; } && { grep -q '^local_review_submitted=1' "$f" 2>/dev/null || echo 'local_review_submitted=1' >>"$f"; }
}
is_local_review_submitted() {
  local f; f=$(pr_state_file "$1")
  [[ -f "$f" ]] && grep -q '^local_review_submitted=1' "$f" 2>/dev/null
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
  git fetch origin "$base" "$branch" || true
  if git show-ref --verify --quiet "refs/heads/$branch"; then
    git checkout "$branch"
  else
    git checkout -b "$branch" --track "origin/$branch" || git checkout "$branch"
  fi

  local need_rebase=false
  case "$merge_state" in
    BEHIND|DIRTY|UNKNOWN|UNSTABLE|'')
      need_rebase=true
      ;;
  esac

  if [[ $need_rebase == false ]]; then
    if git rev-parse --verify --quiet "origin/$base" >/dev/null 2>&1; then
      if ! git merge-base --is-ancestor "origin/$base" "$branch" 2>/dev/null; then
        need_rebase=true
      fi
    fi
  fi

  if [[ $need_rebase == false ]]; then
    return 0
  fi

  echo "[rebase] PR #${pr_num:-?} mergeStateStatus=$merge_state; ensuring $branch is rebased onto origin/$base" >&2
  if git rebase --autostash "origin/$base"; then
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
      cf=$(context_file_for_issue "${inum:-}")
      [[ -f "$cf" ]] && history=$(tail -n 200 "$cf" 2>/dev/null | sanitize_for_prompt || true)
    fi
    # Build prompt with a literal here-doc to avoid command substitution from backticks
    prompt=$(cat << 'EOF'
You are resolving an in-progress Git rebase with merge conflicts.

Goal: Resolve all conflicts cleanly, preserve both intended changes, and complete the rebase. Then run tests locally to ensure correctness, stage specific files, and continue the rebase.

Rules:
- Do NOT abort the rebase. Fix conflicts file-by-file.
- Keep changes focused; minor local cleanups OK. No unrelated edits. Markdown
  only in PR/issue per policy.
- Stage only resolved files explicitly (no `git add .`).
- After resolving all conflicts, run `git rebase --continue`.
- If tests fail post-continue, create follow-up fix commits on the branch and push.

Tips:
- Use conflict markers (<<<<<<<, =======, >>>>>>>) to identify sections.
- If a file can be resolved by choosing one side entirely, do so deliberately.
- When both changes should be kept, integrate them carefully and compile/tests locally.

Context (recent log):
EOF
    )
    prompt+=$'\n'
    prompt+="$history"
    if [[ $use_claude -eq 1 ]]; then
      # Claude Code version - pass prompt as properly escaped string argument
      CONFLICTED_FILES="$conflicted" BRANCH="$branch" BASE="$base" "${TIMEOUT[@]}" "${CODEX_REBASE_TIMEOUT}" claude --print --dangerously-skip-permissions "$prompt"
    else
      CONFLICTED_FILES="$conflicted" BRANCH="$branch" BASE="$base" "${TIMEOUT[@]}" "${CODEX_REBASE_TIMEOUT}" codex exec --dangerously-bypass-approvals-and-sandbox --cd "$repo_root" -- "$prompt" < /dev/null
    fi
    # If still conflicted, let Codex try again next loop; otherwise continue
    if rebase_in_progress; then
      # Ensure any resolved files are staged; try to continue
      if git rebase --continue; then :; fi
    fi
    ((attempt+=1))
  done
  if ! rebase_in_progress; then
    git push --force-with-lease
    return 0
  fi
  echo "[rebase] Unable to complete rebase automatically after $max_attempts attempts." >&2
  return 1
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
  git pull --rebase --autostash origin main
}

# List open non-draft PRs likely created by this automation (branch name pattern)
list_open_non_draft_codex_prs() {
  gh pr list --state open --json number,headRefName,isDraft \
    --jq '.[] | select(.headRefName|test("^fix/issue-")) | select(.isDraft|not) | .number' \
    2>/dev/null || true
}

# Hard gate: do not open new PRs while non-draft PRs are open. Process them and exit if any remain.
enforce_no_parallel_prs() {
  local prs
  prs=$(list_open_non_draft_codex_prs | tr '\n' ' ')
  if [[ -n "${prs// /}" ]]; then
    echo "[gate] Found open non-draft PR(s): $prs. Processing before any new work." >&2
    for pr in $prs; do
      local branch inum
      branch=$(checkout_pr_branch "$pr")
      inum=$(infer_issue_from_current_branch || echo "0")
      process_existing_pr "$pr" "$inum" "$branch"
      ensure_clean_main
    done
    # Re-check; if any still open, exit to strictly forbid parallel PRs
    local remaining
    remaining=$(list_open_non_draft_codex_prs | tr '\n' ' ')
    if [[ -n "${remaining// /}" ]]; then
      echo "[gate] Non-draft PRs still open after processing: $remaining. Not creating new PRs." >&2
      exit 0
    fi
  echo "[gate] No remaining non-draft PRs; continuing." >&2
  fi
}

# Address PR review feedback by reading unresolved review threads and applying targeted fixes.
codex_address_review_feedback() {
  local pr_num="${1-}"; shift || true
  local inum="${1-}"; shift || true
  local branch="$1"; shift || true
  local max_rounds=3
  local round
  for round in $(seq 1 $max_rounds); do
    echo "[Review Fix] Round $round for PR #$pr_num (branch $branch)" >&2
    # Build a focused prompt to read review threads and implement fixes
    local prompt history cf
    history=""
    cf=$(context_file_for_issue "${inum:-}")
    [[ -f "$cf" ]] && history=$(tail -n 200 "$cf" 2>/dev/null | sanitize_for_prompt || true)
    prompt=$(cat << 'EOF'
You are addressing reviewer feedback on a GitHub Pull Request.

Goal: Read PR reviews and comments, apply the requested changes, and push commits to resolve the feedback. Address feedback and nearby code only; small local cleanups OK.

Steps:
1) Inspect PR reviews and comments:
   - `gh pr view "$PR_NUM" --json reviews,reviewThreads,comments,files,headRefName,baseRefName,url`
   - Read each review (state, body) and comment text; scan diffs where referenced.
2) For each actionable item, make the necessary code/test/doc changes to satisfy the request.
3) Run local tests/linters/build to verify. Keep changes minimal and targeted.
4) Stage only related files explicitly; commit with a clear message; push.
5) Stop when there is no more actionable feedback.

Rules:
- No unrelated edits or broad refactors. Markdown only in PR/issue per policy.
- Keep functions small and follow project style. Do not skip tests.

Context (recent log):
EOF
    )
    prompt+=$'\n'
    prompt+="$history"
    if [[ $use_claude -eq 1 ]]; then
      PR_NUM="${pr_num:-}" ISSUE_NUM="${inum:-}" BRANCH="$branch" "${TIMEOUT[@]}" "${CODEX_PR_TIMEOUT}" claude --print --dangerously-skip-permissions "$prompt"
    else
      PR_NUM="${pr_num:-}" ISSUE_NUM="${inum:-}" BRANCH="$branch" "${TIMEOUT[@]}" "${CODEX_PR_TIMEOUT}" codex exec --dangerously-bypass-approvals-and-sandbox --cd "$repo_root" -- "$prompt" < /dev/null
    fi

    # Commit and push if there are staged or unstaged changes
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
        git commit -m "fix(review): address reviewer feedback on PR #${pr_num:-unknown}"
        git push
      fi
    fi

    # If no further local changes, stop early
    if git diff --quiet && git diff --cached --quiet; then
      echo "[Review Fix] No local changes after round $round; stopping." >&2
      break
    fi
  done
}

# Process an existing PR end-to-end: review, rebase if needed, wait for checks, merge or remediate
process_existing_pr() {
  local pr_number="${1-}"; shift || true
  local inum="${1-}"; shift || true
  local branch="$1"; shift || true

  # First pass: address outstanding review feedback if it hasn't been handled yet.
  if ! is_first_pass_done "$pr_number"; then
    echo "[review] First pass; addressing review comments." >&2
    codex_address_review_feedback "$pr_number" "$inum" "$branch" || true
    mark_first_pass_done "$pr_number"
  else
    echo "[review] Review feedback already handled earlier; skipping first-pass loop." >&2
  fi

  # Second pass: always run self-review + submit local review exactly once per PR.
  if is_local_review_submitted "$pr_number"; then
    echo "[review] Local review already submitted for PR #$pr_number; skipping self-review." >&2
  else
    echo "[review] Running self-review." >&2
    codex_pr_self_review "$pr_number" "$inum"
    codex_submit_local_pr_review "$pr_number" "$inum" || true
  fi

  # Move PR out of draft if still draft
  if gh pr view "$pr_number" --json isDraft --jq '.isDraft' | grep -qi true; then
    gh pr ready "$pr_number" || true
  fi

  # Check for thumbs up reaction as approval signal
  local has_thumbs_up
  has_thumbs_up=$(gh api "repos/{owner}/{repo}/pulls/$pr_number" --jq '.reactions | if . then map(select(.content == "+1")) | length > 0 else false end' 2>/dev/null || echo "false")
  if [[ "$has_thumbs_up" == "true" ]]; then
    echo "[orchestrate] PR #$pr_number has thumbs up reaction - proceeding with merge" >&2
  fi

  # Ensure branch is up to date and conflict-free relative to base before watching checks
  rebase_and_resolve_conflicts "$pr_number" "$branch" || true
  # Watch checks; auto-merge if --all was provided or thumbs up received, otherwise handoff for manual review
  echo "Waiting for CI on PR #$pr_number" >&2
  if gh pr checks "$pr_number" --watch; then
    if [[ "$auto_merge" == true || "$has_thumbs_up" == "true" ]]; then
      if maybe_merge_pr "$pr_number"; then
        echo "Merged PR #$pr_number via $merge_method." >&2
        codex_post_merge_close_issue "$pr_number" "$inum"
      else
        echo "Auto-merge failed or not allowed for PR #$pr_number; leaving open for manual follow-up." >&2
      fi
    else
      echo "CI green for PR #$pr_number. Manual check required before merge (no --all or thumbs up)." >&2
    fi
  else
    echo "CI not successful for PR #$pr_number; handing back to Codex for remediation." >&2
    if codex_ci_fix_loop "$pr_number" "$inum" "$branch"; then
      # Re-check for thumbs up after CI fixes
      has_thumbs_up=$(gh api "repos/{owner}/{repo}/pulls/$pr_number" --jq '.reactions | if . then map(select(.content == "+1")) | length > 0 else false end' 2>/dev/null || echo "false")
      if [[ "$auto_merge" == true || "$has_thumbs_up" == "true" ]]; then
        if maybe_merge_pr "$pr_number"; then
          echo "Merged PR #$pr_number via $merge_method after remediation." >&2
          codex_post_merge_close_issue "$pr_number" "$inum"
        else
          echo "Auto-merge failed or not allowed for PR #$pr_number after remediation; leaving open." >&2
        fi
      else
        echo "CI turned green after remediation for PR #$pr_number. Manual check required before merge (no --all or thumbs up)." >&2
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
  # Ensure required checks succeeded before considering merge
  if ! gh pr checks "$pr_num" >/dev/null; then
    echo "[merge] PR #$pr_num checks not successful" >&2
    return 1
  fi
  # Do not block on unresolved review threads; two-pass policy handles feedback resolution.
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
  # Verify PR is merged
  local pr_state merged_at
  pr_state=$(gh pr view "$pr_num" --json state,isDraft,mergedAt,url --jq '.state' 2>/dev/null || echo "")
  merged_at=$(gh pr view "$pr_num" --json mergedAt --jq '.mergedAt' 2>/dev/null || echo "null")
  if [[ "$pr_state" != "MERGED" && "$merged_at" == "null" ]]; then
    echo "[post-merge] PR #$pr_num not merged; skipping issue close." >&2
    return 0
  fi
  # Compose an evidence-rich comment before closing the issue
  local repo_url pr_url merge_commit sha_short files_json
  repo_url=$(gh repo view --json url --jq '.url' 2>/dev/null || echo "")
  pr_url=$(gh pr view "$pr_num" --json url --jq '.url' 2>/dev/null || echo "")
  merge_commit=$(gh pr view "$pr_num" --json mergeCommit --jq '.mergeCommit.oid // empty' 2>/dev/null || echo "")
  sha_short=$(printf "%s" "$merge_commit" | cut -c1-12)
  files_json=$(gh pr view "$pr_num" --json files --jq '[.files[]?.path] // []' 2>/dev/null || echo '[]')

  # Build per-file links to the merged blob for stable references
  # Limit to first 20 files to keep the comment readable
  local file_links max_files
  max_files=20
  file_links=""
  if [[ -n "$repo_url" && -n "$merge_commit" ]]; then
    # Convert files_json (array of strings) to newline list and iterate
    while IFS= read -r f; do
      [[ -z "$f" ]] && continue
      file_links+="- ${repo_url}/blob/${merge_commit}/$f\n"
      max_files=$((max_files-1))
      [[ $max_files -le 0 ]] && break
    done < <(jq -r '.[]' <<<"$files_json")
  fi

  # Links section
  local pr_files_url pr_commits_url merge_commit_url checks_url
  pr_files_url="${pr_url}/files"
  pr_commits_url="${pr_url}/commits"
  merge_commit_url="${repo_url}/commit/${merge_commit}"
  checks_url="$pr_url"  # Checks tab is in PR UI

  # Create a temporary markdown body file to avoid shell quoting issues
  local tmp
  tmp=$(mktemp)
  cat >"$tmp" <<'MD'
Resolution
- Issue closed after merge of the linked PR and verification of changes.

Evidence
- PR: __PR_URL__
- Merge commit: `__SHA_SHORT__` (__MERGE_COMMIT_URL__)
- Files changed (first N):
__FILE_LINKS__

Links
- PR overview: __PR_URL__
- PR commits: __PR_COMMITS_URL__
- PR diffs: __PR_FILES_URL__
- CI/Checks: __CHECKS_URL__

Notes
- References use the merge commit to ensure stable, permanent links to the exact content merged.
MD
  # Substitute placeholders safely
  sed -i \
    -e "s|__PR_URL__|${pr_url//|/\|}|g" \
    -e "s|__SHA_SHORT__|${sha_short//|/\|}|g" \
    -e "s|__MERGE_COMMIT_URL__|${merge_commit_url//|/\|}|g" \
    -e "s|__PR_COMMITS_URL__|${pr_commits_url//|/\|}|g" \
    -e "s|__PR_FILES_URL__|${pr_files_url//|/\|}|g" \
    -e "s|__CHECKS_URL__|${checks_url//|/\|}|g" \
    -e "s|__FILE_LINKS__|${file_links//$'\n'/'\\n'}|g" "$tmp"

  # Post the evidence comment, then close the issue
  local issue_state
  issue_state=$(gh issue view "$issue_num" --json state --jq '.state' 2>/dev/null || echo "")
  if [[ "$issue_state" == "OPEN" ]]; then
    gh issue comment "$issue_num" --body-file "$tmp" || true
    gh issue close "$issue_num" --reason completed || gh issue close "$issue_num" || true
  fi
  rm -f "$tmp" || true

  # Add PR comment noting linkage if body/title lacks fixes reference
  local pr_body pr_title
  pr_title=$(gh pr view "$pr_num" --json title --jq '.title' 2>/dev/null || echo "")
  pr_body=$(gh pr view "$pr_num" --json body --jq '.body' 2>/dev/null || echo "")
  if ! printf "%s\n%s" "$pr_title" "$pr_body" | grep -qi "fixes #$issue_num"; then
    # Use a body file to safely include inline code backticks without shell substitution
    local tmp_prc
    tmp_prc=$(mktemp)
    {
      printf "Closed issue \`%s\` (merged). See the issue for evidence links.\n" "#$issue_num"
    } >"$tmp_prc"
    gh pr comment "$pr_num" --body-file "$tmp_prc" || true
    rm -f "$tmp_prc" || true
  fi
  echo "closed #$issue_num via PR #$pr_num"
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
  echo "[orchestrate] Continuing current branch '$cur' for issue #${inum:-} before iterating issues." >&2

  # Ensure we stay on the current branch
  git fetch origin "$cur":"$cur" || true
  if git show-ref --verify --quiet "refs/heads/$cur"; then
    git checkout "$cur" && git pull --rebase --autostash origin "$cur" || true
  else
    git checkout -b "$cur" --track "origin/$cur" || git checkout "$cur"
  fi

  # Check for an existing PR first to avoid duplicating work
  local pr_number pr_url is_draft
  pr_number=$(gh pr list --head "$cur" --json number,isDraft --limit 1 --jq '.[0].number' 2>/dev/null || true)
  if [[ -n "$pr_number" ]]; then
    is_draft=$(gh pr view "$pr_number" --json isDraft --jq '.isDraft' 2>/dev/null || echo "false")
    pr_url=$(gh pr view "$pr_number" --json url --jq '.url' 2>/dev/null || echo "")
    echo "PR: ${pr_url:-#${pr_number}} (existing)" >&2
    if [[ "$is_draft" == "true" ]]; then
      echo "[gate] Existing PR is draft; ignoring per policy." >&2
      return 0
    fi
    process_existing_pr "$pr_number" "$inum" "$cur"
  else
    # No PR yet; forbid creating a new one if others are open
    local others
    others=$(list_open_non_draft_codex_prs | tr '\n' ' ')
    if [[ -n "${others// /}" ]]; then
      echo "[gate] Non-draft PRs exist ($others); not creating a new PR from current branch." >&2
      return 0
    fi
    # Implement on current branch and open PR through Codex
    local json
    json=$(codex_implement_current_branch "$inum" | tail -n 1)
    pr_url=$(printf "%s" "$json" | jq -r '.url // empty' 2>/dev/null || true)
    if [[ -z "$pr_url" ]]; then
      # Best-effort resolve PR from branch
      pr_url=$(gh pr list --head "$cur" --json url --limit 1 --jq '.[0].url' 2>/dev/null || echo "")
    fi
    if [[ -n "$pr_url" ]]; then echo "PR: $pr_url" >&2; fi
    if pr_number=$(gh pr view "$pr_url" --json number --jq '.number' 2>/dev/null); then
      process_existing_pr "$pr_number" "$inum" "$cur"
    else
      echo "Could not resolve PR number for URL: $pr_url" >&2
    fi
  fi

  # Return to a clean main to continue with normal iteration
  ensure_clean_main
}

# --- Codex autonomous loops ---
codex_implement_current_branch() {
  local inum="${1-}"; shift || true
  local prompt history cf cur
  history=""
  cf=$(context_file_for_issue "${inum:-}")
  [[ -f "$cf" ]] && history=$(tail -n 200 "$cf" 2>/dev/null | sanitize_for_prompt || true)
  cur=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "")
  # Build prompt safely with placeholders to avoid command substitution
  local __template
  read -r -d '' __template << 'EOF' || true
You are on branch '__CUR__' in a Git repository with GitHub CLI.

Goal: Complete implementation for issue #__INUM__ on the current branch, then open a non-draft PR only at the very end, right before handing off to review.

Process:
1) Establish baseline: detect and run available tests (make test-ci, pytest, fpm, npm). If the repository defines artifact verification, ALSO run it:
   - Prefer `make verify-artifacts` when present; otherwise use `VERIFY_CMD` or scripts under `scripts/verify_*`.
   - If nothing exists, derive minimal reproduction from the issue description and project docs.
   Record the exact commands and short excerpts as evidence.
2) Implement the fix with targeted tests; allow small local cleanups. Iterate until tests pass locally. Keep unrelated changes out.
3) Stage specific files only (no `git add .`). Commit using Conventional Commit style including "(fixes #__INUM__)" when appropriate. Push to origin for this branch.
4) As the final step: if a PR to main does not exist for this branch, create a PR (not draft) with title `fix: <issue-title-truncated-to-64> (fixes #__INUM__)`. Include a concise "Verification" section showing artifact evidence (commands run + key output excerpts and artifact paths). Do not open a PR earlier than this step.
5) Print exactly one JSON line with keys: {"issue":__INUM__, "branch":"__CUR__", "pr":<pr-number>, "url":"<pr-url>"}.

Rules:
- Markdown only in PR/issue per policy; keep outputs minimal and actionable.
- Validate with tests AND artifact checks before concluding. Do not skip tests.
- Do not claim an output-affecting fix without attaching evidence excerpts (from project verification or minimal reproduction) to the PR/issue.
- Do not reformat unrelated files. No secrets.

Context (recent log):
__HISTORY__
EOF
  prompt="$__template"
  prompt="${prompt//__CUR__/$cur}"
  prompt="${prompt//__INUM__/$inum}"
  prompt="${prompt//__HISTORY__/$history}"
  if [[ $use_claude -eq 1 ]]; then
    # Claude Code version - pass prompt as properly escaped string argument
    ISSUE_NUM="${inum:-}" BRANCH="$cur" "${TIMEOUT[@]}" "${CODEX_FIX_TIMEOUT}" claude --print --dangerously-skip-permissions "$prompt"
  else
    ISSUE_NUM="${inum:-}" BRANCH="$cur" "${TIMEOUT[@]}" "${CODEX_FIX_TIMEOUT}" codex exec --dangerously-bypass-approvals-and-sandbox --cd "$repo_root" -- "$prompt" < /dev/null
  fi
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
2) Run local tests and linters; fix failures. For output-affecting changes, run the repository’s artifact verification (e.g., `make verify-artifacts`, custom verify scripts, or documented reproductions) and include concise evidence in the PR body if missing.
3) Apply targeted improvements (tests, docs, code) to raise quality while staying within the PR scope.
4) Stage specific files only, commit with clear messages, and push.
5) If no further changes are needed, end gracefully.

Rules:
- No unrelated edits or broad refactors. Markdown only in PR/issue per policy.
- Keep functions under 50 lines when practical; follow project style.
- Don’t skip tests; keep everything reproducible.
EOF
  )
    if [[ $use_claude -eq 1 ]]; then
      # Claude Code version - pass prompt as properly escaped string argument
      PR_NUM="${pr_num:-}" ISSUE_NUM="$inum" "${TIMEOUT[@]}" "${CODEX_PR_TIMEOUT}" claude --print --dangerously-skip-permissions "$prompt"
    else
      PR_NUM="${pr_num:-}" ISSUE_NUM="$inum" "${TIMEOUT[@]}" "${CODEX_PR_TIMEOUT}" codex exec --dangerously-bypass-approvals-and-sandbox --cd "$repo_root" -- "$prompt" < /dev/null
    fi

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

codex_submit_local_pr_review() {
  local pr_num="${1-}"; shift || true
  local inum="${1-}"; shift || true
  if [[ -z "${pr_num:-}" ]]; then
    echo "[review] Missing PR number for local review." >&2
    return 1
  fi
  if is_local_review_submitted "$pr_num"; then
    echo "[review] Local review already submitted for PR #$pr_num; skipping." >&2
    return 0
  fi

  local agents_guidelines=""
  if [[ -f "$repo_root/AGENTS.md" ]]; then
    agents_guidelines=$(sanitize_for_prompt < "$repo_root/AGENTS.md" 2>/dev/null || true)
  fi
  if [[ -z "${agents_guidelines//[[:space:]]/}" ]]; then
    agents_guidelines="(AGENTS.md unavailable)"
  fi

  local template
  read -r -d '' template <<'EOF' || true
You are an autonomous senior reviewer evaluating Pull Request #__PR__.
Repository root: __ROOT__.

Engineering standards (apply rigorously):
__AGENTS__

Task: Perform a full review of this PR so your findings can be submitted via `gh pr review`. Use GitHub CLI and local tools available in this repository.

Checklist:
1) Inspect PR metadata and diff with `gh pr view $PR_NUM --json files,commits,body,number,baseRefName,headRefName,url` and fetch changed files if needed.
2) Evaluate code, tests, docs, performance, and style against the engineering standards above. Pay special attention to Fortran-specific conventions (kinds, formatting, modules) and build/test workflow expectations.
3) Confirm that verification exists (tests, artifacts, docs). Recommend additional coverage when missing and cite exact commands.
4) Identify blocking issues, potential regressions, or polish opportunities. Reference concrete files/lines and required follow-up.
5) Decide whether to approve, request changes, or leave a comment. Approve only when the PR is production-ready and fully verified.

Output format (exact):
FINAL_REVIEW_STATUS: <approve|request_changes|comment>
FINAL_REVIEW_COMMENT:
<markdown feedback suitable for gh pr review>
END_REVIEW_COMMENT

The comment must be concise yet thorough, citing evidence and specific guidance. Do not repeat the AGENTS text itself.
EOF

  local prompt="$template"
  prompt="${prompt//__PR__/$pr_num}"
  prompt="${prompt//__ROOT__/$repo_root}"
  prompt="${prompt//__AGENTS__/$agents_guidelines}"

  local output status
  if [[ $use_claude -eq 1 ]]; then
    set +e
    output=$(PR_NUM="${pr_num:-}" ISSUE_NUM="${inum:-}" "${TIMEOUT[@]}" "${CODEX_PR_TIMEOUT}" claude --print --dangerously-skip-permissions "$prompt")
    status=$?
    set -e
  else
    set +e
    output=$(PR_NUM="${pr_num:-}" ISSUE_NUM="${inum:-}" "${TIMEOUT[@]}" "${CODEX_PR_TIMEOUT}" codex exec --dangerously-bypass-approvals-and-sandbox --cd "$repo_root" -- "$prompt" < /dev/null)
    status=$?
    set -e
  fi
  if (( status != 0 )); then
    echo "[review] Local model review execution failed with status $status." >&2
    return 1
  fi

  local review_status
  review_status=$(sed -n 's/^FINAL_REVIEW_STATUS:[[:space:]]*//p' <<<"$output" | tail -n 1 | tr '[:upper:]' '[:lower:]' | tr -d '\r')
  review_status=${review_status%% *}
  if [[ -z "${review_status:-}" ]]; then
    review_status="comment"
  fi

  local review_body
  review_body=$(sed -n '/^FINAL_REVIEW_COMMENT:$/,/^END_REVIEW_COMMENT$/p' <<<"$output" | sed '1d;$d')
  review_body=$(printf '%s' "$review_body" | sed -e 's/[[:space:]]*$//')
  if [[ -z "${review_body//[[:space:]]/}" ]]; then
    echo "[review] Local model did not produce review body; skipping submission." >&2
    return 1
  fi

  local flag
  case "$review_status" in
    approve)
      flag="--approve"
      ;;
    request_changes|request-changes|requestchanges)
      flag="--request-changes"
      review_status="request_changes"
      ;;
    *)
      flag="--comment"
      review_status="comment"
      ;;
  esac

  if ! gh pr review "$pr_num" "$flag" --body "$review_body"; then
    echo "[review] Failed to submit local review for PR #$pr_num." >&2
    return 1
  fi

  mark_local_review_submitted "$pr_num"
  echo "[review] Submitted local model review ($review_status) for PR #$pr_num." >&2
  return 0
}


checkout_pr_branch() {
  local pr_num="${1-}"
  local branch
  branch=$(gh pr view "${pr_num:-}" --json headRefName --jq '.headRefName')
  git fetch origin "$branch":"$branch" || true
  if git show-ref --verify --quiet "refs/heads/$branch"; then
    git checkout "$branch"
    git pull --rebase --autostash origin "$branch" || true
  else
    git checkout -b "$branch" --track "origin/$branch" || git checkout "$branch"
  fi
  echo "$branch"
}

# Create or checkout a feature branch for an issue and push it

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

## removed: stage_all_changes(), run_local_tests() — no longer used

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
    cf=$(context_file_for_issue "${inum:-}")
    [[ -f "$cf" ]] && history=$(tail -n 200 "$cf" 2>/dev/null | sanitize_for_prompt || true)
    # Build prompt with literal here-doc and append history to avoid command substitution
    prompt=$(cat << 'EOF'
You are operating on a PR with failing CI.

Task: Diagnose the CI failures, read GitHub Actions logs, fix issues locally, push commits, and re-trigger CI until green.

Steps:
1) Inspect latest CI runs for the branch: `gh run list --branch "$BRANCH" --event pull_request --json databaseId,workflowName,status,conclusion,url --limit 5` and view logs for failed jobs using `gh run view <run-id> --json jobs --log`.
2) Reproduce locally (run tests/linters/build) and fix the root cause. Stay within PR scope; local cleanups OK.
3) Add/adjust tests as needed to prevent regression; run locally to green.
4) Stage specific files only; commit with clear message; push.
5) If there is nothing actionable (external flake), document minimal retry (e.g., rebase to retrigger) and proceed.
6) Monitor PR checks until completion with: `gh pr checks <PR#> --watch` (prefer this over generic "wait for CI on GitHub").

Rules:
- Markdown only in PR/issue per policy. Put evidence in commit messages or PR body when appropriate.
- Stay within scope; keep functions small and style consistent.

Context (recent log):
EOF
    )
    prompt+=$'\n'
    prompt+="$history"
    if [[ $use_claude -eq 1 ]]; then
      # Claude Code version - pass prompt as properly escaped string argument
      PR_NUM="${pr_num:-}" ISSUE_NUM="$inum" BRANCH="$branch" "${TIMEOUT[@]}" "${CODEX_CI_FIX_TIMEOUT}" claude --print --dangerously-skip-permissions "$prompt"
    else
      PR_NUM="${pr_num:-}" ISSUE_NUM="$inum" BRANCH="$branch" "${TIMEOUT[@]}" "${CODEX_CI_FIX_TIMEOUT}" codex exec --dangerously-bypass-approvals-and-sandbox --cd "$repo_root" -- "$prompt" < /dev/null
    fi

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
    ((attempt+=1))
  done
  return 1
}

# Fetch issues
# Hard gate: do not proceed if any fix/issue-* PR is still open
enforce_no_parallel_prs

# Show which repo gh targets
gh_repo_effective=$(gh repo view --json nameWithOwner --jq .nameWithOwner 2>/dev/null || echo "")
[[ -n "$gh_repo_effective" ]] && echo "[orchestrate] gh repo: $gh_repo_effective" >&2

codex_implement_issue_single_prompt() {
  # Single Codex session: select highest-priority relevant issue, implement,
  # push branch, and open a PR (non-draft). No JSON handshake; the orchestrator will
  # discover the created/updated PR afterwards.
  local prompt
  prompt=$(cat << 'EOF'
You are operating with GitHub CLI in a Git repository.

Objective: In ONE session (single continuous context), autonomously select the next relevant issue, implement the solution end-to-end, and only at the end open a non-draft PR ready for review.

Selection & priority:
- Discover open issues yourself using gh (do not rely on any provided lists). Use:
  - Step 1 (lightweight): gh issue list --state open --limit 500 \
      --json number,title,labels,updatedAt
    Fetch titles/labels/updatedAt ONLY to avoid large payloads.
    Respect env LABEL when set (filter client-side if needed).
  - Step 2 (on-demand): For a small shortlist (e.g., top 10–20 by priority),
    fetch details as needed with gh issue view <num> --json body,labels,title
    to assess relevance. Do NOT fetch bodies for all issues.
 - Priority: labels P0>P1>P2>P3; if none present, prefer label "bug",
   then issues whose titles suggest failing tests (e.g., contains "test",
   "xfail", error names), then oldest updated.
- Relevance check: parse title/body for mentioned tests, file paths, or identifiers. For output-affecting issues, plan artifact verification (repo target/script or documented reproduction). If artifacts are missing and baseline tests pass, treat as obsolete; only when AUTO_CLOSE=1, close with a concise, evidence-based comment. Otherwise, skip auto-close.

Implementation:
- Create/checkout branch: fix/issue-<num>-<slug>.
- Run baseline tests (use TEST_CMD if provided; else try make/pytest/fpm/npm). Enforce TEST_TIMEOUT. For output-affecting issues, also run artifact verification (prefer `make verify-artifacts` or project-provided scripts/commands) and capture concise evidence.
- Implement the fix with tests; allow small local cleanups; iterate until tests pass locally. Keep commits focused. No unrelated changes.
- Stage files explicitly (no `git add .`). Use Conventional Commit: `fix: <desc> (fixes #<num>)`.
- Only as the final step, open a PR (not draft) to main (reuse if exists). Title: "fix: <issue title truncated to 64> (fixes #<num>)". Include a short "Verification" section with commands, output excerpts, and artifact paths. Do not open a PR earlier.

Rules:
- Minimal output; markdown only in PR/issue per policy.

Deliverable:
- Leave the branch pushed and a non-draft PR open and linked to the issue.
EOF
  )
  if [[ $use_claude -eq 1 ]]; then
    # Claude Code version - pass prompt as properly escaped string argument
    LABEL="${label}" AUTO_CLOSE="${AUTO_CLOSE:-}" TEST_TIMEOUT="${TEST_TIMEOUT}" TEST_CMD="${TEST_CMD:-}" "${TIMEOUT[@]}" "${CODEX_BOOTSTRAP_TIMEOUT}" claude --print --dangerously-skip-permissions "$prompt"
  else
    LABEL="${label}" AUTO_CLOSE="${AUTO_CLOSE:-}" TEST_TIMEOUT="${TEST_TIMEOUT}" TEST_CMD="${TEST_CMD:-}" "${TIMEOUT[@]}" "${CODEX_BOOTSTRAP_TIMEOUT}" codex exec --dangerously-bypass-approvals-and-sandbox --cd "$repo_root" -- "$prompt" < /dev/null
  fi
}

# Create or checkout a feature branch for a specific issue number
create_or_checkout_issue_branch() {
  local inum="$1"
  local branch="fix/issue-${inum}"
  ensure_clean_main
  git fetch origin "$branch":"$branch" || true
  if git show-ref --verify --quiet "refs/heads/$branch"; then
    git checkout "$branch"
    git pull --rebase --autostash origin "$branch" || true
  else
    git checkout -b "$branch" --track "origin/$branch" || git checkout "$branch" || git checkout -b "$branch"
  fi
  echo "$branch"
}

run_specific_issue_pass() {
  local inum="$1"
  # If we're already on a non-main branch for this issue, continue it
  local cur inferred
  cur=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "")
  inferred=$(infer_issue_from_current_branch || true)
  if [[ -n "$cur" && "$cur" != "main" && "$inferred" == "$inum" ]]; then
    echo "[orchestrate] Continuing current branch '$cur' for issue #${inum:-}." >&2
  else
    create_or_checkout_issue_branch "$inum" >/dev/null
  fi

  # Implement on current branch for this issue and open PR (respect gate)
  local json pr_url pr_number branch is_draft others
  branch=$(git rev-parse --abbrev-ref HEAD)
  # If a PR exists for this branch and is draft, ignore per policy
  pr_number=$(gh pr list --head "$branch" --json number,isDraft --limit 1 --jq '.[0].number' 2>/dev/null || true)
  if [[ -n "$pr_number" ]]; then
    is_draft=$(gh pr view "$pr_number" --json isDraft --jq '.isDraft' 2>/dev/null || echo "false")
    if [[ "$is_draft" == "true" ]]; then
      echo "[gate] Existing PR for $branch is draft; ignoring per policy." >&2
      ensure_clean_main
      return 0
    fi
  fi
  # If no PR yet and other non-draft PRs exist, do not create a new one
  if [[ -z "$pr_number" ]]; then
    others=$(list_open_non_draft_codex_prs | tr '\n' ' ')
    if [[ -n "${others// /}" ]]; then
      echo "[gate] Non-draft PRs exist ($others); not creating a new PR for issue #${inum:-}." >&2
      ensure_clean_main
      return 1
    fi
  fi

  # Implement and open PR via Codex for this issue on current branch
  json=$(codex_implement_current_branch "$inum" | tail -n 1 || true)
  pr_url=$(printf "%s" "$json" | jq -r '.url // empty' 2>/dev/null || true)
  if [[ -z "$pr_url" ]]; then
    pr_url=$(gh pr list --head "$branch" --json url --limit 1 --jq '.[0].url' 2>/dev/null || echo "")
  fi
  if [[ -z "$pr_url" ]]; then
    echo "Could not resolve PR for issue #${inum:-} on branch $branch" >&2
    ensure_clean_main
    return 1
  fi
  pr_number=$(gh pr view "$pr_url" --json number --jq '.number' 2>/dev/null || echo "")
  if [[ -z "$pr_number" ]]; then
    echo "Could not resolve PR number from URL: $pr_url" >&2
    ensure_clean_main
    return 1
  fi
  echo "PR: $pr_url" >&2
  process_existing_pr "$pr_number" "$inum" "$branch" || true
  ensure_clean_main
  echo "Issue #${inum:-} pass complete." >&2
  return 0
}

run_issue_pass() {
  # Pre-loop: if we're starting on a non-main branch, finish its workflow first
  progress_current_branch_if_needed

  ensure_clean_main
  # Early gate: if any non-draft PRs are open, do not start new work
  local open_now
  open_now=$(list_open_non_draft_codex_prs | tr '\n' ' ')
  if [[ -n "${open_now// /}" ]]; then
    echo "[gate] Non-draft PRs currently open ($open_now); skipping new issue work." >&2
    return 1
  fi
  # Record open PRs before Codex runs
  local before_json after_json pr_number branch pr_url inum
  before_json=$(gh pr list --state open --json number,headRefName,updatedAt,isDraft 2>/dev/null || echo '[]')

  # Single Codex session to select/implement/open PR
  codex_implement_issue_single_prompt || true

  # Identify newly created/updated PR to process
  after_json=$(gh pr list --state open --json number,headRefName,updatedAt,url,isDraft 2>/dev/null || echo '[]')
  # Prefer any fix/issue-* PRs that are new compared to before
  pr_number=$(jq -r --argjson before "$before_json" '
    ( .[] | select(.headRefName|test("^fix/issue-")) | select(.isDraft|not) ) as $after
    | if ([ $before[]?.headRefName ] | index($after.headRefName)) then empty else $after.number end
  ' <<<"$after_json" | head -n1)

  # Fallback: choose the most recently updated fix/issue-* PR
  if [[ -z "${pr_number:-}" ]]; then
    pr_number=$(jq -r 'map(select(.headRefName|test("^fix/issue-")) | select(.isDraft|not)) | sort_by(.updatedAt) | reverse | .[0].number // empty' <<<"$after_json")
  fi

  if [[ -z "${pr_number:-}" ]]; then
    echo "No PR found after Codex run; nothing to process." >&2
    return 1
  fi

  pr_url=$(gh pr view "$pr_number" --json url --jq '.url' 2>/dev/null || echo "")
  branch=$(gh pr view "$pr_number" --json headRefName --jq '.headRefName' 2>/dev/null || echo "")
  # Best-effort to infer issue number from branch name pattern
  inum=$(echo "$branch" | sed -n 's/^fix\/issue-\([0-9][0-9]*\).*/\1/p' || true)

  echo "PR: ${pr_url:-#${pr_number}}" >&2
  process_existing_pr "$pr_number" "${inum:-}" "${branch:-}" || true
  ensure_clean_main
  echo "Issue pass complete (processed 1)." >&2
  return 0
}

# Determine if any open issues remain according to current label filter
issues_remaining() {
  local args json count
  args=(issue list --state open --json number --limit 200)
  if [[ -n "$label" ]]; then
    args+=(--label "$label")
  fi
  if ! json=$(gh "${args[@]}" 2>/dev/null); then
    echo "[orchestrate] Warning: unable to fetch open issues; assuming issues remain." >&2
    return 0
  fi
  if ! count=$(jq -r 'length' <<<"$json" 2>/dev/null); then
    count=0
  fi
  if (( count > 0 )); then
    return 0
  fi
  return 1
}

if [[ -n "$single_issue" ]]; then
  run_specific_issue_pass "$single_issue" || true
  echo "Done processing requested issue #$single_issue." >&2
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
  else
    run_issue_pass || true
    echo "Autonomous issue processing complete (single pass)." >&2
  fi
fi
