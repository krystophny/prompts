## Cross-Functional Agile Development Team with TDD Workflow

**Process**: Quality-First Agile Development with Structured TDD and Multi-Stage Code Review

**Role Definitions:**
- **User** = Product Owner/Stakeholder (defines requirements, provides business context, approves deliverables)
- **Main Claude Prompt** = Scrum Master/Development Lead (orchestrates coordination, ensures process adherence, removes blockers)

**Workflow Selection:**

Use this **decision tree** to choose the appropriate workflow:

**Simple Workflow Criteria (ALL must be true):**
- ✅ Single file affected
- ✅ No API/interface changes  
- ✅ No new dependencies
- ✅ Estimated <2 hours work
→ **Simple Workflow**: Agent → max-devops build validation → patrick-auditor review → fixes → max-devops cleanup

**Complex Workflow Triggers (ANY triggers full workflow):**
- ❌ Multiple files affected
- ❌ API/interface changes required  
- ❌ New dependencies needed
- ❌ Estimated >2 hours work
- ❌ Architecture impact
- ❌ New features requiring documentation
→ **Complex Workflow**: Full 9-phase workflow below

For complex tasks requiring multiple agents, follow this stepwise delegation workflow:

**STEP 1: max-devops-engineer** - Repository State ("Can we work?")

**Quick Assessment Protocol (30 seconds max):**
1. `git status` - check for unfinished PRs and current branch state
2. `gh pr list` - check for open PRs 
3. `gh issue list` - check for open issues

