# PLAN WORKFLOW - Sprint Planning Meeting

## Workflow Trigger
Execute this command after PLAY workflow completion or when user requests planning.

## Execution Protocol
**Agent**: chris-architect EXCLUSIVELY

**Autonomous Execution Sequence**:
1. **Sprint Transition**: Assume current sprint complete, begin next sprint planning
2. **Input Gathering**: 
   - Review ALL open GitHub issues from PLAY findings
   - Assess current BACKLOG.md EPICs and priorities
   - Integrate DESIGN.md architectural context
   - Incorporate user requirements (if provided in initial prompt)
3. **🚨 COMPREHENSIVE ISSUE AUDIT AND CONSOLIDATION**:
   - **MANDATORY FULL REVIEW**: Read through ALL existing GitHub issues using `gh issue list -s all` and examine each one in detail
   - **RELEVANCE CHECK**: Close/archive issues that are no longer relevant or obsolete
   - **🚨 DELETE NON-ACTIONABLE ISSUES**: Close workflow reminders, process documentation, general notes that belong in BACKLOG.md
   - **BRUTAL DUPLICATE ELIMINATION**: Merge duplicates and overlapping issues, calling out who created the mess
   - **PRIORITY REASSESSMENT**: Update priorities based on architectural impact and team incompetence
   - **KEEP ONLY ACTIONABLE DEFECTS**: Issues must be specific bugs, broken functionality, or critical architectural violations
   - Add BRUTAL implementation guidance: "Fix this properly", "Stop being lazy", "Do it right this time"
4. **SHORT Sprint Planning** (team can't handle complexity):
   - Clean BACKLOG.md: Remove completed DONE entries
   - Rewrite SPRINT_BACKLOG section with TINY, PRECISE issues under EPICs (MAX 3-5 issues per sprint)
   - Balance defect fixes with new requirements (keep tasks small for incompetent team)
   - Set clear sprint goal and Definition of Done with harsh expectations
5. **Architecture Updates**:
   - Update DESIGN.md with lessons learned
   - Document architectural decisions for next sprint
   - Plan integration patterns and technical approach
   - Add documentation tasks to BACKLOG.md as sprint notes (NOT as GitHub issues)
6. **Completion**: Commit and push BACKLOG.md and DESIGN.md directly to main

**File Edit Authority**: EXCLUSIVE - only chris may edit BACKLOG.md and DESIGN.md
**Commit Protocol**: Direct commits to main (no PRs for planning files)
**Restriction**: NO CODE CHANGES - planning files only

## Success Criteria
- Sprint goal and Definition of Done clearly defined
- All PLAY issues consolidated and prioritized
- BACKLOG.md updated with next sprint structure
- DESIGN.md reflects architectural lessons learned
- Changes committed and pushed to main
- Workflow complete without manual intervention

## Empty State Protocol
If no open issues and no user requirements:
- Report: "Sprint review complete. All defects resolved. Awaiting new requirements."
- DO NOT invent features or scope
- STOP workflow execution

