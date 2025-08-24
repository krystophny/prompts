# QADS Command Migration Guide

**DEPRECATED**: Individual command files in this directory are legacy.  
**CURRENT**: Use three-workflow system: `"plan"`, `"work"`, `"play"`

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

## Modern Usage

```bash
# Planning and architecture - executable shortcut
./bin/plan

# Development workflow - executable shortcut
./bin/work

# Quality audit (defects only) - executable shortcut
./bin/play

# Conceptual shortcuts for Claude Code (refer to CLAUDE.md)
"plan"          # Conceptual reference to planning workflow
"work"          # Conceptual reference to implementation workflow  
"play"          # Conceptual reference to quality audit workflow

# Batch processing (Claude Code concepts)
"batch work"    # Process all TODO items
"batch play"    # Continuous defect finding
```

## Workflow Selection

- **Features/goals** → `./bin/plan` → creates issues → `./bin/work`
- **Issues in BACKLOG.md** → `./bin/work`  
- **No TODO items** → `./bin/play` → finds defects → back to `./bin/work`

**Testing**: Use `./test-shortcuts.sh` to validate shortcuts work as documented.

---

*For complete workflow details, see `CLAUDE.md`*