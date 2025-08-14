# MCP Dashboard Service Setup Instructions

## 🚀 Quick Setup (Recommended)

Run these commands to install the MCP dashboard as a system service:

```bash
# 1. Copy the service file to LaunchAgents
cp com.claude.mcp.dashboard.plist ~/Library/LaunchAgents/

# 2. Load and start the service
launchctl load ~/Library/LaunchAgents/com.claude.mcp.dashboard.plist

# 3. Verify it's running
launchctl list | grep claude.mcp.dashboard
```

## ✅ Verify Installation

Check that the dashboard is running:

```bash
# Check service status
launchctl list | grep claude.mcp.dashboard

# Check if dashboard is accessible
curl -s http://localhost:3003/api/metrics | head -5

# View logs if needed
tail -f ~/Library/Logs/mcp-dashboard.log
```

## 📊 Access Dashboard

Once installed, the dashboard will:

- **Auto-start on system boot**
- **Restart automatically if it crashes**
- **Always be available at:** <http://localhost:3003>

## 🛠️ Service Management Commands

### Start Service

```bash
launchctl start com.claude.mcp.dashboard
```

### Stop Service

```bash
launchctl stop com.claude.mcp.dashboard
```

### Restart Service

```bash
launchctl stop com.claude.mcp.dashboard
launchctl start com.claude.mcp.dashboard
```

### Disable Auto-Start

```bash
launchctl unload ~/Library/LaunchAgents/com.claude.mcp.dashboard.plist
```

### Re-enable Auto-Start

```bash
launchctl load ~/Library/LaunchAgents/com.claude.mcp.dashboard.plist
```

### Completely Remove Service

```bash
launchctl unload ~/Library/LaunchAgents/com.claude.mcp.dashboard.plist
rm ~/Library/LaunchAgents/com.claude.mcp.dashboard.plist
```

## 📝 Service Configuration Details

The service is configured to:

- **Run at system startup** (`RunAtLoad: true`)
- **Restart on crash** (`KeepAlive -> Crashed: true`)
- **Not restart on clean exit** (allows manual stops)
- **Throttle restarts** (30-second minimum between restarts)
- **Run in background** (no UI interference)

## 📂 File Locations

- **Service definition:** `~/Library/LaunchAgents/com.claude.mcp.dashboard.plist`
- **Dashboard script:** `~/Documents/Projects/claude-config/dashboard.js`
- **Output logs:** `~/Library/Logs/mcp-dashboard.log`
- **Error logs:** `~/Library/Logs/mcp-dashboard.error.log`

## 🔧 Troubleshooting

### Dashboard Not Starting

1. Check Node.js path:

   ```bash
   which node
   ```

   If not `/usr/local/bin/node`, update the path in the plist file.

2. Check permissions:

   ```bash
   ls -la ~/Documents/Projects/claude-config/dashboard.js
   ```

3. Check error logs:

   ```bash
   cat ~/Library/Logs/mcp-dashboard.error.log
   ```

### Port Already in Use

If port 3003 is taken, edit `dashboard.js` to use a different port:

```javascript
const PORT = 3004; // or any available port
```

### Service Not Loading

Ensure the plist file has correct permissions:

```bash
chmod 644 ~/Library/LaunchAgents/com.claude.mcp.dashboard.plist
```

## 🎯 Benefits of System Service

1. **Always Available** - Dashboard runs automatically at startup
2. **Resilient** - Auto-restarts if it crashes
3. **Background Operation** - Doesn't require terminal window
4. **Professional** - Runs like a proper system service
5. **Logging** - Automatic log rotation and management
6. **Resource Efficient** - macOS manages the process efficiently

## 💡 Optional: Add to Menu Bar

For easy access, you can create a menu bar shortcut:

1. Open Script Editor
2. Create new script:

   ```applescript
   do shell script "open http://localhost:3003"
   ```

3. Save as application
4. Add to Login Items for menu bar access

## 🔄 Updating the Dashboard

When you update `dashboard.js`:

```bash
# Restart the service to load changes
launchctl stop com.claude.mcp.dashboard
launchctl start com.claude.mcp.dashboard
```

## ✨ Success Indicators

You know it's working when:

- ✅ `launchctl list` shows the service with PID
- ✅ <http://localhost:3003> loads the dashboard
- ✅ Dashboard survives system restarts
- ✅ Logs show successful startup in `~/Library/Logs/mcp-dashboard.log`
