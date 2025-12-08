# Lecture Notes: App Components (Part 1 - Theory)

**Duration:** 30-45 minutes
**Chapter:** 05 - App Components

---

## Lecture Outline

1. Opening Question
2. The Component Spectrum
3. Anatomy of an App Component
4. The Composition Pattern in Action
5. Business Logic: Where Does It Live?
6. When to Promote (or Not)
7. Key Takeaways

---

## 1. Opening Question (3 minutes)

> **Ask the class:** "You have a `<Button>` component in your UI library. Now you need a button that says 'Add to Cart', disables when out of stock, and triggers an API call. Where does this component live?"

**Expected answers:** "In the app," "It depends," "Maybe a new AddToCartButton component?"

**Instructor note:** This question surfaces the fuzzy boundary between UI and app components. The answer reveals a fundamental principle: **business logic never belongs in the UI library**.

**Follow-up:** "What if three different pages all need that same Add to Cart button?"

---

## 2. The Component Spectrum (8 minutes)

### Components Exist on a Spectrum

From completely generic to completely specific:

```
Generic (UI Package)                        Specific (App Components)
◄────────────────────────────────────────────────────────────────────►

Button        Avatar        UserCard        UserProfilePage
   │             │              │                    │
   │             │              │                    │
No business   Still        Knows about          Full page with
logic         generic,     User type,           routing, data
              just         has edit/delete,     fetching, layout,
              displays     business rules       everything
              an image
```

### The Key Distinction

| UI Components (`packages/ui/`) | App Components (`apps/web/components/`) |
|-------------------------------|----------------------------------------|
| Generic, reusable anywhere | Product-specific |
| No business logic | Contains business logic |
| No knowledge of your domain | Knows your data types |
| No data fetching | May fetch/mutate data |
| Purely presentational | Orchestrates behavior |
| `<Button>` | `<AddToCartButton>` |
| `<Card>` | `<ProductCard>` |
| `<Avatar>` | `<UserProfileHeader>` |

### Visual: The Layer Model

```
┌─────────────────────────────────────────────────────────────────┐
│  Layer 5: Pages/Views                                           │
│    └─ /dashboard, /settings, /products/[id]                     │
├─────────────────────────────────────────────────────────────────┤
│  Layer 4: App Components   ← YOU ARE HERE                       │
│    └─ UserCard, ProductCard, ContactForm, OrderSummary          │
│    └─ These COMPOSE primitives with business logic              │
├─────────────────────────────────────────────────────────────────┤
│  Layer 3: Pattern Components                                    │
│    └─ DataTable, SearchBar, Modal (in packages/ui)              │
├─────────────────────────────────────────────────────────────────┤
│  Layer 2: Primitive Components                                  │
│    └─ Button, Input, Card, Badge, Avatar (in packages/ui)       │
├─────────────────────────────────────────────────────────────────┤
│  Layer 1: Design Tokens                                         │
│    └─ colors, spacing, typography                               │
└─────────────────────────────────────────────────────────────────┘
```

> **Key insight:** App components (Layer 4) are the bridge between your generic UI library (Layers 2-3) and your actual pages (Layer 5). They add the business context.

---

## 3. Anatomy of an App Component (10 minutes)

### The Four Parts

Every app component follows a similar structure:

```tsx
// 1. IMPORTS: UI components from your design system
import { Card, Avatar, Badge, Button } from "@myapp/ui";

// 2. TYPES: Business entities from your domain
import type { User } from "@/types";

// 3. PROPS: Business-contextual interface
interface UserCardProps {
  user: User;                     // Business entity
  onEdit?: (user: User) => void;  // Business action
  onDelete?: (user: User) => void;
}

// 4. COMPONENT: Composition + business logic
export function UserCard({ user, onEdit, onDelete }: UserCardProps) {
  // Business logic lives here
  const canDelete = user.role !== "admin";

  return (
    <Card>
      {/* Compose UI primitives */}
      <Avatar src={user.avatarUrl} alt={user.name} />
      <h3>{user.name}</h3>
      <Badge>{user.role}</Badge>

      {/* Conditional business logic */}
      {onEdit && <Button onClick={() => onEdit(user)}>Edit</Button>}
      {onDelete && canDelete && (
        <Button variant="destructive" onClick={() => onDelete(user)}>
          Delete
        </Button>
      )}
    </Card>
  );
}
```

