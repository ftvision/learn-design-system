#!/bin/bash

# References Setup Script
# Initializes all reference project submodules

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Pinned commits for reproducibility
CALCOM_COMMIT="1182460d5c0733d126e77528daeb6fabc5d3ecc5"
SUPABASE_COMMIT="0399beba0e8ddcf4bf63b66d9fd16dc4a53a5c81"

echo "=== References Setup ==="
echo ""

cd "$REPO_ROOT"

# Cal.com
if [ -d "$SCRIPT_DIR/cal.com" ]; then
    echo "Setting up Cal.com..."

    if [ ! -d "$SCRIPT_DIR/cal.com/.git" ] && [ ! -f "$SCRIPT_DIR/cal.com/.git" ]; then
        echo "  Initializing submodule..."
        git submodule update --init references/cal.com
    fi

    echo "  Checking out pinned commit ($CALCOM_COMMIT)..."
    cd "$SCRIPT_DIR/cal.com"
    git checkout "$CALCOM_COMMIT" --quiet
    cd "$REPO_ROOT"

    echo "  ✓ Cal.com ready"
else
    echo "Cal.com submodule not configured. Skipping."
fi

# Supabase
if [ -d "$SCRIPT_DIR/supabase" ]; then
    echo "Setting up Supabase..."

    if [ ! -d "$SCRIPT_DIR/supabase/.git" ] && [ ! -f "$SCRIPT_DIR/supabase/.git" ]; then
        echo "  Initializing submodule..."
        git submodule update --init references/supabase
    fi

    echo "  Checking out pinned commit ($SUPABASE_COMMIT)..."
    cd "$SCRIPT_DIR/supabase"
    git checkout "$SUPABASE_COMMIT" --quiet
    cd "$REPO_ROOT"

    echo "  ✓ Supabase ready"
else
    echo "Supabase submodule not configured. Skipping."
fi

echo ""
echo "=== Setup Complete ==="
