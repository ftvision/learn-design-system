#!/bin/bash

# Lab 4.6 Setup Script
# Creates symlinks to reference projects for comparison

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../../../.." && pwd)"
REFERENCES_DIR="$REPO_ROOT/references"

echo "=== Lab 4.6 Setup: Compare with Real Projects ==="
echo ""

# Check if references exist
if [ ! -d "$REFERENCES_DIR/cal.com" ]; then
    echo "Cal.com reference not found."
    echo "Please run the Chapter 1 setup first to initialize references."
    echo ""
    echo "From the repo root:"
    echo "  cd references && ./setup.sh"
    exit 1
fi

# Create symlink to cal.com
if [ ! -L "$SCRIPT_DIR/cal.com" ] && [ ! -d "$SCRIPT_DIR/cal.com" ]; then
    echo "Creating symlink to Cal.com..."
    ln -s ../../../../../references/cal.com "$SCRIPT_DIR/cal.com"
fi

echo ""
echo "=== Setup Complete ==="
echo ""
echo "Reference projects available:"
if [ -L "$SCRIPT_DIR/cal.com" ]; then
    echo "  - cal.com/ -> Cal.com repository"
fi
echo ""
echo "Next steps:"
echo "  1. Read the README.md for this lab"
echo "  2. Study Cal.com's monorepo structure:"
echo "     cat cal.com/pnpm-workspace.yaml"
echo "     cat cal.com/turbo.json"
echo "  3. Compare with your implementation"
echo "  4. Complete the reflection questions"
echo ""
