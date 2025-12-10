# Lab 4.5: Build & Run

## Objective

Install dependencies, build all packages, run the development server, and verify hot reload works across packages.

## Time Estimate

~20 minutes

## Prerequisites

- Completed Labs 4.1-4.4
- pnpm installed (`npm install -g pnpm`)

## Setup

### Quick Setup

```bash
./setup.sh
```

This will:
1. Ensure all previous labs are complete
2. Install dependencies with pnpm
3. Build all packages with Turborepo
4. Provide instructions for running dev server

## Exercises

### Exercise 1: Install Dependencies

From the lab4.1 directory (monorepo root):

```bash
cd ../lab4.1
pnpm install
```

**What happens:**
1. pnpm reads `pnpm-workspace.yaml`
2. Finds all packages in `packages/*` and `apps/*`
3. Installs dependencies for each
4. Creates symlinks for workspace packages

**Verify symlinks:**
```bash
ls -la node_modules/@myapp/
```

You should see:
```
ui -> ../../packages/ui
tokens -> ../../packages/tokens
config -> ../../packages/config
```

### Exercise 2: Build All Packages

```bash
pnpm build
```

**Watch the build order:**

Turborepo reads the dependency graph and builds in order:

```
┌─────────────────────────────────────────────────┐
│ • Packages in scope: @myapp/config, @myapp/tokens, @myapp/ui, @myapp/web
│ • Running build in 4 packages
│ • Remote caching disabled
└─────────────────────────────────────────────────┘

@myapp/tokens:build: cache miss, executing
@myapp/tokens:build: > style-dictionary build

@myapp/ui:build: cache miss, executing
@myapp/ui:build: > tsc

@myapp/web:build: cache miss, executing
@myapp/web:build: > next build
```

**Order:**
1. `@myapp/config` - No build (static files)
2. `@myapp/tokens` - Runs Style Dictionary
3. `@myapp/ui` - Runs TypeScript
4. `@myapp/web` - Runs Next.js build

### Exercise 3: Run Development Server

```bash
pnpm dev
```

**Expected output:**
```
@myapp/web:dev: ready - started server on 0.0.0.0:3000
```

Open http://localhost:3000 in your browser.

**Verify:**
- [ ] Page loads without errors
- [ ] Buttons render with correct styles
- [ ] Button variants (primary, secondary, etc.) work
- [ ] Input components show labels and errors
- [ ] Card layout is correct

### Exercise 4: Test Hot Reload

This is the magic of monorepos - changes propagate instantly!

1. **Keep `pnpm dev` running**

2. **Open `packages/ui/src/components/Button.tsx`**

3. **Change a color:**
   ```tsx
   // Find this line:
   primary: "bg-blue-600 text-white hover:bg-blue-700 focus-visible:ring-blue-500",

   // Change to:
   primary: "bg-purple-600 text-white hover:bg-purple-700 focus-visible:ring-purple-500",
   ```

4. **Save the file**

5. **Watch the browser** - buttons should turn purple without refresh!

**Why this works:**
- Next.js detects the workspace package change
- Triggers recompilation of the UI package
- Hot Module Replacement (HMR) updates the browser

### Exercise 5: Understand Turborepo Caching

Run build again:

```bash
pnpm build
```

**Second run output:**
```
@myapp/tokens:build: cache hit, replaying logs
@myapp/ui:build: cache hit, replaying logs
@myapp/web:build: cache hit, replaying logs
```

Turborepo cached the results! Builds that haven't changed are skipped.

**Try modifying a file:**
1. Edit `packages/ui/src/components/Button.tsx`
2. Run `pnpm build`
3. Only `@myapp/ui` and `@myapp/web` rebuild

### Exercise 6: Inspect node_modules

Understand how pnpm handles workspace packages:

```bash
# See workspace symlinks
ls -la node_modules/@myapp/

# See where packages get their dependencies
ls packages/ui/node_modules/
```

**Key insight:** Each package can have its own `node_modules`, but workspace packages are symlinked from root.

### Exercise 7: Run Individual Package Scripts

Turborepo can target specific packages:

```bash
# Build only tokens
pnpm build --filter=@myapp/tokens

# Build only UI and its dependencies
pnpm build --filter=@myapp/ui

# Run dev for just the web app
pnpm dev --filter=@myapp/web
```

The `--filter` flag is powerful for large monorepos.

## Key Concepts

### Turborepo Task Pipeline

From `turbo.json`:
```json
{
  "tasks": {
    "build": {
      "dependsOn": ["^build"],
      "outputs": ["dist/**", ".next/**", "build/**"]
    }
  }
}
```

- `dependsOn: ["^build"]` - Build dependencies first
- `outputs` - Files to cache

### pnpm Workspace Symlinks

Unlike npm/yarn, pnpm uses symlinks:

```
node_modules/
└── @myapp/
    ├── ui -> ../../packages/ui       # Symlink!
    ├── tokens -> ../../packages/tokens
    └── config -> ../../packages/config
```

**Benefits:**
- Instant updates (no reinstall needed)
- Disk space efficient
- True single version of each package

### Hot Reload Flow

```
Edit packages/ui/Button.tsx
         ↓
Next.js detects change
         ↓
Triggers recompilation
         ↓
HMR sends update to browser
         ↓
Component re-renders (no full reload!)
```

## Common Issues and Solutions

### "Module not found" after install

```bash
# Clear caches and reinstall
pnpm clean
rm -rf node_modules
pnpm install
```

### Build fails on first package

Check that dependencies are correctly declared:
```bash
# Show dependency graph
pnpm why @myapp/ui
```

### Tailwind styles not updating

Make sure Tailwind content includes UI package:
```typescript
// apps/web/tailwind.config.ts
content: [
  "../../packages/ui/src/**/*.{js,ts,jsx,tsx}",  // Check this path!
]
```

### Port 3000 already in use

```bash
# Find and kill the process
lsof -i :3000
kill -9 <PID>

# Or use a different port
pnpm dev -- -p 3001
```

## Checklist

Before proceeding to Lab 4.6:

- [ ] `pnpm install` completes without errors
- [ ] `pnpm build` builds all packages in order
- [ ] `pnpm dev` starts the development server
- [ ] http://localhost:3000 shows the demo page
- [ ] Components render correctly with styles
- [ ] Hot reload works when editing UI package
- [ ] You understand Turborepo caching

## Next

Proceed to Lab 4.6 to compare with real-world monorepo projects.
