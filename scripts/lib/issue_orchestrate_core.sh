# shellcheck shell=bash
# shellcheck disable=SC2154

pr_state_file() { echo "/tmp/codex_pr_${1}.state"; }

mark_first_pass_done() {
  local f
  f=$(pr_state_file "$1")
  { [[ -f "$f" ]] || :; } && { grep -q '^first_pass_done=1' "$f" 2>/dev/null || echo 'first_pass_done=1' >>"$f"; }
}

is_first_pass_done() {
  local f
  f=$(pr_state_file "$1")
  [[ -f "$f" ]] && grep -q '^first_pass_done=1' "$f" 2>/dev/null
}

mark_local_review_submitted() {
  increment_local_review_round "$1"
}

pr_has_open_feedback() {
  local pr_num="$1" json unresolved_threads pending_reviews
  json=$(gh pr view "$pr_num" --json reviewThreads,reviews 2>/dev/null || echo '{}')
  unresolved_threads=$(jq -r '[.reviewThreads[]? | select(.isResolved|not)] | length' <<<"$json" 2>/dev/null || echo '0')
  pending_reviews=$(jq -r '[.reviews[]? | select(.state == "CHANGES_REQUESTED" or .state == "PENDING")] | length' <<<"$json" 2>/dev/null || echo '0')
  if (( unresolved_threads > 0 || pending_reviews > 0 )); then
    return 0
  fi
  return 1
}

get_local_review_round() {
  local pr="$1" f line value
  f=$(pr_state_file "$pr")
  line=""
  value=0
  if [[ -f "$f" ]]; then
    line=$(grep -E '^local_review_round=' "$f" 2>/dev/null | tail -n 1 || true)
    if [[ -n "$line" ]]; then
      value=${line#local_review_round=}
    elif grep -q '^local_review_submitted=1' "$f" 2>/dev/null; then
      value=1
    fi
  fi
  printf '%s\n' "${value:-0}"
}

set_local_review_round() {
  local pr="$1" round="$2" f tmp
  f=$(pr_state_file "$pr")
  tmp=$(mktemp)
  if [[ -f "$f" ]]; then
    grep -v -E '^local_review_round=' "$f" >"$tmp" 2>/dev/null || true
  fi
  printf '%s\n' "local_review_round=${round}" >>"$tmp"
  mv "$tmp" "$f"
}

increment_local_review_round() {
  local pr="$1" round
  round=$(get_local_review_round "$pr")
  if [[ -z "$round" ]]; then
    round=0
  fi
  round=$((round + 1))
  set_local_review_round "$pr" "$round"
}

has_untracked() { [[ -n "$(git ls-files --others --exclude-standard)" ]]; }

has_mods() { ! git diff --quiet || ! git diff --cached --quiet; }

print_dirty() {
  echo "Working tree has changes:" >&2
  git status --short >&2 || true
}

rebase_in_progress() {
  [[ -d .git/rebase-merge || -d .git/rebase-apply ]]
}

rebase_and_resolve_conflicts() {
  local pr_num="$1" branch="$2"
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

  local attempt=1 max_attempts=10
  while rebase_in_progress && (( attempt <= max_attempts )); do
    echo "[rebase] Conflicts during rebase (attempt $attempt/$max_attempts). Handing to Codex." >&2
    local conflicted prompt
    conflicted=$(git diff --name-only --diff-filter=U || true)
    prompt=$(load_prompt rebase_conflicts.prompt)
    if [[ $use_claude -eq 1 ]]; then
      CONFLICTED_FILES="$conflicted" BRANCH="$branch" BASE="$base" "${TIMEOUT[@]}" "${CODEX_REBASE_TIMEOUT}" claude --print --dangerously-skip-permissions "$prompt"
    else
      CONFLICTED_FILES="$conflicted" BRANCH="$branch" BASE="$base" "${TIMEOUT[@]}" "${CODEX_REBASE_TIMEOUT}" codex exec --dangerously-bypass-approvals-and-sandbox --cd "$repo_root" -- "$prompt" < /dev/null
    fi
    if rebase_in_progress; then
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
  if [[ "$cur" != "main" ]]; then
    git checkout main
  fi
  git pull --rebase --autostash origin main
}

list_open_non_draft_codex_prs() {
  gh pr list --state open --json number,headRefName,isDraft \
    --jq '.[] | select(.headRefName|test("^fix/issue-")) | select(.isDraft|not) | .number' \
    2>/dev/null || true
}

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
    local remaining
    remaining=$(list_open_non_draft_codex_prs | tr '\n' ' ')
    if [[ -n "${remaining// /}" ]]; then
      echo "[gate] Non-draft PRs still open after processing: $remaining. Not creating new PRs." >&2
      exit 0
    fi
    echo "[gate] No remaining non-draft PRs; continuing." >&2
  fi
}

