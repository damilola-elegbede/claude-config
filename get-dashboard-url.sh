#!/bin/bash

# Get the current ngrok URL for the MCP Dashboard

# Check local dashboard
if curl -s http://localhost:3003/api/metrics > /dev/null 2>&1; then
    echo "✅ Local Dashboard: http://localhost:3003"
else
    echo "❌ Local Dashboard: Not running"
fi

# Get ngrok URL from API
NGROK_URL=$(curl -s http://localhost:4040/api/tunnels 2>/dev/null | grep -o '"public_url":"[^"]*' | grep -o 'http[^"]*' | head -1)

if [ -n "$NGROK_URL" ]; then
    echo "🌐 Public URL: $NGROK_URL"
    echo ""
    echo "Share this URL to access your MCP Dashboard from anywhere!"
    
    # Optional: Copy to clipboard (macOS)
    echo "$NGROK_URL" | pbcopy
    echo "📋 URL copied to clipboard!"
else
    echo "❌ Ngrok tunnel: Not running"
    echo ""
    echo "To start ngrok tunnel:"
    echo "  launchctl load ~/Library/LaunchAgents/com.claude.mcp.ngrok.plist"
fi