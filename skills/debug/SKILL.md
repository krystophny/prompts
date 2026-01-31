---
name: debug
description: Debug failing tests. Supports multiple tests in parallel. No args = all failing tests.
argument-hint: "[test-name...]"
disable-model-invocation: true
---

# Debug Failing Tests

Investigate and fix failing tests. Supports multiple tests in parallel.

## Usage
```
/debug                   # All currently failing tests
/debug test_foo          # Single test
/debug test_a test_b     # Multiple tests in parallel
```

## MODE DETECTION (when no arguments)

```bash
# Run test suite, capture failing tests
FAILING=$(make test 2>&1 | grep -E "FAIL|FAILED|ERROR" | head -20)

if [ -n "$FAILING" ]; then
  echo "Found failing tests:"
  echo "$FAILING"
  # Extract test names and debug each
else
  echo "All tests passing"
  exit 0
fi
```

## PARALLEL EXECUTION (multiple tests)

```bash
for TEST in $ARGUMENTS; do
  # Spawn sergei-perfectionist-coder agent for each test
  # Agents work in parallel
done

# Wait for all agents, collect results
```

## AGENT DELEGATION

**MANDATORY**: Spawn sergei-perfectionist-coder for fix implementation.

## SINGLE TEST WORKFLOW

### 1. RUN THE TEST
```bash
# Run specific test, capture full output
make test TEST=$TEST 2>&1 | tee /tmp/test-$TEST.log
```

### 2. CAPTURE ERROR
- Exact error message
- Line numbers
- Stack trace
- Context around failure

### 3. READ RELEVANT CODE
- Read test file
- Read related source files
- Understand expected vs actual

### 4. CHECK RECENT CHANGES
```bash
git log --oneline -10
git diff HEAD~5 -- <relevant-files>
```

### 5. IDENTIFY ROOT CAUSE
- Which stage? (Parser, Semantics, Codegen, Runtime)
- Expected vs actual behavior?
- Why is this happening?

### 6. IMPLEMENT FIX (spawn sergei-perfectionist-coder)
- Fix in earliest appropriate stage
- Search codebase first (reuse-first)
- Minimal changes only

### 7. VERIFY FIX
```bash
# Run original test - MUST PASS
make test TEST=$TEST

# Run full suite - ALL must pass (100%)
make test
```

### 8. COMMIT
```bash
git add <specific-files>
git commit -m "fix: <description>"
```

## CLEAN CODE CHECK

- [ ] Functions < 100 lines
- [ ] No copy-paste code
- [ ] No TODO/FIXME without issues
- [ ] No commented-out code

## REPORT TEMPLATE

```markdown
# Debug: $TEST

## Root Cause
- Stage: [Parser/Semantics/Codegen/Runtime]
- Issue: [description]
- Location: [file:line]

## Fix
- Files: [list]
- Approach: [description]

## Verification
- Original test: [PASS/FAIL]
- Full suite: [PASS/FAIL]
```
