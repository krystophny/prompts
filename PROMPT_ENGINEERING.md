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
```
Examples:

Example 1:
Input: [Example input 1]
Output: [Desired output 1]

Example 2:
Input: [Example input 2]
Output: [Desired output 2]

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
```
## Thinking Process
Work through your reasoning here step-by-step.

## Answer
Provide your final response here.
```

**Benefits**:
- Reduces errors in complex reasoning
- Creates more cohesive responses
- Enables debugging of unclear prompts
- Improves accuracy on analytical tasks

### 4. Structured Organization

**Core Organizational Sections**:
```
## Instructions
Your main task instructions here

## Context
Background information and situational context

## Examples
Input/output examples for reference

## Formatting Requirements
Specific formatting requirements

## Constraints
- Limitations and restrictions
```

**Processing Sections**:
```
## Thinking Process
Step-by-step reasoning process

## Analysis
Detailed analysis section

## Answer
Final structured response
```

**Best Practices**:
- Use consistent, descriptive section headers
- Organize content hierarchically with clear headings
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
```
## Documents

### Document 1
- Source: annual_report_2023.pdf
- Content: {{LONG_DOCUMENT_CONTENT}}

### Document 2  
- Source: market_analysis.docx
- Content: {{SECOND_DOCUMENT_CONTENT}}

## Query
Your specific question or task here
```

**Information Extraction Pattern**:
```
First, identify and quote the relevant sections from the documents that relate to [TOPIC].

Then, analyze these quotes to answer: [SPECIFIC_QUESTION]
```

## Structural Guidelines

### Prompt Organization Template

```
## Role
Define Claude's expertise and perspective

## Context
Provide relevant background information

## Instructions
1. Clear, numbered steps
2. Specific expectations
3. Output format requirements

## Examples
Show 2-3 input/output pairs

## Constraints
- List any limitations
- Specify what to avoid
- Define boundaries

## Formatting Requirements
Specify exact output structure
```

### Response Structure Template

```
## Thinking Process
Step-by-step reasoning process

## Analysis
Detailed examination of the problem

## Solution
Main response content

## Verification
Quality check and validation
```

### Architectural Cohesion Guidelines
- Partition prompt sections so that each block handles one concern (role, context, instructions, evaluation) to keep information flows clean
- Audit every prompt component for a single responsibility and relocate mixed content into dedicated sections before finalizing
- Reference earlier sections by name rather than duplicating content, which keeps dependencies weak and makes iterative refinement cheaper

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
- Use structured sections with clear headers
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
```
## Instructions
1. Summarize the key information
2. Identify patterns and trends
3. Analyze implications
4. Provide actionable recommendations

## Thinking Process
Work through each step systematically

## Summary
Key information overview

## Patterns
Identified trends and patterns

## Implications
What this means for the situation

## Recommendations
Specific, actionable next steps
```

### Generation Pattern
```
## Role
Expert content creator in [DOMAIN]

## Requirements
- Target audience: [AUDIENCE]
- Tone: [TONE]
- Length: [LENGTH]
- Format: [FORMAT]

## Examples
[Show similar successful outputs]

## Constraints
- Must include: [REQUIRED_ELEMENTS]
- Must avoid: [FORBIDDEN_ELEMENTS]

## Task
Generate: [SPECIFIC_REQUEST]
```

### Evaluation Pattern
```
## Criteria
1. [CRITERION_1]: [DESCRIPTION]
2. [CRITERION_2]: [DESCRIPTION]  
3. [CRITERION_3]: [DESCRIPTION]

## Evaluation Process
For each criterion, provide:
- Score (1-10)
- Justification
- Supporting evidence
- Improvement suggestions

## Final Assessment
Overall score and summary recommendation
```

---

## Quick Reference

### Essential Techniques Checklist
- [ ] Clear, specific instructions
- [ ] Relevant examples provided
- [ ] Chain of thought reasoning
- [ ] Structured sections with clear headers
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
