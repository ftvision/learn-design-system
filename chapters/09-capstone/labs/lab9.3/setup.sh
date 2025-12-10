#!/bin/bash

# Lab 9.3 Setup Script
# Creates TeamMemberRow and InviteMemberModal app components

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MONOREPO_DIR="$SCRIPT_DIR/../../../04-monorepo-architecture/labs/lab4.1"
WEB_DIR="$MONOREPO_DIR/apps/web"
TEAM_DIR="$WEB_DIR/components/team"

echo "=== Lab 9.3 Setup: App Components ==="
echo ""

# Check if monorepo exists
if [ ! -d "$MONOREPO_DIR" ]; then
    echo "Error: Chapter 4 monorepo not found at $MONOREPO_DIR"
    echo "Please complete Chapter 4 labs first."
    exit 1
fi

# Check if types exist from Lab 9.1
if [ ! -f "$WEB_DIR/types/team.ts" ]; then
    echo "Warning: types/team.ts not found. Running Lab 9.1 setup..."
    bash "$SCRIPT_DIR/../lab9.1/setup.sh"
fi

# Create team components directory
mkdir -p "$TEAM_DIR"

# Create TeamMemberRow
MEMBER_ROW="$TEAM_DIR/TeamMemberRow.tsx"
if [ -f "$MEMBER_ROW" ]; then
    echo "TeamMemberRow.tsx already exists. Skipping."
else
    echo "Creating TeamMemberRow.tsx..."
    cat > "$MEMBER_ROW" << 'EOF'
import { Avatar, Badge, Button, Select } from "@myapp/ui";
import type { TeamMember } from "@/types/team";

interface TeamMemberRowProps {
  member: TeamMember;
  onRoleChange?: (memberId: string, role: TeamMember["role"]) => void;
  onRemove?: (member: TeamMember) => void;
  canEdit?: boolean;
}

const roleOptions = [
  { value: "admin", label: "Admin" },
  { value: "member", label: "Member" },
  { value: "guest", label: "Guest" },
];

const roleColors = {
  owner: "primary",
  admin: "primary",
  member: "success",
  guest: "default",
} as const;

export function TeamMemberRow({
  member,
  onRoleChange,
  onRemove,
  canEdit = true,
}: TeamMemberRowProps) {
  const isOwner = member.role === "owner";

  return (
    <div className="flex items-center gap-4 p-4 border-b border-[var(--color-border)]">
      <Avatar src={member.avatarUrl} alt={member.name} size="md" />

      <div className="flex-1 min-w-0">
        <div className="flex items-center gap-2">
          <span className="font-medium text-[var(--color-text)] truncate">
            {member.name}
          </span>
          {member.status === "pending" && (
            <Badge variant="warning">Pending</Badge>
          )}
        </div>
        <span className="text-sm text-[var(--color-text-muted)] truncate block">
          {member.email}
        </span>
      </div>

      <div className="flex items-center gap-4">
        {isOwner ? (
          <Badge variant={roleColors[member.role]}>{member.role}</Badge>
        ) : canEdit && onRoleChange ? (
          <Select
            options={roleOptions}
            value={member.role}
            onChange={(value) =>
              onRoleChange(member.id, value as TeamMember["role"])
            }
            className="w-32"
          />
        ) : (
          <Badge variant={roleColors[member.role]}>{member.role}</Badge>
        )}

        {!isOwner && canEdit && onRemove && (
          <Button
            variant="ghost"
            size="sm"
            onClick={() => onRemove(member)}
            className="text-[var(--color-error)]"
          >
            Remove
          </Button>
        )}
      </div>
    </div>
  );
}
EOF
fi

# Create InviteMemberModal
INVITE_MODAL="$TEAM_DIR/InviteMemberModal.tsx"
if [ -f "$INVITE_MODAL" ]; then
    echo "InviteMemberModal.tsx already exists. Skipping."
else
    echo "Creating InviteMemberModal.tsx..."
    cat > "$INVITE_MODAL" << 'EOF'
"use client";

import { useState } from "react";
import {
  Modal,
  ModalHeader,
  ModalTitle,
  ModalBody,
  ModalFooter,
  Input,
  Select,
  Button,
} from "@myapp/ui";
import type { TeamInvite, TeamMember } from "@/types/team";

