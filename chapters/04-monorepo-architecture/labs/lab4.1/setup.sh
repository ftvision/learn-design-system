#!/bin/bash

# Lab 4.1 Setup Script
# Creates the monorepo root structure with pnpm and Turborepo

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "=== Lab 4.1 Setup: Initialize Monorepo ==="
echo ""

# Create directory structure
echo "Creating directory structure..."
mkdir -p "$SCRIPT_DIR/packages/tokens"
mkdir -p "$SCRIPT_DIR/packages/ui"
mkdir -p "$SCRIPT_DIR/packages/config"
mkdir -p "$SCRIPT_DIR/apps/web"

# Create root package.json
PACKAGE_JSON="$SCRIPT_DIR/package.json"
if [ -f "$PACKAGE_JSON" ]; then
    echo "package.json already exists. Skipping."
else
    echo "Creating root package.json..."
    cat > "$PACKAGE_JSON" << 'EOF'
{
  "name": "design-system-course",
  "private": true,
  "scripts": {
    "dev": "turbo dev",
    "build": "turbo build",
    "lint": "turbo lint",
    "clean": "turbo clean && rm -rf node_modules"
  },
  "devDependencies": {
    "turbo": "^2.0.0"
  },
  "packageManager": "pnpm@8.15.0"
}
EOF
fi

# Create pnpm-workspace.yaml
WORKSPACE_YAML="$SCRIPT_DIR/pnpm-workspace.yaml"
if [ -f "$WORKSPACE_YAML" ]; then
    echo "pnpm-workspace.yaml already exists. Skipping."
else
    echo "Creating pnpm-workspace.yaml..."
    cat > "$WORKSPACE_YAML" << 'EOF'
packages:
  - 'packages/*'
  - 'apps/*'
EOF
fi

# Create turbo.json
TURBO_JSON="$SCRIPT_DIR/turbo.json"
if [ -f "$TURBO_JSON" ]; then
    echo "turbo.json already exists. Skipping."
else
    echo "Creating turbo.json..."
    cat > "$TURBO_JSON" << 'EOF'
{
  "$schema": "https://turbo.build/schema.json",
  "tasks": {
    "build": {
      "dependsOn": ["^build"],
      "outputs": ["dist/**", ".next/**", "build/**"]
    },
    "dev": {
      "cache": false,
      "persistent": true
    },
    "lint": {
      "dependsOn": ["^build"]
    },
    "clean": {
      "cache": false
    }
  }
}
EOF
fi

echo ""
echo "=== Setup Complete ==="
echo ""
echo "Directory structure created:"
echo "  - packages/tokens/"
echo "  - packages/ui/"
echo "  - packages/config/"
echo "  - apps/web/"
echo ""
echo "Configuration files created:"
echo "  - $PACKAGE_JSON"
echo "  - $WORKSPACE_YAML"
echo "  - $TURBO_JSON"
echo ""
echo "Next steps:"
echo "  1. Read the README.md for this lab"
echo "  2. Understand the monorepo structure"
echo "  3. Proceed to Lab 4.2 to create shared configurations"
echo ""
