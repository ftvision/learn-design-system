#!/bin/bash

# Lab 3.4 Setup Script
# Creates the Card component

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LAB31_DIR="$SCRIPT_DIR/../lab3.1"
LAB32_DIR="$SCRIPT_DIR/../lab3.2"
LAB33_DIR="$SCRIPT_DIR/../lab3.3"
UI_DIR="$LAB31_DIR/packages/ui"

echo "=== Lab 3.4 Setup: Card Component ==="
echo ""

# Ensure previous labs are complete
if [ ! -d "$UI_DIR" ]; then
    echo "Lab 3.1 not complete. Running setup..."
    cd "$LAB31_DIR" && ./setup.sh && cd "$SCRIPT_DIR"
fi

if [ ! -f "$UI_DIR/src/components/Button.tsx" ]; then
    echo "Lab 3.2 not complete. Running setup..."
    cd "$LAB32_DIR" && ./setup.sh && cd "$SCRIPT_DIR"
fi

if [ ! -f "$UI_DIR/src/components/Input.tsx" ]; then
    echo "Lab 3.3 not complete. Running setup..."
    cd "$LAB33_DIR" && ./setup.sh && cd "$SCRIPT_DIR"
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

// Main Card component
interface CardProps extends React.HTMLAttributes<HTMLDivElement> {
  /** Card padding preset */
  padding?: "none" | "sm" | "md" | "lg";
  /** Adds hover effect */
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
        "rounded-lg border border-gray-200 bg-white shadow-sm",
        paddingClasses[padding],
        hoverable && "transition-shadow hover:shadow-md cursor-pointer",
        className
      )}
      {...props}
    >
      {children}
    </div>
  );
}

// Card Header
interface CardHeaderProps extends React.HTMLAttributes<HTMLDivElement> {}

export function CardHeader({ className, ...props }: CardHeaderProps) {
  return (
    <div
      className={cn("flex flex-col space-y-1.5", className)}
      {...props}
    />
  );
}

// Card Title
interface CardTitleProps extends React.HTMLAttributes<HTMLHeadingElement> {
  /** Heading level for semantic HTML */
  as?: "h1" | "h2" | "h3" | "h4" | "h5" | "h6";
}

export function CardTitle({
  className,
  as: Component = "h3",
  ...props
}: CardTitleProps) {
  return (
    <Component
      className={cn("text-lg font-semibold text-gray-900", className)}
      {...props}
    />
  );
}

// Card Description
interface CardDescriptionProps extends React.HTMLAttributes<HTMLParagraphElement> {}

export function CardDescription({ className, ...props }: CardDescriptionProps) {
  return (
    <p
      className={cn("text-sm text-gray-500", className)}
      {...props}
    />
  );
}

// Card Content
interface CardContentProps extends React.HTMLAttributes<HTMLDivElement> {}

export function CardContent({ className, ...props }: CardContentProps) {
  return <div className={cn("", className)} {...props} />;
}

// Card Footer
interface CardFooterProps extends React.HTMLAttributes<HTMLDivElement> {}

export function CardFooter({ className, ...props }: CardFooterProps) {
  return (
    <div
      className={cn("flex items-center gap-2 pt-4", className)}
      {...props}
    />
  );
}
EOF
fi

echo ""
echo "=== Setup Complete ==="
echo ""
echo "Card component created at: $CARD_FILE"
echo ""
echo "Next steps:"
echo "  1. Read the README.md for this lab"
echo "  2. Study the composition pattern"
echo "  3. Add the CardImage sub-component as an exercise"
echo "  4. Proceed to Lab 3.5 for Badge and Avatar"
echo ""
