#!/bin/bash

# Lab 8.4 Setup Script
# Examines Android XML output and React Native usage

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MONOREPO_DIR="$SCRIPT_DIR/../../../04-monorepo-architecture/labs/lab4.1"
TOKENS_DIR="$MONOREPO_DIR/packages/tokens"
ANDROID_DIR="$TOKENS_DIR/build/android"
TS_DIR="$TOKENS_DIR/build/ts"

echo "=== Lab 8.4 Setup: Android XML Output ==="
echo ""

# Check if monorepo exists
if [ ! -d "$MONOREPO_DIR" ]; then
    echo "Error: Chapter 4 monorepo not found at $MONOREPO_DIR"
    echo "Please complete Chapter 4 labs first."
    exit 1
fi

# Check if build exists
if [ ! -d "$ANDROID_DIR" ]; then
    echo "Warning: Android build directory not found."
    echo "Running build..."
    cd "$TOKENS_DIR"
    npx style-dictionary build 2>/dev/null || {
        echo "Error: Build failed. Please complete Lab 8.2 first."
        exit 1
    }
fi

echo "=== Android XML Files ==="
echo ""

# Display colors.xml
if [ -f "$ANDROID_DIR/colors.xml" ]; then
    echo "--- colors.xml ---"
    cat "$ANDROID_DIR/colors.xml"
    echo ""
else
    echo "colors.xml not found"
fi

# Display dimens.xml
if [ -f "$ANDROID_DIR/dimens.xml" ]; then
    echo "--- dimens.xml ---"
    cat "$ANDROID_DIR/dimens.xml"
    echo ""
else
    echo "dimens.xml not found"
fi

# Display font_sizes.xml
if [ -f "$ANDROID_DIR/font_sizes.xml" ]; then
    echo "--- font_sizes.xml ---"
    cat "$ANDROID_DIR/font_sizes.xml"
    echo ""
else
    echo "font_sizes.xml not found"
fi

echo ""
echo "=== TypeScript Output (for React Native) ==="
echo ""

if [ -f "$TS_DIR/tokens.ts" ]; then
    echo "--- tokens.ts (first 30 lines) ---"
    head -30 "$TS_DIR/tokens.ts"
    echo ""
    echo "[... truncated ...]"
else
    echo "tokens.ts not found"
fi

echo ""
echo "=== Android Layout XML Usage ==="
echo ""
cat << 'EOF'
<Button
    android:layout_width="wrap_content"
    android:layout_height="wrap_content"
    android:background="@color/color_primary_500"
    android:textColor="@color/color_white"
    android:paddingStart="@dimen/spacing_4"
    android:paddingEnd="@dimen/spacing_4"
    android:text="Submit" />
EOF

echo ""
echo "=== Android Kotlin Usage ==="
echo ""
cat << 'EOF'
val color = ContextCompat.getColor(context, R.color.color_primary_500)
val padding = resources.getDimensionPixelSize(R.dimen.spacing_4)
EOF

echo ""
echo "=== React Native Usage ==="
echo ""
cat << 'EOF'
import { colorPrimary500, spacing4 } from '@myapp/tokens';

const styles = StyleSheet.create({
  button: {
    backgroundColor: colorPrimary500,
    paddingHorizontal: parseInt(spacing4),
  },
});
EOF

echo ""
echo "=== Setup Complete ==="
echo ""
echo "Android files location: $ANDROID_DIR"
echo "TypeScript files location: $TS_DIR"
echo ""
echo "Next steps:"
echo "  1. Read the README.md for this lab"
echo "  2. Understand Android XML resources format"
echo "  3. Understand React Native token usage"
echo "  4. Proceed to Lab 8.5 for Carbon study and reflection"
echo ""
