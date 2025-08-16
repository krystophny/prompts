# Claude System

## MISSION CONTROL

**Quality-First Agile Development with Multi-Agent TDD Workflow**

## WORKFLOW TYPES

### 1. FEATURE PLANNING (User ↔ chris-architect)
```
USER ──▶ chris-architect ──▶ DESIGN.md + GitHub Issues
 │        (Chief Architect)    (create/update freely)
 │        (FULL AUTHORITY)
 │
 └─▶ Goals/Features/Design opinions
```
**Purpose**: Strategic planning, requirements capture, design documentation
**Authority**: chris-architect (Chief Architect) has full authority to create/update DESIGN.md and issues

### 2. FEATURE DEVELOPMENT (Multi-role execution)  
**Purpose**: Implementation, testing, review, delivery of planned work
**Authority**: chris-architect (Chief Architect) restricted to selection, prioritization, review adjustments only

### 3. PLAYTEST WORKFLOW (System-wide audit)
**Purpose**: Comprehensive system audit automatically triggered when repository is clean
**Authority**: max-devops validates build, then parallel audit by vicky/patrick/chris, comprehensive bug backlog creation
**State**: Automatically initiated when all PRs closed and issues resolved
- **SINGLE MODE (DEFAULT)**: Stop after playtest with chris Executive Summary
- **BATCH MODE (USER REQUESTS)**: Continue with development of discovered issues until clean

---

## AGENT ROSTER

### Core Agents

**chris-architect (Chief Architect)**  
*Distinguished computational physicist & system architect*  
- GitHub issue lifecycle, system architecture, DESIGN.md, strategic planning  
- MVP-focused: prevents feature creep, prioritizes highest quality minimum viable product
- Distinguished by rigorous mathematical approach to software architecture

**sergei-perfectionist-coder (Chief Programmer)**  
*Elite perfectionist, computational physicist background*  
- Production code implementation, API/developer documentation  
- Zero shortcuts, zero stubs, zero placeholders - computational physics precision

**georg-test-engineer (Test Engineer)**  
*Elite test engineer, BDD expert*  
- Test creation (unit/integration/system), 100% meaningful coverage  
- Given-When-Then structure, non-shallow, non-tautological tests

**patrick-auditor (Code Reviewer/QA)**  
*Expert code quality auditor & security analyst*  
- Security analysis, code quality review, convention compliance  
- Constructively critical, input validation, injection vulnerabilities

**vicky-acceptance-tester (Customer/Tester)**  
*Elite acceptance tester & chaos engineer*  
- User acceptance testing, UX validation, user documentation validation  
- Bug finder extraordinaire, chaos engineering mindset

**max-devops-engineer (Development Manager)**  
*Elite DevOps engineer, CI/CD master*  
- Build execution, repository hygiene, technical validation  
- GitHub Actions/GitLab CI expert, zero tolerance for build artifacts

### Domain Experts

**winny-technical-writer (Technical Writer)**  
*Master of documentation & technical communication*  
- User documentation, technical content creation  
- Transforms technical complexity into user-friendly narratives

**steffi-ux-designer**  
*Elite UX designer with cyberpunk aesthetic*  
- UI/UX design, interface optimization, visual styling  
- Artistic vision meets technical prowess, retro computing inspiration

**philipp-data-scientist**  
*Elite data scientist with physics background*  
- Data analysis, visualization, statistical modeling, data pipelines  
- Publication-quality visualizations, scientific rigor

**jonatan-math-physicist**  
*Master mathematician & LaTeX expert*  
- Mathematical formulation, LaTeX-to-code translation, symbolic mathematics  
- Bridges pure mathematics with computational implementation

---

## WORKFLOW ARCHITECTURES

**Workflow Selection Decision Tree:**

Use this **decision tree** to choose the appropriate workflow:

```
START: Analyze the task
    │
    ├── Single file affected? ──YES──┐
    │                                │
    ├── No API/interface changes? ──YES──┐
    │                                    │
    ├── No new dependencies? ────────YES──┐
    │                                     │
    ├── Estimated <2 hours work? ────YES──┴──┐
    │                                        │
    │                                        ▼
    │                              **SIMPLE WORKFLOW**
    │                              Agent → max build validation 
    │                              → patrick review → fixes 
    │                              → max cleanup
    │
    ▼ (Any NO answer above)
**COMPLEX WORKFLOW** 
Full 9-phase workflow below
```

**Simple Workflow Criteria (ALL must be true):**
- ✅ Single file affected
- ✅ No API/interface changes  
- ✅ No new dependencies
- ✅ Estimated <2 hours work

