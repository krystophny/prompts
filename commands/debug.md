# /debug - Debug Failing Test

Investigate and fix a failing test. Argument: test name or file path.

## Usage
```
/debug <test_name>
/debug path/to/test.f90
```

## AGENT DELEGATION

```
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!! MANDATORY: Spawn sergei-perfectionist-coder for fix implementation   !!
!! The agent enforces clean code and prevents technical debt            !!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
```

## CHECKLIST (Execute in Order)

```
[ ] 1. RUN THE TEST
      # Use project-specific test command with the test name/file
      # Capture full output including error messages

[ ] 2. CAPTURE ERROR
      - Exact error message
      - Line numbers
      - Stack trace (if available)
      - Context around failure

[ ] 3. READ RELEVANT CODE
      - Read the test file
      - Read related source files
      - Understand expected vs actual behavior

[ ] 4. CHECK RECENT CHANGES
      git log --oneline -10
      git diff HEAD~5 -- <relevant-files>

[ ] 5. CREATE MINIMAL REPRODUCER
      If test is complex, create simpler MRE in /tmp:
      # Create minimal code that triggers the bug
      # Run and verify it reproduces the issue

[ ] 6. IDENTIFY ROOT CAUSE
      - Which pipeline stage? (Parser, Semantics, ASR, Passes, Codegen)
      - What is the expected vs actual behavior?
      - Why is this happening?

[ ] 7. IMPLEMENT FIX (spawn sergei-perfectionist-coder)
      - Fix in earliest appropriate stage
      - Search codebase first (reuse-first)
      - Minimal changes only
      - NO technical debt

[ ] 8. CLEAN CODE VERIFICATION
      - [ ] Functions < 100 lines (hard limit)
      - [ ] No copy-paste code
      - [ ] No magic numbers
      - [ ] No TODO/FIXME without GitHub issues
      - [ ] No commented-out code
      - [ ] No suppression pragmas

[ ] 9. VERIFY FIX
      # Run original test - MUST PASS
      # Run full test suite - ALL must pass (100%)

[ ] 10. REPORT
```

## TECHNICAL DEBT CHECK (BLOCKING)

Before committing the fix, verify:

| Pattern | Severity | Action |
|---------|----------|--------|
| TODO/FIXME without issue | CRITICAL | REJECT - create GitHub issue first |
| Commented-out code | CRITICAL | REJECT - delete it |
| Suppression pragmas | CRITICAL | REJECT - fix the underlying issue |
| Copy-paste duplication | MAJOR | REJECT - extract shared code |
| Magic numbers | MAJOR | REJECT - use named constants |
| Functions >100 lines | MAJOR | REJECT - split function |

## REPORT TEMPLATE

```markdown
# Debug Report

## Test
- Name: [test name]
- File: [file path]

## Root Cause
- Stage: [Parser/Semantics/ASR/Passes/Codegen]
- Issue: [description]
- Location: [file:line]

## Fix
- Files changed: [list]
- Approach: [description]

## Clean Code Verification
- Function size: [PASS/FAIL]
- No duplication: [PASS/FAIL]
- No magic numbers: [PASS/FAIL]
- No tech debt: [PASS/FAIL]

## Verification
- Original test: [PASS/FAIL]
- Full test suite: [PASS/FAIL]
```
