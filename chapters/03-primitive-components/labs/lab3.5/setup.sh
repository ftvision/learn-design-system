#!/bin/bash

# Lab 3.5 Setup Script
# Creates Badge, Avatar components and barrel export

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LAB31_DIR="$SCRIPT_DIR/../lab3.1"
LAB32_DIR="$SCRIPT_DIR/../lab3.2"
LAB33_DIR="$SCRIPT_DIR/../lab3.3"
LAB34_DIR="$SCRIPT_DIR/../lab3.4"
UI_DIR="$LAB31_DIR/packages/ui"

echo "=== Lab 3.5 Setup: Badge, Avatar & Exports ==="
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

if [ ! -f "$UI_DIR/src/components/Card.tsx" ]; then
    echo "Lab 3.4 not complete. Running setup..."
    cd "$LAB34_DIR" && ./setup.sh && cd "$SCRIPT_DIR"
fi

# Create Badge component
BADGE_FILE="$UI_DIR/src/components/Badge.tsx"
if [ -f "$BADGE_FILE" ]; then
    echo "Badge.tsx already exists. Skipping."
else
    echo "Creating Badge component..."
    cat > "$BADGE_FILE" << 'EOF'
import * as React from "react";
import { cva, type VariantProps } from "class-variance-authority";
import { cn } from "../lib/utils";

const badgeVariants = cva(
  "inline-flex items-center rounded-full px-2.5 py-0.5 text-xs font-medium transition-colors",
  {
    variants: {
      variant: {
        default: "bg-gray-100 text-gray-800",
        primary: "bg-blue-100 text-blue-800",
        success: "bg-green-100 text-green-800",
        warning: "bg-yellow-100 text-yellow-800",
        error: "bg-red-100 text-red-800",
        outline: "border border-gray-300 text-gray-700 bg-transparent",
      },
    },
    defaultVariants: {
      variant: "default",
    },
  }
);

export interface BadgeProps
  extends React.HTMLAttributes<HTMLSpanElement>,
    VariantProps<typeof badgeVariants> {}

export function Badge({ className, variant, ...props }: BadgeProps) {
  return (
    <span className={cn(badgeVariants({ variant }), className)} {...props} />
  );
}
EOF
fi

# Create Avatar component
AVATAR_FILE="$UI_DIR/src/components/Avatar.tsx"
if [ -f "$AVATAR_FILE" ]; then
    echo "Avatar.tsx already exists. Skipping."
else
    echo "Creating Avatar component..."
    cat > "$AVATAR_FILE" << 'EOF'
import * as React from "react";
import { cva, type VariantProps } from "class-variance-authority";
import { cn } from "../lib/utils";

const avatarVariants = cva(
  "relative inline-flex shrink-0 overflow-hidden rounded-full bg-gray-100",
  {
    variants: {
      size: {
        xs: "h-6 w-6 text-xs",
        sm: "h-8 w-8 text-sm",
        md: "h-10 w-10 text-base",
        lg: "h-12 w-12 text-lg",
        xl: "h-16 w-16 text-xl",
      },
    },
    defaultVariants: {
      size: "md",
    },
  }
);

export interface AvatarProps
  extends React.HTMLAttributes<HTMLDivElement>,
    VariantProps<typeof avatarVariants> {
  /** Image URL for the avatar */
  src?: string;
  /** Alt text for the image */
  alt?: string;
  /** Fallback text (usually initials) shown when no image */
  fallback?: string;
}

export function Avatar({
  className,
  size,
  src,
  alt = "",
  fallback,
  ...props
}: AvatarProps) {
  const [imageError, setImageError] = React.useState(false);
  const showImage = src && !imageError;

  // Generate initials from alt text if no fallback provided
  const initials = React.useMemo(() => {
    if (fallback) return fallback;
    if (!alt) return "";
    return alt
      .split(" ")
      .map((word) => word[0])
      .slice(0, 2)
      .join("")
      .toUpperCase();
  }, [alt, fallback]);

  return (
    <div
      className={cn(avatarVariants({ size }), className)}
      {...props}
    >
      {showImage ? (
        <img
          src={src}
          alt={alt}
          className="h-full w-full object-cover"
          onError={() => setImageError(true)}
        />
      ) : (
        <span className="flex h-full w-full items-center justify-center font-medium text-gray-600">
          {initials}
        </span>
      )}
    </div>
  );
}
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
export { Badge, type BadgeProps } from "./components/Badge";
export { Avatar, type AvatarProps } from "./components/Avatar";

// Utilities
export { cn } from "./lib/utils";
EOF
fi

echo ""
echo "=== Setup Complete ==="
echo ""
echo "Components created:"
echo "  - $BADGE_FILE"
echo "  - $AVATAR_FILE"
echo "  - $INDEX_FILE"
echo ""
echo "Verify with: cd $UI_DIR && npm run typecheck"
echo ""
echo "Next steps:"
echo "  1. Read the README.md for this lab"
echo "  2. Add size variants to Badge as an exercise"
echo "  3. Proceed to Lab 3.6 to compare with real projects"
echo ""
