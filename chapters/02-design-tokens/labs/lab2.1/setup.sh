#!/bin/bash

# Lab 2.1 Setup Script
# Initializes the tokens package with Style Dictionary

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "=== Lab 2.1 Setup: Token System Initialization ==="
echo ""

# Create the package structure
TOKENS_DIR="$SCRIPT_DIR/packages/tokens"

if [ -d "$TOKENS_DIR" ]; then
    echo "packages/tokens already exists. Skipping creation."
else
    echo "Creating packages/tokens directory structure..."
    mkdir -p "$TOKENS_DIR/src"
fi

# Create package.json if it doesn't exist
PACKAGE_JSON="$TOKENS_DIR/package.json"
if [ -f "$PACKAGE_JSON" ]; then
    echo "package.json already exists. Skipping creation."
else
    echo "Creating package.json..."
    cat > "$PACKAGE_JSON" << 'EOF'
{
  "name": "@myapp/tokens",
  "version": "0.0.1",
  "description": "Design tokens for the design system",
  "main": "build/js/tokens.js",
  "types": "build/ts/tokens.ts",
  "scripts": {
    "build": "style-dictionary build",
    "clean": "rm -rf build"
  },
  "keywords": [
    "design-tokens",
    "style-dictionary",
    "design-system"
  ],
  "license": "MIT",
  "devDependencies": {
    "style-dictionary": "^3.9.0"
  }
}
EOF
fi

# Install dependencies
echo ""
echo "Installing dependencies..."
cd "$TOKENS_DIR"
npm install

echo ""
echo "=== Setup Complete ==="
echo ""
echo "Your tokens package is ready at: $TOKENS_DIR"
echo ""
echo "Directory structure:"
echo "  packages/tokens/"
echo "  ├── src/           # Add your token files here"
echo "  ├── package.json"
echo "  └── node_modules/"
echo ""
echo "Next steps:"
echo "  1. Read the README.md for this lab"
echo "  2. Proceed to Lab 2.2 to create color tokens"
echo ""
