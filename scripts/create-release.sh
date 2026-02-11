#!/bin/sh
set -e

# This script creates a git tag and GitHub release after ensuring all commits are synced.
# Usage: ./create-release.sh [tag-name] [branch-name]
# If arguments are not provided, the script will prompt for them.

echo "=== Git Tag & GitHub Release Creator ==="
echo ""

# Check if gh CLI is installed
if ! command -v gh >/dev/null 2>&1; then
	echo "Error: GitHub CLI (gh) is not installed."
	echo "Install it from: https://cli.github.com/"
	exit 1
fi

# Check if we're in a git repository
if ! git rev-parse --git-dir >/dev/null 2>&1; then
	echo "Error: Not in a git repository"
	exit 1
fi

# Get tag name from argument or prompt
if [ -n "$1" ]; then
	TAG_NAME="$1"
else
	TAG_NAME=$(gum input --placeholder "Enter tag name (e.g., v1.0.0)")
	if [ -z "$TAG_NAME" ]; then
		echo "Error: Tag name cannot be empty"
		exit 1
	fi
fi

# Get branch name from argument or prompt with fzf
if [ -n "$2" ]; then
	BRANCH_NAME="$2"
else
	# Get current branch
	CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
	if [ "$CURRENT_BRANCH" = "HEAD" ]; then
		echo "Error: You are in detached HEAD state. Please checkout a branch first."
		exit 1
	fi

	echo ""
	echo "Select branch for release:"
	echo "Current branch: $CURRENT_BRANCH"
	echo ""

	# Ask if user wants to use current branch or select different one
	OPTION=$(printf "Use current branch: %s\nSelect different branch" "$CURRENT_BRANCH" | fzf --reverse --info=inline --prompt="Branch Option: " --height=5 --preview="" --multi=0)

	if echo "$OPTION" | grep -q "Select different branch"; then
		# Get all branches
		ALL_BRANCHES=$(git branch -a | sed 's/^[*+ ] //' | sed 's|remotes/origin/||' | grep -v '^HEAD' | sort -u)

		if [ -z "$ALL_BRANCHES" ]; then
			echo "Error: No branches found"
			exit 1
		fi

		echo "Select branch to create release from:"
		BRANCH_NAME=$(echo "$ALL_BRANCHES" | fzf --reverse --info=inline --prompt="Release Branch: " --height=20 --preview="" --multi=0)

		if [ -z "$BRANCH_NAME" ]; then
			echo "No branch selected, using current branch: $CURRENT_BRANCH"
			BRANCH_NAME="$CURRENT_BRANCH"
		else
			echo "Selected branch: $BRANCH_NAME"
		fi
	else
		BRANCH_NAME="$CURRENT_BRANCH"
		echo "Using current branch: $BRANCH_NAME"
	fi
fi

echo ""
echo "Branch: $BRANCH_NAME"
echo "Tag: $TAG_NAME"
echo ""

# Check if tag already exists locally
if git rev-parse "$TAG_NAME" >/dev/null 2>&1; then
	echo "Error: Tag '$TAG_NAME' already exists locally"
	exit 1
fi

# Check if tag already exists on remote
if git ls-remote --tags origin | grep -q "refs/tags/$TAG_NAME"; then
	echo "Error: Tag '$TAG_NAME' already exists on remote"
	exit 1
fi

# Ensure we're on the correct branch
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
if [ "$CURRENT_BRANCH" != "$BRANCH_NAME" ]; then
	echo "Switching to branch: $BRANCH_NAME"
	git checkout "$BRANCH_NAME"
fi

# Fetch latest changes from remote
echo "Fetching latest changes from remote..."
git fetch origin "$BRANCH_NAME"

# Check if local branch is behind remote
LOCAL=$(git rev-parse @)
REMOTE=$(git rev-parse "@{u}" 2>/dev/null || echo "")
BASE=$(git merge-base @ "@{u}" 2>/dev/null || echo "")

if [ -n "$REMOTE" ]; then
	if [ "$LOCAL" != "$REMOTE" ]; then
		if [ "$LOCAL" = "$BASE" ]; then
			echo "Local branch is behind remote. Pulling changes..."
			git pull origin "$BRANCH_NAME"
			echo "✅ Successfully pulled latest changes"
		elif [ "$REMOTE" = "$BASE" ]; then
			echo ""
			echo "⚠️  Local branch is ahead of remote."
			echo "Please push your changes before creating a release:"
			echo "  git push origin $BRANCH_NAME"
			echo ""
			exit 1
		else
			echo "Error: Local and remote branches have diverged."
			echo "Please resolve this manually before creating a release."
			exit 1
		fi
	else
		echo "Branch is up to date with remote."
	fi
