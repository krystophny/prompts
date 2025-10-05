# /codex - Stepwise Codex Orchestration

## COMMAND PURPOSE

Execute a multi-step task by invoking the `codex` agent repeatedly in a deterministic loop. The command consumes a task document (markdown file or GitHub issue), processes each action sequentially, and continues autonomously until all work is complete or an unresolvable blocker is encountered.

**This command operates in fully autonomous mode. Once started, it MUST NOT pause, stop, or wait for user input until completion or blocking error.**

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

## REQUIRED INPUTS

When user invokes `/codex`:

- **TASK_SOURCE**: Path to markdown task file OR GitHub issue number/URL
- **MISSION_CLASS** (optional): implementation, review, triage, etc.

## STEP-BY-STEP PROCEDURE

### 1. Initialize
- Load `TASK_SOURCE` and parse all actionable steps
- Enumerate steps in explicit execution order
- Verify task document is well-formed and unambiguous

### 2. For Each Step (Loop Until Complete)

#### a. Prepare Context
- Extract current step objective
- Identify completed steps (for context)
- Identify remaining steps (for planning)
- Gather repository state (branch, workspace status)

#### b. Invoke Codex Agent
- Call `codex` agent with current step as mission
- Provide full context (completed/remaining steps, repo state, constraints)
- Wait for agent to complete Codex CLI execution and return JSON result

#### c. Process Results
- Parse JSON response from agent
- Verify evidence exists for claimed success
- If blocked/failed, assess if autonomous resolution possible
- If blocker is resolvable, create fix step and continue
- If blocker is unresolvable, escalate to user with full context

#### d. Review and Fix
- Apply CLAUDE.md review criteria to changes
- Implement necessary fixes or improvements
- Re-run verification if fixes were applied

#### e. Update and Report
- Update `TASK_SOURCE` with progress (checkboxes, status, evidence links)
- Stage modified files explicitly
- Commit changes describing step completion and fixes
- Push to remote
- Report brief status to user (2-3 sentences with evidence)

#### f. Continue Immediately
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
- Rendering the Codex CLI prompt template
- Executing `codex exec` once
- Capturing and parsing results
- Performing self-review
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

## EXAMPLE EXECUTION FLOW

```
User: /codex tasks/add-feature-x.md implementation

Command:
1. Loads tasks/add-feature-x.md
2. Parses 5 task items
3. Invokes codex agent for step 1
   - Agent runs Codex CLI
   - Returns success + test evidence
   - Command reviews changes
   - Command updates task doc, commits, pushes
   - Reports: "Step 1 complete: Added module foo. Tests pass (fpm test output). Proceeding to step 2."
4. Invokes codex agent for step 2 (no pause)
   - Agent runs Codex CLI
   - Returns success + build evidence
   - Command reviews, updates, commits, pushes
   - Reports: "Step 2 complete: Integrated foo into main. Build succeeds. Proceeding to step 3."
5. Continues through steps 3, 4, 5 without stopping
6. Final report: "All 5 tasks complete. 5 commits pushed. Feature X ready for testing."
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
- Task document parsing and updates
- Step sequencing and context management
- Autonomous loop control
- User progress reporting
- Blocker escalation decisions

The division ensures:
- Agent focuses on single-shot execution quality
- Command manages workflow and state persistence
- No duplication of responsibilities
- Clear handoff protocol (command → agent → command)
