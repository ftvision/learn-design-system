#!/bin/bash

# Lab 9.4 Setup Script
# Creates TeamMemberList and the team page

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MONOREPO_DIR="$SCRIPT_DIR/../../../04-monorepo-architecture/labs/lab4.1"
WEB_DIR="$MONOREPO_DIR/apps/web"
TEAM_DIR="$WEB_DIR/components/team"
APP_DIR="$WEB_DIR/app"

echo "=== Lab 9.4 Setup: TeamMemberList & Team Page ==="
echo ""

# Check if monorepo exists
if [ ! -d "$MONOREPO_DIR" ]; then
    echo "Error: Chapter 4 monorepo not found at $MONOREPO_DIR"
    echo "Please complete Chapter 4 labs first."
    exit 1
fi

# Check if previous labs complete
if [ ! -f "$TEAM_DIR/TeamMemberRow.tsx" ]; then
    echo "Warning: TeamMemberRow not found. Running Lab 9.3 setup..."
    bash "$SCRIPT_DIR/../lab9.3/setup.sh"
fi

# Create TeamMemberList
MEMBER_LIST="$TEAM_DIR/TeamMemberList.tsx"
if [ -f "$MEMBER_LIST" ]; then
    echo "TeamMemberList.tsx already exists. Skipping."
else
    echo "Creating TeamMemberList.tsx..."
    cat > "$MEMBER_LIST" << 'EOF'
"use client";

import { useState } from "react";
import { Input, Button, Card } from "@myapp/ui";
import { TeamMemberRow } from "./TeamMemberRow";
import { InviteMemberModal } from "./InviteMemberModal";
import type { TeamMember, TeamInvite } from "@/types/team";

interface TeamMemberListProps {
  members: TeamMember[];
  onRoleChange?: (memberId: string, role: TeamMember["role"]) => void;
  onRemove?: (member: TeamMember) => void;
  onInvite?: (invite: TeamInvite) => Promise<void>;
  canEdit?: boolean;
}

export function TeamMemberList({
  members,
  onRoleChange,
  onRemove,
  onInvite,
  canEdit = true,
}: TeamMemberListProps) {
  const [search, setSearch] = useState("");
  const [roleFilter, setRoleFilter] = useState<string>("all");
  const [inviteModalOpen, setInviteModalOpen] = useState(false);

  // Filter members
  const filteredMembers = members.filter((member) => {
    const matchesSearch =
      member.name.toLowerCase().includes(search.toLowerCase()) ||
      member.email.toLowerCase().includes(search.toLowerCase());
    const matchesRole = roleFilter === "all" || member.role === roleFilter;
    return matchesSearch && matchesRole;
  });

  return (
    <div className="space-y-4">
      {/* Header */}
      <div className="flex items-center justify-between">
        <h2 className="text-xl font-semibold text-[var(--color-text)]">
          Team Members ({members.length})
        </h2>
        {canEdit && onInvite && (
          <Button onClick={() => setInviteModalOpen(true)}>
            Invite Member
          </Button>
        )}
      </div>

      {/* Filters */}
      <div className="flex gap-4">
        <div className="flex-1">
          <Input
            placeholder="Search by name or email..."
            value={search}
            onChange={(e) => setSearch(e.target.value)}
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

      {/* Member list */}
      <Card padding="none">
        {filteredMembers.length > 0 ? (
          filteredMembers.map((member) => (
            <TeamMemberRow
              key={member.id}
              member={member}
              onRoleChange={onRoleChange}
              onRemove={onRemove}
              canEdit={canEdit}
            />
          ))
        ) : (
          <div className="p-8 text-center text-[var(--color-text-muted)]">
            No members found
          </div>
        )}
      </Card>

      {/* Invite modal */}
      {onInvite && (
        <InviteMemberModal
          open={inviteModalOpen}
          onClose={() => setInviteModalOpen(false)}
          onInvite={onInvite}
        />
      )}
    </div>
  );
}
EOF
fi

# Update index export
INDEX_FILE="$TEAM_DIR/index.ts"
if grep -q "TeamMemberList" "$INDEX_FILE" 2>/dev/null; then
    echo "TeamMemberList already exported."
else
    echo "Updating index.ts..."
    echo 'export { TeamMemberList } from "./TeamMemberList";' >> "$INDEX_FILE"
fi

# Create team page directory
mkdir -p "$APP_DIR/team"

# Create team page
TEAM_PAGE="$APP_DIR/team/page.tsx"
if [ -f "$TEAM_PAGE" ]; then
    echo "team/page.tsx already exists. Skipping."
else
    echo "Creating team/page.tsx..."
    cat > "$TEAM_PAGE" << 'EOF'
import { TeamMemberList } from "@/components/team/TeamMemberList";
import { ThemeToggle } from "@/components/ThemeToggle";
import { mockMembers } from "@/data/mockTeamMembers";

export default function TeamPage() {
  return (
    <div className="min-h-screen bg-[var(--color-bg)]">
      {/* Header */}
      <header className="border-b border-[var(--color-border)] bg-[var(--color-bg)]">
        <div className="max-w-5xl mx-auto px-6 py-4 flex justify-between items-center">
          <h1 className="text-xl font-bold text-[var(--color-text)]">
            Team Settings
          </h1>
          <ThemeToggle />
        </div>
      </header>

      {/* Main content */}
      <main className="max-w-5xl mx-auto px-6 py-8">
        <TeamMemberList
          members={mockMembers}
          onRoleChange={(id, role) => {
            console.log("Change role:", id, role);
          }}
          onRemove={(member) => {
            console.log("Remove:", member);
          }}
          onInvite={async (invite) => {
            console.log("Invite:", invite);
            await new Promise((r) => setTimeout(r, 1000));
          }}
        />
      </main>
    </div>
  );
}
EOF
fi

echo ""
echo "=== Setup Complete ==="
echo ""
echo "Files created:"
echo "  - $MEMBER_LIST"
echo "  - $TEAM_PAGE"
echo ""
echo "Architecture overview:"
echo ""
echo "  /team/page.tsx (Layer 5)"
echo "    └── TeamMemberList (Layer 4)"
echo "          ├── TeamMemberRow (Layer 4)"
echo "          │     ├── Avatar, Badge (Layer 2)"
echo "          │     └── Select, Button (Layer 2)"
echo "          └── InviteMemberModal (Layer 4)"
echo "                └── Modal, Input, Select (Layer 2-3)"
echo ""
echo "Next steps:"
echo "  1. Read the README.md for this lab"
echo "  2. Start the dev server: npm run dev"
echo "  3. Navigate to /team"
echo "  4. Test all features: search, filter, invite, theme"
echo "  5. Proceed to Lab 9.5 for final review"
echo ""
