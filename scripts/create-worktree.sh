#!/bin/sh
set -e

# Interactive script to create a git worktree with a standardized naming convention.
# Worktree name format: {type_prefix}{repo_name}--{branch_part}
# e.g., fe__my-repo--some-feature

# Require a bare repo — worktrees must live inside the bare repo directory.
BARE_PATH=$(git worktree list | awk '/\(bare\)/{print $1}')

if [ -z "$BARE_PATH" ]; then
	echo "Error: no bare repo found in worktree list. Set up a bare repo before creating worktrees."
	exit 1
fi

# Get repo name (strip .git suffix if present), format with hyphens and lowercase
REPO_NAME=$(basename "$BARE_PATH" | sed 's/\.git$//')
REPO_NAME_FORMATTED=$(echo "$REPO_NAME" | tr ' _' '-' | tr '[:upper:]' '[:lower:]')

# Step 1: Ask project type
PROJECT_TYPE=$(printf "Monorepo\nFront-end\nBack-end" | fzf --reverse --info=inline --prompt="Project Type: " --height=6 --preview="" --multi=0)

if [ -z "$PROJECT_TYPE" ]; then
	echo "No project type selected. Exiting."
	exit 1
fi

case "$PROJECT_TYPE" in
	Monorepo) TYPE_PREFIX="mr__" ;;
	Front-end) TYPE_PREFIX="fe__" ;;
	Back-end) TYPE_PREFIX="be__" ;;
esac

# Steps 2 & 3: Build prefix: {type_prefix}{repo_name}--
WORKTREE_PREFIX="${TYPE_PREFIX}${REPO_NAME_FORMATTED}--"

# Step 4: Fetch latest remote branches then let user select
echo "Fetching remote branches..."
git fetch --prune

BASE_BRANCH=$(git branch -r | \
	sed 's/^[[:space:]]*//' | \
	sed 's|^origin/||' | \
	grep -v '^HEAD' | \
	sort -u | \
	fzf --reverse --info=inline --prompt="Base Branch: " --height=20 --preview="" --multi=0)

if [ -z "$BASE_BRANCH" ]; then
	echo "No base branch selected. Exiting."
	exit 1
fi

# Step 5: Create worktree on base branch or a new branch?
BRANCH_MODE=$(printf "use base branch\ncreate new branch" | fzf --reverse --info=inline --prompt="Worktree Mode: " --height=5 --preview="" --multi=0)

if [ -z "$BRANCH_MODE" ]; then
	echo "No mode selected. Exiting."
	exit 1
fi

if [ "$BRANCH_MODE" = "use base branch" ]; then
	FINAL_BRANCH="$BASE_BRANCH"
	NEW_BRANCH=false
else
	# Step 6: Ask for new branch name, prefilled with base branch name
	FINAL_BRANCH=$(gum input --value "$BASE_BRANCH" --placeholder "New branch name")
	if [ -z "$FINAL_BRANCH" ]; then
		echo "Branch name cannot be empty. Exiting."
		exit 1
	fi
	NEW_BRANCH=true
fi

# Step 7: Prepare last part of worktree name from branch name
# Remove feat/ or feature/ prefix if present, then format with hyphens
BRANCH_PART=$(echo "$FINAL_BRANCH" | sed 's|^feat/||' | sed 's|^feature/||')
BRANCH_PART=$(echo "$BRANCH_PART" | tr '/ _' '-' | tr '[:upper:]' '[:lower:]')

PREPARED_NAME="${WORKTREE_PREFIX}${BRANCH_PART}"

# Step 8: Confirm final worktree name with gum (prefilled)
FINAL_NAME=$(gum input --value "$PREPARED_NAME" --placeholder "Worktree directory name")

if [ -z "$FINAL_NAME" ]; then
	echo "Worktree name cannot be empty. Exiting."
	exit 1
fi

WORKTREE_PATH="${BARE_PATH}/${FINAL_NAME}"

echo ""
echo "Creating worktree:"
echo "  Path:   $WORKTREE_PATH"
echo "  Branch: $FINAL_BRANCH"

if [ "$NEW_BRANCH" = "true" ]; then
	echo "  Mode:   new branch from origin/$BASE_BRANCH"
	git worktree add "$WORKTREE_PATH" -b "$FINAL_BRANCH" "origin/$BASE_BRANCH"
else
	echo "  Mode:   checkout $BASE_BRANCH"
	git worktree add "$WORKTREE_PATH" "origin/$BASE_BRANCH"
fi

echo ""
echo "Worktree created at: $WORKTREE_PATH"

# Warn if HEAD is detached — means the branch is already checked out in another worktree
if ! git -C "$WORKTREE_PATH" symbolic-ref HEAD >/dev/null 2>&1; then
	DETACHED_COMMIT=$(git -C "$WORKTREE_PATH" rev-parse HEAD)
	echo ""
	echo "Warning: HEAD is detached in the new worktree. '$FINAL_BRANCH' may already be checked out in another worktree, so this worktree is pointing to commit $DETACHED_COMMIT."
fi
