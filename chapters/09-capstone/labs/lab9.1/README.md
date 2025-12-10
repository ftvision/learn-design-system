# Lab 9.1: Planning & Data Model

## Objective

Define the data model and TypeScript types for the Team Management feature, and create a component inventory for the capstone project.

## Time Estimate

~30 minutes

## Prerequisites

- Completed Chapters 1-8
- Monorepo from Chapter 4 working
- Understanding of TypeScript interfaces

## Setup

### Quick Setup

```bash
./setup.sh
```

This will:
1. Check that the monorepo exists
2. Create the types directory
3. Create the team types file

### Manual Setup

Navigate to the web app:
```bash
cd ../../../04-monorepo-architecture/labs/lab4.1/apps/web
mkdir -p types
```

## Exercises

### Exercise 1: Define TeamMember Type

Create `apps/web/types/team.ts`:

```typescript
export interface TeamMember {
  id: string;
  name: string;
  email: string;
  role: "owner" | "admin" | "member" | "guest";
  avatarUrl?: string;
  joinedAt: Date;
  status: "active" | "pending" | "inactive";
}
```

**Key observations:**
- `role` uses a union type for type safety
- `avatarUrl` is optional (some members may not have one)
- `status` tracks invitation state

### Exercise 2: Define TeamInvite Type

Add to `apps/web/types/team.ts`:

```typescript
export interface TeamInvite {
  email: string;
  role: "admin" | "member" | "guest";
  message?: string;
}
```

Note: `owner` is not a valid invite role (there can only be one owner).

### Exercise 3: Create Mock Data

Create `apps/web/data/mockTeamMembers.ts`:

```typescript
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
```

### Exercise 4: Component Inventory

Review the components you'll need to build:

**UI Components (packages/ui/):**

| Component | Layer | Status | Purpose |
|-----------|-------|--------|---------|
| Button | 2 | Existing | Actions |
| Input | 2 | Existing | Form fields |
| Card | 2 | Existing | Containers |
| Avatar | 2 | Existing | User images |
| Badge | 2 | Existing | Status indicators |
| Modal | 2-3 | **New** | Dialog overlay |
| Select | 2 | **New** | Dropdown selection |

**App Components (apps/web/components/):**

| Component | Purpose | Composes |
|-----------|---------|----------|
| TeamMemberRow | Single member display | Avatar, Badge, Select, Button |
| InviteMemberModal | Invite form in modal | Modal, Input, Select, Button |
| TeamMemberList | List with search/filter | Input, Button, Card, TeamMemberRow |

### Exercise 5: Architecture Review

Map the feature to the 5-layer architecture:

```
Layer 5: Page
└── /team/page.tsx
    ├── Data fetching (mock for now)
    └── Orchestration

Layer 4: App Components
└── apps/web/components/team/
    ├── TeamMemberList.tsx
    ├── TeamMemberRow.tsx
    └── InviteMemberModal.tsx

Layers 2-3: UI Components
└── packages/ui/src/components/
    ├── Modal.tsx (new)
    ├── Select.tsx (new)
    ├── Button.tsx (existing)
    ├── Input.tsx (existing)
    ├── Avatar.tsx (existing)
    └── Badge.tsx (existing)

Layer 1: Design Tokens
└── packages/tokens/ + theme.css
    └── All semantic tokens
```

## Key Concepts

### Separation of Concerns

| Aspect | UI Components | App Components |
|--------|---------------|----------------|
| Knowledge | Generic patterns | Business domain |
| Example | `Modal` with children | `InviteMemberModal` |
| Location | packages/ui/ | apps/web/components/ |
| Reusability | Across apps | Within app |

### Type-Driven Development

Define types first, then build components:

```typescript
// 1. Define the shape of data
interface TeamMember { ... }

// 2. Define component props based on data
interface TeamMemberRowProps {
  member: TeamMember;
  onRoleChange?: (id: string, role: TeamMember["role"]) => void;
}

// 3. Build the component
function TeamMemberRow({ member, onRoleChange }: TeamMemberRowProps) { ... }
```

## Checklist

Before proceeding to Lab 9.2:

- [ ] TeamMember type defined
- [ ] TeamInvite type defined
- [ ] Mock data created
- [ ] Understand which components are new vs existing
- [ ] Understand the 5-layer mapping

## Troubleshooting

### TypeScript path alias not working

Ensure `tsconfig.json` has:
```json
{
  "compilerOptions": {
    "paths": {
      "@/*": ["./src/*"]
    }
  }
}
```

### Import errors for types

Check that the file is created at `apps/web/types/team.ts` and exported correctly.

## Next

Proceed to Lab 9.2 to build the Modal and Select UI components.
