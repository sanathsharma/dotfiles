#!/bin/sh
set -e

# Script to select a git commit and copy its URL to the clipboard.
# Uses gum for interactive selection.

# 1. Get commit list
# Format: <short_hash> - <subject>
COMMIT_LOG_OUTPUT=$(git log --pretty=format:"%h - %s" -n 30 --no-merges)

if [ -z "$COMMIT_LOG_OUTPUT" ]; then
    gum style --bold --foreground="red" "No commits found in the current repository."
    exit 1
fi

# 2. Use gum filter to select a commit
SELECTED_LINE=$(echo "$COMMIT_LOG_OUTPUT" | gum filter --height 15 --placeholder "Select a commit...")

if [ -z "$SELECTED_LINE" ]; then
    gum style --foreground="yellow" "No commit selected. Exiting."
    exit 0
fi

# 3. Extract commit hash
COMMIT_HASH=$(echo "$SELECTED_LINE" | awk '{print $1}')

# 4. Determine remote URL
RAW_REMOTE_URL=$(git remote get-url origin 2>/dev/null)

if [ -z "$RAW_REMOTE_URL" ]; then
    gum style --bold --foreground="red" "Error: Could not determine remote URL for 'origin'."
    gum style --foreground="yellow" "Please ensure the 'origin' remote is configured for this repository."
    exit 1
fi

# 5. Extract GitHub repo info and construct commit URL
# Handle both SSH (git@github.com:user/repo.git) and HTTPS (https://github.com/user/repo.git)
if echo "$RAW_REMOTE_URL" | grep -q "github.com"; then
    if echo "$RAW_REMOTE_URL" | grep -q "^git@"; then
        # SSH format: git@github.com:user/repo.git
        REPO_INFO=$(echo "$RAW_REMOTE_URL" | sed 's/git@github.com://' | sed 's/\.git$//')
    else
        # HTTPS format: https://github.com/user/repo.git
        REPO_INFO=$(echo "$RAW_REMOTE_URL" | sed 's|https://github.com/||' | sed 's/\.git$//')
    fi
else
    gum style --bold --foreground="red" "Error: Remote URL is not a GitHub repository."
    gum style --foreground="yellow" "Remote URL: $RAW_REMOTE_URL"
    exit 1
fi

# Construct the commit URL
FINAL_COMMIT_URL="https://github.com/${REPO_INFO}/commit/${COMMIT_HASH}"

# 6. Copy to clipboard and provide feedback
echo ""
echo "Generated Commit URL:"
echo "$FINAL_COMMIT_URL"
echo ""

# Copy to clipboard based on OS
if command -v pbcopy > /dev/null 2>&1; then
    # macOS
    echo "$FINAL_COMMIT_URL" | pbcopy
    echo "✅ URL copied to clipboard (macOS)"
elif command -v xclip > /dev/null 2>&1; then
    # Linux with xclip
    echo "$FINAL_COMMIT_URL" | xclip -selection clipboard
    echo "✅ URL copied to clipboard (Linux - xclip)"
elif command -v xsel > /dev/null 2>&1; then
    # Linux with xsel
    echo "$FINAL_COMMIT_URL" | xsel --clipboard --input
    echo "✅ URL copied to clipboard (Linux - xsel)"
elif command -v wl-copy > /dev/null 2>&1; then
    # Wayland
    echo "$FINAL_COMMIT_URL" | wl-copy
    echo "✅ URL copied to clipboard (Wayland)"
else
    echo "⚠️  Could not copy to clipboard. Please copy the URL manually."
    echo "Install one of: pbcopy (macOS), xclip, xsel, or wl-copy (Linux)"
fi

echo ""
echo "You can now paste the URL in your browser to view the commit!"

exit 0
