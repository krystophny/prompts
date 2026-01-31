---
name: comments
description: Address PR comments. Supports multiple PRs in parallel via worktrees. No args = current PR.
argument-hint: "[pr-number...]"
disable-model-invocation: true
---

# Address PR Comments

Review and address comments on PRs. Supports multiple PRs in parallel using git worktrees.

## Usage
```
/comments                # Current PR
/comments 123            # Single PR
/comments 123 456 789    # Multiple PRs in parallel worktrees
```

## PR DETECTION (when no arguments)

```bash
# Check if current branch has open PR
CURRENT_PR=$(gh pr view --json number --jq '.number' 2>/dev/null)

if [ -n "$CURRENT_PR" ]; then
  echo "Working on current PR #$CURRENT_PR"
else
  echo "No open PR on current branch"
  exit 1
fi
```

## PARALLEL EXECUTION (multiple PRs)

```bash
for PR in $ARGUMENTS; do
  BRANCH=$(gh pr view $PR --json headRefName --jq '.headRefName')
  WORKTREE="/tmp/worktree-$PR"

  # Create worktree if not exists
  if [ ! -d "$WORKTREE" ]; then
    git worktree add "$WORKTREE" "$BRANCH"
  fi

  # Spawn agent in background for this worktree
done

# Wait for all agents, collect results
```

## AGENT DELEGATION

**MANDATORY**: Spawn sergei-perfectionist-coder for code changes.

## SINGLE PR WORKFLOW

### 1. GET ALL COMMENTS
```bash
gh pr view $PR --comments
gh pr view $PR --json reviews --jq '.reviews[] | "\(.author.login): \(.state)"'
gh api repos/{owner}/{repo}/pulls/$PR/comments --jq '.[] | "[\(.path):\(.line)] \(.user.login): \(.body)"'
```

### 2. FOR EACH COMMENT
- Read carefully
- Code change needed -> spawn sergei-perfectionist-coder
- Clarification needed -> reply to comment
- Disagreement -> discuss respectfully

### 3. FOLLOW-UP TRACKING
- [ ] Reviewer requested issue -> verify exists
- [ ] "Improve later" -> GitHub issue created
- [ ] Link issue numbers in PR comment

### 4. VERIFY AND PUSH
```bash
cd $WORKTREE  # or current dir
# Build and test - ALL must pass (100%)
git add <specific-files>
git commit -m "fix: address review feedback"
git push
```

### 5. REPLY TO COMMENTS
Confirm resolution by replying to each addressed comment.

### 6. REQUEST RE-REVIEW
```bash
gh pr edit $PR --add-reviewer <reviewer>
```

## WORKTREE CLEANUP

```bash
for PR in $ARGUMENTS; do
  git worktree remove "/tmp/worktree-$PR" 2>/dev/null
done
```

## TECHNICAL DEBT CHECK

| Pattern | Action |
|---------|--------|
| TODO/FIXME without issue | REJECT |
| Commented-out code | REJECT |
| Functions >100 lines | REJECT |