### Breaking Down Each Part

#### Part 1: Imports from UI Library

```tsx
import { Card, Avatar, Badge, Button } from "@myapp/ui";
```

- App components are **consumers** of your UI library
- They don't reimplement buttons or cards—they use them
- This is the payoff of Chapters 2-4

#### Part 2: Business Types

```tsx
import type { User } from "@/types";

interface User {
  id: string;
  name: string;
  email: string;
  role: "admin" | "member" | "guest";
  avatarUrl?: string;
  createdAt: Date;
}
```

- Your domain entities: User, Product, Order, Invoice
- These types are **specific to your application**
- They wouldn't make sense in a generic UI library

#### Part 3: Props Interface

```tsx
interface UserCardProps {
  user: User;                     // The business entity
  onEdit?: (user: User) => void;  // Callback with business context
  onDelete?: (user: User) => void;
  showActions?: boolean;          // Feature flag
}
```

Notice: Props include **business entities**, not generic data:
- `user: User` not `data: object`
- `onEdit: (user: User)` not `onClick: () => void`

#### Part 4: Business Logic

```tsx
// Inside the component:

// Business rule: admins can't be deleted
const canDelete = user.role !== "admin";

// Business formatting: date display
const memberSince = new Intl.DateTimeFormat("en-US", {
  year: "numeric",
  month: "short",
}).format(user.createdAt);

// Business rule: badge color by role
const roleBadgeVariant =
  user.role === "admin" ? "primary" :
  user.role === "member" ? "success" : "default";
```

This logic is **specific to your product**. It doesn't belong in a generic Card component.

---

## 4. The Composition Pattern in Action (7 minutes)

### What is Composition?

App components **compose** UI primitives—they don't replace them:

```tsx
// App component composes UI components
function ProductCard({ product, onAddToCart }) {
  return (
    <Card>                              {/* UI primitive */}
      <img src={product.imageUrl} />
      <h3>{product.name}</h3>
      <Badge>{product.category}</Badge>  {/* UI primitive */}
      <span>{formatPrice(product)}</span>
      <Button onClick={() => onAddToCart(product)}>  {/* UI primitive */}
        Add to Cart
      </Button>
    </Card>
  );
}
```

### The Composition Hierarchy

```
ProductCard (app component)
    │
    ├── Card (UI primitive)
    │     │
    │     ├── img (HTML)
    │     ├── h3 (HTML)
    │     ├── Badge (UI primitive)
    │     ├── span (HTML)
    │     └── Button (UI primitive)
    │
    └── Business Logic
          ├── formatPrice()
          ├── onAddToCart()
          └── inStock check
```

### Why Composition Matters

```tsx
// WITHOUT composition (bad):
// You'd need ProductCard in your UI library
// with product-specific props

// packages/ui/ProductCard.tsx
function ProductCard({
  imageUrl,
  name,
  category,
  price,
  currency,
  inStock,
  onAddToCart
}) {
  // UI library now knows about "products" 😱
}
```

```tsx
// WITH composition (good):
// UI library stays generic
// App component adds business context

// apps/web/components/ProductCard.tsx
function ProductCard({ product, onAddToCart }) {
  return (
    <Card>
      {/* Compose generic UI with specific data */}
    </Card>
  );
}
```

> **Key insight:** Your UI library should never import your business types. The composition pattern keeps that boundary clean.

---

## 5. Business Logic: Where Does It Live? (8 minutes)

### The Business Logic Checklist

Ask these questions to decide where code belongs:

| Question | If Yes → | If No → |
|----------|----------|---------|
| Does it know about User, Product, Order? | App component | UI component |
| Does it call an API? | App component | UI component |
| Does it have validation rules? | App component | UI component |
| Does it format business data? | App component | UI component |
| Could ANY app use this exact code? | UI component | App component |

### Example: Form Validation

```tsx
// This validation logic belongs in the APP COMPONENT
function validateContactForm(data: ContactFormData) {
  const errors = {};

  if (!data.name.trim()) {
    errors.name = "Name is required";
  }

  if (!data.email.match(/^[^\s@]+@[^\s@]+\.[^\s@]+$/)) {
    errors.email = "Invalid email address";
  }

  if (data.message.length < 10) {
    errors.message = "Message must be at least 10 characters";
  }

  return errors;
}
```

