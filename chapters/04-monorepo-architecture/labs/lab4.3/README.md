# Lab 4.3: Wire Packages

## Objective

Configure the tokens and UI packages with workspace dependencies and connect them to the shared configurations.

## Time Estimate

~30 minutes

## Prerequisites

- Completed Lab 4.1 (monorepo structure)
- Completed Lab 4.2 (shared configurations)
- Chapter 2 tokens knowledge (Style Dictionary)
- Chapter 3 UI components knowledge (CVA, React)

## Setup

### Quick Setup

```bash
./setup.sh
```

This will:
1. Ensure Labs 4.1 and 4.2 are complete
2. Configure tokens package with Style Dictionary
3. Configure UI package with workspace dependencies
4. Create minimal token and component files

### Manual Setup

Navigate to packages:
```bash
cd ../lab4.1/packages
```

## Exercises

### Exercise 1: Configure Tokens Package

Examine `packages/tokens/package.json`:

```json
{
  "name": "@myapp/tokens",
  "version": "0.0.1",
  "private": true,
  "main": "./build/js/tokens.js",
  "types": "./build/ts/tokens.d.ts",
  "exports": {
    ".": "./build/js/tokens.js",
    "./css": "./build/css/variables.css"
  },
  "scripts": {
    "build": "style-dictionary build",
    "clean": "rm -rf build"
  },
  "devDependencies": {
    "style-dictionary": "^3.9.0"
  }
}
```

**Key points:**
- `exports` defines two entry points:
  - `.` (default): JavaScript tokens
  - `./css`: CSS variables file
- The `build` script runs Style Dictionary

### Exercise 2: Configure UI Package

Examine `packages/ui/package.json`:

```json
{
  "name": "@myapp/ui",
  "version": "0.0.1",
  "private": true,
  "main": "./src/index.tsx",
  "module": "./src/index.tsx",
  "types": "./src/index.tsx",
  "exports": {
    ".": "./src/index.tsx",
    "./button": "./src/components/Button.tsx",
    "./input": "./src/components/Input.tsx",
    "./card": "./src/components/Card.tsx"
  },
  "scripts": {
    "build": "tsc",
    "dev": "tsc --watch",
    "clean": "rm -rf dist",
    "typecheck": "tsc --noEmit"
  },
  "dependencies": {
    "@myapp/tokens": "workspace:*",
    "class-variance-authority": "^0.7.0",
    "clsx": "^2.0.0",
    "tailwind-merge": "^2.0.0"
  },
  "peerDependencies": {
    "react": "^18.0.0",
    "react-dom": "^18.0.0"
  },
  "devDependencies": {
    "@myapp/config": "workspace:*",
    "@types/react": "^18.0.0",
    "@types/react-dom": "^18.0.0",
    "typescript": "^5.0.0"
  }
}
```

**Workspace dependencies:**
- `@myapp/tokens: workspace:*` - UI can import from tokens
- `@myapp/config: workspace:*` - UI uses shared TypeScript config

**Peer dependencies:**
- React is a peer dependency because the consuming app provides it

### Exercise 3: Understand workspace:* Resolution

When you write:
```json
{
  "dependencies": {
    "@myapp/tokens": "workspace:*"
  }
}
```

pnpm:
1. Looks in `pnpm-workspace.yaml` for workspace packages
2. Finds `packages/tokens` with `name: "@myapp/tokens"`
3. Creates a symlink: `node_modules/@myapp/tokens -> ../../packages/tokens`

**Result:** Changes to tokens reflect immediately in UI!

### Exercise 4: Configure UI's TypeScript

Examine `packages/ui/tsconfig.json`:

```json
{
  "extends": "@myapp/config/tsconfig/react",
  "compilerOptions": {
    "outDir": "./dist"
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "dist"]
}
```

This:
- Extends the shared React TypeScript config
- Outputs compiled files to `dist/`
- Only includes source files

### Exercise 5: Examine Token Files

Check the token source structure:

```bash
ls packages/tokens/src/
```

**Files:**
- `color.json` - Color tokens
- `spacing.json` - Spacing tokens

Example `color.json`:
```json
{
  "color": {
    "primary": {
      "50": { "value": "#eff6ff" },
      "500": { "value": "#3b82f6" },
      "600": { "value": "#2563eb" },
      "700": { "value": "#1d4ed8" }
    }
  }
}
```

### Exercise 6: Examine UI Component Files

Check the UI source structure:

```bash
ls packages/ui/src/
ls packages/ui/src/components/
```

**Structure:**
```
packages/ui/src/
├── components/
│   └── Button.tsx
├── lib/
│   └── utils.ts
└── index.tsx
```

The Button component uses CVA pattern from Chapter 3.

### Exercise 7: Trace the Dependency Graph

```
@myapp/config
     ↓ (devDependency)
@myapp/tokens ────────→ @myapp/ui
                            ↓
                       (workspace:*)
```

**Build order:**
1. `@myapp/config` (no deps, just static files)
2. `@myapp/tokens` (needs Style Dictionary build)
3. `@myapp/ui` (depends on tokens)

## Key Concepts

### workspace:* vs Version Numbers

| Syntax | Meaning |
|--------|---------|
| `"^1.0.0"` | Get from npm registry |
| `"workspace:*"` | Get from local workspace |
| `"workspace:^"` | Local, but version must match |

For monorepos, always use `workspace:*` for internal packages.

### Why Private Packages?

```json
{ "private": true }
```

This prevents accidental `npm publish`. These packages:
- Are only used within the monorepo
- Don't need to be on npm
- Can reference each other freely

### Exports Field Benefits

```json
{
  "exports": {
    ".": "./src/index.tsx",
    "./button": "./src/components/Button.tsx"
  }
}
```

Consumers can now:
```tsx
// Import everything
import { Button, Input } from "@myapp/ui";

// Import specific component (smaller bundle)
import { Button } from "@myapp/ui/button";
```

## Checklist

Before proceeding to Lab 4.4:

- [ ] tokens/package.json configured with Style Dictionary
- [ ] tokens/src/ has color.json and spacing.json
- [ ] ui/package.json has workspace:* dependencies
- [ ] ui/tsconfig.json extends @myapp/config/tsconfig/react
- [ ] ui/src/ has components, lib, and index.tsx
- [ ] You understand workspace:* resolution

## Troubleshooting

### "Cannot find module '@myapp/tokens'"

1. Check tokens/package.json has `"name": "@myapp/tokens"`
2. Run `pnpm install` from root
3. Check symlink exists: `ls -la node_modules/@myapp/`

### "Cannot find module '@myapp/config/tsconfig/react'"

1. Check config/package.json exports field
2. Make sure the path matches: `./tsconfig/react.json`

### Style Dictionary errors

Make sure token JSON is valid:
```bash
cd packages/tokens
npx style-dictionary build
```

## Next

Proceed to Lab 4.4 to create the web application.
