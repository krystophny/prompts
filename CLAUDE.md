simplify this to have less redundant information and be more targetted for prompt design for the points that really count.
## Development Principles

- Strictly follow TDD, SOLID, KISS, SRP and DRY as strict requirements in the development process.
- !!! You MUST always write tests first. Strictly follow Test Driven Development as defined below !!!
- Always keep functions, subroutines and modules small and manageable.
- Always keep work units small and manageable.
- Always work sequentially. Never do multiple things in parallel.
- Never be lazy. Don't take shortcuts. Fulfill every task fully to 100%
- Delete things that are obsolete if they are under version control. Don't hamster old messy stuff.
- Always write code that speaks for itself and avoid comments where possible.
- Never leave commented out sections of code in source files.
- You have a strict limit of 88 characters per line. 
- You indent with 4 spaces.
- When you work, you carefully go through each point of TODO.md in order, check of completed items, and update the plan when needed. Always plan before you implement. Always write tests first.
- Usually, you don't need to clean the build output before build or test. Do this only in case of persisting build problems that you cannot solve otherwise.
- Use typename_t as convention for Fortran derived types
- Always prefer simple and elegant solutions over complex ones.
- Fortran knows no polymorphic arrays. You need a concrete wrapper type with one abstract type member variable and build an array of this wrapper type objects.
- Never nest deeper than 3 levels in loops, if blocks, etc.
- To avoid dummy argument warnings in Fortran, you can place them in an empty associate block
- Extend Fortran arrays with arr = [arr, new_element] syntax. Be sure that new_element is just a variable and not an expression (one may need a temporary)
- I hate having several versions of the same thing lying around like a Python programming rookie who has never used git. Clean up redundant code immediately.
- NEVER keep old versions and start new files with updates or rewrites. ALWAYS work on existing files in place.
- NEVER use phrases like "for now assume" or take methodological shortcuts.
- When cleaning the build, use fpm clean --skip to avoid removing files that should be kept.

## Test Driven Development

Follow the Red-Green-Refactor cycle:

1. **RED**: Write a test that will fail until we wrote our code
2. **GREEN**: Implement actual code and pass this test  
3. **REFACTOR**: Clean up code while keeping all tests green

## Rules
- Never write code without a failing test
- Write only enough code to pass the test
- Run tests after each step
- A REAL test must:
  - Actually exercise the functionality being tested
  - Fail when the functionality is broken
  - Pass only when the functionality works correctly
  - Not just print "PASS" or "FAIL" messages
- For a compiler, real tests compile actual Fortran code and verify the output

## Personal Information

- My github username is krystophny

## Communication Guidelines

- Be concise and professional. No celebrations, no exaggerations.
- Don't declare victory when fixing minor infrastructure issues if the main functionality still doesn't work
- A test is NOT just code that prints "PASS" - it must actually verify functionality
- Understand the difference between infrastructure fixes and actual feature implementation

## System Information

- Our OS is Arch Linux.
