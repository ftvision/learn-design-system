#!/bin/bash

# Lab 3.3 Setup Script
# Creates the Input component

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LAB31_DIR="$SCRIPT_DIR/../lab3.1"
LAB32_DIR="$SCRIPT_DIR/../lab3.2"
UI_DIR="$LAB31_DIR/packages/ui"

echo "=== Lab 3.3 Setup: Input Component ==="
echo ""

# Check if Lab 3.1 is complete
if [ ! -d "$UI_DIR" ]; then
    echo "Lab 3.1 not complete. Running setup..."
    cd "$LAB31_DIR" && ./setup.sh && cd "$SCRIPT_DIR"
fi

# Check if Lab 3.2 is complete
if [ ! -f "$UI_DIR/src/components/Button.tsx" ]; then
    echo "Lab 3.2 not complete. Running setup..."
    cd "$LAB32_DIR" && ./setup.sh && cd "$SCRIPT_DIR"
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
  /** Label text displayed above the input */
  label?: string;
  /** Error message - displays in red and sets aria-invalid */
  error?: string;
  /** Hint text displayed below the input (hidden when error is present) */
  hint?: string;
  /** Left addon (icon or text) inside the input */
  leftAddon?: React.ReactNode;
  /** Right addon (icon or text) inside the input */
  rightAddon?: React.ReactNode;
}

/**
 * Input component with label, error, and hint support.
 *
 * @example
 * <Input label="Email" type="email" placeholder="you@example.com" />
 * <Input label="Password" type="password" error="Password is required" />
 */
export const Input = React.forwardRef<HTMLInputElement, InputProps>(
  (
    {
      className,
      type = "text",
      label,
      error,
      hint,
      leftAddon,
      rightAddon,
      id,
      disabled,
      ...props
    },
    ref
  ) => {
    // Generate a unique ID if not provided
    const inputId = id || React.useId();
    const errorId = `${inputId}-error`;
    const hintId = `${inputId}-hint`;

    return (
      <div className="w-full">
        {/* Label */}
        {label && (
          <label
            htmlFor={inputId}
            className={cn(
              "block text-sm font-medium mb-1.5",
              disabled ? "text-gray-400" : "text-gray-700"
            )}
          >
            {label}
          </label>
        )}

        {/* Input container */}
        <div className="relative">
          {/* Left addon */}
          {leftAddon && (
            <div className="absolute left-3 top-1/2 -translate-y-1/2 text-gray-400">
              {leftAddon}
            </div>
          )}

          {/* Input element */}
          <input
            ref={ref}
            id={inputId}
            type={type}
            disabled={disabled}
            className={cn(
              // Base styles
              "flex h-10 w-full rounded-md border bg-white px-3 py-2 text-sm",
              "transition-colors duration-200",
              // Placeholder
              "placeholder:text-gray-400",
              // Focus styles
              "focus:outline-none focus:ring-2 focus:ring-offset-0",
              // Disabled styles
              "disabled:cursor-not-allowed disabled:bg-gray-50 disabled:opacity-50",
              // Error vs normal styles
              error
                ? "border-red-500 focus:border-red-500 focus:ring-red-500/20"
                : "border-gray-300 focus:border-blue-500 focus:ring-blue-500/20",
              // Addon padding
              leftAddon && "pl-10",
              rightAddon && "pr-10",
              className
            )}
            aria-invalid={error ? "true" : undefined}
            aria-describedby={
              error ? errorId : hint ? hintId : undefined
            }
            {...props}
          />

          {/* Right addon */}
          {rightAddon && (
            <div className="absolute right-3 top-1/2 -translate-y-1/2 text-gray-400">
              {rightAddon}
            </div>
          )}
        </div>

        {/* Error message */}
        {error && (
          <p id={errorId} className="mt-1.5 text-sm text-red-600" role="alert">
            {error}
          </p>
        )}

        {/* Hint text (only shown when no error) */}
        {hint && !error && (
          <p id={hintId} className="mt-1.5 text-sm text-gray-500">
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

echo ""
echo "=== Setup Complete ==="
echo ""
echo "Input component created at: $INPUT_FILE"
echo ""
echo "Next steps:"
echo "  1. Read the README.md for this lab"
echo "  2. Study the accessibility features"
echo "  3. Add the required indicator as an exercise"
echo "  4. Proceed to Lab 3.4 for the Card component"
echo ""
