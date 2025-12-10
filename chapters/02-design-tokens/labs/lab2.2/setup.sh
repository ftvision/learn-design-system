#!/bin/bash

# Lab 2.2 Setup Script
# Creates color token files

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LAB21_DIR="$SCRIPT_DIR/../lab2.1"
TOKENS_DIR="$LAB21_DIR/packages/tokens"

echo "=== Lab 2.2 Setup: Color Tokens ==="
echo ""

# Check if Lab 2.1 is complete
if [ ! -d "$TOKENS_DIR" ]; then
    echo "Lab 2.1 not complete. Running Lab 2.1 setup first..."
    cd "$LAB21_DIR"
    ./setup.sh
    cd "$SCRIPT_DIR"
fi

# Create colors.json with starter content
COLORS_FILE="$TOKENS_DIR/src/colors.json"
if [ -f "$COLORS_FILE" ]; then
    echo "colors.json already exists. Skipping creation."
    echo "If you want to start fresh, delete it and run setup again."
else
    echo "Creating starter colors.json..."
    cat > "$COLORS_FILE" << 'EOF'
{
  "color": {
    "primary": {
      "50": { "value": "#E3F2FD", "comment": "Lightest primary" },
      "100": { "value": "#BBDEFB" },
      "200": { "value": "#90CAF9" },
      "300": { "value": "#64B5F6" },
      "400": { "value": "#42A5F5" },
      "500": { "value": "#2196F3", "comment": "Default primary" },
      "600": { "value": "#1E88E5" },
      "700": { "value": "#1976D2" },
      "800": { "value": "#1565C0" },
      "900": { "value": "#0D47A1", "comment": "Darkest primary" }
    },
    "neutral": {
      "0": { "value": "#FFFFFF" },
      "50": { "value": "#FAFAFA" },
      "100": { "value": "#F5F5F5" },
      "200": { "value": "#EEEEEE" },
      "300": { "value": "#E0E0E0" },
      "400": { "value": "#BDBDBD" },
      "500": { "value": "#9E9E9E" },
      "600": { "value": "#757575" },
      "700": { "value": "#616161" },
      "800": { "value": "#424242" },
      "900": { "value": "#212121" },
      "1000": { "value": "#000000" }
    },
    "success": {
      "light": { "value": "#81C784" },
      "default": { "value": "#4CAF50" },
      "dark": { "value": "#388E3C" }
    },
    "warning": {
      "light": { "value": "#FFB74D" },
      "default": { "value": "#FF9800" },
      "dark": { "value": "#F57C00" }
    },
    "error": {
      "light": { "value": "#E57373" },
      "default": { "value": "#F44336" },
      "dark": { "value": "#D32F2F" }
    }
  }
}
EOF
    echo ""
    echo "NOTE: The 'info' color is missing! Add it as an exercise."
fi

echo ""
echo "=== Setup Complete ==="
echo ""
echo "Color tokens file: $COLORS_FILE"
echo ""
echo "Next steps:"
echo "  1. Read the README.md for this lab"
echo "  2. Add the missing 'info' color to colors.json"
echo "  3. Proceed to Lab 2.3 for spacing and typography tokens"
echo ""
