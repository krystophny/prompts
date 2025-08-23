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
# Planning and architecture
"plan"

# Development workflow  
"work"

# Quality audit (defects only)
"play"

# Batch processing
"batch work"    # Process all TODO items
"batch play"    # Continuous defect finding
```

## Workflow Selection

- **Features/goals** → `"plan"` → creates issues → `"work"`
- **Issues in BACKLOG.md** → `"work"`  
- **No TODO items** → `"play"` → finds defects → back to `"work"`

---

*For complete workflow details, see `CLAUDE.md`*