# Lab 3.1: UI Package Setup

## Objective

Create the UI package structure with all necessary dependencies and utilities for building primitive components.

## Time Estimate

~30 minutes

## Prerequisites

- Completed Chapter 2 (tokens package)
- Node.js 18+ installed
- Understanding of TypeScript basics

## Setup

### Quick Setup

```bash
./setup.sh
```

This will:
1. Create the UI package structure
2. Initialize package.json with dependencies
3. Install all dependencies
4. Create the utility function and TypeScript config

### Manual Setup

```bash
# From the lab directory (labs/lab3.1/)
mkdir -p packages/ui/src/{components,lib}
cd packages/ui
```

## Exercises

### Exercise 1: Create Package Structure

After setup, verify the directory structure (from the lab directory):

```bash
ls -la packages/ui/
ls -la packages/ui/src/
```

**Expected structure:**
```
packages/ui/
├── src/
│   ├── components/   # React components go here
│   └── lib/          # Utility functions
├── package.json
├── tsconfig.json
└── node_modules/
```

### Exercise 2: Understand package.json

Examine `packages/ui/package.json`:

```json
{
  "name": "@myapp/ui",
  "version": "0.0.1",
  "main": "./src/index.tsx",
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
  }
}
```

**Questions to answer:**
1. Why are React and React-DOM in `peerDependencies` instead of `dependencies`?
2. What does the `exports` field allow?
3. What are the three main dependencies for?

### Exercise 3: Create the cn() Utility

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
- `clsx`: Handles conditional classes (`isActive && "active"`, `{ active: isActive }`)
- `tailwind-merge`: Resolves Tailwind conflicts (`"px-4 px-6"` → `"px-6"`)

**Test it mentally:**
```typescript
cn("px-4 py-2", "px-6")           // → "py-2 px-6"
cn("text-red-500", false)         // → "text-red-500"
cn("text-red-500", "text-blue-500") // → "text-blue-500"
cn("p-4", { "m-2": true, "m-4": false }) // → "p-4 m-2"
```

### Exercise 4: Create TypeScript Config

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

**Key settings:**
- `jsx: "react-jsx"`: Uses React 17+ JSX transform (no need to import React)
- `strict: true`: Enables all strict type checking
- `declaration: true`: Generates `.d.ts` type files
- `noEmit: true`: We'll use a bundler, not tsc, for output

### Exercise 5: Verify Installation

Run TypeScript to check for errors (from `packages/ui/`):

```bash
npx tsc --noEmit
```

If successful, you should see no output (no errors).

## Key Concepts

### Why These Dependencies?

| Dependency | Purpose |
|------------|---------|
| `class-variance-authority` | Define component variants (primary, secondary, sizes) |
| `clsx` | Conditionally join class names |
| `tailwind-merge` | Resolve Tailwind CSS conflicts |

### The CVA Pattern Preview

You'll use CVA extensively in the next labs:

```tsx
import { cva } from "class-variance-authority";

const buttonVariants = cva(
  "base-classes-always-applied",
  {
    variants: {
      variant: {
        primary: "bg-blue-600 text-white",
        secondary: "bg-gray-100 text-gray-900",
      },
      size: {
        sm: "h-8 px-3",
        md: "h-10 px-4",
      },
    },
    defaultVariants: {
      variant: "primary",
      size: "md",
    },
  }
);

// Usage
buttonVariants({ variant: "primary", size: "sm" })
// → "base-classes-always-applied bg-blue-600 text-white h-8 px-3"
```

### Component Design Principles

Keep these in mind as you build components:

1. **Single Responsibility** - Each component does one thing well
2. **Composable Over Configurable** - Prefer composition over prop explosion
3. **Accessible by Default** - Include ARIA attributes, keyboard support
4. **Customizable** - Always accept `className` for overrides

## Checklist

Before proceeding to Lab 3.2:

- [ ] `packages/ui` directory structure exists
- [ ] `package.json` has all dependencies installed
- [ ] `src/lib/utils.ts` contains the `cn()` function
- [ ] `tsconfig.json` is configured
- [ ] `npx tsc --noEmit` runs without errors
- [ ] You understand what CVA, clsx, and tailwind-merge do

## Troubleshooting

### npm install fails

Ensure you're in the correct directory:
```bash
pwd  # Should end with packages/ui
npm install
```

### TypeScript errors

If you see errors about missing React types:
```bash
npm install -D @types/react @types/react-dom
```

### Module not found errors

Ensure `moduleResolution` is set to `"bundler"` in tsconfig.json.

## Next

Proceed to Lab 3.2 to build the Button component.
