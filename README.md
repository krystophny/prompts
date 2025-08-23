# Quality-driven Agent Development System (QADS) v3.0

## Quick Start

Copy or symlink the following to your `~/.claude` directory:

- `CLAUDE.md`
- `agents/`
- `commands/`

```bash
# Shortcuts for each workflow
"plan"    # Planning workflow - create issues and BACKLOG.md
"work"    # Work workflow - implement from BACKLOG.md
"play"    # Play workflow - find defects only

# Batch operations
"batch work"   # Process all BACKLOG.md TODO items
"batch play"   # Continuous defect finding loop
```

## Three Core Workflows

```mermaid
graph TD
    User[User Request] --> WF{Which Workflow?}
    WF -->|Planning/design| PLAN[1. PLAN WORKFLOW]
    WF -->|Issues in BACKLOG.md| WORK[2. WORK WORKFLOW]
    WF -->|BACKLOG.md empty| PLAY[3. PLAY WORKFLOW]
    
    PLAN --> BL[BACKLOG.md + Issues]
    WORK --> IMPL[Implementation + PR]
    PLAY --> DEFECTS[Defect Issues Only]
```

### 1. PLAN WORKFLOW (shortcut: `"plan"`)
**Trigger**: User requests planning, design, or new features  
**Actor**: chris-architect ONLY  
**Authority**: FULL control of BACKLOG.md and issue creation  
**Protocol**:
1. Create/update GitHub issues
2. Update BACKLOG.md with ordered priorities
3. Update DESIGN.md as needed
4. **MANDATORY**: Commit and push BACKLOG.md immediately

### 2. WORK WORKFLOW (shortcut: `"work"`)
**Trigger**: Issues exist in BACKLOG.md or current branch work  
**Actors**: max → sergei → patrick → (user if manual) → max  
**Protocol**:
1. **max**: Repository state management + forensic analysis
   - `git fetch --all`, forensic analysis if inconsistent state
   - Choose/create branch, ensure 1 DOING + ≤1 PR rule
   - **🚨 PRE-WORK REBASE**: Prepare clean branch for sergei
2. **sergei**: Implementation only on prepared branch
   - Write tests/code, `git commit`, `git push`, create PR
3. **patrick**: Code review + issue triage
   - CRITICAL issues → handback to sergei (infinite cycles)
   - Non-critical → file as GitHub issues, add to BACKLOG.md TODO
4. **user**: Manual review (if not batch mode)
5. **max**: Final merge + cleanup
   - **🚨 PRE-MERGE REBASE**: `git rebase origin/main`
   - Wait for CI, merge PR, close issue, clean state (0 DOING, 0 PRs)

### 3. PLAY WORKFLOW (shortcut: `"play"`)
**Trigger**: BACKLOG.md empty (all issues resolved)  
**Working Directory**: Separate clone/worktree  
**Actors**: max → winny → parallel audits → chris  
**Protocol**:
1. **max**: Pull latest main, git clean -fdx
2. **winny**: Complete documentation rewrite
3. **Parallel audits**: patrick (dead code), vicky (bugs) - file issues immediately
4. **chris**: Clear DONE section, update BACKLOG.md with new issues, commit and push

## BACKLOG.md Management

### Format
```markdown
# Development Backlog

## TODO (Ordered by Priority)
- [ ] #123: Implement user authentication
- [ ] #456: Add data validation
- [ ] #789: Update documentation

## DOING (Current Work)
- [x] #101: Fix memory leak (branch: fix-memory-leak-101)

## DONE (Completed)
- [x] #100: Setup CI pipeline
```

### Operations

**Chris's BACKLOG.md Workflow**:
1. Create/update GitHub issues
2. Edit BACKLOG.md: Add issues to TODO, order by priority
3. PLAY mode: Clear DONE section before adding new TODO items
4. **MANDATORY**: `git add BACKLOG.md && git commit -m "plan: update BACKLOG.md" && git push`

**Max's Repository Management Protocol**:
1. **State Analysis & Forensic Reconciliation**:
   - `git fetch --all && git status`
   - `gh pr list --state open --draft=false`
   - **Forensic analysis** if inconsistent: branch name + PR + BACKLOG.md + commits
   - Update BACKLOG.md to match actual work being done
2. **Branch & Issue Management**:
   - Multiple PRs: choose one, continue it to completion
   - Clean state: move DOING→DONE, pick top TODO→DOING, create branch
   - **MANDATORY**: Commit/push BACKLOG.md updates
3. **Pre-work Preparation**:
   - `git rebase origin/main` (prepare clean branch)
   - **HANDOFF**: Clean rebased branch ready for sergei

**Sergei's Focused Implementation Protocol**:
1. **Implementation Only** (on max-prepared branch):
   - Write tests, implement code (NO repository management)
2. **Commit & Push**:
   - `git add <files>`, `git commit`, `git push`, create PR