interface InviteMemberModalProps {
  open: boolean;
  onClose: () => void;
  onInvite: (invite: TeamInvite) => Promise<void>;
}

const roleOptions = [
  { value: "admin", label: "Admin" },
  { value: "member", label: "Member" },
  { value: "guest", label: "Guest" },
];

export function InviteMemberModal({
  open,
  onClose,
  onInvite,
}: InviteMemberModalProps) {
  const [email, setEmail] = useState("");
  const [role, setRole] = useState<TeamMember["role"]>("member");
  const [message, setMessage] = useState("");
  const [errors, setErrors] = useState<Record<string, string>>({});
  const [isSubmitting, setIsSubmitting] = useState(false);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setErrors({});

    // Validation
    if (!email.trim()) {
      setErrors({ email: "Email is required" });
      return;
    }
    if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
      setErrors({ email: "Invalid email address" });
      return;
    }

    setIsSubmitting(true);
    try {
      await onInvite({ email, role, message: message || undefined });
      onClose();
      // Reset form
      setEmail("");
      setRole("member");
      setMessage("");
    } catch (error) {
      setErrors({ submit: "Failed to send invite" });
    } finally {
      setIsSubmitting(false);
    }
  };

  return (
    <Modal open={open} onClose={onClose}>
      <form onSubmit={handleSubmit}>
        <ModalHeader>
          <ModalTitle>Invite Team Member</ModalTitle>
        </ModalHeader>
        <ModalBody className="space-y-4">
          {errors.submit && (
            <div className="p-3 text-sm bg-red-50 text-[var(--color-error)] rounded-md dark:bg-red-900/20">
              {errors.submit}
            </div>
          )}
          <Input
            label="Email Address"
            type="email"
            placeholder="colleague@company.com"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            error={errors.email}
          />
          <Select
            label="Role"
            options={roleOptions}
            value={role}
            onChange={(v) => setRole(v as TeamMember["role"])}
          />
          <div className="space-y-1">
            <label className="block text-sm font-medium text-[var(--color-text)]">
              Personal Message (optional)
            </label>
            <textarea
              rows={3}
              placeholder="Add a personal note to the invitation..."
              value={message}
              onChange={(e) => setMessage(e.target.value)}
              className="w-full rounded-md border border-[var(--color-border)] bg-[var(--color-bg)] px-3 py-2 text-sm text-[var(--color-text)] focus:outline-none focus:ring-2 focus:ring-[var(--color-primary)]"
            />
          </div>
        </ModalBody>
        <ModalFooter>
          <Button type="button" variant="ghost" onClick={onClose}>
            Cancel
          </Button>
          <Button type="submit" loading={isSubmitting}>
            Send Invite
          </Button>
        </ModalFooter>
      </form>
    </Modal>
  );
}
EOF
fi

# Create index export
INDEX_FILE="$TEAM_DIR/index.ts"
if [ -f "$INDEX_FILE" ]; then
    echo "index.ts already exists. Skipping."
else
    echo "Creating index.ts..."
    cat > "$INDEX_FILE" << 'EOF'
export { TeamMemberRow } from "./TeamMemberRow";
export { InviteMemberModal } from "./InviteMemberModal";
EOF
fi

echo ""
echo "=== Setup Complete ==="
echo ""
echo "Files created:"
echo "  - $MEMBER_ROW"
echo "  - $INVITE_MODAL"
echo "  - $INDEX_FILE"
echo ""
echo "Component comparison:"
echo ""
echo "  UI Component (Modal):"
echo "    - Generic dialog pattern"
echo "    - No business logic"
echo "    - Reusable across apps"
echo ""
echo "  App Component (InviteMemberModal):"
echo "    - Knows about TeamMember/TeamInvite"
echo "    - Contains validation logic"
echo "    - Specific to this feature"
echo ""
echo "Next steps:"
echo "  1. Read the README.md for this lab"
echo "  2. Test components in a temporary page"
echo "  3. Proceed to Lab 9.4 to build TeamMemberList"
echo ""
