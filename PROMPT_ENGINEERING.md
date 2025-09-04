# Anthropic Prompt Engineering Guide

This document provides comprehensive guidelines for effective prompt engineering with Claude, based on Anthropic's official documentation and best practices.

## Table of Contents

1. [Fundamentals](#fundamentals)
2. [Core Techniques](#core-techniques)
3. [Advanced Strategies](#advanced-strategies)
4. [Structural Guidelines](#structural-guidelines)
5. [Optimization Principles](#optimization-principles)
6. [Common Patterns](#common-patterns)

## Fundamentals

### When to Use Prompt Engineering

Prompt engineering is the optimal approach when you need:
- **Speed**: Faster than fine-tuning with immediate results
- **Cost-efficiency**: More resource-efficient than model training
- **Flexibility**: Rapid iteration and experimentation
- **Generality**: Preserves model's broad knowledge base
- **Transparency**: Clear visibility into model interactions

### Success Criteria Framework

Before starting any prompt engineering project:

1. **Define clear success metrics**
2. **Develop empirical testing methods**
3. **Create baseline prompt drafts**
4. **Establish measurable improvement goals**

## Core Techniques

### 1. Be Clear and Direct

**Golden Rule**: "Show your prompt to a colleague with minimal context and see if they understand."

**Essential Elements**:
- **Context**: Explain the task's purpose and workflow
- **Audience**: Describe who will use the output
- **Expectations**: Be explicit about desired outcomes
- **Structure**: Use numbered or bulleted instructions

**Before/After Example**:
```
❌ Vague: "Write a marketing email for our new features"

✅ Clear: "Write a marketing email to our existing customers (small business owners) 
announcing our new inventory management features. Use a friendly but professional 
tone. Include:
1. Subject line under 50 characters
2. Brief intro acknowledging their business needs
3. 3 key benefits of the new features
4. Clear call-to-action button
5. Personalization variables: {{customer_name}}, {{business_type}}"
```

### 2. Use Examples (Few-Shot Prompting)

**Structure**:
```xml
<examples>
<example>
<input>[Example input 1]</input>
<output>[Desired output 1]</output>
</example>

<example>
<input>[Example input 2]</input>
<output>[Desired output 2]</output>
</example>
</examples>

Now process: [Actual input]
```

**Best Practices**:
- Provide 2-3 high-quality examples
- Show edge cases and variations
- Maintain consistent format across examples

### 3. Chain of Thought Reasoning

**Levels of Implementation**:

**Basic**:
```
Think step-by-step before answering.
```

**Guided**:
```
Before answering, work through this process:
1. Identify the key components
2. Analyze each component
3. Consider relationships
4. Draw conclusions
```

**Structured**:
```xml
<thinking>
Work through your reasoning here step-by-step.
</thinking>

<answer>
Provide your final response here.
</answer>
```

**Benefits**:
- Reduces errors in complex reasoning
- Creates more cohesive responses
- Enables debugging of unclear prompts
- Improves accuracy on analytical tasks

### 4. XML Tag Structure

**Core Organizational Tags**:
```xml
<instructions>
Your main task instructions here
</instructions>

<context>
Background information and situational context
</context>

<examples>
Input/output examples for reference
</examples>

<formatting>
Specific formatting requirements
</formatting>

<constraints>
Limitations and restrictions
</constraints>
```

**Processing Tags**:
```xml
<thinking>
Step-by-step reasoning process
</thinking>

<analysis>
Detailed analysis section
</analysis>

<answer>
Final structured response
</answer>
```

**Best Practices**:
- Use consistent, descriptive tag names
- Nest tags for hierarchical content
- Combine with other techniques for maximum effect

### 5. System Prompts and Role Assignment

**Implementation**:
```python
system_prompt = "You are a seasoned data scientist specializing in customer 
insight analysis at a Fortune 500 company. You excel at translating complex 
data into actionable business recommendations."
```

**Role Specificity Levels**:
- **Generic**: "You are a data scientist"
- **Focused**: "You are a data scientist specializing in customer analytics"
- **Expert**: "You are a senior data scientist with 10+ years in retail customer 
  behavior analysis, known for translating complex patterns into profitable 
  business strategies"

**Impact Areas**:
- Task-specific accuracy
- Communication tone and style
- Domain expertise depth
- Response structure and focus

### 6. Response Prefilling

**JSON Output Control**:
```
User: Analyze this data and provide insights.
Assistant: {
```

**Character Consistency**:
```
User: Continue our conversation about market trends.
Assistant: [MARKET_ANALYST]:
```

**Format Enforcement**:
```
User: List the key findings.
Assistant: ## Key Findings

1.
```

**Important Notes**:
- Only works in non-extended thinking modes
- Cannot end with trailing whitespace
- Particularly effective for structured outputs

## Advanced Strategies

### Prompt Chaining

**Core Principle**: Break complex tasks into manageable subtasks where each gets Claude's full attention.

**Chaining Workflow**:
```
Task 1: Research → Output A
Task 2: Analysis (using Output A) → Output B  
Task 3: Synthesis (using Output B) → Final Result
```

**Self-Correction Chains**:
```
Step 1: Generate initial response
Step 2: Review and identify improvements
Step 3: Refine based on review
Step 4: Final quality check
```

**Parallel Processing**: For independent subtasks, run separate prompts simultaneously for speed optimization.

### Long Context Optimization

**Document Placement Strategy**:
- Place long documents (20K+ tokens) at the beginning of prompts
- Can improve response quality by up to 30%

**Document Structure**:
```xml
<documents>
  <document index="1">
    <source>annual_report_2023.pdf</source>
    <document_content>
    {{LONG_DOCUMENT_CONTENT}}
    </document_content>
  </document>
  
  <document index="2">
    <source>market_analysis.docx</source>
    <document_content>
    {{SECOND_DOCUMENT_CONTENT}}
    </document_content>
  </document>
</documents>

<query>
Your specific question or task here
</query>
```

**Information Extraction Pattern**:
```
First, identify and quote the relevant sections from the documents that relate to [TOPIC].

Then, analyze these quotes to answer: [SPECIFIC_QUESTION]
```

## Structural Guidelines

### Prompt Organization Template

```xml
<role>
Define Claude's expertise and perspective
</role>

<context>
Provide relevant background information
</context>

<instructions>
1. Clear, numbered steps
2. Specific expectations
3. Output format requirements
</instructions>

<examples>
Show 2-3 input/output pairs
</examples>

<constraints>
- List any limitations
- Specify what to avoid
- Define boundaries
</constraints>

<formatting>
Specify exact output structure
</formatting>
```

### Response Structure Template

```xml
<thinking>
Step-by-step reasoning process
</thinking>

<analysis>
Detailed examination of the problem
</analysis>

<solution>
Main response content
</solution>

<verification>
Quality check and validation
</verification>
```

## Optimization Principles

### Iterative Improvement Process

1. **Baseline**: Create initial working prompt
2. **Test**: Run on representative examples
3. **Measure**: Evaluate against success criteria
4. **Refine**: Adjust based on failure modes
5. **Validate**: Confirm improvements hold across cases

### Common Failure Modes and Solutions

| Problem | Solution |
|---------|----------|
| Inconsistent formatting | Add specific formatting constraints and examples |
| Missing context | Provide more background information |
| Overly verbose responses | Use prefilling or explicit length constraints |
| Off-topic responses | Strengthen instructions and add constraints |
| Shallow analysis | Implement chain of thought reasoning |
| Factual errors | Add verification steps and source requirements |

### Performance Optimization

**For Accuracy**:
- Use chain of thought reasoning
- Provide relevant examples
- Add verification steps
- Break complex tasks into subtasks

**For Consistency**:
- Use XML tags for structure
- Provide clear formatting guidelines
- Use system prompts for role consistency
- Implement response prefilling

**For Efficiency**:
- Place long content at prompt beginning
- Use parallel processing for independent tasks
- Optimize context window usage
- Implement smart document chunking

## Common Patterns

### Analysis Pattern
```xml
<instructions>
1. Summarize the key information
2. Identify patterns and trends
3. Analyze implications
4. Provide actionable recommendations
</instructions>

<thinking>
Work through each step systematically
</thinking>

<summary>
Key information overview
</summary>

<patterns>
Identified trends and patterns
</patterns>

<implications>
What this means for the situation
</implications>

<recommendations>
Specific, actionable next steps
</recommendations>
```

### Generation Pattern
```xml
<role>
Expert content creator in [DOMAIN]
</role>

<requirements>
- Target audience: [AUDIENCE]
- Tone: [TONE]
- Length: [LENGTH]
- Format: [FORMAT]
</requirements>

<examples>
[Show similar successful outputs]
</examples>

<constraints>
- Must include: [REQUIRED_ELEMENTS]
- Must avoid: [FORBIDDEN_ELEMENTS]
</constraints>

Generate: [SPECIFIC_REQUEST]
```

### Evaluation Pattern
```xml
<criteria>
1. [CRITERION_1]: [DESCRIPTION]
2. [CRITERION_2]: [DESCRIPTION]
3. [CRITERION_3]: [DESCRIPTION]
</criteria>

<evaluation_process>
For each criterion, provide:
- Score (1-10)
- Justification
- Supporting evidence
- Improvement suggestions
</evaluation_process>

<final_assessment>
Overall score and summary recommendation
</final_assessment>
```

---

## Quick Reference

### Essential Techniques Checklist
- [ ] Clear, specific instructions
- [ ] Relevant examples provided
- [ ] Chain of thought reasoning
- [ ] XML tags for structure
- [ ] Appropriate role assignment
- [ ] Response format prefilling (if needed)

### Quality Gates
- [ ] Colleague comprehension test passed
- [ ] Success criteria defined and measurable
- [ ] Edge cases considered
- [ ] Error modes identified and addressed
- [ ] Consistent performance across test cases

### Advanced Features
- [ ] Prompt chaining for complex tasks
- [ ] Long context optimization applied
- [ ] Self-correction loops implemented
- [ ] Parallel processing opportunities identified

---

*This guide synthesizes Anthropic's official prompt engineering documentation and represents current best practices for Claude interaction optimization.*