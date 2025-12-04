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

## Part 2: Lab - Set Up Types (15 minutes)

### Lab 5.1: Create Type Definitions

Create `apps/web/types/index.ts`:

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

// Form states
export interface FormState<T> {
  data: T;
  errors: Partial<Record<keyof T, string>>;
  isSubmitting: boolean;
  isValid: boolean;
}
```

---

## Part 3: Lab - Build UserCard Component (30 minutes)

### Lab 5.2: Create UserCard

Create `apps/web/components/UserCard.tsx`:

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
    <Card hoverable>
      <CardContent>
        <div className="flex items-start gap-4">
          {/* Avatar with fallback */}
          <Avatar
            src={user.avatarUrl}
            alt={user.name}
            fallback={user.name.charAt(0)}
            size="lg"
          />

          {/* User info */}
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

        {/* Actions */}
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

### Lab 5.3: Create UserList Component

Create `apps/web/components/UserList.tsx`:

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

---

## Part 4: Lab - Build Form with Validation (45 minutes)

### Lab 5.4: Create ContactForm Component

Create `apps/web/components/ContactForm.tsx`:

```tsx
"use client";

import { useState, useCallback } from "react";
import {
  Button,
  Input,
  Card,
  CardHeader,
  CardTitle,
  CardDescription,
  CardContent,
  CardFooter,
} from "@myapp/ui";

interface ContactFormData {
  name: string;
  email: string;
  subject: string;
  message: string;
}

interface ContactFormProps {
  onSubmit: (data: ContactFormData) => Promise<void>;
  onCancel?: () => void;
}

// Validation rules (business logic)
function validateForm(data: ContactFormData): Partial<Record<keyof ContactFormData, string>> {
  const errors: Partial<Record<keyof ContactFormData, string>> = {};

  if (!data.name.trim()) {
    errors.name = "Name is required";
  } else if (data.name.length < 2) {
    errors.name = "Name must be at least 2 characters";
  }

  if (!data.email.trim()) {
    errors.email = "Email is required";
  } else if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(data.email)) {
    errors.email = "Please enter a valid email address";
  }

  if (!data.subject.trim()) {
    errors.subject = "Subject is required";
  }

  if (!data.message.trim()) {
    errors.message = "Message is required";
  } else if (data.message.length < 10) {
    errors.message = "Message must be at least 10 characters";
  }

  return errors;
}

