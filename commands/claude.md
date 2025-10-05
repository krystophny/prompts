# /claude - Autonomous Claude Code Execution

## COMMAND PURPOSE

Execute tasks using Claude Code CLI in autonomous mode. Handles both single prompts and multi-step TODO lists, with iterative review, commit, and push after each completion.

**This command is invoked FROM Codex CLI. All execution logic is self-contained here.**

## OPERATING MODES

### Mode 1: Single Prompt Execution
User provides an explicit task as a string argument.

Example: `/claude "Add error handling to the parser module"`

The command will:
1. Construct `claude` CLI invocation with prompt
2. Execute Claude Code non-interactively
3. Capture and parse output
4. Review changes against CLAUDE.md criteria
5. Apply fixes if needed
6. Stage files explicitly, commit, and push
7. Return result to user

### Mode 2: TODO List Execution
User provides path to markdown file or GitHub issue with actionable TODO items.

Example: `/claude tasks/refactor-module.md` or `/claude 42`

The command will:
1. Parse all TODO items from source
2. For each item (loop until complete):
   - Execute item via Claude Code CLI
   - Review and apply fixes
   - Update TODO document with evidence
   - Commit and push changes
   - Report progress (2-3 sentences)
   - Proceed immediately to next item
3. Final comprehensive report

## REQUIRED INPUTS

**TASK_INPUT** (required): One of:
- Explicit prompt string (quoted)
- Path to markdown TODO file
- GitHub issue number or URL

**MISSION_CLASS** (optional): implementation, review, refactor, etc.

## INPUT DETECTION

Automatically detect input type:
1. Check if input is a file path (exists on disk) → Mode 2
2. Check if input is numeric or GitHub issue URL → Mode 2
3. Otherwise treat as explicit prompt string → Mode 1

## EXECUTION PROCEDURE

### Mode 1: Single Prompt Flow

1. **Prepare Context**
   - Repository root: current working directory
   - Current branch: `git rev-parse --abbrev-ref HEAD`
   - Workspace status: `git status --short`

2. **Execute Claude CLI**
   ```bash
   claude --print --dangerously-skip-permissions "{{prompt}}"
   ```

   Capture stdout, stderr, and exit code

   Note: `--print` enables non-interactive mode, `--dangerously-skip-permissions` bypasses all permission checks

3. **Parse Results**
   - Extract file changes from output
   - Identify test commands run
   - Collect evidence (test output, build logs)

4. **Review Against CLAUDE.md**
   - Apply all review criteria (see section below)
   - Check for violations
   - Identify necessary fixes

5. **Apply Fixes**
   - Implement corrections based on review
   - Re-run tests if fixes applied
   - Ensure all evidence captured

6. **Git Operations**
   - Stage each modified file explicitly
   - Never use `git add .` or `git add -A`
   - Commit with clear message
   - Push to remote

7. **Report**
   - 2-3 sentence summary
   - Evidence references
   - Files changed and committed

### Mode 2: TODO List Flow

1. **Initialize**
   - Load TODO source (file or GitHub issue via `gh issue view`)
   - Parse actionable items (checkboxes, numbered lists)
   - Enumerate in execution order
   - Verify document is well-formed

2. **For Each TODO Item** (loop until complete)

   a. **Prepare Item Context**
      - Current item objective
      - Completed items (for context)
      - Remaining items (for planning)
      - Repository state (branch, workspace)

   b. **Execute via Claude CLI**
      ```bash
      claude --print --dangerously-skip-permissions "{{item_text}}

      Context:
      - Completed: {{completed_items}}
      - Remaining: {{remaining_items}}
      - Constraints: All CLAUDE.md standards apply
      "
      ```

   c. **Capture and Validate**
      - Parse Claude output
      - Extract file changes
      - Collect test/build evidence
      - Verify success claims with proof

   d. **Review Against CLAUDE.md**
      - Apply all mandatory checks (see criteria below)
      - Identify violations or needed fixes
      - Assess if changes meet standards

   e. **Apply Fixes**
      - Implement necessary corrections
      - Re-run verification if fixes applied
      - Ensure full compliance

   f. **Update TODO Document**
      - Mark item as complete with checkbox
      - Add evidence references (test output, file paths)
      - Note any observations or follow-ups
      - Save changes to file or update GitHub issue

   g. **Git Operations**
      - Stage modified files explicitly
      - Stage updated TODO document
      - Commit with message: "{{item_summary}} (step N/M)"
      - Push immediately

   h. **Report Progress**
      - "Step N/M complete: {{summary}}. {{evidence}}. Proceeding to step N+1."
      - Do NOT wait for user acknowledgment
      - Continue immediately to next item

