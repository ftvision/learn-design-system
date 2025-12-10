#!/bin/bash

# Lab 4.3 Setup Script
# Configures tokens and UI packages with workspace dependencies

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LAB41_DIR="$SCRIPT_DIR/../lab4.1"
LAB42_DIR="$SCRIPT_DIR/../lab4.2"
TOKENS_DIR="$LAB41_DIR/packages/tokens"
UI_DIR="$LAB41_DIR/packages/ui"

echo "=== Lab 4.3 Setup: Wire Packages ==="
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

# Create tokens package structure
mkdir -p "$TOKENS_DIR/src"

# Create tokens package.json
TOKENS_PACKAGE="$TOKENS_DIR/package.json"
if [ -f "$TOKENS_PACKAGE" ]; then
    echo "tokens/package.json already exists. Skipping."
else
    echo "Creating tokens package.json..."
    cat > "$TOKENS_PACKAGE" << 'EOF'
{
  "name": "@myapp/tokens",
  "version": "0.0.1",
  "private": true,
  "main": "./build/js/tokens.js",
  "types": "./build/ts/tokens.d.ts",
  "exports": {
    ".": "./build/js/tokens.js",
    "./css": "./build/css/variables.css"
  },
  "scripts": {
    "build": "style-dictionary build",
    "clean": "rm -rf build"
  },
  "devDependencies": {
    "style-dictionary": "^3.9.0"
  }
}
EOF
fi

# Create Style Dictionary config
SD_CONFIG="$TOKENS_DIR/style-dictionary.config.js"
if [ -f "$SD_CONFIG" ]; then
    echo "style-dictionary.config.js already exists. Skipping."
else
    echo "Creating Style Dictionary config..."
    cat > "$SD_CONFIG" << 'EOF'
module.exports = {
  source: ["src/**/*.json"],
  platforms: {
    css: {
      transformGroup: "css",
      buildPath: "build/css/",
      files: [
        {
          destination: "variables.css",
          format: "css/variables",
        },
      ],
    },
    js: {
      transformGroup: "js",
      buildPath: "build/js/",
      files: [
        {
          destination: "tokens.js",
          format: "javascript/es6",
        },
      ],
    },
    ts: {
      transformGroup: "js",
      buildPath: "build/ts/",
      files: [
        {
          destination: "tokens.d.ts",
          format: "typescript/es6-declarations",
        },
      ],
    },
  },
};
EOF
fi

# Create color tokens
COLOR_TOKENS="$TOKENS_DIR/src/color.json"
if [ -f "$COLOR_TOKENS" ]; then
    echo "color.json already exists. Skipping."
else
    echo "Creating color tokens..."
    cat > "$COLOR_TOKENS" << 'EOF'
{
  "color": {
    "primary": {
      "50": { "value": "#eff6ff" },
      "100": { "value": "#dbeafe" },
      "500": { "value": "#3b82f6" },
      "600": { "value": "#2563eb" },
      "700": { "value": "#1d4ed8" }
    },
    "neutral": {
      "0": { "value": "#ffffff" },
      "50": { "value": "#f9fafb" },
      "100": { "value": "#f3f4f6" },
      "200": { "value": "#e5e7eb" },
      "300": { "value": "#d1d5db" },
      "500": { "value": "#6b7280" },
      "700": { "value": "#374151" },
      "900": { "value": "#111827" }
    },
    "success": {
      "500": { "value": "#22c55e" },
      "600": { "value": "#16a34a" }
    },
    "error": {
      "500": { "value": "#ef4444" },
      "600": { "value": "#dc2626" }
    }
  }
}
EOF
fi

# Create spacing tokens
SPACING_TOKENS="$TOKENS_DIR/src/spacing.json"
if [ -f "$SPACING_TOKENS" ]; then
    echo "spacing.json already exists. Skipping."
else
    echo "Creating spacing tokens..."
    cat > "$SPACING_TOKENS" << 'EOF'
{
  "spacing": {
    "0": { "value": "0" },
    "1": { "value": "0.25rem" },
    "2": { "value": "0.5rem" },
    "3": { "value": "0.75rem" },
    "4": { "value": "1rem" },
    "6": { "value": "1.5rem" },
    "8": { "value": "2rem" },
    "12": { "value": "3rem" },
    "16": { "value": "4rem" }
  }
}
EOF
fi

# Create UI package structure
mkdir -p "$UI_DIR/src/components"
mkdir -p "$UI_DIR/src/lib"

# Create UI package.json
UI_PACKAGE="$UI_DIR/package.json"
if [ -f "$UI_PACKAGE" ]; then
    echo "ui/package.json already exists. Skipping."
