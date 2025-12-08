# Lab 1.5: Trace the Import Path

## Objective

Understand how packages reference each other in a monorepo by tracing the complete import path from a page to the UI package.

## Setup

Cal.com is stored as a git submodule in `references/cal.com` and symlinked into this lab directory.

### Quick Setup

```bash
./setup.sh
```

This will:
1. Initialize the Cal.com submodule (if needed)
2. Checkout the pinned commit for reproducibility
3. Create a symlink at `cal.com/` for easy access

## Exercises

### Exercise 1: Find the Dependency Declaration

Open `apps/web/package.json` and find how it references the UI package:

```bash
cat cal.com/apps/web/package.json | grep -A2 -B2 "@calcom/ui"
```

**Write your findings:**
```
Dependency declaration: ____________________
```

**Questions to answer:**
1. What version specifier is used?
2. What does `workspace:*` (or similar) mean?

### Exercise 2: Understand Workspace Dependencies

Look at the root package.json and workspace configuration:

```bash
cat cal.com/package.json | head -30
cat cal.com/pnpm-workspace.yaml 2>/dev/null || cat cal.com/turbo.json | head -20
```

**Questions to answer:**
1. What package manager does Cal.com use?
2. How are workspaces defined?
3. What packages are included in the workspace?

### Exercise 3: Trace a Complete Import

Pick a page that uses `@calcom/ui` and trace the import:

```bash
# Step 1: Find a page using @calcom/ui
grep -r "from \"@calcom/ui\"" cal.com/apps/web/app/ --include="*.tsx" -l | head -1

# Step 2: Look at the import in that file
# (replace with the file you found)
grep "@calcom/ui" cal.com/apps/web/app/[your-file].tsx

# Step 3: Look at how the UI package exports
cat cal.com/packages/ui/package.json | grep -A5 "exports"
```

**Trace the path:**
```
Page file: apps/web/app/____________________
  ↓ imports from
Package: @calcom/ui
  ↓ resolves to
Directory: packages/ui/
  ↓ exports from
Entry point: ____________________
```

### Exercise 4: Understand the Resolution

**How does `import { Button } from "@calcom/ui"` work?**

1. The app's `package.json` declares `@calcom/ui: workspace:*`
2. The package manager (pnpm/yarn) resolves `workspace:*` to `packages/ui`
3. The UI package's `package.json` defines exports/main entry
4. TypeScript follows the same resolution

```bash
# Check the UI package's entry point
cat cal.com/packages/ui/package.json | grep -E "main|exports|types" | head -10
```

### Exercise 5: Visualize the Dependency Graph

Draw the dependency flow:

```
┌─────────────────────────────────────────────────────────────┐
│ apps/web/app/[page].tsx                                     │
│   import { Button } from "@calcom/ui"                       │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│ apps/web/package.json                                       │
│   "@calcom/ui": "workspace:*"                               │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│ packages/ui/package.json                                    │
│   "main": "./index.tsx" (or similar)                        │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│ packages/ui/index.tsx                                       │
│   export { Button } from "./components/button"              │
└─────────────────────────────────────────────────────────────┘
```

## Key Observations

After completing this lab, you should understand:
- How `workspace:*` connects packages in a monorepo
- The resolution path from import statement to actual file
- Why monorepos don't need npm publishing for internal packages
- How TypeScript resolves types across packages

## Checklist

- [ ] I found the dependency declaration in `apps/web/package.json`
- [ ] I understand what `workspace:*` means
- [ ] I can trace an import from page to UI package
- [ ] I understand the package resolution flow

## Summary

You've now traced the complete path:

```
Page (Layer 5)
    ↓ imports
App Component (Layer 4)
    ↓ imports
UI Package (Layers 2-3)
    ↓ uses
Design Tokens (Layer 1)
```

## Next

Proceed to Part 3 (Labs 1.6-1.8) to compare Cal.com with Supabase's approach.
