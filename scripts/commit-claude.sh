#!/bin/bash

set -e

# Check for --no-verify flag
NO_VERIFY=""
if [ "$1" = "--no-verify" ]; then
	NO_VERIFY="--no-verify"
	echo "[debug] Using --no-verify flag"
fi

echo "[debug] Checking for staged changes..."
# Check if there are staged changes
if ! git diff --cached --quiet 2>/dev/null; then
	echo "[debug] Found staged changes"
else
	echo "Error: No staged changes to commit"
	exit 1
fi

echo "[debug] Generating commit message with Claude..."

# Call Claude Code slash command
COMMIT_MSG=$(echo "/commit" | claude --print --model sonnet 2>&1)

echo "[debug] Received response from Claude"

# Check if message was extracted
if [ -z "$COMMIT_MSG" ]; then
	echo "Error: No commit message generated"
	exit 1
fi

echo "[debug] Generated commit message:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "$COMMIT_MSG"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Ask for confirmation
printf "Do you want to proceed with this commit message? [Y/n] "
read -r response

# Default to 'yes' if user just presses Enter
if [ -z "$response" ]; then
	response="y"
fi

# Check response
case "$response" in
	[yY][eE][sS]|[yY])
		echo "[debug] Proceeding with commit..."
		;;
	*)
		echo "Commit cancelled by user"
		exit 0
		;;
esac

# Create temp file for commit message
TEMP_MSG=$(mktemp)
echo "$COMMIT_MSG" >"$TEMP_MSG"

echo "[debug] Opening editor for commit message review..."

# Commit with editor
git commit $NO_VERIFY -e -F "$TEMP_MSG"

# Clean up
rm "$TEMP_MSG"

echo "[debug] Commit successful!"
