#!/usr/bin/env bash
set -euo pipefail

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LAYOUT_DIR="$BASE_DIR/layouts"

cd "$LAYOUT_DIR" || {
  tmux display-message "Layouts dir not found: $LAYOUT_DIR"
  exit 1
}

items=()

for f in *; do
  [ -f "$f" ] || continue
  [ -x "$f" ] || continue
  items+=("$f" "" "run-shell -b \"$LAYOUT_DIR/$f\"")
done

if [ ${#items[@]} -eq 0 ]; then
  tmux display-message "No executable layouts in $LAYOUT_DIR"
  exit 0
fi

tmux display-menu -T "Select Layout" "${items[@]}"