else
	echo ""
	echo "⚠️  Branch has no upstream tracking."
	echo "Please push your branch first:"
	echo "  git push -u origin $BRANCH_NAME"
	echo ""
	exit 1
fi

echo ""
echo "All commits are synced with remote."
echo ""

# Ask for tag message
echo "Enter tag message (optional):"
TAG_MESSAGE=$(gum input --placeholder "Tag message")

# Create the tag
if [ -n "$TAG_MESSAGE" ]; then
	echo "Creating annotated tag: $TAG_NAME"
	git tag -a "$TAG_NAME" -m "$TAG_MESSAGE"
else
	echo "Creating lightweight tag: $TAG_NAME"
	git tag "$TAG_NAME"
fi

# Push the tag to remote
echo "Pushing tag to remote..."
git push origin "$TAG_NAME"

echo ""
echo "Tag created successfully!"
echo ""

# Ask if user wants to create a GitHub release
echo "Create GitHub release? (y/n)"
CREATE_RELEASE=$(gum choose "yes" "no")

if [ "$CREATE_RELEASE" = "yes" ]; then
	echo ""
	echo "=== Creating GitHub Release ==="
	echo ""

	# Ask for release title
	RELEASE_TITLE=$(gum input --value "$TAG_NAME" --placeholder "Release title")
	if [ -z "$RELEASE_TITLE" ]; then
		RELEASE_TITLE="$TAG_NAME"
	fi

	# Ask for release type
	echo "Select release type:"
	RELEASE_TYPE=$(gum choose "Latest release" "Pre-release" "Draft")

	# Generate release notes options
	echo ""
	echo "Release notes:"
	NOTES_OPTION=$(gum choose "Auto-generate from commits" "Write manually" "Use tag message" "Skip (empty notes)")

	RELEASE_NOTES=""
	case "$NOTES_OPTION" in
		"Auto-generate from commits")
			# Let gh auto-generate notes
			GH_NOTES_FLAG="--generate-notes"
			;;
		"Write manually")
			echo ""
			echo "Enter release notes (Ctrl+D when done):"
			RELEASE_NOTES=$(gum write --placeholder "Enter release notes...")
			GH_NOTES_FLAG=""
			;;
		"Use tag message")
			if [ -n "$TAG_MESSAGE" ]; then
				RELEASE_NOTES="$TAG_MESSAGE"
			fi
			GH_NOTES_FLAG=""
			;;
		"Skip (empty notes)")
			RELEASE_NOTES=""
			GH_NOTES_FLAG=""
			;;
	esac

	# Build gh release create command
	GH_CMD="gh release create $TAG_NAME --title \"$RELEASE_TITLE\""

	case "$RELEASE_TYPE" in
		"Pre-release")
			GH_CMD="$GH_CMD --prerelease"
			;;
		"Draft")
			GH_CMD="$GH_CMD --draft"
			;;
	esac

	if [ -n "$GH_NOTES_FLAG" ]; then
		GH_CMD="$GH_CMD $GH_NOTES_FLAG"
	elif [ -n "$RELEASE_NOTES" ]; then
		# Write notes to a temporary file
		NOTES_FILE=$(mktemp)
		echo "$RELEASE_NOTES" > "$NOTES_FILE"
		GH_CMD="$GH_CMD --notes-file \"$NOTES_FILE\""
	else
		GH_CMD="$GH_CMD --notes \"\""
	fi

	# Execute the command
	echo ""
	echo "Creating GitHub release..."
	eval "$GH_CMD"

	# Clean up temp file if created
	if [ -n "$NOTES_FILE" ] && [ -f "$NOTES_FILE" ]; then
		rm "$NOTES_FILE"
	fi

	echo ""
	echo "GitHub release created successfully!"

	# Show the release URL
	RELEASE_URL=$(gh release view "$TAG_NAME" --json url -q .url)
	echo "Release URL: $RELEASE_URL"
else
	echo ""
	echo "Skipping GitHub release creation."
fi

echo ""
echo "=== Done! ==="
echo "Tag: $TAG_NAME"
echo "Branch: $BRANCH_NAME"
