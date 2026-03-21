---
description: Generate a conventional commit message.
agent: build
model: opencode/glm-5
---

Generate a conventional commit message on my behalf for the staged changes.

**Instructions:**
1. Run `git log --no-merges -n 5` to see the last 5 commits for inspiration and style matching
2. Follow the same prefix/pattern (like [company-name]) used in previous commits if present
3. Use imperative mood: "add feature" not "adds feature" or "added feature"
4. Keep the subject line under 72 characters
5. The type and subject should reflect the major change; list other changes as bullet points in the body
6. Ignore lock files (package-lock.json, yarn.lock, Cargo.lock, pnpm-lock.yaml, etc.) when analyzing the diff for commit message generation

Output only the final commit message block.

