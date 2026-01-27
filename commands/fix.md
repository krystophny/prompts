# /fix - Fix Failing PR Checks

Execute when PR CI checks fail. Requires PR number as argument.

## Usage
```
/fix <pr-number>
```

## SUCCESS CRITERIA (ALL must be true before reporting success)
- [ ] CI status is `completed` + `success` (NOT "in progress", NOT "queued")
- [ ] All reviewer comments addressed (not ignored)
- [ ] New changes committed AND pushed
- [ ] PR description matches actual implementation (no contradictions)

## CHECKLIST (Execute in Order)

### 1. CHECK PR COMMENTS FIRST (BLOCKING)
```bash
gh pr view $ARGUMENTS --repo lfortran/lfortran --comments
gh api repos/lfortran/lfortran/pulls/$ARGUMENTS/comments --jq '.[] | "\(.user.login): \(.body)"'
```
**STOP HERE if reviewer requested specific approach. Follow it EXACTLY.**
**Do NOT add workarounds reviewer explicitly rejected.**

### 2. GET BRANCH AND FIND FAILED JOBS
```bash
BRANCH=$(gh pr view $ARGUMENTS --repo lfortran/lfortran --json headRefName --jq '.headRefName')

# List runs - look for any with conclusion=failure OR status=in_progress (may have failed jobs)
gh run list --repo lfortran/lfortran --branch $BRANCH --limit 5 --json databaseId,status,conclusion,workflowName

# Get the latest run ID (even if in_progress - it may have failed jobs already)
RUN_ID=$(gh run list --repo lfortran/lfortran --branch $BRANCH --limit 1 --json databaseId --jq '.[0].databaseId')

# Check individual job statuses - shows which jobs failed even if run is still in_progress
gh run view $RUN_ID --repo lfortran/lfortran --json jobs --jq '.jobs[] | select(.conclusion == "failure") | "\(.name): \(.conclusion)"'
```

### 3. GET ERROR LOGS FROM FAILED JOBS IMMEDIATELY
```bash
# This works even if the overall run is still in_progress - fetches logs from completed failed jobs
gh run view $RUN_ID --repo lfortran/lfortran --log-failed 2>&1 | grep -E "error:|Error:|FAILED|fatal:" | head -50

# If no output, the failed jobs may not have actionable errors yet - check job details
gh run view $RUN_ID --repo lfortran/lfortran --json jobs --jq '.jobs[] | select(.conclusion == "failure") | {name: .name, steps: [.steps[] | select(.conclusion == "failure") | .name]}'
```
**DO NOT wait for "in progress" runs to complete. Failed jobs have logs available immediately.**

### 4. REPRODUCE LOCALLY
```bash
git -C lfortran fetch origin
git -C lfortran checkout $BRANCH
scripts/lf.sh build
# Run exact command/test that CI failed on
```

### 5. IMPLEMENT FIX
- Follow reviewer guidance EXACTLY
- Fix in correct pipeline stage (Semantics > ASR > Passes > Codegen)
- Minimal changes only

### 6. VERIFY FIX LOCALLY
```bash
scripts/lf.sh build
scripts/lf.sh test
```

### 7. COMMIT & PUSH (MANDATORY - not optional)
```bash
git -C lfortran add <specific-files>
git -C lfortran commit -m "fix: <description>"
git -C lfortran push
```
**If nothing to commit, the fix failed - go back to step 5.**

### 8. UPDATE PR DESCRIPTION (if implementation approach changed)
Ensure PR description accurately reflects what was done.

### 9. MONITOR CI - CHECK FOR FAILURES FIRST
```bash
# Get latest run for this branch
RUN_ID=$(gh run list --repo lfortran/lfortran --branch $BRANCH --limit 1 --json databaseId --jq '.[0].databaseId')

# Check if any jobs already failed (even if run is still in_progress)
FAILED=$(gh run view $RUN_ID --repo lfortran/lfortran --json jobs --jq '[.jobs[] | select(.conclusion == "failure")] | length')
if [ "$FAILED" -gt 0 ]; then
  echo "Jobs already failed - fetching logs immediately"
  gh run view $RUN_ID --repo lfortran/lfortran --log-failed 2>&1 | head -100
  # Go back to step 3 to diagnose
fi

# Only watch if no failures yet
gh run watch $RUN_ID --repo lfortran/lfortran --exit-status || gh run view $RUN_ID --repo lfortran/lfortran --log-failed 2>&1 | head -100
```
**DO NOT just report "in progress" - check for already-failed jobs first.**
**Only report success when status is `completed` + `success`.**
**If CI fails again, repeat from step 3.**

## FAILURE CONDITIONS (report failure, not success)
- CI still running or queued
- Nothing committed/pushed
- Reviewer comments ignored
- Workarounds added that reviewer rejected
- PR description contradicts implementation
