#!/bin/sh

set -e

# Check for --no-verify flag
NO_VERIFY=""
if [ "$1" = "--no-verify" ]; then
    NO_VERIFY="--no-verify"
fi

# Run opencode and extract commit message
COMMIT_MSG=$(opencode run --command commit --format json | jq -r 'select(.type == "text") | .part.text')

# Check if message was extracted
if [ -z "$COMMIT_MSG" ]; then
    echo "Error: No commit message generated"
    exit 1
fi

# Commit with editor
git commit $NO_VERIFY -e -m "$COMMIT_MSG"
