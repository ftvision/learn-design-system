# Lab 5.1: Types & UserCard

## Objective

Create business type definitions and build the first app component (UserCard) that composes UI primitives with business logic.

## Time Estimate

~30 minutes

## Prerequisites

- Completed Chapter 4 (monorepo setup)
- Understanding of TypeScript interfaces
- Familiarity with UI components from Chapter 3

## Setup

### Quick Setup

```bash
./setup.sh
```

This will:
1. Create the types directory structure
2. Create business type definitions
3. Create the UserCard component

### Manual Setup

Navigate to your web app:
```bash
cd ../../../04-monorepo-architecture/labs/lab4.1/apps/web
```

## Exercises

### Exercise 1: Understand the Component Spectrum

Components exist on a spectrum from generic to specific:

```
Generic (UI Package)              Specific (App Components)
◄─────────────────────────────────────────────────────────►

Button          Avatar          UserCard          UserProfilePage
   │               │                │                    │
   │               │                │                    │
No business    Still generic    Knows about         Full page with
logic          but displays     User type,          routing, data
               user data        has edit/delete     fetching, etc.
```

**Key decision framework:**

| Put in `packages/ui/` when... | Put in `apps/web/components/` when... |
|-------------------------------|---------------------------------------|
| Could be used in any app | Specific to your product |
| No business domain knowledge | Knows your data types (User, Order) |
| Purely presentational | Contains business logic |
| Configured through props | Has side effects (API, navigation) |

### Exercise 2: Create Type Definitions

Examine `apps/web/types/index.ts`:

```typescript
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
```

**Questions:**
1. Why are these types in `apps/web/types/` not `packages/ui/`?
2. What makes `role: "admin" | "member" | "guest"` a union type?
3. Why is `avatarUrl` optional (`?`)?

### Exercise 3: Examine the UserCard Component

Open `apps/web/components/UserCard.tsx`:

```tsx
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
          <Avatar
            src={user.avatarUrl}
            alt={user.name}
            size="lg"
          />
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
```

### Exercise 4: Identify the Pattern

Notice how UserCard:

1. **Imports UI components** from `@myapp/ui`
   ```tsx
   import { Card, CardContent, Avatar, Badge, Button } from "@myapp/ui";
   ```

2. **Imports business types** from local types
   ```tsx
   import type { User } from "@/types";
   ```

3. **Accepts business entities as props**
   ```tsx
   interface UserCardProps {
     user: User;  // Business entity, not generic data
   }
   ```

4. **Contains business logic**
   ```tsx
   const canDelete = user.role !== "admin";
   const roleBadgeVariant = user.role === "admin" ? "primary" : ...;
   ```

5. **Composes UI primitives**
   ```tsx
   <Card>
     <Avatar ... />
     <Badge ... />
     <Button ... />
   </Card>
   ```

### Exercise 5: Why This Isn't in packages/ui

UserCard cannot be in `packages/ui` because:

| Aspect | Why it's app-specific |
|--------|----------------------|
| `User` type | Specific to this application |
| Role logic | Business rule: admins can't be deleted |
| Date formatting | Locale-specific business decision |
| Badge colors | Business meaning of roles |

If another app used the same UI package, they would have different:
- User types (maybe no `role` field)
- Business rules (maybe admins CAN be deleted)
- Display preferences

## Key Concepts

### Anatomy of an App Component

```tsx
// 1. Import UI components from design system
import { Card, Avatar, Badge, Button } from "@myapp/ui";

// 2. Import business types
import type { User } from "@/types";

// 3. Props include business entities
interface UserCardProps {
  user: User;
  onEdit?: (user: User) => void;
}

// 4. Component contains business logic
export function UserCard({ user, onEdit }: UserCardProps) {
  const canDelete = user.role !== "admin";  // Business rule

  // 5. Compose UI primitives with business context
  return (
    <Card>
      <Avatar src={user.avatarUrl} />
      <Badge variant={roleToVariant(user.role)} />
    </Card>
  );
}
```

### UI Component vs App Component

| UI Component (packages/ui) | App Component (apps/web) |
|---------------------------|--------------------------|
| `<Avatar src={url} />` | `<UserCard user={user} />` |
| `<Badge variant="success">` | Role-based badge color |
| `<Button onClick={fn}>` | `onEdit(user)` with business entity |
| No business knowledge | Knows User, Order, Product types |

## Checklist

Before proceeding to Lab 5.2:

- [ ] Type definitions created in apps/web/types/
- [ ] UserCard component created
- [ ] Understand why UserCard imports from @myapp/ui
- [ ] Understand why UserCard contains business logic
- [ ] Can identify what makes this an "app component"

## Troubleshooting

### "Cannot find module '@/types'"

Check tsconfig.json has path alias:
```json
{
  "compilerOptions": {
    "paths": {
      "@/*": ["./*"]
    }
  }
}
```

### "Cannot find module '@myapp/ui'"

Make sure you've run `pnpm install` from the monorepo root.

## Next

Proceed to Lab 5.2 to build the UserList component with filtering.
