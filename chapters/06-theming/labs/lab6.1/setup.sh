#!/bin/bash

# Lab 6.1 Setup Script
# Creates theme CSS with primitive and semantic tokens

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MONOREPO_DIR="$SCRIPT_DIR/../../../04-monorepo-architecture/labs/lab4.1"
UI_DIR="$MONOREPO_DIR/packages/ui"

echo "=== Lab 6.1 Setup: Create Theme CSS ==="
echo ""

# Check if monorepo exists
if [ ! -d "$MONOREPO_DIR" ]; then
    echo "Error: Chapter 4 monorepo not found at $MONOREPO_DIR"
    echo "Please complete Chapter 4 labs first."
    exit 1
fi

# Check if UI package exists
if [ ! -d "$UI_DIR" ]; then
    echo "Error: UI package not found at $UI_DIR"
    echo "Please complete Chapter 4 labs first."
    exit 1
fi

# Create styles directory
mkdir -p "$UI_DIR/src/styles"

# Create theme.css
THEME_FILE="$UI_DIR/src/styles/theme.css"
if [ -f "$THEME_FILE" ]; then
    echo "theme.css already exists. Skipping."
else
    echo "Creating theme.css..."
    cat > "$THEME_FILE" << 'EOF'
/*
 * Design System Theme Tokens
 *
 * Primitive tokens stay constant.
 * Semantic tokens change per theme.
 */

/* ===== Primitive Tokens ===== */
:root {
  /* Gray scale */
  --gray-50: #F9FAFB;
  --gray-100: #F3F4F6;
  --gray-200: #E5E7EB;
  --gray-300: #D1D5DB;
  --gray-400: #9CA3AF;
  --gray-500: #6B7280;
  --gray-600: #4B5563;
  --gray-700: #374151;
  --gray-800: #1F2937;
  --gray-900: #111827;
  --gray-950: #030712;

  /* Primary (Blue) */
  --blue-50: #EFF6FF;
  --blue-100: #DBEAFE;
  --blue-500: #3B82F6;
  --blue-600: #2563EB;
  --blue-700: #1D4ED8;

  /* Success (Green) */
  --green-50: #F0FDF4;
  --green-500: #22C55E;
  --green-600: #16A34A;

  /* Warning (Amber) */
  --amber-50: #FFFBEB;
  --amber-500: #F59E0B;
  --amber-600: #D97706;

  /* Error (Red) */
  --red-50: #FEF2F2;
  --red-500: #EF4444;
  --red-600: #DC2626;

  /* White/Black */
  --white: #FFFFFF;
  --black: #000000;
}

/* ===== Semantic Tokens - Light Theme (Default) ===== */
:root {
  /* Backgrounds */
  --color-bg: var(--white);
  --color-bg-subtle: var(--gray-50);
  --color-bg-muted: var(--gray-100);
  --color-bg-emphasis: var(--gray-200);

  /* Foreground / Text */
  --color-text: var(--gray-900);
  --color-text-muted: var(--gray-600);
  --color-text-subtle: var(--gray-400);
  --color-text-on-emphasis: var(--white);

  /* Borders */
  --color-border: var(--gray-200);
  --color-border-muted: var(--gray-100);
  --color-border-emphasis: var(--gray-300);

  /* Primary */
  --color-primary: var(--blue-600);
  --color-primary-hover: var(--blue-700);
  --color-primary-subtle: var(--blue-50);
  --color-primary-text: var(--white);

  /* Success */
  --color-success: var(--green-500);
  --color-success-subtle: var(--green-50);

  /* Warning */
  --color-warning: var(--amber-500);
  --color-warning-subtle: var(--amber-50);

  /* Error */
  --color-error: var(--red-500);
  --color-error-subtle: var(--red-50);

  /* Shadows */
  --shadow-sm: 0 1px 2px 0 rgb(0 0 0 / 0.05);
  --shadow-md: 0 4px 6px -1px rgb(0 0 0 / 0.1), 0 2px 4px -2px rgb(0 0 0 / 0.1);
  --shadow-lg: 0 10px 15px -3px rgb(0 0 0 / 0.1), 0 4px 6px -4px rgb(0 0 0 / 0.1);

  /* Focus ring */
  --ring-color: var(--blue-500);
  --ring-offset-color: var(--white);
}

/* ===== Semantic Tokens - Dark Theme ===== */
.dark {
  /* Backgrounds */
  --color-bg: var(--gray-950);
  --color-bg-subtle: var(--gray-900);
  --color-bg-muted: var(--gray-800);
  --color-bg-emphasis: var(--gray-700);

  /* Foreground / Text */
  --color-text: var(--gray-50);
  --color-text-muted: var(--gray-400);
  --color-text-subtle: var(--gray-500);
  --color-text-on-emphasis: var(--white);

  /* Borders */
  --color-border: var(--gray-800);
  --color-border-muted: var(--gray-900);
  --color-border-emphasis: var(--gray-700);

  /* Primary */
  --color-primary: var(--blue-500);
  --color-primary-hover: var(--blue-600);
  --color-primary-subtle: rgba(59, 130, 246, 0.1);
  --color-primary-text: var(--white);

  /* Success */
  --color-success: var(--green-500);
  --color-success-subtle: rgba(34, 197, 94, 0.1);

  /* Warning */
  --color-warning: var(--amber-500);
  --color-warning-subtle: rgba(245, 158, 11, 0.1);

  /* Error */
  --color-error: var(--red-500);
  --color-error-subtle: rgba(239, 68, 68, 0.1);

  /* Shadows (more subtle in dark mode) */
  --shadow-sm: 0 1px 2px 0 rgb(0 0 0 / 0.3);
  --shadow-md: 0 4px 6px -1px rgb(0 0 0 / 0.4), 0 2px 4px -2px rgb(0 0 0 / 0.3);
  --shadow-lg: 0 10px 15px -3px rgb(0 0 0 / 0.5), 0 4px 6px -4px rgb(0 0 0 / 0.4);

  /* Focus ring */
  --ring-color: var(--blue-500);
  --ring-offset-color: var(--gray-950);
}
EOF
fi

# Update package.json to export styles
PACKAGE_JSON="$UI_DIR/package.json"
if [ -f "$PACKAGE_JSON" ]; then
    # Check if exports already has styles
    if grep -q '"./styles"' "$PACKAGE_JSON"; then
        echo "package.json already exports styles. Skipping."
    else
        echo "Updating package.json to export styles..."
        # Use node to update package.json properly
        node -e "
const fs = require('fs');
const pkg = JSON.parse(fs.readFileSync('$PACKAGE_JSON', 'utf8'));
if (!pkg.exports) {
  pkg.exports = {};
}
if (typeof pkg.exports === 'string') {
  const main = pkg.exports;
  pkg.exports = { '.': main };
}
pkg.exports['./styles'] = './src/styles/theme.css';
fs.writeFileSync('$PACKAGE_JSON', JSON.stringify(pkg, null, 2) + '\n');
"
    fi
else
    echo "Warning: package.json not found at $PACKAGE_JSON"
fi

echo ""
echo "=== Setup Complete ==="
echo ""
echo "Files created/updated:"
echo "  - $THEME_FILE"
echo "  - $PACKAGE_JSON (exports updated)"
echo ""
echo "Next steps:"
echo "  1. Read the README.md for this lab"
echo "  2. Examine the primitive and semantic tokens"
echo "  3. Understand light vs dark theme structure"
echo "  4. Proceed to Lab 6.2 to update components"
echo ""
