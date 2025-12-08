#!/bin/bash

# Lab 1.7 Setup Script
# Symlinks Supabase from references/ directory

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
REFERENCES_DIR="$REPO_ROOT/references"
SUPABASE_PATH="$REFERENCES_DIR/supabase"

echo "=== Lab 1.7 Setup ==="
echo ""

# Check if references/supabase exists and initialize if needed
if [ ! -d "$SUPABASE_PATH/.git" ] && [ ! -f "$SUPABASE_PATH/.git" ]; then
    echo "Supabase not initialized. Running references setup..."
    cd "$REFERENCES_DIR"
    ./setup.sh
    cd "$SCRIPT_DIR"
fi

# Create symlink if it doesn't exist
if [ ! -L "$SCRIPT_DIR/supabase" ] && [ ! -d "$SCRIPT_DIR/supabase" ]; then
    echo "Creating symlink to Supabase..."
    ln -s ../../../../references/supabase "$SCRIPT_DIR/supabase"
fi

echo ""
echo "=== Setup Complete ==="
echo ""
echo "Supabase is available at: $SCRIPT_DIR/supabase"
echo ""
echo "Start exploring the two-tier UI system:"
echo "  ls supabase/packages/ui/"
echo "  ls supabase/packages/ui-patterns/"
