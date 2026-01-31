---
name: fix
description: Fix failing PR CI checks. Supports multiple PRs in parallel via worktrees. No args = current PR or create new.
argument-hint: "[pr-number...]"
disable-model-invocation: true
---

# Fix Failing PR Checks

Fix failing CI checks. Supports multiple PRs in parallel using git worktrees.

## Usage
```
/fix                     # Current PR, or create new from changes
/fix 123                 # Single PR
/fix 123 456 789         # Multiple PRs in parallel worktrees
```

## PR DETECTION (when no arguments)

```bash
# 1. Check if current branch has open PR
CURRENT_PR=$(gh pr view --json number --jq '.number' 2>/dev/null)

if [ -n "$CURRENT_PR" ]; then
  echo "Working on current PR #$CURRENT_PR"
  # Continue with PR workflow
else
  # 2. Check for uncommitted changes
  if [ -n "$(git status --porcelain)" ]; then
    echo "Creating new PR from current changes"
    BRANCH="fix/$(date +%Y%m%d-%H%M%S)"
    git checkout -b "$BRANCH"
    # Stage, commit, push, create PR
  else
    echo "No PR and no changes - nothing to do"
    exit 0
  fi
fi
```

## PARALLEL EXECUTION (multiple PRs)

For each PR number, create a worktree and spawn parallel agent:

```bash
for PR in $ARGUMENTS; do
  BRANCH=$(gh pr view $PR --json headRefName --jq '.headRefName')
  WORKTREE="/tmp/worktree-$PR"

  # Create worktree if not exists
  if [ ! -d "$WORKTREE" ]; then
    git worktree add "$WORKTREE" "$BRANCH"
  fi

  # Spawn agent in background for this worktree
  # Each agent works independently in its worktree
done

# Wait for all agents to complete
# Collect and report results
```

## AGENT DELEGATION

**MANDATORY**: Spawn sergei-perfectionist-coder for implementation.

## SINGLE PR WORKFLOW

### 1. CHECK PR COMMENTS FIRST (BLOCKING)
```bash
gh pr view $PR --comments
gh api repos/{owner}/{repo}/pulls/$PR/comments --jq '.[] | "\(.user.login): \(.body)"'
```

STOP if reviewer requested specific approach. Follow it EXACTLY.

### 2. GET FAILED JOBS
```bash
BRANCH=$(gh pr view $PR --json headRefName --jq '.headRefName')
RUN_ID=$(gh run list --branch $BRANCH --limit 1 --json databaseId --jq '.[0].databaseId')
gh run view $RUN_ID --log-failed 2>&1 | grep -E "error:|Error:|FAILED|fatal:" | head -50
```

### 3. REPRODUCE AND FIX
```bash
cd $WORKTREE  # or current dir if single PR
git pull origin $BRANCH
# Build and run failing test
# Implement fix (spawn sergei-perfectionist-coder)
```

### 4. VERIFY AND PUSH
```bash
# Run tests - ALL must pass (100%)
git add <specific-files>
git commit -m "fix: <description>"
git push
```

### 5. MONITOR CI
```bash
gh run watch $RUN_ID --exit-status
```

## WORKTREE CLEANUP

After completion:
```bash
for PR in $ARGUMENTS; do
  WORKTREE="/tmp/worktree-$PR"
  git worktree remove "$WORKTREE" 2>/dev/null
done
```

## SUCCESS CRITERIA
- [ ] CI status is `completed` + `success`
- [ ] All reviewer comments addressed
- [ ] Changes committed AND pushed
- [ ] No technical debt introduced
