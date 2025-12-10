# Lab 3.2: Button Component

## Objective

Build a fully-featured Button component using CVA (Class Variance Authority) with multiple variants, sizes, and states.

## Time Estimate

~45 minutes

## Prerequisites

- Completed Lab 3.1 (UI package setup)
- Understanding of React functional components
- Basic TypeScript knowledge

## Setup

### Quick Setup

```bash
./setup.sh
```

This will:
1. Ensure Lab 3.1 is complete
2. Create the Button component file with starter code

### Manual Setup

Navigate to your UI package from Lab 3.1:
```bash
cd ../lab3.1/packages/ui
```

## Exercises

### Exercise 1: Understand the CVA Pattern

Before building, understand how CVA works:

```tsx
import { cva } from "class-variance-authority";

const buttonVariants = cva(
  // Base styles (always applied)
  "inline-flex items-center justify-center rounded-md font-medium",
  {
    variants: {
      // Each variant has named options
      variant: {
        primary: "bg-blue-600 text-white",
        secondary: "bg-gray-100 text-gray-900",
      },
      size: {
        sm: "h-8 px-3 text-sm",
        md: "h-10 px-4 text-base",
      },
    },
    // Defaults when variant/size not specified
    defaultVariants: {
      variant: "primary",
      size: "md",
    },
  }
);

// Usage
buttonVariants({ variant: "primary", size: "sm" })
// → "inline-flex items-center justify-center rounded-md font-medium bg-blue-600 text-white h-8 px-3 text-sm"
```

### Exercise 2: Create the Button Component

Create `src/components/Button.tsx`:

```tsx
import * as React from "react";
import { cva, type VariantProps } from "class-variance-authority";
import { cn } from "../lib/utils";

// Define all button variants
const buttonVariants = cva(
  // Base styles
  [
    "inline-flex items-center justify-center gap-2",
    "rounded-md font-medium",
    "transition-colors duration-200",
    "focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-offset-2",
    "disabled:pointer-events-none disabled:opacity-50",
  ],
  {
    variants: {
      variant: {
        primary: [
          "bg-blue-600 text-white",
          "hover:bg-blue-700",
          "focus-visible:ring-blue-500",
        ],
        secondary: [
          "bg-gray-100 text-gray-900",
          "hover:bg-gray-200",
          "focus-visible:ring-gray-500",
        ],
        destructive: [
          "bg-red-600 text-white",
          "hover:bg-red-700",
          "focus-visible:ring-red-500",
        ],
        outline: [
          "border border-gray-300 bg-transparent text-gray-700",
          "hover:bg-gray-50",
          "focus-visible:ring-gray-500",
        ],
        ghost: [
          "bg-transparent text-gray-700",
          "hover:bg-gray-100",
          "focus-visible:ring-gray-500",
        ],
        link: [
          "bg-transparent text-blue-600 underline-offset-4",
          "hover:underline",
          "focus-visible:ring-blue-500",
        ],
      },
      size: {
        sm: "h-8 px-3 text-sm",
        md: "h-10 px-4 text-sm",
        lg: "h-12 px-6 text-base",
        icon: "h-10 w-10",
      },
    },
    defaultVariants: {
      variant: "primary",
      size: "md",
    },
  }
);

// Spinner component for loading state
function Spinner({ className }: { className?: string }) {
  return (
    <svg
      className={cn("animate-spin", className)}
      xmlns="http://www.w3.org/2000/svg"
      fill="none"
      viewBox="0 0 24 24"
      aria-hidden="true"
    >
      <circle
        className="opacity-25"
        cx="12"
        cy="12"
        r="10"
        stroke="currentColor"
        strokeWidth="4"
      />
      <path
        className="opacity-75"
        fill="currentColor"
        d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z"
      />
    </svg>
  );
}

// Button props type
export interface ButtonProps
  extends React.ButtonHTMLAttributes<HTMLButtonElement>,
    VariantProps<typeof buttonVariants> {
  /** Shows a loading spinner and disables the button */
  loading?: boolean;
  /** Icon to show before the button text */
  leftIcon?: React.ReactNode;
  /** Icon to show after the button text */
  rightIcon?: React.ReactNode;
}

/**
 * Button component with multiple variants and sizes.
 *
 * @example
 * <Button variant="primary" size="md">Click me</Button>
 * <Button variant="destructive" loading>Deleting...</Button>
 */
export const Button = React.forwardRef<HTMLButtonElement, ButtonProps>(
  (
    {
      className,
      variant,
      size,
      loading = false,
      disabled,
      leftIcon,
      rightIcon,
      children,
      ...props
    },
    ref
  ) => {
    return (
      <button
        ref={ref}
        className={cn(buttonVariants({ variant, size }), className)}
        disabled={disabled || loading}
        {...props}
      >
        {loading ? (
          <Spinner className="h-4 w-4" />
        ) : leftIcon ? (
          <span className="shrink-0">{leftIcon}</span>
        ) : null}
        {children}
        {rightIcon && !loading ? (
          <span className="shrink-0">{rightIcon}</span>
        ) : null}
      </button>
    );
  }
);

Button.displayName = "Button";

// Export variants for use in other components or tests
export { buttonVariants };
```

