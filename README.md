# prompts

See also [Claude docs](https://docs.anthropic.com/en/docs/claude-code/common-workflows).

* The goal of this project is *goal*. Initialize CLAUDE.md with this information.
* *Insert requirements and goals here*. Devise an architectural plan in DESIGN.md and derive a detailed backlog for execution in RED/GREEN/REFACTOR test-driven development with non-shallow and non-tautological tests in a set of well and detailed issues on GitHub. Emphasize that no cheating and no shortcuts, simplifications, stubs or placeholders are allowed. Then commit and push.
* Consider the current failing tests and problems, devise a solution strategy, and add a list of issues with a detailed checklist what to do to resolve it.
* Take the next issue on GitHub and get it done in a new branch. No cheating, no shortcuts, no simplifications, no stubs, no placeholders. Write targetted tests that initially fail (RED phase), implement full functionality to make them pass (GREEN phase), clean up implementation (REFACTOR phase), see that all tests still pass. Do this in small steps. After each step, update issue description, commit, push. Once finished, open a PR.
* Check qodo comments in PR, CI and coverage and fix anything that pops up.
* Merge PR into main. Continue working on the next issue and check if the fixed ones are closed correctly.
* Audit the whole codebase and all tests if you cheated or took a shortcut or wrote a stub just to get something to look like it works superficially. Check for duplicate, legacy, and dead code up for elimination. Check if all criteria of CLAUDE.md and ~/.claude/CLAUDE.md are fulfilled. Then fix all honestly in small steps covered by tests.

## Review
* Review the changes of the current PR in a constructively critical way based on the following criteria:
  - Goals of the underlying issue are completely fulfilled.
  - No dead, legacy or duplicated code remains.
  - No files added that shouldn't be in git. 
  - File and Directory names and structure are consistent and meaningful.
  - Documentation is up to date. 
  - Conventions of CLAUDE.md and ~/.claude/CLAUDE.md are fulfilled. 

## Thinking Mode

Think. Think hard. Think harder. Ultrathink.

