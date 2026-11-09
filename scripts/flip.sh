#!/bin/bash
# Toggles internal keyboard lock for tablet mode.
# Because folding your laptop into a tablet shouldn't mean your lap types accidental gibberish into vim.

STATE_FILE="/tmp/omarchy_keyboard_locked"

# Discover internal AT keyboard or fallback to the standard x86 name
KBD=$(hyprctl devices -j 2>/dev/null | jq -r '.keyboards[]?.name | select(test("at-translated"))' | head -n 1)
[ -z "$KBD" ] && KBD="at-translated-set-2-keyboard"

if [ -f "$STATE_FILE" ]; then
  # Laptop mode: restore physical keyboard
  rm -f "$STATE_FILE"
  hyprctl eval "hl.device({ name = '$KBD', enabled = true })" >/dev/null 2>&1
else
  # Tablet mode: ignore physical keyboard presses
  touch "$STATE_FILE"
  hyprctl eval "hl.device({ name = '$KBD', enabled = false })" >/dev/null 2>&1
fi
