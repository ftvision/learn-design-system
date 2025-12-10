# Lab 6.2: Update Components to Use Theme Tokens

## Objective

Update existing UI components (Button, Card, Input) to use CSS custom property theme tokens instead of hardcoded colors.

## Time Estimate

~30 minutes

## Prerequisites

- Completed Lab 6.1 (theme CSS created)
- Understanding of class-variance-authority (cva)
- Familiarity with Tailwind CSS arbitrary values

## Setup

### Quick Setup

```bash
./setup.sh
```

This will:
1. Check that Lab 6.1 is complete (theme.css exists)
2. Update Button component to use theme tokens
3. Update Card component to use theme tokens
4. Update Input component to use theme tokens

### Manual Setup

Navigate to your UI package:
```bash
cd ../../../04-monorepo-architecture/labs/lab4.1/packages/ui/src/components
```

## Exercises

### Exercise 1: Understand the Token Syntax

In Tailwind, use CSS custom properties with arbitrary value syntax:

```tsx
// Hardcoded (before)
className="bg-blue-600 text-white"

// Theme tokens (after)
className="bg-[var(--color-primary)] text-[var(--color-primary-text)]"
```

The `[var(--token-name)]` syntax tells Tailwind to use the CSS variable directly.

### Exercise 2: Examine the Updated Button

Open `packages/ui/src/components/Button.tsx` and study the changes:

**Base styles now use tokens:**
```tsx
const buttonVariants = cva(
  [
    // Focus ring uses theme tokens
    "focus-visible:ring-2 focus-visible:ring-[var(--ring-color)]",
    "focus-visible:ring-offset-2 focus-visible:ring-offset-[var(--ring-offset-color)]",
  ],
  {
    variants: {
      variant: {
        primary: [
          "bg-[var(--color-primary)] text-[var(--color-primary-text)]",
          "hover:bg-[var(--color-primary-hover)]",
        ],
        secondary: [
          "bg-[var(--color-bg-muted)] text-[var(--color-text)]",
          "border border-[var(--color-border)]",
        ],
        // ... etc
      },
    },
  }
);
```

**Questions:**
1. What happens to `--color-primary` when `.dark` class is applied to `<html>`?
2. Why use `--ring-offset-color` that matches the background?
3. How does the ghost variant use background tokens?

### Exercise 3: Examine the Updated Card

Open `packages/ui/src/components/Card.tsx`:

```tsx
<div
  className={cn(
    "rounded-lg border",
    "border-[var(--color-border)]",
    "bg-[var(--color-bg)]",
    "shadow-[var(--shadow-sm)]",
    hoverable && "hover:shadow-[var(--shadow-md)]",
    className
  )}
>
```

**Note the pattern:**
- Background: `--color-bg` (main surface)
- Border: `--color-border` (standard borders)
- Shadow: `--shadow-sm` (elevation, themed for dark mode)

### Exercise 4: Examine the Updated Input

Open `packages/ui/src/components/Input.tsx`:

```tsx
className={cn(
  "bg-[var(--color-bg)] text-[var(--color-text)]",
  "border-[var(--color-border)]",
  "placeholder:text-[var(--color-text-subtle)]",
  "focus:ring-[var(--ring-color)] focus:border-[var(--color-primary)]",
  "disabled:bg-[var(--color-bg-muted)]",
  error && "border-[var(--color-error)] focus:ring-[var(--color-error)]",
)}
```

**Key patterns:**
- Placeholder text uses `--color-text-subtle` (lighter than muted)
- Disabled state uses `--color-bg-muted` (slightly darker background)
- Error state uses `--color-error` for both border and focus ring

### Exercise 5: Identify the Token Mapping

Map common Tailwind colors to theme tokens:

| Tailwind Class | Theme Token | Purpose |
|---------------|-------------|---------|
| `bg-white` | `--color-bg` | Main background |
| `bg-gray-50` | `--color-bg-subtle` | Subtle background |
| `bg-gray-100` | `--color-bg-muted` | Muted background |
| `text-gray-900` | `--color-text` | Primary text |
| `text-gray-600` | `--color-text-muted` | Secondary text |
| `text-gray-400` | `--color-text-subtle` | Tertiary text |
| `border-gray-200` | `--color-border` | Standard borders |
| `bg-blue-600` | `--color-primary` | Primary actions |
| `bg-red-500` | `--color-error` | Error states |

## Key Concepts

### Why Update Components?

**Before (hardcoded):**
```tsx
<button className="bg-blue-600 hover:bg-blue-700 text-white">
```
- Works for light mode only
- Dark mode needs separate styles
- Brand color changes require finding all instances

**After (tokens):**
```tsx
<button className="bg-[var(--color-primary)] hover:bg-[var(--color-primary-hover)] text-[var(--color-primary-text)]">
```
- Automatically adapts to light/dark
- Brand changes update the token once
- Consistent across all components

### The Token Reference Chain

```
Component                  Semantic Token         Primitive Token
─────────────────────────  ────────────────────   ──────────────
bg-[var(--color-primary)]  --color-primary: ...   --blue-600
                                      │
                                      ▼
                           Light: var(--blue-600)
                           Dark:  var(--blue-500)
```

### Handling Shadows in Dark Mode

Shadows need adjustment in dark mode because:
- Light mode: Shadows are visible against light backgrounds
- Dark mode: Same shadows can be invisible or too harsh

```css
/* Light mode */
--shadow-sm: 0 1px 2px 0 rgb(0 0 0 / 0.05);

/* Dark mode - more opacity for visibility */
.dark {
  --shadow-sm: 0 1px 2px 0 rgb(0 0 0 / 0.3);
}
```

## Checklist

Before proceeding to Lab 6.3:

- [ ] Button component uses theme tokens
- [ ] Card component uses theme tokens
- [ ] Input component uses theme tokens
- [ ] Understand `[var(--token)]` syntax
- [ ] Understand which tokens map to which purposes
- [ ] Can identify patterns (bg, text, border, shadow)

## Troubleshooting

### Styles not applying

1. Ensure theme.css is imported in your app
2. Check that Tailwind config allows arbitrary values (default: yes)
3. Verify CSS variable names match exactly

### Dark mode not working

1. Add `.dark` class to `<html>` element manually to test
2. Check browser DevTools for CSS variable values
3. Ensure theme.css is loaded before component styles

### TypeScript errors with CVA

Ensure `class-variance-authority` is installed:
```bash
pnpm add class-variance-authority
```

## Next

Proceed to Lab 6.3 to create the useTheme hook and ThemeToggle component.