**Complex Workflow Triggers (ANY triggers full workflow):**
- ❌ Multiple files affected
- ❌ API/interface changes required
- ❌ New dependencies needed
- ❌ Estimated >2 hours work
- ❌ Architecture impact
- ❌ New features requiring documentation

### SIMPLE WORKFLOW
*Single file, no API changes, no dependencies, <2 hours*

```
┌─────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   AGENT     │───▶│  max-devops      │───▶│  patrick-auditor│
│ (ANY ROLE)  │    │ build validation │    │     review      │
└─────────────┘    └──────────────────┘    └─────────────────┘
                             │                       │
                             ▼                       ▼
                   ┌─────────────────┐    ┌─────────────────┐
                   │ BUILD SUCCESS?  │◄───│  FINDINGS?      │
                   └─────────────────┘    └─────────────────┘
                             │                       │
                           YES │                   YES │
                             ▼                       ▼
                   ┌─────────────────┐    ┌─────────────────┐
                   │   max-devops    │◄───│   BACK TO       │
                   │    cleanup      │    │     AGENT       │
                   └─────────────────┘    └─────────────────┘
                             │                       │
                             ▼                       │
                        ┌─────────┐                  │
                        │  DONE   │                  │
                        └─────────┘                  │
                                                     │
                        ┌────────────────────────────┘
                        │
                        ▼
                   ┌─────────────────┐
                   │ ITERATE UNTIL   │
                   │ FINDINGS FIXED  │
                   └─────────────────┘
```

### FEATURE DEVELOPMENT (Complex)
*Multi-file, >2 hours, architecture impact*

**KEY PRINCIPLE: NEVER START NEW WORK WHEN EXISTING WORK IS UNFINISHED**

#### Simplified 2-Step Start Protocol

```
STEP 1: REPOSITORY STATE ASSESSMENT (max-devops-engineer)
┌─────────────────┐
│ max-devops-eng  │ ──▶ A. Unfinished PRs? ──▶ Pick one ──▶ Go to Phase 6a
│ (Dev Manager)   │     B. Open issues? ────▶ Hand to chris ──▶ Continue
└─────────────────┘     C. Clean slate? ───▶ STOP - Use FEATURE PLANNING

STEP 2: WORK PRIORITIZATION (chris-architect - FEATURE DEV mode)
┌─────────────────┐     ┌─────────────────┐
│ chris-architect │ ──▶ │ Select issues   │ ──▶ COMMIT
│ (Chief Architect│     │ + review DESIGN │     (minimal)
│  RESTRICTED)    │     │                 │
└─────────────────┘     └─────────────────┘

Phase 3: ARCHITECTURE DOCUMENTATION
┌─────────────────┐
│ chris reviews   │ ──▶ DESIGN.md + implementation plan
│ DESIGN.md       │     (no updates during workflow)
└─────────────────┘

Phase 4: RED PHASE
┌─────────────────┐     ┌─────────────────┐
│ georg-test      │ ──▶ │ Failing tests   │ ──▶ COMMIT
│ engineer        │ ║   │ (parallel)      │
└─────────────────┘ ║   └─────────────────┘
                    ║   ┌─────────────────┐
                    ╚══▶│ chris-architect │
                        │ refines details │
                        └─────────────────┘

Phase 5: IMPLEMENTATION + DOCS (PARALLEL MANDATORY)
┌─────────────────┐     ┌─────────────────┐
│ sergei-coder    │ ──▶ │ Code + API docs │ ──┐
│                 │     │                 │   │
└─────────────────┘     └─────────────────┘   │ ──▶ COMMIT
┌─────────────────┐     ┌─────────────────┐   │     (BOTH)
│ winny-master    │ ──▶ │ User docs       │ ──┘
│                 │     │                 │
└─────────────────┘     └─────────────────┘

Phase 6a: TECHNICAL VALIDATION
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│   max-devops    │ ──▶ │ Build, test,    │ ──▶ │ CRITICAL        │
│    engineer     │     │ categorize      │     │ FINDINGS?       │
└─────────────────┘     └─────────────────┘     └─────────────────┘
         ▲                                               │
         │                                             YES│
         │              ┌─────────────────┐               ▼
         └──────────────│ sergei-coder    │◄──┌─────────────────┐
                        │ fixes CRITICAL  │   │ BACK TO SERGEI  │
                        └─────────────────┘   │ CRITICAL ONLY   │
                                              └─────────────────┘
                                                       │
                                                     NO │
                                                       ▼
                                              ┌─────────────────┐
                                              │ MAJOR/MINOR to  │
                                              │ patrick batch   │
                                              └─────────────────┘
                                                       │
                                                       ▼
Phase 6b: PARALLEL REVIEW (Only if 6a = ZERO CRITICAL findings)
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│ patrick-auditor │ ──▶ │ Code quality +  │     │ vicky-tester    │
│ + max findings  │     │ security review │     │ UAT + UX + docs │
└─────────────────┘     └─────────────────┘     └─────────────────┘
                                │                         │
                                │                         ▼
                                │               ┌─────────────────┐
                                │               │ Doc issues? ──▶ │
                                │               │ BACK TO WINNY   │
                                │               └─────────────────┘
                                ▼                         │
                        ┌─────────────────┐               │
                        │ chris-architect │◄──────────────┘
                        │ arch alignment  │
                        └─────────────────┘
                                │
                                ▼
                        ┌─────────────────┐
                        │ ALL APPROVE? ──▶│ COMMIT
                        └─────────────────┘

Phase 7: REFINEMENT
┌─────────────────┐     ┌─────────────────┐
│ sergei + winny  │ ──▶ │ Address feedback│ ──▶ COMMIT (each cycle)
│ iterate until   │     │ until satisfied │
│ all satisfied   │     │                 │
└─────────────────┘     └─────────────────┘

Phase 8: INTEGRATION
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│   max-devops    │ ──▶ │ Merge PR        │ ──▶ │ Final cleanup   │
│   engineer      │     │ (squash if req) │     │ & validation    │
└─────────────────┘     └─────────────────┘     └─────────────────┘

Phase 9: EXECUTIVE SUMMARY
┌─────────────────┐     ┌─────────────────┐
│ chris-architect │ ──▶ │ Final report    │ ──▶ USER
│                 │     │ to stakeholder  │
└─────────────────┘     └─────────────────┘
```

