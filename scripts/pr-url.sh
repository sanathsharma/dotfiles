#!/bin/sh
set -e

# This script creates a GitHub PR URL for a selected branch and copies it to clipboard.
# It allows interactive selection of branches and handles both macOS and Linux clipboard.

echo "Welcome to GitHub PR URL Generator"

# Check if we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "Error: Not in a git repository"
    exit 1
fi

# Get the remote origin URL and extract GitHub repo info
REMOTE_URL=$(git config --get remote.origin.url 2>/dev/null || echo "")
if [ -z "$REMOTE_URL" ]; then
    echo "Error: No remote origin found"
    exit 1
fi

# Extract GitHub repo info from different URL formats
# Handle both SSH (git@github.com:user/repo.git) and HTTPS (https://github.com/user/repo.git)
if echo "$REMOTE_URL" | grep -q "github.com"; then
    if echo "$REMOTE_URL" | grep -q "^git@"; then
        # SSH format: git@github.com:user/repo.git
        REPO_INFO=$(echo "$REMOTE_URL" | sed 's/git@github.com://' | sed 's/\.git$//')
    else
        # HTTPS format: https://github.com/user/repo.git
        REPO_INFO=$(echo "$REMOTE_URL" | sed 's|https://github.com/||' | sed 's/\.git$//')
    fi
else
    echo "Error: Remote origin is not a GitHub repository"
    exit 1
fi

echo "Repository: $REPO_INFO"
echo ""

# Get current branch (the branch we want to create PR from)
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
if [ "$CURRENT_BRANCH" = "HEAD" ]; then
    echo "Error: You are in detached HEAD state. Please checkout a branch first."
    exit 1
fi

echo "Creating PR from current branch: $CURRENT_BRANCH"
echo ""

# Fetch all branches once
# echo "Fetching branches..."
# git fetch --all --quiet 2>/dev/null || true

# Get all branches, remove duplicates, and clean up the format
ALL_BRANCHES=$(git branch -a | sed 's/^[*+ ] //' | sed 's|remotes/origin/||' | grep -v '^HEAD' | sort -u)

if [ -z "$ALL_BRANCHES" ]; then
    echo "Error: No branches found"
    exit 1
fi

# Ask if user wants to change the current branch using fzf
echo "Select an option:"
OPTION=$(printf "Use current branch: %s\nSelect different branch" "$CURRENT_BRANCH" | fzf --reverse --info=inline --prompt="Option: " --height=5 --preview="" --multi=0)

if echo "$OPTION" | grep -q "Select different branch"; then
    echo "Select branch to create PR from:"
    SELECTED_BRANCH=$(echo "$ALL_BRANCHES" | fzf --reverse --info=inline --prompt="PR Branch: " --height=20 --preview="" --multi=0)
    
    if [ -z "$SELECTED_BRANCH" ]; then
        echo "No branch selected, using current branch: $CURRENT_BRANCH"
        PR_BRANCH="$CURRENT_BRANCH"
    else
        PR_BRANCH="$SELECTED_BRANCH"
        echo "Selected branch: $PR_BRANCH"
    fi
else
    PR_BRANCH="$CURRENT_BRANCH"
fi

echo ""

# Filter out the PR branch from available base branches
BRANCHES=$(echo "$ALL_BRANCHES" | grep -v "^$PR_BRANCH$")

if [ -z "$BRANCHES" ]; then
    echo "Error: No other branches found to merge into"
    exit 1
fi

# Let user select a BASE branch using fzf
echo "Select base branch to merge INTO:"
BASE_BRANCH=$(echo "$BRANCHES" | fzf --reverse --info=inline --prompt="Base Branch: " --height=20 --preview="" --multi=0)

if [ -z "$BASE_BRANCH" ]; then
    echo "No base branch selected"
    exit 1
fi

# Construct the final URL
PR_URL="https://github.com/${REPO_INFO}/compare/${BASE_BRANCH}...${PR_BRANCH}?expand=1"

echo ""
echo "Generated PR URL:"
echo "$PR_URL"
echo ""

# Copy to clipboard based on OS
if command -v pbcopy > /dev/null 2>&1; then
    # macOS
    echo "$PR_URL" | pbcopy
    echo "✅ URL copied to clipboard (macOS)"
elif command -v xclip > /dev/null 2>&1; then
    # Linux with xclip
    echo "$PR_URL" | xclip -selection clipboard
    echo "✅ URL copied to clipboard (Linux - xclip)"
elif command -v xsel > /dev/null 2>&1; then
    # Linux with xsel
    echo "$PR_URL" | xsel --clipboard --input
    echo "✅ URL copied to clipboard (Linux - xsel)"
elif command -v wl-copy > /dev/null 2>&1; then
    # Wayland
    echo "$PR_URL" | wl-copy
    echo "✅ URL copied to clipboard (Wayland)"
else
    echo "⚠️  Could not copy to clipboard. Please copy the URL manually."
    echo "Install one of: pbcopy (macOS), xclip, xsel, or wl-copy (Linux)"
fi

echo ""
echo "You can now paste the URL in your browser to create a new PR!"