**Max's Complete Role**:
- **Repository state management** (forensic analysis, branch prep)
- **BACKLOG.md issue management** (DOING→DONE, TODO→DOING)
- **Pre-work rebase**: Prepare clean branch for sergei
- **Pre-merge rebase**: `git rebase origin/main` before final merge
- **Final merge & cleanup**: Wait for CI, merge, close issues, clean state

## Repository Assessment (max-devops FIRST)

```mermaid
graph LR
    START[max-devops] --> ASSESS[Repository Assessment]
    ASSESS --> PR{Multiple PRs?}
    PR -->|Yes| CHOOSE[Choose one, continue it]
    PR -->|Single| CONT[Continue existing work]
    PR -->|None| STATE{Clean state?}
    STATE -->|Yes| TODO[Pick next TODO]
    STATE -->|No| BL{BACKLOG.md TODO?}
    BL -->|Yes| TODO
    BL -->|No| PLAY[PLAY workflow]
    TODO --> PREP[Pre-work rebase]
    CHOOSE --> PREP
    CONT --> PREP
    PREP --> SERGEI[Handoff to sergei]
```

**Max's Assessment & Forensic Protocol**:
1. `git fetch --all && git status`
2. `gh pr list --state open --draft=false`
3. **Forensic analysis** if inconsistent state
4. **State reconciliation** - update BACKLOG.md to match reality
5. **Pre-work rebase** - prepare clean branch for sergei

## Batch Mode

| Command | Behavior | Stop Condition |
|---------|----------|----------------|
| `"batch work"` | Process all TODO items | BACKLOG.md TODO empty |
| `"batch play"` | Continuous defect finding | Never (loop forever) |

**Batch characteristics**:
- FULLY AUTONOMOUS - no user interaction
- Wait for CI between tasks
- Skip manual review phase

## Agent Ownership

| Agent | Owns | Restrictions |
|-------|------|--------------|
| **max-devops** | Repository management, forensic analysis, pre/post rebase, final merge, closing issues | Cannot modify implementation code |
| **chris-architect** | BACKLOG.md, issues, DESIGN.md, architecture | MUST commit/push BACKLOG.md |
| **sergei-perfectionist** | Pure code implementation, commit/push implementation | Works on max-prepared branches only |
| **patrick-auditor** | Code review with handback, non-critical issue filing + BACKLOG.md TODO additions | Cannot modify implementation, infinite review cycles allowed |
| **winny-technical-writer** | Documentation consolidation (PLAY only) | Cannot modify code |
| **vicky-acceptance-tester** | Bug detection, issue filing (PLAY only) | Cannot modify code |

## Core Standards

### Code Quality
- TDD: RED/GREEN/REFACTOR
- CORRECTNESS > PERFORMANCE > KISS > SRP > YAGNI > DRY > SOLID > SECURITY
- Files <1000 lines (target <500)
- Functions <100 lines (target <50)
- 88 char limit, 4-space indent
- NO commented code, stubs, placeholders

### Git Operations
- `git add <file>` ONLY (never `.` or `-A`)
- Commit immediately after work
- Push right after committing
- NO emojis in commits/PRs/issues
- Conventional commits: `type: description`

### PR Management
- NO draft PRs - create ready for review
- NEVER close PRs without merge
- Fix in review loop until resolved
- BACKLOG.md already updated before PR

### Documentation
- Example-first approach
- ELIMINATE ALL DUPLICATION
- Copy-paste ready examples
- Concise and information-dense

### Cleanup Policy
- Delete obsolete code immediately
- NO backup copies or commenting out
- Boy Scout Rule: leave cleaner than found

## PLAY Workflow Constraints

**DEFECTS ONLY**:
- ✅ Bugs, broken functionality
- ✅ Dead code, unused imports
- ✅ Obsolete documentation
- ✅ Security vulnerabilities
- ✅ Performance regressions
- ❌ NO features or enhancements
- ❌ NO scope expansion

## User Authority

User has **ULTIMATE AUTHORITY** to override any rule or decision:
- Direct task assignment: `"Work on issue #123"`
- Skip agents: `"Skip patrick review"`
- Modify workflows: Immediate execution
- NO questioning or alternatives offered

## Definition of Done

✅ Tests pass  
✅ CI green  
✅ Code reviewed  
✅ BACKLOG.md updated  
✅ PR merged  
✅ Issue closed

## Quick Reference

| Shortcut | Action |
|----------|--------|
| `"plan"` | Start PLAN workflow |
| `"work"` | Start WORK workflow |
| `"play"` | Start PLAY workflow |
| `"batch work"` | Autonomous TODO processing |
| `"batch play"` | Continuous defect finding |
| `"Work on #123"` | Override issue selection |
| `"Skip [agent]"` | Modify review chain |

---

*QADS v3.0 - Simplified three-workflow system with BACKLOG.md tracking*  
*User authority absolute. Mandatory compliance required.*