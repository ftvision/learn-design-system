# Lecture Notes: Primitive Components (Part 1 - Theory)

**Duration:** 30-45 minutes
**Chapter:** 03 - Primitive Components

---

## Lecture Outline

1. Opening Question
2. What Makes a Component "Primitive"?
3. The Three Design Principles
4. The Variant Pattern and CVA
5. Composition Over Configuration
6. Accessibility as a First-Class Concern
7. Key Takeaways

---

## 1. Opening Question (3 minutes)

> **Ask the class:** "You need a button in your app. Do you write `<button className="...">` every time, or do you create a `<Button>` component? Why?"

**Expected answers:** Reusability, consistency, less repetition, easier to maintain...

**Instructor note:** This question surfaces the intuition behind componentization. The follow-up question is: "How do you design that Button component so it works for *every* use case in your application?"

**Follow-up:** "Have you ever created a Button component that eventually grew so many props it became harder to use than just writing raw HTML?"

---

## 2. What Makes a Component "Primitive"? (7 minutes)

### The Definition

> **Definition:** A primitive component is a **generic, reusable UI building block** with no business logic, designed to work in any context.

Think of primitives as the **atoms** in your design system—the smallest useful units that combine to form everything else.

### Primitive vs. Non-Primitive

| Primitive | NOT Primitive |
|-----------|---------------|
| `<Button>` | `<SubmitOrderButton>` |
| `<Input>` | `<EmailInput>` (with validation) |
| `<Card>` | `<ProductCard>` |
| `<Avatar>` | `<UserProfileAvatar>` |
| `<Modal>` | `<ConfirmDeleteModal>` |

> **Ask:** "What's the difference between `<Button>` and `<SubmitOrderButton>`?"

**Answer:** `<Button>` knows nothing about orders. `<SubmitOrderButton>` knows your business domain, probably calls an API, maybe has specific text. The primitive is generic; the app component is specific.

### The Four Characteristics

| Characteristic | What It Means |
|---------------|---------------|
| **Generic** | No business logic, no domain knowledge |
| **Configurable** | Variants, sizes, states via props |
| **Accessible** | Keyboard navigation, ARIA attributes built-in |
| **Composable** | Can be combined to build complex UIs |

### Visual: The Component Hierarchy

```
┌─────────────────────────────────────────────────────┐
│  Pages/Views (Layer 5)                              │
│    └─ /checkout, /dashboard                         │
├─────────────────────────────────────────────────────┤
│  App Components (Layer 4)                           │
│    └─ <ProductCard>, <CheckoutForm>                 │
├─────────────────────────────────────────────────────┤
│  Pattern Components (Layer 3)                       │
│    └─ <AuthForm>, <DataTable>, <SearchBar>          │
├─────────────────────────────────────────────────────┤
│  Primitive Components (Layer 2)  ← YOU ARE HERE     │
│    └─ <Button>, <Input>, <Card>, <Badge>, <Avatar>  │
├─────────────────────────────────────────────────────┤
│  Design Tokens (Layer 1)                            │
│    └─ colors, spacing, typography                   │
└─────────────────────────────────────────────────────┘
```

Primitives sit at Layer 2—they consume tokens and are consumed by everything above.

---

## 3. The Three Design Principles (8 minutes)

### Principle 1: Single Responsibility

A primitive component does **one thing well**.

```tsx
// GOOD: Button just handles being a button
<Button onClick={handleClick}>Submit</Button>

// BAD: Button knows about forms, APIs, data
<Button onFormSubmit={data => api.submitOrder(data)}>Submit Order</Button>
```

