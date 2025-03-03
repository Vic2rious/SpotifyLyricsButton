#!/bin/bash

# Configuration
SPOTIFY_LAUNCH_COMMAND="LD_PRELOAD='/usr/lib/spotifywm.so' spotify-launcher"
STARTUP_WAIT=5  # Initial wait for Spotify to launch
WINDOW_WAIT=1    # Wait between window operations
MAX_RETRIES=30   # Maximum number of retries to find Spotify window
LYRICS_X=1162    # Default X coordinate for lyrics button
LYRICS_Y=2522    # Default Y coordinate for lyrics button
SHIFT_Y=-40      # Adjust this value based on how much the icon moves

# Function to check if Spotify is running
is_spotify_running() {
    pgrep -x "spotify" >/dev/null
}

# Function to get Spotify window ID
get_spotify_window_id() {
    xdotool search --classname "Spotify" 2>/dev/null || xdotool search --class "Spotify" | head -1
}

# Function to get pixel color at a given coordinate
get_pixel_color() {
    import -silent -window root -crop 1x1+"$1"+"$2" txt:- | awk 'NR==2 {print $3}' | cut -c1-7
}

# Function to save current mouse position and focused window
save_state() {
    eval $(xdotool getmouselocation --shell)
    ORIGINAL_X=$X
    ORIGINAL_Y=$Y
    ORIGINAL_WINDOW=$(xdotool getactivewindow 2>/dev/null)
    
    if [[ ! "$ORIGINAL_WINDOW" =~ ^[0-9]+$ ]]; then
        echo "Warning: Invalid window ID detected ($ORIGINAL_WINDOW)"
        ORIGINAL_WINDOW=""
    fi
}

# Function to restore mouse position and focus
restore_state() {
    xdotool mousemove "$ORIGINAL_X" "$ORIGINAL_Y"
    
    if [[ -n "$ORIGINAL_WINDOW" ]]; then
        xdotool windowactivate "$ORIGINAL_WINDOW" 2>/dev/null || echo "Warning: Failed to restore window focus"
    fi
}

# Clean up on script termination
trap restore_state EXIT

# Save initial state
save_state

# Launch Spotify if not already running
if ! is_spotify_running; then
    eval $SPOTIFY_LAUNCH_COMMAND &
    echo "Launching Spotify..."
    sleep $STARTUP_WAIT
fi

# Wait for Spotify window to be available
retry_count=0
window_id=""
while [ -z "$window_id" ] && [ $retry_count -lt $MAX_RETRIES ]; do
    window_id=$(get_spotify_window_id)
    if [ -z "$window_id" ]; then
        sleep 1
        retry_count=$((retry_count + 1))
    fi
done

if [ -z "$window_id" ]; then
    echo "Error: Could not find Spotify window"
    exit 1
fi

# Activate Spotify window
xdotool windowactivate "$window_id"
sleep "$WINDOW_WAIT"

# Check if the purple bar is present
COLOR=$(get_pixel_color "$LYRICS_X" "$((LYRICS_Y + 20))")
echo "Detected color: $COLOR"

if [[ "$COLOR" == "#AEAE1A" ]]; then # the actual colour is AE1ADB, I am simply a genius
    echo "Detected purple bar, adjusting coordinates..."
    LYRICS_Y=$((LYRICS_Y + SHIFT_Y))
fi

# Click lyrics button
xdotool mousemove "$LYRICS_X" "$LYRICS_Y" click 1
