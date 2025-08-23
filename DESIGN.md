# Quality-driven Agent Development System (QADS) - Architecture Design

## System Overview

QADS v3.0 implements a three-workflow system with specialized AI agents managing software development through BACKLOG.md-driven task tracking.

```
USER REQUESTS
     |
     v
[PLAN WORKFLOW] --> BACKLOG.md --> [WORK WORKFLOW]
                         ^                |
                         |                v
                    [PLAY WORKFLOW] <-- Delivered Code
```

## Core Architecture Components

### 1. Workflow Engine

**PLAN Workflow**
- **Actor**: chris-architect
- **Input**: User requirements
- **Output**: GitHub issues, prioritized BACKLOG.md
- **State**: Stateless planning sessions

**WORK Workflow**
- **Actors**: max → sergei → patrick → max
- **Input**: BACKLOG.md TODO items
- **Output**: Implemented features, merged PRs
- **State**: Branch-based with PR tracking

**PLAY Workflow**
- **Actors**: max → winny → patrick/vicky → chris
- **Input**: Empty BACKLOG.md (all work complete)
- **Output**: New defect issues in BACKLOG.md
- **State**: Separate worktree/clone

### 2. Data Flow Architecture

```
BACKLOG.md Structure:
┌─────────────────────────┐
│ TODO (Priority Ordered) │ ← chris creates/orders
├─────────────────────────┤
│ DOING (Current Work)    │ ← sergei moves TODO→DOING
├─────────────────────────┤
│ DONE (Completed)        │ ← sergei moves DOING→DONE
└─────────────────────────┘
           ↓
    Git Repository
           ↓
    GitHub Issues/PRs
```

### 3. Agent Responsibilities Matrix

| Agent | PLAN | WORK | PLAY | Primary Ownership |
|-------|------|------|------|-------------------|
| chris-architect | LEAD | - | Final | BACKLOG.md, Issues, Architecture |
| max-devops | - | Start/End | Start | Repository, Merges, CI |
| sergei-perfectionist | - | Implement | - | Code, Tests, PRs |
| patrick-auditor | - | Review | Audit | Code Quality, Dead Code |
| winny-writer | - | - | Docs | Documentation |
| vicky-tester | - | - | Test | Bug Detection |

### 4. State Management

**Repository States**
```
CLEAN STATE:
- 0 DOING items
- 0 open PRs
- main branch current

WORK STATE:
- 1 DOING item maximum
- 1 PR maximum (non-draft)
- Feature branch active

INCONSISTENT STATE:
- Triggers forensic analysis
- Reconciliation to valid state
- BACKLOG.md as source of truth
```

### 5. Quality Gates

**Pre-Implementation Gate** (max-devops)
- Repository clean check
- Rebase against main
- BACKLOG.md consistency

**Implementation Gate** (sergei)
- Test-first development
- Code quality standards
- Targeted test execution

**Review Gate** (patrick)
- Critical issues → sergei handback
- Non-critical → new GitHub issues
- Infinite review cycles allowed

**Merge Gate** (max-devops)
- CI checks passing
- Final rebase
- Clean state verification

## Implementation Patterns

### Branch Naming Convention
```
<type>-<issue-number>
Examples:
- feat-123
- fix-456
- refactor-789
```

### Commit Message Format
```
<type>: <description>

Types: feat, fix, refactor, test, docs, perf, chore
Example: fix: resolve memory leak in data processor
```

### PR Title Format
```
<type>: <description>
References: fixes #<issue-number>
Example: feat: add user authentication (fixes #123)
```

## System Boundaries

### External Interfaces
- **GitHub API**: Issues, PRs, CI status
- **Git**: Version control, branching
- **User Input**: Requirements, overrides

### Internal Boundaries
- **Agent Isolation**: Each agent works within ownership
- **Workflow Separation**: No cross-workflow dependencies
- **State Encapsulation**: BACKLOG.md as single source

## Error Handling Strategy

### Forensic Analysis Protocol
When state inconsistency detected:
1. Examine branch name pattern
2. Review PR descriptions
3. Analyze commit history
4. Check file changes
5. Reconcile with BACKLOG.md

