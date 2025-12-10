# Chapter 5 Study Plan: App Components

## Part 1: Theory (20 minutes)

### 1.1 The Component Spectrum

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

### 1.2 Decision Framework

**Put in `packages/ui/` when:**
- Could be used in any application
- No knowledge of your business domain
- Purely presentational
- Configured entirely through props

**Put in `apps/web/components/` when:**
- Specific to your product
- Knows about your data types (User, Order, Product)
- Contains business logic or validation
- Has side effects (API calls, navigation)

### 1.3 Anatomy of an App Component

```tsx
// apps/web/components/UserCard.tsx

// 1. Import UI components from your design system
import { Card, Avatar, Badge, Button } from "@myapp/ui";

// 2. Import business types
import type { User } from "@/types";

// 3. Define props with business context
interface UserCardProps {
  user: User;                    // Business entity
  onEdit?: (user: User) => void; // Business action
  onDelete?: (user: User) => void;
}

// 4. Compose UI components with business logic
export function UserCard({ user, onEdit, onDelete }: UserCardProps) {
  // Business logic can live here
  const canDelete = user.role !== "admin";

  return (
    <Card>
      {/* Compose UI primitives */}
      <Avatar src={user.avatarUrl} alt={user.name} />
      <h3>{user.name}</h3>
      <Badge variant={user.role === "admin" ? "primary" : "default"}>
        {user.role}
      </Badge>

      {/* Conditional business logic */}
      {onEdit && (
        <Button variant="secondary" onClick={() => onEdit(user)}>
          Edit
        </Button>
      )}
      {onDelete && canDelete && (
        <Button variant="destructive" onClick={() => onDelete(user)}>
          Delete
        </Button>
      )}
    </Card>
  );
}
```

---

## Part 2: Labs

### Lab 5.1: Types & UserCard (~30 minutes)

**Objective:** Create business type definitions and build the UserCard component.

**Topics:**
- Business entity types (User, Product, Order)
- Component spectrum understanding
- Composing UI primitives with business logic

**Key Concepts:**
- Why types belong in app, not UI package
- Business logic in app components
- Props with business entities

[→ Go to Lab 5.1](./labs/lab5.1/README.md)

---

### Lab 5.2: UserList Component (~25 minutes)

**Objective:** Build a UserList that composes UserCard with filtering and search.

**Topics:**
- Component composition pattern
- "use client" directive
- Search and filter business logic

**Key Concepts:**
- State management in app components
- Filtering logic placement
- Composition over configuration

[→ Go to Lab 5.2](./labs/lab5.2/README.md)

---

### Lab 5.3: ContactForm with Validation (~35 minutes)

**Objective:** Build a ContactForm with validation logic and submission states.

**Topics:**
- Form state management
- Validation business logic
- Async form submission
- Success/error states

**Key Concepts:**
- Why validation belongs in app components
- Form state pattern
- Error clearing UX

[→ Go to Lab 5.3](./labs/lab5.3/README.md)

---

### Lab 5.4: ProductCard Component (~25 minutes)

**Objective:** Build a ProductCard with price formatting and stock status logic.

**Topics:**
- Price formatting with Intl.NumberFormat
- Conditional UI based on business state
- Action button states

**Key Concepts:**
- Business formatting functions
- Conditional action rendering
- Comparing similar component patterns

[→ Go to Lab 5.4](./labs/lab5.4/README.md)

---

### Lab 5.5: Demo Page & Compare (~30 minutes)

**Objective:** Create a demo page and compare with real-world projects.

**Topics:**
- Integrating all app components
- Cal.com app component patterns
- Written reflection

**Key Concepts:**
- Component organization strategies
- When to promote app → UI
- Production patterns

[→ Go to Lab 5.5](./labs/lab5.5/README.md)

---

## Part 3: Self-Check & Reflection

### Files You Should Have

```
apps/web/
├── types/
│   └── index.ts          # User, Product, Order types
├── components/
│   ├── UserCard.tsx      # User display with role logic
│   ├── UserList.tsx      # Filterable user list
│   ├── ContactForm.tsx   # Form with validation
│   └── ProductCard.tsx   # Product display with pricing
└── app/
    └── page.tsx          # Demo page
```

### Self-Check

Before moving to Chapter 6, verify:

- [ ] Created UserCard that composes UI primitives
- [ ] Created UserList with search and filtering
- [ ] Created ContactForm with validation logic
- [ ] Created ProductCard with business formatting
- [ ] Understood separation of UI vs app components
- [ ] Studied Cal.com's app component patterns
- [ ] Demo page works with all components

### Written Reflection

1. **What's the key difference between UI and app components?**
   ```


   ```

2. **Where does form validation logic belong - UI or app component?**
   ```


   ```

3. **When would you "promote" an app component to the UI package?**
   ```


   ```

4. **How do app components enable code reuse while staying specific?**
   ```


   ```

---

## Extension Exercises

### Exercise 5.1: Add Data Fetching

Convert UserList to fetch users from an API:
```tsx
// Use React Query or SWR
const { data: users, isLoading, error } = useUsers();
```

### Exercise 5.2: Add a Modal Flow

Create an EditUserModal that:
- Opens when "Edit" is clicked
- Uses UI Modal component
- Has form validation
- Submits to an API

### Exercise 5.3: Create OrderCard

Build an OrderCard component that:
- Displays order status with appropriate badge colors
- Shows order items list
- Has actions based on status (cancel, track, reorder)

---

## Next Chapter

In Chapter 6, you'll add theming support to enable light/dark modes and custom brand colors.
