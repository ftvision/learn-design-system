#!/bin/bash

# Lab 8.1 Setup Script
# Creates multi-platform Style Dictionary configuration

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MONOREPO_DIR="$SCRIPT_DIR/../../../04-monorepo-architecture/labs/lab4.1"
TOKENS_DIR="$MONOREPO_DIR/packages/tokens"

echo "=== Lab 8.1 Setup: Configure Multi-Platform Build ==="
echo ""

# Check if monorepo exists
if [ ! -d "$MONOREPO_DIR" ]; then
    echo "Error: Chapter 4 monorepo not found at $MONOREPO_DIR"
    echo "Please complete Chapter 4 labs first."
    exit 1
fi

# Create tokens package if needed
mkdir -p "$TOKENS_DIR/src"

# Create Style Dictionary config
CONFIG_FILE="$TOKENS_DIR/style-dictionary.config.js"
echo "Creating style-dictionary.config.js..."
cat > "$CONFIG_FILE" << 'EOF'
module.exports = {
  source: ["src/**/*.json"],
  platforms: {
    // CSS for web
    css: {
      transformGroup: "css",
      buildPath: "build/css/",
      files: [
        {
          destination: "variables.css",
          format: "css/variables",
        },
      ],
    },

    // JavaScript ES6
    js: {
      transformGroup: "js",
      buildPath: "build/js/",
      files: [
        {
          destination: "tokens.js",
          format: "javascript/es6",
        },
      ],
    },

    // TypeScript (for React Native)
    ts: {
      transformGroup: "js",
      buildPath: "build/ts/",
      files: [
        {
          destination: "tokens.ts",
          format: "javascript/es6",
        },
        {
          destination: "tokens.d.ts",
          format: "typescript/es6-declarations",
        },
      ],
    },

    // iOS Swift
    ios: {
      transformGroup: "ios-swift-separate",
      buildPath: "build/ios/",
      files: [
        {
          destination: "Colors.swift",
          format: "ios-swift/enum.swift",
          className: "Colors",
          filter: {
            type: "color",
          },
        },
        {
          destination: "Spacing.swift",
          format: "ios-swift/enum.swift",
          className: "Spacing",
          filter: {
            type: "dimension",
          },
        },
        {
          destination: "Typography.swift",
          format: "ios-swift/enum.swift",
          className: "Typography",
          filter: (token) =>
            token.path[0] === "font" &&
            (token.path[1] === "size" || token.path[1] === "weight"),
        },
      ],
    },

    // Android
    android: {
      transformGroup: "android",
      buildPath: "build/android/",
      files: [
        {
          destination: "colors.xml",
          format: "android/colors",
          filter: {
            type: "color",
          },
        },
        {
          destination: "dimens.xml",
          format: "android/dimens",
          filter: {
            type: "dimension",
          },
        },
        {
          destination: "font_sizes.xml",
          format: "android/fontDimens",
          filter: (token) => token.path[0] === "font" && token.path[1] === "size",
        },
      ],
    },
  },
};
EOF

# Create or update package.json
PACKAGE_FILE="$TOKENS_DIR/package.json"
if [ ! -f "$PACKAGE_FILE" ]; then
    echo "Creating package.json..."
    cat > "$PACKAGE_FILE" << 'EOF'
{
  "name": "@myapp/tokens",
  "version": "0.0.1",
  "private": true,
  "scripts": {
    "build": "style-dictionary build",
    "clean": "rm -rf build"
  },
  "devDependencies": {
    "style-dictionary": "^3.9.0"
  }
}
EOF
else
    echo "package.json already exists. Checking for style-dictionary..."
    if ! grep -q "style-dictionary" "$PACKAGE_FILE"; then
        echo "Warning: style-dictionary not in package.json. Please add it manually."
    fi
fi

echo ""
echo "=== Setup Complete ==="
echo ""
echo "Files created:"
echo "  - $CONFIG_FILE"
echo ""
echo "Platform outputs configured:"
echo "  - css    → build/css/variables.css"
echo "  - js     → build/js/tokens.js"
echo "  - ts     → build/ts/tokens.ts, tokens.d.ts"
echo "  - ios    → build/ios/Colors.swift, Spacing.swift, Typography.swift"
echo "  - android → build/android/colors.xml, dimens.xml, font_sizes.xml"
echo ""
echo "Next steps:"
echo "  1. Read the README.md for this lab"
echo "  2. Proceed to Lab 8.2 to add token types and build"
echo ""