codex_address_review_feedback() {
  local pr_num="$1" inum="$2" branch="$3"
  local max_rounds=3 round
  for round in $(seq 1 $max_rounds); do
    echo "[Review Fix] Round $round for PR #$pr_num (branch $branch)" >&2
    local prompt
    prompt=$(load_prompt review_feedback.prompt)
    if [[ $use_claude -eq 1 ]]; then
      PR_NUM="${pr_num:-}" ISSUE_NUM="${inum:-}" BRANCH="$branch" "${TIMEOUT[@]}" "${CODEX_PR_TIMEOUT}" claude --print --dangerously-skip-permissions "$prompt"
    else
      PR_NUM="${pr_num:-}" ISSUE_NUM="${inum:-}" BRANCH="$branch" "${TIMEOUT[@]}" "${CODEX_PR_TIMEOUT}" codex exec --dangerously-bypass-approvals-and-sandbox --cd "$repo_root" -- "$prompt" < /dev/null
    fi

    if ! git diff --quiet || ! git diff --cached --quiet; then
      while IFS= read -r -d '' rec; do
        local code path
        code=${rec:0:2}
        path=${rec:3}
        case "$code" in
          D*|*D) git rm -- "$path" || true ;;
          R*) IFS= read -r -d '' newpath || true
              [[ -n "$newpath" ]] && { git rm -- "$path" || true; git add -- "$newpath" || true; }
              ;;
          *) git add -- "$path" || true ;;
        esac
      done < <(git status --porcelain -z)
      if ! git diff --cached --quiet; then
        git commit -m "fix(review): address reviewer feedback on PR #${pr_num:-unknown}"
        git push
      fi
    fi

    if git diff --quiet && git diff --cached --quiet; then
      echo "[Review Fix] No local changes after round $round; stopping." >&2
      break
    fi
  done
}

process_existing_pr() {
  local pr_number="$1" inum="$2" branch="$3"

  if ! is_first_pass_done "$pr_number"; then
    echo "[review] First pass; addressing review comments." >&2
    codex_address_review_feedback "$pr_number" "$inum" "$branch" || true
    mark_first_pass_done "$pr_number"
  fi

  local iteration=1
  while true; do
    echo "[review] Autonomous loop iteration $iteration for PR #$pr_number." >&2

    if pr_has_open_feedback "$pr_number"; then
      echo "[review] Outstanding feedback detected before self-review; invoking fix session." >&2
      codex_address_review_feedback "$pr_number" "$inum" "$branch" || true
      if pr_has_open_feedback "$pr_number"; then
        ((iteration+=1))
        continue
      fi
    fi

    codex_pr_self_review "$pr_number" "$inum" || true
    codex_submit_local_pr_review "$pr_number" "$inum" "$iteration" || true

    if gh pr view "$pr_number" --json isDraft --jq '.isDraft' | grep -qi true; then
      gh pr ready "$pr_number" || true
    fi

    rebase_and_resolve_conflicts "$pr_number" "$branch" || true

    echo "Waiting for CI on PR #$pr_number (iteration $iteration)." >&2
    if ! gh pr checks "$pr_number" --watch; then
      echo "CI not successful for PR #$pr_number; handing back to Codex for remediation." >&2
      if codex_ci_fix_loop "$pr_number" "$inum" "$branch"; then
        echo "[review] CI remediation complete; restarting loop for fresh review." >&2
        codex_address_review_feedback "$pr_number" "$inum" "$branch" || true
        ((iteration+=1))
        continue
      else
        echo "CI still failing after remediation attempts; cleaning up PR #$pr_number." >&2
        cleanup_pr "$pr_number"
        return
      fi
    fi

    echo "[review] Post-CI feedback sweep for PR #$pr_number (iteration $iteration)." >&2
    codex_address_review_feedback "$pr_number" "$inum" "$branch" || true
    if pr_has_open_feedback "$pr_number"; then
      echo "[review] Outstanding feedback remains after post-CI sweep; restarting loop." >&2
      ((iteration+=1))
      continue
    fi

    local has_thumbs_up
    has_thumbs_up=$(gh api "repos/{owner}/{repo}/pulls/$pr_number" --jq '.reactions | if . then map(select(.content == "+1")) | length > 0 else false end' 2>/dev/null || echo "false")
    if [[ "$has_thumbs_up" == "true" ]]; then
      echo "[orchestrate] PR #$pr_number has thumbs up reaction - eligible for auto-merge." >&2
    fi

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
    break
  done
}