3. **Completion**
   - Verify all items marked complete
   - Confirm all evidence captured
   - Final report: "All N items complete. N commits pushed. {{summary}}."

## CLAUDE CLI INVOCATION PATTERNS

### Basic execution:
```bash
claude --print --dangerously-skip-permissions "{{prompt}}"
```

### With output format (JSON):
```bash
claude --print --output-format json --dangerously-skip-permissions "{{prompt}}"
```

### With streaming JSON output:
```bash
claude --print --output-format stream-json --dangerously-skip-permissions "{{prompt}}"
```

### With permission mode (alternative to --dangerously-skip-permissions):
```bash
claude --print --permission-mode bypassPermissions "{{prompt}}"
```

### With specific model:
```bash
claude --print --dangerously-skip-permissions --model sonnet "{{prompt}}"
```

### Continue previous conversation:
```bash
claude --print --dangerously-skip-permissions --continue "{{prompt}}"
```

## CLAUDE.MD REVIEW CRITERIA

After every execution (single or per TODO item), review ALL changes:

### Non-Negotiables
- [ ] No stubs, placeholders, commented-out code, or suppressions
- [ ] Success claims backed by evidence (CI logs, test output, command results)
- [ ] Files staged explicitly (verify git commands used)
- [ ] Repo build/test scripts executed

### Fortran Code Quality
- [ ] Fortran 2018+ features used appropriately
- [ ] `use, intrinsic :: iso_fortran_env, only: dp => real64` for reals
- [ ] All reals declared as `real(dp)`, literals use `1.0d0` format
- [ ] Modules <500 lines (hard limit 1000)
- [ ] Functions <50 lines (hard limit 100)
- [ ] All dummy arguments have `intent(in|out|inout)`
- [ ] Procedures marked `pure`/`elemental` where appropriate
- [ ] 88-column formatting enforced (run `fprettify` if needed)
- [ ] Files end with newline
- [ ] Derived types named `<name>_t`
- [ ] `allocatable` used; manual deallocation avoided
- [ ] No reliance on short-circuit evaluation in conditionals

### Design Principles
- [ ] Reuse-first: existing code modified/extended
- [ ] Nearby duplication eliminated
- [ ] No shallow wrappers or over-abstraction
- [ ] Input validation present
- [ ] No hardcoded secrets/keys/passwords
- [ ] Structure-of-arrays over array-of-structures where applicable
- [ ] Inner loops over leftmost (fastest-varying) index
- [ ] Obsolete/dead code removed

### Testing & Build
- [ ] Tests run and pass locally
- [ ] Test duration ≤120s each
- [ ] Build commands execute successfully
- [ ] Linter/formatter applied if required (e.g., `fprettify`)

### Git/GitHub Discipline
- [ ] Explicit file staging only (check for `git add .` - forbidden!)
- [ ] No emojis in commits
- [ ] Commit messages clear and descriptive
- [ ] Changes pushed to remote

## FIX APPLICATION WORKFLOW

When review identifies issues:

1. **Categorize Issues**
   - Critical: violates non-negotiables (stubs, blanket git adds)
   - Major: violates hard limits (file size, function size)
   - Minor: style violations (formatting, naming)

2. **Apply Fixes**
   - Critical: fix immediately, re-run full test suite
   - Major: fix and re-verify affected functionality
   - Minor: apply and spot-check

3. **Re-validate**
   - Run tests again if logic changed
   - Re-check all failed criteria
   - Ensure no new issues introduced

4. **Document**
   - Note fixes applied in commit message
   - Add to TODO update if in Mode 2

## GIT OPERATIONS PROTOCOL

**Always follow this exact sequence:**

1. **Check Status**
   ```bash
   git status --short
   ```

2. **Stage Files Explicitly**
   ```bash
   # CORRECT:
   git add src/module.f90 test/test_module.f90 tasks/refactor.md

   # FORBIDDEN:
   git add .
   git add -A
   git add --all
   ```

3. **Commit with HEREDOC**
   ```bash
   git commit -m "$(cat <<'EOF'
   Brief summary of changes

   Details:
   - Specific change 1
   - Specific change 2

   Evidence: tests pass (fpm test output)
   EOF
   )"
   ```

