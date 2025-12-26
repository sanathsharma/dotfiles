#!/bin/sh

set -e

# Run opencode and extract commit message
COMMIT_MSG=$(opencode run --command commit --format json | jq -r 'select(.type == "text") | .part.text')

# Check if message was extracted
if [ -z "$COMMIT_MSG" ]; then
    echo "Error: No commit message generated"
    exit 1
fi

# Commit with editor
git commit -e -m "$COMMIT_MSG"