else
    echo "Creating UI package.json..."
    cat > "$UI_PACKAGE" << 'EOF'
{
  "name": "@myapp/ui",
  "version": "0.0.1",
  "private": true,
  "main": "./src/index.tsx",
  "module": "./src/index.tsx",
  "types": "./src/index.tsx",
  "exports": {
    ".": "./src/index.tsx",
    "./button": "./src/components/Button.tsx",
    "./input": "./src/components/Input.tsx",
    "./card": "./src/components/Card.tsx"
  },
  "scripts": {
    "build": "tsc",
    "dev": "tsc --watch",
    "clean": "rm -rf dist",
    "typecheck": "tsc --noEmit"
  },
  "dependencies": {
    "@myapp/tokens": "workspace:*",
    "class-variance-authority": "^0.7.0",
    "clsx": "^2.0.0",
    "tailwind-merge": "^2.0.0"
  },
  "peerDependencies": {
    "react": "^18.0.0",
    "react-dom": "^18.0.0"
  },
  "devDependencies": {
    "@myapp/config": "workspace:*",
    "@types/react": "^18.0.0",
    "@types/react-dom": "^18.0.0",
    "typescript": "^5.0.0"
  }
}
EOF
fi

# Create UI tsconfig.json
UI_TSCONFIG="$UI_DIR/tsconfig.json"
if [ -f "$UI_TSCONFIG" ]; then
    echo "ui/tsconfig.json already exists. Skipping."
else
    echo "Creating UI tsconfig.json..."
    cat > "$UI_TSCONFIG" << 'EOF'
{
  "extends": "@myapp/config/tsconfig/react",
  "compilerOptions": {
    "outDir": "./dist"
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "dist"]
}
EOF
fi

# Create cn utility
UTILS_FILE="$UI_DIR/src/lib/utils.ts"
if [ -f "$UTILS_FILE" ]; then
    echo "lib/utils.ts already exists. Skipping."
else
    echo "Creating cn utility..."
    cat > "$UTILS_FILE" << 'EOF'
import { clsx, type ClassValue } from "clsx";
import { twMerge } from "tailwind-merge";

/**
 * Merges class names with Tailwind CSS conflict resolution.
 */
export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs));
}
EOF
fi

# Create Button component
BUTTON_FILE="$UI_DIR/src/components/Button.tsx"
if [ -f "$BUTTON_FILE" ]; then
    echo "Button.tsx already exists. Skipping."
else
    echo "Creating Button component..."
    cat > "$BUTTON_FILE" << 'EOF'
import * as React from "react";
import { cva, type VariantProps } from "class-variance-authority";
import { cn } from "../lib/utils";

const buttonVariants = cva(
  "inline-flex items-center justify-center rounded-md font-medium transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50",
  {
    variants: {
      variant: {
        primary: "bg-blue-600 text-white hover:bg-blue-700 focus-visible:ring-blue-500",
        secondary: "bg-gray-100 text-gray-900 hover:bg-gray-200 focus-visible:ring-gray-500",
        destructive: "bg-red-600 text-white hover:bg-red-700 focus-visible:ring-red-500",
        outline: "border border-gray-300 bg-transparent hover:bg-gray-100 focus-visible:ring-gray-500",
        ghost: "hover:bg-gray-100 focus-visible:ring-gray-500",
        link: "text-blue-600 underline-offset-4 hover:underline focus-visible:ring-blue-500",
      },
      size: {
        sm: "h-8 px-3 text-sm",
        md: "h-10 px-4 text-sm",
        lg: "h-12 px-6 text-base",
        icon: "h-10 w-10",
      },
    },
    defaultVariants: {
      variant: "primary",
      size: "md",
    },
  }
);

export interface ButtonProps
  extends React.ButtonHTMLAttributes<HTMLButtonElement>,
    VariantProps<typeof buttonVariants> {
  loading?: boolean;
}

export const Button = React.forwardRef<HTMLButtonElement, ButtonProps>(
  ({ className, variant, size, loading, disabled, children, ...props }, ref) => {
    return (
      <button
        className={cn(buttonVariants({ variant, size, className }))}
        ref={ref}
        disabled={disabled || loading}
        {...props}
      >
        {loading ? (
          <>
            <svg
              className="mr-2 h-4 w-4 animate-spin"
              xmlns="http://www.w3.org/2000/svg"
              fill="none"
              viewBox="0 0 24 24"
            >
              <circle
                className="opacity-25"
                cx="12"
                cy="12"
                r="10"
                stroke="currentColor"
                strokeWidth="4"
              />
              <path
                className="opacity-75"
                fill="currentColor"
                d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"
              />
            </svg>
            {children}
          </>
        ) : (
          children
        )}
      </button>
    );
  }
);

Button.displayName = "Button";

export { buttonVariants };
EOF
fi

# Create Input component
INPUT_FILE="$UI_DIR/src/components/Input.tsx"
if [ -f "$INPUT_FILE" ]; then
    echo "Input.tsx already exists. Skipping."
else
    echo "Creating Input component..."
    cat > "$INPUT_FILE" << 'EOF'
import * as React from "react";
import { cn } from "../lib/utils";

export interface InputProps
  extends React.InputHTMLAttributes<HTMLInputElement> {
  label?: string;
  error?: string;
  hint?: string;
}