4. **Push Immediately**
   ```bash
   git push
   ```

## AUTONOMOUS EXECUTION GUARANTEES

- No pausing between TODO items
- No user approval prompts
- Only stop for unresolvable blockers
- All changes reviewed and committed automatically
- Continuous progress reporting

## ERROR HANDLING

If Claude CLI execution fails:

1. **Capture Full Context**
   - Exit code
   - Stdout and stderr
   - Git status before/after
   - Attempted command

2. **Assess Resolvability**
   - Can be fixed by adjusting prompt?
   - Missing dependencies or files?
   - Constraint violation?

3. **Attempt Fix** (if possible)
   - Modify approach and retry
   - Add missing context
   - Adjust constraints

4. **Escalate** (if unresolvable)
   - Mark TODO item as blocked
   - Report to user with:
     - Objective
     - Error description
     - Evidence of failure
     - Attempted resolutions

## EXAMPLE EXECUTIONS

### Example 1: Single Prompt
```
User: /claude "Add comprehensive error handling to parser.f90"

Execution:
1. Detects string input → Mode 1
2. Executes: claude --print --dangerously-skip-permissions "Add comprehensive error handling to parser.f90"
3. Claude modifies parser.f90, runs tests
4. Review: module 287 lines ✓, intents present ✓, tests pass ✓
5. No fixes needed
6. Stages: git add src/parser.f90 test/test_parser.f90
7. Commits: "Add error handling to parser module"
8. Pushes to remote
9. Reports: "Added error handling to parser.f90. All tests pass. Module size: 287 lines. Committed and pushed."
```

### Example 2: TODO List with Fixes
```
User: /claude tasks/optimization.md

Execution:
1. Detects file path → Mode 2
2. Loads tasks/optimization.md
3. Parses 3 TODO items

Step 1/3:
- Executes: claude --print --dangerously-skip-permissions "Profile code to identify bottlenecks"
- Claude creates profiler script, runs it, generates report
- Review: script 245 lines ✓, but missing intent on 2 args ✗
- Fix: adds intent(in) to 2 arguments
- Re-runs tests: pass ✓
- Updates TODO: ✅ Profile code (evidence: profile.txt)
- Commits: "Profile code and identify bottlenecks (step 1/3)"
- Pushes
- Reports: "Step 1/3 complete: Profiled code. Bottlenecks in solver loop. Evidence: profile.txt. Fixed missing intents. Proceeding to step 2."

Step 2/3:
- Executes: claude --print --dangerously-skip-permissions "Preallocate arrays in hot loops identified in profile.txt"
- Claude modifies solver, preallocates arrays
- Review: all checks pass ✓
- No fixes needed
- Updates TODO: ✅ Preallocate arrays
- Commits: "Preallocate arrays in solver hot loops (step 2/3)"
- Pushes
- Reports: "Step 2/3 complete: Preallocated scratch arrays. 1.5x speedup. Tests pass. Proceeding to step 3."

Step 3/3:
- Executes: claude --print --dangerously-skip-permissions "Apply structure-of-arrays pattern to particle data"
- Claude refactors data structures
- Review: module 892 lines ✗ (exceeds 500 soft limit, under 1000 hard limit, acceptable)
- Review: function copy_particles 127 lines ✗ (exceeds 100 hard limit!)
- Fix: splits copy_particles into copy_positions (42 lines) and copy_velocities (38 lines)
- Re-runs tests: pass ✓
- Updates TODO: ✅ Apply SoA pattern (split copy_particles to meet size limit)
- Commits: "Apply structure-of-arrays pattern, split oversized function (step 3/3)"
- Pushes
- Reports: "Step 3/3 complete: Applied SoA pattern. Split copy_particles to meet limits. 2.1x total speedup. Proceeding to final report."

Final:
- All 3 items complete
- 3 commits pushed
- Reports: "All 3 tasks complete. 3 commits pushed. Achieved 2.1x speedup. Ready for benchmarking."
```

## RELATIONSHIP WITH /codex COMMAND

**Key distinction:**

- **`/codex`**: Runs FROM Claude Code, uses Codex CLI, delegates to codex agent
- **`/claude`**: Runs FROM Codex CLI, uses Claude Code CLI, self-contained logic

Both commands support dual modes (single prompt / TODO list) with identical autonomous execution guarantees and review standards.
