# /debug - Debug Failing Test

Investigate and fix a failing test. Argument: test name or file path.

## Usage
```
/debug <test_name>
/debug lfortran/integration_tests/arrays_28.f90
```

## CHECKLIST (Execute in Order)

### 1. RUN THE TEST
```bash
scripts/lf.sh test -t $ARGUMENTS -s
```
Or for a file:
```bash
scripts/lf.sh run $ARGUMENTS
```

### 2. CAPTURE ERROR
Note exact error message, line numbers, and context.

### 3. READ RELEVANT CODE
Read the test file and related source files.

### 4. CHECK RECENT CHANGES
```bash
git -C lfortran log --oneline -10
git -C lfortran diff HEAD~5 -- <relevant-files>
```

### 5. CREATE MINIMAL REPRODUCER
If test is complex, create simpler MRE in /tmp:
```bash
cat > /tmp/debug_mre.f90 << 'EOF'
program debug_mre
  ! Minimal code that triggers the bug
end program
EOF
scripts/lf.sh run /tmp/debug_mre.f90
```

### 6. IDENTIFY ROOT CAUSE
- Which pipeline stage? (Parser, Semantics, ASR, Passes, Codegen)
- What's the expected vs actual behavior?

### 7. IMPLEMENT FIX
Fix in earliest appropriate stage.

### 8. VERIFY FIX
```bash
scripts/lf.sh run $ARGUMENTS  # Original test passes
scripts/lf.sh test            # No regressions
```

### 9. REPORT
Summarize:
- Root cause
- Fix location
- Verification status
