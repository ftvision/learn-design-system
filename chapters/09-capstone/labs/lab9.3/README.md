# Lab 9.3: Build App Components

## Objective

Build the TeamMemberRow and InviteMemberModal app components. These components combine UI primitives with business logic specific to the team management feature.

## Time Estimate

~45 minutes

## Prerequisites

- Completed Lab 9.2 (Modal and Select UI components)
- Types and mock data from Lab 9.1
- Understanding of composition patterns

## Setup

### Quick Setup

```bash
./setup.sh
```

This will:
1. Create the team components directory
2. Create TeamMemberRow.tsx
3. Create InviteMemberModal.tsx

### Manual Setup

Navigate to web app:
```bash
cd ../../../04-monorepo-architecture/labs/lab4.1/apps/web
mkdir -p components/team
```

## Exercises

### Exercise 1: Build TeamMemberRow

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

**Key observations:**
- Uses UI primitives (Avatar, Badge, Button, Select)
- Contains business logic (owner can't be removed)
- Maps role to badge color
- Handles pending status display

### Exercise 2: Build InviteMemberModal

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
```

**Key observations:**
- Uses Modal compound components
- Contains form validation logic
- Handles async submission with loading state
- Resets form on successful submit

### Exercise 3: Create Index Export

Create `apps/web/components/team/index.ts`:

```typescript
export { TeamMemberRow } from "./TeamMemberRow";
export { InviteMemberModal } from "./InviteMemberModal";
```

### Exercise 4: Understand the Separation

Compare the layers:

| Aspect | UI Component (Modal) | App Component (InviteMemberModal) |
|--------|---------------------|-----------------------------------|
| Location | packages/ui/ | apps/web/components/ |
| Knowledge | Generic modal pattern | Team invitation flow |
| Validation | None | Email format, required fields |
| State | Just open/close | Form fields, errors, loading |
| Reusable | Across any app | Within this feature |

### Exercise 5: Test the Components

Create a simple test page to verify the components work:

```tsx
// apps/web/app/test-team/page.tsx (temporary)
"use client";

import { useState } from "react";
import { TeamMemberRow } from "@/components/team/TeamMemberRow";
import { InviteMemberModal } from "@/components/team/InviteMemberModal";
import { Button } from "@myapp/ui";
import { mockMembers } from "@/data/mockTeamMembers";

export default function TestTeamPage() {
  const [inviteOpen, setInviteOpen] = useState(false);

  return (
    <div className="p-8 bg-[var(--color-bg)] min-h-screen">
      <h1 className="text-2xl font-bold mb-4 text-[var(--color-text)]">
        Component Test
      </h1>

      <Button onClick={() => setInviteOpen(true)} className="mb-4">
        Open Invite Modal
      </Button>

      <div className="border border-[var(--color-border)] rounded-lg">
        {mockMembers.map((member) => (
          <TeamMemberRow
            key={member.id}
            member={member}
            onRoleChange={(id, role) => console.log("Role change:", id, role)}
            onRemove={(m) => console.log("Remove:", m)}
          />
        ))}
      </div>

      <InviteMemberModal
        open={inviteOpen}
        onClose={() => setInviteOpen(false)}
        onInvite={async (invite) => {
          console.log("Invite:", invite);
          await new Promise((r) => setTimeout(r, 1000));
        }}
      />
    </div>
  );
}
```

## Key Concepts

### App Component Pattern

App components:
1. **Import UI primitives** from the shared package
2. **Add domain knowledge** (TeamMember, roles, etc.)
3. **Contain business logic** (validation, permissions)
4. **Manage feature state** (form fields, errors)

```tsx
// The app component KNOWS about TeamMember
function TeamMemberRow({ member }: { member: TeamMember }) {
  // Business logic: owners can't be removed
  const canRemove = member.role !== "owner";

  // Composes UI primitives with domain logic
  return (
    <Card>
      <Avatar src={member.avatarUrl} />  {/* UI primitive */}
      {canRemove && <Button>Remove</Button>}  {/* Business rule */}
    </Card>
  );
}
```

### Form Validation Pattern

```tsx
const handleSubmit = async (e: React.FormEvent) => {
  e.preventDefault();
  setErrors({});

  // 1. Validate
  if (!email) {
    setErrors({ email: "Required" });
    return;
  }

  // 2. Submit
  setIsSubmitting(true);
  try {
    await onInvite({ email, role });
    onClose();  // Success: close modal
    resetForm();
  } catch (error) {
    setErrors({ submit: "Failed" });  // Error: show message
  } finally {
    setIsSubmitting(false);
  }
};
```

## Checklist

Before proceeding to Lab 9.4:

- [ ] TeamMemberRow displays member info correctly
- [ ] TeamMemberRow shows role dropdown (not for owner)
- [ ] TeamMemberRow shows pending badge when applicable
- [ ] InviteMemberModal validates email
- [ ] InviteMemberModal shows loading state
- [ ] InviteMemberModal resets on close
- [ ] Both components use CSS variables for theming

## Troubleshooting

### Import errors for @myapp/ui

Ensure the UI package is properly linked in `package.json`:
```json
{
  "dependencies": {
    "@myapp/ui": "workspace:*"
  }
}
```

### Type errors for TeamMember

Check that the types are exported from `types/team.ts` and imported correctly.

### Modal not closing after submit

Ensure you call `onClose()` after successful submission, not in the `finally` block.

## Next

Proceed to Lab 9.4 to build TeamMemberList and the team page.
