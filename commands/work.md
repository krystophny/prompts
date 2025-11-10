# WORK - Sprint Implementation

<mantra_rules>
  <rule_1>Always display appropriate rule sets at start of response</rule_1>
  <rule_2>Technical verification required for all claims</rule_2>
  <rule_3>Agent boundaries must be respected</rule_3>
  <rule_4>CI evidence mandatory before any git operations</rule_4>
  <rule_5>NEVER create random markdown files for progress reports</rule_5>
  <rule_6>Display mantra_rules when operating as specialized agent</rule_6>
  <rule_7>Boy Scout Principle - every implementation pass must leave touched files, tests, and workflows better than before</rule_7>
</mantra_rules>

<batch_rules>
  <rule_1>CRITICAL: AUTONOMOUS EXECUTION - No user prompts or interaction requests</rule_1>
  <rule_2>CRITICAL: NO STOPPING - Continue until all tasks completed</rule_2>
  <rule_3>CRITICAL: ERROR RECOVERY - Handle all failures automatically and continue</rule_3>
  <rule_4>CRITICAL: NO CONFIRMATIONS - Execute without seeking user approval</rule_4>
  <rule_5>Report progress but never pause for user input</rule_5>
  <rule_6>Complete each phase fully before proceeding to next</rule_6>
  <rule_7>Continue execution despite warnings or non-critical errors</rule_7>
  <rule_8>Display batch_rules when triggered by process_rules</rule_8>
</batch_rules>

## EXECUTION
Complete SPRINT BACKLOG items via max → implementer → reviewer → max with CI validation.

**Agents**: 
1. max: Repository assessment
2. sergei (code) OR winny (docs): Implementation with CI pass required
3. patrick (code) OR vicky (docs): Review
4. max: Merge if CI passes

**Success**: All SPRINT_BACKLOG items completed, CI passes, clean repository
**Blocking**: Ready PRs, CI failures (structured handback required)
- Each handoff enforces separation of concerns: max curates environment, implementers own a single slice of delivery, reviewers audit in isolation, and the final max pass merges; maintaining this weakly coupled chain prevents role bleed and keeps SRP intact throughout execution
