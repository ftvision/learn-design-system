#!/bin/bash

# Lab 8.2 Setup Script
# Creates token files with type attributes and builds all platforms

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MONOREPO_DIR="$SCRIPT_DIR/../../../04-monorepo-architecture/labs/lab4.1"
TOKENS_DIR="$MONOREPO_DIR/packages/tokens"
SRC_DIR="$TOKENS_DIR/src"

echo "=== Lab 8.2 Setup: Add Token Types & Build ==="
echo ""

# Check if monorepo exists
if [ ! -d "$MONOREPO_DIR" ]; then
    echo "Error: Chapter 4 monorepo not found at $MONOREPO_DIR"
    echo "Please complete Chapter 4 labs first."
    exit 1
fi

# Check if Lab 8.1 is complete
if [ ! -f "$TOKENS_DIR/style-dictionary.config.js" ]; then
    echo "Error: style-dictionary.config.js not found."
    echo "Please complete Lab 8.1 first."
    exit 1
fi

# Create src directory
mkdir -p "$SRC_DIR"

# Create colors.json
COLORS_FILE="$SRC_DIR/colors.json"
echo "Creating colors.json with type attributes..."
cat > "$COLORS_FILE" << 'EOF'
{
  "color": {
    "primary": {
      "50": { "value": "#EFF6FF", "type": "color" },
      "100": { "value": "#DBEAFE", "type": "color" },
      "500": { "value": "#3B82F6", "type": "color" },
      "600": { "value": "#2563EB", "type": "color" },
      "700": { "value": "#1D4ED8", "type": "color" }
    },
    "gray": {
      "50": { "value": "#F9FAFB", "type": "color" },
      "100": { "value": "#F3F4F6", "type": "color" },
      "200": { "value": "#E5E7EB", "type": "color" },
      "300": { "value": "#D1D5DB", "type": "color" },
      "400": { "value": "#9CA3AF", "type": "color" },
      "500": { "value": "#6B7280", "type": "color" },
      "600": { "value": "#4B5563", "type": "color" },
      "700": { "value": "#374151", "type": "color" },
      "800": { "value": "#1F2937", "type": "color" },
      "900": { "value": "#111827", "type": "color" },
      "950": { "value": "#030712", "type": "color" }
    },
    "success": { "value": "#22C55E", "type": "color" },
    "warning": { "value": "#F59E0B", "type": "color" },
    "error": { "value": "#EF4444", "type": "color" },
    "white": { "value": "#FFFFFF", "type": "color" },
    "black": { "value": "#000000", "type": "color" }
  }
}
EOF

# Create spacing.json
SPACING_FILE="$SRC_DIR/spacing.json"
echo "Creating spacing.json with type attributes..."
cat > "$SPACING_FILE" << 'EOF'
{
  "spacing": {
    "0": { "value": "0", "type": "dimension" },
    "1": { "value": "4px", "type": "dimension" },
    "2": { "value": "8px", "type": "dimension" },
    "3": { "value": "12px", "type": "dimension" },
    "4": { "value": "16px", "type": "dimension" },
    "5": { "value": "20px", "type": "dimension" },
    "6": { "value": "24px", "type": "dimension" },
    "8": { "value": "32px", "type": "dimension" },
    "10": { "value": "40px", "type": "dimension" },
    "12": { "value": "48px", "type": "dimension" },
    "16": { "value": "64px", "type": "dimension" }
  }
}
EOF

# Create typography.json
TYPOGRAPHY_FILE="$SRC_DIR/typography.json"
echo "Creating typography.json with type attributes..."
cat > "$TYPOGRAPHY_FILE" << 'EOF'
{
  "font": {
    "family": {
      "sans": { "value": "Inter, system-ui, sans-serif", "type": "fontFamily" },
      "mono": { "value": "Fira Code, monospace", "type": "fontFamily" }
    },
    "size": {
      "xs": { "value": "12px", "type": "dimension" },
      "sm": { "value": "14px", "type": "dimension" },
      "base": { "value": "16px", "type": "dimension" },
      "lg": { "value": "18px", "type": "dimension" },
      "xl": { "value": "20px", "type": "dimension" },
      "2xl": { "value": "24px", "type": "dimension" },
      "3xl": { "value": "30px", "type": "dimension" },
      "4xl": { "value": "36px", "type": "dimension" }
    },
    "weight": {
      "normal": { "value": "400", "type": "fontWeight" },
      "medium": { "value": "500", "type": "fontWeight" },
      "semibold": { "value": "600", "type": "fontWeight" },
      "bold": { "value": "700", "type": "fontWeight" }
    }
  }
}
EOF

echo ""
echo "Token files created:"
echo "  - $COLORS_FILE"
echo "  - $SPACING_FILE"
echo "  - $TYPOGRAPHY_FILE"
echo ""

# Try to build if style-dictionary is installed
cd "$TOKENS_DIR"
if command -v npx &> /dev/null && [ -f "package.json" ]; then
    echo "Installing dependencies and building..."
    if [ -f "pnpm-lock.yaml" ] || [ -f "../../../pnpm-lock.yaml" ]; then
        pnpm install 2>/dev/null || npm install 2>/dev/null || echo "Install manually: pnpm install"
    else
        npm install 2>/dev/null || echo "Install manually: npm install"
    fi

    echo ""
    echo "Building tokens..."
    npx style-dictionary build 2>/dev/null || echo "Build manually: npx style-dictionary build"
fi

echo ""
echo "=== Setup Complete ==="
echo ""
echo "Next steps:"
echo "  1. Read the README.md for this lab"
echo "  2. Examine the token files"
echo "  3. Run: cd $TOKENS_DIR && pnpm build"
echo "  4. Explore the build/ directory"
echo "  5. Proceed to Lab 8.3 to examine iOS output"
echo ""