export function ContactForm({ onSubmit, onCancel }: ContactFormProps) {
  // Form state
  const [formData, setFormData] = useState<ContactFormData>({
    name: "",
    email: "",
    subject: "",
    message: "",
  });
  const [errors, setErrors] = useState<Partial<Record<keyof ContactFormData, string>>>({});
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [submitError, setSubmitError] = useState<string | null>(null);
  const [submitSuccess, setSubmitSuccess] = useState(false);

  // Handle input changes
  const handleChange = useCallback(
    (field: keyof ContactFormData) =>
      (e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement>) => {
        const value = e.target.value;
        setFormData((prev) => ({ ...prev, [field]: value }));
        // Clear error when user starts typing
        if (errors[field]) {
          setErrors((prev) => ({ ...prev, [field]: undefined }));
        }
      },
    [errors]
  );

  // Handle form submission
  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setSubmitError(null);

    // Validate
    const validationErrors = validateForm(formData);
    if (Object.keys(validationErrors).length > 0) {
      setErrors(validationErrors);
      return;
    }

    // Submit
    setIsSubmitting(true);
    try {
      await onSubmit(formData);
      setSubmitSuccess(true);
      // Reset form
      setFormData({ name: "", email: "", subject: "", message: "" });
    } catch (error) {
      setSubmitError(
        error instanceof Error ? error.message : "Something went wrong"
      );
    } finally {
      setIsSubmitting(false);
    }
  };

  // Success state
  if (submitSuccess) {
    return (
      <Card>
        <CardContent className="py-12 text-center">
          <div className="text-4xl mb-4">✓</div>
          <h3 className="text-lg font-semibold text-gray-900 mb-2">
            Message Sent!
          </h3>
          <p className="text-gray-500 mb-4">
            Thank you for reaching out. We'll get back to you soon.
          </p>
          <Button onClick={() => setSubmitSuccess(false)}>
            Send Another Message
          </Button>
        </CardContent>
      </Card>
    );
  }

  return (
    <Card>
      <form onSubmit={handleSubmit}>
        <CardHeader>
          <CardTitle>Contact Us</CardTitle>
          <CardDescription>
            Fill out the form below and we'll get back to you as soon as possible.
          </CardDescription>
        </CardHeader>

        <CardContent className="space-y-4">
          {/* Submit error */}
          {submitError && (
            <div className="p-3 text-sm text-red-600 bg-red-50 rounded-md">
              {submitError}
            </div>
          )}

          {/* Form fields */}
          <div className="grid gap-4 sm:grid-cols-2">
            <Input
              label="Name"
              placeholder="Your name"
              value={formData.name}
              onChange={handleChange("name")}
              error={errors.name}
              disabled={isSubmitting}
            />
            <Input
              label="Email"
              type="email"
              placeholder="you@example.com"
              value={formData.email}
              onChange={handleChange("email")}
              error={errors.email}
              disabled={isSubmitting}
            />
          </div>

          <Input
            label="Subject"
            placeholder="What is this about?"
            value={formData.subject}
            onChange={handleChange("subject")}
            error={errors.subject}
            disabled={isSubmitting}
          />

          <div className="space-y-1">
            <label className="block text-sm font-medium text-gray-700">
              Message
            </label>
            <textarea
              rows={5}
              placeholder="Your message..."
              value={formData.message}
              onChange={handleChange("message")}
              disabled={isSubmitting}
              className={`
                w-full rounded-md border px-3 py-2 text-sm
                placeholder:text-gray-400
                focus:outline-none focus:ring-2 focus:ring-offset-0
                disabled:cursor-not-allowed disabled:opacity-50
                ${
                  errors.message
                    ? "border-red-500 focus:border-red-500 focus:ring-red-500/20"
                    : "border-gray-300 focus:border-blue-500 focus:ring-blue-500/20"
                }
              `}
            />
            {errors.message && (
              <p className="text-sm text-red-600">{errors.message}</p>
            )}
          </div>
        </CardContent>

        <CardFooter className="justify-end">
          {onCancel && (
            <Button
              type="button"
              variant="ghost"
              onClick={onCancel}
              disabled={isSubmitting}
            >
              Cancel
            </Button>
          )}
          <Button type="submit" loading={isSubmitting}>
            Send Message
          </Button>
        </CardFooter>
      </form>
    </Card>
  );
}
```

---

## Part 5: Lab - Build ProductCard (30 minutes)

### Lab 5.5: Create ProductCard Component

Create `apps/web/components/ProductCard.tsx`:

```tsx
import { Card, CardContent, Badge, Button } from "@myapp/ui";
import type { Product } from "@/types";

interface ProductCardProps {
  product: Product;
  onAddToCart?: (product: Product) => void;
  onViewDetails?: (product: Product) => void;
}