### Recovery Mechanisms
- **Stuck PR**: Forensic analysis → continue work
- **Multiple PRs**: Priority selection → completion
- **Lost state**: BACKLOG.md reconstruction

## Performance Considerations

### Optimization Points
- Targeted test execution (not full suite)
- Parallel PLAY audits
- Batch mode automation
- Incremental documentation updates

### Resource Management
- Single DOING item constraint
- Single PR constraint
- Branch cleanup after merge
- Worktree for PLAY workflow

## Security Architecture

### Code Security
- No hardcoded secrets
- Input validation
- Secure defaults
- Dependency scanning via CI

### Process Security
- GitHub authentication
- Protected main branch
- Review requirements
- CI/CD gates

## Extension Points

### Custom Workflows
Extension possible through:
- New agent definitions
- Workflow composition
- BACKLOG.md sections
- GitHub labels/milestones

### Integration Options
- CI/CD pipelines
- External issue trackers
- Documentation systems
- Monitoring/metrics

## Example Workflow Execution

### PLAN Example
```bash
# User request
"Add user authentication feature"

# chris-architect actions
1. Create GitHub issue #123
2. Update BACKLOG.md TODO section
3. Set priority ordering
4. Commit and push BACKLOG.md
```

### WORK Example
```bash
# max-devops start
1. git fetch --all && git status
2. Move #123 TODO→DOING in BACKLOG.md
3. Create branch feat-123
4. git rebase origin/main

# sergei implementation
1. Write authentication tests
2. Implement authentication
3. git add src/auth.py tests/test_auth.py
4. git commit -m "feat: add user authentication"
5. git push
6. gh pr create --title "feat: add user authentication"

# patrick review
1. Review code quality
2. Critical issues → sergei
3. Non-critical → new issues

# max-devops merge
1. git rebase origin/main
2. git push --force-with-lease
3. Wait for CI
4. Merge PR
5. Close issue #123
```

### PLAY Example
```bash
# max-devops setup
1. Create worktree/clone
2. git clean -fdx

# winny documentation
1. Consolidate all docs
2. Remove duplication

# patrick/vicky parallel
1. Find dead code → issue
2. Find bugs → issue

# chris finalize
1. Clear DONE section
2. Add new issues to TODO
3. Commit and push BACKLOG.md
```

## Architecture Decisions Record (ADR)

### ADR-001: BACKLOG.md as Single Source of Truth
**Status**: Accepted
**Context**: Need centralized task tracking
**Decision**: Use BACKLOG.md with TODO/DOING/DONE
**Consequences**: Simple, visible, Git-tracked state

### ADR-002: Single DOING Item Constraint
**Status**: Accepted
**Context**: Prevent WIP explosion
**Decision**: Maximum 1 DOING item
**Consequences**: Focus, completion, reduced context switching

### ADR-003: Infinite Review Cycles
**Status**: Accepted
**Context**: Quality over speed
**Decision**: Patrick can handback indefinitely
**Consequences**: Higher quality, longer cycles possible

### ADR-004: Batch Mode Automation
**Status**: Accepted
**Context**: Enable autonomous operation
**Decision**: Full automation in batch mode
**Consequences**: Unattended operation, no user gates

## Metrics and Observability

### Key Metrics
- Issues completed per cycle
- Review iterations per PR
- Time in DOING state
- Defects found in PLAY

### Monitoring Points
- BACKLOG.md state transitions
- PR lifecycle events
- CI/CD pipeline status
- Agent handoff points

## Deployment Architecture

### Development Environment
- Local Git repository
- GitHub integration
- Agent simulation via prompts

### Production Considerations
- CI/CD integration required
- GitHub Actions recommended
- Protected branch rules
- Review requirements

## Maintenance and Evolution

### Version Management
- QADS version in CLAUDE.md
- Agent definitions versioned
- Workflow compatibility matrix

### Upgrade Path
- Backward compatible changes
- Migration scripts if needed
- Documentation updates
- Agent retraining

---

*QADS Architecture Design v3.0 - Supporting chris-architect workflow*