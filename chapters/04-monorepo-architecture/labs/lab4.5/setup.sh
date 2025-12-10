#!/bin/bash

# Lab 4.5 Setup Script
# Installs dependencies and builds the monorepo

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LAB41_DIR="$SCRIPT_DIR/../lab4.1"
LAB42_DIR="$SCRIPT_DIR/../lab4.2"
LAB43_DIR="$SCRIPT_DIR/../lab4.3"
LAB44_DIR="$SCRIPT_DIR/../lab4.4"

echo "=== Lab 4.5 Setup: Build & Run ==="
echo ""

# Ensure previous labs are complete
if [ ! -f "$LAB41_DIR/package.json" ]; then
    echo "Lab 4.1 not complete. Running setup..."
    cd "$LAB41_DIR" && ./setup.sh && cd "$SCRIPT_DIR"
fi

if [ ! -f "$LAB41_DIR/packages/config/package.json" ]; then
    echo "Lab 4.2 not complete. Running setup..."
    cd "$LAB42_DIR" && ./setup.sh && cd "$SCRIPT_DIR"
fi

if [ ! -f "$LAB41_DIR/packages/ui/package.json" ]; then
    echo "Lab 4.3 not complete. Running setup..."
    cd "$LAB43_DIR" && ./setup.sh && cd "$SCRIPT_DIR"
fi

if [ ! -f "$LAB41_DIR/apps/web/package.json" ]; then
    echo "Lab 4.4 not complete. Running setup..."
    cd "$LAB44_DIR" && ./setup.sh && cd "$SCRIPT_DIR"
fi

echo "All previous labs complete."
echo ""

# Check if pnpm is installed
if ! command -v pnpm &> /dev/null; then
    echo "pnpm is not installed. Please install it first:"
    echo "  npm install -g pnpm"
    echo ""
    echo "Then run this setup script again."
    exit 1
fi

echo "Installing dependencies..."
cd "$LAB41_DIR"
pnpm install

echo ""
echo "Building all packages..."
pnpm build

echo ""
echo "=== Setup Complete ==="
echo ""
echo "Monorepo is ready!"
echo ""
echo "To run the development server:"
echo "  cd $LAB41_DIR"
echo "  pnpm dev"
echo ""
echo "Then open http://localhost:3000 in your browser."
echo ""
echo "Next steps:"
echo "  1. Read the README.md for this lab"
echo "  2. Test hot reload by editing packages/ui/src/components/Button.tsx"
echo "  3. Proceed to Lab 4.6 to compare with real projects"
echo ""
