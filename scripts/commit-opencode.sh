#!/bin/sh

set -e

MODEL="opencode/minimax-m2.5-free"

NO_VERIFY=""
if [ "$1" = "--no-verify" ]; then
	NO_VERIFY="--no-verify"
fi

STAGED_DIFF=$(git diff --cached)
UNSTAGED=$(git diff)

if [ -z "$STAGED_DIFF" ]; then
	STAGE=$(printf "Yes\nNo" | fzf --reverse --info=inline --prompt="Stage all changes? " --height=5 --preview="" --no-multi)
	[ "$STAGE" = "Yes" ] && git add .
fi

STAGED_DIFF=$(git diff --cached)

if [ -z "$STAGED_DIFF" ]; then
	echo "Error: No staged changes found"
	exit 1
fi

RECENT_LOGS=$(git log --no-merges -n 5)

PROMPT="Generate a conventional commit message for these staged changes.

Recent commits for style reference:
$RECENT_LOGS

Instructions:
- Use imperative mood (add feature, not adds feature)
- Keep subject under 72 characters
- Output ONLY the commit message, no explanation or code blocks"

COMMIT_MSG=$(opencode run "$PROMPT" -m "$MODEL" --format json 2>&1 | jq -r 'select(.type == "text") | .part.text')

if [ -z "$COMMIT_MSG" ]; then
	echo "Error: No commit message generated"
	exit 1
fi

echo "Generated commit message:"
echo ""
echo "$COMMIT_MSG"
echo ""

CONFIRM=$(printf "Yes\nNo" | fzf --reverse --info=inline --prompt="Open in editor? " --height=5 --preview="" --no-multi)

if [ "$CONFIRM" = "Yes" ]; then
	git commit $NO_VERIFY -e -m "$COMMIT_MSG"
else
	echo "Commit cancelled"
	exit 0
fi
