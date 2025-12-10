#!/bin/bash

# Lab 5.2 Setup Script
# Creates UserList component

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LAB51_DIR="$SCRIPT_DIR/../lab5.1"
MONOREPO_DIR="$SCRIPT_DIR/../../../04-monorepo-architecture/labs/lab4.1"
WEB_DIR="$MONOREPO_DIR/apps/web"

echo "=== Lab 5.2 Setup: UserList Component ==="
echo ""

# Ensure Lab 5.1 is complete
if [ ! -f "$WEB_DIR/components/UserCard.tsx" ]; then
    echo "Lab 5.1 not complete. Running setup..."
    cd "$LAB51_DIR" && ./setup.sh && cd "$SCRIPT_DIR"
fi

# Create UserList component
USERLIST_FILE="$WEB_DIR/components/UserList.tsx"
if [ -f "$USERLIST_FILE" ]; then
    echo "UserList.tsx already exists. Skipping."
else
    echo "Creating UserList component..."
    cat > "$USERLIST_FILE" << 'EOF'
"use client";

import { useState } from "react";
import { UserCard } from "./UserCard";
import { Button, Input } from "@myapp/ui";
import type { User } from "@/types";

interface UserListProps {
  users: User[];
  onEditUser?: (user: User) => void;
  onDeleteUser?: (user: User) => void;
}

export function UserList({ users, onEditUser, onDeleteUser }: UserListProps) {
  const [searchQuery, setSearchQuery] = useState("");
  const [roleFilter, setRoleFilter] = useState<string>("all");

  // Business logic: filter users
  const filteredUsers = users.filter((user) => {
    const matchesSearch =
      user.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
      user.email.toLowerCase().includes(searchQuery.toLowerCase());
    const matchesRole = roleFilter === "all" || user.role === roleFilter;
    return matchesSearch && matchesRole;
  });

  return (
    <div className="space-y-4">
      {/* Filters */}
      <div className="flex gap-4">
        <div className="flex-1">
          <Input
            placeholder="Search users..."
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
          />
        </div>
        <div className="flex gap-2">
          {["all", "admin", "member", "guest"].map((role) => (
            <Button
              key={role}
              variant={roleFilter === role ? "primary" : "secondary"}
              size="sm"
              onClick={() => setRoleFilter(role)}
            >
              {role.charAt(0).toUpperCase() + role.slice(1)}
            </Button>
          ))}
        </div>
      </div>

      {/* Results count */}
      <p className="text-sm text-gray-500">
        Showing {filteredUsers.length} of {users.length} users
      </p>

      {/* User grid */}
      <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-3">
        {filteredUsers.map((user) => (
          <UserCard
            key={user.id}
            user={user}
            onEdit={onEditUser}
            onDelete={onDeleteUser}
          />
        ))}
      </div>

      {/* Empty state */}
      {filteredUsers.length === 0 && (
        <div className="text-center py-12 text-gray-500">
          No users found matching your criteria.
        </div>
      )}
    </div>
  );
}
EOF
fi

echo ""
echo "=== Setup Complete ==="
echo ""
echo "Files created:"
echo "  - $USERLIST_FILE"
echo ""
echo "Next steps:"
echo "  1. Read the README.md for this lab"
echo "  2. Understand the composition pattern"
echo "  3. Analyze the filtering business logic"
echo "  4. Proceed to Lab 5.3 for ContactForm"
echo ""
