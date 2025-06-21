#!/bin/sh

# Get the current working directory
CWD=$(pwd)

# Define the commit message file path using the current working directory
COMMIT_MSG_FILE="$CWD/tmp/commit-msg.txt"

# Create tmp directory if it doesn't exist
mkdir -p "$CWD/tmp"

# Clear any existing commit message
echo "" > "$COMMIT_MSG_FILE"

# Run the AIP script to generate commit message
aip run --single-shot ~/aipack/gen-commit

# Wait for the commit message file to be populated
while [ ! -s "$COMMIT_MSG_FILE" ]; do
  sleep 0.1
done

# Commit with the generated message and open editor for review
git commit -m "$(cat "$COMMIT_MSG_FILE")" -e

# Clear the commit message file
echo "" > "$COMMIT_MSG_FILE"
