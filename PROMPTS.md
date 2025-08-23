# QADS Development Patterns

Historical patterns for Quality-driven Agent Development System implementation.

## Core Development Cycle

**Assess → Plan → Execute → Review → Iterate**

Always start with architecture verification and build system understanding before implementation.

## Project Initialization Pattern

```bash
# 1. Initialize project with clear goals
"The goal of this project is <specific_goal>"

# 2. Create architectural foundation  
- Update DESIGN.md with architectural plan
- Create detailed GitHub issues with checklists
- Emphasize: NO shortcuts, stubs, or placeholders
- Commit and push immediately
```

## Issue Resolution Pattern

```bash
# 1. State assessment
git checkout main && git pull
gh issue list --state open
gh pr list --state all

# 2. Select optimal issue
# Choose based on priority and current project state

# 3. TDD Implementation
# RED: Write failing tests (Given-When-Then BDD style)
# GREEN: Implement functionality to pass tests  
# REFACTOR: Clean up implementation while keeping tests green

# 4. Incremental progress
# After each increment: update issue, commit, push

# 5. PR completion
# Ensure tests pass, create PR, address CI feedback
```

## Quality Review Criteria

**Comprehensive PR review checklist:**

- ✅ **Scope**: Issue objectives fulfilled, aligned with project goals
- ✅ **Correctness**: No stubs, shortcuts, or illegal workarounds
- ✅ **Concurrency**: No race conditions or thread safety issues  
- ✅ **Cleanliness**: Dead/legacy/duplicated code eliminated
- ✅ **Testing**: Adequate coverage, targeted non-shallow tests, fast execution
- ✅ **Repository**: Only appropriate files committed to git
- ✅ **Structure**: Consistent file/directory naming and organization
- ✅ **Documentation**: Current and accurate  
- ✅ **Standards**: CLAUDE.md conventions followed

**After review: Revise → Test → Commit → Push**

## Audit Pattern

```bash
# Comprehensive codebase audit
# Focus areas:
- Shortcuts and stubs removal
- Duplicate/legacy/dead code elimination  
- Test quality (shallow, tautological, inefficient tests)
- CLAUDE.md compliance verification
- Fix incrementally with test coverage
```

## Legacy References

See `commands/` directory for deprecated individual command files.  
Modern QADS uses three-workflow system: PLAN → WORK → PLAY.

---

*For current system specification, see `CLAUDE.md`*