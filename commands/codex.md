# /codex - Stepwise Codex Orchestration

<mantra_rules>
  <rule_1>Always display applicable rule sets before any action</rule_1>
  <rule_2>Verify every technical claim with concrete evidence</rule_2>
  <rule_3>Respect agent boundaries and delegation protocols</rule_3>
  <rule_4>CI or local test proof is mandatory before reporting success</rule_4>
  <rule_5>Do not generate ad-hoc markdown status logs</rule_5>
</mantra_rules>

<step_loop_rules>
  <rule_1>Process exactly one task step per Codex run</rule_1>
  <rule_2>After each step, perform self-review and apply follow-up fixes immediately</rule_2>
  <rule_3>Update the source task document (markdown or issue) after every completed step</rule_3>
  <rule_4>Report progress back to the user with a concise status summary after each step</rule_4>
  <rule_5>Do not stop looping until every task in the document is fully satisfied</rule_5>
  <rule_6>Escalate only if a blocker cannot be resolved autonomously</rule_6>
  <rule_7>MUST NOT STOP FOR USER PROMPTS OR APPROVAL until all tasks are completed</rule_7>
  <rule_8>Execute continuously and autonomously through all steps without interruption</rule_8>
</step_loop_rules>

## PURPOSE
Drive the `codex` agent through a deterministic step-by-step execution loop: the command must invoke the agent for every step, and the agent must in turn run the Codex CLI one-shot workflow cleanly. The loop consumes a task markdown file or GitHub issue, completes each listed action sequentially, performs reviews and follow-up fixes after every step, and keeps the task document and user continuously updated until all work is finished.

**CRITICAL**: This command operates in fully autonomous mode. Once started, it MUST NOT pause, stop, or wait for user input until either all tasks are complete or an unresolvable blocker is encountered. The agent must execute all steps continuously without seeking approval or confirmation.

## REQUIRED INPUTS
- `TASK_SOURCE`: absolute or repo-relative path to the markdown task file **or** GitHub issue number/URL.
- `MISSION_CLASS`: implementation, review, triage, etc. (determines which rule blocks to surface).

## OPERATING PROCEDURE
1. Instantiate the `codex` agent and load `TASK_SOURCE`, enumerating actionable steps in explicit order.
2. For each step:
   - Render the Codex prompt (see template below) with the current single step as the objective.
   - Allow the `codex` agent to issue the single `codex exec` run required to perform the action.
   - Review the resulting changes, execute verification commands, and apply any fixes needed.
   - Update `TASK_SOURCE` to reflect progress (checkboxes, status text, code pointers, etc.).
   - Record a brief status update for the user summarizing what changed, evidence collected, and remaining work.
   - **Immediately proceed to the next step without waiting for user input.**
3. Repeat until every task item is marked complete with supporting evidence; the command must continue invoking the agent until no steps remain.
4. **Do not pause between steps. Do not ask for confirmation. Do not stop for approval.**
5. Provide a final comprehensive report covering the entire document completion.

## PROMPT TEMPLATE
Use one prompt per step, always populating the placeholders with the current step context and cumulative status. The `codex` agent owns the prompt construction and invocation of `codex exec`; the command only coordinates step sequencing and state updates.
```text
# QADS Codex Step Execution

## ROLE
You are Codex, operating under QADS v4.0. Obey CLAUDE.md, AGENTS.md, and the active agent rule sets. Prefer modern Fortran 2018+, enforce evidence-based delivery.

## CURRENT STEP
{{step_summary}}

## GLOBAL CONTEXT
- Task source: {{task_source}}
- Mission class: {{mission_class}}
- Completed steps: {{completed_steps}}
- Remaining steps: {{remaining_steps}}
- Repository root: {{repo_root}}
- Current branch: {{branch_name}}
- Workspace summary: {{workspace_summary}}
- Linked references: {{linked_references}}
- Additional notes: {{extra_observations}}

## CONSTRAINTS
{{constraints}}

## REQUIRED ACTIONS
1. Execute the step objective.
2. Run designated verification commands and capture evidence.
3. Perform a self-review; apply fixes if gaps remain.
4. Output a JSON report describing work performed, evidence, remaining risks, and next steps.

## OUTPUT FORMAT
Return only a fenced JSON block with keys: status, summary, changes, tests, artifacts, follow_up, notes. The command must reject any response that violates this schema and re-run the agent for the step.
```

## USER REPORTING PROTOCOL
- After each Codex run, summarize results for the user in 2-3 sentences including evidence references.
- Highlight any follow-up actions before proceeding to the next step.
- When all steps are complete, deliver a final wrap-up with confirmation that the task document reflects completion.

## BLOCKER HANDLING
If a step cannot be completed autonomously, capture the failure context, mark the task item as blocked in the source document, and escalate with required evidence.

*QADS v4.0 - Codex Stepwise Execution Command*
