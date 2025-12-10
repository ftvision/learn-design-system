#!/bin/bash

# Lab 6.3 Setup Script
# Creates useTheme hook and ThemeToggle component

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MONOREPO_DIR="$SCRIPT_DIR/../../../04-monorepo-architecture/labs/lab4.1"
WEB_DIR="$MONOREPO_DIR/apps/web"
UI_DIR="$MONOREPO_DIR/packages/ui"

echo "=== Lab 6.3 Setup: Theme Toggle Hook & Component ==="
echo ""

# Check if monorepo exists
if [ ! -d "$MONOREPO_DIR" ]; then
    echo "Error: Chapter 4 monorepo not found at $MONOREPO_DIR"
    echo "Please complete Chapter 4 labs first."
    exit 1
fi

# Check if Lab 6.2 is complete (updated Button exists with theme tokens)
BUTTON_FILE="$UI_DIR/src/components/Button.tsx"
if [ -f "$BUTTON_FILE" ]; then
    if ! grep -q "var(--color-primary)" "$BUTTON_FILE"; then
        echo "Warning: Button.tsx doesn't use theme tokens."
        echo "Please complete Lab 6.2 first, or continue anyway."
    fi
else
    echo "Warning: Button.tsx not found. Please complete Lab 6.2."
fi

# Create directories
mkdir -p "$WEB_DIR/hooks"
mkdir -p "$WEB_DIR/components"

# Create useTheme hook
HOOK_FILE="$WEB_DIR/hooks/useTheme.ts"
if [ -f "$HOOK_FILE" ]; then
    echo "useTheme.ts already exists. Skipping."
else
    echo "Creating useTheme hook..."
    cat > "$HOOK_FILE" << 'EOF'
"use client";

import { useEffect, useState } from "react";

type Theme = "light" | "dark" | "system";

export function useTheme() {
  const [theme, setTheme] = useState<Theme>("system");
  const [resolvedTheme, setResolvedTheme] = useState<"light" | "dark">("light");

  // Initialize theme from localStorage or system preference
  useEffect(() => {
    const stored = localStorage.getItem("theme") as Theme | null;
    if (stored) {
      setTheme(stored);
    }

    // Get resolved theme (what's actually shown)
    const isDark = document.documentElement.classList.contains("dark");
    setResolvedTheme(isDark ? "dark" : "light");
  }, []);

  // Apply theme changes
  useEffect(() => {
    const root = document.documentElement;

    if (theme === "system") {
      localStorage.removeItem("theme");
      const systemDark = window.matchMedia("(prefers-color-scheme: dark)").matches;
      root.classList.toggle("dark", systemDark);
      setResolvedTheme(systemDark ? "dark" : "light");
    } else {
      localStorage.setItem("theme", theme);
      root.classList.toggle("dark", theme === "dark");
      setResolvedTheme(theme);
    }
  }, [theme]);

  // Listen for system preference changes
  useEffect(() => {
    if (theme !== "system") return;

    const mediaQuery = window.matchMedia("(prefers-color-scheme: dark)");
    const handler = (e: MediaQueryListEvent) => {
      document.documentElement.classList.toggle("dark", e.matches);
      setResolvedTheme(e.matches ? "dark" : "light");
    };

    mediaQuery.addEventListener("change", handler);
    return () => mediaQuery.removeEventListener("change", handler);
  }, [theme]);

  return {
    theme,
    setTheme,
    resolvedTheme,
  };
}
EOF
fi

# Create ThemeToggle component
TOGGLE_FILE="$WEB_DIR/components/ThemeToggle.tsx"
if [ -f "$TOGGLE_FILE" ]; then
    echo "ThemeToggle.tsx already exists. Skipping."
else
    echo "Creating ThemeToggle component..."
    cat > "$TOGGLE_FILE" << 'EOF'
"use client";

import { Button } from "@myapp/ui";
import { useTheme } from "@/hooks/useTheme";

export function ThemeToggle() {
  const { theme, setTheme, resolvedTheme } = useTheme();

  const cycleTheme = () => {
    if (theme === "light") setTheme("dark");
    else if (theme === "dark") setTheme("system");
    else setTheme("light");
  };

  const icon = resolvedTheme === "dark" ? "🌙" : "☀️";
  const label =
    theme === "system"
      ? `System (${resolvedTheme})`
      : theme.charAt(0).toUpperCase() + theme.slice(1);

  return (
    <Button variant="ghost" size="sm" onClick={cycleTheme}>
      <span className="mr-2">{icon}</span>
      {label}
    </Button>
  );
}
EOF
fi

echo ""
echo "=== Setup Complete ==="
echo ""
echo "Files created:"
echo "  - $HOOK_FILE"
echo "  - $TOGGLE_FILE"
echo ""
echo "Next steps:"
echo "  1. Read the README.md for this lab"
echo "  2. Examine the useTheme hook logic"
echo "  3. Understand the three theme states"
echo "  4. Proceed to Lab 6.4 for flash prevention"
echo ""
