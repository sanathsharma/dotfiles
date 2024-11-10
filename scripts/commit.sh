#!/bin/sh
set -e

# This script is used to write a conventional commit message.
# It prompts the user to choose the type of commit as specified in the
# conventional commit spec. And then prompts for the summary and detailed
# description of the message and uses the values provided. as the summary and
# details of the message.
#
# If you want to add a simpler version of this script to your dotfiles, use:
#
# alias gcm='git commit -m "$(gum input)" -m "$(gum write)"'

echo "Welcome to commit-cli"

if [ -z "$(git status -s -uno | grep -v '^ ' | awk '{print $2}')" ]; then
    gum confirm "Stage all?" && git add .
fi

# Print status
echo "Git status:"
echo ""
git status --porcelain
echo ""

TICKET=$(gum input --placeholder "ticket_id")
test -n "$TICKET" && TICKET="[$TICKET] "

TYPE=$(gum choose "fix" "feat" "docs" "style" "refactor" "test" "chore" "revert")

if test -f ./scopes.txt; then
	SCOPE=$(cat ./scopes.txt | gum choose)
else 
	SCOPE=$(gum input --placeholder "scope")
fi

# Since the scope is optional, wrap it in parentheses if it has a value.
if [ -n "$SCOPE" ] && [ "$SCOPE" != "none" ]; then
	SCOPE="($SCOPE)"
else
	SCOPE=""
fi

# Pre-populate the input with the [ticket_id] type(scope): so that the user may change it
SUMMARY=$(gum input --value "$TICKET$TYPE$SCOPE: " --placeholder "Summary of this change")
DESCRIPTION=$(gum write --placeholder "Details of this change")

echo "Any breaking changes?"
BREAKING_CHANGE=$(gum choose "yes" "no")

if test ["$BREAKING_CHANGE" = "yes"]; then 
	BREAKING_CHANGE_TEXT=$(gum input --placeholder "Enter breaking change desctiption")
	# Open the commit editor with the filled details
	git commit -m "$SUMMARY" -m "$DESCRIPTION" -m "BREAKING CHANGE: $BREAKING_CHANGE_TEXT" -e
else 
	# Open the commit editor with the filled details
	git commit -m "$SUMMARY" -m "$DESCRIPTION" -e
fi