export const Input = React.forwardRef<HTMLInputElement, InputProps>(
  ({ className, label, error, hint, id, ...props }, ref) => {
    const inputId = id || React.useId();
    const errorId = `${inputId}-error`;
    const hintId = `${inputId}-hint`;

    return (
      <div className="w-full">
        {label && (
          <label
            htmlFor={inputId}
            className="block text-sm font-medium text-gray-700 mb-1"
          >
            {label}
          </label>
        )}
        <input
          id={inputId}
          ref={ref}
          className={cn(
            "flex h-10 w-full rounded-md border bg-white px-3 py-2 text-sm placeholder:text-gray-400 focus:outline-none focus:ring-2 focus:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50",
            error
              ? "border-red-500 focus:ring-red-500"
              : "border-gray-300 focus:ring-blue-500",
            className
          )}
          aria-invalid={error ? "true" : undefined}
          aria-describedby={
            error ? errorId : hint ? hintId : undefined
          }
          {...props}
        />
        {error && (
          <p id={errorId} className="mt-1 text-sm text-red-600">
            {error}
          </p>
        )}
        {hint && !error && (
          <p id={hintId} className="mt-1 text-sm text-gray-500">
            {hint}
          </p>
        )}
      </div>
    );
  }
);

Input.displayName = "Input";
EOF
fi

# Create Card component
CARD_FILE="$UI_DIR/src/components/Card.tsx"
if [ -f "$CARD_FILE" ]; then
    echo "Card.tsx already exists. Skipping."
else
    echo "Creating Card component..."
    cat > "$CARD_FILE" << 'EOF'
import * as React from "react";
import { cn } from "../lib/utils";

export const Card = React.forwardRef<
  HTMLDivElement,
  React.HTMLAttributes<HTMLDivElement>
>(({ className, ...props }, ref) => (
  <div
    ref={ref}
    className={cn(
      "rounded-lg border border-gray-200 bg-white shadow-sm",
      className
    )}
    {...props}
  />
));
Card.displayName = "Card";

export const CardHeader = React.forwardRef<
  HTMLDivElement,
  React.HTMLAttributes<HTMLDivElement>
>(({ className, ...props }, ref) => (
  <div
    ref={ref}
    className={cn("flex flex-col space-y-1.5 p-6", className)}
    {...props}
  />
));
CardHeader.displayName = "CardHeader";

export const CardTitle = React.forwardRef<
  HTMLParagraphElement,
  React.HTMLAttributes<HTMLHeadingElement>
>(({ className, ...props }, ref) => (
  <h3
    ref={ref}
    className={cn("text-lg font-semibold leading-none tracking-tight", className)}
    {...props}
  />
));
CardTitle.displayName = "CardTitle";

export const CardDescription = React.forwardRef<
  HTMLParagraphElement,
  React.HTMLAttributes<HTMLParagraphElement>
>(({ className, ...props }, ref) => (
  <p
    ref={ref}
    className={cn("text-sm text-gray-500", className)}
    {...props}
  />
));
CardDescription.displayName = "CardDescription";

export const CardContent = React.forwardRef<
  HTMLDivElement,
  React.HTMLAttributes<HTMLDivElement>
>(({ className, ...props }, ref) => (
  <div ref={ref} className={cn("p-6 pt-0", className)} {...props} />
));
CardContent.displayName = "CardContent";

export const CardFooter = React.forwardRef<
  HTMLDivElement,
  React.HTMLAttributes<HTMLDivElement>
>(({ className, ...props }, ref) => (
  <div
    ref={ref}
    className={cn("flex items-center p-6 pt-0 gap-2", className)}
    {...props}
  />
));
CardFooter.displayName = "CardFooter";
EOF
fi

# Create barrel export
INDEX_FILE="$UI_DIR/src/index.tsx"
if [ -f "$INDEX_FILE" ]; then
    echo "index.tsx already exists. Skipping."
else
    echo "Creating barrel export..."
    cat > "$INDEX_FILE" << 'EOF'
// Components
export { Button, buttonVariants, type ButtonProps } from "./components/Button";
export { Input, type InputProps } from "./components/Input";
export {
  Card,
  CardHeader,
  CardTitle,
  CardDescription,
  CardContent,
  CardFooter,
} from "./components/Card";

// Utilities
export { cn } from "./lib/utils";
EOF
fi

echo ""
echo "=== Setup Complete ==="
echo ""
echo "Tokens package configured:"
echo "  - $TOKENS_PACKAGE"
echo "  - $TOKENS_DIR/src/color.json"
echo "  - $TOKENS_DIR/src/spacing.json"
echo ""
echo "UI package configured:"
echo "  - $UI_PACKAGE"
echo "  - $UI_TSCONFIG"
echo "  - $UI_DIR/src/components/Button.tsx"
echo "  - $UI_DIR/src/components/Input.tsx"
echo "  - $UI_DIR/src/components/Card.tsx"
echo ""
echo "Next steps:"
echo "  1. Read the README.md for this lab"
echo "  2. Understand workspace:* dependencies"
echo "  3. Proceed to Lab 4.4 to create the web app"
echo ""
