# Lab 3.3: Input Component

## Objective

Build an accessible Input component with label, error, hint support, and proper ARIA attributes.

## Time Estimate

~30 minutes

## Prerequisites

- Completed Lab 3.1 (UI package setup)
- Completed Lab 3.2 (Button component)
- Understanding of HTML form accessibility

## Setup

### Quick Setup

```bash
./setup.sh
```

This will:
1. Ensure previous labs are complete
2. Create the Input component file

### Manual Setup

Navigate to your UI package:
```bash
cd ../lab3.1/packages/ui
```

## Exercises

### Exercise 1: Create the Input Component

Create `src/components/Input.tsx`:

```tsx
import * as React from "react";
import { cn } from "../lib/utils";

export interface InputProps
  extends React.InputHTMLAttributes<HTMLInputElement> {
  /** Label text displayed above the input */
  label?: string;
  /** Error message - displays in red and sets aria-invalid */
  error?: string;
  /** Hint text displayed below the input (hidden when error is present) */
  hint?: string;
  /** Left addon (icon or text) inside the input */
  leftAddon?: React.ReactNode;
  /** Right addon (icon or text) inside the input */
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

### Exercise 2: Understand Accessibility Features

The Input component includes several accessibility features:

| Feature | Implementation | Purpose |
|---------|---------------|---------|
| Label association | `htmlFor={inputId}` | Clicking label focuses input |
| Unique IDs | `React.useId()` | Ensures IDs are unique across the page |
| Error indication | `aria-invalid="true"` | Announces invalid state to screen readers |
| Description linking | `aria-describedby` | Links error/hint to input |
| Error announcement | `role="alert"` | Announces error immediately |

**Questions:**
1. Why do we use `React.useId()` instead of a static ID?
2. What happens to the `aria-describedby` when there's an error vs a hint?
3. Why does the error have `role="alert"`?

### Exercise 3: Test the Input API

All these should work:

```tsx
// Basic usage
<Input placeholder="Enter text" />
<Input label="Email" type="email" />

// With validation
<Input label="Password" type="password" error="Password is required" />
<Input label="Username" hint="Must be at least 3 characters" />

// With addons
<Input leftAddon={<SearchIcon />} placeholder="Search..." />
<Input rightAddon={<EyeIcon />} type="password" />

// States
<Input disabled value="Disabled input" />

// Form integration
<Input name="email" required />
```

### Exercise 4: Trace the Accessibility Flow

Given this usage:
```tsx
<Input
  label="Email"
  error="Please enter a valid email"
/>
```

Trace what HTML is rendered:

1. What is the `for` attribute on the label?
2. What is the `id` on the input?
3. What is the `aria-invalid` value?
4. What is the `aria-describedby` value?
5. What is the `id` on the error message?

**Answer format:**
```
label for="___"
input id="___" aria-invalid="___" aria-describedby="___"
p id="___" role="alert"
```

### Exercise 5: Add Required Indicator (Your Turn!)

Modify the label to show a red asterisk when the input is required:

```tsx
{label && (
  <label htmlFor={inputId} className={cn(...)}>
    {label}
    {/* Add required indicator here */}
  </label>
)}
```

**Hint:** Check if `props.required` is truthy.

**Suggested solution:**
```tsx
{label && (
  <label htmlFor={inputId} className={cn(...)}>
    {label}
    {props.required && (
      <span className="text-red-500 ml-1" aria-hidden="true">*</span>
    )}
  </label>
)}
```

## Key Concepts

### Why No CVA for Input?

Unlike Button, Input doesn't need CVA because:
- It doesn't have multiple variants (primary, secondary, etc.)
- The styling is more conditional (error state, addons)
- The complexity is in structure, not variants

### Form Library Compatibility

The Input is compatible with form libraries:

```tsx
// React Hook Form
<Input {...register("email")} error={errors.email?.message} />

// Formik
<Input {...field} error={meta.touched && meta.error} />
```

### The useId() Hook

`React.useId()` generates stable, unique IDs:
- Unique across the entire page
- Stable across re-renders
- Works with server-side rendering

```tsx
const id = React.useId();  // e.g., ":r0:"
```

## Checklist

Before proceeding to Lab 3.4:

- [ ] Input component created with all features
- [ ] TypeScript compiles without errors
- [ ] Understand all ARIA attributes and their purposes
- [ ] Can trace the accessibility flow for a given usage
- [ ] Added required indicator (exercise)

## Reflection Questions

1. Why is `hint` hidden when there's an `error`?
2. How would you add support for a `success` state?
3. What's the difference between `aria-describedby` and `aria-labelledby`?

## Next

Proceed to Lab 3.4 to build the Card component.
