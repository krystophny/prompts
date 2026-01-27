# /commit - Create Git Commit

Create a commit following CLAUDE.md git rules. Optional argument: commit message.

## Usage
```
/commit                    # Auto-generate message
/commit "fix: description" # Use provided message
```

## CHECKLIST (Execute in Order)

### 1. CHECK STATUS
```bash
git -C lfortran status
git -C lfortran diff --stat
```

### 2. REVIEW CHANGES
```bash
git -C lfortran diff
```
Ensure no secrets, large binaries, or unintended changes.

### 3. VERIFY TESTS PASS
```bash
scripts/lf.sh test
```
NEVER commit if tests fail.

### 4. STAGE FILES EXPLICITLY
```bash
git -C lfortran add <specific-file-1> <specific-file-2>
```
NEVER use `git add .` or `git add -A`.

### 5. CREATE COMMIT
If message provided:
```bash
git -C lfortran commit -m "$ARGUMENTS"
```

If no message, generate one based on changes:
```bash
git -C lfortran log --oneline -5  # Check style
git -C lfortran commit -m "$(cat <<'EOF'
<type>: <description>

<optional body>
EOF
)"
```

Types: fix, feat, refactor, test, docs, chore

### 6. VERIFY COMMIT
```bash
git -C lfortran log -1 --stat
git -C lfortran status
```

## RULES
- NEVER amend unless explicitly requested
- NEVER skip hooks (--no-verify)
- NEVER commit .env, credentials, or secrets
- NEVER push without explicit request
