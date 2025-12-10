#!/bin/bash

# Lab 8.5 Setup Script
# Summary and reflection for cross-platform tokens

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MONOREPO_DIR="$SCRIPT_DIR/../../../04-monorepo-architecture/labs/lab4.1"
TOKENS_DIR="$MONOREPO_DIR/packages/tokens"
BUILD_DIR="$TOKENS_DIR/build"

echo "=== Lab 8.5 Setup: Study Carbon & Reflection ==="
echo ""

# Check if monorepo exists
if [ ! -d "$MONOREPO_DIR" ]; then
    echo "Error: Chapter 4 monorepo not found at $MONOREPO_DIR"
    echo "Please complete Chapter 4 labs first."
    exit 1
fi

echo "=== Generated Files Summary ==="
echo ""

if [ -d "$BUILD_DIR" ]; then
    echo "Build directory contents:"
    find "$BUILD_DIR" -type f -name "*.*" | sort | while read -r file; do
        size=$(wc -c < "$file" | tr -d ' ')
        echo "  ${file#$BUILD_DIR/} ($size bytes)"
    done
else
    echo "Build directory not found. Run 'pnpm build' in tokens package."
fi

echo ""
echo "=== Platform Comparison ==="
echo ""
cat << 'EOF'
┌─────────────┬────────────────────┬──────────────────────────┐
│ Platform    │ Format             │ Output File              │
├─────────────┼────────────────────┼──────────────────────────┤
│ Web (CSS)   │ CSS Variables      │ variables.css            │
│ JavaScript  │ ES6 exports        │ tokens.js                │
│ TypeScript  │ ES6 + declarations │ tokens.ts, tokens.d.ts   │
│ iOS         │ Swift enum         │ Colors.swift, etc.       │
│ Android     │ XML resources      │ colors.xml, etc.         │
└─────────────┴────────────────────┴──────────────────────────┘
EOF

echo ""
echo "=== IBM Carbon Repository ==="
echo ""
echo "Explore: https://github.com/carbon-design-system/carbon"
echo ""
echo "Key directories to examine:"
echo "  - packages/colors/   - Color definitions"
echo "  - packages/themes/   - Theme configurations"
echo "  - packages/type/     - Typography tokens"
echo ""

echo "=== Reflection Questions ==="
echo ""
cat << 'EOF'
1. Why generate tokens for multiple platforms instead of copying values?

2. What happens if you need to change a color across all platforms?

3. How would you add a new platform (like Flutter)?

4. What's the hardest part of maintaining cross-platform tokens?

5. How would you handle platform-specific variations?
EOF

echo ""
echo "=== Self-Check ==="
echo ""
cat << 'EOF'
Before completing Chapter 8, verify:

[ ] Style Dictionary generates iOS Swift files
[ ] Style Dictionary generates Android XML files
[ ] TypeScript output works for React Native
[ ] You understand how native apps consume these files
[ ] You explored IBM Carbon's token approach
[ ] You completed the written reflection
EOF

echo ""
echo "=== Setup Complete ==="
echo ""
echo "Next steps:"
echo "  1. Read the README.md for this lab"
echo "  2. Explore IBM Carbon repository"
echo "  3. Complete the written reflection"
echo "  4. Review all generated files"
echo ""
