#!/bin/sh

# Clear any existing commit message
echo "" > ~/aipack/tmp/commit-msg.txt

# Run the AIP script to generate commit message
aip run --single-shot ~/aipack/gen-commit

# Wait for the commit message file to be populated
while [ ! -s ~/aipack/tmp/commit-msg.txt ]; do
  sleep 0.1
done

# Commit with the generated message and open editor for review
git commit -m "$(cat ~/aipack/tmp/commit-msg.txt)" -e

# Clear the commit message file
echo "" > ~/aipack/tmp/commit-msg.txt
