#!/bin/bash

# The name of the application to toggle
APP_NAME="Notes"

# The directory where the state file will be stored
STATE_DIR="/Users/tadeucbmad/dotfiles/.config/aerospace/scripts/state"
mkdir -p "$STATE_DIR"

# The state file path
STATE_FILE="$STATE_DIR/app_toggle_state"

echo "Activating $APP_NAME..."
# Activate Notes application
osascript -e 'tell application "Notes" to activate'

echo "Waiting for $APP_NAME to be focused..."
# Wait until Notes is the focused application
while true; do
  CURRENT_FOCUSED_APP_NAME=$(aerospace list-windows --focused | awk -F '|' '{print $2}' | tr -d ' ')
  echo "Current focused app: $CURRENT_FOCUSED_APP_NAME"
  if [ "$CURRENT_FOCUSED_APP_NAME" == "$APP_NAME" ]; then
    echo "$APP_NAME is focused."
    break
  fi
  sleep 0.5
done

echo "Getting focused window ID and app name..."
# Get the focused window
FOCUSED_WINDOW_ID=$(aerospace list-windows --focused | awk -F '|' '{print $1}' | tr -d ' ')
FOCUSED_WINDOW_APP_NAME=$(aerospace list-windows --all | grep "^$FOCUSED_WINDOW_ID " | awk -F '|' '{print $2}' | tr -d ' ')
echo "FOCUSED_WINDOW_ID: $FOCUSED_WINDOW_ID"
echo "FOCUSED_WINDOW_APP_NAME: $FOCUSED_WINDOW_APP_NAME"

# If the focused window is not the app we want to toggle, check if there is a toggled window
if [ "$FOCUSED_WINDOW_APP_NAME" != "$APP_NAME" ]; then
  echo "Focused window is not $APP_NAME. Checking state file..."
  # If the state file exists, it means there is a toggled window
  if [ -f "$STATE_FILE" ]; then
    echo "State file exists. Restoring window..."
    # Get the window ID and its original geometry from the state file
    WINDOW_ID=$(cat "$STATE_FILE" | awk '{print $1}')
    ORIGINAL_GEOMETRY=$(cat "$STATE_FILE" | cut -d' ' -f2-)
    echo "Restoring WINDOW_ID: $WINDOW_ID with ORIGINAL_GEOMETRY: $ORIGINAL_GEOMETRY"

    # Restore the window to its original geometry
    aerospace move-node-to-workspace $(aerospace list-windows --all | grep "^$WINDOW_ID " | awk -F '|' '{print $3}' | tr -d ' ')
    aerospace layout tiling

    # Remove the state file
    rm "$STATE_FILE"
  else
    echo "State file does not exist. Exiting."
  fi
  exit 0
fi

echo "Focused window is $APP_NAME."
# If the state file exists, it means the window is in the toggled state
if [ -f "$STATE_FILE" ]; then
  echo "State file exists. Restoring window..."
  # Get the window ID and its original geometry from the state file
  WINDOW_ID=$(cat "$STATE_FILE" | awk '{print $1}')
  ORIGINAL_GEOMETRY=$(cat "$STATE_FILE" | cut -d' ' -f2-)
  echo "Restoring WINDOW_ID: $WINDOW_ID with ORIGINAL_GEOMETRY: $ORIGINAL_GEOMETRY"

  # Restore the window to its original geometry
  aerospace move-node-to-workspace $(aerospace list-windows --all | grep "^$WINDOW_ID " | awk -F '|' '{print $3}' | tr -d ' ')
  aerospace layout tiling

  # Remove the state file
  rm "$STATE_FILE"
else
  echo "State file does not exist. Toggling window..."
  # Get the focused window ID
  WINDOW_ID=$(aerospace list-windows --focused | awk -F '|' '{print $1}' | tr -d ' ')
  echo "WINDOW_ID for toggling: $WINDOW_ID"

  # Get the window's geometry
  ORIGINAL_GEOMETRY=$(aerospace list-windows --all | grep "^$WINDOW_ID " | awk -F '|' '{print $4}' | tr -d ' ')
  echo "ORIGINAL_GEOMETRY: $ORIGINAL_GEOMETRY"

  # Store the window ID and its original geometry in the state file
  echo "$WINDOW_ID $ORIGINAL_GEOMETRY" >"$STATE_FILE"
  echo "State saved to $STATE_FILE"

  # Get the focused monitor's resolution using osascript
  MONITOR_BOUNDS=$(osascript -e 'tell application "Finder" to get bounds of window of desktop')
  MONITOR_WIDTH=$(echo "$MONITOR_BOUNDS" | awk -F ', ' '{print $3}')
  MONITOR_HEIGHT=$(echo "$MONITOR_BOUNDS" | awk -F ', ' '{print $4}')
  echo "MONITOR_WIDTH: $MONITOR_WIDTH, MONITOR_HEIGHT: $MONITOR_HEIGHT"

  # Get the window's size
  WINDOW_GEOMETRY=$(aerospace list-windows --all | grep "^$WINDOW_ID " | awk -F '|' '{print $4}' | tr -d ' ')
  WINDOW_WIDTH=$(echo "$WINDOW_GEOMETRY" | awk '{print $3}')
  WINDOW_HEIGHT=$(echo "$WINDOW_GEOMETRY" | awk '{print $4}')
  echo "WINDOW_WIDTH: $WINDOW_WIDTH, WINDOW_HEIGHT: $WINDOW_HEIGHT"

  # Calculate the new window position
  NEW_X=$(((MONITOR_WIDTH - WINDOW_WIDTH) / 2))
  NEW_Y=$(((MONITOR_HEIGHT - WINDOW_HEIGHT) / 2))
  echo "NEW_X: $NEW_X, NEW_Y: $NEW_Y"

  # Center and float the window
  aerospace layout floating
  aerospace move-window $NEW_X $NEW_Y
  echo "Window moved to $NEW_X, $NEW_Y and set to floating."
fi
