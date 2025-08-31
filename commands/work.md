# WORK WORKFLOW - Sprint Implementation

## 1. TASK CONTEXT: Command Purpose

**PRIMARY FUNCTION**: Sprint implementation with fraud-proof validation through systematic CI integration and evidence-based development practices.

**BATCH MODE EXECUTION**
- Autonomous execution - no user interaction required
- Complete all SPRINT BACKLOG items sequentially
- Follow CLAUDE.md fraud-proof protocols throughout

**PREREQUISITES**: Apply all CLAUDE.md rule sets: operation_rules, repository_rules, implementation_rules, workflow_rules, agent_rules

**CORE EXECUTION**: Complete SPRINT BACKLOG items through max → implementer → reviewer → max workflow with mandatory CI validation.

### WORK COMMAND PROTOCOL
<work_command_rules>
  <rule_1>Apply all CLAUDE.md rule sets at start of execution</rule_1>
  <rule_2>max-devops assessment ALWAYS first</rule_2>
  <rule_3>CI gates cannot be bypassed</rule_3>
  <rule_4>All implementations require reviewer approval</rule_4>
  <rule_5>NEVER create random markdown files for progress reports</rule_5>
  <rule_6>Display work_command_rules when executing WORK workflow</rule_6>
  <rule_7>CRITICAL: Display batch_rules for autonomous execution</rule_7>
</work_command_rules>

### BATCH EXECUTION MANTRA
<batch_execution_mantra>
  <mantra_1>WORK BATCH MODE: NO USER PROMPTS, NO CONFIRMATIONS, NO STOPPING</mantra_1>
  <mantra_2>AUTONOMOUS EXECUTION: Process all SPRINT_BACKLOG items without pause</mantra_2>
  <mantra_3>ERROR RECOVERY: Handle CI failures and conflicts automatically</mantra_3>
  <mantra_4>CONTINUOUS FLOW: max → implementer → reviewer → max without interruption</mantra_4>
</batch_execution_mantra>

## 2. TONE CONTEXT: Command Style

**SYSTEMATIC AND EVIDENCE-BASED**
- All implementation progress verified through CI execution
- Independent validation at each workflow step
- Structured handbacks with technical evidence
- No bypassing of quality gates

## 3. BACKGROUND DATA: Verification Requirements

**FRAUD-PROOF IMPLEMENTATION VALIDATION**
- **ZERO TRUST CLAIMS**: All development progress verified through CI execution
- **AUTOMATED GATES**: Code quality enforced through CI-integrated testing
- **MANDATORY CI VALIDATION**: Every step backed by verifiable CI execution
- **INDEPENDENT REVIEW**: All changes validated through independent review

## 4. DETAILED TASK DESCRIPTION: Execution Protocols

## Workflow Trigger
Execute when issues exist in SPRINT BACKLOG meta-issue or current branch work exists.

**FRAUD-PROOF TRIGGER VALIDATION**: Workflow initiation verified through systematic SPRINT BACKLOG assessment with documented evidence.

## Execution Protocol
**Agents**: max → (sergei OR winny) → CI-GATE → (patrick OR vicky) → max

**Implementation Sequence**:
1. **max**: Repository assessment per Max Protocol in agents/max-devops-engineer.md
2. **Implementation**: 
   - Code: sergei per Sergei Protocol in agents/sergei-perfectionist-coder.md
   - Docs: winny per agents/winny-technical-writer.md
3. **CI Gate**: Automated verification blocks PR if tests fail (see verification_rules in CLAUDE.md)
4. **Review**: 
   - Code: patrick per agents/patrick-auditor.md
   - Docs: vicky per agents/vicky-acceptance-tester.md
5. **max**: Final merge per Max Protocol, only if CI passes

**Loop**: Process all SPRINT_BACKLOG items until empty

**User Integration**: Incorporate ad-hoc tasks and implementation hints from initial prompt

# 4. OWNERSHIP AND BOUNDARIES

**AGENT RESPONSIBILITIES**:
- **max-devops**: Repository state management, CI validation, final merge
- **sergei-perfectionist**: Code implementation with CI verification
- **winny-technical-writer**: Documentation implementation with testing
- **patrick-auditor**: Code quality review with independent verification
- **vicky-acceptance-tester**: Documentation review and user testing

**CRITICAL BOUNDARIES**:
- No agent may bypass CI requirements
- All implementations must pass automated testing
- Independent review required before merge

# 5. IMPLEMENTATION STANDARDS

