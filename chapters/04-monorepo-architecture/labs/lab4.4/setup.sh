#!/bin/bash

# Lab 4.4 Setup Script
# Creates the Next.js web application

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LAB41_DIR="$SCRIPT_DIR/../lab4.1"
LAB42_DIR="$SCRIPT_DIR/../lab4.2"
LAB43_DIR="$SCRIPT_DIR/../lab4.3"
WEB_DIR="$LAB41_DIR/apps/web"

echo "=== Lab 4.4 Setup: Create Web App ==="
echo ""

# Ensure previous labs are complete
if [ ! -f "$LAB41_DIR/package.json" ]; then
    echo "Lab 4.1 not complete. Running setup..."
    cd "$LAB41_DIR" && ./setup.sh && cd "$SCRIPT_DIR"
fi

if [ ! -f "$LAB41_DIR/packages/config/package.json" ]; then
    echo "Lab 4.2 not complete. Running setup..."
    cd "$LAB42_DIR" && ./setup.sh && cd "$SCRIPT_DIR"
fi

if [ ! -f "$LAB41_DIR/packages/ui/package.json" ]; then
    echo "Lab 4.3 not complete. Running setup..."
    cd "$LAB43_DIR" && ./setup.sh && cd "$SCRIPT_DIR"
fi

# Create web app directory structure
mkdir -p "$WEB_DIR/app"

# Create web app package.json
WEB_PACKAGE="$WEB_DIR/package.json"
if [ -f "$WEB_PACKAGE" ]; then
    echo "apps/web/package.json already exists. Skipping."
else
    echo "Creating web app package.json..."
    cat > "$WEB_PACKAGE" << 'EOF'
{
  "name": "@myapp/web",
  "version": "0.0.1",
  "private": true,
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "start": "next start",
    "lint": "next lint"
  },
  "dependencies": {
    "@myapp/tokens": "workspace:*",
    "@myapp/ui": "workspace:*",
    "next": "14.2.0",
    "react": "^18",
    "react-dom": "^18"
  },
  "devDependencies": {
    "@myapp/config": "workspace:*",
    "@types/node": "^20",
    "@types/react": "^18",
    "@types/react-dom": "^18",
    "autoprefixer": "^10.0.0",
    "postcss": "^8",
    "tailwindcss": "^3.4.0",
    "typescript": "^5"
  }
}
EOF
fi

# Create web app tsconfig.json
WEB_TSCONFIG="$WEB_DIR/tsconfig.json"
if [ -f "$WEB_TSCONFIG" ]; then
    echo "apps/web/tsconfig.json already exists. Skipping."
else
    echo "Creating web app tsconfig.json..."
    cat > "$WEB_TSCONFIG" << 'EOF'
{
  "extends": "@myapp/config/tsconfig/nextjs",
  "compilerOptions": {
    "baseUrl": ".",
    "paths": {
      "@/*": ["./*"]
    }
  },
  "include": ["next-env.d.ts", "**/*.ts", "**/*.tsx", ".next/types/**/*.ts"],
  "exclude": ["node_modules"]
}
EOF
fi

# Create tailwind.config.ts
TAILWIND_CONFIG="$WEB_DIR/tailwind.config.ts"
if [ -f "$TAILWIND_CONFIG" ]; then
    echo "tailwind.config.ts already exists. Skipping."
else
    echo "Creating tailwind.config.ts..."
    cat > "$TAILWIND_CONFIG" << 'EOF'
import type { Config } from "tailwindcss";

const config: Config = {
  content: [
    "./app/**/*.{js,ts,jsx,tsx,mdx}",
    "./components/**/*.{js,ts,jsx,tsx,mdx}",
    // Include UI package content
    "../../packages/ui/src/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {},
  },
  plugins: [],
};

export default config;
EOF
fi

# Create postcss.config.mjs
POSTCSS_CONFIG="$WEB_DIR/postcss.config.mjs"
if [ -f "$POSTCSS_CONFIG" ]; then
    echo "postcss.config.mjs already exists. Skipping."
else
    echo "Creating postcss.config.mjs..."
    cat > "$POSTCSS_CONFIG" << 'EOF'
/** @type {import('postcss-load-config').Config} */
const config = {
  plugins: {
    tailwindcss: {},
    autoprefixer: {},
  },
};

export default config;
EOF
fi

# Create next.config.mjs
NEXT_CONFIG="$WEB_DIR/next.config.mjs"
if [ -f "$NEXT_CONFIG" ]; then
    echo "next.config.mjs already exists. Skipping."
