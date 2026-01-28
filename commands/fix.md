# /fix - Fix Failing PR Checks

Execute when PR CI checks fail. Requires PR number as argument.

## Usage
```
/fix <pr-number>
```

## AGENT DELEGATION

```
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!! MANDATORY: Spawn sergei-perfectionist-coder for implementation       !!
!! The agent enforces clean code and prevents technical debt            !!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
```

## SUCCESS CRITERIA (ALL must be true before reporting success)
- [ ] CI status is `completed` + `success` (NOT "in progress", NOT "queued")
- [ ] All reviewer comments addressed (not ignored)
- [ ] New changes committed AND pushed
- [ ] PR description matches actual implementation (no contradictions)
- [ ] No technical debt introduced

## CHECKLIST (Execute in Order)

```
[ ] 1. CHECK PR COMMENTS FIRST (BLOCKING)
      gh pr view $ARGUMENTS --repo <owner>/<repo> --comments
      gh api repos/<owner>/<repo>/pulls/$ARGUMENTS/comments --jq '.[] | "\(.user.login): \(.body)"'

      STOP HERE if reviewer requested specific approach. Follow it EXACTLY.
      Do NOT add workarounds reviewer explicitly rejected.

[ ] 2. GET BRANCH AND FIND FAILED JOBS
      BRANCH=$(gh pr view $ARGUMENTS --repo <owner>/<repo> --json headRefName --jq '.headRefName')

      # List runs - look for any with conclusion=failure OR status=in_progress
      gh run list --repo <owner>/<repo> --branch $BRANCH --limit 5 --json databaseId,status,conclusion,workflowName

      # Get the latest run ID
      RUN_ID=$(gh run list --repo <owner>/<repo> --branch $BRANCH --limit 1 --json databaseId --jq '.[0].databaseId')

      # Check individual job statuses
      gh run view $RUN_ID --repo <owner>/<repo> --json jobs --jq '.jobs[] | select(.conclusion == "failure") | "\(.name): \(.conclusion)"'

[ ] 3. GET ERROR LOGS FROM FAILED JOBS IMMEDIATELY
      gh run view $RUN_ID --repo <owner>/<repo> --log-failed 2>&1 | grep -E "error:|Error:|FAILED|fatal:" | head -50

      DO NOT wait for "in progress" runs. Failed jobs have logs available immediately.

[ ] 4. REPRODUCE LOCALLY
      git fetch origin
      git checkout $BRANCH
      # Build and run exact command/test that CI failed on

[ ] 5. IMPLEMENT FIX (spawn sergei-perfectionist-coder)
      - Follow reviewer guidance EXACTLY
      - Fix in correct pipeline stage
      - Minimal changes only
      - NO technical debt (see checklist below)

[ ] 6. CLEAN CODE VERIFICATION
      - [ ] Functions < 100 lines (hard limit)
      - [ ] No copy-paste code
      - [ ] No magic numbers
      - [ ] No TODO/FIXME without GitHub issues
      - [ ] No commented-out code
      - [ ] No suppression pragmas

[ ] 7. VERIFY FIX LOCALLY
      # Build and run tests
      # ALL tests must pass - 100%

[ ] 8. COMMIT & PUSH (MANDATORY - not optional)
      git add <specific-files>
      git commit -m "fix: <description>"
      git push

      If nothing to commit, the fix failed - go back to step 5.

[ ] 9. UPDATE PR DESCRIPTION (if implementation approach changed)
      Ensure PR description accurately reflects what was done.

[ ] 10. MONITOR CI - CHECK FOR FAILURES FIRST
       RUN_ID=$(gh run list --repo <owner>/<repo> --branch $BRANCH --limit 1 --json databaseId --jq '.[0].databaseId')

       # Check if any jobs already failed
       FAILED=$(gh run view $RUN_ID --repo <owner>/<repo> --json jobs --jq '[.jobs[] | select(.conclusion == "failure")] | length')
       if [ "$FAILED" -gt 0 ]; then
         echo "Jobs already failed - fetching logs immediately"
         gh run view $RUN_ID --repo <owner>/<repo> --log-failed 2>&1 | head -100
         # Go back to step 3 to diagnose
       fi

       # Only watch if no failures yet
       gh run watch $RUN_ID --repo <owner>/<repo> --exit-status || gh run view $RUN_ID --repo <owner>/<repo> --log-failed 2>&1 | head -100

       DO NOT just report "in progress" - check for already-failed jobs first.
       Only report success when status is `completed` + `success`.
       If CI fails again, repeat from step 3.
```

## TECHNICAL DEBT CHECK (BLOCKING)

| Pattern | Severity | Action |
|---------|----------|--------|
| TODO/FIXME without issue | CRITICAL | REJECT - create GitHub issue first |
| Commented-out code | CRITICAL | REJECT - delete it |
| Suppression pragmas | CRITICAL | REJECT - fix the underlying issue |
| Copy-paste duplication | MAJOR | REJECT - extract shared code |
| Magic numbers | MAJOR | REJECT - use named constants |
| Functions >100 lines | MAJOR | REJECT - split function |

## FAILURE CONDITIONS (report failure, not success)
- CI still running or queued
- Nothing committed/pushed
- Reviewer comments ignored
- Workarounds added that reviewer rejected
- PR description contradicts implementation
- Technical debt introduced
