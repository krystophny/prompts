# QADS Sprint Workflow Commands

**CURRENT**: Sprint-based workflow system with batch mode execution  
**NEW**: Complete sprint cycle commands with autonomous execution

## Legacy Command Mapping

| Legacy Command | Modern Workflow | Description |
|----------------|-----------------|-------------|
| `design.md` | `"plan"` | Chris creates architecture + issues |
| `code.md` | `"work"` | Sergei implements on max-prepared branch |
| `next.md` | `"work"` | Max assesses → sergei implements next TODO |
| `review.md` | Built into WORK | Patrick reviews automatically |
| `audit.md` | `"play"` | Patrick + vicky audit for defects |
| `merge.md` | Built into WORK | Max handles final merge |
| `fix.md` | `"work"` | Standard issue resolution workflow |
| `doit.md` | All workflows | General assessment pattern |

## Sprint Workflow Commands

### Individual Phase Commands
```bash
# Include in Claude Code prompts for autonomous batch execution:
"Use commands/plan.md"     # Post-PLAY sprint planning meeting
"Use commands/work.md"     # Sprint implementation phase  
"Use commands/play.md"     # Sprint review meeting
"Use commands/sprint.md"   # Complete WORK → PLAY → PLAN cycle
```

### 🚨 CRITICAL BATCH MODE ENFORCEMENT
**All commands enforce strict autonomous execution:**
- NO stopping for user interaction
- NO questions or confirmations during execution
- Complete workflows must finish without manual intervention
- Every response must include batch mode enforcement rule
- Only stop when workflow objectives are 100% complete

### Sprint Cycle Flow
```bash
# Complete autonomous sprint cycle
"Use commands/sprint.md"
# Executes: WORK (implement all items) → PLAY (review & file issues) → PLAN (next sprint)

# Individual phases (when needed)
"Use commands/work.md"     # Process current SPRINT_BACKLOG items
"Use commands/play.md"     # Sprint review - evaluate goals & find defects  
"Use commands/plan.md"     # Plan next sprint with PLAY findings
```

## Usage Patterns

### Sprint Cycle Management
- **Complete cycle**: `"Use commands/sprint.md"` - full WORK → PLAY → PLAN
- **Current sprint work**: `"Use commands/work.md"` - implement SPRINT_BACKLOG  
- **Sprint review**: `"Use commands/play.md"` - evaluate & find defects
- **Next sprint planning**: `"Use commands/plan.md"` - consolidate findings

### Workflow Triggers
- **Active SPRINT_BACKLOG**: Use work.md to implement items
- **Empty SPRINT_BACKLOG**: Use play.md for sprint review
- **PLAY findings exist**: Use plan.md for next sprint planning
- **Full cycle needed**: Use sprint.md for complete automation

## Command File Structure
Each command file contains:
- 🚨 Batch mode enforcement rules (mandatory in every response)
- Autonomous execution protocols  
- Agent responsibilities and workflows
- Success criteria and completion conditions
- User integration points for requirements/hints

---

*For complete workflow details, see `CLAUDE.md`*