else
    echo "Creating next.config.mjs..."
    cat > "$NEXT_CONFIG" << 'EOF'
/** @type {import('next').NextConfig} */
const nextConfig = {
  transpilePackages: ["@myapp/ui"],
};

export default nextConfig;
EOF
fi

# Create next-env.d.ts
NEXT_ENV="$WEB_DIR/next-env.d.ts"
if [ -f "$NEXT_ENV" ]; then
    echo "next-env.d.ts already exists. Skipping."
else
    echo "Creating next-env.d.ts..."
    cat > "$NEXT_ENV" << 'EOF'
/// <reference types="next" />
/// <reference types="next/image-types/global" />

// NOTE: This file should not be edited
// see https://nextjs.org/docs/basic-features/typescript for more information.
EOF
fi

# Create globals.css
GLOBALS_CSS="$WEB_DIR/app/globals.css"
if [ -f "$GLOBALS_CSS" ]; then
    echo "globals.css already exists. Skipping."
else
    echo "Creating globals.css..."
    cat > "$GLOBALS_CSS" << 'EOF'
@tailwind base;
@tailwind components;
@tailwind utilities;
EOF
fi

# Create layout.tsx
LAYOUT_FILE="$WEB_DIR/app/layout.tsx"
if [ -f "$LAYOUT_FILE" ]; then
    echo "layout.tsx already exists. Skipping."
else
    echo "Creating layout.tsx..."
    cat > "$LAYOUT_FILE" << 'EOF'
import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "Design System Demo",
  description: "Monorepo design system demo",
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en">
      <body>{children}</body>
    </html>
  );
}
EOF
fi

# Create page.tsx
PAGE_FILE="$WEB_DIR/app/page.tsx"
if [ -f "$PAGE_FILE" ]; then
    echo "page.tsx already exists. Skipping."
else
    echo "Creating page.tsx..."
    cat > "$PAGE_FILE" << 'EOF'
import {
  Button,
  Input,
  Card,
  CardHeader,
  CardTitle,
  CardContent,
  CardFooter
} from "@myapp/ui";

export default function Home() {
  return (
    <main className="min-h-screen p-8 bg-gray-50">
      <div className="max-w-2xl mx-auto space-y-8">
        <h1 className="text-3xl font-bold text-gray-900">
          Design System Demo
        </h1>

        {/* Button variants */}
        <section>
          <h2 className="text-xl font-semibold mb-4">Buttons</h2>
          <div className="flex flex-wrap gap-4">
            <Button variant="primary">Primary</Button>
            <Button variant="secondary">Secondary</Button>
            <Button variant="destructive">Destructive</Button>
            <Button variant="outline">Outline</Button>
            <Button variant="ghost">Ghost</Button>
            <Button variant="link">Link</Button>
          </div>
        </section>

        {/* Button sizes */}
        <section>
          <h2 className="text-xl font-semibold mb-4">Button Sizes</h2>
          <div className="flex items-center gap-4">
            <Button size="sm">Small</Button>
            <Button size="md">Medium</Button>
            <Button size="lg">Large</Button>
          </div>
        </section>

        {/* Loading state */}
        <section>
          <h2 className="text-xl font-semibold mb-4">Loading State</h2>
          <Button loading>Saving...</Button>
        </section>

        {/* Form example */}
        <Card>
          <CardHeader>
            <CardTitle>Sign Up</CardTitle>
          </CardHeader>
          <CardContent className="space-y-4">
            <Input
              label="Full Name"
              placeholder="John Doe"
            />
            <Input
              label="Email"
              type="email"
              placeholder="john@example.com"
              hint="We'll never share your email"
            />
            <Input
              label="Password"
              type="password"
              error="Password must be at least 8 characters"
            />
          </CardContent>
          <CardFooter className="justify-end">
            <Button variant="secondary">Cancel</Button>
            <Button>Create Account</Button>
          </CardFooter>
        </Card>
      </div>
    </main>
  );
}
EOF
fi

echo ""
echo "=== Setup Complete ==="
echo ""
echo "Web app created:"
echo "  - $WEB_PACKAGE"
echo "  - $WEB_TSCONFIG"
echo "  - $TAILWIND_CONFIG"
echo "  - $WEB_DIR/app/layout.tsx"
echo "  - $WEB_DIR/app/page.tsx"
echo "  - $WEB_DIR/app/globals.css"
echo ""
echo "Next steps:"
echo "  1. Read the README.md for this lab"
echo "  2. Understand workspace dependencies"
echo "  3. Proceed to Lab 4.5 to build and run"
echo ""
