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
3. **BRUTAL Issue Consolidation**:
   - Combine related defect issues from PLAY with HARSH criticism of responsible team members
   - Merge duplicates and overlapping issues, calling out who created the mess
   - Update priorities based on architectural impact and team incompetence
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
   - Create BRUTAL documentation consolidation issue calling out team's documentation failures
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

