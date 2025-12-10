#!/bin/bash

# Lab 4.2 Setup Script
# Creates shared configurations (TypeScript, Tailwind)

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LAB41_DIR="$SCRIPT_DIR/../lab4.1"
CONFIG_DIR="$LAB41_DIR/packages/config"

echo "=== Lab 4.2 Setup: Shared Configurations ==="
echo ""

# Ensure Lab 4.1 is complete
if [ ! -f "$LAB41_DIR/package.json" ]; then
    echo "Lab 4.1 not complete. Running setup..."
    cd "$LAB41_DIR" && ./setup.sh && cd "$SCRIPT_DIR"
fi

# Create config package directory
mkdir -p "$CONFIG_DIR/tsconfig"

# Create config package.json
CONFIG_PACKAGE="$CONFIG_DIR/package.json"
if [ -f "$CONFIG_PACKAGE" ]; then
    echo "packages/config/package.json already exists. Skipping."
else
    echo "Creating config package.json..."
    cat > "$CONFIG_PACKAGE" << 'EOF'
{
  "name": "@myapp/config",
  "version": "0.0.0",
  "private": true,
  "exports": {
    "./tsconfig/base": "./tsconfig/base.json",
    "./tsconfig/react": "./tsconfig/react.json",
    "./tsconfig/nextjs": "./tsconfig/nextjs.json",
    "./tailwind": "./tailwind.config.js"
  }
}
EOF
fi

# Create base TypeScript config
BASE_TSCONFIG="$CONFIG_DIR/tsconfig/base.json"
if [ -f "$BASE_TSCONFIG" ]; then
    echo "tsconfig/base.json already exists. Skipping."
else
    echo "Creating base TypeScript config..."
    cat > "$BASE_TSCONFIG" << 'EOF'
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "compilerOptions": {
    "target": "ES2020",
    "lib": ["ES2020"],
    "module": "ESNext",
    "moduleResolution": "bundler",
    "strict": true,
    "declaration": true,
    "declarationMap": true,
    "sourceMap": true,
    "esModuleInterop": true,
    "allowSyntheticDefaultImports": true,
    "forceConsistentCasingInFileNames": true,
    "skipLibCheck": true,
    "resolveJsonModule": true,
    "isolatedModules": true
  }
}
EOF
fi

# Create React TypeScript config
REACT_TSCONFIG="$CONFIG_DIR/tsconfig/react.json"
if [ -f "$REACT_TSCONFIG" ]; then
    echo "tsconfig/react.json already exists. Skipping."
else
    echo "Creating React TypeScript config..."
    cat > "$REACT_TSCONFIG" << 'EOF'
{
  "extends": "./base.json",
  "compilerOptions": {
    "lib": ["ES2020", "DOM", "DOM.Iterable"],
    "jsx": "react-jsx",
    "noEmit": true
  }
}
EOF
fi

# Create Next.js TypeScript config
NEXTJS_TSCONFIG="$CONFIG_DIR/tsconfig/nextjs.json"
if [ -f "$NEXTJS_TSCONFIG" ]; then
    echo "tsconfig/nextjs.json already exists. Skipping."
else
    echo "Creating Next.js TypeScript config..."
    cat > "$NEXTJS_TSCONFIG" << 'EOF'
{
  "extends": "./react.json",
  "compilerOptions": {
    "plugins": [{ "name": "next" }],
    "module": "ESNext",
    "moduleResolution": "bundler",
    "allowJs": true
  }
}
EOF
fi

# Create shared Tailwind config
TAILWIND_CONFIG="$CONFIG_DIR/tailwind.config.js"
if [ -f "$TAILWIND_CONFIG" ]; then
    echo "tailwind.config.js already exists. Skipping."
else
    echo "Creating shared Tailwind config..."
    cat > "$TAILWIND_CONFIG" << 'EOF'
/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    // Include all packages and apps
    "../../packages/ui/src/**/*.{js,ts,jsx,tsx}",
    "./src/**/*.{js,ts,jsx,tsx}",
    "./app/**/*.{js,ts,jsx,tsx}",
    "./components/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      // Custom theme values can be added here
      // Or import from tokens package
    },
  },
  plugins: [],
};
EOF
fi

echo ""
echo "=== Setup Complete ==="
echo ""
echo "Config files created:"
echo "  - $CONFIG_PACKAGE"
echo "  - $BASE_TSCONFIG"
echo "  - $REACT_TSCONFIG"
echo "  - $NEXTJS_TSCONFIG"
echo "  - $TAILWIND_CONFIG"
echo ""
echo "Next steps:"
echo "  1. Read the README.md for this lab"
echo "  2. Understand config inheritance"
echo "  3. Proceed to Lab 4.3 to wire packages"
echo ""
