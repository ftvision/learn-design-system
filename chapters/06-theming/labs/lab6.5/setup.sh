#!/bin/bash

# Lab 6.5 Setup Script
# Testing and reflection lab - no new files created

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MONOREPO_DIR="$SCRIPT_DIR/../../../04-monorepo-architecture/labs/lab4.1"
WEB_DIR="$MONOREPO_DIR/apps/web"
UI_DIR="$MONOREPO_DIR/packages/ui"

echo "=== Lab 6.5 Setup: Testing, Comparison & Reflection ==="
echo ""

# Check prerequisites
echo "Checking prerequisites..."
echo ""

PREREQS_MET=true

# Check theme.css (Lab 6.1)
if [ -f "$UI_DIR/src/styles/theme.css" ]; then
    echo "✓ Lab 6.1: theme.css exists"
else
    echo "✗ Lab 6.1: theme.css not found"
    PREREQS_MET=false
fi

# Check updated Button (Lab 6.2)
if [ -f "$UI_DIR/src/components/Button.tsx" ]; then
    if grep -q "var(--color-primary)" "$UI_DIR/src/components/Button.tsx"; then
        echo "✓ Lab 6.2: Button uses theme tokens"
    else
        echo "✗ Lab 6.2: Button not updated with theme tokens"
        PREREQS_MET=false
    fi
else
    echo "✗ Lab 6.2: Button.tsx not found"
    PREREQS_MET=false
fi

# Check useTheme hook (Lab 6.3)
if [ -f "$WEB_DIR/hooks/useTheme.ts" ]; then
    echo "✓ Lab 6.3: useTheme hook exists"
else
    echo "✗ Lab 6.3: useTheme hook not found"
    PREREQS_MET=false
fi

# Check ThemeToggle (Lab 6.3)
if [ -f "$WEB_DIR/components/ThemeToggle.tsx" ]; then
    echo "✓ Lab 6.3: ThemeToggle component exists"
else
    echo "✗ Lab 6.3: ThemeToggle component not found"
    PREREQS_MET=false
fi

# Check layout.tsx (Lab 6.4)
if [ -f "$WEB_DIR/app/layout.tsx" ]; then
    if grep -q "suppressHydrationWarning" "$WEB_DIR/app/layout.tsx"; then
        echo "✓ Lab 6.4: layout.tsx has flash prevention"
    else
        echo "✗ Lab 6.4: layout.tsx missing flash prevention"
        PREREQS_MET=false
    fi
else
    echo "✗ Lab 6.4: layout.tsx not found"
    PREREQS_MET=false
fi

echo ""

if [ "$PREREQS_MET" = false ]; then
    echo "⚠️  Some prerequisites are missing."
    echo "Please complete the previous labs first."
    echo ""
fi

echo "=== Testing Checklist ==="
echo ""
echo "Manual Testing:"
echo "  [ ] Theme toggle cycles: light → dark → system"
echo "  [ ] Visual changes apply correctly"
echo "  [ ] Theme persists after refresh"
echo "  [ ] No flash of wrong theme"
echo "  [ ] System preference detection works"
echo ""
echo "Comparison Tasks:"
echo "  [ ] Review Supabase theming approach"
echo "  [ ] Review Cal.com theming approach"
echo ""
echo "Reflection:"
echo "  [ ] Answer questions in README.md"
echo ""
echo "To start testing:"
echo "  cd $MONOREPO_DIR"
echo "  pnpm dev"
echo ""
echo "Then open http://localhost:3000 in your browser."
echo ""