maybe_merge_pr() {
  local pr_num="$1"
  if gh pr view "$pr_num" --json isDraft --jq '.isDraft' | grep -qi true; then
    gh pr ready "$pr_num" || true
  fi
  if ! gh pr checks "$pr_num" >/dev/null; then
    echo "[merge] PR #$pr_num checks not successful" >&2
    return 1
  fi
  local merge_state
  merge_state=$(gh pr view "$pr_num" --json mergeStateStatus --jq '.mergeStateStatus' 2>/dev/null || echo "")
  case "$merge_state" in
    CLEAN|HAS_HOOKS|UNKNOWN|'') : ;;
    *)
      echo "[merge] PR #$pr_num not mergeable state: $merge_state" >&2
      return 1
      ;;
  esac
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

codex_post_merge_close_issue() {
  local pr_num="$1" issue_num="$2"
  local pr_state merged_at
  pr_state=$(gh pr view "$pr_num" --json state,isDraft,mergedAt,url --jq '.state' 2>/dev/null || echo "")
  merged_at=$(gh pr view "$pr_num" --json mergedAt --jq '.mergedAt' 2>/dev/null || echo "null")
  if [[ "$pr_state" != "MERGED" && "$merged_at" == "null" ]]; then
    echo "[post-merge] PR #$pr_num not merged; skipping issue close." >&2
    return 0
  fi

  local repo_url pr_url merge_commit sha_short files_json
  repo_url=$(gh repo view --json url --jq '.url' 2>/dev/null || echo "")
  pr_url=$(gh pr view "$pr_num" --json url --jq '.url' 2>/dev/null || echo "")
  merge_commit=$(gh pr view "$pr_num" --json mergeCommit --jq '.mergeCommit.oid // empty' 2>/dev/null || echo "")
  sha_short=$(printf "%s" "$merge_commit" | cut -c1-12)
  files_json=$(gh pr view "$pr_num" --json files --jq '[.files[]?.path] // []' 2>/dev/null || echo '[]')

  local file_links max_files
  max_files=20
  file_links=""
  if [[ -n "$repo_url" && -n "$merge_commit" ]]; then
    while IFS= read -r f; do
      [[ -z "$f" ]] && continue
      file_links+="- ${repo_url}/blob/${merge_commit}/$f\n"
      max_files=$((max_files-1))
      [[ $max_files -le 0 ]] && break
    done < <(jq -r '.[]' <<<"$files_json")
  fi

  local pr_files_url pr_commits_url merge_commit_url checks_url
  pr_files_url="${pr_url}/files"
  pr_commits_url="${pr_url}/commits"
  merge_commit_url="${repo_url}/commit/${merge_commit}"
  checks_url="$pr_url"

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
  sed -i \
    -e "s|__PR_URL__|${pr_url//|/\|}|g" \
    -e "s|__SHA_SHORT__|${sha_short//|/\|}|g" \
    -e "s|__MERGE_COMMIT_URL__|${merge_commit_url//|/\|}|g" \
    -e "s|__PR_COMMITS_URL__|${pr_commits_url//|/\|}|g" \
    -e "s|__PR_FILES_URL__|${pr_files_url//|/\|}|g" \
    -e "s|__CHECKS_URL__|${checks_url//|/\|}|g" \
    -e "s|__FILE_LINKS__|${file_links//$'\n'/'\\n'}|g" "$tmp"

  local issue_state
  issue_state=$(gh issue view "$issue_num" --json state --jq '.state' 2>/dev/null || echo "")
  if [[ "$issue_state" == "OPEN" ]]; then
    gh issue comment "$issue_num" --body-file "$tmp" || true
    gh issue close "$issue_num" --reason completed || gh issue close "$issue_num" || true
  fi
  rm -f "$tmp" || true

  local pr_body pr_title
  pr_title=$(gh pr view "$pr_num" --json title --jq '.title' 2>/dev/null || echo "")
  pr_body=$(gh pr view "$pr_num" --json body --jq '.body' 2>/dev/null || echo "")
  if ! printf "%s\n%s" "$pr_title" "$pr_body" | grep -qi "fixes #$issue_num"; then
    local tmp_prc
    tmp_prc=$(mktemp)
    printf "Closed issue \`%s\` (merged). See the issue for evidence links.\n" "#$issue_num" >"$tmp_prc"
    gh pr comment "$pr_num" --body-file "$tmp_prc" || true
    rm -f "$tmp_prc" || true
  fi
  echo "closed #$issue_num via PR #$pr_num"
}

