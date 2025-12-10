# Lab 3.4: Card Component

## Objective

Build a composable Card component using the compound component pattern with Card, CardHeader, CardTitle, CardDescription, CardContent, and CardFooter.

## Time Estimate

~30 minutes

## Prerequisites

- Completed Labs 3.1-3.3
- Understanding of React composition patterns

## Setup

### Quick Setup

```bash
./setup.sh
```

This will:
1. Ensure previous labs are complete
2. Create the Card component file with all sub-components

### Manual Setup

Navigate to your UI package:
```bash
cd ../lab3.1/packages/ui
```

## Exercises

### Exercise 1: Understand the Composition Pattern

Before building, understand why composition is better than configuration:

**Configuration approach (avoid):**
```tsx
// Too many props, inflexible
<Card
  title="Settings"
  description="Manage your preferences"
  showHeader={true}
  headerVariant="default"
  footerContent={<Button>Save</Button>}
  footerAlignment="right"
/>
```

**Composition approach (preferred):**
```tsx
// Flexible, readable structure
<Card>
  <CardHeader>
    <CardTitle>Settings</CardTitle>
    <CardDescription>Manage your preferences</CardDescription>
  </CardHeader>
  <CardContent>
    {/* Form fields */}
  </CardContent>
  <CardFooter>
    <Button>Save</Button>
  </CardFooter>
</Card>
```

### Exercise 2: Create the Card Component

Create `src/components/Card.tsx`:

```tsx
import * as React from "react";
import { cn } from "../lib/utils";

// Main Card component
interface CardProps extends React.HTMLAttributes<HTMLDivElement> {
  /** Card padding preset */
  padding?: "none" | "sm" | "md" | "lg";
  /** Adds hover effect */
  hoverable?: boolean;
}

const paddingClasses = {
  none: "",
  sm: "p-3",
  md: "p-4",
  lg: "p-6",
};

export function Card({
  className,
  padding = "md",
  hoverable = false,
  children,
  ...props
}: CardProps) {
  return (
    <div
      className={cn(
        "rounded-lg border border-gray-200 bg-white shadow-sm",
        paddingClasses[padding],
        hoverable && "transition-shadow hover:shadow-md cursor-pointer",
        className
      )}
      {...props}
    >
      {children}
    </div>
  );
}

// Card Header
interface CardHeaderProps extends React.HTMLAttributes<HTMLDivElement> {}

export function CardHeader({ className, ...props }: CardHeaderProps) {
  return (
    <div
      className={cn("flex flex-col space-y-1.5", className)}
      {...props}
    />
  );
}

// Card Title
interface CardTitleProps extends React.HTMLAttributes<HTMLHeadingElement> {
  /** Heading level for semantic HTML */
  as?: "h1" | "h2" | "h3" | "h4" | "h5" | "h6";
}

export function CardTitle({
  className,
  as: Component = "h3",
  ...props
}: CardTitleProps) {
  return (
    <Component
      className={cn("text-lg font-semibold text-gray-900", className)}
      {...props}
    />
  );
}

// Card Description
interface CardDescriptionProps extends React.HTMLAttributes<HTMLParagraphElement> {}

export function CardDescription({ className, ...props }: CardDescriptionProps) {
  return (
    <p
      className={cn("text-sm text-gray-500", className)}
      {...props}
    />
  );
}

// Card Content
interface CardContentProps extends React.HTMLAttributes<HTMLDivElement> {}

export function CardContent({ className, ...props }: CardContentProps) {
  return <div className={cn("", className)} {...props} />;
}

// Card Footer
interface CardFooterProps extends React.HTMLAttributes<HTMLDivElement> {}

export function CardFooter({ className, ...props }: CardFooterProps) {
  return (
    <div
      className={cn("flex items-center gap-2 pt-4", className)}
      {...props}
    />
  );
}
```

### Exercise 3: Test Composition Patterns

All these usage patterns should work:

```tsx
// Full card with all sections
<Card>
  <CardHeader>
    <CardTitle>Account Settings</CardTitle>
    <CardDescription>Manage your account preferences</CardDescription>
  </CardHeader>
  <CardContent>
    <Input label="Display Name" />
    <Input label="Email" type="email" />
  </CardContent>
  <CardFooter>
    <Button variant="secondary">Cancel</Button>
    <Button>Save Changes</Button>
  </CardFooter>
</Card>

// Simple card (no sub-components needed)
<Card>
  <p>Simple card content</p>
</Card>

// Header and content only
<Card>
  <CardHeader>
    <CardTitle>Quick Stats</CardTitle>
  </CardHeader>
  <CardContent>
    <p>Some statistics here</p>
  </CardContent>
</Card>

// Hoverable card for lists
<Card hoverable onClick={() => navigate('/item/1')}>
  <CardTitle>Click me</CardTitle>
</Card>

// Custom padding
<Card padding="lg">
  <CardTitle>Spacious Card</CardTitle>
</Card>
```

### Exercise 4: Understand the as Prop

The `CardTitle` accepts an `as` prop for semantic HTML:

```tsx
// Default: h3
<CardTitle>Settings</CardTitle>
// Renders: <h3 class="...">Settings</h3>

// Override for proper heading hierarchy
<CardTitle as="h2">Main Section</CardTitle>
// Renders: <h2 class="...">Main Section</h2>
```

**Why is this important?**
- Screen readers use heading levels to navigate
- `h1` → `h2` → `h3` should follow a logical order
- Visual appearance stays the same, semantics change

### Exercise 5: Add CardImage Sub-component (Your Turn!)

Add a `CardImage` sub-component that:
- Renders at the top of the card
- Has rounded top corners when used as the first child
- Accepts `src` and `alt` props

**Starter code:**
```tsx
interface CardImageProps extends React.ImgHTMLAttributes<HTMLImageElement> {
  src: string;
  alt: string;
}

export function CardImage({ className, ...props }: CardImageProps) {
  return (
    <img
      className={cn(
        // Add your classes here
        className
      )}
      {...props}
    />
  );
}
```

**Suggested solution:**
```tsx
export function CardImage({ className, ...props }: CardImageProps) {
  return (
    <img
      className={cn(
        "w-full object-cover rounded-t-lg -m-4 mb-4 w-[calc(100%+2rem)]",
        className
      )}
      {...props}
    />
  );
}
```

## Key Concepts

### Why Composition Over Configuration?

| Configuration | Composition |
|--------------|-------------|
| Limited flexibility | Unlimited flexibility |
| Props grow over time | Structure is explicit |
| Hard to customize | Easy to customize |
| Implicit structure | Visible structure |

### No Context Needed

Unlike some compound components (like Tabs), Card doesn't need React Context because:
- Sub-components don't need to communicate
- No shared state
- Just visual structure

### Each Sub-component is Optional

Users include only what they need:
```tsx
// Just content
<Card>Content</Card>

// Title + Content
<Card>
  <CardTitle>Title</CardTitle>
  <CardContent>Content</CardContent>
</Card>

// Full structure
<Card>
  <CardHeader>
    <CardTitle>Title</CardTitle>
    <CardDescription>Desc</CardDescription>
  </CardHeader>
  <CardContent>Content</CardContent>
  <CardFooter>Footer</CardFooter>
</Card>
```

## Checklist

Before proceeding to Lab 3.5:

- [ ] Card and all sub-components created
- [ ] TypeScript compiles without errors
- [ ] Understand composition vs configuration
- [ ] Understand the `as` prop for CardTitle
- [ ] Can create different card layouts by composition
- [ ] Added CardImage sub-component (exercise)

## Reflection Questions

1. When would you use `padding="none"` on a Card?
2. Why is CardContent's className just `""`?
3. How would you add a "variant" to Card (e.g., outlined, elevated)?

## Next

Proceed to Lab 3.5 to build Badge and Avatar components.
