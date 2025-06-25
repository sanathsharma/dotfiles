#!/bin/sh
set -e

# This script is used to create a new git branch with a standardized naming convention.
# For feature/fix branches: <type>/<ticket>/<summary>
# For temporary branches: base-<current-branch>/<name>

echo "Welcome to branch-cli"

# Get current branch name from env or git
CURRENT_BRANCH=${BASE_BRANCH:-$(git rev-parse --abbrev-ref HEAD)}
echo "Creating new branch based off of: $CURRENT_BRANCH"
echo ""

# Get the branch type
TYPE=$(printf "feature\nfix\nfixes\npoc\ntemp\nrelease\nhotfix" | fzf --reverse --info=inline --prompt="Branch Type: " --height=10 --preview="" --multi=0)

if [ "$TYPE" = "temp" ]; then
	# Handle temp branch creation
	# Pre-populate with the complete temp branch format
	BRANCH_NAME=$(gum input --value "base-${CURRENT_BRANCH}/" --placeholder "Enter complete branch name")
	if [ -z "$BRANCH_NAME" ]; then
		echo "Branch name cannot be empty"
		exit 1
	fi
else
	# Get ticket ID (optional)
	TICKET=$(gum input --placeholder "Enter ticket ID (optional)")

	# Pre-populate the input with the type/ticket/ format
	if [ -n "$TICKET" ]; then
		SUMMARY=$(gum input --value "${TYPE}/${TICKET}/" --placeholder "Summary of this branch")
	else
		SUMMARY=$(gum input --value "${TYPE}/" --placeholder "Summary of this branch")
	fi

	if [ -z "$SUMMARY" ]; then
		echo "Summary cannot be empty"
		exit 1
	fi

	# Convert spaces to hyphens in summary
	SUMMARY=$(echo "$SUMMARY" | tr ' ' '-')

	# Use the entire input as branch name since it's pre-populated with the correct format
	BRANCH_NAME="$SUMMARY"
fi

# Create and checkout the new branch
echo "Creating branch: $BRANCH_NAME"
git checkout -b "$BRANCH_NAME" "$CURRENT_BRANCH"

echo "Successfully created and switched to branch: $BRANCH_NAME"
