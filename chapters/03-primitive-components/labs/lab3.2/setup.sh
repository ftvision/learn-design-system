#!/bin/bash

# Lab 3.2 Setup Script
# Creates the Button component

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LAB31_DIR="$SCRIPT_DIR/../lab3.1"
UI_DIR="$LAB31_DIR/packages/ui"

echo "=== Lab 3.2 Setup: Button Component ==="
echo ""

# Check if Lab 3.1 is complete
if [ ! -d "$UI_DIR" ]; then
    echo "Lab 3.1 not complete. Running Lab 3.1 setup first..."
    cd "$LAB31_DIR"
    ./setup.sh
    cd "$SCRIPT_DIR"
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

// Define all button variants
const buttonVariants = cva(
  // Base styles
  [
    "inline-flex items-center justify-center gap-2",
    "rounded-md font-medium",
    "transition-colors duration-200",
    "focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-offset-2",
    "disabled:pointer-events-none disabled:opacity-50",
  ],
  {
    variants: {
      variant: {
        primary: [
          "bg-blue-600 text-white",
          "hover:bg-blue-700",
          "focus-visible:ring-blue-500",
        ],
        secondary: [
          "bg-gray-100 text-gray-900",
          "hover:bg-gray-200",
          "focus-visible:ring-gray-500",
        ],
        destructive: [
          "bg-red-600 text-white",
          "hover:bg-red-700",
          "focus-visible:ring-red-500",
        ],
        outline: [
          "border border-gray-300 bg-transparent text-gray-700",
          "hover:bg-gray-50",
          "focus-visible:ring-gray-500",
        ],
        ghost: [
          "bg-transparent text-gray-700",
          "hover:bg-gray-100",
          "focus-visible:ring-gray-500",
        ],
        link: [
          "bg-transparent text-blue-600 underline-offset-4",
          "hover:underline",
          "focus-visible:ring-blue-500",
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

// Spinner component for loading state
function Spinner({ className }: { className?: string }) {
  return (
    <svg
      className={cn("animate-spin", className)}
      xmlns="http://www.w3.org/2000/svg"
      fill="none"
      viewBox="0 0 24 24"
      aria-hidden="true"
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
        d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z"
      />
    </svg>
  );
}

// Button props type
export interface ButtonProps
  extends React.ButtonHTMLAttributes<HTMLButtonElement>,
    VariantProps<typeof buttonVariants> {
  /** Shows a loading spinner and disables the button */
  loading?: boolean;
  /** Icon to show before the button text */
  leftIcon?: React.ReactNode;
  /** Icon to show after the button text */
  rightIcon?: React.ReactNode;
}

/**
 * Button component with multiple variants and sizes.
 *
 * @example
 * <Button variant="primary" size="md">Click me</Button>
 * <Button variant="destructive" loading>Deleting...</Button>
 */
export const Button = React.forwardRef<HTMLButtonElement, ButtonProps>(
  (
    {
      className,
      variant,
      size,
      loading = false,
      disabled,
      leftIcon,
      rightIcon,
      children,
      ...props
    },
    ref
  ) => {
    return (
      <button
        ref={ref}
        className={cn(buttonVariants({ variant, size }), className)}
        disabled={disabled || loading}
        {...props}
      >
        {loading ? (
          <Spinner className="h-4 w-4" />
        ) : leftIcon ? (
          <span className="shrink-0">{leftIcon}</span>
        ) : null}
        {children}
        {rightIcon && !loading ? (
          <span className="shrink-0">{rightIcon}</span>
        ) : null}
      </button>
    );
  }
);

Button.displayName = "Button";

// Export variants for use in other components or tests
export { buttonVariants };
EOF
fi

echo ""
echo "=== Setup Complete ==="
echo ""
echo "Button component created at: $BUTTON_FILE"
echo ""
echo "Next steps:"
echo "  1. Read the README.md for this lab"
echo "  2. Study the CVA pattern in the Button component"
echo "  3. Add the 'warning' variant as an exercise"
echo "  4. Proceed to Lab 3.3 for the Input component"
echo ""
