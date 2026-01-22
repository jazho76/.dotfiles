#!/usr/bin/env sh

TASKS_FILE="$HOME/.config/tmux/quick_actions.txt"

menu_args=()

while IFS='|' read -r label key cmd; do
  [ -z "$label" ] && continue

  menu_args+=(
    "$label" "$key"
    "split-window -v -l 25% -c '#{pane_current_path}' '$cmd || exec \$SHELL'"
  )
done < "$TASKS_FILE"

tmux display-menu -T "Quick Actions" "${menu_args[@]}"

