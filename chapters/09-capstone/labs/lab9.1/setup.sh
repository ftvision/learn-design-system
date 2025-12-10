#!/bin/bash

# Lab 9.1 Setup Script
# Creates data model and types for the Team Management feature

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MONOREPO_DIR="$SCRIPT_DIR/../../../04-monorepo-architecture/labs/lab4.1"
WEB_DIR="$MONOREPO_DIR/apps/web"
TYPES_DIR="$WEB_DIR/types"
DATA_DIR="$WEB_DIR/data"

echo "=== Lab 9.1 Setup: Planning & Data Model ==="
echo ""

# Check if monorepo exists
if [ ! -d "$MONOREPO_DIR" ]; then
    echo "Error: Chapter 4 monorepo not found at $MONOREPO_DIR"
    echo "Please complete Chapter 4 labs first."
    exit 1
fi

# Check if web app exists
if [ ! -d "$WEB_DIR" ]; then
    echo "Error: Web app not found at $WEB_DIR"
    echo "Please complete Chapter 5 labs first."
    exit 1
fi

# Create types directory
mkdir -p "$TYPES_DIR"
mkdir -p "$DATA_DIR"

# Create team types
TEAM_TYPES="$TYPES_DIR/team.ts"
if [ -f "$TEAM_TYPES" ]; then
    echo "team.ts already exists. Skipping."
else
    echo "Creating types/team.ts..."
    cat > "$TEAM_TYPES" << 'EOF'
/**
 * Team Member Type Definitions
 * Used for the Team Management capstone feature
 */

export interface TeamMember {
  id: string;
  name: string;
  email: string;
  role: "owner" | "admin" | "member" | "guest";
  avatarUrl?: string;
  joinedAt: Date;
  status: "active" | "pending" | "inactive";
}

export interface TeamInvite {
  email: string;
  role: "admin" | "member" | "guest";
  message?: string;
}

export type TeamRole = TeamMember["role"];
export type InviteRole = TeamInvite["role"];
EOF
fi

# Create mock data
MOCK_DATA="$DATA_DIR/mockTeamMembers.ts"
if [ -f "$MOCK_DATA" ]; then
    echo "mockTeamMembers.ts already exists. Skipping."
else
    echo "Creating data/mockTeamMembers.ts..."
    cat > "$MOCK_DATA" << 'EOF'
import type { TeamMember } from "@/types/team";

export const mockMembers: TeamMember[] = [
  {
    id: "1",
    name: "Jane Smith",
    email: "jane@company.com",
    role: "owner",
    avatarUrl: "https://i.pravatar.cc/150?u=jane",
    joinedAt: new Date("2022-01-15"),
    status: "active",
  },
  {
    id: "2",
    name: "John Doe",
    email: "john@company.com",
    role: "admin",
    avatarUrl: "https://i.pravatar.cc/150?u=john",
    joinedAt: new Date("2022-06-20"),
    status: "active",
  },
  {
    id: "3",
    name: "Alice Johnson",
    email: "alice@company.com",
    role: "member",
    joinedAt: new Date("2023-03-10"),
    status: "active",
  },
  {
    id: "4",
    name: "Bob Williams",
    email: "bob@company.com",
    role: "member",
    avatarUrl: "https://i.pravatar.cc/150?u=bob",
    joinedAt: new Date("2023-08-01"),
    status: "pending",
  },
  {
    id: "5",
    name: "Carol Brown",
    email: "carol@company.com",
    role: "guest",
    joinedAt: new Date("2024-01-05"),
    status: "active",
  },
];
EOF
fi

echo ""
echo "=== Component Inventory ==="
echo ""
echo "UI Components (packages/ui/):"
echo "  ✓ Button     - Existing"
echo "  ✓ Input      - Existing"
echo "  ✓ Card       - Existing"
echo "  ✓ Avatar     - Existing"
echo "  ✓ Badge      - Existing"
echo "  ○ Modal      - To build in Lab 9.2"
echo "  ○ Select     - To build in Lab 9.2"
echo ""
echo "App Components (apps/web/components/):"
echo "  ○ TeamMemberRow     - To build in Lab 9.3"
echo "  ○ InviteMemberModal - To build in Lab 9.3"
echo "  ○ TeamMemberList    - To build in Lab 9.4"
echo ""

echo "=== Setup Complete ==="
echo ""
echo "Files created:"
echo "  - $TEAM_TYPES"
echo "  - $MOCK_DATA"
echo ""
echo "Next steps:"
echo "  1. Read the README.md for this lab"
echo "  2. Review the types and mock data"
echo "  3. Proceed to Lab 9.2 to build Modal and Select"
echo ""
