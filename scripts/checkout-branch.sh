#!/bin/sh
set -e

# Interactive branch checkout script using fzf
# Allows selection from both local and remote branches

echo "Select a branch to checkout:"

# Get all branches (local and remote), clean them up, and present via fzf
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
SELECTED_BRANCH=$(git branch -a | \
    sed 's/^[* ] //' | \
    sed 's/^remotes\///' | \
    grep -v '^HEAD' | \
    grep -v "^${CURRENT_BRANCH}$" | \
    sort -u | \
    fzf --reverse --info=inline --prompt="Branch: " --height=20 --preview="")

# Exit if no branch was selected
if [ -z "$SELECTED_BRANCH" ]; then
    echo "No branch selected. Exiting."
    exit 0
fi

# Remove any remote prefix if present for cleaner checkout
# Get list of all remotes and remove any matching prefix
CLEAN_BRANCH="$SELECTED_BRANCH"
for remote in $(git remote); do
    CLEAN_BRANCH=$(echo "$CLEAN_BRANCH" | sed "s/^${remote}\///")
done

echo "Switching to branch: $CLEAN_BRANCH"

# Switch to the selected branch
git switch "$CLEAN_BRANCH"

echo "Successfully switched to branch: $CLEAN_BRANCH"