### Exercise 3: Understand the Props Interface

Examine the ButtonProps interface:

```tsx
export interface ButtonProps
  extends React.ButtonHTMLAttributes<HTMLButtonElement>,  // All native props
    VariantProps<typeof buttonVariants> {                 // variant, size
  loading?: boolean;
  leftIcon?: React.ReactNode;
  rightIcon?: React.ReactNode;
}
```

**Questions:**
1. What native button props are automatically included?
2. What does `VariantProps<typeof buttonVariants>` provide?
3. Why use `React.forwardRef`?

### Exercise 4: Test the Button API

All these should work with proper TypeScript support:

```tsx
// Basic usage
<Button>Default</Button>
<Button variant="primary">Primary</Button>
<Button variant="secondary" size="lg">Large Secondary</Button>

// States
<Button variant="destructive" loading>Deleting...</Button>
<Button variant="outline" disabled>Disabled</Button>

// With icons
<Button variant="ghost" leftIcon={<SearchIcon />}>Search</Button>
<Button size="icon"><MenuIcon /></Button>

// Customization
<Button className="w-full">Full Width</Button>

// Native props work
<Button onClick={() => console.log("clicked")}>Click Handler</Button>
<Button type="submit">Submit Form</Button>
```

### Exercise 5: Add a New Variant (Your Turn!)

Add a `warning` variant to the buttonVariants:

**Requirements:**
- Background: yellow/amber tones
- Text: dark (for contrast)
- Hover: slightly darker
- Focus ring: yellow/amber

**Write your answer:**
```tsx
warning: [
  "______",
  "______",
  "______",
],
```

**Suggested solution:**
```tsx
warning: [
  "bg-amber-500 text-amber-950",
  "hover:bg-amber-600",
  "focus-visible:ring-amber-500",
],
```

## Key Concepts

### Why forwardRef?

`React.forwardRef` allows parent components to get a ref to the underlying DOM element:

```tsx
function Form() {
  const buttonRef = useRef<HTMLButtonElement>(null);

  useEffect(() => {
    // Can focus the button programmatically
    buttonRef.current?.focus();
  }, []);

  return <Button ref={buttonRef}>Submit</Button>;
}
```

### Why Export buttonVariants?

Exporting the variants allows:
1. Reuse in other components (e.g., ButtonLink)
2. Testing variant combinations
3. Accessing variant keys for documentation

```tsx
// In another component
import { buttonVariants } from "./Button";

function ButtonLink({ href, variant, size, children }) {
  return (
    <a href={href} className={buttonVariants({ variant, size })}>
      {children}
    </a>
  );
}
```

### Accessibility Features

The Button includes:
- `focus-visible:ring-*`: Focus indicator for keyboard users
- `disabled:opacity-50`: Visual feedback for disabled state
- `disabled:pointer-events-none`: Prevents interaction when disabled
- `aria-hidden="true"` on spinner: Hidden from screen readers

## Checklist

Before proceeding to Lab 3.3:

- [ ] Button component created with all variants
- [ ] TypeScript compiles without errors
- [ ] Understand how CVA defines variants
- [ ] Understand how VariantProps provides type safety
- [ ] Can explain why forwardRef is used
- [ ] Added the warning variant (exercise)

## Reflection Questions

1. Why use arrays for class names instead of a single string?
2. What happens if you pass both `disabled` and `loading={true}`?
3. How would you add a new size variant?

## Next

Proceed to Lab 3.3 to build the Input component.
