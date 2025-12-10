# Lab 9.4: Build TeamMemberList & Team Page

## Objective

Build the TeamMemberList component and create the team page that integrates all components into a complete feature.

## Time Estimate

~45 minutes

## Prerequisites

- Completed Lab 9.3 (TeamMemberRow and InviteMemberModal)
- Understanding of React state management
- Familiarity with filtering patterns

## Setup

### Quick Setup

```bash
./setup.sh
```

This will:
1. Create TeamMemberList.tsx
2. Create the team page at app/team/page.tsx
3. Add ThemeToggle to the page header

### Manual Setup

Navigate to web app:
```bash
cd ../../../04-monorepo-architecture/labs/lab4.1/apps/web
```

## Exercises

### Exercise 1: Build TeamMemberList

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

**Key features:**
- Search by name or email
- Filter by role
- Empty state handling
- Integrates TeamMemberRow and InviteMemberModal

### Exercise 2: Update Team Index

Update `apps/web/components/team/index.ts`:

```typescript
export { TeamMemberRow } from "./TeamMemberRow";
export { InviteMemberModal } from "./InviteMemberModal";
export { TeamMemberList } from "./TeamMemberList";
```

### Exercise 3: Create Team Page

Create `apps/web/app/team/page.tsx`:

```tsx
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
```

### Exercise 4: Test the Complete Feature

1. Start the development server:
```bash
npm run dev
```

2. Navigate to `/team`

3. Test each feature:
   - [ ] Members display with avatars
   - [ ] Search filters by name/email
   - [ ] Role filter buttons work
   - [ ] Invite modal opens
   - [ ] Form validation works
   - [ ] Theme toggle changes colors

### Exercise 5: Understand the Layer Integration

```
┌─────────────────────────────────────────────────────────────────┐
│                    TEAM PAGE ARCHITECTURE                        │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  Layer 5: /team/page.tsx                                        │
│  ├── Fetches data (mock for now)                                │
│  ├── Passes callbacks for mutations                             │
│  └── Renders TeamMemberList                                     │
│                                                                  │
│  Layer 4: TeamMemberList                                        │
│  ├── Manages filter state (search, role)                        │
│  ├── Manages modal state (open/close)                           │
│  ├── Filters members array                                      │
│  └── Renders TeamMemberRow for each member                      │
│                                                                  │
│  Layer 4: TeamMemberRow                                         │
│  ├── Displays member info                                       │
│  ├── Business logic (owner check)                               │
│  └── Composes Avatar, Badge, Select, Button                     │
│                                                                  │
│  Layer 4: InviteMemberModal                                     │
│  ├── Form state management                                      │
│  ├── Validation logic                                           │
│  └── Composes Modal + primitives                                │
│                                                                  │
│  Layers 2-3: UI Primitives                                      │
│  ├── Avatar, Badge, Button, Input, Card                         │
│  ├── Modal, ModalHeader, ModalBody, ModalFooter                │
│  └── Select                                                      │
│                                                                  │
│  Layer 1: Design Tokens                                         │
│  └── --color-bg, --color-text, --color-border, etc.            │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

## Key Concepts

### State Lifting Pattern

Filter state lives in TeamMemberList because:
- It's needed to filter the members array
- It's local to this list feature
- It doesn't need to persist across page navigations

```tsx
function TeamMemberList({ members }: { members: TeamMember[] }) {
  const [search, setSearch] = useState("");  // Local state
  const [roleFilter, setRoleFilter] = useState("all");

  const filteredMembers = members.filter(...);  // Derived state

  return (...);
}
```

### Callback Props Pattern

The page passes callbacks that components can call:

```tsx
// Page provides the callback
<TeamMemberList
  onRoleChange={(id, role) => {
    // Update server
    // Refresh data
  }}
/>

// TeamMemberList passes it down
<TeamMemberRow
  onRoleChange={onRoleChange}  // Same callback
/>

// TeamMemberRow calls it
<Select
  onChange={(value) => onRoleChange(member.id, value)}
/>
```

### Empty State Pattern

Always handle the case when there's no data:

```tsx
{filteredMembers.length > 0 ? (
  filteredMembers.map((member) => ...)
) : (
  <div className="p-8 text-center text-[var(--color-text-muted)]">
    No members found
  </div>
)}
```

## Checklist

Before proceeding to Lab 9.5:

- [ ] TeamMemberList renders with search and filters
- [ ] Search filters by name and email
- [ ] Role filter buttons highlight active filter
- [ ] Empty state shows when no matches
- [ ] Invite button opens modal
- [ ] Team page displays all components
- [ ] Theme toggle works throughout
- [ ] Console shows callbacks being triggered

## Troubleshooting

### "mockMembers is not defined"

Check the import path:
```tsx
import { mockMembers } from "@/data/mockTeamMembers";
```

### Theme toggle not affecting page

Ensure the page uses CSS variables:
```tsx
className="bg-[var(--color-bg)]"  // Good
className="bg-white"  // Bad - won't respond to theme
```

### Filter not working

Check the filter logic:
```tsx
const matchesSearch =
  member.name.toLowerCase().includes(search.toLowerCase()) ||
  member.email.toLowerCase().includes(search.toLowerCase());
```

## Next

Proceed to Lab 9.5 for final polish and the self-check review.