infer_issue_from_current_branch() {
  local cur
  cur=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "")
  if [[ -z "$cur" || "$cur" == "main" ]]; then
    return 1
  fi
  local n
  n=$(echo "$cur" | sed -nE 's/.*issue-([0-9]+).*/\1/p' || true)
  if [[ -n "$n" ]]; then
    echo "$n"
    return 0
  fi
  local pr_json
  pr_json=$(gh pr list --head "$cur" --json number,title,body --limit 1 2>/dev/null || true)
  if [[ -n "$pr_json" && "$pr_json" != "[]" ]]; then
    local ref
    ref=$(echo "$pr_json" | jq -r '.[0] | ((.title // "") + "\n" + (.body // ""))' | grep -Eo '#[0-9]+' | head -n1 | tr -d '#')
    if [[ -n "$ref" ]]; then
      echo "$ref"
      return 0
    fi
  fi
  return 1
}

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

  git fetch origin "$cur":"$cur" || true
  if git show-ref --verify --quiet "refs/heads/$cur"; then
    git checkout "$cur" && git pull --rebase --autostash origin "$cur" || true
  else
    git checkout -b "$cur" --track "origin/$cur" || git checkout "$cur"
  fi

  local pr_json pr_number pr_url pr_is_draft
  pr_json=$(gh pr list --head "$cur" --json number,isDraft,url --limit 1 2>/dev/null || echo '[]')
  pr_number=$(jq -r '.[0].number // ""' <<<"$pr_json" 2>/dev/null || echo "")
  pr_url=$(jq -r '.[0].url // ""' <<<"$pr_json" 2>/dev/null || echo "")
  pr_is_draft=$(jq -r '.[0].isDraft // false' <<<"$pr_json" 2>/dev/null || echo "false")

  if [[ -n "$pr_number" ]]; then
    local feedback_state draft_state
    if pr_has_open_feedback "$pr_number"; then
      feedback_state="open-feedback"
    else
      feedback_state="no-feedback"
    fi
    if [[ "$pr_is_draft" == "true" ]]; then
      draft_state="draft"
    else
      draft_state="ready"
    fi
    printf '[orchestrate] Branch %s review stage: PR %s (%s, %s).\n' \
      "$cur" "${pr_url:-#${pr_number}}" "$draft_state" "$feedback_state" >&2
    process_existing_pr "$pr_number" "$inum" "$cur"
    ensure_clean_main
    return 0
  fi

  local others
  others=$(list_open_non_draft_codex_prs | tr '\n' ' ')
  if [[ -n "${others// /}" ]]; then
    echo "[gate] Non-draft PRs exist ($others); not creating a new PR from current branch." >&2
    return 0
  fi

  printf '[orchestrate] Branch %s implementation stage: no PR found; creating update.\n' "$cur" >&2

  local json new_url new_number
  json=$(codex_implement_current_branch "$inum" | tail -n 1 || true)
  new_url=$(printf "%s" "$json" | jq -r '.url // empty' 2>/dev/null || true)
  if [[ -z "$new_url" ]]; then
    new_url=$(gh pr list --head "$cur" --json url --limit 1 --jq '.[0].url' 2>/dev/null || echo "")
  fi
  if [[ -n "$new_url" ]]; then
    echo "PR: $new_url" >&2
    new_number=$(gh pr view "$new_url" --json number --jq '.number' 2>/dev/null || echo "")
    if [[ -n "$new_number" ]]; then
      process_existing_pr "$new_number" "$inum" "$cur"
    else
      echo "Could not resolve PR number for URL: $new_url" >&2
    fi
  else
    echo "[orchestrate] No PR generated for branch '$cur' after implementation pass." >&2
  fi

  ensure_clean_main
}

