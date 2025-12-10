#!/bin/bash

# Lab 2.3 Setup Script
# Creates spacing, typography, shadows, and borders token files

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LAB21_DIR="$SCRIPT_DIR/../lab2.1"
LAB22_DIR="$SCRIPT_DIR/../lab2.2"
TOKENS_DIR="$LAB21_DIR/packages/tokens"
SRC_DIR="$TOKENS_DIR/src"

echo "=== Lab 2.3 Setup: Spacing, Typography, Shadows & Borders ==="
echo ""

# Check if Lab 2.1 is complete
if [ ! -d "$TOKENS_DIR" ]; then
    echo "Lab 2.1 not complete. Running Lab 2.1 setup first..."
    cd "$LAB21_DIR"
    ./setup.sh
    cd "$SCRIPT_DIR"
fi

# Check if Lab 2.2 is complete (colors.json exists)
if [ ! -f "$SRC_DIR/colors.json" ]; then
    echo "Lab 2.2 not complete. Running Lab 2.2 setup first..."
    cd "$LAB22_DIR"
    ./setup.sh
    cd "$SCRIPT_DIR"
fi

# Create spacing.json
SPACING_FILE="$SRC_DIR/spacing.json"
if [ -f "$SPACING_FILE" ]; then
    echo "spacing.json already exists. Skipping."
else
    echo "Creating spacing.json..."
    cat > "$SPACING_FILE" << 'EOF'
{
  "spacing": {
    "0": { "value": "0" },
    "px": { "value": "1px" },
    "0.5": { "value": "2px" },
    "1": { "value": "4px" },
    "2": { "value": "8px" },
    "3": { "value": "12px" },
    "4": { "value": "16px" },
    "5": { "value": "20px" },
    "6": { "value": "24px" },
    "8": { "value": "32px" },
    "10": { "value": "40px" },
    "12": { "value": "48px" },
    "16": { "value": "64px" },
    "20": { "value": "80px" },
    "24": { "value": "96px" }
  }
}
EOF
fi

# Create typography.json
TYPOGRAPHY_FILE="$SRC_DIR/typography.json"
if [ -f "$TYPOGRAPHY_FILE" ]; then
    echo "typography.json already exists. Skipping."
else
    echo "Creating typography.json..."
    cat > "$TYPOGRAPHY_FILE" << 'EOF'
{
  "font": {
    "family": {
      "sans": { "value": "Inter, -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif" },
      "mono": { "value": "'JetBrains Mono', 'Fira Code', Consolas, monospace" }
    },
    "size": {
      "xs": { "value": "0.75rem", "comment": "12px" },
      "sm": { "value": "0.875rem", "comment": "14px" },
      "base": { "value": "1rem", "comment": "16px" },
      "lg": { "value": "1.125rem", "comment": "18px" },
      "xl": { "value": "1.25rem", "comment": "20px" },
      "2xl": { "value": "1.5rem", "comment": "24px" },
      "3xl": { "value": "1.875rem", "comment": "30px" },
      "4xl": { "value": "2.25rem", "comment": "36px" }
    },
    "weight": {
      "normal": { "value": "400" },
      "medium": { "value": "500" },
      "semibold": { "value": "600" },
      "bold": { "value": "700" }
    },
    "lineHeight": {
      "tight": { "value": "1.25" },
      "normal": { "value": "1.5" },
      "relaxed": { "value": "1.75" }
    }
  }
}
EOF
fi

# Create shadows.json
SHADOWS_FILE="$SRC_DIR/shadows.json"
if [ -f "$SHADOWS_FILE" ]; then
    echo "shadows.json already exists. Skipping."
else
    echo "Creating shadows.json..."
    cat > "$SHADOWS_FILE" << 'EOF'
{
  "shadow": {
    "none": { "value": "none" },
    "sm": { "value": "0 1px 2px 0 rgba(0, 0, 0, 0.05)" },
    "default": { "value": "0 1px 3px 0 rgba(0, 0, 0, 0.1), 0 1px 2px -1px rgba(0, 0, 0, 0.1)" },
    "md": { "value": "0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -2px rgba(0, 0, 0, 0.1)" },
    "lg": { "value": "0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -4px rgba(0, 0, 0, 0.1)" },
    "xl": { "value": "0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 8px 10px -6px rgba(0, 0, 0, 0.1)" }
  }
}
EOF
fi

# Create borders.json
BORDERS_FILE="$SRC_DIR/borders.json"
if [ -f "$BORDERS_FILE" ]; then
    echo "borders.json already exists. Skipping."
else
    echo "Creating borders.json..."
    cat > "$BORDERS_FILE" << 'EOF'
{
  "border": {
    "radius": {
      "none": { "value": "0" },
      "sm": { "value": "2px" },
      "default": { "value": "4px" },
      "md": { "value": "6px" },
      "lg": { "value": "8px" },
      "xl": { "value": "12px" },
      "2xl": { "value": "16px" },
      "full": { "value": "9999px" }
    },
    "width": {
      "none": { "value": "0" },
      "thin": { "value": "1px" },
      "default": { "value": "1px" },
      "thick": { "value": "2px" }
    }
  }
}
EOF
fi

echo ""
echo "=== Setup Complete ==="
echo ""
echo "Token files created in: $SRC_DIR"
echo ""
echo "Files:"
ls -la "$SRC_DIR"
echo ""
echo "Next steps:"
echo "  1. Read the README.md for this lab"
echo "  2. Review each token file and understand its structure"
echo "  3. Proceed to Lab 2.4 to build the tokens"
echo ""
