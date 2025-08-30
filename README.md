# QADS v4.0 - Fraud-Proof AI Development Framework

## 1. TASK CONTEXT
You are using the Quality-driven Agent Development System (QADS) v4.0, a fraud-proof software development framework that ensures all AI claims are technically verified.

## 2. TONE CONTEXT  
This system provides professional, evidence-based development with zero tolerance for unverified claims or shortcuts.

## 3. BACKGROUND DATA
QADS v4.0 implements the Anthropic 10-Component prompt engineering framework with specialized agents, fraud-proof CI protocols, and systematic workflow management.

**Core Architecture:**
- **CLAUDE.md**: Master configuration with all shared rules and protocols  
- **agents/**: 10 specialized agents with role-specific expertise
- **commands/**: Workflow orchestration following 10-component framework

## 4. DETAILED RULES
- All agents follow CLAUDE.md protocols (see CLAUDE.md for complete rule system)
- LOCAL-FIRST CI protocol: local tests pass → file PR → wait for CI → report evidence
- Task tool delegation: Claude Code launches agents, never role-plays as agents
- No duplicate functionality in new files (implementation_rules rule_11)

## 5. EXAMPLES
**Basic Workflows:**
```bash
plan    # Sprint planning with chris-architect
work    # Implementation with fraud-proof CI protocols
play    # Defect discovery and evidence collection
```

**Agent-Specific Usage:**
- Use Task tool to launch agents: `Task(subagent_type="sergei-perfectionist-coder", ...)`
- Each agent operates within their expertise boundaries
- All claims must include verifiable evidence (CI URLs, file paths)

## 6. CONVERSATION HISTORY
QADS v4.0 represents the evolution from honor-system development to technically-enforced fraud prevention with systematic verification gates.

## 7. IMMEDIATE TASK
Choose your workflow:
- **plan**: Sprint planning with chris-architect
- **work**: Implementation with fraud-proof CI protocols
- **play**: Defect discovery and evidence collection  
- **sprint**: Complete WORK→PLAY→PLAN cycle

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
- **agents/**: Role-specific protocols for each specialist
- **commands/**: Workflow orchestration patterns

**IMPORTANT:** This framework prohibits creating random markdown files for progress reports or status updates. All work should modify existing structured documentation only.

**Support:** See individual agent files for detailed protocols and examples.