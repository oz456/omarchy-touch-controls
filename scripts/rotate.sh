#!/bin/bash
# Cycles screen rotation and keeps touch/stylus inputs aligned.
# Because reading a document upside down is only fun for the first five seconds.

# Pick the internal laptop display (defaults to eDP-1 if detection fails)
MONITOR=$(hyprctl monitors -j 2>/dev/null | jq -r '.[] | select(.name | test("^eDP")) | .name' | head -n 1)
[ -z "$MONITOR" ] && MONITOR="eDP-1"

CURRENT_TRANSFORM=$(hyprctl monitors -j 2>/dev/null | jq -r --arg m "$MONITOR" '.[] | select(.name==$m) | .transform // 0' | head -n 1)
[ -z "$CURRENT_TRANSFORM" ] && CURRENT_TRANSFORM=0

# Preserve existing monitor scaling (fallback to 1 if unset)
SCALE=$(hyprctl monitors -j 2>/dev/null | jq -r --arg m "$MONITOR" '.[] | select(.name==$m) | .scale // 1' | head -n 1)
[ -z "$SCALE" ] && SCALE=1

# 0 -> 90 -> 180 -> 270 -> 0
NEXT=$(( (CURRENT_TRANSFORM + 1) % 4 ))

# Rotate the display
hyprctl eval "hl.monitor({ output = '$MONITOR', mode = 'preferred', position = 'auto', scale = $SCALE, transform = $NEXT })" >/dev/null 2>&1

# Sync generic Hyprland touch and tablet rules
hyprctl eval "hl.config({ input = { touchdevice = { transform = $NEXT, output = '$MONITOR' }, tablet = { transform = $NEXT, output = '$MONITOR' } } })" >/dev/null 2>&1

# Sync specific hardware digitizers and styluses currently attached
DEVICES=$(hyprctl devices -j 2>/dev/null)
if [ -n "$DEVICES" ]; then
  # Touchscreens
  echo "$DEVICES" | jq -r '.touch[]?.name // empty' | while read -r dev; do
    [ -n "$dev" ] && hyprctl eval "hl.device({ name = '$dev', output = '$MONITOR', transform = $NEXT })" >/dev/null 2>&1
  done

  # Styluses / graphics tablets
  echo "$DEVICES" | jq -r '.tablets[]?.name // empty' | while read -r dev; do
    [ -n "$dev" ] && hyprctl eval "hl.device({ name = '$dev', output = '$MONITOR', transform = $NEXT })" >/dev/null 2>&1
  done
fi
