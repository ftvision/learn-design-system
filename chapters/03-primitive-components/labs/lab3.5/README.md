# Lab 3.5: Badge, Avatar & Exports

## Objective

Build Badge and Avatar components, then create the barrel export file to expose all components from the UI package.

## Time Estimate

~30 minutes

## Prerequisites

- Completed Labs 3.1-3.4
- Understanding of CVA pattern (from Button)

## Setup

### Quick Setup

```bash
./setup.sh
```

This will:
1. Ensure previous labs are complete
2. Create Badge and Avatar components
3. Create the index.tsx barrel export

### Manual Setup

Navigate to your UI package:
```bash
cd ../lab3.1/packages/ui
```

## Exercises

### Exercise 1: Create the Badge Component

Create `src/components/Badge.tsx`:

```tsx
import * as React from "react";
import { cva, type VariantProps } from "class-variance-authority";
import { cn } from "../lib/utils";

const badgeVariants = cva(
  "inline-flex items-center rounded-full px-2.5 py-0.5 text-xs font-medium transition-colors",
  {
    variants: {
      variant: {
        default: "bg-gray-100 text-gray-800",
        primary: "bg-blue-100 text-blue-800",
        success: "bg-green-100 text-green-800",
        warning: "bg-yellow-100 text-yellow-800",
        error: "bg-red-100 text-red-800",
        outline: "border border-gray-300 text-gray-700 bg-transparent",
      },
    },
    defaultVariants: {
      variant: "default",
    },
  }
);

export interface BadgeProps
  extends React.HTMLAttributes<HTMLSpanElement>,
    VariantProps<typeof badgeVariants> {}

export function Badge({ className, variant, ...props }: BadgeProps) {
  return (
    <span className={cn(badgeVariants({ variant }), className)} {...props} />
  );
}
```

**Usage examples:**
```tsx
<Badge>Default</Badge>
<Badge variant="success">Active</Badge>
<Badge variant="error">Failed</Badge>
<Badge variant="warning">Pending</Badge>
<Badge variant="outline">Draft</Badge>
```

### Exercise 2: Create the Avatar Component

Create `src/components/Avatar.tsx`:

```tsx
import * as React from "react";
import { cva, type VariantProps } from "class-variance-authority";
import { cn } from "../lib/utils";

const avatarVariants = cva(
  "relative inline-flex shrink-0 overflow-hidden rounded-full bg-gray-100",
  {
    variants: {
      size: {
        xs: "h-6 w-6 text-xs",
        sm: "h-8 w-8 text-sm",
        md: "h-10 w-10 text-base",
        lg: "h-12 w-12 text-lg",
        xl: "h-16 w-16 text-xl",
      },
    },
    defaultVariants: {
      size: "md",
    },
  }
);

export interface AvatarProps
  extends React.HTMLAttributes<HTMLDivElement>,
    VariantProps<typeof avatarVariants> {
  /** Image URL for the avatar */
  src?: string;
  /** Alt text for the image */
  alt?: string;
  /** Fallback text (usually initials) shown when no image */
  fallback?: string;
}

export function Avatar({
  className,
  size,
  src,
  alt = "",
  fallback,
  ...props
}: AvatarProps) {
  const [imageError, setImageError] = React.useState(false);
  const showImage = src && !imageError;

  // Generate initials from alt text if no fallback provided
  const initials = React.useMemo(() => {
    if (fallback) return fallback;
    if (!alt) return "";
    return alt
      .split(" ")
      .map((word) => word[0])
      .slice(0, 2)
      .join("")
      .toUpperCase();
  }, [alt, fallback]);

  return (
    <div
      className={cn(avatarVariants({ size }), className)}
      {...props}
    >
      {showImage ? (
        <img
          src={src}
          alt={alt}
          className="h-full w-full object-cover"
          onError={() => setImageError(true)}
        />
      ) : (
        <span className="flex h-full w-full items-center justify-center font-medium text-gray-600">
          {initials}
        </span>
      )}
    </div>
  );
}
```