codex_implement_current_branch() {
  local inum="$1" cur template prompt
  cur=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "")
  template=$(load_prompt implement_current_branch.prompt)
  prompt="${template//__CUR__/$cur}"
  prompt="${prompt//__INUM__/$inum}"
  if [[ $use_claude -eq 1 ]]; then
    ISSUE_NUM="${inum:-}" BRANCH="$cur" "${TIMEOUT[@]}" "${CODEX_FIX_TIMEOUT}" claude --print --dangerously-skip-permissions "$prompt"
  else
    ISSUE_NUM="${inum:-}" BRANCH="$cur" "${TIMEOUT[@]}" "${CODEX_FIX_TIMEOUT}" codex exec --dangerously-bypass-approvals-and-sandbox --cd "$repo_root" -- "$prompt" < /dev/null
  fi
}

codex_implement_issue_single_prompt() {
  local prompt
  prompt=$(load_prompt implement_issue_single.prompt)
  if [[ $use_claude -eq 1 ]]; then
    LABEL="${label}" AUTO_CLOSE="${AUTO_CLOSE:-}" TEST_TIMEOUT="${TEST_TIMEOUT}" TEST_CMD="${TEST_CMD:-}" "${TIMEOUT[@]}" "${CODEX_BOOTSTRAP_TIMEOUT}" claude --print --dangerously-skip-permissions "$prompt"
  else
    LABEL="${label}" AUTO_CLOSE="${AUTO_CLOSE:-}" TEST_TIMEOUT="${TEST_TIMEOUT}" TEST_CMD="${TEST_CMD:-}" "${TIMEOUT[@]}" "${CODEX_BOOTSTRAP_TIMEOUT}" codex exec --dangerously-bypass-approvals-and-sandbox --cd "$repo_root" -- "$prompt" < /dev/null
  fi
}

codex_pr_self_review() {
  local pr_num="$1" inum="$2" max_rounds=3 round
  for round in $(seq 1 $max_rounds); do
    echo "[Codex Review] Round $round on PR #$pr_num" >&2
    local prompt
    prompt=$(load_prompt pr_self_review.prompt)
    if [[ $use_claude -eq 1 ]]; then
      PR_NUM="${pr_num:-}" ISSUE_NUM="$inum" "${TIMEOUT[@]}" "${CODEX_PR_TIMEOUT}" claude --print --dangerously-skip-permissions "$prompt"
    else
      PR_NUM="${pr_num:-}" ISSUE_NUM="$inum" "${TIMEOUT[@]}" "${CODEX_PR_TIMEOUT}" codex exec --dangerously-bypass-approvals-and-sandbox --cd "$repo_root" -- "$prompt" < /dev/null
    fi

    if git diff --quiet && git diff --cached --quiet; then
      echo "[Codex Review] No local changes detected after round $round." >&2
      break
    fi
    if ! git diff --cached --quiet; then
      while IFS= read -r -d '' rec; do
        local code path
        code=${rec:0:2}
        path=${rec:3}
        case "$code" in
          D*|*D) git rm -- "$path" || true ;;
          R*) IFS= read -r -d '' newpath || true
              [[ -n "$newpath" ]] && { git rm -- "$path" || true; git add -- "$newpath" || true; }
              ;;
          *) git add -- "$path" || true ;;
        esac
      done < <(git status --porcelain -z)
      git commit -m "chore: self-review improvements (#${pr_num:-unknown})"
      git push
    fi
  done
}

