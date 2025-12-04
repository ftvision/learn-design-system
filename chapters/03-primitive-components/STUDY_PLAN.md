# Chapter 3 Study Plan: Primitive Components

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

## Part 2: Lab - Set Up the UI Package (30 minutes)

### Lab 3.1: Create Package Structure

```bash
cd design-system-course
mkdir -p packages/ui/src/{components,lib}
cd packages/ui
```

### Lab 3.2: Initialize the Package

Create `package.json`:

```json
{
  "name": "@myapp/ui",
  "version": "0.0.1",
  "main": "./src/index.tsx",
  "module": "./src/index.tsx",
  "types": "./src/index.tsx",
  "exports": {
    ".": "./src/index.tsx",
    "./button": "./src/components/Button.tsx",
    "./input": "./src/components/Input.tsx",
    "./card": "./src/components/Card.tsx"
  },
  "peerDependencies": {
    "react": "^18.0.0",
    "react-dom": "^18.0.0"
  },
  "dependencies": {
    "class-variance-authority": "^0.7.0",
    "clsx": "^2.0.0",
    "tailwind-merge": "^2.0.0"
  },
  "devDependencies": {
    "@types/react": "^18.0.0",
    "@types/react-dom": "^18.0.0",
    "typescript": "^5.0.0"
  }
}
```

Install dependencies:
```bash
npm install
```

### Lab 3.3: Create Utility Function

Create `src/lib/utils.ts`:

```typescript
import { clsx, type ClassValue } from "clsx";
import { twMerge } from "tailwind-merge";

/**
 * Merges class names with Tailwind CSS conflict resolution.
 *
 * @example
 * cn("px-4 py-2", "px-6") // Returns "py-2 px-6" (px-6 wins)
 * cn("text-red-500", isError && "text-blue-500") // Conditional classes
 */
export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs));
}
```

**Why this utility?**
- `clsx`: Handles conditional classes (`isActive && "active"`)
- `tailwind-merge`: Resolves conflicts (`"px-4 px-6"` → `"px-6"`)

### Lab 3.4: Create TypeScript Config

Create `tsconfig.json`:

```json
{
  "compilerOptions": {
    "target": "ES2020",
    "lib": ["ES2020", "DOM", "DOM.Iterable"],
    "module": "ESNext",
    "moduleResolution": "bundler",
    "jsx": "react-jsx",
    "strict": true,
    "declaration": true,
    "declarationMap": true,
    "sourceMap": true,
    "skipLibCheck": true,
    "esModuleInterop": true,
    "allowSyntheticDefaultImports": true,
    "forceConsistentCasingInFileNames": true,
    "resolveJsonModule": true,
    "isolatedModules": true,
    "noEmit": true
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules"]
}
```

---

## Part 3: Lab - Build the Button Component (45 minutes)

### Lab 3.5: Create Button Component

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
  /**
   * Shows a loading spinner and disables the button
   */
  loading?: boolean;
  /**
   * Icon to show before the button text
   */
  leftIcon?: React.ReactNode;
  /**
   * Icon to show after the button text
   */
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

### Lab 3.6: Test the Button API

Create a mental model of the Button API:

```tsx
// All these should work:
<Button>Default</Button>
<Button variant="primary">Primary</Button>
<Button variant="secondary" size="lg">Large Secondary</Button>
<Button variant="destructive" loading>Deleting...</Button>
<Button variant="outline" disabled>Disabled</Button>
<Button variant="ghost" leftIcon={<Icon />}>With Icon</Button>
<Button size="icon"><Icon /></Button>
<Button className="w-full">Full Width</Button>
<Button onClick={() => console.log("clicked")}>Click Handler</Button>
```

**Exercise:** What's the default variant and size? Trace through the code to find out.

---

## Part 4: Lab - Build the Input Component (30 minutes)

### Lab 3.7: Create Input Component

Create `src/components/Input.tsx`:

```tsx
import * as React from "react";
import { cn } from "../lib/utils";

export interface InputProps
  extends React.InputHTMLAttributes<HTMLInputElement> {
  /**
   * Label text displayed above the input
   */
  label?: string;
  /**
   * Error message - displays in red and sets aria-invalid
   */
  error?: string;
  /**
   * Hint text displayed below the input (hidden when error is present)
   */
  hint?: string;
  /**
   * Left addon (icon or text) inside the input
   */
  leftAddon?: React.ReactNode;
  /**
   * Right addon (icon or text) inside the input
   */
  rightAddon?: React.ReactNode;
}

/**
 * Input component with label, error, and hint support.
 *
 * @example
 * <Input label="Email" type="email" placeholder="you@example.com" />
 * <Input label="Password" type="password" error="Password is required" />
 */
export const Input = React.forwardRef<HTMLInputElement, InputProps>(
  (
    {
      className,
      type = "text",
      label,
      error,
      hint,
      leftAddon,
      rightAddon,
      id,
      disabled,
      ...props
    },
    ref
  ) => {
    // Generate a unique ID if not provided
    const inputId = id || React.useId();
    const errorId = `${inputId}-error`;
    const hintId = `${inputId}-hint`;

    return (
      <div className="w-full">
        {/* Label */}
        {label && (
          <label
            htmlFor={inputId}
            className={cn(
              "block text-sm font-medium mb-1.5",
              disabled ? "text-gray-400" : "text-gray-700"
            )}
          >
            {label}
          </label>
        )}

        {/* Input container */}
        <div className="relative">
          {/* Left addon */}
          {leftAddon && (
            <div className="absolute left-3 top-1/2 -translate-y-1/2 text-gray-400">
              {leftAddon}
            </div>
          )}

          {/* Input element */}
          <input
            ref={ref}
            id={inputId}
            type={type}
            disabled={disabled}
            className={cn(
              // Base styles
              "flex h-10 w-full rounded-md border bg-white px-3 py-2 text-sm",
              "transition-colors duration-200",
              // Placeholder
              "placeholder:text-gray-400",
              // Focus styles
              "focus:outline-none focus:ring-2 focus:ring-offset-0",
              // Disabled styles
              "disabled:cursor-not-allowed disabled:bg-gray-50 disabled:opacity-50",
              // Error vs normal styles
              error
                ? "border-red-500 focus:border-red-500 focus:ring-red-500/20"
                : "border-gray-300 focus:border-blue-500 focus:ring-blue-500/20",
              // Addon padding
              leftAddon && "pl-10",
              rightAddon && "pr-10",
              className
            )}
            aria-invalid={error ? "true" : undefined}
            aria-describedby={
              error ? errorId : hint ? hintId : undefined
            }
            {...props}
          />

          {/* Right addon */}
          {rightAddon && (
            <div className="absolute right-3 top-1/2 -translate-y-1/2 text-gray-400">
              {rightAddon}
            </div>
          )}
        </div>

        {/* Error message */}
        {error && (
          <p id={errorId} className="mt-1.5 text-sm text-red-600" role="alert">
            {error}
          </p>
        )}

        {/* Hint text (only shown when no error) */}
        {hint && !error && (
          <p id={hintId} className="mt-1.5 text-sm text-gray-500">
            {hint}
          </p>
        )}
      </div>
    );
  }
);

Input.displayName = "Input";
```

### Lab 3.8: Accessibility Check

The Input component includes several accessibility features:

| Feature | Implementation |
|---------|---------------|
| Label association | `htmlFor` matches input `id` |
| Error announcement | `aria-invalid="true"` when error exists |
| Description linking | `aria-describedby` points to error or hint |
| Error role | `role="alert"` on error message |
| Unique IDs | `React.useId()` generates unique IDs |

**Exercise:** Open the React DevTools and verify these ARIA attributes are set correctly.

---

## Part 5: Lab - Build the Card Component (30 minutes)

### Lab 3.9: Create Card Component

Create `src/components/Card.tsx`:

```tsx
import * as React from "react";
import { cn } from "../lib/utils";

// Main Card component
interface CardProps extends React.HTMLAttributes<HTMLDivElement> {
  /**
   * Card padding preset
   */
  padding?: "none" | "sm" | "md" | "lg";
  /**
   * Adds hover effect
   */
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

### Lab 3.10: Composition Pattern

The Card component uses the **composition pattern**:

```tsx
// Users compose the card as needed
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

// Or simpler usage
<Card>
  <p>Simple card content</p>
</Card>

// Or just header and content
<Card>
  <CardHeader>
    <CardTitle>Quick Stats</CardTitle>
  </CardHeader>
  <CardContent>
    <p>Some statistics here</p>
  </CardContent>
</Card>
```

**Why composition?**
- Flexible: Users include only what they need
- Clear: Structure is visible in JSX
- Maintainable: Each sub-component has one job

---

## Part 6: Lab - Build Badge and Avatar (30 minutes)

### Lab 3.11: Create Badge Component

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

### Lab 3.12: Create Avatar Component

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
  /**
   * Image URL for the avatar
   */
  src?: string;
  /**
   * Alt text for the image
   */
  alt?: string;
  /**
   * Fallback text (usually initials) shown when no image
   */
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

---

## Part 7: Create the Barrel Export (10 minutes)

### Lab 3.13: Create Index File

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

---

## Part 8: Compare with Real Projects (20 minutes)

### Lab 3.14: Study Cal.com's Button

```bash
# In the cal.com repo
cat packages/ui/components/button/Button.tsx
```

**Questions:**
1. How do they define variants?
2. What additional features do they include?
3. How do they handle the loading state?

### Lab 3.15: Study Supabase's Components

```bash
# In the supabase repo
ls packages/ui/src/components/
cat packages/ui/src/components/Button/Button.tsx
```

**Compare:**
- Props interface
- Variant definitions
- Accessibility features

---

## Part 9: Reflection (20 minutes)

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

## Part 10: Self-Check

Before moving to Chapter 4, verify:

- [ ] Button has 5+ variants and 3+ sizes
- [ ] Input has label, error, and hint support
- [ ] Input has proper ARIA attributes
- [ ] Card uses composition pattern
- [ ] All components accept `className` for customization
- [ ] TypeScript types are properly defined
- [ ] You've compared with real codebases

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

---

## Extension Exercises

### Exercise 3.1: Add a Textarea Component

Build a Textarea component similar to Input with:
- Label, error, hint support
- Proper accessibility
- Optional character count

### Exercise 3.2: Add Icon Button Variant

Modify Button to better support icon-only buttons:
- Add `icon` size variant
- Add `aria-label` support for accessibility
- Test with an SVG icon

### Exercise 3.3: Add Avatar Group

Create an AvatarGroup component that:
- Stacks multiple avatars with overlap
- Shows "+N" for overflow
- Has a `max` prop to limit visible avatars
