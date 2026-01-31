# Claude Code Configuration

Personal Claude Code setup with skills, agents, and settings.

## Installation

```bash
# Clone and symlink to ~/.claude/
git clone git@github.com:krystophny/prompts.git ~/code/prompts
cd ~/code/prompts

ln -sfn ~/code/prompts/agents ~/.claude/agents
ln -sfn ~/code/prompts/skills ~/.claude/skills
ln -sfn ~/code/prompts/settings.json ~/.claude/settings.json
ln -sfn ~/code/prompts/CLAUDE.md ~/.claude/CLAUDE.md
```

## Structure

```
~/.claude/
├── agents/        -> prompts/agents/       (11 agents)
├── skills/        -> prompts/skills/       (15 skills)
├── settings.json  -> prompts/settings.json
└── CLAUDE.md      -> prompts/CLAUDE.md
```

## Skills

| Skill | Description |
|-------|-------------|
| `/autonomous` | Execute via Claude CLI from Codex |
| `/check` | Pre-commit code review |
| `/codex` | Stepwise Codex orchestration |
| `/comments` | Address PR comments |
| `/commit` | Create git commit |
| `/debug` | Debug failing test |
| `/do` | Enforce CLAUDE.md compliance |
| `/fix` | Fix failing PR checks |
| `/issue` | Create GitHub issue |
| `/multisprint` | Continuous sprint cycles |
| `/play` | Sprint review and defect discovery |
| `/pr` | Start new bug fix PR |
| `/sprint` | Complete sprint cycle |
| `/sprint-plan` | Strategic sprint planning |
| `/work` | Sprint implementation |

## Agents

| Agent | Role |
|-------|------|
| chris-architect | Sprint planning, architecture |
| codex | Codex CLI integration |
| georg-test-engineer | Test creation and validation |
| jonatan-math-physicist | Math/physics modeling |
| max-devops-engineer | DevOps, CI/CD, releases |
| patrick-reviewer | Code review, quality |
| philipp-data-scientist | Data analysis, ML |
| sergei-perfectionist-coder | Implementation |
| steffi-ux-designer | UX design |
| vicky-acceptance-tester | Acceptance testing |
| winny-technical-writer | Documentation |

## Settings

`settings.json` enforces CLAUDE.md rules via permissions:

**Denied:**
- `git add .`, `git add -A` (explicit staging only)
- `git push --force`, `git reset --hard`
- Reading `.env`, credentials, secrets

**Allowed:**
- git, gh, make, cmake, fpm, go, pytest, npm, fprettify

## License

MIT
