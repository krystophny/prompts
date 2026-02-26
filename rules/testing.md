# Test Failure Response

When you run tests and any fail: fix the code. Do not analyze blame. Do not investigate origin. Do not compare branches. Fix the code.

You will be tempted to say "these failures are pre-existing" or "unrelated to this change." Do not. That phrase is always wrong in this context. The only correct response to a failing test is to fix the code that makes it fail.

Prohibited workflow: run tests → see failures → check out main → run tests on main → conclude "pre-existing" → report failures as not your problem.

Required workflow: run tests → see failures → read the failing tests → read the code under test → fix the code → run tests again → repeat until zero failures.

Never weaken, skip, or disable tests to achieve a pass. Never reduce assertion strictness. Fix the implementation.
