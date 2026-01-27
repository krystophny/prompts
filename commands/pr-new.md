# /pr-new - Start New Bug Fix

Start a new bug fix from scratch. Argument is the branch name suffix.

## Usage
```
/pr-new <short-name>
```

Example: `/pr-new minloc-kind8` creates branch `fix/minloc-kind8`

## CHECKLIST (Execute in Order)

### 1. SETUP BRANCH
```bash
git -C lfortran fetch upstream
git -C lfortran checkout -b fix/$ARGUMENTS upstream/main
```

### 2. CREATE MRE TEST
- File: `integration_tests/<category>/<name>_NN.f90` (next number)
- Add to `CMakeLists.txt` with labels: `gfortran`, `llvm`

### 3. VERIFY TEST FAILS ON MAIN
```bash
git -C lfortran stash
git -C lfortran checkout upstream/main
scripts/lf.sh build
scripts/lf.sh run lfortran/integration_tests/<test>.f90
# MUST FAIL - if passes, write a better test
```

### 4. IMPLEMENT FIX
```bash
git -C lfortran checkout fix/$ARGUMENTS
git -C lfortran stash pop
```
- Fix in earliest pipeline stage (Semantics > ASR > Passes > Codegen)
- Minimal changes only, no refactoring

### 5. VERIFY TEST PASSES
```bash
scripts/lf.sh build
scripts/lf.sh run lfortran/integration_tests/<test>.f90
# MUST PASS
```

### 6. RUN FULL TESTS
```bash
scripts/lf.sh test
# ALL tests must pass
```

### 7. COMMIT & PUSH
```bash
git -C lfortran add <specific-files>
git -C lfortran commit -m "fix: <description>"
git -C lfortran push -u origin fix/$ARGUMENTS
```

### 8. CREATE DRAFT PR (only if requested by user)
```bash
gh pr create --draft --repo lfortran/lfortran \
  --title "fix: <description>" --body-file /tmp/pr.md
```
