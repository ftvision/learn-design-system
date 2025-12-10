#!/bin/bash

# Lab 3.1 Setup Script
# Creates the UI package structure with dependencies

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COURSE_DIR="$SCRIPT_DIR/../../../.."
UI_DIR="$SCRIPT_DIR/packages/ui"

echo "=== Lab 3.1 Setup: UI Package ==="
echo ""

# Create the package structure
if [ -d "$UI_DIR" ]; then
    echo "packages/ui already exists. Skipping directory creation."
else
    echo "Creating packages/ui directory structure..."
    mkdir -p "$UI_DIR/src/components"
    mkdir -p "$UI_DIR/src/lib"
fi

# Create package.json
PACKAGE_JSON="$UI_DIR/package.json"
if [ -f "$PACKAGE_JSON" ]; then
    echo "package.json already exists. Skipping."
else
    echo "Creating package.json..."
    cat > "$PACKAGE_JSON" << 'EOF'
{
  "name": "@myapp/ui",
  "version": "0.0.1",
  "description": "Primitive UI components for the design system",
  "main": "./src/index.tsx",
  "module": "./src/index.tsx",
  "types": "./src/index.tsx",
  "exports": {
    ".": "./src/index.tsx",
    "./button": "./src/components/Button.tsx",
    "./input": "./src/components/Input.tsx",
    "./card": "./src/components/Card.tsx",
    "./badge": "./src/components/Badge.tsx",
    "./avatar": "./src/components/Avatar.tsx"
  },
  "peerDependencies": {
    "react": "^18.0.0",
    "react-dom": "^18.0.0"
  },
  "dependencies": {
    "class-variance-authority": "^0.7.0",
    "clsx": "^2.0.0",
    "tailwind-merge": "^2.0.0"
  },
  "devDependencies": {
    "@types/react": "^18.0.0",
    "@types/react-dom": "^18.0.0",
    "typescript": "^5.0.0"
  },
  "scripts": {
    "typecheck": "tsc --noEmit"
  },
  "keywords": [
    "react",
    "components",
    "design-system",
    "ui"
  ],
  "license": "MIT"
}
EOF
fi

# Create tsconfig.json
TSCONFIG="$UI_DIR/tsconfig.json"
if [ -f "$TSCONFIG" ]; then
    echo "tsconfig.json already exists. Skipping."
else
    echo "Creating tsconfig.json..."
    cat > "$TSCONFIG" << 'EOF'
{
  "compilerOptions": {
    "target": "ES2020",
    "lib": ["ES2020", "DOM", "DOM.Iterable"],
    "module": "ESNext",
    "moduleResolution": "bundler",
    "jsx": "react-jsx",
    "strict": true,
    "declaration": true,
    "declarationMap": true,
    "sourceMap": true,
    "skipLibCheck": true,
    "esModuleInterop": true,
    "allowSyntheticDefaultImports": true,
    "forceConsistentCasingInFileNames": true,
    "resolveJsonModule": true,
    "isolatedModules": true,
    "noEmit": true
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules"]
}
EOF
fi

# Create utils.ts
UTILS_FILE="$UI_DIR/src/lib/utils.ts"
if [ -f "$UTILS_FILE" ]; then
    echo "utils.ts already exists. Skipping."
else
    echo "Creating src/lib/utils.ts..."
    cat > "$UTILS_FILE" << 'EOF'
import { clsx, type ClassValue } from "clsx";
import { twMerge } from "tailwind-merge";

/**
 * Merges class names with Tailwind CSS conflict resolution.
 *
 * @example
 * cn("px-4 py-2", "px-6") // Returns "py-2 px-6" (px-6 wins)
 * cn("text-red-500", isError && "text-blue-500") // Conditional classes
 */
export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs));
}
EOF
fi

# Install dependencies
echo ""
echo "Installing dependencies..."
cd "$UI_DIR"
npm install

echo ""
echo "=== Setup Complete ==="
echo ""
echo "UI package created at: $UI_DIR"
echo ""
echo "Directory structure:"
echo "  packages/ui/"
echo "  ├── src/"
echo "  │   ├── components/  # Add components here"
echo "  │   └── lib/"
echo "  │       └── utils.ts # cn() utility"
echo "  ├── package.json"
echo "  └── tsconfig.json"
echo ""
echo "Next steps:"
echo "  1. Read the README.md for this lab"
echo "  2. Verify with: cd packages/ui && npm run typecheck"
echo "  3. Proceed to Lab 3.2 to build the Button component"
echo ""