codex_submit_local_pr_review() {
  local pr_num="$1" inum="$2" iteration_hint="$3"
  if [[ -z "${pr_num:-}" ]]; then
    echo "[review] Missing PR number for local review." >&2
    return 1
  fi

  local agents_guidelines=""
  if [[ -f "$repo_root/AGENTS.md" ]]; then
    agents_guidelines=$(sanitize_for_prompt < "$repo_root/AGENTS.md" 2>/dev/null || true)
  fi
  if [[ -z "${agents_guidelines//[[:space:]]/}" ]]; then
    agents_guidelines="(AGENTS.md unavailable)"
  fi

  local template prompt
  template=$(load_prompt local_review.prompt)
  prompt="$template"
  prompt="${prompt//__PR__/$pr_num}"
  prompt="${prompt//__ROOT__/$repo_root}"
  prompt="${prompt//__AGENTS__/$agents_guidelines}"

  local previous_round next_round
  previous_round=$(get_local_review_round "$pr_num")
  [[ -z "${previous_round:-}" ]] && previous_round=0
  if [[ -n "${iteration_hint:-}" ]]; then
    next_round="$iteration_hint"
  else
    next_round=$((previous_round + 1))
  fi

  local output status
  if [[ $use_claude -eq 1 ]]; then
    set +e
    output=$(LOCAL_REVIEW_ROUND="${next_round}" PR_NUM="${pr_num:-}" ISSUE_NUM="${inum:-}" "${TIMEOUT[@]}" "${CODEX_PR_TIMEOUT}" claude --print --dangerously-skip-permissions "$prompt")
    status=$?
    set -e
  else
    set +e
    output=$(LOCAL_REVIEW_ROUND="${next_round}" PR_NUM="${pr_num:-}" ISSUE_NUM="${inum:-}" "${TIMEOUT[@]}" "${CODEX_PR_TIMEOUT}" codex exec --dangerously-bypass-approvals-and-sandbox --cd "$repo_root" -- "$prompt" < /dev/null)
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

  if (( previous_round > 0 )) && [[ "$flag" == "--approve" ]]; then
    flag="--comment"
    review_status="comment"
  fi

  if ! gh pr review "$pr_num" "$flag" --body "$review_body"; then
    echo "[review] Failed to submit local review for PR #$pr_num." >&2
    return 1
  fi

  mark_local_review_submitted "$pr_num"
  echo "[review] Submitted local model review round $next_round ($review_status) for PR #$pr_num." >&2
  return 0
}