Why? Because:
- These rules are specific to YOUR contact form
- Another app might have different validation rules
- The Input component doesn't care WHY something is invalid—it just displays the error

### Example: Data Formatting

```tsx
// This formatting belongs in the APP COMPONENT
function formatPrice(product: Product) {
  return new Intl.NumberFormat("en-US", {
    style: "currency",
    currency: product.currency,
  }).format(product.price);
}

// Not in the UI component:
// <PriceDisplay price={product.price} currency={product.currency} />
// ↑ This couples UI to your business model
```

### The Data Flow

```
┌─────────────────────────────────────────────────────────────────┐
│                        PAGE / VIEW                               │
│  - Fetches data from API                                        │
│  - Passes business entities to app components                   │
│  - Handles navigation                                           │
├─────────────────────────────────────────────────────────────────┤
│                                    │                             │
│                                    ▼                             │
│                        APP COMPONENT                             │
│  - Receives business entities                                   │
│  - Applies business logic                                       │
│  - Formats data for display                                     │
│  - Composes UI primitives                                       │
├─────────────────────────────────────────────────────────────────┤
│                                    │                             │
│                                    ▼                             │
│                        UI COMPONENTS                             │
│  - Receives generic props                                       │
│  - Handles presentation only                                    │
│  - No business knowledge                                        │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## 6. When to Promote (or Not) (5 minutes)

### The Promotion Question

> "We've used UserCard in three places. Should we move it to the UI library?"

**Usually: No.**

### When to Keep in App Components

Keep a component in `apps/web/components/` when:

- It knows about your domain types (User, Product)
- It contains business logic
- It's only useful for THIS product
- Different apps would need different versions

### When to Promote to UI Library

Move a component to `packages/ui/` when:

- You've **stripped out all business logic**
- The component is **truly generic**
- Multiple apps could use it **as-is**
- It accepts primitive props, not business entities

### The Generalization Process

```tsx
// BEFORE: App component with business logic
function UserCard({ user, onEdit, onDelete }) {
  const canDelete = user.role !== "admin";
  return (
    <Card>
      <Avatar src={user.avatarUrl} />
      <h3>{user.name}</h3>
      <Badge>{user.role}</Badge>
      {canDelete && <Button onClick={() => onDelete(user)}>Delete</Button>}
    </Card>
  );
}

// AFTER: Generic UI component (if you decide to promote)
function EntityCard({
  avatarSrc,
  title,
  subtitle,
  badge,
  actions
}: EntityCardProps) {
  return (
    <Card>
      <Avatar src={avatarSrc} />
      <h3>{title}</h3>
      {badge && <Badge variant={badge.variant}>{badge.label}</Badge>}
      {actions}
    </Card>
  );
}

// App component wraps the generic one
function UserCard({ user, onEdit, onDelete }) {
  const canDelete = user.role !== "admin";
  return (
    <EntityCard
      avatarSrc={user.avatarUrl}
      title={user.name}
      badge={{ variant: "primary", label: user.role }}
      actions={
        canDelete && <Button onClick={() => onDelete(user)}>Delete</Button>
      }
    />
  );
}
```

> **Rule of thumb:** Don't promote prematurely. Keep business logic in app components until you're SURE you need a generic version.

---

## 7. Key Takeaways (4 minutes)

### Summary Visual

```
┌─────────────────────────────────────────────────────────────────┐
│                     THE CLEAN BOUNDARY                          │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│   packages/ui/              apps/web/components/                │
│   ┌───────────┐             ┌───────────────────┐              │
│   │           │             │                   │              │
│   │  Button   │◄────────────│   ProductCard     │              │
│   │  Card     │  composes   │   UserCard        │              │
│   │  Badge    │             │   ContactForm     │              │
│   │  Avatar   │             │   OrderSummary    │              │
│   │           │             │                   │              │
│   │ NO business│            │ HAS business      │              │
│   │ logic     │             │ logic             │              │
│   │           │             │                   │              │
│   │ NO domain │             │ KNOWS domain      │              │
│   │ types     │             │ types             │              │
│   │           │             │                   │              │
│   └───────────┘             └───────────────────┘              │
│                                                                 │
│   Could be used by          Specific to                        │
│   ANY product               THIS product                       │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### Three Things to Remember

1. **App components compose UI primitives with business logic** — They import from `@myapp/ui` and add your domain knowledge (User, Product, Order types and rules).

