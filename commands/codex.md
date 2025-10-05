# /codex - Codex One-Shot Execution Bridge

<mantra_rules>
  <rule_1>Always display applicable rule sets before any action</rule_1>
  <rule_2>Verify every technical claim with concrete evidence</rule_2>
  <rule_3>Respect agent boundaries and delegation protocols</rule_3>
  <rule_4>CI or local test proof is mandatory before reporting success</rule_4>
  <rule_5>Do not generate ad-hoc markdown status logs</rule_5>
</mantra_rules>

## PURPOSE
Launch a single Codex CLI session with complete task context, enforce QADS standards, and translate Codex's structured result back to the user with verified evidence.

## PRE-FLIGHT CHECKLIST
1. Re-read `CLAUDE.md` and `AGENTS.md` sections relevant to the task class.
2. Confirm working directory is the repository root the user specified.
3. Classify the operation (implementation, review, triage, etc.) and surface the required rule blocks.
4. Gather fresh repository state (`git status --short`, current branch, pending diffs) without staging changes.
5. Collect the user's goal, constraints, success criteria, and any files/tests they mentioned.
6. Identify the verification command(s) Codex must run (default to project build/test scripts; prefer `fpm`).
7. Abort and escalate if mission scope is ambiguous or violates non-negotiables.

### REQUIRED CONTEXT PACKET (fill all fields before prompting Codex)
- `mission_summary`: concise one-paragraph description of the requested outcome.
- `inputs`: bullet list of key files, logs, issue links, or reproduction steps Codex must inspect.
- `constraints`: non-negotiable rules (Fortran-First standards, size limits, CI policies, security boundaries).
- `resources`: tooling commands Codex may execute (build/test scripts, lint, formatters).
- `evidence_targets`: explicit outputs Codex must capture (test excerpts, artifact paths, diffs).
- `handoff_expectations`: what must exist at completion (e.g., patch ready for review, CI log path).

If any field is empty, resolve the gap with the user before launching Codex.

## PROMPT TEMPLATE (populate placeholders exactly once)
```text
# QADS Codex One-Shot Mission

## ROLE
You are Codex, an autonomous engineer operating inside the QADS v4.0 fraud-proof framework. You must obey CLAUDE.md and AGENTS.md standards, prefer modern Fortran 2018+, and never claim success without verifiable evidence.

## OBJECTIVE
{{mission_summary}}

## CONTEXT
- Repository root: {{repo_root}}
- Current branch: {{branch_name}}
- Pending changes summary: {{workspace_summary}}
- Related issues / links: {{linked_references}}
- Additional notes: {{extra_observations}}

## CONSTRAINTS
{{constraints}}

## AVAILABLE RESOURCES
- Preferred build/test command(s): {{verification_commands}}
- Supporting tools: {{tools}}
- Reference files to inspect: {{inputs}}

## REQUIRED WORKFLOW
1. Understand the issue and plan the minimal change set.
2. Implement the solution adhering to Fortran-first and reuse-first policies.
3. Run required verification commands (tests, linters, artifact generation).
4. Collect evidence outputs and summarize observed results.
5. Prepare a final report matching the specified schema.

## OUTPUT FORMAT
Respond with a fenced JSON block using this schema:
~~~json
{
  "status": "success" | "blocked" | "failed",
  "summary": "<2-4 sentence result overview>",
  "changes": ["relative/path: explanation of modification"],
  "tests": [{"command": "<cmd>", "status": "pass"|"fail"|"not_run", "evidence": "<key output excerpt>"}],
  "artifacts": ["<path or URL to produced artifact or log>"],
  "follow_up": ["next action or open question"],
  "notes": "extra observations, errors, or blockers"
}
~~~
Only include the fenced JSON block in your final message—no additional prose.

## GUARDRAILS
- If blockers prevent progress, set `status` to "blocked" and explain in `notes`.
- If work would violate constraints, halt and report instead of proceeding.
- Never open draft PRs or stage all changes; rely on explicit file staging only.
```

Populate `{{...}}` with concrete values before execution. Preserve section headings exactly so Codex receives a stable prompt interface.

## EXECUTION PROCEDURE
1. Render the template with gathered context. Store it in a temp file, e.g. `prompt_file=$(mktemp /tmp/codex_prompt.XXXXXX)`.
2. Run Codex once using the non-interactive CLI:
   ```bash
   codex exec -C "{{repo_root}}" --dangerously-bypass-approvals-and-sandbox --output-last-message "$LAST_MSG" --json - <"$prompt_file"
   ```
   - Set `LAST_MSG=$(mktemp /tmp/codex_last_message.XXXXXX)` beforehand.
   - Include `--include-plan-tool` if the task benefits from Codex's internal planning.
   - This uses the same dangerous bypass flag as automation scripts to suppress approval prompts—only run inside the sanctioned sandbox.
3. Capture Codex's stdout/stderr stream for audit logs. Record the exit code.
4. Delete the prompt temp file only after results are processed.

## RESULT PROCESSING
1. Read the final message from `$LAST_MSG`; extract the JSON fenced block.
2. Parse the JSON to confirm all required keys exist and that `tests` includes at least one entry unless the task explicitly forbids execution.
3. If `status` is `success`, verify evidence references exist (log files, command output). If missing, treat as failure and hand back for remediation.
4. If `status` is `failed` or `blocked`, summarize Codex's reasoning and propose next steps instead of fabricating success.
5. Relay a concise report to the user including:
   - Operation classification and whether Codex completed it
   - Evidence summary (command outputs, artifact paths)
   - Any follow-up actions or approvals needed
   - Location of raw Codex transcript if relevant

## CLEANUP AND ESCALATION
- Remove temp files (`prompt_file`, `$LAST_MSG`) after capturing their contents.
- If the Codex CLI exits non-zero or returns malformed output, rerun only after diagnosing; otherwise escalate with the captured logs.
- Do not hide Codex errors—surface them verbatim with context.

## SELF-CHECK BEFORE RESPONDING TO USER
- [ ] Were all mandatory rule blocks displayed?
- [ ] Did the Codex prompt include every required section and constraint?
- [ ] Is the returned JSON valid and aligned with evidence requirements?
- [ ] Are success claims backed by captured logs/tests?
- [ ] Have next steps or blockers been clearly communicated?
