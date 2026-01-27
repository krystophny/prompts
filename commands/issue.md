# /issue - Create GitHub Issue

Create a properly formatted GitHub issue. Argument: issue title.

## Usage
```
/issue "Bug: minloc returns wrong type with kind=8"
```

## CHECKLIST (Execute in Order)

### 1. GATHER INFORMATION
- What is the bug/feature?
- Steps to reproduce (MRE)
- Expected vs actual behavior
- LFortran version: `lfortran --version`

### 2. CREATE MRE
```fortran
! Minimal reproducing example
program mre
  ! Smallest code that shows the issue
end program
```

### 3. VERIFY MRE
```bash
scripts/lf.sh run /tmp/mre.f90
gfortran /tmp/mre.f90 -o /tmp/mre_gfortran && /tmp/mre_gfortran
```

### 4. WRITE ISSUE BODY
Save to /tmp/issue.md:
```markdown
## Description
<1-2 sentences describing the issue>

## MRE
\`\`\`fortran
<minimal code>
\`\`\`

## Expected Behavior
<what should happen>

## Actual Behavior
<what actually happens>

## Version
\`\`\`
<lfortran --version output>
\`\`\`
```

### 5. CREATE ISSUE
```bash
gh issue create --repo lfortran/lfortran \
  --title "$ARGUMENTS" \
  --body-file /tmp/issue.md \
  --label bug
```

### 6. REPORT
Provide the issue URL.

## RULES
- Always include MRE
- Always verify MRE compiles with gfortran (unless gfortran bug)
- No emojis in title or body
- Use appropriate labels: bug, enhancement, documentation
