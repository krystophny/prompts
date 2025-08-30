# WORK WORKFLOW - Sprint Implementation

**BATCH MODE EXECUTION**
- Autonomous execution - no user interaction required
- Complete all SPRINT BACKLOG items sequentially
- Follow CLAUDE.md fraud-proof protocols throughout

**PREREQUISITES**: Apply all CLAUDE.md rule sets: operation_rules, repository_rules, implementation_rules, workflow_rules, agent_rules

## Workflow Trigger
Execute when issues exist in SPRINT BACKLOG meta-issue or current branch work exists.

## Execution Protocol
**Agents**: max → (sergei OR winny) → CI-GATE → (patrick OR vicky) → max

**Implementation Sequence**:
1. **max**: Repository assessment per Max Protocol in agents/max-devops-engineer.md
2. **Implementation**: 
   - Code: sergei per Sergei Protocol in agents/sergei-perfectionist-coder.md
   - Docs: winny per agents/winny-technical-writer.md
3. **CI Gate**: Automated verification blocks PR if tests fail (see verification_rules in CLAUDE.md)
4. **Review**: 
   - Code: patrick per agents/patrick-auditor.md
   - Docs: vicky per agents/vicky-acceptance-tester.md
5. **max**: Final merge per Max Protocol, only if CI passes

**Loop**: Process all SPRINT_BACKLOG items until empty

**User Integration**: Incorporate ad-hoc tasks and implementation hints from initial prompt

## Success Criteria
- All SPRINT_BACKLOG items completed and merged
- CI passes for all changes  
- Clean repository state (no open PRs, no DOING items)

## Blocking Conditions
- Apply pr_rules, verification_rules, handback_rules from CLAUDE.md
- Ready PRs block new work until merged
- CI failures require structured handback with evidence
- Critical review issues must be resolved before merge