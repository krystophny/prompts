# PLAY WORKFLOW - Sprint Review and Defect Discovery

**BATCH MODE EXECUTION**
- Autonomous execution - no user interaction required
- Complete defect discovery and issue consolidation
- Follow CLAUDE.md fraud-proof protocols throughout

**PREREQUISITES**: Apply all CLAUDE.md rule sets: operation_rules, workflow_rules, agent_rules, gh_rules

## Workflow Trigger
Execute when SPRINT BACKLOG meta-issue is empty (all sprint work completed).

## Execution Protocol
**Agents**: max → patrick → vicky → max → chris (sequential)

**Implementation Sequence**:
1. **max**: Infrastructure setup per Max Protocol in agents/max-devops-engineer.md
2. **patrick**: Code analysis per agents/patrick-auditor.md - structural defects only
3. **vicky**: User acceptance testing per agents/vicky-acceptance-tester.md 
4. **max**: Repository cleanup and state restoration
5. **chris**: Issue audit and consolidation per Chris Protocol in agents/chris-architect.md

**Key Constraints**:
- Sequential execution prevents conflicts
- Apply gh_rules from CLAUDE.md for all issue operations
- Defect discovery only - no file modifications
- Technical evidence required for all issues filed

## Success Criteria
- Sprint completion status reported to user
- All defects identified and filed as GitHub issues  
- No file modifications made
- Ready for next PLAN workflow

## User Integration
- Focus on user-specified areas for review
- Address user concerns from initial prompt