**Usage examples:**
```tsx
// With image
<Avatar src="/path/to/image.jpg" alt="John Doe" />

// Fallback to initials
<Avatar alt="John Doe" />  // Shows "JD"

// Custom fallback
<Avatar fallback="?" />

// Different sizes
<Avatar size="xs" alt="User" />
<Avatar size="xl" alt="User" src="/avatar.jpg" />
```

### Exercise 3: Understand the Avatar's Error Handling

The Avatar handles broken images gracefully:

```tsx
const [imageError, setImageError] = React.useState(false);
const showImage = src && !imageError;

// On the img element:
onError={() => setImageError(true)}
```

**Flow:**
1. If `src` is provided, try to load the image
2. If image fails to load, `onError` fires
3. `imageError` becomes `true`
4. `showImage` becomes `false`
5. Fallback initials are displayed

### Exercise 4: Create the Barrel Export

Create `src/index.tsx`:

```tsx
// Components
export { Button, buttonVariants, type ButtonProps } from "./components/Button";
export { Input, type InputProps } from "./components/Input";
export {
  Card,
  CardHeader,
  CardTitle,
  CardDescription,
  CardContent,
  CardFooter,
} from "./components/Card";
export { Badge, type BadgeProps } from "./components/Badge";
export { Avatar, type AvatarProps } from "./components/Avatar";

// Utilities
export { cn } from "./lib/utils";
```

**Why a barrel export?**
- Single import point: `import { Button, Input } from "@myapp/ui"`
- Controls public API (only exported items are accessible)
- Enables tree-shaking for bundlers

### Exercise 5: Verify Exports

After creating the index file, verify TypeScript is happy:

```bash
cd packages/ui
npm run typecheck
```

You should see no errors.

### Exercise 6: Add a Size Variant to Badge (Your Turn!)

Currently Badge has no size variants. Add `size` variants:

**Requirements:**
- `sm`: smaller padding and font
- `md`: current size (default)
- `lg`: larger padding and font

**Starter code:**
```tsx
const badgeVariants = cva(
  "inline-flex items-center rounded-full font-medium transition-colors",
  {
    variants: {
      variant: { /* existing */ },
      size: {
        sm: "______",
        md: "______",
        lg: "______",
      },
    },
    defaultVariants: {
      variant: "default",
      size: "md",
    },
  }
);
```

**Suggested solution:**
```tsx
size: {
  sm: "px-2 py-0.5 text-xs",
  md: "px-2.5 py-0.5 text-xs",
  lg: "px-3 py-1 text-sm",
},
```

## Key Concepts

### Badge vs Button

| Badge | Button |
|-------|--------|
| Display-only | Interactive |
| `<span>` | `<button>` |
| No click handlers | Has click handlers |
| Shows status | Triggers actions |

### Avatar Fallback Strategy

1. Show image if `src` is valid
2. If image fails, show `fallback` text
3. If no `fallback`, generate initials from `alt`
4. If no `alt`, show empty initials

### Barrel Exports Best Practices

- Export types alongside components (`type ButtonProps`)
- Export utilities that consumers might need (`cn`)
- Don't export internal helpers
- Consider named exports for tree-shaking

## Final File Structure

After completing all labs, your UI package should have:

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

## Checklist

Before proceeding to Lab 3.6:

- [ ] Badge component created with variants
- [ ] Avatar component created with size variants and fallback
- [ ] index.tsx barrel export created
- [ ] `npm run typecheck` passes
- [ ] Added size variants to Badge (exercise)

## Reflection Questions

1. Why does Avatar use `useMemo` for initials?
2. When would you use Badge vs a colored Button?
3. What would happen if you exported a component but not its props type?

## Next

Proceed to Lab 3.6 to compare your components with real-world projects.
