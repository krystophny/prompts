---
name: check
description: Review changes before commit. Supports multiple PRs in parallel via worktrees. No args = current changes or PR.
argument-hint: "[pr-number...]"
disable-model-invocation: true
---

# Pre-Commit Check

Review changes before committing. Supports multiple PRs in parallel using git worktrees.

## Usage
```
/check                   # Current changes or current PR
/check 123               # Review PR #123
/check 123 456 789       # Multiple PRs in parallel worktrees
```

## MODE DETECTION (when no arguments)

```bash
# 1. Check for uncommitted changes
if [ -n "$(git status --porcelain)" ]; then
  echo "Reviewing uncommitted changes"
  MODE="local"
else
  # 2. Check if current branch has open PR
  CURRENT_PR=$(gh pr view --json number --jq '.number' 2>/dev/null)
  if [ -n "$CURRENT_PR" ]; then
    echo "Reviewing PR #$CURRENT_PR"
    MODE="pr"
    PR=$CURRENT_PR
  else
    echo "No changes and no PR - nothing to review"
    exit 0
  fi
fi
```

## PARALLEL EXECUTION (multiple PRs)

```bash
for PR in $ARGUMENTS; do
  BRANCH=$(gh pr view $PR --json headRefName --jq '.headRefName')
  WORKTREE="/tmp/worktree-$PR"

  if [ ! -d "$WORKTREE" ]; then
    git worktree add "$WORKTREE" "$BRANCH"
  fi

  # Spawn patrick-reviewer agent in background for this worktree
done

# Wait for all agents, collect results
```

## AGENT DELEGATION

**MANDATORY**: Spawn patrick-reviewer for review.

## LOCAL CHANGES REVIEW

### 1. SHOW CHANGES
```bash
git status
git diff --stat
git diff
```

### 2. COMPARE TO MAIN
```bash
git diff main...HEAD --stat
git log main..HEAD --oneline
```

## PR REVIEW

### 1. GET PR DIFF
```bash
cd $WORKTREE  # or current dir
gh pr diff $PR
gh pr view $PR --json additions,deletions,changedFiles
```

### 2. CHECK CI STATUS
```bash
gh pr checks $PR
```

## REVIEW CHECKLIST

### Clean Code Principles
- [ ] SRP: Each function does ONE thing
- [ ] Functions < 100 lines (hard limit)
- [ ] No copy-paste code blocks
- [ ] No magic numbers
- [ ] No cryptic abbreviations

### Technical Debt (BLOCKING)
- [ ] NO TODO/FIXME without linked issue
- [ ] NO commented-out code
- [ ] NO suppression pragmas
- [ ] NO workarounds without issue number

### Code Quality
- [ ] No debug print statements
- [ ] No hardcoded secrets/paths
- [ ] Modules < 1000 lines

### Fortran Specific
- [ ] 88-column limit
- [ ] implicit none present
- [ ] All arguments have intent

## AUTO-CREATE PR (if local changes, no PR)

If reviewing local changes and they pass:
```bash
# Offer to create PR
BRANCH="review/$(date +%Y%m%d-%H%M%S)"
git checkout -b "$BRANCH"
git add <specific-files>
git commit -m "<type>: <description>"
git push -u origin "$BRANCH"
gh pr create --title "<title>" --body "<body>"
```

## WORKTREE CLEANUP

```bash
for PR in $ARGUMENTS; do
  git worktree remove "/tmp/worktree-$PR" 2>/dev/null
done
```

## REPORT TEMPLATE

```markdown
# Review: [PR #N | Local Changes]

## Status: [PASSED | ISSUES FOUND]

### Clean Code: [PASS/FAIL]
### Tech Debt: [NONE/FOUND]
### Issues: [list if any]

## Verdict: [Ready | Needs fixes]
```
