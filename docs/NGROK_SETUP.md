# Ngrok Setup for MCP Dashboard

## 🌐 Public URL Access for Your Dashboard

This guide helps you expose your MCP Dashboard to the internet using ngrok.

## Quick Setup

### 1. Manual Start (Immediate Access)

```bash
# Start ngrok tunnel
ngrok http 3003

# This will display something like:
# Forwarding: https://abc123.ngrok.io -> http://localhost:3003
```

Your dashboard will be accessible at the ngrok URL shown!

### 2. Get Free Ngrok Account (Recommended)

1. Sign up at <https://ngrok.com/signup>
2. Get your auth token from <https://dashboard.ngrok.com/auth>
3. Configure ngrok:

   ```bash
   ngrok authtoken YOUR_AUTH_TOKEN
   ```

### 3. Automatic Startup Script

Create an alias in your shell profile (`~/.zshrc` or `~/.bashrc`):

```bash
# Add this to your shell profile
alias mcp-public="ngrok http 3003 &"
alias mcp-url="curl -s http://localhost:4040/api/tunnels | grep -o '\"public_url\":\"[^\"]*' | grep -o 'https[^\"]*' | head -1"
```

Then reload your shell:

```bash
source ~/.zshrc  # or ~/.bashrc
```

### 4. Start Everything with One Command

Create a master startup script:

```bash
cat > ~/start-mcp-dashboard.sh << 'EOF'
#!/bin/bash
echo "Starting MCP Dashboard Suite..."

# Check if dashboard is already running
if ! launchctl list | grep -q "com.claude.mcp.dashboard"; then
    launchctl load ~/Library/LaunchAgents/com.claude.mcp.dashboard.plist
    echo "✅ Dashboard service started"
else
    echo "✅ Dashboard already running"
fi

# Start ngrok
if ! pgrep -x ngrok > /dev/null; then
    ngrok http 3003 > /dev/null 2>&1 &
    echo "✅ Ngrok tunnel started"
    sleep 3
    
    # Get and display the public URL
    PUBLIC_URL=$(curl -s http://localhost:4040/api/tunnels 2>/dev/null | grep -o '"public_url":"[^"]*' | grep -o 'https[^"]*' | head -1)
    
    if [ -n "$PUBLIC_URL" ]; then
        echo ""
        echo "🌐 Your MCP Dashboard is available at:"
        echo "   Local: http://localhost:3003"
        echo "   Public: $PUBLIC_URL"
        echo ""
        echo "$PUBLIC_URL" | pbcopy
        echo "📋 Public URL copied to clipboard!"
    fi
else
    echo "✅ Ngrok already running"
    PUBLIC_URL=$(curl -s http://localhost:4040/api/tunnels 2>/dev/null | grep -o '"public_url":"[^"]*' | grep -o 'https[^"]*' | head -1)
    echo "   Public URL: $PUBLIC_URL"
fi
EOF

chmod +x ~/start-mcp-dashboard.sh
```

## 🚀 Usage

### Start Everything

```bash
~/start-mcp-dashboard.sh
```

### Get Current Public URL

```bash
./get-dashboard-url.sh
```

### Check Status

```bash
# Check dashboard
launchctl list | grep claude.mcp.dashboard

# Check ngrok
ps aux | grep ngrok

# Get public URL
curl -s http://localhost:4040/api/tunnels | jq -r '.tunnels[0].public_url'
```

## 🔐 Security Notes

1. **Free ngrok URLs change** each time you restart (random subdomain)
2. **Anyone with the URL can access** your dashboard
3. **For permanent URL**, upgrade to ngrok paid plan for custom subdomains
4. **For security**, consider:
   - Adding basic auth to ngrok: `ngrok http -auth="user:password" 3003`
   - Using ngrok's IP restrictions (paid feature)
   - Only running ngrok when needed

## 📱 Share Your Dashboard

Once ngrok is running, you can:

- Share the public URL with team members
- Access from your phone or tablet
- Demo to stakeholders remotely
- Monitor from anywhere

## 🛠️ Troubleshooting

### Ngrok Not Starting

```bash
# Check if port 4040 is in use (ngrok API)
lsof -i :4040

# Kill existing ngrok
pkill ngrok

# Restart
ngrok http 3003
```

### Dashboard Not Accessible via Ngrok

```bash
# Verify local dashboard works
curl http://localhost:3003/api/metrics

# Check ngrok status
curl http://localhost:4040/api/tunnels
```

## 🎯 Auto-Start at Login (Simple Method)

Add to your Login Items:

1. Open System Preferences → Users & Groups
2. Click Login Items tab
3. Click "+" and add the `~/start-mcp-dashboard.sh` script

Or use a simple cron job:

```bash
# Edit crontab
crontab -e

# Add this line
@reboot /Users/damilola/start-mcp-dashboard.sh
```

## Summary

Your MCP Dashboard is now:

- ✅ Running as a system service (always available locally)
- ✅ Accessible via ngrok public URL (when ngrok is running)
- ✅ Can be shared with anyone via the public URL
- ✅ Auto-starts on system boot (dashboard service)
