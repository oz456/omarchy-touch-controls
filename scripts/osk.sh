#!/bin/bash
# On-screen keyboard launcher & theme sync for wvkbd-mobintl.
# Typing on glass is bad enough; the least we can do is make it match your desktop palette.

export PATH="/usr/local/bin:/usr/bin:$PATH"
OSK_CMD="wvkbd-mobintl"
THEME_FILE="${XDG_STATE_HOME:-$HOME/.local/state}/omarchy/current/theme/colors.toml"
DIRTY_FLAG="/tmp/osk_theme_dirty"

get_theme_color() {
  local keys="$1"
  local default="$2"
  local val=""
  IFS="," read -ra key_list <<< "$keys"
  for k in "${key_list[@]}"; do
    val=$(awk -F= -v target="$k" '$1 ~ "^[[:space:]]*"target"[[:space:]]*$" { gsub(/[^0-9a-fA-F]/, "", $2); print $2; exit }' "$THEME_FILE" 2>/dev/null)
    if [ -n "$val" ]; then
      echo "$val"
      return 0
    fi
  done
  echo "$default"
}

start_osk() {
  local hidden_flag="$1"

  local c_bg c_fg c_fg_sp c_text c_accent c_press_text
  c_bg=$(get_theme_color "background" "1e1e2e")
  c_fg=$(get_theme_color "color8,dark_background,muted" "45475a")
  c_fg_sp=$(get_theme_color "color0,darker_background" "181825")
  c_text=$(get_theme_color "foreground,bright_foreground" "ffffff")
  c_accent=$(get_theme_color "accent,color4" "89b4fa")
  c_press_text=$(get_theme_color "selection_foreground,background" "1e1e2e")

  rm -f "$DIRTY_FLAG"

  nohup $OSK_CMD \
    $hidden_flag \
    -L 340 \
    -H 420 \
    -R 10 \
    --bg "$c_bg" \
    --fg "$c_fg" \
    --fg-sp "$c_fg_sp" \
    --text "$c_text" \
    --text-sp "$c_accent" \
    --press "$c_accent" \
    --press-sp "$c_accent" \
    --text-press "$c_press_text" \
    --text-press-sp "$c_press_text" >/dev/null 2>&1 &
  disown
}

action="${1:-toggle}"

case "$action" in
  reload)
    pkill -x "$OSK_CMD" 2>/dev/null || true
    rm -f "$DIRTY_FLAG"
    start_osk ""
    ;;

  show)
    if [ -f "$DIRTY_FLAG" ]; then
      pkill -x "$OSK_CMD" 2>/dev/null || true
      start_osk ""
    elif pgrep -x "$OSK_CMD" >/dev/null; then
      pkill -USR2 -x "$OSK_CMD"
    else
      start_osk ""
    fi
    ;;

  hide)
    if [ -f "$DIRTY_FLAG" ]; then
      pkill -x "$OSK_CMD" 2>/dev/null || true
      rm -f "$DIRTY_FLAG"
    elif pgrep -x "$OSK_CMD" >/dev/null; then
      pkill -USR1 -x "$OSK_CMD"
    fi
    ;;

  toggle|*)
    if [ -f "$DIRTY_FLAG" ]; then
      # Theme changed while keyboard was open -> close cleanly
      pkill -x "$OSK_CMD" 2>/dev/null || true
      rm -f "$DIRTY_FLAG"
    elif pgrep -x "$OSK_CMD" >/dev/null; then
      if hyprctl layers 2>/dev/null | grep -q "namespace: wvkbd"; then
        pkill -USR1 -x "$OSK_CMD"
      else
        pkill -USR2 -x "$OSK_CMD"
      fi
    else
      start_osk ""
    fi
    ;;
esac
