#!/bin/sh
set -e

# Interactive branch checkout script using fzf
# Allows selection from both local and remote branches
# Usage: checkout-branch.sh [default_query]

# Parse optional argument for default query
DEFAULT_QUERY="$1"

echo "Select a branch to checkout:"

# Get all branches (local and remote), clean them up, and present via fzf
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
SELECTED_BRANCH=$(git branch -a | \
    sed 's/^[*+ ] //' | \
    sed 's/^remotes\///' | \
    grep -v '^HEAD' | \
    grep -v "^${CURRENT_BRANCH}$" | \
    sort -u | \
    fzf --reverse --info=inline --prompt="Branch: " --height=20 --preview="" --query="$DEFAULT_QUERY")

# Exit if no branch was selected
if [ -z "$SELECTED_BRANCH" ]; then
    echo "No branch selected. Exiting."
    exit 0
fi

# Store the original selected branch name before cleaning for remote tracking
ORIGINAL_SELECTED_BRANCH="$SELECTED_BRANCH"

# Determine the remote name and clean branch name
REMOTE_NAME=""
CLEAN_BRANCH="$SELECTED_BRANCH"

# Check if this is a remote branch and extract remote name
for remote in $(git remote); do
    if echo "$SELECTED_BRANCH" | grep -q "^${remote}/"; then
        REMOTE_NAME="$remote"
        CLEAN_BRANCH=$(echo "$SELECTED_BRANCH" | sed "s/^${remote}\///")
        break
    fi
done

# For non-origin remotes, add remote prefix to local branch name
if [ -n "$REMOTE_NAME" ] && [ "$REMOTE_NAME" != "origin" ]; then
    LOCAL_BRANCH_NAME="${REMOTE_NAME}-${CLEAN_BRANCH}"
else
    LOCAL_BRANCH_NAME="$CLEAN_BRANCH"
fi

echo "Switching to branch: $LOCAL_BRANCH_NAME"

# Check if the branch exists locally
if git show-ref --verify --quiet refs/heads/"$LOCAL_BRANCH_NAME"; then
    # Branch exists locally, just switch to it
    git switch "$LOCAL_BRANCH_NAME"
    
    # Show tracking information if available
    TRACKING_BRANCH=$(git rev-parse --abbrev-ref "$LOCAL_BRANCH_NAME"@{upstream} 2>/dev/null || echo "")
    if [ -n "$TRACKING_BRANCH" ]; then
        echo "Successfully switched to existing local branch: $LOCAL_BRANCH_NAME (tracking $TRACKING_BRANCH)"
    else
        echo "Successfully switched to existing local branch: $LOCAL_BRANCH_NAME (no upstream tracking)"
    fi
else
    # Branch doesn't exist locally, check if it was selected from remote
    if [ -n "$REMOTE_NAME" ]; then
        # This was a remote branch, create local branch with tracking
        git switch -c "$LOCAL_BRANCH_NAME" --track "$ORIGINAL_SELECTED_BRANCH"
        echo "Successfully created and switched to new branch: $LOCAL_BRANCH_NAME (tracking $ORIGINAL_SELECTED_BRANCH)"
    else
        # This was a local branch name that doesn't exist, create it
        git switch -c "$LOCAL_BRANCH_NAME"
        echo "Successfully created and switched to new branch: $LOCAL_BRANCH_NAME"
    fi
fi
