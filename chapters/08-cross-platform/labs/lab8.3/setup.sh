#!/bin/bash

# Lab 8.3 Setup Script
# Examines iOS Swift output

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MONOREPO_DIR="$SCRIPT_DIR/../../../04-monorepo-architecture/labs/lab4.1"
TOKENS_DIR="$MONOREPO_DIR/packages/tokens"
IOS_DIR="$TOKENS_DIR/build/ios"

echo "=== Lab 8.3 Setup: iOS Swift Output ==="
echo ""

# Check if monorepo exists
if [ ! -d "$MONOREPO_DIR" ]; then
    echo "Error: Chapter 4 monorepo not found at $MONOREPO_DIR"
    echo "Please complete Chapter 4 labs first."
    exit 1
fi

# Check if build exists
if [ ! -d "$IOS_DIR" ]; then
    echo "Warning: iOS build directory not found."
    echo "Running build..."
    cd "$TOKENS_DIR"
    npx style-dictionary build 2>/dev/null || {
        echo "Error: Build failed. Please complete Lab 8.2 first."
        exit 1
    }
fi

echo "=== iOS Swift Files ==="
echo ""

# Display Colors.swift
if [ -f "$IOS_DIR/Colors.swift" ]; then
    echo "--- Colors.swift ---"
    head -30 "$IOS_DIR/Colors.swift"
    echo ""
    echo "[... truncated ...]"
    echo ""
else
    echo "Colors.swift not found"
fi

# Display Spacing.swift
if [ -f "$IOS_DIR/Spacing.swift" ]; then
    echo "--- Spacing.swift ---"
    cat "$IOS_DIR/Spacing.swift"
    echo ""
else
    echo "Spacing.swift not found"
fi

# Display Typography.swift
if [ -f "$IOS_DIR/Typography.swift" ]; then
    echo "--- Typography.swift ---"
    cat "$IOS_DIR/Typography.swift"
    echo ""
else
    echo "Typography.swift not found"
fi

echo ""
echo "=== SwiftUI Usage Example ==="
echo ""
cat << 'EOF'
import SwiftUI

struct PrimaryButton: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .foregroundColor(Color(Colors.colorWhite))
                .padding(.horizontal, Spacing.spacing4)
                .padding(.vertical, Spacing.spacing2)
        }
        .background(Color(Colors.colorPrimary500))
        .cornerRadius(8)
    }
}
EOF

echo ""
echo "=== UIKit Usage Example ==="
echo ""
cat << 'EOF'
import UIKit

class CustomButton: UIButton {
    private func setup() {
        backgroundColor = Colors.colorPrimary500
        setTitleColor(Colors.colorWhite, for: .normal)
        layer.cornerRadius = 8
    }
}
EOF

echo ""
echo "=== Setup Complete ==="
echo ""
echo "iOS files location: $IOS_DIR"
echo ""
echo "Next steps:"
echo "  1. Read the README.md for this lab"
echo "  2. Examine the generated Swift files"
echo "  3. Understand UIColor and CGFloat usage"
echo "  4. Proceed to Lab 8.4 for Android output"
echo ""
