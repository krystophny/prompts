# 📝 Git Commit Message Guidelines

We follow the [Conventional Commits](https://www.conventionalcommits.org/) convention for all Git commit messages. This helps keep our history clean, readable, and automatable.

## 🔧 Format

```
<type>(optional scope): <short, imperative description>
```

## ✅ Examples

```
feat(login): add user authentication flow
fix(api): handle 500 error on GET /posts
docs: update README with setup instructions
```

## 📌 Rules

- Use the **imperative mood** (e.g., "add", not "added" or "adds")
- Keep messages as **short as possible, but as long as necessary**
- Capitalize the first word; **no period** at the end
- Prefer clarity over brevity

## 🔖 Common Types

- `feat`: a new feature
- `fix`: a bug fix
- `docs`: documentation-only changes
- `style`: formatting, whitespace, etc.
- `refactor`: code change that doesn’t add features or fix bugs
- `test`: adding or updating tests
- `chore`: tooling, CI, build-related changes
