#!/usr/bin/env bash
# Creates a standard set of windows based on the session name's prefix.
# Wired up via tmux's `session-created` hook, so it only runs once,
# right when a brand-new session is created (e.g. by `sesh connect`).

set -euo pipefail

session_name="$1"

case "$session_name" in
  be__*|mr__*)
    windows=(editor term agent dbui)
    ;;
  *)
    windows=(editor term agent)
    ;;
esac

# Find the actual index of the (single) window that already exists,
# regardless of base-index, and rename it to the first window we want.
first_win=$(tmux list-windows -t "$session_name" -F '#{window_index}' | head -1)
tmux rename-window -t "${session_name}:${first_win}" "${windows[0]}"

# Create the remaining windows.
for w in "${windows[@]:1}"; do
  tmux new-window -t "$session_name" -n "$w"
done

# Land back on the first window.
tmux select-window -t "${session_name}:${windows[0]}"
