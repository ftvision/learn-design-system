#!/bin/bash

# Lab 7.5 Setup Script
# Updates Storybook with theme toggle and verifies setup

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MONOREPO_DIR="$SCRIPT_DIR/../../../04-monorepo-architecture/labs/lab4.1"
DOCS_DIR="$MONOREPO_DIR/apps/docs"
UI_DIR="$MONOREPO_DIR/packages/ui"
COMPONENTS_DIR="$UI_DIR/src/components"

echo "=== Lab 7.5 Setup: Theme Toggle & Testing ==="
echo ""

# Check if monorepo exists
if [ ! -d "$MONOREPO_DIR" ]; then
    echo "Error: Chapter 4 monorepo not found at $MONOREPO_DIR"
    echo "Please complete Chapter 4 labs first."
    exit 1
fi

# Check prerequisites
echo "Checking prerequisites..."
PREREQS_MET=true

if [ -f "$COMPONENTS_DIR/Button.stories.tsx" ]; then
    echo "✓ Button.stories.tsx exists"
else
    echo "✗ Button.stories.tsx not found"
    PREREQS_MET=false
fi

if [ -f "$COMPONENTS_DIR/Input.stories.tsx" ]; then
    echo "✓ Input.stories.tsx exists"
else
    echo "✗ Input.stories.tsx not found"
    PREREQS_MET=false
fi

if [ -f "$COMPONENTS_DIR/Card.stories.tsx" ]; then
    echo "✓ Card.stories.tsx exists"
else
    echo "✗ Card.stories.tsx not found"
    PREREQS_MET=false
fi

if [ -f "$COMPONENTS_DIR/Badge.stories.tsx" ]; then
    echo "✓ Badge.stories.tsx exists"
else
    echo "✗ Badge.stories.tsx not found"
    PREREQS_MET=false
fi

if [ -f "$COMPONENTS_DIR/Avatar.stories.tsx" ]; then
    echo "✓ Avatar.stories.tsx exists"
else
    echo "✗ Avatar.stories.tsx not found"
    PREREQS_MET=false
fi

echo ""

if [ "$PREREQS_MET" = false ]; then
    echo "⚠️  Some story files are missing."
    echo "Please complete Labs 7.2-7.4 first."
    echo ""
fi

# Update preview.ts with theme toolbar
PREVIEW_FILE="$DOCS_DIR/.storybook/preview.ts"
echo "Updating preview.ts with theme toolbar..."
cat > "$PREVIEW_FILE" << 'EOF'
import type { Preview } from "@storybook/react";
import "@myapp/ui/styles";

const preview: Preview = {
  globalTypes: {
    theme: {
      description: "Theme for components",
      defaultValue: "light",
      toolbar: {
        title: "Theme",
        icon: "circlehollow",
        items: [
          { value: "light", icon: "sun", title: "Light" },
          { value: "dark", icon: "moon", title: "Dark" },
        ],
        dynamicTitle: true,
      },
    },
  },
  decorators: [
    (Story, context) => {
      const theme = context.globals.theme || "light";
      document.documentElement.classList.toggle("dark", theme === "dark");

      return (
        <div
          style={{
            padding: "1rem",
            backgroundColor: theme === "dark" ? "#030712" : "#ffffff",
            minHeight: "100vh",
          }}
        >
          <Story />
        </div>
      );
    },
  ],
  parameters: {
    controls: {
      matchers: {
        color: /(background|color)$/i,
        date: /Date$/i,
      },
    },
  },
};

export default preview;
EOF

echo ""
echo "=== Setup Complete ==="
echo ""
echo "Files updated:"
echo "  - $PREVIEW_FILE"
echo ""
echo "=== Verification Checklist ==="
echo ""
echo "Run Storybook and verify:"
echo "  [ ] Theme toggle appears in toolbar"
echo "  [ ] Clicking toggle switches theme"
echo "  [ ] Button variants work in both themes"
echo "  [ ] Input states visible in both themes"
echo "  [ ] Card borders/shadows work in both themes"
echo "  [ ] Badge variants distinguishable"
echo "  [ ] Avatar displays correctly"
echo ""
echo "To run Storybook:"
echo "  cd $MONOREPO_DIR"
echo "  pnpm install"
echo "  cd apps/docs && pnpm dev"
echo ""
