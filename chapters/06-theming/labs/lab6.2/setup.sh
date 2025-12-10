#!/bin/bash

# Lab 6.2 Setup Script
# Updates components to use theme tokens

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MONOREPO_DIR="$SCRIPT_DIR/../../../04-monorepo-architecture/labs/lab4.1"
UI_DIR="$MONOREPO_DIR/packages/ui"
COMPONENTS_DIR="$UI_DIR/src/components"

echo "=== Lab 6.2 Setup: Update Components to Use Theme Tokens ==="
echo ""

# Check if monorepo exists
if [ ! -d "$MONOREPO_DIR" ]; then
    echo "Error: Chapter 4 monorepo not found at $MONOREPO_DIR"
    echo "Please complete Chapter 4 labs first."
    exit 1
fi

# Check if theme.css exists (Lab 6.1 prerequisite)
THEME_FILE="$UI_DIR/src/styles/theme.css"
if [ ! -f "$THEME_FILE" ]; then
    echo "Error: theme.css not found at $THEME_FILE"
    echo "Please complete Lab 6.1 first."
    exit 1
fi

# Create components directory if needed
mkdir -p "$COMPONENTS_DIR"

# Update Button component
BUTTON_FILE="$COMPONENTS_DIR/Button.tsx"
echo "Creating/updating Button.tsx with theme tokens..."
cat > "$BUTTON_FILE" << 'EOF'
import * as React from "react";
import { cva, type VariantProps } from "class-variance-authority";
import { cn } from "../lib/utils";

