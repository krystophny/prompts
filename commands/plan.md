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
3. **Issue Consolidation**:
   - Combine related defect issues from PLAY
   - Merge duplicates and overlapping issues
   - Update priorities based on architectural impact
   - Enhance with implementation guidance
4. **Sprint Planning**:
   - Clean BACKLOG.md: Remove completed DONE entries
   - Rewrite SPRINT_BACKLOG section with prioritized issues under EPICs
   - Balance defect fixes with new requirements
   - Set clear sprint goal and Definition of Done
5. **Architecture Updates**:
   - Update DESIGN.md with lessons learned
   - Document architectural decisions for next sprint
   - Plan integration patterns and technical approach
   - Create documentation consolidation issue
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