**CODE QUALITY STANDARDS**:
- CORRECTNESS > PERFORMANCE > KISS > SRP > YAGNI > DRY > SOLID > SECURITY
- Files <1000 lines (target <500), Functions <100 lines (target <50)
- 88 character line limit, 4-space indentation
- Self-documenting code with meaningful names

**CI INTEGRATION REQUIREMENTS**:
- All code changes verified through CI execution
- Test coverage maintained through automated testing
- Build success verified through CI validation
- Performance regression monitored through CI benchmarking

# 6. QUALITY GATES

## Success Criteria
- All SPRINT_BACKLOG items completed and merged - **Evidence**: GitHub issue closure with CI validation logs
- CI passes for all changes - **Evidence**: Comprehensive CI execution results with documented test success
- Clean repository state (no open PRs, no DOING items) - **Evidence**: Repository state verification through automated checking

## Blocking Conditions
- Apply pr_rules, verification_rules, handback_rules from CLAUDE.md
- Ready PRs block new work until merged - **Evidence**: PR status verification with CI completion documentation
- CI failures require structured handback with evidence - **Evidence**: Failed CI logs with systematic problem analysis
- Critical review issues must be resolved before merge - **Evidence**: Review resolution documentation with technical validation

# 7. VALIDATION PROCEDURES

**SYSTEMATIC VALIDATION PROTOCOL**:
1. **SPRINT BACKLOG VALIDATION**: Verify all items addressed through systematic GitHub issue analysis
2. **CI EXECUTION VERIFICATION**: Validate all implementation through comprehensive CI testing
3. **REVIEW COMPLETION CONFIRMATION**: Ensure all code changes reviewed with documented evidence
4. **REPOSITORY STATE VERIFICATION**: Confirm clean state through automated checking

**QUALITY ASSURANCE GATES**:
- **IMPLEMENTATION COMPLETENESS**: All SPRINT BACKLOG items verified complete through GitHub API
- **CI SUCCESS VALIDATION**: All changes verified through successful CI execution
- **REVIEW APPROVAL CONFIRMATION**: All PRs approved through systematic review process
- **REPOSITORY HYGIENE VERIFICATION**: Clean state confirmed through automated repository checking

# 8. TESTING FRAMEWORK

**WORK TESTING REQUIREMENTS**:
- **AUTOMATED CI INTEGRATION**: All implementation verified through CI-integrated testing frameworks
- **COMPREHENSIVE TEST COVERAGE**: Code coverage validated through CI-integrated coverage analysis
- **SYSTEMATIC REGRESSION TESTING**: All changes tested for regression through CI automation
- **PERFORMANCE IMPACT MONITORING**: Implementation performance monitored through CI benchmarking

**TESTING VERIFICATION PROTOCOL**:
1. **PRE-WORK BASELINE TESTING**: Establish system baseline through comprehensive CI testing
2. **IMPLEMENTATION TESTING VALIDATION**: Verify all code changes through CI-integrated testing
3. **REVIEW TESTING CONFIRMATION**: Validate review completeness through systematic testing verification
4. **POST-MERGE VALIDATION TESTING**: Confirm merge success through comprehensive CI testing

# 9. IMPLEMENTATION PRINCIPLES

**EVIDENCE-BASED IMPLEMENTATION PRINCIPLES**:
- **SYSTEMATIC CI INTEGRATION**: All development backed by comprehensive CI validation
- **AUTOMATED QUALITY ENFORCEMENT**: Code quality maintained through CI-integrated tools
- **INDEPENDENT REVIEW VALIDATION**: All changes verified through systematic review processes
- **COMPREHENSIVE TESTING COVERAGE**: Implementation quality assured through extensive automated testing

**FRAUD-PROOF DEVELOPMENT STANDARDS**:
- **ZERO TRUST IMPLEMENTATION**: All development claims verified through independent CI execution
- **AUTOMATED GATES ENFORCEMENT**: Quality standards enforced through technical automation, not human judgment
- **SYSTEMATIC REVIEW PROCESSES**: Code quality validated through comprehensive review with documented evidence
- **CONTINUOUS VALIDATION**: Real-time quality monitoring through CI integration and automated checking

# 10. SUCCESS METRICS

## MANDATORY REPORTING

**COMPLETED**: [SPRINT BACKLOG items implemented, CI validation passed, repository clean] - **Implementation Evidence**: [CI execution URLs and comprehensive test results]
**OPEN ITEMS**: [Remaining implementation tasks, CI failures, review blockers] - **Technical Evidence**: [Specific failures with CI logs and systematic analysis]
**LESSONS LEARNED**: [Implementation insights and QADS improvements] - **Quality Metrics**: [Code quality improvements and CI validation enhancement with documented evidence]