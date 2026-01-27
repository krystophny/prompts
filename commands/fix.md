# /fix - Fix Failing PR Checks

Execute when PR CI checks fail. Requires PR number as argument.

## Usage
```
/pr-fix <pr-number>
```

## CHECKLIST (Execute in Order)

### 1. CHECK PR COMMENTS
```bash
gh pr view $ARGUMENTS --repo lfortran/lfortran --comments
```
Reviewers may have already identified the issue.

### 2. IDENTIFY FAILURE
```bash
gh run list --repo lfortran/lfortran --branch <branch> --limit 3
gh run view <run-id> --repo lfortran/lfortran --log-failed 2>&1 | head -200
```

### 3. FIND THE ERROR
Look for: `error:`, `FAILED`, `Error:`, assertion failures.
Note: test name, error message, CI job (LLVM version, OS).

### 4. REPRODUCE LOCALLY
```bash
git -C lfortran checkout <branch>
scripts/lf.sh build
scripts/lf.sh test -t <test_name> -s
```

### 5. FIX THE ISSUE
- Fix the code (not the test, unless test is wrong)
- Rebuild and verify fix locally

### 6. VERIFY ALL TESTS PASS
```bash
scripts/lf.sh test
```

### 7. COMMIT & PUSH
```bash
git -C lfortran add <specific-files>
git -C lfortran commit -m "fix: <describe what was fixed>"
git -C lfortran push
```

### 8. UPDATE PR IF NEEDED
```bash
gh pr edit $ARGUMENTS --repo lfortran/lfortran --title "new title"
gh pr edit $ARGUMENTS --repo lfortran/lfortran --body-file /tmp/pr.md
```

### 9. MONITOR CI
```bash
gh run list --repo lfortran/lfortran --branch <branch> --limit 1
```
Repeat checklist if CI fails again.
