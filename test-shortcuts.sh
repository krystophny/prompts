#!/bin/bash
# QADS Workflow Shortcuts Test Suite
# Validates that workflow shortcuts are executable and provide expected outputs

set -e

echo "TESTING: QADS Workflow Shortcuts"
echo "=================================="
echo ""

# Test configuration
TEST_PASSED=0
TEST_FAILED=0
TEMP_DIR=$(mktemp -d)

# Test helper functions
run_test() {
    local test_name="$1"
    local command="$2"
    local expected_pattern="$3"
    
    echo "Testing: $test_name"
    
    if $command > "$TEMP_DIR/output.txt" 2>&1; then
        if grep -q "$expected_pattern" "$TEMP_DIR/output.txt"; then
            echo "SUCCESS: PASS: $test_name"
            ((TEST_PASSED++))
        else
            echo "ERROR: FAIL: $test_name - Expected pattern not found"
            echo "   Expected: $expected_pattern"
            echo "   Got:"
            cat "$TEMP_DIR/output.txt" | head -5
            ((TEST_FAILED++))
        fi
    else
        echo "ERROR: FAIL: $test_name - Command failed"
        cat "$TEMP_DIR/output.txt"
        ((TEST_FAILED++))
    fi
    echo ""
}

# Test 1: Verify scripts exist and are executable
echo "Phase 1: File existence and permissions"
echo "--------------------------------------"

for script in plan work play; do
    if [ -f "bin/$script" ] && [ -x "bin/$script" ]; then
        echo "SUCCESS: PASS: bin/$script exists and is executable"
        ((TEST_PASSED++))
    else
        echo "ERROR: FAIL: bin/$script missing or not executable"
        ((TEST_FAILED++))
    fi
done
echo ""

# Test 2: Script execution and output validation
echo "Phase 2: Script execution and output"
echo "------------------------------------"

# Test plan script
run_test "plan script execution" "./bin/plan" "PLANNING: QADS Planning Workflow"
run_test "plan mentions chris-architect" "./bin/plan" "chris-architect"
run_test "plan mentions BACKLOG.md" "./bin/plan" "BACKLOG.md"

# Test work script  
run_test "work script execution" "./bin/work" "WORK: QADS Work Workflow"
run_test "work mentions implementation pipeline" "./bin/work" "implementation pipeline"
run_test "work mentions max.*sergei.*patrick" "./bin/work" "max.*sergei.*patrick"

# Test play script
run_test "play script execution" "./bin/play" "AUDIT: QADS Play Workflow"
run_test "play mentions quality audit" "./bin/play" "quality audit"
run_test "play mentions defects only" "./bin/play" "defects"

# Test 3: Error handling validation
echo "Phase 3: Error handling"
echo "----------------------"

# Create temporary non-git directory for testing
NON_GIT_DIR=$(mktemp -d)
cd "$NON_GIT_DIR"

run_test "plan error handling (non-git)" "../bin/plan" "Must be run from within a git repository"
run_test "work error handling (non-git)" "../bin/work" "Must be run from within a git repository"  
run_test "play error handling (non-git)" "../bin/play" "Must be run from within a git repository"

# Return to original directory
cd - > /dev/null

# Test 4: Integration validation
echo "Phase 4: Integration validation"
echo "------------------------------"

# Check if shortcuts match documented workflows
if grep -q "chris-architect" bin/plan && grep -q "max.*sergei.*patrick" bin/work && grep -q "defects" bin/play; then
    echo "SUCCESS: PASS: Shortcuts match documented agent workflows"
    ((TEST_PASSED++))
else
    echo "ERROR: FAIL: Shortcuts don't match documented workflows"
    ((TEST_FAILED++))
fi

# Cleanup
rm -rf "$TEMP_DIR" "$NON_GIT_DIR"

# Final results
echo ""
echo "RESULTS: Test Results"
echo "==============="
echo "SUCCESS: Passed: $TEST_PASSED"
echo "ERROR: Failed: $TEST_FAILED"
echo ""

if [ $TEST_FAILED -eq 0 ]; then
    echo "SUCCESS: All tests passed! Workflow shortcuts are working correctly."
    exit 0
else
    echo "ERROR: Some tests failed. Please review and fix issues above."
    exit 1
fi