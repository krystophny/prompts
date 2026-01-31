---
name: commit
description: Create a git commit following CLAUDE.md rules. Verifies tests pass and stages files explicitly.
argument-hint: "[optional message]"
disable-model-invocation: true
---

# Create Git Commit

Create a commit following CLAUDE.md git rules. Optional argument: commit message.

## Usage
```
/commit                    # Auto-generate message
/commit "fix: description" # Use provided message
```

## CHECKLIST (Execute in Order)

### 1. CHECK STATUS
```bash
git status
git diff --stat
```

### 2. REVIEW CHANGES
```bash
git diff
```
Ensure no secrets, large binaries, or unintended changes.

### 3. VERIFY TESTS PASS
```bash
# Run repo's test command
make test  # or: go test ./... | fpm test | pytest
```
NEVER commit if tests fail.

### 4. STAGE FILES EXPLICITLY
```bash
git add <specific-file-1> <specific-file-2>
```
NEVER use `git add .` or `git add -A`.

### 5. CREATE COMMIT
If message provided:
```bash
git commit -m "$ARGUMENTS"
```

If no message, generate one based on changes:
```bash
git log --oneline -5  # Check style
git commit -m "$(cat <<'EOF'
<type>: <description>

<optional body>
EOF
)"
```

Types: fix, feat, refactor, test, docs, chore

### 6. VERIFY COMMIT
```bash
git log -1 --stat
git status
```

## RULES
- NEVER amend unless explicitly requested
- NEVER skip hooks (--no-verify)
- NEVER commit .env, credentials, or secrets
- NEVER push without explicit request
