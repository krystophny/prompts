---
name: sprint-plan
description: Strategic sprint planning via chris-architect. Issue consolidation, GitHub meta-issue updates, and sprint goal establishment. Use after PLAY phase or when planning next sprint.
disable-model-invocation: false
user-invocable: true
---

# Strategic Sprint Planning

Task tool delegation to chris-architect ONLY for:
- Issue consolidation and duplicate removal
- GitHub meta-issue updates (SPRINT BACKLOG, PRODUCT BACKLOG, DESIGN)
- Sprint goal establishment

**Protocol**: GitHub API only - NO git operations

## Boy Scout Principle
- Planning passes must clean meta-issues and fix adjacent defects immediately
- If you uncover sloppy prior responses or unchecked boxes, correct them before moving forward

## EXECUTION

**DELEGATION EXECUTION SEQUENCE**:
```
Task tool -> chris-architect -> Planning Implementation
-- Sprint Transition: Assume current sprint complete
-- Input Gathering: Review ALL GitHub issues from PLAY findings
-- COMPREHENSIVE ISSUE REVIEW: Full review and consolidation
-- Sprint Planning: Update SPRINT BACKLOG meta-issue (3-5 items max)
-- Architecture Updates: Update DESIGN meta-issue with lessons
-- Completion: GitHub API updates ONLY - NO git operations
```

## SYSTEMATIC PLANNING PROCESS

1. **Sprint Transition Assessment**: Current sprint completion verification
2. **Comprehensive Input Analysis**:
   - ALL open GitHub issues from PLAY findings via GitHub API
   - SPRINT BACKLOG meta-issue EPICS and priorities assessment
   - DESIGN meta-issue architectural context integration
   - User requirements incorporation (if provided)
3. **MANDATORY ISSUE REVIEW AND CONSOLIDATION**:
   - Full review of existing open issues using `gh issue list --state open --limit 500`
   - Relevance assessment and obsolete issue closure/archival
   - Non-actionable issue elimination (workflow reminders, process docs)
   - Systematic duplicate detection and consolidation protocols
   - Priority reassessment based on architectural impact analysis
   - Actionable defect retention only (specific bugs, broken functionality)
   - Implementation guidance enhancement for clarity and precision
4. **Streamlined Sprint Planning**:
   - SPRINT BACKLOG meta-issue cleanup: Remove DONE entries
   - SPRINT_BACKLOG section rewrite with precise issues under EPICs (3-5 max)
   - Defect fixes balanced with new requirements
   - Clear sprint goal and Definition of Done establishment
5. **Architecture Documentation Updates**:
   - DESIGN meta-issue updates with lessons learned documentation
   - Architectural decision documentation for next sprint planning
   - Integration pattern planning and technical approach documentation
   - Documentation task addition to SPRINT BACKLOG meta-issue as notes
6. **GitHub API Completion**: Meta-issue updates via descriptions - **NO GIT OPERATIONS**

## OWNERSHIP AND BOUNDARIES

**EXCLUSIVE CHRIS-ARCHITECT AUTHORITY**:
- GitHub meta-issue management through API-only access
- Issue consolidation and prioritization with systematic review protocols
- Sprint goal definition with evidence-based validation systems
- Architectural decision documentation with CI integration protocols

**META-ISSUE UPDATE AUTHORITY**: EXCLUSIVE chris-architect - GitHub meta-issues ONLY
**PROTOCOL**: GitHub API issue description updates EXCLUSIVELY
**RESTRICTION**: NO CODE CHANGES - meta-issue management exclusively

**FORBIDDEN OPERATIONS**:
- Git operations (add, commit, push) - GitHub API operations only
- Code implementation activities - planning phase exclusively
- File system modifications - issue management exclusively

## IMPLEMENTATION STANDARDS

**META-ISSUE MANAGEMENT STANDARDS**:
- SPRINT BACKLOG: <1000 lines maximum, concise issue organization protocols
- PRODUCT BACKLOG: <1000 lines maximum, feature prioritization systems
- DESIGN: <1000 lines maximum, architectural documentation standards
- Issue hygiene protocols: NO emojis, precise technical language requirements
- Planning artifacts must preserve strict separation of concerns

## QUALITY GATES

**PLANNING QUALITY STANDARDS**:
- Issue count <50 (hard limit 100) through systematic management
- Zero duplicate issues via comprehensive detection systems
- Technical evidence for all issue priorities through verification protocols
- Architectural decisions with CI validation integration

**SUCCESS VALIDATION CRITERIA**:
- Sprint goal clarity through Definition of Done establishment
- Issue consolidation completeness through systematic duplicate elimination
- Meta-issue consistency through cross-reference validation protocols
- Planning evidence documentation through GitHub API verification

## Empty State Protocol

If no open issues AND no user requirements:
- **Report**: "Sprint review complete. All defects resolved. Awaiting new requirements."
- **Evidence**: GitHub API issue count verification with systematic validation
- **Action**: NO feature invention without user requirements with documentation
- **Completion**: STOP workflow execution with documented termination
