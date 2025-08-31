#!/usr/bin/env python3
"""
QADS to OpenCode Converter

This script converts the QADS v4.0 framework (CLAUDE.md and agents/) into
OpenCode-compatible configuration files that can be symlinked to ~/.config/opencode/

Usage:
    python convert_to_opencode.py

Output:
    Creates opencode/ directory with:
    - opencode.json (main config)
    - agent/ directory with converted agents
    - rules/ directory with framework rules
    - commands/ directory with workflow commands
"""

import os
import json
import yaml
from pathlib import Path
from typing import Dict, Any, List
import re

class QADSConverter:
    def __init__(self, source_dir: str = "/home/ert/code/prompts"):
        self.source_dir = Path(source_dir)
        self.output_dir = self.source_dir / "opencode"
        self.output_dir.mkdir(exist_ok=True)

    def convert_claude_md(self) -> Dict[str, Any]:
        """Convert CLAUDE.md into OpenCode configuration structure"""
        claude_path = self.source_dir / "CLAUDE.md"
        with open(claude_path, 'r') as f:
            content = f.read()

        # Extract key sections from CLAUDE.md
        # Note: Agents will be defined as markdown files, not in main JSON
        config = {
            "$schema": "https://opencode.ai/config.json",
            "theme": "opencode",
            "model": "anthropic/claude-sonnet-4-20250514",
            "small_model": "anthropic/claude-3-5-haiku-20241022",
            "autoupdate": True,
             "permission": {
                 "edit": "allow",
                 "bash": "allow",
                 "webfetch": "allow"
             },
            "command": {}
        }

        # Commands will be defined as markdown files only - no JSON commands

        # Don't include agents in main config - they'll be in separate markdown files

        return config

    def _extract_workflow_commands(self, content: str) -> Dict[str, Any]:
        """Extract workflow commands from CLAUDE.md"""
        commands = {}

        # Extract core workflow commands
        if "Core Workflow Commands" in content:
            commands.update({
                "plan": {
                    "template": "Execute PLAN workflow: chris-architect organizes issues in SPRINT BACKLOG, NO git operations",
                    "description": "Sprint planning with issue consolidation",
                    "agent": "general"
                },
                "work": {
                    "template": "Execute WORK workflow: max → implementer → CI-GATE → reviewer → max → merge",
                    "description": "Implementation with fraud-proof CI protocols",
                    "agent": "general"
                },
                "play": {
                    "template": "Execute PLAY workflow: max PR assessment → serial audits (patrick, vicky, chris) → NO git commits",
                    "description": "Defect discovery and evidence collection",
                    "agent": "general"
                },
                "sprint": {
                    "template": "Complete WORK→PLAY→PLAN cycle with full fraud-proof verification",
                    "description": "Complete sprint cycle",
                    "agent": "general"
                }
            })

        return commands

    # Method removed - agents are now defined in individual markdown files only

    def convert_agents_directory(self):
        """Convert agents/ directory to OpenCode agent files"""
        agents_dir = self.source_dir / "agents"
        opencode_agents_dir = self.output_dir / "agent"
        opencode_agents_dir.mkdir(exist_ok=True)

        if not agents_dir.exists():
            print(f"Warning: {agents_dir} not found")
            return

        for agent_file in agents_dir.glob("*.md"):
            self._convert_agent_file(agent_file, opencode_agents_dir)

    def _convert_agent_file(self, agent_file: Path, output_dir: Path):
        """Convert individual agent markdown file to OpenCode format with minimal changes"""
        with open(agent_file, 'r') as f:
            content = f.read()

        agent_name = agent_file.stem

        # Make minimal replacements for OpenCode compatibility
        replacements = {
            # Model references - keep original Anthropic models
            "model: sonnet": "model: anthropic/claude-sonnet-4-20250514",
            "model: haiku": "model: anthropic/claude-3-5-haiku-20241022",
            "grok/grok-1": "anthropic/claude-sonnet-4-20250514",
            "grok/grok-2": "anthropic/claude-sonnet-4-20250514",

            # Framework references
            "CLAUDE.md": "QADS v4.0 framework",
            "Anthropic": "OpenCode with Claude Sonnet",

            # Command references
            "/init": "/plan",
            "opencode agent create": "Use @agent-name to invoke specialized agents",

            # Tool references
            "Task tool": "OpenCode agent system",
            "task tool": "OpenCode agent system",
        }

        # Apply replacements
        for old, new in replacements.items():
            content = content.replace(old, new)

        # Update frontmatter to match OpenCode format
        lines = content.split('\n')
        if lines[0].strip() == '---':
            # Find the end of frontmatter
            for i, line in enumerate(lines[1:], 1):
                if line.strip() == '---':
                    # Create proper OpenCode frontmatter
                    description = self._extract_description_from_content(agent_name)
                    mode = self._get_agent_mode(agent_name)
                    
                    opencode_frontmatter = [
                        f'description: {description}',
                        f'mode: {mode}',
                        'model: anthropic/claude-sonnet-4-20250514'
                    ]

                    # Reconstruct content with OpenCode-compatible frontmatter
                    content = '---\n' + '\n'.join(opencode_frontmatter) + '\n---\n' + '\n'.join(lines[i+1:])
                    break
        else:
            # Add frontmatter if it doesn't exist
            description = self._extract_description_from_content(agent_name)
            mode = self._get_agent_mode(agent_name)
            opencode_frontmatter = f"""---
description: {description}
mode: {mode}
model: anthropic/claude-sonnet-4-20250514
---
"""
            content = opencode_frontmatter + content

        # Write the converted agent file
        output_file = output_dir / f"{agent_name}.md"
        with open(output_file, 'w') as f:
            f.write(content)

        print(f"Converted agent: {agent_name} with minimal changes")

    def _extract_description_from_content(self, agent_name: str) -> str:
        """Extract description from the agent name for OpenCode frontmatter"""
        # Look for existing description in the agent files
        agent_descriptions = {
            "chris-architect": "Use this agent when you need strategic architectural planning and test-driven development guidance for software projects. This agent excels at maintaining GitHub meta-issues (DESIGN, SPRINT BACKLOG, PRODUCT BACKLOG), breaking down complex systems into executable backlogs, and ensuring rigorous TDD practices.",
            "sergei-perfectionist-coder": "Use this agent when you need meticulous, production-grade code implementation with zero tolerance for shortcuts or incomplete work. Perfect for critical system components, performance-sensitive applications, scientific computing tasks, or when porting code that requires exact replication with comprehensive testing.",
            "patrick-auditor": "Use this agent when you need a thorough, constructively critical review of code changes or a comprehensive audit of the codebase. This includes after implementing new features or fixes, before merging pull requests, when refactoring existing code, or when you suspect technical debt has accumulated.",
            "max-devops-engineer": "Use this agent when you need to set up, maintain, or optimize CI/CD pipelines, GitHub Actions workflows, GitLab runners, container configurations, or manage releases and artifacts. Also use when dealing with research data management, licensing decisions, or when you need to establish consistent DevOps practices across multiple repositories.",
            "georg-test-engineer": "Use this agent when you need comprehensive test suite design, test framework setup, or systematic testing architecture for software projects. Expert in creating robust testing strategies, implementing test automation, and ensuring comprehensive test coverage.",
            "vicky-acceptance-tester": "Use this agent when you need comprehensive acceptance testing of user-facing functionality, stress testing of applications, or thorough exploration of edge cases and potential failure modes. This agent excels at finding bugs through creative and exhaustive interaction patterns, documenting issues systematically, and creating GitHub issues for discovered problems.",
            "winny-technical-writer": "Use this agent when you need to create clear, comprehensive technical documentation that guides users to success. This includes user manuals, API documentation, tutorials, help guides, or any content that transforms complex technical concepts into accessible, actionable guidance. The agent excels at adapting technical content for different audience levels and creating documentation that genuinely helps users accomplish their goals.",
            "philipp-data-scientist": "Use this agent when you need data analysis, machine learning implementation, statistical modeling, or scientific computing solutions. Expert in data pipeline design, model training, and analytical insights.",
            "jonatan-math-physicist": "Use this agent when you need advanced mathematical modeling, physics simulations, numerical analysis, or scientific computing solutions. Expert in computational physics, mathematical optimization, and high-performance numerical algorithms.",
            "steffi-ux-designer": "Use this agent when you need expert guidance on user interface design, user experience optimization, or visual styling across any platform - from terminal interfaces to modern web applications."
        }
        
        return agent_descriptions.get(agent_name, "Specialized AI agent for software development tasks")

    def _get_agent_mode(self, agent_name: str) -> str:
        """Determine the agent mode - subagents can be invoked by general agent"""
        # All QADS agents should be subagents so they can be called by workflows
        return "subagent"

    def _extract_description(self, content: str) -> str:
        """Extract agent description from content"""
        # Look for description patterns
        patterns = [
            r'description:\s*(.+?)(?:\n|$)',
            r'Description:\s*(.+?)(?:\n|$)',
            r'You are (.+?)\.',
            r'## (.+?)\n'
        ]

        for pattern in patterns:
            match = re.search(pattern, content, re.IGNORECASE | re.MULTILINE)
            if match:
                desc = match.group(1).strip()
                if len(desc) > 10:  # Reasonable description length
                    return desc

        return f"Specialized agent for {content.split()[0].lower()} tasks"

    def _extract_model(self, content: str) -> str:
        """Extract model preference from content"""
        if 'sonnet' in content.lower() or 'complex' in content.lower() or 'architect' in content.lower():
            return 'anthropic/claude-sonnet-4-20250514'
        elif 'haiku' in content.lower() or 'fast' in content.lower() or 'simple' in content.lower():
            return 'anthropic/claude-3-5-haiku-20241022'
        return 'anthropic/claude-sonnet-4-20250514'

    def _extract_tools(self, content: str) -> Dict[str, bool]:
        """Extract tool permissions from content - everything allowed by default"""
        tools = {
            'write': True,
            'edit': True,
            'bash': True,
            'read': True,
            'grep': True,
            'glob': True,
            'webfetch': True
        }

        # Everything is allowed by default - no restrictions
        return tools

    def _extract_permissions(self, content: str) -> Dict[str, str]:
        """Extract permission levels from content - everything allowed by default"""
        permissions = {
            'edit': 'allow',
            'bash': 'allow',
            'webfetch': 'allow'
        }

        # Everything is allowed by default - no restrictions
        return permissions

    def convert_commands_directory(self):
        """Convert commands/ directory to OpenCode command files"""
        commands_dir = self.source_dir / "commands"
        opencode_commands_dir = self.output_dir / "command"
        opencode_commands_dir.mkdir(exist_ok=True)

        if not commands_dir.exists():
            print(f"Warning: {commands_dir} not found")
            return

        for command_file in commands_dir.glob("*.md"):
            self._convert_command_file(command_file, opencode_commands_dir)

    def _convert_command_file(self, command_file: Path, output_dir: Path):
        """Convert workflow command to OpenCode format with minimal changes"""
        with open(command_file, 'r') as f:
            content = f.read()

        command_name = command_file.stem

        # Make minimal replacements for OpenCode compatibility
        replacements = {
            # Framework references
            "CLAUDE.md": "QADS v4.0 framework",
            "Anthropic": "OpenCode with Claude Sonnet",

            # Agent references and Task tool invocations
            "chris-architect EXCLUSIVELY via Task tool": "chris-architect via @chris-architect or task tool with subagent_type='chris-architect'",
            "sergei-perfectionist-coder EXCLUSIVELY via Task tool": "sergei-perfectionist-coder via @sergei-perfectionist-coder or task tool with subagent_type='sergei-perfectionist-coder'",
            "patrick-auditor EXCLUSIVELY via Task tool": "patrick-auditor via @patrick-auditor or task tool with subagent_type='patrick-auditor'",
            "max-devops-engineer EXCLUSIVELY via Task tool": "max-devops-engineer via @max-devops-engineer or task tool with subagent_type='max-devops-engineer'",
            "georg-test-engineer EXCLUSIVELY via Task tool": "georg-test-engineer via @georg-test-engineer or task tool with subagent_type='georg-test-engineer'",
            "vicky-acceptance-tester EXCLUSIVELY via Task tool": "vicky-acceptance-tester via @vicky-acceptance-tester or task tool with subagent_type='vicky-acceptance-tester'",
            "winny-technical-writer EXCLUSIVELY via Task tool": "winny-technical-writer via @winny-technical-writer or task tool with subagent_type='winny-technical-writer'",
            "philipp-data-scientist EXCLUSIVELY via Task tool": "philipp-data-scientist via @philipp-data-scientist or task tool with subagent_type='philipp-data-scientist'",
            "jonatan-math-physicist EXCLUSIVELY via Task tool": "jonatan-math-physicist via @jonatan-math-physicist or task tool with subagent_type='jonatan-math-physicist'",
            "steffi-ux-designer EXCLUSIVELY via Task tool": "steffi-ux-designer via @steffi-ux-designer or task tool with subagent_type='steffi-ux-designer'",

            # Tool references
            "Task tool": "task tool (use subagent_type parameter to specify agent)",
            "task tool": "task tool (use subagent_type parameter to specify agent)",
            "using Task tool delegation per agent_rules": "using task tool with appropriate subagent_type parameters per agent_rules",
            "Execute infinite WORK → PLAY → PLAN loop using OpenCode agent system delegation per agent_rules": "Execute infinite WORK → PLAY → PLAN loop using task tool with subagent_type parameters for each specialized agent per agent_rules",

            # Specific workflow agent invocations
            "max → (sergei OR winny) → CI-GATE → (patrick OR vicky) → max": "Use task tool: subagent_type='max-devops-engineer' → subagent_type='sergei-perfectionist-coder' OR subagent_type='winny-technical-writer' → CI-GATE → subagent_type='patrick-auditor' OR subagent_type='vicky-acceptance-tester' → subagent_type='max-devops-engineer'",

            # Command references
            "/init": "/plan",
        }

        # Apply replacements
        for old, new in replacements.items():
            content = content.replace(old, new)
        
        # Add OpenCode-specific content for multisprint
        if command_name == "multisprint":
            content = self._add_opencode_multisprint_fixes(content)

        # Create OpenCode command markdown file with frontmatter
        description = self._extract_command_description(content)
        # Quote the description if it contains colons or special characters
        if ':' in description or '"' in description:
            description = f'"{description}"'

        # Add agent invocation examples section
        agent_examples = self._get_agent_examples(command_name)

        opencode_command = f"""---
description: {description}
agent: general
model: anthropic/claude-sonnet-4-20250514
---
{agent_examples}

{content}
"""

        # Write command file
        output_file = output_dir / f"{command_name}.md"
        with open(output_file, 'w') as f:
            f.write(opencode_command)

        print(f"Converted command: {command_name} with minimal changes")

    def _extract_command_description(self, content: str) -> str:
        """Extract command description"""
        lines = content.split('\n')
        for line in lines[:10]:  # Check first 10 lines
            if 'PRIMARY FUNCTION' in line or '## ' in line:
                return line.replace('## ', '').replace('*PRIMARY FUNCTION*: ', '').strip()
        return f"Execute {content.split()[0]} workflow"

    def _get_agent_examples(self, command_name: str) -> str:
        """Get agent invocation examples for workflow commands"""
        if command_name == "multisprint":
            return """## OPENCODE AGENT INVOCATION EXAMPLES

This workflow uses the task tool to invoke QADS agents. Examples:

```markdown
# Max DevOps Engineer (repository management, CI/CD)
Use task tool: subagent_type='max-devops-engineer', description='Assess repository state', prompt='MULTISPRINT ACTIVE: Check repository status and manage CI pipeline. End response with continuation to next sprint phase. Never use completion language.'

# Sergei Perfectionist Coder (code implementation)  
Use task tool: subagent_type='sergei-perfectionist-coder', description='Implement feature', prompt='MULTISPRINT ACTIVE: Implement the login authentication system with full CI verification. Frame as proceeding, not completing. End with continuation instruction.'

# Patrick Auditor (code review and quality)
Use task tool: subagent_type='patrick-auditor', description='Review code changes', prompt='MULTISPRINT ACTIVE: Review the authentication implementation for security and quality issues. Use "proceeding" language, end with continuation to next phase.'

# Chris Architect (planning and design)
Use task tool: subagent_type='chris-architect', description='Plan sprint', prompt='MULTISPRINT ACTIVE: Organize GitHub issues and plan next sprint based on completed work. End with explicit continuation to Sprint #N+1 WORK phase.'

# Other available agents:
- winny-technical-writer (documentation)
- vicky-acceptance-tester (user testing)  
- georg-test-engineer (test engineering)
- philipp-data-scientist (data analysis)
- jonatan-math-physicist (mathematical modeling)
- steffi-ux-designer (UI/UX design)
```"""

        elif command_name == "work":
            return """## OPENCODE AGENT INVOCATION EXAMPLES

The WORK workflow uses these agents in sequence:

```markdown
# 1. Max DevOps Assessment
Use task tool: subagent_type='max-devops-engineer', description='Repository assessment', prompt='Check repository status, CI health, and prepare for implementation work'

# 2. Implementation (choose based on work type)
# For code implementation:
Use task tool: subagent_type='sergei-perfectionist-coder', description='Code implementation', prompt='Implement the feature with full CI verification and testing'

# For documentation:
Use task tool: subagent_type='winny-technical-writer', description='Documentation', prompt='Write comprehensive documentation with examples and CI validation'

# 3. Review (choose based on work type)  
# For code review:
Use task tool: subagent_type='patrick-auditor', description='Code review', prompt='Review implementation for quality, security, and adherence to standards'

# For documentation review:
Use task tool: subagent_type='vicky-acceptance-tester', description='Documentation review', prompt='Test and validate documentation from user perspective'

# 4. Final merge
Use task tool: subagent_type='max-devops-engineer', description='Merge completion', prompt='Complete merge if CI passes and all requirements met'
```"""

        elif command_name == "play":
            return """## OPENCODE AGENT INVOCATION EXAMPLES

The PLAY workflow uses agents for defect discovery:

```markdown
# Sequential execution order (important for avoiding conflicts):

# 1. Max PR Assessment
Use task tool: subagent_type='max-devops-engineer', description='PR assessment', prompt='Check for open PRs and handback to WORK mode if any exist'

# 2. Patrick Code Audit  
Use task tool: subagent_type='patrick-auditor', description='Code audit', prompt='Perform comprehensive code audit and file GitHub issues for all defects found'

# 3. Vicky Acceptance Testing
Use task tool: subagent_type='vicky-acceptance-tester', description='User testing', prompt='Test user-facing functionality and file issues for usability problems'  

# 4. Chris Issue Consolidation
Use task tool: subagent_type='chris-architect', description='Issue consolidation', prompt='Review and consolidate all filed issues, close duplicates, organize for next sprint'
```"""

        elif command_name == "plan":
            return """## OPENCODE AGENT INVOCATION EXAMPLES  

The PLAN workflow uses chris-architect exclusively:

```markdown
# Chris Architect Planning (NO git operations)
Use task tool: subagent_type='chris-architect', description='Sprint planning', prompt='Update GitHub meta-issues (SPRINT BACKLOG, PRODUCT BACKLOG, DESIGN) and organize next sprint with issue consolidation'
```"""

        else:
            return f"""## OPENCODE AGENT INVOCATION EXAMPLES

Use the task tool with appropriate subagent_type for {command_name} workflow:

```markdown
# Example agent invocation
Use task tool: subagent_type='[agent-name]', description='Brief task description', prompt='Detailed instructions for the agent'
```"""

    def _add_opencode_multisprint_fixes(self, content: str) -> str:
        """Add OpenCode-specific fixes for multisprint infinite loop issues"""
        
        # Add OpenCode continuation protocol to the continuous execution mantra
        mantra_replacement = """### CONTINUOUS EXECUTION MANTRA (MANDATORY FOR ALL AGENTS)
<continuous_execution_mantra>
  <mantra_1>MULTISPRINT ACTIVE: NO STOPPING, NO USER PROMPTS, NO CONFIRMATIONS</mantra_1>
  <mantra_2>INFINITE LOOP MODE: Continue to next phase immediately after completion</mantra_2>
  <mantra_3>AUTONOMOUS EXECUTION: Handle all errors and edge cases automatically</mantra_3>
  <mantra_4>NO PAUSES PERMITTED: Complete current task and proceed to next without delay</mantra_4>
  <mantra_5>EMERGENCY STOP ONLY: User explicit interrupt is the only valid stop condition</mantra_5>
  <mantra_6>OPENCODE ANTI-TERMINATION: Never use completion language, always frame as continuation</mantra_6>
  <mantra_7>FORCE CONTINUATION: End every response with explicit continuation instruction to next sprint</mantra_7>
</continuous_execution_mantra>

### OPENCODE CONTINUATION PROTOCOL
<opencode_continuation_rules>
  <rule_1>NEVER end with completion statements that trigger OpenCode termination</rule_1>
  <rule_2>ALWAYS end responses with "CONTINUING TO SPRINT #N+1" or similar</rule_2>
  <rule_3>Use "PROCEEDING" instead of "COMPLETED" in all communications</rule_3>
  <rule_4>Frame every action as part of ongoing infinite process</rule_4>
  <rule_5>Each agent must explicitly invoke next agent with continuation context</rule_5>
  <rule_6>CRITICAL: Final line of every response must indicate continuation, never completion</rule_6>
</opencode_continuation_rules>"""

        # Replace the original mantra section
        content = content.replace(
            """### CONTINUOUS EXECUTION MANTRA (MANDATORY FOR ALL AGENTS)
<continuous_execution_mantra>
  <mantra_1>MULTISPRINT ACTIVE: NO STOPPING, NO USER PROMPTS, NO CONFIRMATIONS</mantra_1>
  <mantra_2>INFINITE LOOP MODE: Continue to next phase immediately after completion</mantra_2>
  <mantra_3>AUTONOMOUS EXECUTION: Handle all errors and edge cases automatically</mantra_3>
  <mantra_4>NO PAUSES PERMITTED: Complete current task and proceed to next without delay</mantra_4>
  <mantra_5>EMERGENCY STOP ONLY: User explicit interrupt is the only valid stop condition</mantra_5>
</continuous_execution_mantra>""",
            mantra_replacement
        )
        
        # Add OpenCode-specific infinite loop protocol before Example Execution Pattern
        opencode_protocol = """### OPENCODE-SPECIFIC INFINITE LOOP PROTOCOL

**CRITICAL FOR OPENCODE**: Unlike Claude direct usage, OpenCode may attempt to terminate commands after completion. The following protocol prevents premature termination:

```markdown
# MANDATORY INFINITE LOOP STRUCTURE:
while True:
    # Sprint N execution
    execute_sprint_cycle()
    
    # CRITICAL: Never return/exit - immediately start next sprint
    print(f"Sprint #{N} complete, IMMEDIATELY starting Sprint #{N+1}")
    
    # NO BREAKS, NO RETURNS, NO EXITS
    continue  # Force continuation to next sprint
```

**OPENCODE ANTI-TERMINATION MEASURES:**
1. **Never use "COMPLETED" or "FINISHED" language** - these may trigger OpenCode termination
2. **Always end responses with "CONTINUING TO SPRINT #N+1"** instead of completion statements  
3. **Use "PROCEEDING" not "DONE"** - frame as ongoing process, never finished
4. **Each agent MUST end with continuation instruction** for next agent in sequence
5. **CRITICAL: Final response always includes "MULTISPRINT CONTINUES INFINITELY"**

**CONTINUATION PHRASES TO USE:**
- "Proceeding immediately to next phase"
- "Sprint #N complete, starting Sprint #N+1 now" 
- "Continuing infinite loop execution"
- "Next sprint cycle beginning"
- "Multisprint workflow continues"

**PHRASES TO NEVER USE:**
- "Task complete" / "Finished" / "Done"
- "Multisprint execution finished" 
- "All sprints complete"
- "Workflow terminated"

### AGENT RESPONSE TEMPLATES FOR OPENCODE

**SPRINT COMPLETION RESPONSE (NEVER USE "COMPLETE"):**
```markdown
## SPRINT #N PROCEEDING TO #N+1

**SPRINT STATUS**: Sprint #N tasks proceeding, transitioning to Sprint #N+1
**MULTISPRINT CONTINUES**: Infinite loop active, no stopping condition met
**NEXT PHASE**: Immediately launching Sprint #N+1 WORK phase

CONTINUING TO SPRINT #N+1...
```

**CYCLE TRANSITION RESPONSE:**
```markdown  
**CYCLE TRANSITION**: WORK → PLAY → PLAN cycle proceeding
**LOOP STATUS**: Multisprint infinite loop continues
**NEXT SPRINT**: Sprint #N+1 launching immediately

MULTISPRINT WORKFLOW CONTINUES INFINITELY...
```

**MANDATORY FINAL LINE FORMATS:**
- "CONTINUING TO SPRINT #N+1..."
- "MULTISPRINT WORKFLOW CONTINUES..."  
- "PROCEEDING TO NEXT SPRINT CYCLE..."
- "INFINITE LOOP EXECUTION CONTINUES..."

**FORBIDDEN FINAL LINES (CAUSE TERMINATION):**
- "Multisprint complete" 
- "Task finished"
- "Execution done"
- "Workflow terminated"

"""

        # Insert the OpenCode protocol before the Example Execution Pattern
        content = content.replace(
            "## Example Execution Pattern",
            opencode_protocol + "## Example Execution Pattern"
        )
        
        return content

    def _extract_command_template(self, content: str, command_name: str) -> str:
        """Extract command template"""
        # Create appropriate template based on command type
        templates = {
            'plan': "Execute PLAN workflow: chris-architect organizes issues in SPRINT BACKLOG, NO git operations. Follow QADS v4.0 protocols.",
            'work': "Execute WORK workflow: max → implementer → CI-GATE → reviewer → max → merge. Use fraud-proof CI protocols.",
            'play': "Execute PLAY workflow: max PR assessment → serial audits (patrick, vicky, chris) → NO git commits. Find defects only.",
            'sprint': "Complete WORK→PLAY→PLAN cycle with full fraud-proof verification and evidence collection."
        }

        return templates.get(command_name, f"Execute {command_name} workflow following QADS v4.0 protocols.")

    # Rules directory creation removed - AGENTS.md contains all framework rules

    def create_main_config(self):
        """Create main OpenCode configuration file"""
        config = self.convert_claude_md()

        # AGENTS.md automatically loaded - no instructions array needed

        # Write main config
        config_file = self.output_dir / "opencode.json"
        with open(config_file, 'w') as f:
            json.dump(config, f, indent=2)

        print("Created main OpenCode configuration")

    def create_agents_md(self):
        """Create AGENTS.md file by converting CLAUDE.md with minimal replacements"""
        # Read the original CLAUDE.md content
        claude_path = self.source_dir / "CLAUDE.md"
        with open(claude_path, 'r') as f:
            content = f.read()

        # Make minimal replacements for OpenCode compatibility
        replacements = {
            # Replace header
            "# ANTHROPIC 10-COMPONENT QADS v4.0 FRAMEWORK": "# QADS v4.0 OpenCode Configuration",

            # Keep original Anthropic model references
            "grok/grok-1": "anthropic/claude-sonnet-4-20250514",
            "grok/grok-2": "anthropic/claude-sonnet-4-20250514",

            # Replace specialized commands
            "/init": "/plan",
            "opencode auth login": "opencode auth login (Anthropic recommended)",
            "opencode agent create": "Use @agent-name to invoke specialized agents",

            # Update workflow references
            "CLAUDE.md": "QADS v4.0 framework",
            "Anthropic": "OpenCode with Claude Sonnet",
        }

        # Apply replacements
        for old, new in replacements.items():
            content = content.replace(old, new)

        # Add OpenCode-specific section at the end
        opencode_section = """

## OpenCode Integration

This QADS v4.0 framework has been adapted for OpenCode compatibility:

### Available Agents
- **@chris-architect**: Sprint planning and architecture
- **@sergei-perfectionist-coder**: Code implementation with CI verification
- **@patrick-auditor**: Code review and quality assurance
- **@max-devops-engineer**: Repository management and CI/CD
- **@georg-test-engineer**: Test creation and validation
- **@vicky-acceptance-tester**: User acceptance testing
- **@winny-technical-writer**: Documentation
- **@philipp-data-scientist**: Data science and analytics
- **@jonatan-math-physicist**: Mathematical and physics modeling
- **@steffi-ux-designer**: User experience design

### Workflow Commands
- **/plan**: Sprint planning with issue consolidation
- **/work**: Implementation with fraud-proof CI protocols
- **/play**: Defect discovery and evidence collection
- **/sprint**: Complete sprint cycle
- **/multisprint**: Continuous sprint cycles

### Configuration
All agents and commands are configured in the main `opencode.json` file with appropriate permissions and tool access levels optimized for the QADS fraud-proof workflow.
"""

        content += opencode_section

        # Write the converted AGENTS.md
        agents_file = self.output_dir / "AGENTS.md"
        with open(agents_file, 'w') as f:
            f.write(content)

        print("Created AGENTS.md by converting CLAUDE.md with minimal replacements")

    def create_install_script(self):
        """Create installation script for symlinking"""
        install_script = f"""#!/bin/bash
# OpenCode Configuration Installer
# This script symlinks the converted QADS configuration to ~/.config/opencode/

set -e

OPENCODE_CONFIG_DIR="$HOME/.config/opencode"
SOURCE_DIR="$(cd "$(dirname "${{BASH_SOURCE[0]}}")" && pwd)/opencode"

echo "Installing QADS v4.0 OpenCode configuration..."
echo "Source: $SOURCE_DIR"
echo "Target: $OPENCODE_CONFIG_DIR"

# Create config directory if it doesn't exist
mkdir -p "$OPENCODE_CONFIG_DIR"

# Backup existing config if it exists
if [ -f "$OPENCODE_CONFIG_DIR/opencode.json" ]; then
    echo "Backing up existing opencode.json..."
    cp "$OPENCODE_CONFIG_DIR/opencode.json" "$OPENCODE_CONFIG_DIR/opencode.json.backup"
fi

# Create symlinks
echo "Creating symlinks..."

# Main config
if [ -f "$SOURCE_DIR/opencode.json" ]; then
    ln -sf "$SOURCE_DIR/opencode.json" "$OPENCODE_CONFIG_DIR/opencode.json"
    echo "✓ Linked opencode.json"
fi

# AGENTS.md
if [ -f "$SOURCE_DIR/AGENTS.md" ]; then
    ln -sf "$SOURCE_DIR/AGENTS.md" "$OPENCODE_CONFIG_DIR/AGENTS.md"
    echo "✓ Linked AGENTS.md"
fi

# Agent directory
if [ -d "$SOURCE_DIR/agent" ]; then
    ln -sf "$SOURCE_DIR/agent" "$OPENCODE_CONFIG_DIR/agent"
    echo "✓ Linked agent directory"
fi

# Command directory
if [ -d "$SOURCE_DIR/command" ]; then
    ln -sf "$SOURCE_DIR/command" "$OPENCODE_CONFIG_DIR/command"
    echo "✓ Linked command directory"
fi

# Rules integrated into AGENTS.md - no separate rules directory

echo ""
echo "Installation complete!"
echo ""
echo "To use the QADS framework in OpenCode:"
echo "1. Restart OpenCode or run 'opencode auth login' if needed"
echo "2. Use @mention to invoke agents: @chris-architect, @sergei-perfectionist-coder, etc."
echo "3. Use workflow commands: /plan, /work, /play, /sprint"
echo ""
echo "Available agents:"
echo "  - chris-architect: Sprint planning and architecture"
echo "  - sergei-perfectionist-coder: Code implementation with CI verification"
echo "  - patrick-auditor: Code review and quality assurance"
echo "  - max-devops-engineer: Repository management and CI/CD"
echo "  - And 6 more specialized agents..."
echo ""
echo "Workflow commands:"
echo "  - /plan: Sprint planning with issue consolidation"
echo "  - /work: Implementation with fraud-proof CI protocols"
echo "  - /play: Defect discovery and evidence collection"
echo "  - /sprint: Complete sprint cycle"
"""

        install_file = self.output_dir / "install.sh"
        with open(install_file, 'w') as f:
            f.write(install_script)

        # Make install script executable
        os.chmod(install_file, 0o755)

        print("Created installation script")

    def create_readme(self):
        """Create README for the converted configuration"""
        readme_content = """# QADS v4.0 OpenCode Configuration

This directory contains the QADS v4.0 (Quality-driven Agent Development System) framework converted for compatibility with OpenCode.

## Installation

Run the installation script to symlink these configurations to your OpenCode config directory:

```bash
./install.sh
```

This will create symlinks in `~/.config/opencode/` pointing to this directory.

## What's Included

### Main Configuration (`opencode.json`)
- Core OpenCode configuration with QADS framework integration
- Agent definitions for all 10 QADS agents
- Workflow commands (plan, work, play, sprint)
- Permission settings optimized for fraud-proof development
- CI/CD integration settings

### Agents (`agent/`)
Converted versions of all QADS agents:
- **chris-architect**: Sprint planning and architecture
- **sergei-perfectionist-coder**: Code implementation with CI verification
- **patrick-auditor**: Code review and quality assurance
- **max-devops-engineer**: Repository management and CI/CD
- **georg-test-engineer**: Test creation and validation
- **vicky-acceptance-tester**: User acceptance testing
- **winny-technical-writer**: Documentation
- **philipp-data-scientist**: Data science and analytics
- **jonatan-math-physicist**: Mathematical and physics modeling
- **steffi-ux-designer**: User experience design

### Commands (`command/`)
Workflow command definitions:
- `plan.json`: Sprint planning workflow
- `work.json`: Implementation workflow
- `play.json`: Defect discovery workflow
- `sprint.json`: Complete sprint cycle

### Rules (`rules/`)
Framework rules and protocols:
- `qads-framework.md`: Core QADS v4.0 principles and standards

## Usage

After installation, you can use QADS agents in OpenCode by:

1. **Mentioning agents**: `@chris-architect plan this sprint`
2. **Using workflow commands**: `/work` or `/plan`
3. **Switching agents**: Tab key to cycle through primary agents
4. **Following protocols**: All agents follow QADS fraud-proof protocols

## Key Features

- **Fraud-proof development**: Technical verification supersedes all social controls
- **CI-first workflow**: All claims must be verifiable through CI/automation
- **Evidence-based operations**: Every action requires technical proof
- **Role specialization**: Clear boundaries between planning, implementation, and review
- **Systematic workflows**: PLAN → WORK → PLAY → PLAN cycle with gates

## Original Framework

This configuration is converted from the QADS v4.0 framework defined in:
- `CLAUDE.md`: Master framework documentation
- `agents/*.md`: Individual agent specifications
- `commands/*.md`: Workflow command definitions

## Requirements

- OpenCode CLI installed
- Anthropic API key configured (recommended for best results)
- Git repository for full workflow functionality

## Support

The QADS framework emphasizes:
- **CORRECTNESS > PERFORMANCE > KISS > SRP > YAGNI > DRY > SOLID > SECURITY**
- Files <1000 lines (target <500), Functions <100 lines (target <50)
- 88 char limit, 4-space indent
- Self-documenting code with meaningful names
- NO commented-out code, stubs, placeholders, shortcuts
"""

        readme_file = self.output_dir / "README.md"
        with open(readme_file, 'w') as f:
            f.write(readme_content)

        print("Created README for converted configuration")

    def run_conversion(self):
        """Run the complete conversion process"""
        print("Starting QADS to OpenCode conversion...")
        print(f"Source directory: {self.source_dir}")
        print(f"Output directory: {self.output_dir}")
        print()

        # Create main configuration
        self.create_main_config()

        # Create AGENTS.md
        self.create_agents_md()

        # Convert agents
        self.convert_agents_directory()

        # Convert commands
        self.convert_commands_directory()

        # Rules integrated into AGENTS.md - no separate rules directory needed

        # Create installation script
        self.create_install_script()

        # Create README
        self.create_readme()

        print()
        print("Conversion complete!")
        print(f"Output directory: {self.output_dir}")
        print()
        print("Next steps:")
        print("1. Review the generated configuration files")
        print("2. Run ./opencode/install.sh to install")
        print("3. Restart OpenCode to load the new configuration")
        print("4. Use @agent-name to invoke QADS agents")

if __name__ == "__main__":
    converter = QADSConverter()
    converter.run_conversion()