The Button doesn't know:
- What happens when clicked (that's the parent's job)
- What text to display (that's passed as children)
- What API to call (that's business logic)

It only knows:
- How to look like a button
- How to handle click/keyboard events
- How to show loading/disabled states

### Principle 2: Props Should Be Intuitive

Good component APIs are **discoverable** and **predictable**.

```tsx
// GOOD: Clear, standard props
<Button
  variant="primary"    // Visual style
  size="md"            // Size preset
  disabled             // Standard HTML attribute
  loading              // Loading state
>
  Save
</Button>

// BAD: Confusing, non-standard props
<Button
  buttonType={3}       // What does 3 mean?
  isLarge={false}      // Negative boolean
  notClickable         // Double negative
  spinnerVisible       // Implementation detail
>
  Save
</Button>
```

> **Rule of thumb:** If you need to look at the source code to understand a prop, the API needs work.

### Principle 3: Extend, Don't Restrict

Components should accept standard HTML attributes.

```tsx
// Component definition
interface ButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: "primary" | "secondary";
  size?: "sm" | "md" | "lg";
}

// Usage: ALL button attributes work
<Button
  variant="primary"
  onClick={() => {}}      // Standard attribute
  type="submit"           // Standard attribute
  aria-label="Submit"     // Standard attribute
  data-testid="submit"    // Standard attribute
>
  Submit
</Button>
```

By extending `ButtonHTMLAttributes`, your component automatically supports everything a native button does.

---

## 4. The Variant Pattern and CVA (10 minutes)

### The Problem with Multiple Components

What if you need different button styles?

```tsx
// BAD: Creating multiple components
<PrimaryButton>Save</PrimaryButton>
<SecondaryButton>Cancel</SecondaryButton>
<DangerButton>Delete</DangerButton>
<SmallPrimaryButton>Save</SmallPrimaryButton>
<LargeDangerButton>Delete</LargeDangerButton>
// ... this explodes combinatorially
```

This approach leads to **component explosion**—you end up with dozens of components that are 95% identical.

### The Variant Solution

One component, configurable via props:

```tsx
// GOOD: One component, many variants
<Button variant="primary" size="md">Save</Button>
<Button variant="secondary" size="md">Cancel</Button>
<Button variant="destructive" size="sm">Delete</Button>
<Button variant="outline" size="lg">Learn More</Button>
```

### Enter CVA (Class Variance Authority)

CVA is a utility that manages variant styles cleanly:

```tsx
import { cva } from "class-variance-authority";

const buttonVariants = cva(
  // Base styles (always applied)
  "inline-flex items-center justify-center rounded-md font-medium",
  {
    variants: {
      variant: {
        primary: "bg-blue-600 text-white hover:bg-blue-700",
        secondary: "bg-gray-100 text-gray-900 hover:bg-gray-200",
        destructive: "bg-red-600 text-white hover:bg-red-700",
      },
      size: {
        sm: "h-8 px-3 text-sm",
        md: "h-10 px-4 text-base",
        lg: "h-12 px-6 text-lg",
      },
    },
    defaultVariants: {
      variant: "primary",
      size: "md",
    },
  }
);
```

### How CVA Works

```tsx
// Call the function with variant options
buttonVariants({ variant: "primary", size: "sm" })

// Returns combined class string:
// "inline-flex items-center justify-center rounded-md font-medium
//  bg-blue-600 text-white hover:bg-blue-700
//  h-8 px-3 text-sm"
```

### CVA in a Component

```tsx
interface ButtonProps
  extends React.ButtonHTMLAttributes<HTMLButtonElement>,
    VariantProps<typeof buttonVariants> {
  loading?: boolean;
}

export function Button({ variant, size, className, ...props }: ButtonProps) {
  return (
    <button
      className={cn(buttonVariants({ variant, size }), className)}
      {...props}
    />
  );
}
```

### The `cn` Utility

The `cn` function combines `clsx` and `tailwind-merge`:

```tsx
import { clsx } from "clsx";
import { twMerge } from "tailwind-merge";

export function cn(...inputs) {
  return twMerge(clsx(inputs));
}

// Example:
cn(
  "px-4 py-2",           // Base
  isActive && "bg-blue", // Conditional
  "px-6"                 // Override
)
// Returns: "py-2 px-6 bg-blue" (px-6 wins over px-4)
```

---

## 5. Composition Over Configuration (7 minutes)

### The Anti-Pattern: Prop Explosion

When you try to configure everything via props:

```tsx
// BAD: Too many props
<Card
  title="Settings"
  subtitle="Manage your account"
  showHeader={true}
  showFooter={true}
  headerVariant="default"
  footerActions={[
    { label: "Cancel", variant: "secondary" },
    { label: "Save", variant: "primary" }
  ]}
  padding="large"
  hoverable
>
  Content here
</Card>
```

**Problems:**
- Hard to remember all props
- Inflexible—what if you need a custom header?
- Complex TypeScript types
- Testing nightmare

### The Solution: Composition Pattern

Break the card into composable pieces:

```tsx
// GOOD: Compose what you need
<Card>
  <CardHeader>
    <CardTitle>Settings</CardTitle>
    <CardDescription>Manage your account</CardDescription>
  </CardHeader>
  <CardContent>
    {/* Any content */}
  </CardContent>
  <CardFooter>
    <Button variant="secondary">Cancel</Button>
    <Button>Save</Button>
  </CardFooter>
</Card>
```

### Why Composition Wins

| Aspect | Configuration (Props) | Composition |
|--------|----------------------|-------------|
| Flexibility | Limited by props | Unlimited |
| Discoverability | Read docs/types | Visible in JSX |
| Custom content | Need escape hatches | Natural |
| Testing | Mock complex prop objects | Test each piece |

### Composition in Practice

Different use cases, same components:

```tsx
// Simple card
<Card>
  <p>Just some content</p>
</Card>

// Card with just header
<Card>
  <CardHeader>
    <CardTitle>Quick Stats</CardTitle>
  </CardHeader>
  <CardContent>
    <StatsGrid />
  </CardContent>
</Card>

// Full featured card
<Card hoverable>
  <CardHeader>
    <CardTitle>Project Alpha</CardTitle>
    <CardDescription>Last updated 2 days ago</CardDescription>
  </CardHeader>
  <CardContent>
    <ProgressBar value={75} />
  </CardContent>
  <CardFooter>
    <Badge variant="success">Active</Badge>
    <Button size="sm">View Details</Button>
  </CardFooter>
</Card>
```

---

## 6. Accessibility as a First-Class Concern (7 minutes)

### Why Accessibility in Primitives?

If your primitives are accessible, **everything built on them is accessible**. If they're not, you're retrofitting accessibility throughout your entire codebase.

> **Key insight:** Accessibility is an investment that compounds. Fix it once at the primitive level, and you never think about it again.

### The Input Component: An Accessibility Case Study

```tsx
<Input
  label="Email Address"
  error="Please enter a valid email"
  hint="We'll never share your email"
/>
```

What accessibility features should this have?

### Accessibility Checklist for Input

| Feature | Implementation | Why |
|---------|---------------|-----|
| Label association | `<label htmlFor={id}>` | Screen readers announce the label |
| Error state | `aria-invalid="true"` | Screen readers announce invalid state |
| Description linking | `aria-describedby` | Connects input to error/hint text |
| Error announcement | `role="alert"` | Screen readers announce errors immediately |
| Unique IDs | `React.useId()` | Prevents ID collisions |

### Implementation

```tsx
export function Input({ label, error, hint, id, ...props }) {
  const inputId = id || React.useId();
  const errorId = `${inputId}-error`;
  const hintId = `${inputId}-hint`;

  return (
    <div>
      {/* Label properly associated */}
      <label htmlFor={inputId}>{label}</label>

      {/* Input with ARIA attributes */}
      <input
        id={inputId}
        aria-invalid={error ? "true" : undefined}
        aria-describedby={
          error ? errorId : hint ? hintId : undefined
        }
        {...props}
      />

      {/* Error with role="alert" */}
      {error && (
        <p id={errorId} role="alert">{error}</p>
      )}

      {/* Hint text linked via aria-describedby */}
      {hint && !error && (
        <p id={hintId}>{hint}</p>
      )}
    </div>
  );
}
```

### Focus States: The Keyboard User's Lifeline

```css
/* BAD: Removing focus outline */
button:focus {
  outline: none;  /* Never do this! */
}

/* GOOD: Custom focus ring */
button:focus-visible {
  outline: none;
  ring: 2px;
  ring-offset: 2px;
  ring-color: blue-500;
}
```

`focus-visible` shows focus ring for keyboard navigation but not mouse clicks—best of both worlds.

---

## 7. Key Takeaways (3 minutes)

### Summary Visual

```
Primitive Component Design:

   ┌──────────────────────────────────────┐
   │     Single Responsibility            │
   │     (Do one thing well)              │
   ├──────────────────────────────────────┤
   │     Variant Pattern + CVA            │
   │     (One component, many styles)     │
   ├──────────────────────────────────────┤
   │     Composition > Configuration      │
   │     (Compose pieces, don't add props)│
   ├──────────────────────────────────────┤
   │     Accessibility by Default         │
   │     (ARIA attributes built-in)       │
   └──────────────────────────────────────┘
```

### Three Things to Remember

1. **Primitives are generic building blocks** — they have no business logic and work in any context. `<Button>` doesn't know about your checkout flow.

2. **Use variants instead of multiple components** — CVA lets you define `variant`, `size`, and other options cleanly. One `<Button>` with variants beats ten `<PrimaryButton>`, `<SecondaryButton>`, etc.

3. **Accessibility is built into primitives, not bolted on** — proper labels, ARIA attributes, and keyboard navigation belong in the component definition, not as an afterthought.

### The Building Block Metaphor

```
Your Application:
                                    ┌───────────┐
                                    │  Pages    │
                                    └─────┬─────┘
                                          │ uses
                                    ┌─────▼─────┐
                                    │   App     │
                                    │Components │
                                    └─────┬─────┘
                                          │ uses
                              ┌───────────▼───────────┐
                              │    Primitives         │ ← Chapter 3
                              │  Button, Input, Card  │
                              └───────────┬───────────┘
                                          │ consumes
                              ┌───────────▼───────────┐
                              │    Design Tokens      │ ← Chapter 2
                              └───────────────────────┘
```

If your primitives are solid, everything built on top benefits.

---

## Looking Ahead

In the **lab section**, you'll:
- Set up a `packages/ui` folder with TypeScript and CVA
- Build a Button with 6 variants and 4 sizes
- Build an Input with labels, errors, hints, and full accessibility
- Build a Card using the composition pattern
- Build Badge and Avatar components
- Compare your implementations with Cal.com and Supabase

In **Chapter 4**, we'll connect everything with monorepo architecture—so your app can `import { Button } from "@myapp/ui"`.

---

## Discussion Questions for Class

1. You're building a form. Should the Submit button know about form validation, or should the parent component handle that? Why?

2. Your designer asks for a "ghost" button variant. Do you add a new variant to your existing Button, or create a new GhostButton component? What's your decision criteria?

3. A developer on your team writes a Card component with 15 props. How would you refactor it to use composition?

4. How would you test that your Input component is accessible? What would you check?

---

## Common Misconceptions

### "Primitives should handle every edge case"

**Correction:** Primitives handle common patterns well. For truly unique cases, users can pass custom `className` or build specialized components on top.

### "More variants are always better"

**Correction:** Only add variants for patterns that repeat. If you need a one-off style, use `className`. If you're adding a variant for a single use case, you're over-engineering.

### "Composition means no props at all"

**Correction:** Simple, essential props are fine (`variant`, `size`, `disabled`). Composition replaces *complex configuration*, not all props.

### "Accessibility can be added later"

**Correction:** Retrofitting accessibility is expensive and error-prone. Building it into primitives from day one is dramatically cheaper.

---

## Additional Resources

- **Library:** [CVA (class-variance-authority)](https://cva.style/)
- **Library:** [Radix UI Primitives](https://www.radix-ui.com/primitives)
- **Guide:** [W3C WAI-ARIA Authoring Practices](https://www.w3.org/WAI/ARIA/apg/)
- **Article:** "Compound Components" by Kent C. Dodds
- **Tool:** [axe DevTools](https://www.deque.com/axe/devtools/) for accessibility testing

---

## Preparation for Lab

Before the lab, ensure you have:
- [ ] Completed Chapters 1-2 (understanding of layers and tokens)
- [ ] Node.js v18+ installed
- [ ] React and TypeScript familiarity
- [ ] A code editor with TypeScript support
- [ ] Optional: React DevTools browser extension
