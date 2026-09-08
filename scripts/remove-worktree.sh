#!/bin/sh
set -e

# Interactive script to remove a git worktree selected via fzf.

# Require a bare repo
BARE_PATH=$(git worktree list | awk '/\(bare\)/{print $1}')

if [ -z "$BARE_PATH" ]; then
	echo "Error: no bare repo found in worktree list. This script requires a bare repo setup."
	exit 1
fi

# Build a display list of non-bare worktrees with the bare path prefix stripped
WORKTREE_LIST=$(git worktree list | grep -v '(bare)' | sed "s|^${BARE_PATH}/||")

if [ -z "$WORKTREE_LIST" ]; then
	echo "No worktrees to remove."
	exit 0
fi

# Select a single worktree via fzf — show bare path as prompt context
SELECTED=$(echo "$WORKTREE_LIST" | \
	fzf --no-multi --reverse --info=inline --prompt="${BARE_PATH}/ > " --height=20 --preview="")

if [ -z "$SELECTED" ]; then
	echo "No worktree selected. Exiting."
	exit 0
fi

WORKTREE_PATH="${BARE_PATH}/$(echo "$SELECTED" | awk '{print $1}')"

echo ""
echo "Selected: $WORKTREE_PATH"

# Warn before confirm if there are uncommitted changes
DIRTY=$(git -C "$WORKTREE_PATH" status --porcelain 2>/dev/null)
if [ -n "$DIRTY" ]; then
	echo ""
	echo "Warning: this worktree has uncommitted changes:"
	echo "$DIRTY"
fi

# Confirm with gum
if ! gum confirm "Remove worktree at '$WORKTREE_PATH'?"; then
	echo "Aborted."
	exit 0
fi

# Attempt removal; retry with --force if it fails due to uncommitted changes
if ! git worktree remove "$WORKTREE_PATH" 2>/dev/null; then
	echo ""
	echo "Warning: worktree has uncommitted changes."
	if gum confirm "Force remove anyway?"; then
		git worktree remove --force "$WORKTREE_PATH"
	else
		echo "Aborted."
		exit 0
	fi
fi

git worktree prune

echo ""
echo "Worktree removed: $WORKTREE_PATH"
