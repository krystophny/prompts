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

### 2. GET BRANCH AND CI STATUS
```bash
BRANCH=$(gh pr view $ARGUMENTS --repo lfortran/lfortran --json headRefName --jq '.headRefName')
gh run list --repo lfortran/lfortran --branch $BRANCH --limit 3
```

### 3. GET ERROR FROM FAILED RUN
```bash
gh run view <run-id> --repo lfortran/lfortran --log-failed 2>&1 | grep -E "error:|Error:|FAILED" | head -30
```

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

### 9. WAIT FOR CI TO PASS
```bash
gh run watch --repo lfortran/lfortran
```
**Only report success when status is `completed` + `success`.**
**If CI fails again, repeat from step 3.**

## FAILURE CONDITIONS (report failure, not success)
- CI still running or queued
- Nothing committed/pushed
- Reviewer comments ignored
- Workarounds added that reviewer rejected
- PR description contradicts implementation
