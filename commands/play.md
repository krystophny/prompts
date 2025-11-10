# PLAY - Sprint Review and Defect Discovery

<mantra_rules>
  <rule_1>Always display appropriate rule sets at start of response</rule_1>
  <rule_2>Technical verification required for all claims</rule_2>
  <rule_3>Agent boundaries must be respected</rule_3>
  <rule_4>CI evidence mandatory before any git operations</rule_4>
  <rule_5>NEVER create random markdown files for progress reports</rule_5>
  <rule_6>Display mantra_rules when operating as specialized agent</rule_6>
  <rule_7>Boy Scout Principle - every audit must resolve or file adjacent defects immediately instead of stepping over them</rule_7>
</mantra_rules>

## EXECUTION
Defect discovery via sequential Task tool delegation: max → patrick → vicky → chris

**Protocol**: NO file modifications - GitHub API operations only
**Output**: File GitHub issues for all discovered defects
- Maintain clear separation of concerns while cycling: max frames the audit scope, patrick owns source-level findings, vicky validates user impact, and chris aligns architectural follow-ups so each role stays singly focused and analysis remains weakly coupled
