#!/bin/sh
set -e

# This script allows you to search and select a branch name and copy it to clipboard.
# Useful for quickly getting branch names for git operations.

echo "Welcome to Branch Name Copier"

# Check if we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "Error: Not in a git repository"
    exit 1
fi

# Function to select a branch using fzf
select_branch() {
    # Fetch all branches
    # echo "Fetching branches..."
    # git fetch --all --quiet 2>/dev/null || true

    # Get all branches, remove duplicates, and clean up the format
    ALL_BRANCHES=$(git branch -a | sed 's/^[*+ ] //' | sed 's|remotes/origin/||' | grep -v '^HEAD' | sort -u)

    if [ -z "$ALL_BRANCHES" ]; then
        echo "Error: No branches found"
        exit 1
    fi

    # Let user select a branch using fzf
    echo "Select branch to copy:"
    SELECTED_BRANCH=$(echo "$ALL_BRANCHES" | fzf --reverse --info=inline --prompt="Branch: " --height=20 --preview="" --multi=0)

    if [ -z "$SELECTED_BRANCH" ]; then
        echo "No branch selected"
        exit 1
    fi
    
    echo "Selected branch: $SELECTED_BRANCH"
}

# Get current branch
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
IN_DETACHED_HEAD=false

if [ "$CURRENT_BRANCH" = "HEAD" ]; then
    echo "You are in detached HEAD state."
    echo "Skipping current branch option - showing all branches for selection."
    echo ""
    IN_DETACHED_HEAD=true
else
    echo "Current branch: $CURRENT_BRANCH"
    echo ""
fi

# Ask if user wants to copy current branch or search for another (skip if in detached HEAD)
if [ "$IN_DETACHED_HEAD" = "false" ]; then
    COPY_OPTION=$(printf "Copy current branch: %s\nSelect different branch" "$CURRENT_BRANCH" | fzf --reverse --info=inline --prompt="Option: " --height=5 --preview="" --multi=0)
    if echo "$COPY_OPTION" | grep -q "Copy current branch"; then
        SELECTED_BRANCH="$CURRENT_BRANCH"
        echo "Using current branch: $SELECTED_BRANCH"
    else
        select_branch
    fi
else
    select_branch
fi

echo ""
echo ""

# Copy to clipboard based on OS
if command -v pbcopy > /dev/null 2>&1; then
    # macOS
    printf "%s" "$SELECTED_BRANCH" | pbcopy
    echo "✅ Branch name copied to clipboard (macOS)"
elif command -v xclip > /dev/null 2>&1; then
    # Linux with xclip
    printf "%s" "$SELECTED_BRANCH" | xclip -selection clipboard
    echo "✅ Branch name copied to clipboard (Linux - xclip)"
elif command -v xsel > /dev/null 2>&1; then
    # Linux with xsel
    printf "%s" "$SELECTED_BRANCH" | xsel --clipboard --input
    echo "✅ Branch name copied to clipboard (Linux - xsel)"
elif command -v wl-copy > /dev/null 2>&1; then
    # Wayland
    printf "%s" "$SELECTED_BRANCH" | wl-copy
    echo "✅ Branch name copied to clipboard (Wayland)"
else
    echo "⚠️  Could not copy to clipboard. Please copy the branch name manually."
    echo "Install one of: pbcopy (macOS), xclip, xsel, or wl-copy (Linux)"
fi

echo ""
echo "You can now paste the branch name wherever needed!"