2. **Business logic stays out of the UI library** — Validation, formatting, API calls, and business rules live in app components, never in `packages/ui/`.

3. **Promote to UI library with caution** — Only move components to the UI package after stripping ALL business logic. Most app components should stay where they are.

### The Architecture Summary

```
┌─────────────────────────────────────────────────────────────────┐
│                    YOUR APPLICATION                              │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  apps/web/app/page.tsx         (Layer 5 - Pages)                │
│        │                                                         │
│        │ renders                                                 │
│        ▼                                                         │
│  apps/web/components/          (Layer 4 - App Components)       │
│  UserCard, ProductCard                                          │
│        │                                                         │
│        │ composes                                                │
│        ▼                                                         │
│  packages/ui/                  (Layers 2-3 - UI Components)     │
│  Button, Card, Avatar                                           │
│        │                                                         │
│        │ consumes                                                │
│        ▼                                                         │
│  packages/tokens/              (Layer 1 - Tokens)               │
│  colors, spacing, typography                                    │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

## Looking Ahead

In the **lab section**, you'll:
- Create business types (User, Product, Order)
- Build UserCard that composes UI primitives
- Build ContactForm with validation logic
- Build ProductCard with business formatting
- Create a demo page showcasing all components
- Compare with Cal.com's app component patterns

In **Chapter 6**, we'll add theming—allowing your entire system (tokens, UI, and app components) to adapt to light/dark mode and custom brand colors.

---

## Discussion Questions for Class

1. You have a `<DataTable>` component. It's used to display Users, Products, and Orders. Should it live in `packages/ui/` or `apps/web/components/`?

2. Your PM says "We need the same UserCard in our mobile app." Does this mean UserCard should be in the UI library?

3. Two teams are building features that both need a "ProductCard." Should they share one component? Where should it live?

4. A junior developer adds an API call inside a Button component to track analytics. What's wrong with this approach?

---

## Common Misconceptions

### "Reusable = UI library"

**Correction:** Reusable within YOUR app doesn't mean reusable across ALL apps. UserCard might be used in 10 places in your app, but it still belongs in app components because it knows about Users.

### "App components are just wrappers"

**Correction:** App components do meaningful work—they format data, apply business rules, handle validation, manage state. They're not just pass-through wrappers.

### "We should avoid business logic in components"

**Correction:** Business logic has to live somewhere. App components are the RIGHT place for business logic that relates to presentation. It's better than scattering it across utility files or putting it in pages.

### "More abstraction is always better"

**Correction:** Sometimes three similar app components are better than one generic component with ten configuration props. Duplication is cheaper than wrong abstraction.

---

## Code Smells in App Components

### Smell 1: UI Component Importing Business Types

```tsx
// packages/ui/Button.tsx
import type { User } from "@myapp/types"; // 🚨 BAD!
```

**Fix:** Business types never enter the UI package.

### Smell 2: App Component Reimplementing UI

```tsx
// apps/web/components/ProductCard.tsx
function ProductCard() {
  return (
    <div className="border rounded-lg p-4 shadow-sm..."> // 🚨 Reimplementing Card
      {/* ... */}
    </div>
  );
}
```

**Fix:** Use the Card component from your UI library.

### Smell 3: Page with Too Much Logic

```tsx
// apps/web/app/users/page.tsx
export default function UsersPage() {
  // 50 lines of user filtering logic
  // 30 lines of permission checking
  // 20 lines of formatting
  return (
    <div>
      {users.map(user => (
        // Inline user card rendering with all logic
      ))}
    </div>
  );
}
```

**Fix:** Extract to UserList and UserCard app components.

---

## Additional Resources

- **Pattern:** Container/Presentational Components (Dan Abramov)
- **Article:** "Composition vs Inheritance" (React Docs)
- **Example:** [Cal.com apps/web/components](https://github.com/calcom/cal.com/tree/main/apps/web/components)
- **Example:** [Supabase Studio components](https://github.com/supabase/supabase/tree/master/apps/studio/components)

---

## Preparation for Lab

Before the lab, ensure you have:
- [ ] Completed Chapters 1-4 (working monorepo)
- [ ] Your UI components from Chapter 3
- [ ] Understanding of TypeScript interfaces
- [ ] Familiarity with React hooks (useState, useCallback)
- [ ] A code editor with TypeScript support
