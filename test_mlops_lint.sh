#!/bin/bash

# Test markdownlint on mlops-guide.md
echo "Testing markdownlint on docs/mlops-guide.md"
echo "============================================="

cd "/Users/daelegbe/Documents/Projects/claude-config"

# Run markdownlint on the specific file
npx markdownlint-cli2 docs/mlops-guide.md --config .markdownlint-cli2.jsonc

exit_code=$?
echo ""
echo "Exit code: $exit_code"
if [ $exit_code -eq 0 ]; then
    echo "✅ No markdownlint violations found!"
else
    echo "❌ Found markdownlint violations"
fi