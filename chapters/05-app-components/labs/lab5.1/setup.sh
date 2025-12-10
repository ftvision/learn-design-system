#!/bin/bash

# Lab 5.1 Setup Script
# Creates type definitions and UserCard component

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MONOREPO_DIR="$SCRIPT_DIR/../../../04-monorepo-architecture/labs/lab4.1"
WEB_DIR="$MONOREPO_DIR/apps/web"

echo "=== Lab 5.1 Setup: Types & UserCard ==="
echo ""

# Check if monorepo exists
if [ ! -d "$MONOREPO_DIR" ]; then
    echo "Chapter 4 monorepo not found at $MONOREPO_DIR"
    echo "Please complete Chapter 4 labs first."
    exit 1
fi

# Create types directory
mkdir -p "$WEB_DIR/types"
mkdir -p "$WEB_DIR/components"

# Create type definitions
TYPES_FILE="$WEB_DIR/types/index.ts"
if [ -f "$TYPES_FILE" ]; then
    echo "types/index.ts already exists. Skipping."
else
    echo "Creating type definitions..."
    cat > "$TYPES_FILE" << 'EOF'
// User entity
export interface User {
  id: string;
  name: string;
  email: string;
  role: "admin" | "member" | "guest";
  avatarUrl?: string;
  createdAt: Date;
}

// Product entity
export interface Product {
  id: string;
  name: string;
  description: string;
  price: number;
  currency: string;
  imageUrl?: string;
  inStock: boolean;
  category: string;
}

// Order entity
export interface Order {
  id: string;
  userId: string;
  products: Array<{
    productId: string;
    quantity: number;
    price: number;
  }>;
  status: "pending" | "processing" | "shipped" | "delivered" | "cancelled";
  total: number;
  createdAt: Date;
}

// Form states
export interface FormState<T> {
  data: T;
  errors: Partial<Record<keyof T, string>>;
  isSubmitting: boolean;
  isValid: boolean;
}
EOF
fi

# Create UserCard component
USERCARD_FILE="$WEB_DIR/components/UserCard.tsx"
if [ -f "$USERCARD_FILE" ]; then
    echo "UserCard.tsx already exists. Skipping."
else
    echo "Creating UserCard component..."
    cat > "$USERCARD_FILE" << 'EOF'
import { Card, CardContent, Avatar, Badge, Button } from "@myapp/ui";
import type { User } from "@/types";

interface UserCardProps {
  user: User;
  onEdit?: (user: User) => void;
  onDelete?: (user: User) => void;
  showActions?: boolean;
}

export function UserCard({
  user,
  onEdit,
  onDelete,
  showActions = true,
}: UserCardProps) {
  // Business logic: admins cannot be deleted
  const canDelete = user.role !== "admin";

  // Business logic: format date
  const memberSince = new Intl.DateTimeFormat("en-US", {
    year: "numeric",
    month: "short",
  }).format(user.createdAt);

  // Business logic: role badge variant
  const roleBadgeVariant =
    user.role === "admin"
      ? "primary"
      : user.role === "member"
      ? "success"
      : "default";

  return (
    <Card>
      <CardContent>
        <div className="flex items-start gap-4">
          {/* Avatar with fallback */}
          <Avatar
            src={user.avatarUrl}
            alt={user.name}
            size="lg"
          />

          {/* User info */}
          <div className="flex-1 min-w-0">
            <div className="flex items-center gap-2">
              <h3 className="font-semibold text-gray-900 truncate">
                {user.name}
              </h3>
              <Badge variant={roleBadgeVariant}>{user.role}</Badge>
            </div>
            <p className="text-sm text-gray-500 truncate">{user.email}</p>
            <p className="text-xs text-gray-400 mt-1">
              Member since {memberSince}
            </p>
          </div>
        </div>

        {/* Actions */}
        {showActions && (onEdit || onDelete) && (
          <div className="mt-4 pt-4 border-t border-gray-100 flex gap-2">
            {onEdit && (
              <Button
                variant="secondary"
                size="sm"
                onClick={() => onEdit(user)}
              >
                Edit Profile
              </Button>
            )}
            {onDelete && canDelete && (
              <Button
                variant="destructive"
                size="sm"
                onClick={() => onDelete(user)}
              >
                Remove
              </Button>
            )}
            {onDelete && !canDelete && (
              <span className="text-xs text-gray-400 self-center">
                Admins cannot be removed
              </span>
            )}
          </div>
        )}
      </CardContent>
    </Card>
  );
}
EOF
fi

echo ""
echo "=== Setup Complete ==="
echo ""
echo "Files created:"
echo "  - $TYPES_FILE"
echo "  - $USERCARD_FILE"
echo ""
echo "Next steps:"
echo "  1. Read the README.md for this lab"
echo "  2. Understand the component spectrum"
echo "  3. Examine the UserCard business logic"
echo "  4. Proceed to Lab 5.2 for UserList"
echo ""
