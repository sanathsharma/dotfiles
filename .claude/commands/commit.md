Generate a conventional commit message for the staged changes.

## Steps

1. Run `git diff --cached` to get staged changes. If nothing is staged, say so and stop.

2. Run `git log --no-merges -10 --pretty=format:"%s"` to get recent commit history (skip merge commits). Use the first 5 non-merge messages.

3. Check if `scopes.txt` exists in the repo root — if so, read it for valid scope names.

4. Check if this is a monorepo by detecting top-level service directories (e.g., `apps/`, `packages/`, `services/`, `libs/`). If staged files are all under one service directory, prefer that directory name as the scope.

## Rules

**Format:** `[prefix] type(scope): description` — only include `[prefix]` and `(scope)` if applicable.

**Detect prefix:** If previous commits consistently use a prefix like `[acme]` or `[proj]`, include it.

**Types:** `feat`, `fix`, `docs`, `refactor`, `test`, `chore`, `perf`, `style`, `ci`, `build`

**Scope:** From `scopes.txt` if present, or monorepo service dir, or infer from changed files.

**Description:** Imperative, lowercase, no period, ≤72 chars total.

**Breaking change:** Append `!` after type/scope if breaking, add `BREAKING CHANGE:` footer.

## Examples

```
feat(auth): add OAuth2 login flow
fix(api): handle null response from payment gateway
chore: update dependencies
feat!: remove deprecated v1 endpoints

BREAKING CHANGE: /v1/* routes no longer exist
[acme] feat(dashboard): add export to CSV button
```

## Output structure

- First line: type(scope): description of the single most significant change
- Body (if multiple changes): bullet list of remaining changes with `-`, after a blank line
- Footer: `BREAKING CHANGE:` if applicable, after a blank line
- No markdown formatting in the output — no bold, no backticks, no headers, plain text only

Print only the raw commit message, nothing else — no explanation, no code fences, no labels.

Example output:
feat(auth): add OAuth2 login flow

- remove legacy session-based auth handler
- add refresh token rotation
- update auth middleware to validate JWT
