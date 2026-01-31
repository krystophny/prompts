---
name: pr
description: Start new bug fix. Supports multiple in parallel via worktrees. No args = create from current changes.
argument-hint: "[branch-name...]"
disable-model-invocation: true
---

# Start New Bug Fix

Create new bug fix branches. Supports multiple in parallel using git worktrees.

## Usage
```
/pr                      # Create from current changes vs main
/pr minloc-fix           # Create fix/minloc-fix branch
/pr fix1 fix2 fix3       # Multiple branches in parallel worktrees
```

## MODE DETECTION (when no arguments)

```bash
# Check for uncommitted changes vs main
CHANGES=$(git diff main --stat)

if [ -n "$CHANGES" ]; then
  echo "Creating PR from changes vs main"
  BRANCH="fix/$(git rev-parse --abbrev-ref HEAD)-$(date +%H%M%S)"
else
  echo "No changes vs main - provide branch name"
  exit 1
fi
```

## PARALLEL EXECUTION (multiple branches)

```bash
for NAME in $ARGUMENTS; do
  BRANCH="fix/$NAME"
  WORKTREE="/tmp/worktree-$NAME"

  # Create worktree with new branch from main
  git worktree add -b "$BRANCH" "$WORKTREE" origin/main

  # Spawn agent pipeline in background
done

# Wait for all agents, collect results
```

## AGENT PIPELINE

1. **georg-test-engineer**: Create MRE test
2. **sergei-perfectionist-coder**: Implement fix
3. **patrick-reviewer**: Review before PR

## SINGLE BRANCH WORKFLOW

### 1. SETUP BRANCH
```bash
cd $WORKTREE  # or current dir
git fetch origin
git checkout -b fix/$NAME origin/main
```

### 2. CREATE MRE TEST (spawn georg-test-engineer)
- Create minimal reproducing test
- Add to build system with labels
- MUST fail on main, pass after fix

### 3. VERIFY TEST FAILS ON MAIN (CAPTURE OUTPUT)
```bash
git stash
git checkout origin/main
# Run test - MUST FAIL - CAPTURE CONSOLE OUTPUT FOR PR DESCRIPTION
<test_command> 2>&1 | tee /tmp/test-fail-main.log
git checkout fix/$NAME
git stash pop
```
**MANDATORY**: Save this failure output for PR description evidence.

### 4. IMPLEMENT FIX (spawn sergei-perfectionist-coder)
- Search codebase first (reuse-first)
- Fix in earliest pipeline stage
- Minimal changes only

### 5. VERIFY AND PUSH
```bash
# Run test - MUST PASS
# Run full suite - ALL must pass (100%)
git add <specific-files>
git commit -m "fix: <description>"
git push -u origin fix/$NAME
```

### 6. REVIEW (spawn patrick-reviewer)
- Clean code compliance
- Tech debt check
- Test quality

### 7. CREATE PR WITH VERIFICATION EVIDENCE
```bash
gh pr create --draft --title "fix: <description>" --body-file /tmp/pr.md
```

**PR body MUST include verification section:**
```markdown
## Verification

### Test fails on main
\`\`\`
$ git checkout upstream/main
$ <test_command>
[... actual console output from /tmp/test-fail-main.log ...]
\`\`\`

### Test passes after fix
\`\`\`
$ git checkout fix/$NAME
$ <test_command>
[... actual console output showing PASS ...]
\`\`\`
```

## WORKTREE CLEANUP

```bash
for NAME in $ARGUMENTS; do
  git worktree remove "/tmp/worktree-$NAME" 2>/dev/null
done
```

## TECHNICAL DEBT PREVENTION

| Check | Requirement |
|-------|-------------|
| Function size | < 100 lines |
| Module size | < 1000 lines |
| TODO/FIXME | Must have linked issue |
| Commented code | Must be deleted |

## AGENT RESPONSIBILITIES

### georg-test-engineer
- Create minimal reproducing test
- Ensure test is strict (not shallow)
- Verify test fails on main

### sergei-perfectionist-coder
- Search codebase before implementing
- Implement minimal fix
- Run full test suite (100% pass)

### patrick-reviewer
- Verify clean code principles
- Detect technical debt
- Approve or handback
