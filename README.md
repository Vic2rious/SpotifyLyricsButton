# Spotify Lyrics Clicker

Automatically open the lyrics view in Spotify when it launches. This script intelligently handles the "Listening on Another Device" notification by adjusting the click coordinates as needed.

## Features

- Automatically clicks the lyrics button in Spotify after launch
- Detects and adjusts for the "Listening on Another Device" notification bar
- Preserves your mouse position and active window
- Works with both standard Spotify and spotify-launcher

## Requirements

- Linux environment
- `xdotool` for window management and mouse automation
- `imagemagick` for color detection
- Spotify client

## Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/Vic2rious/spotify-lyrics-clicker.git
   cd spotify-lyrics-clicker
   ```

2. Make the script executable:
   ```bash
   chmod +x spotify-lyrics-clicker.sh
   ```

## Usage

Simply run the script:

```bash
./spotify-lyrics-clicker.sh
```

The script will:
1. Launch Spotify if it's not already running
2. Wait for the Spotify window to appear
3. Check if the "Listening on Another Device" notification is present
4. Click the lyrics button at the appropriate coordinates
5. Restore your original mouse position and window focus

## Configuration

You may need to adjust some variables in the script to match your setup:

```bash
# Configuration
SPOTIFY_LAUNCH_COMMAND="LD_PRELOAD='/usr/lib/spotifywm.so' spotify-launcher"
STARTUP_WAIT=5  # Initial wait for Spotify to launch
WINDOW_WAIT=1   # Wait between window operations
MAX_RETRIES=30  # Maximum number of retries to find Spotify window
LYRICS_X=1162   # Default X coordinate for lyrics button
LYRICS_Y=2522   # Default Y coordinate for lyrics button
SHIFT_Y=-40     # Adjust this value based on how much the icon moves
```

### Finding the Correct Coordinates

If the script doesn't click in the right place, you'll need to find the correct coordinates for your display:

1. Run `xdotool getmouselocation` in a terminal
2. Move your mouse over the lyrics button in Spotify
3. Check the X and Y values and update the script accordingly

## Troubleshooting

### Script doesn't click the lyrics button

- Verify the coordinates by running `xdotool getmouselocation` while hovering over the lyrics button
- Adjust the `LYRICS_X` and `LYRICS_Y` variables accordingly
- If using a custom theme, you may need to adjust the color detection

### Spotify window not detected

- Increase the `STARTUP_WAIT` and `MAX_RETRIES` values
- Verify that Spotify's window class is correct by running `xdotool search --class "Spotify"`

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- This script uses [spotifywm](https://github.com/dasJ/spotifywm) for better window management integration
