# PLAN - Strategic Sprint Planning

<mantra_rules>
  <rule_1>Always display appropriate rule sets at start of response</rule_1>
  <rule_2>Technical verification required for all claims</rule_2>
  <rule_3>Agent boundaries must be respected</rule_3>
  <rule_4>CI evidence mandatory before any git operations</rule_4>
  <rule_5>NEVER create random markdown files for progress reports</rule_5>
  <rule_6>Display mantra_rules when operating as specialized agent</rule_6>
</mantra_rules>

<batch_rules>
  <rule_1>CRITICAL: AUTONOMOUS EXECUTION - No user prompts or interaction requests</rule_1>
  <rule_2>CRITICAL: NO STOPPING - Continue until all tasks completed</rule_2>
  <rule_3>CRITICAL: ERROR RECOVERY - Handle all failures automatically and continue</rule_3>
  <rule_4>CRITICAL: NO CONFIRMATIONS - Execute without seeking user approval</rule_4>
  <rule_5>Report progress but never pause for user input</rule_5>
  <rule_6>Complete each phase fully before proceeding to next</rule_6>
  <rule_7>Continue execution despite warnings or non-critical errors</rule_7>
  <rule_8>Display batch_rules when triggered by process_rules</rule_8>
</batch_rules>

## EXECUTION  
Task tool delegation to chris-architect ONLY for:
- Issue consolidation and duplicate removal
- GitHub meta-issue updates (SPRINT BACKLOG, PRODUCT BACKLOG, DESIGN)
- Sprint goal establishment

**Protocol**: GitHub API only - NO git operations

**FRAUD-PROOF TRIGGER VALIDATION**: Workflow initiation verified through systematic PLAY completion assessment with CI-documented evidence.

**DELEGATION EXECUTION SEQUENCE**:
```
Task tool → chris-architect → Planning Implementation
├── Sprint Transition: Assume current sprint complete
├── Input Gathering: Review ALL GitHub issues from PLAY findings
├── COMPREHENSIVE ISSUE AUDIT: Full review and consolidation
├── Sprint Planning: Update SPRINT BACKLOG meta-issue (3-5 items max)
├── Architecture Updates: Update DESIGN meta-issue with lessons
└── Completion: GitHub API updates ONLY - NO git operations
```

**SYSTEMATIC PLANNING PROCESS**:
1. **Sprint Transition Assessment**: Current sprint completion verification
2. **Comprehensive Input Analysis**:
   - ALL open GitHub issues from PLAY findings via GitHub API
   - SPRINT BACKLOG meta-issue EPICS and priorities assessment  
   - DESIGN meta-issue architectural context integration
   - User requirements incorporation (if provided)
3. **MANDATORY ISSUE AUDIT AND CONSOLIDATION**:
   - Full review of existing open issues using `gh issue list --state open --limit 500`
   - Relevance assessment and obsolete issue closure/archival
   - Non-actionable issue elimination (workflow reminders, process docs)
   - Systematic duplicate detection and consolidation protocols
   - Priority reassessment based on architectural impact analysis
   - Actionable defect retention only (specific bugs, broken functionality)
   - Implementation guidance enhancement for clarity and precision
4. **Streamlined Sprint Planning**:
   - SPRINT BACKLOG meta-issue cleanup: Remove DONE entries
   - SPRINT_BACKLOG section rewrite with precise issues under EPICs (3-5 max)
   - Defect fixes balanced with new requirements
   - Clear sprint goal and Definition of Done establishment
5. **Architecture Documentation Updates**:
   - DESIGN meta-issue updates with lessons learned documentation
   - Architectural decision documentation for next sprint planning
   - Integration pattern planning and technical approach documentation
   - Documentation task addition to SPRINT BACKLOG meta-issue as notes
6. **GitHub API Completion**: Meta-issue updates via descriptions - **NO GIT OPERATIONS**

# 4. OWNERSHIP AND BOUNDARIES

**EXCLUSIVE CHRIS-ARCHITECT AUTHORITY**:
- GitHub meta-issue management through API-only access
- Issue consolidation and prioritization with systematic audit protocols
- Sprint goal definition with evidence-based validation systems
- Architectural decision documentation with CI integration protocols

**META-ISSUE UPDATE AUTHORITY**: EXCLUSIVE chris-architect - GitHub meta-issues ONLY
**PROTOCOL**: GitHub API issue description updates EXCLUSIVELY
**RESTRICTION**: NO CODE CHANGES - meta-issue management exclusively

**FORBIDDEN OPERATIONS**:
- Git operations (add, commit, push) - GitHub API operations only
- Code implementation activities - planning phase exclusively
- File system modifications - issue management exclusively

**DELEGATION BOUNDARIES**:
- Task tool usage for chris-architect delegation - NO role-playing behavior
- GitHub API operations exclusively through chris-architect protocols
- Meta-issue management authority limited to chris-architect exclusively

# 5. IMPLEMENTATION STANDARDS

**META-ISSUE MANAGEMENT STANDARDS**:
- SPRINT BACKLOG: <1000 lines maximum, concise issue organization protocols
- PRODUCT BACKLOG: <1000 lines maximum, feature prioritization systems
- DESIGN: <1000 lines maximum, architectural documentation standards
- Issue hygiene protocols: NO emojis, precise technical language requirements

**CI INTEGRATION REQUIREMENTS**:
- Planning validation through CI-integrated analysis tools
- Meta-issue consistency verification through automated checking systems
- Issue priority validation through technical evidence analysis
- Architectural decision validation through CI integration protocols

**QUALITY ENFORCEMENT MECHANISMS**:
- Automated issue quality assessment through systematic analysis
- Duplicate detection systems with consolidation protocols
- Priority validation through measurable criteria systems
- Technical evidence requirements for all planning decisions

