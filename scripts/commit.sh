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
    STAGE_OPTION=$(printf "Yes\nNo" | fzf --info=inline --prompt="Stage all? " --height=5 --preview="" --multi=0)
    if [ "$STAGE_OPTION" = "Yes" ]; then
        git add .
    fi
fi

# Print status
echo "Git status:"
echo ""
git status --porcelain
echo ""

TICKET=$(gum input --placeholder "ticket_id")
JIRA_LINK=""
if [ -n "$TICKET" ]; then
    # Extract ticket ID without brackets for the link
    TICKET_CLEAN=$(echo "$TICKET" | sed 's/[^A-Za-z0-9-]//g')
    JIRA_LINK="https://pyxispm.atlassian.net/browse/$TICKET_CLEAN"
    TICKET="[$TICKET] "
fi

TYPE=$(printf "fix\nfeat\nenhance\ndocs\nstyle\nrefactor\ntest\nchore\nrevert\nbuild" | fzf --info=inline --prompt="Commit Type: " --height=12 --preview="" --multi=0)

if test -f ./scopes.txt; then
	SCOPE=$(cat ./scopes.txt | fzf --info=inline --prompt="Scope: " --height=15 --preview="" --multi=0)
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

# Ask user if they want to include Jira link
if [ -n "$JIRA_LINK" ]; then
    JIRA_OPTION=$(printf "Yes\nNo" | fzf --info=inline --prompt="Include Jira link in commit? " --height=5 --preview="" --multi=0)
    if [ "$JIRA_OPTION" = "Yes" ]; then
        DESCRIPTION=$(printf "%s\n\nJira: %s" "$DESCRIPTION" "$JIRA_LINK")
    fi
fi

BREAKING_OPTION=$(printf "No\nYes" | fzf --info=inline --prompt="Any breaking changes? " --height=5 --preview="" --multi=0)
if [ "$BREAKING_OPTION" = "Yes" ]; then
    BREAKING_CHANGE_TEXT=$(gum input --placeholder "Enter breaking change description")
    # Open the commit editor with the filled details
    git commit -m "$SUMMARY" -m "$DESCRIPTION" -m "BREAKING CHANGE: $BREAKING_CHANGE_TEXT" -e
else
    # Open the commit editor with the filled details
    git commit -m "$SUMMARY" -m "$DESCRIPTION" -e
fi
