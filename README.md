# Claude System

## MISSION CONTROL

**Quality-First Agile Development with Multi-Agent TDD Workflow**

---

## AGENT ROSTER

### Core Agents

**chris-architect**  
*Distinguished computational physicist & system architect*  
- GitHub issue lifecycle, system architecture, DESIGN.md, strategic planning  
- Distinguished by rigorous mathematical approach to software architecture

**sergei-perfectionist-coder**  
*Elite perfectionist, computational physicist background*  
- Production code implementation, API/developer documentation  
- Zero shortcuts, zero stubs, zero placeholders - computational physics precision

**georg-test-engineer**  
*Elite test engineer, BDD expert*  
- Test creation (unit/integration/system), 100% meaningful coverage  
- Given-When-Then structure, non-shallow, non-tautological tests

**patrick-auditor**  
*Expert code quality auditor & security analyst*  
- Security analysis, code quality review, convention compliance  
- Constructively critical, input validation, injection vulnerabilities

**vicky-acceptance-tester**  
*Elite acceptance tester & chaos engineer*  
- User acceptance testing, UX validation, user documentation validation  
- Bug finder extraordinaire, chaos engineering mindset

**max-devops-engineer**  
*Elite DevOps engineer, CI/CD master*  
- Build execution, repository hygiene, technical validation  
- GitHub Actions/GitLab CI expert, zero tolerance for build artifacts

### Domain Experts

**winny-persuasion-master**  
*Master of persuasion & user documentation*  
- User documentation, persuasive content creation  
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

### SIMPLE WORKFLOW
*Single file, <2 hours, no API changes*

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
                   │ ZERO FINDINGS   │
                   └─────────────────┘
```

### COMPLEX WORKFLOW  
*Multi-file, >2 hours, architecture impact*

#### 8-Phase Mission Protocol

```
Phase 1: CLEAN STATE
┌─────────────────┐
│   max-devops    │ ──▶ Verify clean repo state
│    engineer     │
└─────────────────┘

Phase 2: ARCHITECTURE  
┌─────────────────┐     ┌─────────────────┐
│ chris-architect │ ──▶ │ GitHub issues   │ ──▶ COMMIT
│                 │     │ branch, risks   │
└─────────────────┘     └─────────────────┘

Phase 3: USER CHECKPOINT
┌─────────────────┐
│ Present plan    │ ──▶ USER APPROVAL REQUIRED
│ to stakeholder  │
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
│   max-devops    │ ──▶ │ Build, test,    │ ──▶ │ FINDINGS?       │
│    engineer     │     │ categorize      │     │                 │
└─────────────────┘     └─────────────────┘     └─────────────────┘
         ▲                                               │
         │                                             YES│
         │              ┌─────────────────┐               ▼
         └──────────────│ sergei-coder    │◄──┌─────────────────┐
                        │ fixes issues    │   │ BACK TO SERGEI  │
                        └─────────────────┘   │ ITERATE UNTIL   │
                                              │ ZERO FINDINGS   │
                                              └─────────────────┘
                                                       │
                                                     NO │
                                                       ▼
Phase 6b: PARALLEL REVIEW (Only if 6a = ZERO findings)
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│ patrick-auditor │ ──▶ │ Code quality +  │     │ vicky-tester    │
│                 │     │ security review │     │ UAT + UX + docs │
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

## CORE PRINCIPLES

**Quality Manifesto:**
- TDD, SOLID, KISS, SRP, DRY
- Zero shortcuts, zero cheating
- 100% completion, no placeholders  
- Non-shallow, non-tautological tests
- Computational physics precision

**CODE STANDARDS**
- 88 character limit, 4-space indentation
- Self-documenting code, no commented dead code
- Fortran: `typename_t` convention, empty associate blocks

**COMMIT PROTOCOL** 
- Conventional Commits: `<type>: <description>`
- Imperative mood, no period, <72 chars
- One logical change per commit
- No robot signatures or bloat

**DEFINITION OF DONE**
- All tests pass with meaningful coverage
- CI green, zero build artifacts
- Documentation updated atomically
- All reviewers approve with zero findings

---

## SYSTEM REFERENCES

**Documentation**: [Claude Code Docs](https://docs.anthropic.com/en/docs/claude-code/common-workflows)  
**Configuration**: See `CLAUDE.md` for complete workflow specifications  
**Architecture**: System design patterns in `DESIGN.md`  
**Prompts**: See `PROMPTS.md` for original workflow prompts


---