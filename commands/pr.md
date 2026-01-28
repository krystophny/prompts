# /pr - Start New Bug Fix

Start a new bug fix from scratch. Uses agent pipeline.

## Usage
```
/pr <short-name>
```

Example: `/pr minloc-kind8` creates branch `fix/minloc-kind8`

## AGENT PIPELINE

```
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!! AGENT WORKFLOW:                                                       !!
!! 1. georg-test-engineer: Create MRE test                              !!
!! 2. sergei-perfectionist-coder: Implement fix                         !!
!! 3. patrick-reviewer: Review before PR                                !!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
```

## CHECKLIST (Execute in Order)

```
[ ] 1. SETUP BRANCH
      git fetch upstream
      git checkout -b fix/$ARGUMENTS upstream/main

[ ] 2. CREATE MRE TEST (spawn georg-test-engineer)
      - File: integration_tests/<category>/<name>_NN.f90
      - Add to CMakeLists.txt with labels
      - MUST fail on main, pass after fix

[ ] 3. VERIFY TEST FAILS ON MAIN
      git stash
      git checkout upstream/main
      # Build and run test - MUST FAIL

[ ] 4. IMPLEMENT FIX (spawn sergei-perfectionist-coder)
      git checkout fix/$ARGUMENTS
      git stash pop
      - Search codebase first (reuse-first)
      - Fix in earliest pipeline stage
      - Minimal changes only
      - NO technical debt

[ ] 5. VERIFY TEST PASSES
      # Build and run test - MUST PASS

[ ] 6. CLEAN CODE CHECK
      - [ ] Functions < 100 lines
      - [ ] No copy-paste code
      - [ ] No magic numbers
      - [ ] No TODO/FIXME without issues

[ ] 7. RUN FULL TESTS
      # ALL tests must pass - 100%

[ ] 8. REVIEW (spawn patrick-reviewer)
      - Clean code compliance
      - Tech debt check
      - Test quality

[ ] 9. COMMIT & PUSH
      git add <specific-files>
      git commit -m "fix: <description>"
      git push -u origin fix/$ARGUMENTS

[ ] 10. CREATE DRAFT PR (only if requested)
       gh pr create --draft --repo <owner>/<repo> \
         --title "fix: <description>" --body-file /tmp/pr.md
```

## TECHNICAL DEBT PREVENTION

Before any commit, verify:

| Check | Requirement |
|-------|-------------|
| Function size | < 100 lines (hard limit) |
| Module size | < 1000 lines (hard limit) |
| TODO/FIXME | Must have linked GitHub issue |
| Commented code | Must be deleted |
| Copy-paste | Must be extracted to shared code |
| Magic numbers | Must use named constants |

## AGENT RESPONSIBILITIES

### georg-test-engineer
- Create minimal reproducing test
- Ensure test is strict (not shallow/tautological)
- Add proper CMakeLists.txt integration
- Verify test fails on main

### sergei-perfectionist-coder
- Search codebase before implementing
- Enhance existing code (reuse-first)
- Implement minimal fix at correct pipeline stage
- Ensure no technical debt introduced
- Run full test suite (100% pass required)

### patrick-reviewer
- Verify clean code principles
- Detect technical debt
- Check test quality
- Approve or handback with specific feedback
