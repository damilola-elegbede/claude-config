#!/bin/bash

# Create MCP Dashboard.app for easy startup

APP_NAME="MCP Dashboard"
APP_DIR="$HOME/Applications/${APP_NAME}.app"

echo "Creating ${APP_NAME}.app..."

# Create app structure
mkdir -p "${APP_DIR}/Contents/MacOS"
mkdir -p "${APP_DIR}/Contents/Resources"

# Create the executable script
cat > "${APP_DIR}/Contents/MacOS/MCP Dashboard" << 'EOF'
#!/bin/bash

# Start MCP Dashboard and Ngrok
osascript -e 'display notification "Starting MCP Dashboard..." with title "MCP Dashboard"'

# Ensure dashboard is running
if ! launchctl list | grep -q "com.claude.mcp.dashboard"; then
    launchctl load ~/Library/LaunchAgents/com.claude.mcp.dashboard.plist 2>/dev/null
fi

# Wait for dashboard
sleep 2

# Start ngrok if configured
if [ -f "$HOME/.ngrok2/ngrok.yml" ] || [ -f "$HOME/Library/Application Support/ngrok/ngrok.yml" ]; then
    if ! pgrep -x ngrok > /dev/null; then
        /opt/homebrew/bin/ngrok http 3003 > /dev/null 2>&1 &
        sleep 3
    fi
fi

# Open dashboard in browser
open "http://localhost:3003"

# Get public URL if available
sleep 2
PUBLIC_URL=$(curl -s http://localhost:4040/api/tunnels 2>/dev/null | grep -o '"public_url":"[^"]*' | grep -o 'https[^"]*' | head -1)

if [ -n "$PUBLIC_URL" ]; then
    osascript -e "display notification \"Public URL: ${PUBLIC_URL}\" with title \"MCP Dashboard\" subtitle \"URL copied to clipboard\""
    echo "$PUBLIC_URL" | pbcopy
fi
EOF

chmod +x "${APP_DIR}/Contents/MacOS/MCP Dashboard"

# Create Info.plist
cat > "${APP_DIR}/Contents/Info.plist" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleName</key>
    <string>MCP Dashboard</string>
    <key>CFBundleDisplayName</key>
    <string>MCP Dashboard</string>
    <key>CFBundleIdentifier</key>
    <string>com.claude.mcp.dashboard</string>
    <key>CFBundleVersion</key>
    <string>1.0</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleSignature</key>
    <string>????</string>
    <key>CFBundleExecutable</key>
    <string>MCP Dashboard</string>
    <key>CFBundleIconFile</key>
    <string>AppIcon</string>
    <key>LSUIElement</key>
    <true/>
</dict>
</plist>
EOF

echo "✅ Created ${APP_NAME}.app at: ${APP_DIR}"
echo ""
echo "To add to Login Items:"
echo "1. Open System Settings > General > Login Items"
echo "2. Click '+' and navigate to: ~/Applications/"
echo "3. Select 'MCP Dashboard.app' and click Add"
echo ""
echo "Or drag ${APP_NAME}.app to your Dock for easy access!"