# 6. QUALITY GATES

**PLANNING QUALITY STANDARDS**:
- Issue count <50 (hard limit 100) through systematic management
- Zero duplicate issues via comprehensive detection systems
- Technical evidence for all issue priorities through verification protocols
- Architectural decisions with CI validation integration

**SUCCESS VALIDATION CRITERIA**:
- Sprint goal clarity through Definition of Done establishment
- Issue consolidation completeness through systematic duplicate elimination
- Meta-issue consistency through cross-reference validation protocols
- Planning evidence documentation through GitHub API verification

**BLOCKING CONDITIONS**:
- Issue count exceeding limits triggers consolidation requirements
- Missing technical evidence blocks priority assignment protocols
- Architectural inconsistencies require resolution before completion
- Meta-issue validation failures trigger systematic correction requirements

# 7. VALIDATION PROCEDURES

## Success Criteria Verification
- **Sprint Goal Definition**: Clear goal and Definition of Done establishment with GitHub meta-issue documentation
- **Issue Consolidation Completion**: All PLAY issues consolidated and prioritized with systematic duplicate detection
- **SPRINT BACKLOG Update**: Next sprint structure with GitHub API update validation
- **DESIGN Meta-Issue Updates**: Architectural lessons learned with CI integration documentation
- **GitHub API Operations**: Meta-issue descriptions updated exclusively via API with operation logs
- **Autonomous Workflow Completion**: Complete execution without manual intervention with validation documentation

**EVIDENCE REQUIREMENTS**:
- GitHub meta-issue documentation with technical validation protocols
- Systematic duplicate detection and merge documentation
- GitHub API update logs with issue cross-reference verification
- Architectural decision documentation with CI integration evidence
- API operation logs confirming NO git operations performed
- Automated execution documentation with systematic validation protocols

**VALIDATION PROTOCOL EXECUTION**:
1. **Planning Decision Verification**: All sprint priorities validated through technical evidence
2. **Issue Management Validation**: Consolidation completeness through systematic audit
3. **Meta-Issue Consistency Checking**: Cross-reference validation between all meta-issues
4. **GitHub API Operation Verification**: Exclusive API usage confirmation with logging

# 8. TESTING FRAMEWORK

**PLANNING TESTING REQUIREMENTS**:
- **AUTOMATED ISSUE ANALYSIS**: Issue state validation through GitHub API with systematic audit
- **DUPLICATE DETECTION TESTING**: Automated duplicate identification through comparative analysis
- **PRIORITY VALIDATION TESTING**: Sprint priority decisions verified through technical evidence
- **META-ISSUE CONSISTENCY TESTING**: Cross-reference validation between meta-issues and regular issues

**TESTING VERIFICATION PROTOCOL**:
1. **ISSUE AUDIT VALIDATION**: Issue consolidation verification through systematic GitHub API analysis
2. **PRIORITY DECISION TESTING**: Sprint priority validation through technical evidence verification
3. **META-ISSUE SYNCHRONIZATION**: Consistency testing between meta-issues and regular issues
4. **WORKFLOW COMPLETION VERIFICATION**: Planning completion validation through systematic documentation

**CI-INTEGRATED TESTING SYSTEMS**:
- Planning decision validation through CI-integrated analysis tools
- Issue management verification through automated testing protocols
- Meta-issue consistency validation through systematic checking systems
- Workflow completion verification through CI-integrated validation

# 9. PLANNING PRINCIPLES

**EVIDENCE-BASED PLANNING PRINCIPLES**:
- **SYSTEMATIC ISSUE MANAGEMENT**: All decisions backed by verifiable GitHub issue analysis
- **AUTOMATED DUPLICATE PREVENTION**: Issue consolidation through systematic detection protocols
- **TECHNICAL PRIORITY VALIDATION**: Sprint priorities justified through measurable evidence
- **CI-INTEGRATED ARCHITECTURAL DECISIONS**: Design decisions validated through CI integration

**FRAUD-PROOF PLANNING STANDARDS**:
- **ZERO TRUST VERIFICATION**: All planning claims validated through independent technical systems
- **AUTOMATED QUALITY GATES**: Planning standards enforced through technical automation exclusively
- **SYSTEMATIC EVIDENCE REQUIREMENTS**: All decisions backed by verifiable technical documentation
- **CONTINUOUS VALIDATION**: Real-time planning quality monitoring through CI-integrated systems

**DELEGATION CLARITY PRINCIPLES**:
- Task tool delegation to chris-architect exclusively - NO role-playing patterns
- Clear authority boundaries with systematic enforcement protocols
- GitHub API operations exclusively through designated agent protocols
- Evidence-based validation through systematic technical verification

# 10. SUCCESS METRICS

## Empty State Protocol
If no open issues AND no user requirements:
- **Report**: "Sprint review complete. All defects resolved. Awaiting new requirements."
- **Evidence**: GitHub API issue count verification with systematic validation
- **Action**: NO feature invention without user requirements with documentation
- **Completion**: STOP workflow execution with documented termination and systematic validation

## MANDATORY REPORTING

**COMPLETED**: [Sprint planned, issues consolidated, goals defined] - **Planning Evidence**: [GitHub API logs and meta-issue validation results with CI integration documentation]

**OPEN ITEMS**: [Unresolved dependencies, planning blockers] - **Issue Evidence**: [Specific GitHub issues with technical validation and systematic analysis]

**LESSONS LEARNED**: [Planning insights and QADS improvements] - **Metrics**: [Issue management efficiency and consolidation improvements with systematic validation and CI enhancement]

**FRAUD-PROOF VALIDATION**: [All planning claims verified through technical evidence] - **Verification Evidence**: [CI integration logs, GitHub API operation documentation, systematic validation results]