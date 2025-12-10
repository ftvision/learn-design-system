# Chapter 4 Study Plan: Monorepo Architecture

## Part 1: Theory (20 minutes)

### 1.1 Monorepo Fundamentals

A **monorepo** is a single repository containing multiple packages or applications. For design systems, this means:

```
my-product/
├── packages/       # Shared code (libraries)
│   ├── tokens/    # npm: @myapp/tokens
│   ├── ui/        # npm: @myapp/ui
│   └── config/    # npm: @myapp/config
└── apps/          # Applications (not published to npm)
    ├── web/       # Your main app
    └── docs/      # Documentation site
```

### 1.2 Workspace Dependencies

Instead of npm publishing, packages reference each other with `workspace:*`:

```json
// apps/web/package.json
{
  "dependencies": {
    "@myapp/ui": "workspace:*",      // Resolves to packages/ui
    "@myapp/tokens": "workspace:*"   // Resolves to packages/tokens
  }
}
```

**What `workspace:*` means:**
- `workspace:` = Look in this monorepo
- `*` = Use whatever version is in the workspace

### 1.3 Turborepo

Turborepo orchestrates builds across packages:

```json
// turbo.json
{
  "tasks": {
    "build": {
      "dependsOn": ["^build"],  // Build dependencies first
      "outputs": ["dist/**"]
    }
  }
}
```

When you run `turbo build`:
1. Builds `packages/tokens` first (no dependencies)
2. Then `packages/ui` (depends on tokens)
3. Finally `apps/web` (depends on ui)

### 1.4 Benefits

| Feature | Benefit |
|---------|---------|
| Single git clone | Everything in one place |
| Workspace dependencies | No npm publish cycle |
| Shared configs | Consistent TypeScript, ESLint, Tailwind |
| Turborepo caching | Faster builds (skip unchanged packages) |
| Atomic changes | Update UI and app together |

---

## Part 2: Labs

### Lab 4.1: Initialize Monorepo (~30 minutes)

**Objective:** Create the monorepo root structure with pnpm workspaces and Turborepo.

**Topics:**
- Monorepo directory structure
- Root package.json configuration
- pnpm-workspace.yaml setup
- Turborepo task configuration

**Key Concepts:**
- `packages/` vs `apps/` organization
- `dependsOn: ["^build"]` for build order
- `workspace:*` dependency syntax

[→ Go to Lab 4.1](./labs/lab4.1/README.md)

---

### Lab 4.2: Shared Configurations (~30 minutes)

**Objective:** Create shared TypeScript and Tailwind configurations.

**Topics:**
- Base TypeScript config
- React-specific TypeScript config
- Next.js TypeScript config
- Shared Tailwind config

**Key Concepts:**
- Config inheritance chain (base → react → nextjs)
- Exports field in package.json
- Tailwind content paths

[→ Go to Lab 4.2](./labs/lab4.2/README.md)

---

### Lab 4.3: Wire Packages (~30 minutes)

**Objective:** Configure tokens and UI packages with workspace dependencies.

**Topics:**
- Tokens package with Style Dictionary
- UI package with CVA components
- Workspace dependency resolution
- TypeScript config extension

**Key Concepts:**
- `workspace:*` resolution
- Peer dependencies for React
- Package exports field

[→ Go to Lab 4.3](./labs/lab4.3/README.md)

---

### Lab 4.4: Create Web App (~45 minutes)

**Objective:** Create a Next.js application consuming the design system.

**Topics:**
- Next.js app structure
- Workspace dependencies in app
- Tailwind config for workspace packages
- Demo page with UI components

**Key Concepts:**
- Next.js workspace package transpilation
- Tailwind content configuration
- Import resolution chain

[→ Go to Lab 4.4](./labs/lab4.4/README.md)

---

### Lab 4.5: Build & Run (~20 minutes)

**Objective:** Install, build, and run the complete monorepo.

**Topics:**
- pnpm install with workspaces
- Turborepo build order
- Development server
- Hot reload across packages

**Key Concepts:**
- pnpm symlinks vs copying
- Turborepo caching
- Hot Module Replacement (HMR)

[→ Go to Lab 4.5](./labs/lab4.5/README.md)

---

### Lab 4.6: Compare with Real Projects (~20 minutes)

**Objective:** Study production monorepos and reflect on the architecture.

**Topics:**
- Cal.com monorepo structure
- Comparison with your implementation
- Production patterns
- Written reflection

**Key Concepts:**
- Common monorepo patterns
- Scaling considerations
- Real-world additions

[→ Go to Lab 4.6](./labs/lab4.6/README.md)

---

## Part 3: Self-Check & Reflection

### Files You Should Have

After completing all labs:

```
lab4.1/
├── packages/
│   ├── tokens/
│   │   ├── src/
│   │   │   ├── color.json
│   │   │   └── spacing.json
│   │   ├── style-dictionary.config.js
│   │   └── package.json
│   ├── ui/
│   │   ├── src/
│   │   │   ├── components/
│   │   │   │   ├── Button.tsx
│   │   │   │   ├── Input.tsx
│   │   │   │   └── Card.tsx
│   │   │   ├── lib/utils.ts
│   │   │   └── index.tsx
│   │   ├── package.json
│   │   └── tsconfig.json
│   └── config/
│       ├── tsconfig/
│       │   ├── base.json
│       │   ├── react.json
│       │   └── nextjs.json
│       ├── tailwind.config.js
│       └── package.json
├── apps/
│   └── web/
│       ├── app/
│       │   ├── page.tsx
│       │   ├── layout.tsx
│       │   └── globals.css
│       ├── package.json
│       ├── tsconfig.json
│       └── tailwind.config.ts
├── package.json
├── pnpm-workspace.yaml
└── turbo.json
```

### Self-Check

Before moving to Chapter 5, verify:

- [ ] `pnpm install` works without errors
- [ ] `pnpm build` builds all packages in order
- [ ] `pnpm dev` runs the app with hot reload
- [ ] Changes in UI package reflect in the app
- [ ] You understand workspace dependency resolution
- [ ] You've compared with Cal.com or Supabase structure

---

## Troubleshooting

### "Cannot find module '@myapp/ui'"

1. Make sure `packages/ui/package.json` has `"name": "@myapp/ui"`
2. Run `pnpm install` from root
3. Check that `node_modules/@myapp/ui` is a symlink

### "Module not found: Can't resolve 'class-variance-authority'"

Dependencies need to be installed:
```bash
cd packages/ui
pnpm install
```

### "Build failed: packages/ui depends on packages/tokens"

Make sure tokens is built first:
```bash
pnpm build --filter=@myapp/tokens
pnpm build
```

### Tailwind classes not applying

Check `tailwind.config.ts` includes the UI package path:
```typescript
content: [
  // ...
  "../../packages/ui/src/**/*.{js,ts,jsx,tsx}",
]
```

---

## Next Chapter

In Chapter 5, you'll add documentation with Storybook to showcase your design system components.
