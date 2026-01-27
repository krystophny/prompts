# /comments - Check & Address PR Comments

Review and address all comments on a PR. Requires PR number as argument.

## Usage
```
/pr-comments <pr-number>
```

## CHECKLIST (Execute in Order)

### 1. LIST ALL COMMENTS
```bash
gh pr view $ARGUMENTS --repo lfortran/lfortran --comments
```

### 2. CHECK REVIEW STATUS
```bash
gh pr view $ARGUMENTS --repo lfortran/lfortran --json reviews --jq '.reviews[] | "\(.author.login): \(.state)"'
```

### 3. GET INLINE COMMENTS
```bash
gh api repos/lfortran/lfortran/pulls/$ARGUMENTS/comments --jq '.[] | "[\(.path):\(.line)] \(.user.login): \(.body)"'
```

### 4. FOR EACH COMMENT:
- Read carefully
- If code change needed → make the change
- If clarification needed → reply to comment
- If disagreement → discuss respectfully, don't ignore

### 5. AFTER ADDRESSING ALL:
```bash
scripts/lf.sh build
scripts/lf.sh test
```

### 6. COMMIT & PUSH
```bash
git -C lfortran add <specific-files>
git -C lfortran commit -m "fix: address review feedback"
git -C lfortran push
```

### 7. REPLY TO COMMENTS
Confirm resolution by replying to each addressed comment.

### 8. REQUEST RE-REVIEW (if needed)
```bash
gh pr edit $ARGUMENTS --repo lfortran/lfortran --add-reviewer <reviewer>
```
