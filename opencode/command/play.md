---
description: 1. TASK CONTEXT
agent: general
model: anthropic/claude-sonnet-4-20250514
---
## OPENCODE AGENT INVOCATION EXAMPLES

The PLAY workflow uses agents for defect discovery:

```markdown
# Sequential execution order (important for avoiding conflicts):

# 1. Max PR Assessment
Use task tool: subagent_type='max-devops-engineer', description='PR assessment', prompt='Check for open PRs and handback to WORK mode if any exist'

# 2. Patrick Code Audit  
Use task tool: subagent_type='patrick-auditor', description='Code audit', prompt='Perform comprehensive code audit and file GitHub issues for all defects found'

# 3. Vicky Acceptance Testing
Use task tool: subagent_type='vicky-acceptance-tester', description='User testing', prompt='Test user-facing functionality and file issues for usability problems'  

# 4. Chris Issue Consolidation
Use task tool: subagent_type='chris-architect', description='Issue consolidation', prompt='Review and consolidate all filed issues, close duplicates, organize for next sprint'
```

# PLAY WORKFLOW - Sprint Review and Defect Discovery

## 1. TASK CONTEXT
Execute defect discovery workflow with fraud-proof evidence collection per QADS v4.0 framework Section 7.

### PLAY COMMAND PROTOCOL
<play_command_rules>
  <rule_1>Sequential agent execution mandatory</rule_1>
  <rule_2>Defect discovery only - NO file modifications</rule_2>
  <rule_3>GitHub API operations for issue filing</rule_3>
  <rule_4>NEVER create random markdown files for progress reports</rule_4>
  <rule_5>Display play_command_rules when executing PLAY workflow</rule_5>
</play_command_rules>

## 2. TONE CONTEXT  
Follow QADS v4.0 framework Section 2 professional standards with technical verification.

## 3. BACKGROUND DATA
Apply QADS v4.0 framework Section 3 workflow system - PLAY mode restrictions and agent protocols.

## 4. DETAILED TASK RULES
**PREREQUISITES**: Apply all QADS v4.0 framework rule sets: operation_rules, workflow_rules, agent_rules, gh_rules
**EXECUTION**: Sequential agent deployment per workflow_rules rule_7

## 5. EXAMPLES
See QADS v4.0 framework Section 5 - Evidence-Based Verification patterns and agent role execution examples.

## 6. CONVERSATION HISTORY  
Sprint completion triggers PLAY → defect discovery → next PLAN cycle per QADS v4.0 framework Section 6.

## 7. IMMEDIATE TASK
Launch agents via task tool (use subagent_type parameter to specify agent) (use subagent_type parameter to specify agent): max → patrick → vicky → max → chris (workflow_rules rule_7)
- Each agent operates per their protocol in agents/*.md files
- Apply gh_rules from QADS v4.0 framework for all GitHub operations
- NO file modifications - defect discovery only

## 8. THINKING STEP-BY-STEP
Before execution: Apply QADS v4.0 framework Section 8 systematic reasoning and AI failure prevention.

## 9. OUTPUT FORMATTING
Use QADS v4.0 framework Section 9 mandatory output structure with technical verification evidence.

## 10. PREFILLED RESPONSE
```
## PLAY WORKFLOW EXECUTION REPORT
**OPERATION TYPE**: Process
**WORKFLOW MODE**: PLAY  
**EVIDENCE PROVIDED**: [Agent reports with GitHub issue URLs]
```