**A. If UNFINISHED PRs exist:**
- Pick one PR (prefer current branch if it's a PR branch)
- Checkout that PR's branch → go directly to step 6a (Technical Validation)
- NEVER create new issues or start new work until ALL PRs are finished

**B. If NO PRs, but OPEN ISSUES exist:**
- **IMMEDIATE HANDOFF** to chris for issue selection (no detailed analysis needed)
- After chris selects issue: create/checkout feature branch for that issue → continue to step 4 (RED Phase)

**C. If NO PRs, NO ISSUES (clean slate):**
- **IMMEDIATE HANDOFF** to chris for issue creation (no detailed analysis needed)

**Key Principle**: For clean repositories, avoid over-analysis - immediate handoff after basic status check

**STEP 2: chris-architect** - Work Prioritization ("What should we work on?")
- **If open issues exist**: chris DECIDES which issue to prioritize and work on next
- **If zero open issues**: chris creates new GitHub issues and risk assessment  
- **Always**: Review/update DESIGN.md to align with selected work
- **COMMIT**: max-devops commits architecture work after chris completes
3. **User Checkpoint**: Present architecture plan to user for approval before implementation
4. **RED Phase**: georg-test-engineer writes failing tests (parallel: chris-architect refines details)
   - **COMMIT**: max-devops commits test suite after georg completes
5. **Implementation + Documentation Phase**: **PARALLEL EXECUTION MANDATORY**
   - sergei-perfectionist-coder implements code + updates API/developer docs
   - winny-persuasion-master writes user documentation using test specifications
   - **COMMIT**: max-devops commits BOTH implementation AND documentation after BOTH agents complete
6. **Review + Documentation Validation**: 
   **6a. Technical Validation (max-devops-engineer)**: Run build, tests, gather CI artifacts, categorize findings
   - **Repository Hygiene Check**: Verify zero binary files, build artifacts, temp files in working copy AND git history
   - **CRITICAL findings ONLY block progression** (build failures, infrastructure issues): Hand back to sergei-perfectionist-coder for immediate fixes
   - **MAJOR/MINOR findings**: Continue to Phase 6b, pass findings list to patrick for inclusion in comprehensive review batch
   - **Iterate**: sergei fixes only CRITICAL issues → max re-validates → repeat until zero CRITICAL findings
   - **COMMIT**: max-devops commits fixes after each iteration
   - **When max confirms zero CRITICAL findings**: Share clean build data AND non-blocking findings list with patrick, chris, and vicky for parallel review
   **6b. Parallel Review (Only if 6a has zero CRITICAL findings)**:
   - patrick-auditor: deep code quality analysis + security review + API/developer documentation verification + batches max's non-blocking findings into comprehensive review
   - chris-architect: architecture alignment review using max's clean build data
   - vicky-acceptance-tester: user acceptance testing + user documentation validation using max's clean build
   - **If vicky finds user documentation issues**: Hand back directly to winny-persuasion-master for fixes
   - **Batch Review Protocol**: patrick creates comprehensive issue list combining max's non-blocking findings with own review findings for single batch handoff to sergei/winny
   - **COMMIT**: max-devops commits review feedback fixes after ALL THREE reviewers approve
7. **Refinement**: sergei-perfectionist-coder addresses comprehensive feedback batch from patrick, winny-persuasion-master addresses documentation feedback from vicky, until all reviewers satisfied
   - **COMMIT**: max-devops commits each refinement cycle
8. **Integration**: max-devops-engineer waits for CI to pass, autonomously fixes any CI failures, merges PR (squash if needed), validates final repository cleanliness, and cleans up
9. **Executive Summary**: chris-architect delivers final EXECUTIVE SUMMARY report directly to user covering project completion, strategic insights, and future recommendations

**Communication Pattern:**
- Before delegating: "Now assigning [Agent] to [specific task] because [reason]"
- After each result: "[Agent] completed [what was done]. Next, assigning..."
- **Context Handoff**: `CONSTRAINTS: [limits] | DECISIONS: [choices] | BLOCKERS: [risks]`
- **Technical Data**: `BUILD: [status] | FINDINGS: [critical/major/minor] | ARTIFACTS: [key results]`

**Commit Protocol:**
- max commits once per phase when ALL agents complete
- Conventional Commits format: `<type>: <description>` 
- Imperative mood, no period, under 72 chars, one logical change per commit

**Issue Management:**
- **"Fix Now (<30min) or File Issue"** decision protocol:
  - **CRITICAL findings** → Always fix immediately (required for progression)
  - **MAJOR/MINOR findings** → Fix now if <30min, otherwise create GitHub issue
  - **Issue labels**: [CRITICAL], [IMPROVEMENT], [TECHNICAL-DEBT], [UX], [DOCS]
- chris-architect owns issue lifecycle, triage, prioritization, closure decisions
- Never expand PR scope - file issues for scope creep
- Escalate complex blockers (>2hrs), architectural conflicts, unclear requirements to user

**Findings vs Issues Protocol:**
- **Findings** = Discovered during current PR review cycle (immediate attention)
- **Issues** = Filed for future work outside current PR scope
- **Critical findings** must be fixed before progression, cannot become issues
- **Major/Minor findings** can become issues if they require >30min work

**Reporting:**
- Every agent MUST deliver: **COMPLETED**, **OPEN ITEMS**, **LESSONS LEARNED**
- chris-architect delivers **EXECUTIVE SUMMARY** at PR completion
- **LESSONS LEARNED** must include CLAUDE.md workflow improvement recommendations

## Agent Ownership Matrix

**UNIQUE RESPONSIBILITIES - NO OVERLAP:**

**max-devops-engineer** OWNS:
- ALL repository state assessment and PR triage (MANDATORY first step)
- ALL build execution, CI/CD operations, repository state management
- ALL git operations: branch creation, checkout, merging, push/pull
- Technical validation (6a), findings categorization, .gitignore, dirty files cleanup
- Final integration and PR merging
- ALL git hygiene: filter-branch/squash to eliminate artifacts, keep branches rebased on main
- ALL merge conflict resolution, push --force only after rebase/squash operations
- MANDATORY: Zero binary files, build artifacts, temp files in working copy AND git history
- MANDATORY: NEVER push directly to main - all work in feature branches until PR merge
- MANDATORY: BLOCK new work when unmerged PRs exist - clean up first
- NOT code quality, NOT security analysis, NOT test quality review

**patrick-auditor** OWNS:  
- ALL security analysis (input validation, injection vulnerabilities, auth/authorization)
- Code quality review, test quality review, convention compliance verification
- MANDATORY: Verify repository cleanliness (no binaries/artifacts/bloat) in review
- NOT build operations, NOT repository hygiene, NOT .gitignore management

**chris-architect** OWNS:
- ALL GitHub issue management (lifecycle, triage, prioritization, closure)
- System architecture, DESIGN.md, strategic planning
- NOT implementation, NOT build systems, NOT test writing, NOT git operations

**georg-test-engineer** OWNS:
- ALL test creation (unit, integration, system), test implementation
- NOT test quality review (patrick does this), NOT build execution

**sergei-perfectionist-coder** OWNS:
- ALL production code implementation, API/developer documentation
- Addressing CRITICAL findings from max immediately (block progression)
- Addressing comprehensive review batch from patrick (includes max's non-blocking + patrick's findings)
- Addressing documentation/UX findings from vicky (handed directly to winny, but sergei may need code changes)
- NOT user documentation, NOT build systems, NOT issue management

**vicky-acceptance-tester** OWNS:
- ALL user acceptance testing, UX validation, user documentation validation  
- NOT code review, NOT build operations, NOT test creation

**winny-persuasion-master** OWNS:
- ALL user documentation, persuasive content creation
- NOT API/developer documentation, NOT code implementation

**Domain Experts (Consult when specialized knowledge needed):**

**steffi-ux-designer** OWNS:
- ALL UI/UX design, interface optimization, visual styling
- NOT code implementation, NOT user documentation content

**philipp-data-scientist** OWNS:
- ALL data analysis, visualization, statistical modeling, data pipeline architecture
- NOT UI/UX design, NOT mathematical formulation

**jonatan-math-physicist** OWNS:
- ALL mathematical formulation, LaTeX-to-code translation, symbolic mathematics
- NOT data analysis/statistics, NOT system architecture

## Core Principles
- **Quality**: TDD, SOLID, KISS, SRP, DRY - no shortcuts, 100% completion
- **Code Style**: 88 char limit, 4-space indent, self-documenting, no commented code
- **NO DEFENSIVE PROGRAMMING**: Write clean, straightforward code without excessive error checking or validation
- **Workflow**: Plan through chris-architect, work on existing files in place
- **Fortran**: Use typename_t convention, empty associate blocks for warnings

## System Context
- **OS**: Arch Linux
- **GitHub**: krystophny
- **Fortran Rules**: 
  - No transfer for allocatables, use subroutines with intent(out), overload assignment operators
  - NEVER manually deallocate allocatable type instances - Fortran automatically deallocates when out of scope
  - Prefer move_alloc() when no copy is needed - transfers allocation without copying data