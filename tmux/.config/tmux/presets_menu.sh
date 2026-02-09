#!/usr/bin/env bash
set -euo pipefail

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PRESETS_DIR="$BASE_DIR/presets"

cd "$PRESETS_DIR" || {
  tmux display-message "Presets dir not found: $PRESETS_DIR"
  exit 1
}

items=()

for f in *; do
  [ -f "$f" ] || continue
  [ -x "$f" ] || continue
  items+=("$f" "" "run-shell -b \"$PRESETS_DIR/$f\"")
done

if [ ${#items[@]} -eq 0 ]; then
  tmux display-message "No executable preset in $PRESETS_DIR"
  exit 0
fi

tmux display-menu -T "Select Preset" "${items[@]}"

