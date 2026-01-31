# /issue - Create GitHub Issue

Create a properly formatted GitHub issue. Argument: issue title.

## Usage
```
/issue "Bug: function returns wrong result"
```

## CHECKLIST (Execute in Order)

### 1. GATHER INFORMATION
- What is the bug/feature?
- Steps to reproduce (MRE)
- Expected vs actual behavior
- Version info: relevant tool versions

### 2. CREATE MRE
```
# Minimal reproducing example
# Smallest code/steps that shows the issue
```

### 3. VERIFY MRE
```bash
# Run MRE and confirm it reproduces the issue
./mre_script.sh
```

### 4. WRITE ISSUE BODY
Save to /tmp/issue.md:
```markdown
## Description
<1-2 sentences describing the issue>

## MRE
\`\`\`
<minimal code/steps>
\`\`\`

## Expected Behavior
<what should happen>

## Actual Behavior
<what actually happens>

## Version
\`\`\`
<version info>
\`\`\`
```

### 5. CREATE ISSUE
```bash
gh issue create \
  --title "$ARGUMENTS" \
  --body-file /tmp/issue.md \
  --label bug
```

### 6. REPORT
Provide the issue URL.

## RULES
- Always include MRE
- Always verify MRE reproduces the issue
- No emojis in title or body
- Use appropriate labels: bug, enhancement, documentation
