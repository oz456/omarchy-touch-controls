#!/bin/bash
# Prepares the on-screen keyboard for an Omarchy theme switch without flickering.

export PATH="/usr/local/bin:/usr/bin:$PATH"

if pgrep -x "wvkbd-mobintl" >/dev/null; then
  # If open on screen, don't interrupt typing. Flag for refresh on next toggle.
  if hyprctl layers 2>/dev/null | grep -q "namespace: wvkbd"; then
    touch /tmp/osk_theme_dirty
  else
    # If hidden in the background, exit cleanly so next open loads fresh colors.
    pkill -x "wvkbd-mobintl"
  fi
fi
