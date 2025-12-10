# Lab 6.1: Create Theme CSS

## Objective

Create a theme CSS file with primitive and semantic design tokens that support light and dark modes.

## Time Estimate

~25 minutes

## Prerequisites

- Completed Chapter 4 (monorepo setup)
- Completed Chapter 5 (app components)
- Understanding of CSS custom properties

## Setup

### Quick Setup

```bash
./setup.sh
```

This will:
1. Check that Chapter 4 monorepo exists
2. Create the styles directory
3. Create theme.css with primitive and semantic tokens
4. Update package.json to export the CSS

### Manual Setup

Navigate to your UI package:
```bash
cd ../../../04-monorepo-architecture/labs/lab4.1/packages/ui
```

## Exercises

### Exercise 1: Understand CSS Custom Properties for Theming

CSS custom properties (variables) enable theming because:

1. **They cascade** - Child elements inherit values from parents
2. **They can be overridden** - Different contexts can redefine them
3. **JavaScript can modify them** - Dynamic theme switching without rebuild
4. **No build step needed** - Theme changes happen at runtime

```css
/* Base theme */
:root {
  --color-primary: blue;
}

/* Override in dark mode */
.dark {
  --color-primary: lightblue;
}

/* Components just use the variable */
.button {
  background: var(--color-primary);
}
```

### Exercise 2: Understand Primitive vs Semantic Tokens

Open `packages/ui/src/styles/theme.css` and examine the two token types:

**Primitive tokens** = Raw values (never change):
```css
--blue-500: #3B82F6;
--gray-900: #111827;
```

**Semantic tokens** = Meaning-based, reference primitives (change per theme):
```css
/* Light mode */
--color-primary: var(--blue-600);
--color-text: var(--gray-900);

/* Dark mode */
.dark {
  --color-primary: var(--blue-500);
  --color-text: var(--gray-50);
}
```

**Questions:**
1. Why do primitive tokens stay constant across themes?
2. Why do semantic tokens reference primitives instead of raw values?
3. What happens when you change `--blue-500`'s value?

### Exercise 3: Examine the Token Categories

Review the semantic token categories in `theme.css`:

| Category | Purpose | Example |
|----------|---------|---------|
| Backgrounds | Page and element backgrounds | `--color-bg`, `--color-bg-subtle` |
| Text | Text colors at different emphasis | `--color-text`, `--color-text-muted` |
| Borders | Border and divider colors | `--color-border`, `--color-border-emphasis` |
| Primary | Brand/action colors | `--color-primary`, `--color-primary-hover` |
| Status | Success, warning, error states | `--color-success`, `--color-error` |
| Shadows | Elevation shadows | `--shadow-sm`, `--shadow-md` |
| Focus | Accessibility focus indicators | `--ring-color`, `--ring-offset-color` |

### Exercise 4: Verify the Package Export

Check that `packages/ui/package.json` exports the CSS:

```json
{
  "exports": {
    ".": "./src/index.tsx",
    "./styles": "./src/styles/theme.css"
  }
}
```

This allows apps to import the theme:
```tsx
import "@myapp/ui/styles";
```

### Exercise 5: Test Token Values

In browser DevTools, you can inspect custom properties:

1. Open DevTools → Elements → Computed
2. Scroll to CSS Variables section
3. See all `--color-*` values
4. Try manually adding `.dark` class to `<html>` and watch values change

## Key Concepts

### Why Two Token Layers?

```
Primitives (constant)     Semantic (themed)      Component Usage
─────────────────────     ─────────────────      ──────────────
--blue-500: #3B82F6  ──►  --color-primary   ──►  background: var(--color-primary)
--blue-600: #2563EB  ──►  --color-primary-hover
--gray-900: #111827  ──►  --color-text
--gray-50: #F9FAFB   ──►  --color-text (dark)
```

Benefits:
- **Consistency**: All primary colors come from one source
- **Theming**: Swap semantic mappings without changing primitives
- **Maintainability**: Update a primitive, all references update
- **Discoverability**: Semantic names describe purpose

### Dark Mode Strategy

```css
/* Light (default) */
:root {
  --color-bg: var(--white);
  --color-text: var(--gray-900);
}

/* Dark (class-based) */
.dark {
  --color-bg: var(--gray-950);
  --color-text: var(--gray-50);
}
```

The `.dark` class approach (vs `@media (prefers-color-scheme: dark)`):
- Allows user override of system preference
- Can be persisted in localStorage
- More control over when theme applies

## Checklist

Before proceeding to Lab 6.2:

- [ ] theme.css created with primitive tokens
- [ ] theme.css has semantic tokens for light mode
- [ ] theme.css has .dark class with dark mode overrides
- [ ] package.json exports the CSS
- [ ] Understand primitive vs semantic tokens
- [ ] Understand why .dark class is used

## Troubleshooting

### CSS file not created

Run setup.sh from the lab6.1 directory:
```bash
cd chapters/06-theming/labs/lab6.1
./setup.sh
```

### Export not working

Ensure package.json has the exact export path:
```json
"./styles": "./src/styles/theme.css"
```

## Next

Proceed to Lab 6.2 to update components to use the theme tokens.