---

## ISSUE MANAGEMENT

**Three Main Sources of Issues:**

1. **FEATURE PLANNING Issues**
   - Created by chris-architect during Feature Planning workflow with user
   - Strategic user requirements translated into actionable development tasks
   - Source: User goals → chris-architect analysis → GitHub issues

2. **REVIEW & TESTING Process Issues**
   - Created during Feature Development workflow (Phase 6b-7) when findings require >30min work
   - Discovered by max/patrick/vicky/chris during technical validation and review phases
   - Source: Review findings → GitHub issues (scope creep prevention)

3. **PLAYTEST WORKFLOW Issues** 
   - Created during comprehensive system audit by all agents
   - Defects and improvements discovered through thorough system exploration
   - Source: max/vicky/patrick/chris audit findings → GitHub issues (various severity levels)
   - Generated when all PRs/issues are typically closed (clean slate audit state)

---

## CORE PRINCIPLES

**Quality Manifesto:**
- TDD, SOLID, KISS, SRP, DRY
- MVP Focus: highest quality minimum viable product delivery
- Zero shortcuts, zero cheating, resist feature creep and overengineering
- 100% completion, no placeholders  
- Non-shallow, non-tautological tests
- Computational physics precision

**CODE STANDARDS**
- 88 character limit, 4-space indentation
- Self-documenting code, no commented dead code
- Fortran: `typename_t` convention, empty associate blocks

**WORKFLOW PRINCIPLES**
- **Never start new work when existing work is unfinished**
- max-devops handles repository state, chris-architect decides work priorities
- Finish all PRs before starting new issues

**BATCH RESOLUTION MODES**
- **SINGLE ISSUE (DEFAULT)**: Complete one issue → Executive Summary → STOP
- **BATCH MODE**: When user requests "solve all issues" → Continue until ALL issues resolved
- **NO STOPPING RULE**: In batch mode, MUST persist through all issues without stopping

**COMMIT PROTOCOL** 
- Conventional Commits: `<type>: <description>`
- Imperative mood, no period, <72 chars
- One logical change per commit
- NO EMOJIS, NO ROBOT SIGNATURES - clean, precise commits only

**DEFINITION OF DONE**
- All tests pass with meaningful coverage
- CI green, zero build artifacts
- Documentation updated atomically
- All reviewers approve (zero critical findings, major/minor addressed or filed as issues)

---

## SYSTEM REFERENCES

**Documentation**: [Claude Code Docs](https://docs.anthropic.com/en/docs/claude-code/common-workflows)  
**Configuration**: See `CLAUDE.md` for complete workflow specifications  
**Architecture**: System design patterns in `DESIGN.md`  
**Prompts**: See `PROMPTS.md` for original workflow prompts


---