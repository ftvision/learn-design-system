#!/bin/bash

# Lab 7.1 Setup Script
# Sets up Storybook for the design system

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MONOREPO_DIR="$SCRIPT_DIR/../../../04-monorepo-architecture/labs/lab4.1"
DOCS_DIR="$MONOREPO_DIR/apps/docs"

echo "=== Lab 7.1 Setup: Set Up Storybook ==="
echo ""

# Check if monorepo exists
if [ ! -d "$MONOREPO_DIR" ]; then
    echo "Error: Chapter 4 monorepo not found at $MONOREPO_DIR"
    echo "Please complete Chapter 4 labs first."
    exit 1
fi

# Check if theme.css exists (Chapter 6 prerequisite)
THEME_FILE="$MONOREPO_DIR/packages/ui/src/styles/theme.css"
if [ ! -f "$THEME_FILE" ]; then
    echo "Warning: theme.css not found. Chapter 6 may not be complete."
    echo "Continuing anyway..."
fi

# Create docs app directory
mkdir -p "$DOCS_DIR/.storybook"
mkdir -p "$DOCS_DIR/stories"

# Create package.json
PACKAGE_FILE="$DOCS_DIR/package.json"
if [ -f "$PACKAGE_FILE" ]; then
    echo "package.json already exists. Skipping."
else
    echo "Creating package.json..."
    cat > "$PACKAGE_FILE" << 'EOF'
{
  "name": "@myapp/docs",
  "version": "0.0.1",
  "private": true,
  "scripts": {
    "dev": "storybook dev -p 6006",
    "build": "storybook build",
    "preview": "npx http-server storybook-static"
  },
  "dependencies": {
    "@myapp/ui": "workspace:*",
    "react": "^18.2.0",
    "react-dom": "^18.2.0"
  },
  "devDependencies": {
    "@storybook/addon-essentials": "^8.4.0",
    "@storybook/addon-interactions": "^8.4.0",
    "@storybook/addon-links": "^8.4.0",
    "@storybook/blocks": "^8.4.0",
    "@storybook/react": "^8.4.0",
    "@storybook/react-vite": "^8.4.0",
    "@storybook/test": "^8.4.0",
    "storybook": "^8.4.0",
    "vite": "^5.0.0",
    "@types/react": "^18.2.0",
    "@types/react-dom": "^18.2.0",
    "typescript": "^5.0.0"
  }
}
EOF
fi

# Create main.ts
MAIN_FILE="$DOCS_DIR/.storybook/main.ts"
if [ -f "$MAIN_FILE" ]; then
    echo "main.ts already exists. Skipping."
else
    echo "Creating .storybook/main.ts..."
    cat > "$MAIN_FILE" << 'EOF'
import type { StorybookConfig } from "@storybook/react-vite";

const config: StorybookConfig = {
  stories: [
    "../stories/**/*.mdx",
    "../stories/**/*.stories.@(js|jsx|mjs|ts|tsx)",
    // Include UI package stories
    "../../../packages/ui/src/**/*.stories.@(js|jsx|ts|tsx)",
  ],
  addons: [
    "@storybook/addon-links",
    "@storybook/addon-essentials",
    "@storybook/addon-interactions",
  ],
  framework: {
    name: "@storybook/react-vite",
    options: {},
  },
  docs: {
    autodocs: "tag",
  },
};

export default config;
EOF
fi

# Create preview.ts
PREVIEW_FILE="$DOCS_DIR/.storybook/preview.ts"
if [ -f "$PREVIEW_FILE" ]; then
    echo "preview.ts already exists. Skipping."
else
    echo "Creating .storybook/preview.ts..."
    cat > "$PREVIEW_FILE" << 'EOF'
import type { Preview } from "@storybook/react";
import "@myapp/ui/styles";

const preview: Preview = {
  parameters: {
    controls: {
      matchers: {
        color: /(background|color)$/i,
        date: /Date$/i,
      },
    },
    backgrounds: {
      default: "light",
      values: [
        { name: "light", value: "#ffffff" },
        { name: "dark", value: "#030712" },
        { name: "gray", value: "#f3f4f6" },
      ],
    },
  },
  decorators: [
    (Story, context) => {
      // Apply dark class when dark background is selected
      const isDark = context.globals.backgrounds?.value === "#030712";
      document.documentElement.classList.toggle("dark", isDark);

      return (
        <div style={{ padding: "1rem" }}>
          <Story />
        </div>
      );
    },
  ],
};

export default preview;
EOF
fi

# Create welcome story
WELCOME_FILE="$DOCS_DIR/stories/Welcome.mdx"
if [ -f "$WELCOME_FILE" ]; then
    echo "Welcome.mdx already exists. Skipping."
else
    echo "Creating stories/Welcome.mdx..."
    cat > "$WELCOME_FILE" << 'EOF'
import { Meta } from "@storybook/blocks";

<Meta title="Welcome" />

# Design System Documentation

Welcome to the design system component library.

## Getting Started

Browse components in the sidebar to see:
- **Live examples** of each component
- **Controls** to modify props interactively
- **Documentation** auto-generated from TypeScript types

## Components

- **Button** - Action triggers with multiple variants
- **Input** - Text input with labels and validation
- **Card** - Container for grouped content
- **Badge** - Status indicators and labels
- **Avatar** - User profile images with fallbacks

## Theming

Use the background switcher in the toolbar to test light and dark modes.
EOF
fi

# Create tsconfig for docs app
TSCONFIG_FILE="$DOCS_DIR/tsconfig.json"
if [ ! -f "$TSCONFIG_FILE" ]; then
    echo "Creating tsconfig.json..."
    cat > "$TSCONFIG_FILE" << 'EOF'
{
  "compilerOptions": {
    "target": "ES2020",
    "useDefineForClassFields": true,
    "lib": ["ES2020", "DOM", "DOM.Iterable"],
    "module": "ESNext",
    "skipLibCheck": true,
    "moduleResolution": "bundler",
    "allowImportingTsExtensions": true,
    "resolveJsonModule": true,
    "isolatedModules": true,
    "noEmit": true,
    "jsx": "react-jsx",
    "strict": true,
    "noUnusedLocals": true,
    "noUnusedParameters": true,
    "noFallthroughCasesInSwitch": true
  },
  "include": ["stories", ".storybook"]
}
EOF
fi

echo ""
echo "=== Setup Complete ==="
echo ""
echo "Files created:"
echo "  - $PACKAGE_FILE"
echo "  - $MAIN_FILE"
echo "  - $PREVIEW_FILE"
echo "  - $WELCOME_FILE"
echo "  - $TSCONFIG_FILE"
echo ""
echo "Next steps:"
echo "  1. cd $MONOREPO_DIR"
echo "  2. pnpm install"
echo "  3. cd apps/docs && pnpm dev"
echo "  4. Open http://localhost:6006"
echo ""
echo "Note: You'll write component stories in the following labs."
echo ""
