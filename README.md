# AI Development Framework v4.0

## 1. TASK CONTEXT
You are using version 4.0 of this software development framework, which ensures all AI claims are technically verified.

## 2. TONE CONTEXT  
This system provides professional, evidence-based development with zero tolerance for unverified claims or shortcuts.
No time pressure by default: take the time needed to solve tasks fully and
cleanly, provided scope does not expand (no feature/scope creep).

## 3. BACKGROUND DATA
This release implements a ten-component prompt engineering framework with specialized agents, rigorous CI protocols, and systematic workflow management.

**Core Architecture:**
- **CLAUDE.md**: Master configuration with all shared rules and protocols  
- **AGENTS.md**: Lean simplicity-first standards applied across repositories
- **agents/**: 10 specialized agents with role-specific expertise
- **commands/**: Workflow orchestration following 10-component framework
- **Modular Workflows**: PLAN, WORK, and PLAY phases keep responsibilities isolated to maintain separation of concerns, uphold the single responsibility principle, and keep inter-agent coupling intentionally weak

## 4. DETAILED RULES
- All agents follow CLAUDE.md protocols (see CLAUDE.md for complete rule system)
- Architectural changes must respect separation of concerns: each artifact owns one behavior, cross-phase data contracts stay lean, and integrations remain weakly coupled
- LOCAL-FIRST CI protocol: local tests pass → file PR → watch PR checks (`gh pr checks --watch`) → report evidence
- Task tool delegation: Claude Code launches agents, never role-plays as agents
- Boy Scout Principle: every touchpoint must leave the repository cleaner by fixing or improving nearby issues rather than stepping over them
- No duplicate functionality in new files (implementation_rules rule_11)

## 5. EXAMPLES
**Basic Workflows:**
```bash
plan    # Sprint planning with chris-architect
work    # Implementation with CI verification protocols
play    # Defect discovery and evidence collection
do      # Run a single focused task using the framework
sprint  # Execute WORK→PLAY→PLAN cycle end-to-end
multisprint # Run repeated sprint cycles
```

**Agent-Specific Usage:**
- Use Task tool to launch agents: `Task(subagent_type="sergei-perfectionist-coder", ...)`
- Each agent operates within their expertise boundaries
- All claims must include verifiable evidence (CI URLs, file paths)

## 6. CONVERSATION HISTORY
This framework represents the evolution from honor-system development to technically enforced verification with systematic quality gates.

## 7. IMMEDIATE TASK
Choose your workflow:
- **plan**: Sprint planning with chris-architect
- **work**: Implementation with CI verification protocols
- **play**: Defect discovery and evidence collection  
- **sprint**: Complete WORK→PLAY→PLAN cycle

## 7.1 Runtime & Automation
- Tools: Codex CLI and Claude Code are both supported.
- Autonomous orchestrator: `scripts/issue_orchestrate_auto.sh`
  - Toggle Claude Code via env: `CLAUDE_CODE=1`
  - Uses the same framework prompts and agents defined in this repo
  - Non-interactive batch execution with CI gate awareness

## 8. THINKING STEP-BY-STEP
Before any operation:
1. Check current repository state
2. Classify operation type (see operation_rules in CLAUDE.md)
3. Apply appropriate rule sets
4. Ensure evidence collection mechanisms ready
5. Execute with systematic verification

## 9. OUTPUT FORMATTING
All operations produce structured reports with:
- Technical verification evidence
- CI URLs where applicable
- File paths (absolute)
- Completion status with proof

## 10. GETTING STARTED
```bash
# 1. Review the master configuration
cat CLAUDE.md

# 2. Start with planning
plan

# 3. Implement with evidence-based development
work

# 4. Review and discover defects
play
```

**Key Files:**
- **CLAUDE.md**: Complete rule system and 10-component framework
- **AGENTS.md**: System-wide lean simplicity-first engineering standards
- **agents/**: Role-specific protocols for each specialist
- **commands/**: Workflow orchestration patterns

## Language & Stack Policy
- **Existing projects**: Always use the repo's established language, tooling, and style. Consistency trumps preference.
- **Simplicity first**: Prefer the simplest tool that solves the problem.
- **Language selection** (for new projects):
  - Shell over Python for file ops, text processing (grep/sed/awk), simple automation
  - Go over Python for CLI tools, services, concurrent workloads, single-binary deployment
  - C over C++ unless C++ features (RAII, templates, containers) provide clear advantage
  - Fortran for numerics/HPC; expose to Python via f90wrap when needed
- **Tool selection**: Make over CMake when sufficient, SQLite over PostgreSQL for local storage, curl over HTTP libs for simple requests, standard library over external deps.
- Explicit user requests always take precedence.

**IMPORTANT:** This framework prohibits creating random markdown files for progress reports or status updates. All work should modify existing structured documentation only.

**Support:** See individual agent files for detailed protocols and examples.