export function ProductCard({
  product,
  onAddToCart,
  onViewDetails,
}: ProductCardProps) {
  // Business logic: format price
  const formattedPrice = new Intl.NumberFormat("en-US", {
    style: "currency",
    currency: product.currency,
  }).format(product.price);

  // Business logic: determine stock badge
  const stockBadge = product.inStock
    ? { variant: "success" as const, text: "In Stock" }
    : { variant: "error" as const, text: "Out of Stock" };

  return (
    <Card hoverable padding="none" className="overflow-hidden">
      {/* Product image */}
      <div className="aspect-square bg-gray-100 relative">
        {product.imageUrl ? (
          <img
            src={product.imageUrl}
            alt={product.name}
            className="w-full h-full object-cover"
          />
        ) : (
          <div className="w-full h-full flex items-center justify-center text-gray-400">
            No image
          </div>
        )}
        {/* Category badge */}
        <Badge className="absolute top-2 left-2" variant="default">
          {product.category}
        </Badge>
      </div>

      <CardContent className="p-4">
        {/* Product info */}
        <div className="mb-3">
          <h3 className="font-semibold text-gray-900 truncate">
            {product.name}
          </h3>
          <p className="text-sm text-gray-500 line-clamp-2">
            {product.description}
          </p>
        </div>

        {/* Price and stock */}
        <div className="flex items-center justify-between mb-4">
          <span className="text-lg font-bold text-gray-900">
            {formattedPrice}
          </span>
          <Badge variant={stockBadge.variant}>{stockBadge.text}</Badge>
        </div>

        {/* Actions */}
        <div className="flex gap-2">
          {onViewDetails && (
            <Button
              variant="secondary"
              size="sm"
              className="flex-1"
              onClick={() => onViewDetails(product)}
            >
              Details
            </Button>
          )}
          {onAddToCart && (
            <Button
              variant="primary"
              size="sm"
              className="flex-1"
              disabled={!product.inStock}
              onClick={() => onAddToCart(product)}
            >
              Add to Cart
            </Button>
          )}
        </div>
      </CardContent>
    </Card>
  );
}
```

---

## Part 6: Lab - Create Demo Page (20 minutes)

### Lab 5.6: Update the Demo Page

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
  {
    id: "3",
    name: "Carol Williams",
    email: "carol@example.com",
    role: "member",
    createdAt: new Date("2024-02-10"),
  },
  {
    id: "4",
    name: "David Brown",
    email: "david@example.com",
    role: "guest",
    avatarUrl: "https://i.pravatar.cc/150?u=david",
    createdAt: new Date("2024-03-01"),
  },
];

const products: Product[] = [
  {
    id: "1",
    name: "Wireless Headphones",
    description: "Premium noise-canceling wireless headphones with 30-hour battery life.",
    price: 299.99,
    currency: "USD",
    imageUrl: "https://picsum.photos/400/400?random=1",
    inStock: true,
    category: "Electronics",
  },
  {
    id: "2",
    name: "Leather Notebook",
    description: "Handcrafted leather journal with 200 pages of premium paper.",
    price: 45.00,
    currency: "USD",
    imageUrl: "https://picsum.photos/400/400?random=2",
    inStock: true,
    category: "Office",
  },
  {
    id: "3",
    name: "Smart Watch",
    description: "Fitness tracking smartwatch with heart rate monitor and GPS.",
    price: 399.99,
    currency: "USD",
    imageUrl: "https://picsum.photos/400/400?random=3",
    inStock: false,
    category: "Electronics",
  },
];

export default function Home() {
  return (
    <main className="min-h-screen bg-gray-50">
      <div className="max-w-6xl mx-auto p-8 space-y-12">
        <h1 className="text-3xl font-bold text-gray-900">App Components Demo</h1>

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
              // Simulate API call
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

---

## Part 7: Compare with Real Projects (20 minutes)

### Lab 5.7: Study Cal.com's App Components

```bash
# In cal.com repo
ls apps/web/components/
```

**Pick a component and analyze:**
1. What UI components does it import from `@calcom/ui`?
2. What business logic does it contain?
3. What props does it accept (business entities)?

### Lab 5.8: Notice the Pattern

In Cal.com, notice:
- `apps/web/components/booking/` - Booking-specific components
- `apps/web/components/settings/` - Settings-specific components
- They compose `@calcom/ui` primitives with business logic

---

## Part 8: Reflection (20 minutes)

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

## Part 9: Self-Check

Before moving to Chapter 6, verify:

- [ ] Created UserCard that composes UI primitives
- [ ] Created ContactForm with validation logic
- [ ] Created ProductCard with business formatting
- [ ] Understood separation of UI vs app components
- [ ] Studied Cal.com's app component patterns
- [ ] Demo page works with all components

---

## Files You Should Have

```
apps/web/
├── types/
│   └── index.ts
├── components/
│   ├── UserCard.tsx
│   ├── UserList.tsx
│   ├── ContactForm.tsx
│   └── ProductCard.tsx
└── app/
    └── page.tsx
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
