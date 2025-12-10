#!/bin/bash

# Lab 6.4 Setup Script
# Updates layout with flash prevention and integrates theme toggle

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MONOREPO_DIR="$SCRIPT_DIR/../../../04-monorepo-architecture/labs/lab4.1"
WEB_DIR="$MONOREPO_DIR/apps/web"
APP_DIR="$WEB_DIR/app"

echo "=== Lab 6.4 Setup: Flash Prevention & Layout Integration ==="
echo ""

# Check if monorepo exists
if [ ! -d "$MONOREPO_DIR" ]; then
    echo "Error: Chapter 4 monorepo not found at $MONOREPO_DIR"
    echo "Please complete Chapter 4 labs first."
    exit 1
fi

# Check if Lab 6.3 is complete
HOOK_FILE="$WEB_DIR/hooks/useTheme.ts"
TOGGLE_FILE="$WEB_DIR/components/ThemeToggle.tsx"
if [ ! -f "$HOOK_FILE" ] || [ ! -f "$TOGGLE_FILE" ]; then
    echo "Warning: Lab 6.3 files not found."
    echo "Please complete Lab 6.3 first, or continue anyway."
fi

# Create app directory if needed
mkdir -p "$APP_DIR"

# Create/update layout.tsx
LAYOUT_FILE="$APP_DIR/layout.tsx"
echo "Creating/updating layout.tsx with flash prevention..."
cat > "$LAYOUT_FILE" << 'EOF'
import "./globals.css";
import "@myapp/ui/styles";

export const metadata = {
  title: "Design System Demo",
  description: "Demonstrating theming with design tokens",
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en" suppressHydrationWarning>
      <head>
        {/* Inline script to prevent flash of wrong theme */}
        <script
          dangerouslySetInnerHTML={{
            __html: `
              (function() {
                const theme = localStorage.getItem('theme');
                const prefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches;

                if (theme === 'dark' || (!theme && prefersDark)) {
                  document.documentElement.classList.add('dark');
                }
              })();
            `,
          }}
        />
      </head>
      <body className="bg-[var(--color-bg)] text-[var(--color-text)]">
        {children}
      </body>
    </html>
  );
}
EOF

# Create/update globals.css if needed
GLOBALS_FILE="$APP_DIR/globals.css"
if [ ! -f "$GLOBALS_FILE" ]; then
    echo "Creating globals.css..."
    cat > "$GLOBALS_FILE" << 'EOF'
@tailwind base;
@tailwind components;
@tailwind utilities;

/* Additional global styles can go here */
EOF
fi

# Create/update page.tsx
PAGE_FILE="$APP_DIR/page.tsx"
echo "Creating/updating page.tsx with ThemeToggle..."
cat > "$PAGE_FILE" << 'EOF'
import { Button, Card, CardContent, CardTitle, CardDescription, Input } from "@myapp/ui";
import { ThemeToggle } from "@/components/ThemeToggle";

export default function Home() {
  return (
    <main className="min-h-screen">
      {/* Header with theme toggle */}
      <header className="border-b border-[var(--color-border)] p-4">
        <div className="max-w-6xl mx-auto flex justify-between items-center">
          <h1 className="text-xl font-bold">Design System</h1>
          <ThemeToggle />
        </div>
      </header>

      {/* Content area */}
      <div className="max-w-6xl mx-auto p-8 space-y-8">
        {/* Hero section */}
        <section className="text-center py-8">
          <h2 className="text-3xl font-bold mb-4">
            Theming Demo
          </h2>
          <p className="text-[var(--color-text-muted)] max-w-2xl mx-auto">
            Toggle between light, dark, and system themes.
            Components automatically adapt using CSS custom properties.
          </p>
        </section>

        {/* Button variants */}
        <section>
          <h3 className="text-lg font-semibold mb-4">Buttons</h3>
          <div className="flex flex-wrap gap-4">
            <Button variant="primary">Primary</Button>
            <Button variant="secondary">Secondary</Button>
            <Button variant="outline">Outline</Button>
            <Button variant="ghost">Ghost</Button>
            <Button variant="destructive">Destructive</Button>
            <Button variant="link">Link</Button>
          </div>
        </section>

        {/* Cards */}
        <section>
          <h3 className="text-lg font-semibold mb-4">Cards</h3>
          <div className="grid md:grid-cols-3 gap-4">
            <Card>
              <CardContent>
                <CardTitle>Card Title</CardTitle>
                <CardDescription>
                  This card uses theme tokens for background, border, and shadow.
                </CardDescription>
              </CardContent>
            </Card>
            <Card hoverable>
              <CardContent>
                <CardTitle>Hoverable Card</CardTitle>
                <CardDescription>
                  Hover to see shadow change using themed shadow tokens.
                </CardDescription>
              </CardContent>
            </Card>
            <Card>
              <CardContent>
                <CardTitle>Status Colors</CardTitle>
                <div className="mt-2 space-y-1 text-sm">
                  <p className="text-[var(--color-success)]">Success message</p>
                  <p className="text-[var(--color-warning)]">Warning message</p>
                  <p className="text-[var(--color-error)]">Error message</p>
                </div>
              </CardContent>
            </Card>
          </div>
        </section>

        {/* Inputs */}
        <section>
          <h3 className="text-lg font-semibold mb-4">Inputs</h3>
          <div className="max-w-md space-y-4">
            <Input placeholder="Default input" />
            <Input placeholder="Disabled input" disabled />
            <Input placeholder="Error input" error />
          </div>
        </section>

        {/* Token reference */}
        <section className="bg-[var(--color-bg-subtle)] p-6 rounded-lg">
          <h3 className="text-lg font-semibold mb-4">Theme Tokens in Use</h3>
          <div className="grid md:grid-cols-2 gap-4 text-sm font-mono">
            <div>
              <p className="text-[var(--color-text-muted)] mb-2">Backgrounds:</p>
              <ul className="space-y-1 text-[var(--color-text-subtle)]">
                <li>--color-bg</li>
                <li>--color-bg-subtle</li>
                <li>--color-bg-muted</li>
              </ul>
            </div>
            <div>
              <p className="text-[var(--color-text-muted)] mb-2">Text:</p>
              <ul className="space-y-1 text-[var(--color-text-subtle)]">
                <li>--color-text</li>
                <li>--color-text-muted</li>
                <li>--color-text-subtle</li>
              </ul>
            </div>
          </div>
        </section>
      </div>
    </main>
  );
}
EOF

echo ""
echo "=== Setup Complete ==="
echo ""
echo "Files created/updated:"
echo "  - $LAYOUT_FILE"
echo "  - $GLOBALS_FILE"
echo "  - $PAGE_FILE"
echo ""
echo "Next steps:"
echo "  1. Read the README.md for this lab"
echo "  2. Understand the flash prevention technique"
echo "  3. Run 'pnpm dev' to test the theme toggle"
echo "  4. Proceed to Lab 6.5 for testing and comparison"
echo ""
