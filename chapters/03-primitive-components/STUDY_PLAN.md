# Chapter 3 Study Plan: Primitive Components

## Overview

**Total Time:** ~3.5 hours

| Part | Content | Time |
|------|---------|------|
| Part 1 | Theory | 20 min |
| Part 2 | Labs 3.1-3.6 | 3 hours |
| Part 3 | Reflection | 20 min |
| Part 4 | Extension Exercises | Optional |

---

## Part 1: Theory (20 minutes)

### 1.1 Component Design Principles

A well-designed primitive component follows these principles:

**1. Single Responsibility**
```tsx
// Good: Button just handles being a button
<Button onClick={handleClick}>Submit</Button>

// Bad: Button knows about forms
<Button onFormSubmit={data => api.submit(data)}>Submit</Button>
```

**2. Composable Over Configurable**
```tsx
// Good: Compose what you need
<Card>
  <CardHeader>
    <CardTitle>Settings</CardTitle>
  </CardHeader>
  <CardContent>...</CardContent>
</Card>

// Bad: Too many props
<Card title="Settings" showHeader={true} headerVariant="default" />
```

**3. Accessible by Default**
```tsx
// Accessibility built-in, not optional
<Input
  id={inputId}
  aria-invalid={!!error}
  aria-describedby={error ? `${inputId}-error` : undefined}
/>
```

### 1.2 The CVA Pattern

Class Variance Authority (CVA) manages variant styles cleanly:

```tsx
import { cva } from "class-variance-authority";

const buttonVariants = cva(
  // Base styles (always applied)
  "inline-flex items-center justify-center rounded-md font-medium",
  {
    variants: {
      variant: {
        primary: "bg-blue-600 text-white",
        secondary: "bg-gray-100 text-gray-900",
      },
      size: {
        sm: "h-8 px-3 text-sm",
        md: "h-10 px-4 text-base",
      },
    },
    defaultVariants: {
      variant: "primary",
      size: "md",
    },
  }
);

// Usage: buttonVariants({ variant: "primary", size: "sm" })
// Returns: "inline-flex items-center ... bg-blue-600 text-white h-8 px-3 text-sm"
```

### 1.3 TypeScript for Props

Use proper TypeScript for type-safe components:

```tsx
import { VariantProps } from "class-variance-authority";

interface ButtonProps
  extends React.ButtonHTMLAttributes<HTMLButtonElement>,  // All native button props
    VariantProps<typeof buttonVariants> {                 // Variant props
  loading?: boolean;                                       // Custom props
}
```

---

## Part 2: Labs (3 hours)

### Lab 3.1: UI Package Setup (~30 min)

> **Location:** `labs/lab3.1/`

Set up the UI package with dependencies and utilities.

#### What You'll Do

1. Create package structure:
   ```bash
   mkdir -p packages/ui/src/{components,lib}
   ```

2. Initialize package.json with dependencies:
   - `class-variance-authority` - Variant management
   - `clsx` - Conditional class names
   - `tailwind-merge` - Resolve Tailwind conflicts

3. Create the `cn()` utility function:
   ```typescript
   export function cn(...inputs: ClassValue[]) {
     return twMerge(clsx(inputs));
   }
   ```

4. Create TypeScript configuration

#### Key Concepts

- Why peer dependencies for React
- The purpose of clsx + tailwind-merge
- TypeScript configuration for React components

---

### Lab 3.2: Button Component (~45 min)

> **Location:** `labs/lab3.2/`

Build a fully-featured Button with CVA.

#### What You'll Do

1. Create Button with variants: primary, secondary, destructive, outline, ghost, link
2. Add sizes: sm, md, lg, icon
3. Implement loading state with spinner
4. Add leftIcon and rightIcon support
5. Use forwardRef for DOM access

#### Component Structure

```tsx
const buttonVariants = cva(
  "base-styles",
  {
    variants: {
      variant: { primary: "...", secondary: "..." },
      size: { sm: "...", md: "...", lg: "..." },
    },
    defaultVariants: { variant: "primary", size: "md" },
  }
);

export const Button = React.forwardRef<HTMLButtonElement, ButtonProps>(
  ({ variant, size, loading, children, ...props }, ref) => (
    <button
      ref={ref}
      className={cn(buttonVariants({ variant, size }))}
      disabled={loading}
      {...props}
    >
      {loading ? <Spinner /> : children}
    </button>
  )
);
```

#### Key Concepts

- CVA for variant management
- VariantProps for TypeScript inference
- forwardRef for ref forwarding
- Loading state pattern

---

### Lab 3.3: Input Component (~30 min)

> **Location:** `labs/lab3.3/`

Build an accessible Input with label, error, and hint support.

#### What You'll Do

1. Create Input with label, error, hint props
2. Add left/right addon support
3. Implement proper ARIA attributes:
   - `aria-invalid` when error exists
   - `aria-describedby` linking to error/hint
   - `role="alert"` on error message
4. Use `React.useId()` for unique IDs

#### Accessibility Features

