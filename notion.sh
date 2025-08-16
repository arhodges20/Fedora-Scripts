#!/usr/bin/env bash
set -e

# 1) Pick a browser: chromium, google-chrome, or brave-browser
BROWSER=""
for c in chromium-browser chromium google-chrome-stable google-chrome brave-browser; do
  if command -v "$c" >/dev/null 2>&1; then BROWSER="$c"; break; fi
done

if [ -z "$BROWSER" ]; then
  echo "No supported browser found. Install Chromium, Google Chrome, or Brave and rerun."
  exit 1
fi

# 2) Paths
APP_NAME="Notion"
APP_ID="notion-ssb"
ICON_PATH="$HOME/.local/share/icons/notion.png"
PROFILE_DIR="$HOME/.config/$APP_ID"
DESKTOP_DIR="$HOME/.local/share/applications"
DESKTOP_FILE="$DESKTOP_DIR/$APP_ID.desktop"

# 3) Create folders and download icon
mkdir -p "$DESKTOP_DIR" "$PROFILE_DIR" "$(dirname "$ICON_PATH")"
curl -L -o "$ICON_PATH" https://upload.wikimedia.org/wikipedia/commons/4/45/Notion_app_logo.png

# 4) Create launcher (.desktop)
cat > "$DESKTOP_FILE" <<EOF
[Desktop Entry]
Name=$APP_NAME
Comment=$APP_NAME Web App
Exec=$BROWSER --user-data-dir=$PROFILE_DIR --profile-directory=Default --app=https://www.notion.so --class=$APP_NAME --new-window
Terminal=false
Type=Application
Icon=$ICON_PATH
Categories=Office;
StartupWMClass=$APP_NAME
EOF

# 5) Refresh desktop database (silently if not present)
update-desktop-database "$DESKTOP_DIR" >/dev/null 2>&1 || true

echo "Done. Open your app launcher and search for: $APP_NAME"