checkout_pr_branch() {
  local pr_num="$1" branch
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

cleanup_pr() {
  local pr_num="$1" branch
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

codex_ci_fix_loop() {
  local pr_num="$1" inum="$2" branch="$3" max_attempts=10 attempt=1
  while (( attempt <= max_attempts )); do
    echo "[CI Fix] Attempt $attempt on PR #$pr_num (branch $branch)" >&2
    rebase_and_resolve_conflicts "$pr_num" "$branch" || true
    local prompt
    prompt=$(load_prompt ci_fix.prompt)
    if [[ $use_claude -eq 1 ]]; then
      PR_NUM="${pr_num:-}" ISSUE_NUM="$inum" BRANCH="$branch" "${TIMEOUT[@]}" "${CODEX_CI_FIX_TIMEOUT}" claude --print --dangerously-skip-permissions "$prompt"
    else
      PR_NUM="${pr_num:-}" ISSUE_NUM="$inum" BRANCH="$branch" "${TIMEOUT[@]}" "${CODEX_CI_FIX_TIMEOUT}" codex exec --dangerously-bypass-approvals-and-sandbox --cd "$repo_root" -- "$prompt" < /dev/null
    fi

    if ! git diff --quiet || ! git diff --cached --quiet; then
      while IFS= read -r -d '' rec; do
        local code path
        code=${rec:0:2}
        path=${rec:3}
        case "$code" in
          D*|*D) git rm -- "$path" || true ;;
          R*) IFS= read -r -d '' newpath || true
              [[ -n "$newpath" ]] && { git rm -- "$path" || true; git add -- "$newpath" || true; }
              ;;
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
  local inum="$1" cur inferred json pr_url pr_number branch is_draft others
  cur=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "")
  inferred=$(infer_issue_from_current_branch || true)
  if [[ -n "$cur" && "$cur" != "main" && "$inferred" == "$inum" ]]; then
    echo "[orchestrate] Continuing current branch '$cur' for issue #${inum:-}." >&2
  else
    create_or_checkout_issue_branch "$inum" >/dev/null
  fi

  branch=$(git rev-parse --abbrev-ref HEAD)
  pr_number=$(gh pr list --head "$branch" --json number,isDraft --limit 1 --jq '.[0].number' 2>/dev/null || true)
  if [[ -n "$pr_number" ]]; then
    is_draft=$(gh pr view "$pr_number" --json isDraft --jq '.isDraft' 2>/dev/null || echo "false")
    if [[ "$is_draft" == "true" ]]; then
      echo "[gate] Existing PR for $branch is draft; ignoring per policy." >&2
      ensure_clean_main
      return 0
    fi
  fi
  if [[ -z "$pr_number" ]]; then
    others=$(list_open_non_draft_codex_prs | tr '\n' ' ')
    if [[ -n "${others// /}" ]]; then
      echo "[gate] Non-draft PRs exist ($others); not creating a new PR for issue #${inum:-}." >&2
      ensure_clean_main
      return 1
    fi
  fi

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
  progress_current_branch_if_needed
  ensure_clean_main
  local open_now
  open_now=$(list_open_non_draft_codex_prs | tr '\n' ' ')
  if [[ -n "${open_now// /}" ]]; then
    echo "[gate] Non-draft PRs currently open ($open_now); skipping new issue work." >&2
    return 1
  fi
  local before_json after_json pr_number branch pr_url inum
  before_json=$(gh pr list --state open --json number,headRefName,updatedAt,isDraft 2>/dev/null || echo '[]')

  codex_implement_issue_single_prompt || true

  after_json=$(gh pr list --state open --json number,headRefName,updatedAt,url,isDraft 2>/dev/null || echo '[]')
  pr_number=$(jq -r --argjson before "$before_json" '
    ( .[] | select(.headRefName|test("^fix/issue-")) | select(.isDraft|not) ) as $after
    | if ([ $before[]?.headRefName ] | index($after.headRefName)) then empty else $after.number end
  ' <<<"$after_json" | head -n1)

  if [[ -z "${pr_number:-}" ]]; then
    pr_number=$(jq -r 'map(select(.headRefName|test("^fix/issue-")) | select(.isDraft|not)) | sort_by(.updatedAt) | reverse | .[0].number // empty' <<<"$after_json")
  fi

  if [[ -z "${pr_number:-}" ]]; then
    echo "No PR found after Codex run; nothing to process." >&2
    return 1
  fi

  pr_url=$(gh pr view "$pr_number" --json url --jq '.url' 2>/dev/null || echo "")
  branch=$(gh pr view "$pr_number" --json headRefName --jq '.headRefName' 2>/dev/null || echo "")
  inum=$(echo "$branch" | sed -n 's/^fix\/issue-\([0-9][0-9]*\).*/\1/p' || true)

  echo "PR: ${pr_url:-#${pr_number}}" >&2
  process_existing_pr "$pr_number" "${inum:-}" "${branch:-}" || true
  ensure_clean_main
  echo "Issue pass complete (processed 1)." >&2
  return 0
}

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
