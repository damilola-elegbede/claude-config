#!/bin/bash

# Test script to verify npm resilience configuration
# This script simulates the CI environment npm install process

set -e

echo "🧪 Testing npm resilience configuration..."

# Store original npm config
echo "📋 Backing up existing npm config..."
npm config list > /tmp/original_npm_config.txt 2>/dev/null || true

# Apply the resilience configuration
echo "🔧 Applying resilience configuration..."
npm config set registry https://registry.npmjs.org/
npm config set fetch-retry-mintimeout 20000
npm config set fetch-retry-maxtimeout 120000
npm config set fetch-retry-factor 2
npm config set fetch-retries 5
npm config set timeout 300000
npm config set prefer-offline true
npm config set audit false
npm config set progress false

echo "✅ Configuration applied. Current retry settings:"
echo "   - fetch-retries: $(npm config get fetch-retries)"
echo "   - fetch-retry-mintimeout: $(npm config get fetch-retry-mintimeout)"
echo "   - fetch-retry-maxtimeout: $(npm config get fetch-retry-maxtimeout)"
echo "   - timeout: $(npm config get timeout)"

# Test npm ci with current configuration
echo "🔄 Testing npm ci with resilience configuration..."

# Remove node_modules to simulate clean install
if [ -d "node_modules" ]; then
    echo "🧹 Removing existing node_modules..."
    rm -rf node_modules
fi

# Test npm ci
echo "📦 Running npm ci..."
start_time=$(date +%s)

if npm ci --prefer-offline --no-audit --progress=false; then
    end_time=$(date +%s)
    duration=$((end_time - start_time))
    echo "✅ npm ci completed successfully in ${duration}s"
else
    echo "❌ npm ci failed"
    exit 1
fi

# Verify installation
echo "🔍 Verifying installation..."
if [ -d "node_modules" ] && [ -f "node_modules/.package-lock.json" ]; then
    echo "✅ node_modules directory created successfully"
    echo "✅ .package-lock.json exists"

    # Count installed packages
    installed_packages=$(find node_modules -name "package.json" -maxdepth 2 | wc -l | tr -d ' ')
    echo "📊 Installed packages: $installed_packages"
else
    echo "❌ Installation verification failed"
    exit 1
fi

echo "🎉 npm resilience test completed successfully!"
echo ""
echo "💡 This configuration should handle 429 rate limiting errors in CI/CD environments."
echo "   The settings are now also saved in .npmrc for persistent configuration."
