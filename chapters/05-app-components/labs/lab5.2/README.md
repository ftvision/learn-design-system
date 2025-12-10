# Lab 5.2: UserList Component

## Objective

Build a UserList component that composes UserCard with filtering and search functionality.

## Time Estimate

~25 minutes

## Prerequisites

- Completed Lab 5.1 (Types & UserCard)

## Setup

### Quick Setup

```bash
./setup.sh
```

This will:
1. Ensure Lab 5.1 is complete
2. Create the UserList component

### Manual Setup

Navigate to your web app components:
```bash
cd ../../../04-monorepo-architecture/labs/lab4.1/apps/web/components
```

## Exercises

### Exercise 1: Examine the UserList Component

Open `apps/web/components/UserList.tsx`:

```tsx
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
```

### Exercise 2: Identify the Composition Pattern

UserList demonstrates **component composition**:

```
UserList (App Component)
    │
    ├── Input (UI Primitive)
    │
    ├── Button (UI Primitive) × 4
    │
    └── UserCard (App Component) × N
            │
            ├── Card (UI Primitive)
            ├── Avatar (UI Primitive)
            ├── Badge (UI Primitive)
            └── Button (UI Primitive)
```

### Exercise 3: Understand the "use client" Directive

```tsx
"use client";
```

This is a Next.js directive that marks this component as a **Client Component**:
- Uses React hooks (`useState`)
- Handles user interactions
- Runs in the browser

**Without "use client":**
- Component would be a Server Component
- Cannot use `useState`, `useEffect`, etc.
- Cannot add event handlers

### Exercise 4: Analyze the Business Logic

**Search logic:**
```tsx
const matchesSearch =
  user.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
  user.email.toLowerCase().includes(searchQuery.toLowerCase());
```
- Searches both name AND email
- Case-insensitive
- Business decision: what fields are searchable

**Filter logic:**
```tsx
const matchesRole = roleFilter === "all" || user.role === roleFilter;
```
- "all" shows everyone
- Specific role filters by that role
- Business decision: what filters exist

### Exercise 5: Why Not Put Filtering in UI Package?

You might think: "Filtering is reusable, why not make a generic FilteredList?"

**Answer:** The filtering logic is business-specific:
- Fields to search (`name`, `email`)
- Filter options (`admin`, `member`, `guest`)
- Display format of filters
- Empty state messaging

A generic `FilteredList<T>` would require so many configuration props that it becomes harder to use than just writing the filtering logic.

### Exercise 6: Component Boundaries

| Component | Responsibility |
|-----------|---------------|
| `Input` | Render text input, handle value changes |
| `Button` | Render clickable button with variants |
| `UserCard` | Display a user with business formatting |
| `UserList` | Orchestrate filtering, searching, layout |

Each component has a clear, single responsibility.

## Key Concepts

### State Management in App Components

App components often manage:
- **UI state**: search query, selected filters
- **Business state**: filtered results
- **Loading/error states**: for async operations

```tsx
const [searchQuery, setSearchQuery] = useState("");
const [roleFilter, setRoleFilter] = useState<string>("all");
// Derived state (no need for separate useState)
const filteredUsers = users.filter(...);
```

### Composition Over Configuration

Instead of:
```tsx
// ❌ Over-configured generic component
<GenericList
  items={users}
  searchFields={["name", "email"]}
  filters={[{ field: "role", options: ["admin", "member", "guest"] }]}
  renderItem={(user) => <UserCard user={user} />}
  emptyMessage="No users found"
/>
```

Prefer:
```tsx
// ✅ Clear, readable composition
<UserList users={users} onEditUser={...} onDeleteUser={...} />
```

### Props Drilling vs Context

UserList "drills" callbacks to UserCard:
```tsx
<UserCard
  user={user}
  onEdit={onEditUser}    // Drilled from parent
  onDelete={onDeleteUser} // Drilled from parent
/>
```

This is fine for 1-2 levels. For deeper nesting, consider React Context.

## Checklist

Before proceeding to Lab 5.3:

- [ ] UserList component created
- [ ] Understand "use client" directive
- [ ] Understand filtering business logic
- [ ] Can explain why filtering isn't in UI package
- [ ] Understand composition pattern

## Troubleshooting

### "useState is not defined"

Make sure you have `"use client"` at the top of the file.

### Filters not working

Check that `roleFilter` state is being updated:
```tsx
onClick={() => setRoleFilter(role)}
```

## Next

Proceed to Lab 5.3 to build a ContactForm with validation.
