# /claude - Autonomous Claude Code Execution

## COMMAND PURPOSE

Execute tasks using Claude Code CLI in autonomous mode. Handles both single prompts and multi-step TODO lists, with iterative review, commit, and push after completion.

**This command invokes the `codex` agent which then calls Claude Code CLI (`claude`) for execution.**

## OPERATING MODES

### Mode 1: Single Prompt Execution
User provides an explicit task as a string argument.

Example:
```
/claude "Add error handling to the parser module"
```

The command will:
1. Invoke `codex` agent with the prompt as mission objective
2. Agent calls `claude` CLI non-interactively
3. Agent reviews changes against CLAUDE.md criteria
4. Agent commits and pushes changes
5. Returns structured result

### Mode 2: TODO List Execution
User provides path to markdown file or GitHub issue with actionable TODO items.

Example:
```
/claude tasks/refactor-module.md
/claude 42  # GitHub issue #42
```

The command will:
1. Parse all TODO items from source
2. For each item (loop until complete):
   - Invoke `codex` agent with current step
   - Agent calls `claude` CLI non-interactively
   - Agent reviews and applies fixes
   - Agent updates TODO document
   - Agent commits and pushes
   - Report progress (2-3 sentences)
   - Proceed immediately to next item
3. Final comprehensive report

## REQUIRED INPUTS

**TASK_INPUT** (required): One of:
- Explicit prompt string (quoted)
- Path to markdown TODO file
- GitHub issue number

**MISSION_CLASS** (optional): implementation, review, refactor, etc.

## EXECUTION WORKFLOW

### Input Detection
1. Check if input is a file path (exists on disk)
2. Check if input is a GitHub issue number (numeric or URL)
3. Otherwise treat as explicit prompt string

### Single Prompt Flow
1. Create temporary task document with single item
2. Invoke `codex` agent (agents/codex.md)
3. Agent constructs `claude` command:
   ```bash
   claude -m "{{prompt}}" --dangerously-skip-user-approval
   ```
4. Agent captures output and evidence
5. Agent reviews against CLAUDE.md criteria
6. Agent stages files explicitly, commits, pushes
7. Return result to user

### TODO List Flow
1. Load and parse TODO document
2. Extract actionable items in order
3. For each item:
   - Invoke `codex` agent with item as objective
   - Agent calls `claude` CLI for execution
   - Agent reviews output against CLAUDE.md
   - Agent applies fixes if needed
   - Agent updates TODO doc with evidence
   - Agent commits and pushes
   - Report progress without waiting
   - Continue to next item
4. Final report when all items complete

## INTEGRATION WITH CODEX AGENT

The `codex` agent (agents/codex.md) is responsible for:
- Determining whether to use Claude Code CLI or Codex CLI
- Constructing appropriate CLI invocation
- Capturing and validating results
- Performing CLAUDE.md review
- Git operations (stage, commit, push)
- Returning structured JSON result

This command is responsible for:
- Input parsing and mode detection
- TODO document management
- Multi-step orchestration (if TODO list)
- Progress reporting to user
- Autonomous loop control

## CLAUDE CLI INVOCATION EXAMPLES

Single-shot execution:
```bash
claude -m "Implement feature X according to spec.md" \
  --dangerously-skip-user-approval
```

With file context:
```bash
claude -m "Fix bug in parser.f90 line 42" \
  --dangerously-skip-user-approval \
  -f parser.f90
```

With image input:
```bash
claude -m "Implement UI from mockup" \
  --dangerously-skip-user-approval \
  -i mockup.png
```

## REVIEW AND COMMIT PROTOCOL

After every execution (single or per TODO item):

1. **Review Changes**
   - Apply all CLAUDE.md criteria (see agents/codex.md)
   - Fortran: size limits, intents, formatting, allocatable
   - Git: explicit staging, no emojis
   - Design: reuse-first, no stubs, no secrets
   - Tests: run and pass, ≤120s each

2. **Apply Fixes**
   - Implement necessary corrections
   - Re-run tests if fixes applied
   - Ensure all evidence captured

3. **Update Documentation**
   - Mark completed items in TODO doc
   - Add evidence references (test output, file paths)
   - Note any follow-up actions

4. **Git Operations**
   - Stage each file explicitly (never `git add .`)
   - Commit with clear message
   - Push to remote immediately

5. **Report**
   - 2-3 sentence summary of what changed
   - Evidence references
   - Next steps (if TODO list mode)

## AUTONOMOUS EXECUTION GUARANTEES

- No pausing between TODO items
- No user approval prompts during execution
- Only stop for unresolvable blockers
- All changes reviewed, committed, and pushed automatically
- Continuous progress reporting

## ERROR HANDLING

If execution fails:
1. Capture complete error context
2. Assess if blocker is resolvable autonomously
3. If resolvable: create fix, execute, continue
4. If unresolvable: mark TODO item blocked, escalate with evidence

## EXAMPLE USAGE

Single prompt:
```
User: /claude "Add module documentation to solver.f90"
Assistant: [Invokes codex agent → calls claude CLI → reviews → commits → pushes]
Result: "Added comprehensive module documentation to solver.f90.
All functions have intent declarations. Formatted with fprettify.
Committed and pushed."
```

TODO list:
```
User: /claude tasks/optimization.md
Assistant: [Loads 4 TODO items]
Step 1/4: Profiled code, identified bottlenecks. Evidence: profile.txt. Committed.
Step 2/4: Preallocated arrays in hot loop. Tests pass. Committed.
Step 3/4: Applied structure-of-arrays pattern. 2x speedup. Committed.
Step 4/4: Updated benchmarks. All pass. Committed.
Final: All 4 items complete. 4 commits pushed. Ready for review.
```

## SYMLINK SETUP

To make this command available in Codex CLI:
```bash
ln -s /home/ert/code/prompts/commands ~/.codex/prompts
```

Then restart Codex or use `/claude` in Codex interactive mode.
