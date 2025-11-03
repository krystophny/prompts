# /codex - Stepwise Codex Orchestration

## COMMAND PURPOSE

Execute tasks by invoking the `codex` agent. Handles both single prompts and multi-step task documents (markdown files or GitHub issues). Processes actions sequentially and continues autonomously until all work is complete or an unresolvable blocker is encountered.

**This command operates in fully autonomous mode. Once started, it MUST NOT pause, stop, or wait for user input until completion or blocking error.**

## OPERATING MODES

### Mode 1: Single Prompt Execution
User provides an explicit task as a string argument.

Example: `/codex "Implement error handling in parser module"`

The command will:
1. Create temporary task document with single item
2. Invoke `codex` agent with prompt as objective
3. Agent creates draft, calls Codex CLI, reviews, fixes, commits, pushes
4. Command receives result and reports to user

### Mode 2: Multi-Step Task Document
User provides path to markdown file or GitHub issue with TODO items.

Example: `/codex tasks/refactor.md` or `/codex 42`

The command will:
1. Parse all TODO items from source
2. Execute each item in sequence (see full procedure below)
3. Autonomous loop until all items complete
4. Final comprehensive report

## CORE OPERATING RULES

### Autonomous Execution
- Execute continuously through all steps without interruption
- Do not pause between steps
- Do not ask for user confirmation or approval
- Only stop for unresolvable blockers that require user intervention

### Evidence-Based Progress
- Verify every step completion with concrete evidence (test output, build logs, artifacts)
- Update task document after each completed step
- Report progress concisely to user after each step
- Never claim completion without proof

### Precise Task Management
- Process exactly one task step per Codex agent invocation
- Perform self-review and apply follow-up fixes immediately after each step
- Continue looping until every task item is fully satisfied
- Escalate only if blocker cannot be resolved autonomously

### Architectural Discipline
- Keep orchestration responsibilities separate: this command coordinates, the codex agent drafts, and downstream tools execute so that each layer stays singly focused
- When preparing context, pass only minimal contracts needed by the agent to maintain weak coupling and allow independent evolution of command and agent logic
- If a task spans unrelated domains, split it into discrete invocations so every execution path respects the single responsibility principle

## REQUIRED INPUTS

When user invokes `/codex`:

- **TASK_INPUT** (required): One of:
  - Explicit prompt string (quoted): `/codex "Add tests for module X"`
  - Path to markdown task file: `/codex tasks/refactor.md`
  - GitHub issue number/URL: `/codex 42` or `/codex https://github.com/user/repo/issues/42`
- **MISSION_CLASS** (optional): implementation, review, triage, etc.

## INPUT DETECTION

The command automatically detects the input type:
1. Check if input is a file path (exists on disk) → Mode 2: Multi-Step
2. Check if input is numeric or GitHub issue URL → Mode 2: Multi-Step
3. Otherwise treat as explicit prompt string → Mode 1: Single Prompt

## STEP-BY-STEP PROCEDURE

### 1. Initialize

**For Mode 1 (Single Prompt):**
- Create temporary task document with single TODO item
- Set item text to user's prompt
- Proceed to step 2 with single-item list

**For Mode 2 (Multi-Step):**
- Load `TASK_INPUT` (file or GitHub issue)
- Parse all actionable TODO items
- Enumerate items in explicit execution order
- Verify document is well-formed and unambiguous

### 2. For Each Step (Loop Until Complete)

#### a. Prepare Context
- Extract current step objective
- Identify completed steps (for context)
- Identify remaining steps (for planning)
- Gather repository state (branch, workspace status)

#### b. Invoke Codex Agent
- Call `codex` agent with current step as mission
- Provide full context (completed/remaining steps, repo state, constraints)
- Agent creates draft, calls Codex CLI, reviews output, fixes issues, commits, and pushes
- Wait for agent to return JSON result

#### c. Process Results
- Parse JSON response from agent
- Verify evidence exists for claimed success
- Agent has already reviewed, fixed issues, and committed/pushed
- If blocked/failed, assess if autonomous resolution possible
- If blocker is resolvable, create fix step and continue
- If blocker is unresolvable, escalate to user with full context

#### d. Update and Report
- Update `TASK_SOURCE` with progress (checkboxes, status, evidence links)
- Commit task source update if modified
- Report brief status to user (2-3 sentences with evidence)

#### e. Continue Immediately
- **Proceed to next step without waiting for user input**
- Repeat loop until no steps remain

### 3. Completion
- Verify all task items marked complete
- Confirm all evidence captured
- Provide comprehensive final report to user

## CONTEXT PASSED TO CODEX AGENT

Each agent invocation receives:

