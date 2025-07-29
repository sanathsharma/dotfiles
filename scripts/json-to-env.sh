#!/bin/sh
set -e

# Script to convert JSON file to environment variable mapping format
# Usage: ./json-to-env.sh <path_to_json_file>

if [ $# -eq 0 ]; then
    echo "Usage: $0 <path_to_json_file>"
    echo "Example: $0 config.json"
    exit 1
fi

JSON_FILE="$1"

if [ ! -f "$JSON_FILE" ]; then
    echo "Error: File '$JSON_FILE' does not exist"
    exit 1
fi

# Check if jq is installed
if ! command -v jq >/dev/null 2>&1; then
    echo "Error: jq is not installed. Please install jq first."
    exit 1
fi

# Convert JSON to environment variable format and copy to clipboard
# This handles nested objects by flattening them with underscore notation
ENV_OUTPUT=$(jq -r '
  def flatten:
    . as $in
    | reduce paths(scalars) as $p ({}; 
        . + { ($p | map(tostring) | join("_") | ascii_upcase): $in | getpath($p) }
      );
  flatten | to_entries[] | "\(.key)=\(.value)"
' "$JSON_FILE")

# Copy to clipboard based on OS
if command -v pbcopy >/dev/null 2>&1; then
    # macOS
    echo "$ENV_OUTPUT" | pbcopy
    echo "Environment variables copied to clipboard (macOS)"
elif command -v xclip >/dev/null 2>&1; then
    # Linux with xclip
    echo "$ENV_OUTPUT" | xclip -selection clipboard
    echo "Environment variables copied to clipboard (Linux)"
elif command -v wl-copy >/dev/null 2>&1; then
    # Linux with wl-clipboard (Wayland)
    echo "$ENV_OUTPUT" | wl-copy
    echo "Environment variables copied to clipboard (Wayland)"
else
    echo "No clipboard utility found. Output:"
    echo "$ENV_OUTPUT"
fi