| Feature | Implementation |
|---------|---------------|
| Label association | `htmlFor={inputId}` |
| Error indication | `aria-invalid="true"` |
| Description linking | `aria-describedby` |
| Error announcement | `role="alert"` |

#### Key Concepts

- Form accessibility patterns
- Conditional ARIA attributes
- React.useId() for unique IDs

---

### Lab 3.4: Card Component (~30 min)

> **Location:** `labs/lab3.4/`

Build a composable Card using compound components.

#### What You'll Do

1. Create Card container with padding options
2. Create sub-components:
   - CardHeader
   - CardTitle (with `as` prop for heading level)
   - CardDescription
   - CardContent
   - CardFooter
3. Add hoverable prop for clickable cards

#### Composition Pattern

```tsx
<Card>
  <CardHeader>
    <CardTitle>Title</CardTitle>
    <CardDescription>Description</CardDescription>
  </CardHeader>
  <CardContent>Content here</CardContent>
  <CardFooter>
    <Button>Action</Button>
  </CardFooter>
</Card>
```

#### Key Concepts

- Composition over configuration
- Polymorphic components (`as` prop)
- When to use compound components

---

### Lab 3.5: Badge, Avatar & Exports (~30 min)

> **Location:** `labs/lab3.5/`

Build Badge and Avatar, then create the barrel export.

#### What You'll Do

1. Create Badge with variants: default, primary, success, warning, error, outline
2. Create Avatar with:
   - Size variants (xs, sm, md, lg, xl)
   - Image with error fallback
   - Initials generation from alt text
3. Create `src/index.tsx` barrel export

#### Avatar Fallback Strategy

```tsx
const [imageError, setImageError] = React.useState(false);
const showImage = src && !imageError;

// Generate initials from alt text
const initials = alt.split(" ").map(w => w[0]).slice(0, 2).join("").toUpperCase();
```

#### Key Concepts

- Error boundaries for images
- useMemo for computed values
- Barrel exports for clean API

---

### Lab 3.6: Compare with Real Projects (~20 min)

> **Location:** `labs/lab3.6/`

Study how production design systems build components.

#### What You'll Do

1. Study Cal.com's Button implementation
2. Compare variant approaches
3. Examine accessibility patterns
4. Identify patterns to adopt

#### Comparison Points

| Feature | Your Implementation | Cal.com |
|---------|-------------------|---------|
| Variant system | CVA | ? |
| TypeScript | VariantProps | ? |
| Loading state | Built-in | ? |
| Accessibility | aria-* | ? |

#### Key Concepts

- Learning from production code
- Trade-offs in different approaches
- Patterns worth adopting

---

## Part 3: Reflection (20 minutes)

### Written Reflection

1. **What's the difference between a primitive component and an app component?**
   ```


   ```

2. **Why use CVA instead of just conditional classnames?**
   ```


   ```

3. **What accessibility features did you implement in the Input component?**
   ```


   ```

4. **When would you add a new variant vs creating a new component?**
   ```


   ```

---

## Part 4: Extension Exercises (Optional)

### Exercise 3.1: Add a Textarea Component

Build a Textarea component similar to Input with:
- Label, error, hint support
- Proper accessibility
- Optional character count

### Exercise 3.2: Add Icon Button Variant

Modify Button to better support icon-only buttons:
- Add `aria-label` support for accessibility
- Test with an SVG icon

### Exercise 3.3: Add Avatar Group

Create an AvatarGroup component that:
- Stacks multiple avatars with overlap
- Shows "+N" for overflow
- Has a `max` prop to limit visible avatars

---

## Self-Check

Before moving to Chapter 4, verify:

- [ ] Button has 5+ variants and 3+ sizes
- [ ] Input has label, error, and hint support
- [ ] Input has proper ARIA attributes
- [ ] Card uses composition pattern
- [ ] All components accept `className` for customization
- [ ] TypeScript types are properly defined
- [ ] You've compared with real codebases

---

## Summary

You built the component layer of your design system:
- **Button**: Primary interaction element with variants
- **Input**: Form input with accessibility built-in
- **Card**: Composable container component
- **Badge**: Status/label display
- **Avatar**: User representation with fallback

### What About Design Tokens?

You may have noticed components use hardcoded Tailwind classes (`bg-blue-600`) instead of Chapter 2's CSS variables (`var(--color-primary-500)`). This is intentional - Chapter 3 focuses on component patterns.

The token integration happens in:
- **Chapter 4**: Monorepo wires `@myapp/tokens` + `@myapp/ui` together
- **Chapter 6**: Theming integrates CSS variables with components

See Lab 3.6's "Connecting to Chapter 2" section for a preview of how this works.

---

In Chapter 4, you'll set up a monorepo to share these components across applications.

---

## Files You Should Have

```
packages/ui/
├── src/
│   ├── components/
│   │   ├── Button.tsx
│   │   ├── Input.tsx
│   │   ├── Card.tsx
│   │   ├── Badge.tsx
│   │   └── Avatar.tsx
│   ├── lib/
│   │   └── utils.ts
│   └── index.tsx
├── package.json
└── tsconfig.json
```
