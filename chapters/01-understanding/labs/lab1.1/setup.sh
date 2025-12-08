#!/bin/bash

# Lab 1.1 Setup Script
# Symlinks Cal.com from references/ directory

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
REFERENCES_DIR="$REPO_ROOT/references"
CALCOM_PATH="$REFERENCES_DIR/cal.com"

echo "=== Lab 1.1 Setup ==="
echo ""

# Check if references/cal.com exists and initialize if needed
if [ ! -d "$CALCOM_PATH/.git" ] && [ ! -f "$CALCOM_PATH/.git" ]; then
    echo "Cal.com not initialized. Running references setup..."
    cd "$REFERENCES_DIR"
    ./setup.sh
    cd "$SCRIPT_DIR"
fi

# Create symlink if it doesn't exist
if [ ! -L "$SCRIPT_DIR/cal.com" ] && [ ! -d "$SCRIPT_DIR/cal.com" ]; then
    echo "Creating symlink to Cal.com..."
    ln -s ../../../../references/cal.com "$SCRIPT_DIR/cal.com"
fi

echo ""
echo "=== Setup Complete ==="
echo ""
echo "Cal.com is available at: $SCRIPT_DIR/cal.com"
echo ""
echo "Start exploring:"
echo "  ls cal.com/"
echo "  ls cal.com/packages/"
echo "  ls cal.com/apps/"
