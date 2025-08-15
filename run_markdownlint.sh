#!/bin/bash

# Temporary script to run markdownlint on docs directory
echo "Running markdownlint-cli2 on docs/*.md"
echo "========================================="

# Change to project directory
cd "/Users/daelegbe/Documents/Projects/claude-config"

# Run markdownlint with detailed output
npx markdownlint-cli2 docs/*.md --config .markdownlint-cli2.jsonc 2>&1

# Capture exit code
exit_code=$?
echo ""
echo "Exit code: $exit_code"
exit $exit_code