# Chapter 9 Study Plan: Capstone Project

## Overview

This capstone project integrates everything from Chapters 1-8. You'll build a complete Team Management feature that demonstrates mastery of design systems.

---

## Part 1: Planning (30 minutes)

### Step 1.1: Define the Data Model

```typescript
// apps/web/types/team.ts

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
```

### Step 1.2: Component Inventory

**UI Components to Build:**

| Component | Location | Purpose |
|-----------|----------|---------|
| Modal | packages/ui | Reusable modal dialog |
| Select | packages/ui | Dropdown select |
| ConfirmDialog | packages/ui | Confirm action modal |

**App Components to Build:**

| Component | Location | Purpose |
|-----------|----------|---------|
| TeamMemberRow | apps/web/components | Single member display |
| TeamMemberList | apps/web/components | List with search/filter |
| InviteMemberModal | apps/web/components | Invite form in modal |
| EditRoleModal | apps/web/components | Role editor |
| ConfirmDeleteDialog | apps/web/components | Deletion confirmation |

---

## Part 2: Build UI Components (2-3 hours)

### Step 2.1: Build Modal Component

Create `packages/ui/src/components/Modal.tsx`:

```tsx
"use client";

import * as React from "react";
import { cn } from "../lib/utils";

interface ModalProps {
  open: boolean;
  onClose: () => void;
  children: React.ReactNode;
  className?: string;
}

export function Modal({ open, onClose, children, className }: ModalProps) {
  // Close on escape key
  React.useEffect(() => {
    const handleEscape = (e: KeyboardEvent) => {
      if (e.key === "Escape") onClose();
    };
    if (open) {
      document.addEventListener("keydown", handleEscape);
      document.body.style.overflow = "hidden";
    }
    return () => {
      document.removeEventListener("keydown", handleEscape);
      document.body.style.overflow = "";
    };
  }, [open, onClose]);

  if (!open) return null;

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center">
      {/* Backdrop */}
      <div
        className="fixed inset-0 bg-black/50 backdrop-blur-sm"
        onClick={onClose}
        aria-hidden="true"
      />
      {/* Modal content */}
      <div
        role="dialog"
        aria-modal="true"
        className={cn(
          "relative z-50 w-full max-w-lg mx-4",
          "bg-[var(--color-bg)] rounded-lg shadow-lg",
          "border border-[var(--color-border)]",
          className
        )}
      >
        {children}
      </div>
    </div>
  );
}

export function ModalHeader({ className, children, ...props }: React.HTMLAttributes<HTMLDivElement>) {
  return (
    <div className={cn("px-6 py-4 border-b border-[var(--color-border)]", className)} {...props}>
      {children}
    </div>
  );
}

export function ModalTitle({ className, ...props }: React.HTMLAttributes<HTMLHeadingElement>) {
  return <h2 className={cn("text-lg font-semibold text-[var(--color-text)]", className)} {...props} />;
}

export function ModalBody({ className, ...props }: React.HTMLAttributes<HTMLDivElement>) {
  return <div className={cn("px-6 py-4", className)} {...props} />;
}

export function ModalFooter({ className, ...props }: React.HTMLAttributes<HTMLDivElement>) {
  return (
    <div
      className={cn("px-6 py-4 border-t border-[var(--color-border)] flex justify-end gap-2", className)}
      {...props}
    />
  );
}
```

### Step 2.2: Build Select Component

Create `packages/ui/src/components/Select.tsx`:

```tsx
import * as React from "react";
import { cn } from "../lib/utils";

export interface SelectOption {
  value: string;
  label: string;
}

interface SelectProps extends Omit<React.SelectHTMLAttributes<HTMLSelectElement>, "onChange"> {
  options: SelectOption[];
  label?: string;
  error?: string;
  onChange?: (value: string) => void;
}

export const Select = React.forwardRef<HTMLSelectElement, SelectProps>(
  ({ className, options, label, error, onChange, id, ...props }, ref) => {
    const selectId = id || React.useId();

    return (
      <div className="w-full">
        {label && (
          <label
            htmlFor={selectId}
            className="block text-sm font-medium text-[var(--color-text)] mb-1.5"
          >
            {label}
          </label>
        )}
        <select
          ref={ref}
          id={selectId}
          className={cn(
            "flex h-10 w-full rounded-md border px-3 py-2 text-sm",
            "bg-[var(--color-bg)] text-[var(--color-text)]",
            "border-[var(--color-border)]",
            "focus:outline-none focus:ring-2 focus:ring-[var(--ring-color)]",
            "disabled:cursor-not-allowed disabled:opacity-50",
            error && "border-[var(--color-error)]",
            className
          )}
          onChange={(e) => onChange?.(e.target.value)}
          {...props}
        >
          {options.map((option) => (
            <option key={option.value} value={option.value}>
              {option.label}
            </option>
          ))}
        </select>
        {error && <p className="mt-1 text-sm text-[var(--color-error)]">{error}</p>}
      </div>
    );
  }
);
Select.displayName = "Select";
```

### Step 2.3: Update Index Exports

Update `packages/ui/src/index.tsx`:

```tsx
// Add new exports
export {
  Modal,
  ModalHeader,
  ModalTitle,
  ModalBody,
  ModalFooter,
} from "./components/Modal";
export { Select, type SelectOption } from "./components/Select";
```

### Step 2.4: Write Storybook Stories

Create stories for Modal and Select in `packages/ui/src/components/`.

---

## Part 3: Build App Components (2-3 hours)

### Step 3.1: Create TeamMemberRow

Create `apps/web/components/team/TeamMemberRow.tsx`:

```tsx
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
```

### Step 3.2: Create InviteMemberModal

Create `apps/web/components/team/InviteMemberModal.tsx`:

```tsx
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
            <div className="p-3 text-sm bg-[var(--color-error-subtle)] text-[var(--color-error)] rounded-md">
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
              className="w-full rounded-md border border-[var(--color-border)] bg-[var(--color-bg)] px-3 py-2 text-sm"
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
```

### Step 3.3: Create TeamMemberList

Create `apps/web/components/team/TeamMemberList.tsx`:

```tsx
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
```

---

## Part 4: Create the Page (30 minutes)

### Step 4.1: Create Team Page

Create `apps/web/app/team/page.tsx`:

```tsx
import { TeamMemberList } from "@/components/team/TeamMemberList";
import { ThemeToggle } from "@/components/ThemeToggle";
import type { TeamMember } from "@/types/team";

// Mock data
const mockMembers: TeamMember[] = [
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
```

---

## Part 5: Final Checklist

### Functional
- [ ] Members display with avatar, name, email, role
- [ ] Search filters by name or email
- [ ] Role filter works
- [ ] Invite modal opens and submits
- [ ] Role can be changed inline
- [ ] Remove button works for non-owners
- [ ] Theme toggle changes colors

### Technical
- [ ] All components use CSS variables for colors
- [ ] All UI components export from packages/ui
- [ ] App components are in apps/web/components
- [ ] TypeScript types are defined
- [ ] No hardcoded colors in components

### Documentation
- [ ] Modal has Storybook stories
- [ ] Select has Storybook stories
- [ ] Theme works in Storybook

---

## Part 6: Stretch Goals

If you finish early:

1. **Add confirmation dialog for delete**
2. **Add loading skeletons**
3. **Add sorting (by name, role, date joined)**
4. **Add pagination for large lists**
5. **Add keyboard navigation for the list**

---

## Congratulations!

You've completed the Design System course. You now understand:

- The 5-layer architecture of design systems
- How to create and use design tokens
- Building accessible primitive components
- Monorepo architecture with Turborepo
- Separating UI from app components
- Implementing themes with CSS variables
- Documenting with Storybook
- Cross-platform token generation

Keep building and refer back to the real-world examples (Cal.com, Supabase) as you evolve your design system!
