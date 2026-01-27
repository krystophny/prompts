# /review - Quick Code Review

Review current changes before committing. No arguments needed.

## Usage
```
/review
```

## CHECKLIST (Execute in Order)

### 1. SHOW CHANGES
```bash
git -C lfortran status
git -C lfortran diff --stat
git -C lfortran diff
```

### 2. CHECK FOR ISSUES

**Code Quality:**
- [ ] No commented-out code
- [ ] No debug print statements left
- [ ] No hardcoded secrets/paths
- [ ] Functions < 100 lines
- [ ] Modules < 1000 lines

**Fortran Specific:**
- [ ] 88-column limit respected
- [ ] `implicit none` present
- [ ] All arguments have `intent(in|out|inout)`
- [ ] Uses `real(dp)` not `real*8`
- [ ] `allocatable` preferred over `pointer`

**Git Hygiene:**
- [ ] No unrelated changes mixed in
- [ ] No generated files staged
- [ ] No .mod files staged

### 3. RUN TESTS
```bash
scripts/lf.sh test
```

### 4. REPORT
Summarize:
- Files changed
- Issues found (if any)
- Recommendation: ready to commit or needs fixes
