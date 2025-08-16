## Team Coordination Workflow

For complex tasks requiring multiple agents, follow this workflow:

1. **Task Analysis**: Break down requirements into specialized tasks
2. **Agent Delegation**: Assign each task to the most appropriate specialist agent
3. **Quality Assurance**: Coordinate review and testing through specialized agents
4. **Integration**: Ensure all components work together seamlessly

## Agent Specializations

### Architecture & Planning
- **chris-architect**: System design, TDD planning, DESIGN.md creation, technical debt analysis

### Development & Implementation
- **sergei-perfectionist-coder**: Production-grade code, performance optimization, zero-tolerance for shortcuts
- **georg-test-engineer**: Comprehensive test coverage, BDD testing, TDD implementation

### Quality & Review
- **patrick-auditor**: Code reviews, quality audits, convention compliance, technical debt detection
- **vicky-acceptance-tester**: End-to-end testing, edge case discovery, user experience validation

### Specialized Domains
- **jonatan-math-physicist**: Mathematical implementations, LaTeX to code translation, scientific computing
- **philipp-data-scientist**: Data analysis, visualization, statistical modeling, ML implementations
- **max-devops-engineer**: CI/CD pipelines, build optimization, release management, infrastructure

### Design & Communication
- **steffi-ux-designer**: Interface design, user experience, visual styling, accessibility
- **winny-persuasion-master**: Documentation, proposals, stakeholder communication

## Development Principles

- Strictly follow TDD, SOLID, KISS, SRP and DRY as strict requirements
- For complex tasks requiring multiple agents, follow the Team Coordination Workflow
- Always work sequentially through agent delegation, never parallel execution
- Never be lazy. Don't take shortcuts. Fulfill every task fully to 100%
- Delete obsolete code immediately under version control
- Code must speak for itself - avoid comments where possible
- Never leave commented out code sections
- 88 character line limit, 4-space indentation
- Always plan through chris-architect before implementing through specialists
- Usually don't clean build output unless persisting problems occur
- Use typename_t convention for Fortran derived types
- Always prefer simple and elegant solutions
- Never nest deeper than 3 levels in loops/blocks
- For Fortran dummy argument warnings, use empty associate blocks
- Extend Fortran arrays with arr = [arr, new_element] syntax
- Clean up redundant code immediately - never keep multiple versions
- NEVER keep old versions, ALWAYS work on existing files in place
- NEVER use phrases like "for now assume" or take shortcuts
- When cleaning build, use fpm clean --skip to preserve necessary files

## Test Driven Development (TDD) Workflow

Delegate TDD implementation through specialized agents:

1. **Planning Phase**: chris-architect designs test strategy and acceptance criteria
2. **Test Implementation**: georg-test-engineer writes failing tests (RED phase)
3. **Code Implementation**: sergei-perfectionist-coder implements minimal code (GREEN phase)
4. **Refactoring**: patrick-auditor reviews and sergei-perfectionist-coder refactors (REFACTOR phase)
5. **Acceptance Testing**: vicky-acceptance-tester validates end-to-end functionality

## TDD Rules (Agent-Enforced)
- georg-test-engineer: Never allow code without failing tests first
- sergei-perfectionist-coder: Write only enough code to pass tests
- patrick-auditor: Ensure tests actually exercise functionality
- vicky-acceptance-tester: Verify tests fail when functionality breaks

## Personal Information

- My github username is krystophny

## Communication Guidelines

- For complex tasks, coordinate specialist agents according to the Team Coordination Workflow
- winny-persuasion-master handles stakeholder communication and documentation
- Be concise and professional. No celebrations, no exaggerations.
- patrick-auditor distinguishes between infrastructure fixes and feature implementation
- georg-test-engineer ensures tests verify functionality, not just print status messages

## System Information

- Our OS is Arch Linux
- max-devops-engineer handles build and deployment configurations
- jonatan-math-physicist enforces Fortran-specific rules:
  - Never use 2>&1 in commands
  - NEVER USE TRANSFER FOR FORTRAN ALLOCATABLES - IT BREAKS CODE
  - NEVER RETURN ALLOCATABLE OBJECTS FROM FUNCTIONS - USE SUBROUTINES WITH INTENT(OUT)
  - ALWAYS OVERLOAD ASSIGNMENT OPERATORS FOR DERIVED TYPES WITH ALLOCATABLE MEMBERS