```
CURRENT_STEP
The single task objective for this iteration

GLOBAL_CONTEXT
- Task source: {{task_source}}
- Mission class: {{mission_class}}
- Completed steps: {{completed_steps}}
- Remaining steps: {{remaining_steps}}
- Repository root: {{repo_root}}
- Current branch: {{branch_name}}
- Workspace summary: {{workspace_summary}}
- Linked references: {{linked_references}}

CONSTRAINTS
- All CLAUDE.md standards (size limits, Fortran rules, git discipline)
- Evidence required for success claims
- Explicit file staging only
- [Task-specific constraints]

VERIFICATION
- Primary test command
- Build/lint commands if applicable

EXPECTED_OUTPUT
JSON report with: status, summary, changes, tests, artifacts, follow_up, notes
```

The agent is responsible for:
- Creating detailed draft with gaps marked
- Gathering complete context for Codex CLI
- Rendering the Codex CLI prompt template
- Executing `codex exec` once
- Capturing and parsing results
- Reviewing Codex output for correctness, completeness, cruft
- Autonomously fixing any issues found
- Updating task file/issue if it exists
- Staging, committing, and pushing changes
- Returning structured JSON to this command

## USER REPORTING

After each step completion:
- Summarize in 2-3 sentences what changed
- Include evidence references (test output, build logs, file paths)
- Note any follow-up actions applied during review
- **Do not wait for acknowledgment; proceed immediately to next step**

After all steps complete:
- Provide comprehensive wrap-up
- Confirm task document reflects full completion
- List all commits pushed
- Highlight any remaining follow-up items

## BLOCKER HANDLING

If a step cannot be completed autonomously:

1. **Assess Resolvability**
   - Can the blocker be fixed by adjusting approach?
   - Is additional information available in repo/docs?
   - Can constraints be satisfied with alternative implementation?

2. **Attempt Autonomous Fix** (if possible)
   - Create new step to address blocker
   - Execute fix step using same loop
   - Resume original step after fix

3. **Escalate** (if truly unresolvable)
   - Capture complete failure context
   - Mark task item as blocked in source document
   - Report to user with:
     - Step objective
     - Blocker description
     - Evidence of failure
     - Attempted resolutions
     - Required user action

## EXAMPLE EXECUTION FLOWS

### Example 1: Single Prompt
```
User: /codex "Add comprehensive error handling to parser.f90"

Command:
1. Detects string input → Mode 1
2. Creates temp task doc with single item
3. Invokes codex agent
   - Agent creates draft
   - Agent calls Codex CLI
   - Agent reviews and fixes issues
   - Agent commits and pushes
   - Agent returns success + test evidence
4. Reports: "Added error handling to parser.f90. All tests pass.
            Module size: 287 lines. Intents verified. Committed and pushed."
```

### Example 2: Multi-Step Task Document
```
User: /codex tasks/add-feature-x.md implementation

Command:
1. Detects file path → Mode 2
2. Loads tasks/add-feature-x.md
3. Parses 5 task items
4. Invokes codex agent for step 1
   - Agent creates draft, calls Codex, reviews, fixes, commits, pushes
   - Returns success + test evidence
   - Command updates task doc metadata
5. Reports: "Step 1/5 complete: Added module foo. Tests pass (fpm test output). Proceeding to step 2."
6. Invokes codex agent for step 2 (no pause)
   - Agent creates draft, calls Codex, reviews, fixes, commits, pushes
   - Returns success + build evidence
   - Command updates task doc metadata
7. Reports: "Step 2/5 complete: Integrated foo into main. Build succeeds. Proceeding to step 3."
8. Continues through steps 3, 4, 5 without stopping
9. Final report: "All 5 tasks complete. 5 commits pushed. Feature X ready for testing."
```

### Example 3: GitHub Issue
```
User: /codex 42

Command:
1. Detects numeric input → Mode 2
2. Fetches issue #42 via gh CLI
3. Parses TODO checklist from issue body
4. Executes each item autonomously
5. Updates issue description with evidence
6. Final report with all commits listed
```

## ALIGNMENT WITH CODEX AGENT

The `codex` agent (agents/codex.md) handles:
- Single Codex CLI execution per invocation
- Prompt template rendering
- Evidence collection and validation
- JSON result formatting
- Post-execution review and fixes
- Git operations (stage, commit, push)

This command handles:
- Multi-step orchestration
- Task document parsing and metadata updates
- Step sequencing and context management
- Autonomous loop control
- User progress reporting
- Blocker escalation decisions

The division ensures:
- Agent does ALL the work for one step (draft → codex → review → fix → commit)
- Command orchestrates multiple steps and updates task metadata
- No duplication of responsibilities
- Clear handoff protocol (command → agent → command)
