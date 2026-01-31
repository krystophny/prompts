---
name: check
description: Check current changes before committing. Spawns patrick-reviewer for clean code and tech debt detection.
disable-model-invocation: true
---

# Pre-Commit Check

Check current changes before committing. Spawns patrick-reviewer agent.

## Usage
```
/check
```

## AGENT DELEGATION

**MANDATORY**: Spawn patrick-reviewer agent to perform this review.
The agent has specialized clean code and tech debt detection.

## REVIEW CHECKLIST

### 1. SHOW CHANGES
```bash
git status
git diff --stat
git diff
```

### 2. CLEAN CODE PRINCIPLES

**SRP - Single Responsibility**
- [ ] Each module has ONE reason to change
- [ ] Each function does ONE thing
- [ ] No god objects (>3 responsibilities)

**Meaningful Names**
- [ ] Variables describe what they hold
- [ ] Functions describe what they do
- [ ] No cryptic abbreviations (except: i, j, k, n, dp)

**Small Functions**
- [ ] Functions < 50 lines (soft limit)
- [ ] Functions < 100 lines (hard limit - REJECT if exceeded)
- [ ] Max 4 parameters per function

**DRY - Do Not Repeat Yourself**
- [ ] No copy-paste code blocks
- [ ] Similar patterns extracted to shared procedures
- [ ] Constants extracted, no magic numbers

**YAGNI - You Are Not Gonna Need It**
- [ ] No speculative generalization
- [ ] No unused parameters or return values
- [ ] No "just in case" code paths

### 3. TECHNICAL DEBT CHECK (BLOCKING)

FORBIDDEN - Instant rejection if ANY found:
- [ ] NO TODO/FIXME/HACK without linked issue
- [ ] NO suppression pragmas; NO commented-out code; NO dead code
- [ ] NO workarounds without issue number in same line
- [ ] NO noise comments (obvious/redundant, "bug fix for X")
- [ ] NO "improve later" without tracking issue

Code Smells: Long param lists (>4), feature envy, data clumps

### 4. CODE QUALITY
- [ ] No commented-out code
- [ ] No debug print statements
- [ ] No hardcoded secrets/paths
- [ ] Functions < 100 lines (hard limit)
- [ ] Modules < 1000 lines (hard limit)

### 5. FORTRAN SPECIFIC (if applicable)
- [ ] 88-column limit
- [ ] implicit none present
- [ ] All arguments have intent(in|out|inout)
- [ ] Uses real(dp) not real*8
- [ ] allocatable preferred over pointer

### 6. GIT HYGIENE
- [ ] No unrelated changes mixed in
- [ ] No generated files staged
- [ ] No .mod files staged

### 7. RUN TESTS
```bash
# Use project-specific test command
# ALL tests must pass - no exceptions
```

### 8. REPORT

## REPORT TEMPLATE

```markdown
# Code Review

## Status: [PASSED | ISSUES FOUND | NEEDS WORK]

### Clean Code
- SRP: [PASS/FAIL]
- Naming: [PASS/FAIL]
- Function Size: [PASS/FAIL]
- DRY: [PASS/FAIL]
- YAGNI: [PASS/FAIL]

### Technical Debt
- Status: [NONE DETECTED | DEBT INTRODUCED]
- Details: [list if any]

### Issues (if any)
- file:line - description

### Verdict
[Ready to commit | Needs fixes first]
```