const buttonVariants = cva(
  // Base styles using theme tokens
  [
    "inline-flex items-center justify-center gap-2",
    "rounded-md font-medium",
    "transition-colors duration-200",
    "focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-[var(--ring-color)] focus-visible:ring-offset-2 focus-visible:ring-offset-[var(--ring-offset-color)]",
    "disabled:pointer-events-none disabled:opacity-50",
  ],
  {
    variants: {
      variant: {
        primary: [
          "bg-[var(--color-primary)] text-[var(--color-primary-text)]",
          "hover:bg-[var(--color-primary-hover)]",
        ],
        secondary: [
          "bg-[var(--color-bg-muted)] text-[var(--color-text)]",
          "hover:bg-[var(--color-bg-emphasis)]",
          "border border-[var(--color-border)]",
        ],
        destructive: [
          "bg-[var(--color-error)] text-white",
          "hover:opacity-90",
        ],
        outline: [
          "border border-[var(--color-border)] bg-transparent text-[var(--color-text)]",
          "hover:bg-[var(--color-bg-subtle)]",
        ],
        ghost: [
          "bg-transparent text-[var(--color-text)]",
          "hover:bg-[var(--color-bg-muted)]",
        ],
        link: [
          "bg-transparent text-[var(--color-primary)] underline-offset-4",
          "hover:underline",
        ],
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
  asChild?: boolean;
}

export const Button = React.forwardRef<HTMLButtonElement, ButtonProps>(
  ({ className, variant, size, ...props }, ref) => {
    return (
      <button
        className={cn(buttonVariants({ variant, size, className }))}
        ref={ref}
        {...props}
      />
    );
  }
);

Button.displayName = "Button";

export { buttonVariants };
EOF

# Update Card component
CARD_FILE="$COMPONENTS_DIR/Card.tsx"
echo "Creating/updating Card.tsx with theme tokens..."
cat > "$CARD_FILE" << 'EOF'
import * as React from "react";
import { cn } from "../lib/utils";

interface CardProps extends React.HTMLAttributes<HTMLDivElement> {
  padding?: "none" | "sm" | "md" | "lg";
  hoverable?: boolean;
}

const paddingClasses = {
  none: "",
  sm: "p-3",
  md: "p-4",
  lg: "p-6",
};

export function Card({
  className,
  padding = "md",
  hoverable = false,
  children,
  ...props
}: CardProps) {
  return (
    <div
      className={cn(
        // Use theme tokens
        "rounded-lg border border-[var(--color-border)] bg-[var(--color-bg)] shadow-[var(--shadow-sm)]",
        paddingClasses[padding],
        hoverable && "transition-shadow hover:shadow-[var(--shadow-md)] cursor-pointer",
        className
      )}
      {...props}
    >
      {children}
    </div>
  );
}

export function CardHeader({
  className,
  ...props
}: React.HTMLAttributes<HTMLDivElement>) {
  return (
    <div
      className={cn("flex flex-col space-y-1.5 p-6", className)}
      {...props}
    />
  );
}

export function CardTitle({
  className,
  ...props
}: React.HTMLAttributes<HTMLHeadingElement>) {
  return (
    <h3
      className={cn("text-lg font-semibold text-[var(--color-text)]", className)}
      {...props}
    />
  );
}

export function CardDescription({
  className,
  ...props
}: React.HTMLAttributes<HTMLParagraphElement>) {
  return (
    <p
      className={cn("text-sm text-[var(--color-text-muted)]", className)}
      {...props}
    />
  );
}

export function CardContent({
  className,
  ...props
}: React.HTMLAttributes<HTMLDivElement>) {
  return <div className={cn("p-6 pt-0", className)} {...props} />;
}

export function CardFooter({
  className,
  ...props
}: React.HTMLAttributes<HTMLDivElement>) {
  return (
    <div
      className={cn(
        "flex items-center p-6 pt-0 border-t border-[var(--color-border-muted)]",
        className
      )}
      {...props}
    />
  );
}
EOF

# Update Input component
INPUT_FILE="$COMPONENTS_DIR/Input.tsx"
echo "Creating/updating Input.tsx with theme tokens..."
cat > "$INPUT_FILE" << 'EOF'
import * as React from "react";
import { cn } from "../lib/utils";

export interface InputProps
  extends React.InputHTMLAttributes<HTMLInputElement> {
  error?: boolean;
}

export const Input = React.forwardRef<HTMLInputElement, InputProps>(
  ({ className, type, error, ...props }, ref) => {
    return (
      <input
        type={type}
        className={cn(
          "flex h-10 w-full rounded-md border px-3 py-2 text-sm",
          "bg-[var(--color-bg)] text-[var(--color-text)]",
          "border-[var(--color-border)]",
          "placeholder:text-[var(--color-text-subtle)]",
          "focus:outline-none focus:ring-2 focus:ring-[var(--ring-color)] focus:border-[var(--color-primary)]",
          "disabled:cursor-not-allowed disabled:opacity-50 disabled:bg-[var(--color-bg-muted)]",
          error
            ? "border-[var(--color-error)] focus:border-[var(--color-error)] focus:ring-[var(--color-error)]"
            : "",
          className
        )}
        ref={ref}
        {...props}
      />
    );
  }
);

Input.displayName = "Input";
EOF

# Create/update utils if needed
UTILS_DIR="$UI_DIR/src/lib"
UTILS_FILE="$UTILS_DIR/utils.ts"
mkdir -p "$UTILS_DIR"
if [ ! -f "$UTILS_FILE" ]; then
    echo "Creating utils.ts..."
    cat > "$UTILS_FILE" << 'EOF'
import { type ClassValue, clsx } from "clsx";
import { twMerge } from "tailwind-merge";

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs));
}
EOF
fi

echo ""
echo "=== Setup Complete ==="
echo ""
echo "Files created/updated:"
echo "  - $BUTTON_FILE"
echo "  - $CARD_FILE"
echo "  - $INPUT_FILE"
echo ""
echo "Next steps:"
echo "  1. Read the README.md for this lab"
echo "  2. Examine how components use theme tokens"
echo "  3. Understand the [var(--token)] syntax"
echo "  4. Proceed to Lab 6.3 for the theme toggle"
echo ""
