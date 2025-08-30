# PLAN WORKFLOW - Sprint Planning

**AGENT**: chris-architect exclusively 
**PREREQUISITES**: Apply Chris Protocols from agents/chris-architect.md

## Workflow Trigger
Execute after PLAY workflow completion or when user requests planning.

**Autonomous Execution Sequence**:
1. **Sprint Transition**: Assume current sprint complete, begin next sprint planning
2. **Input Gathering**: 
   - Review ALL open GitHub issues from PLAY findings
   - Assess current SPRINT BACKLOG meta-issue EPICs and priorities
   - Integrate DESIGN meta-issue architectural context
   - Incorporate user requirements (if provided in initial prompt)
3. **🚨 COMPREHENSIVE ISSUE AUDIT AND CONSOLIDATION**:
   - **MANDATORY FULL REVIEW**: Read through ALL existing GitHub issues using `gh issue list -s all` and examine each one in detail
   - **RELEVANCE CHECK**: Close/archive issues that are no longer relevant or obsolete
   - **🚨 DELETE NON-ACTIONABLE ISSUES**: Close workflow reminders, process documentation, general notes that belong in SPRINT BACKLOG meta-issue
   - **BRUTAL DUPLICATE ELIMINATION**: Merge duplicates and overlapping issues, calling out who created the mess
   - **PRIORITY REASSESSMENT**: Update priorities based on architectural impact and team incompetence
   - **KEEP ONLY ACTIONABLE DEFECTS**: Issues must be specific bugs, broken functionality, or critical architectural violations
   - Add BRUTAL implementation guidance: "Fix this properly", "Stop being lazy", "Do it right this time"
4. **SHORT Sprint Planning** (team can't handle complexity):
   - Clean SPRINT BACKLOG meta-issue: Remove completed DONE entries from description
   - Rewrite SPRINT_BACKLOG section with TINY, PRECISE issues under EPICs (MAX 3-5 issues per sprint)
   - Balance defect fixes with new requirements (keep tasks small for incompetent team)
   - Set clear sprint goal and Definition of Done with harsh expectations
5. **Architecture Updates**:
   - Update DESIGN meta-issue with lessons learned
   - Document architectural decisions for next sprint
   - Plan integration patterns and technical approach
   - Add documentation tasks to SPRINT BACKLOG meta-issue as sprint notes (NOT as separate GitHub issues)
6. **Completion**: Update GitHub meta-issues (SPRINT BACKLOG, PRODUCT BACKLOG, DESIGN) via issue descriptions - **🚨 NO GIT OPERATIONS**

**Meta-Issue Update Authority**: EXCLUSIVE - only chris may update GitHub meta-issues (SPRINT BACKLOG, PRODUCT BACKLOG, DESIGN)
**Protocol**: GitHub API issue description updates ONLY - **🚨 ABSOLUTELY NO git add, commit, push operations**
**Restriction**: NO CODE CHANGES - meta-issue management only

## Success Criteria
- Sprint goal and Definition of Done clearly defined
- All PLAY issues consolidated and prioritized
- SPRINT BACKLOG meta-issue updated with next sprint structure
- DESIGN meta-issue reflects architectural lessons learned
- Meta-issue descriptions updated via GitHub API - **🚨 NO git operations performed**
- Workflow complete without manual intervention

## Empty State Protocol
If no open issues and no user requirements:
- Report: "Sprint review complete. All defects resolved. Awaiting new requirements."
- DO NOT invent features or scope
- STOP workflow execution

