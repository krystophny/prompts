# /comments - Check & Address PR Comments

Review and address all comments on a PR. Requires PR number as argument.

## Usage
```
/comments <pr-number>
```

## AGENT DELEGATION

```
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!! MANDATORY: Spawn sergei-perfectionist-coder for code changes         !!
!! The agent enforces clean code and prevents technical debt            !!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
```

## CHECKLIST (Execute in Order)

```
[ ] 1. LIST ALL COMMENTS
      gh pr view $ARGUMENTS --repo <owner>/<repo> --comments

[ ] 2. CHECK REVIEW STATUS
      gh pr view $ARGUMENTS --repo <owner>/<repo> --json reviews --jq '.reviews[] | "\(.author.login): \(.state)"'

[ ] 3. GET INLINE COMMENTS
      gh api repos/<owner>/<repo>/pulls/$ARGUMENTS/comments --jq '.[] | "[\(.path):\(.line)] \(.user.login): \(.body)"'

[ ] 4. FOR EACH COMMENT (spawn sergei-perfectionist-coder if code change needed):
      - Read carefully
      - If code change needed -> make the change (NO technical debt)
      - If clarification needed -> reply to comment
      - If disagreement -> discuss respectfully, don't ignore

[ ] 4.5 FOLLOW-UP TRACKING
      - [ ] If reviewer requested issue creation → verify issue exists (gh issue view)
      - [ ] If "improve later/refine later" → GitHub issue created with specifics
      - [ ] Link issue numbers in PR comment as confirmation
      - [ ] Missing tracking = DO NOT PROCEED

[ ] 5. CLEAN CODE VERIFICATION
      - [ ] Functions < 100 lines; No copy-paste code; No magic numbers
      - [ ] No TODO/FIXME without issues; No commented-out code
      - [ ] No noise comments; Workarounds have issue numbers

[ ] 6. BUILD AND TEST
      # Build project
      # Run tests - ALL must pass (100%)

[ ] 7. COMMIT & PUSH
      git add <specific-files>
      git commit -m "fix: address review feedback"
      git push

[ ] 8. REPLY TO COMMENTS
      Confirm resolution by replying to each addressed comment.

[ ] 9. REQUEST RE-REVIEW (if needed)
      gh pr edit $ARGUMENTS --repo <owner>/<repo> --add-reviewer <reviewer>
```

## TECHNICAL DEBT CHECK (BLOCKING)

Before committing any changes, verify:

| Pattern | Severity | Action |
|---------|----------|--------|
| TODO/FIXME without issue | CRITICAL | REJECT - create GitHub issue first |
| Commented-out code | CRITICAL | REJECT - delete it |
| Suppression pragmas | CRITICAL | REJECT - fix the underlying issue |
| Copy-paste duplication | MAJOR | REJECT - extract shared code |
| Magic numbers | MAJOR | REJECT - use named constants |
| Functions >100 lines | MAJOR | REJECT - split function |

## REPORT TEMPLATE

```markdown
# PR Comments Addressed

## Comments Processed
- [ ] Comment 1: [summary] - [action taken]
- [ ] Comment 2: [summary] - [action taken]

## Clean Code Verification
- Function size: [PASS/FAIL]
- No duplication: [PASS/FAIL]
- No magic numbers: [PASS/FAIL]
- No tech debt: [PASS/FAIL]

## Tests
- Status: [ALL PASS / FAILURES]

## Next Steps
[Ready for re-review | More changes needed]
```
