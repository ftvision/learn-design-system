# Lab 5.5: Demo Page & Compare

## Objective

Create a demo page showcasing all app components and compare patterns with real-world projects.

## Time Estimate

~30 minutes

## Prerequisites

- Completed Labs 5.1-5.4
- Chapter 1 completed (Cal.com reference available)

## Setup

### Quick Setup

```bash
./setup.sh
```

This will:
1. Ensure all previous labs are complete
2. Update the demo page with all components
3. Create symlinks to reference projects

## Exercises

### Exercise 1: Create the Demo Page

Update `apps/web/app/page.tsx`:

```tsx
import { UserList } from "@/components/UserList";
import { ContactForm } from "@/components/ContactForm";
import { ProductCard } from "@/components/ProductCard";
import type { User, Product } from "@/types";

// Mock data
const users: User[] = [
  {
    id: "1",
    name: "Alice Johnson",
    email: "alice@example.com",
    role: "admin",
    avatarUrl: "https://i.pravatar.cc/150?u=alice",
    createdAt: new Date("2023-01-15"),
  },
  {
    id: "2",
    name: "Bob Smith",
    email: "bob@example.com",
    role: "member",
    avatarUrl: "https://i.pravatar.cc/150?u=bob",
    createdAt: new Date("2023-06-20"),
  },
  // ... more users
];

const products: Product[] = [
  {
    id: "1",
    name: "Wireless Headphones",
    description: "Premium noise-canceling wireless headphones.",
    price: 299.99,
    currency: "USD",
    imageUrl: "https://picsum.photos/400/400?random=1",
    inStock: true,
    category: "Electronics",
  },
  // ... more products
];

export default function Home() {
  return (
    <main className="min-h-screen bg-gray-50">
      <div className="max-w-6xl mx-auto p-8 space-y-12">
        <h1 className="text-3xl font-bold text-gray-900">
          App Components Demo
        </h1>

        {/* User List Section */}
        <section>
          <h2 className="text-2xl font-semibold mb-4">Team Members</h2>
          <UserList
            users={users}
            onEditUser={(user) => console.log("Edit:", user)}
            onDeleteUser={(user) => console.log("Delete:", user)}
          />
        </section>

        {/* Products Section */}
        <section>
          <h2 className="text-2xl font-semibold mb-4">Featured Products</h2>
          <div className="grid gap-6 sm:grid-cols-2 lg:grid-cols-3">
            {products.map((product) => (
              <ProductCard
                key={product.id}
                product={product}
                onAddToCart={(p) => console.log("Add to cart:", p)}
                onViewDetails={(p) => console.log("View details:", p)}
              />
            ))}
          </div>
        </section>

        {/* Contact Form Section */}
        <section className="max-w-xl">
          <h2 className="text-2xl font-semibold mb-4">Get in Touch</h2>
          <ContactForm
            onSubmit={async (data) => {
              await new Promise((resolve) => setTimeout(resolve, 1500));
              console.log("Form submitted:", data);
            }}
          />
        </section>
      </div>
    </main>
  );
}
```

### Exercise 2: Run the Demo

```bash
cd ../../../04-monorepo-architecture/labs/lab4.1
pnpm dev
```

Open http://localhost:3000 and verify:
- [ ] UserList displays with search and filters
- [ ] ProductCard shows price formatting and stock status
- [ ] ContactForm validates and shows success state

### Exercise 3: Study Cal.com's App Components

```bash
# In cal.com repo
ls apps/web/components/
```

**Pick a component and analyze:**

1. **What UI components does it import?**
   ```bash
   grep -n "from \"@calcom/ui\"" apps/web/components/booking/AvailableTimes.tsx
   ```

2. **What business logic does it contain?**
   - Date/time calculations?
   - User permission checks?
   - API calls?

3. **What business types does it use?**
   ```bash
   grep -n "type\|interface" apps/web/components/booking/AvailableTimes.tsx | head -10
   ```

### Exercise 4: Compare Patterns

**Cal.com's component organization:**
```
apps/web/components/
├── booking/          # Booking-specific components
│   ├── AvailableTimes.tsx
│   ├── BookingForm.tsx
│   └── ...
├── settings/         # Settings-specific components
├── dialog/           # Modal/dialog components
└── ...
```

**Your organization:**
```
apps/web/components/
├── UserCard.tsx
├── UserList.tsx
├── ContactForm.tsx
└── ProductCard.tsx
```

**Questions:**
1. How would you organize if you had 50+ components?
2. What grouping strategy makes sense for your app?

### Exercise 5: Written Reflection

Answer these questions:

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

## Key Takeaways

### The Component Spectrum

```
Generic (UI Package)              Specific (App Components)
◄─────────────────────────────────────────────────────────►

Button          Avatar          UserCard          UserProfilePage
   │               │                │                    │
No business    Still generic    Knows about         Full page with
logic          but displays     User type,          routing, data
               user data        has edit/delete     fetching, etc.
```

### Decision Framework

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

### Common Patterns

1. **Entity-based components**: `UserCard`, `ProductCard`, `OrderCard`
2. **List components**: `UserList`, `ProductGrid`
3. **Form components**: `ContactForm`, `CheckoutForm`
4. **Feature components**: `BookingCalendar`, `PaymentFlow`

### When to Promote to UI Package

Consider promoting when:
- Multiple apps need the same component
- Component has become generic enough
- Business logic has been abstracted out

Example evolution:
```
UserCard (app) → EntityCard (app) → Card + composable parts (UI)
```

## Self-Check: Chapter 5 Complete

Verify you have:

- [ ] Type definitions in apps/web/types/
- [ ] UserCard component with business logic
- [ ] UserList component with filtering
- [ ] ContactForm with validation
- [ ] ProductCard with price formatting
- [ ] Demo page showing all components
- [ ] Studied Cal.com's app component patterns
- [ ] Completed reflection questions

## Files You Should Have

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
- Uses UI Modal component (you'd need to create one)
- Has form validation
- Submits to an API

### Exercise 5.3: Create OrderCard

Build an OrderCard component that:
- Displays order status with appropriate badge colors
- Shows order items list
- Has actions based on status (cancel, track, reorder)

## Next Chapter

In Chapter 6, you'll add theming support to enable light/dark modes and custom brand colors.
