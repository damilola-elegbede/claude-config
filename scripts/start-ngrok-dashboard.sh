#!/bin/bash

# MCP Dashboard Ngrok Tunnel Script
# This script starts an ngrok tunnel for the MCP dashboard

# Configuration
DASHBOARD_PORT=3003
NGROK_SUBDOMAIN="mcp-dashboard-$(whoami)"
LOG_FILE="$HOME/Library/Logs/ngrok-dashboard.log"

echo "Starting ngrok tunnel for MCP Dashboard..." > "$LOG_FILE"
echo "Timestamp: $(date)" >> "$LOG_FILE"
echo "Port: $DASHBOARD_PORT" >> "$LOG_FILE"

# Check if dashboard is running
if ! curl -s http://localhost:$DASHBOARD_PORT/api/metrics > /dev/null 2>&1; then
    echo "Warning: Dashboard not responding on port $DASHBOARD_PORT" >> "$LOG_FILE"
    echo "Waiting 10 seconds for dashboard to start..." >> "$LOG_FILE"
    sleep 10
fi

# Start ngrok with a stable subdomain (requires ngrok account)
# For free account, remove --subdomain flag for random URL
if [ -f "$HOME/.ngrok2/ngrok.yml" ] || [ -f "$HOME/Library/Application Support/ngrok/ngrok.yml" ]; then
    # With auth token - can use custom subdomain with paid plan
    echo "Starting ngrok with auth token..." >> "$LOG_FILE"
    exec /opt/homebrew/bin/ngrok http $DASHBOARD_PORT \
        --log stdout \
        --log-format json \
        2>&1 | tee -a "$LOG_FILE"
else
    # Without auth token - basic tunnel
    echo "Starting ngrok without auth token (random URL)..." >> "$LOG_FILE"
    exec /opt/homebrew/bin/ngrok http $DASHBOARD_PORT \
        --log stdout \
        --log-format json \
        2>&1 | tee -a "$LOG_FILE"
fi
