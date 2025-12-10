# Lab 4.6: Compare with Real Projects

## Objective

Study how production monorepos (Cal.com, Supabase) structure their workspaces and compare with your implementation.

## Time Estimate

~20 minutes

## Prerequisites

- Completed Labs 4.1-4.5
- Chapter 1 completed (Cal.com reference available)

## Setup

### Quick Setup

```bash
./setup.sh
```

This will create symlinks to the reference projects.

## Exercises

### Exercise 1: Study Cal.com's Monorepo Structure

```bash
# Navigate to Cal.com
cat cal.com/pnpm-workspace.yaml
```

**Questions to answer:**

1. **What workspaces does Cal.com define?**
   ```
   Cal.com workspaces:
   - _______________
   - _______________
   - _______________
   ```

2. **How does it compare to your setup?**
   | Aspect | Your Setup | Cal.com |
   |--------|------------|---------|
   | Package manager | pnpm | ___ |
   | Workspace locations | packages/*, apps/* | ___ |
   | Number of packages | 4 | ___ |

### Exercise 2: Study Cal.com's turbo.json

```bash
cat cal.com/turbo.json
```

**Questions:**

1. What tasks are defined?
2. Do they use `dependsOn: ["^build"]`?
3. What outputs do they cache?

**Write observations:**
```
Cal.com turbo.json:
- Tasks: _______________
- Build dependencies: _______________
- Notable features: _______________
```

### Exercise 3: Examine Cal.com's Package Dependencies

```bash
# Look at an app's dependencies
cat cal.com/apps/web/package.json | head -30
```

**Questions:**

1. How do they reference internal packages?
2. Do they use `workspace:*` or specific versions?
3. What shared packages do they depend on?

### Exercise 4: Study Their UI Package Structure

```bash
# Explore UI package
ls cal.com/packages/ui/
cat cal.com/packages/ui/package.json
```

**Compare with your UI package:**

| Feature | Your @myapp/ui | Cal.com's UI |
|---------|----------------|--------------|
| Package name | @myapp/ui | ___ |
| Main entry | src/index.tsx | ___ |
| Build tool | tsc | ___ |
| Exports pattern | Multiple | ___ |

### Exercise 5: Trace Import Resolution

In your monorepo, trace how this import works:

```tsx
import { Button } from "@myapp/ui";
```

**Resolution steps:**

1. Node looks for `@myapp/ui` in node_modules
2. Finds symlink: `node_modules/@myapp/ui -> ../../packages/ui`
3. Reads `packages/ui/package.json`
4. Gets `exports["."]` = `./src/index.tsx`
5. Loads `packages/ui/src/index.tsx`
6. Follows re-export to `./components/Button.tsx`

**Verify with:**
```bash
ls -la node_modules/@myapp/
cat packages/ui/package.json | grep -A5 '"exports"'
```

### Exercise 6: Understanding the Connection

Now you have a complete picture:

```
┌─────────────────────────────────────────────────────────┐
│                    Your Monorepo                        │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  packages/tokens/          packages/ui/                 │
│  ├── src/                  ├── src/                     │
│  │   ├── color.json        │   ├── components/          │
│  │   └── spacing.json      │   │   ├── Button.tsx       │
│  ├── build/                │   │   ├── Input.tsx        │
│  │   ├── css/              │   │   └── Card.tsx         │
│  │   └── js/               │   └── index.tsx            │
│  └── package.json          └── package.json             │
│                                      ↑                   │
│                                      │ workspace:*       │
│                                      │                   │
│  apps/web/                           │                   │
│  ├── app/                            │                   │
│  │   ├── page.tsx ──────────────────┘                   │
│  │   └── layout.tsx                                     │
│  └── package.json                                       │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

### Exercise 7: Written Reflection

Answer these questions:

1. **What problem does a monorepo solve for design systems?**
   ```


   ```

2. **What does `workspace:*` mean in package.json?**
   ```


   ```

3. **Why does Turborepo build in a specific order?**
   ```


   ```

4. **How do changes in packages/ui appear instantly in apps/web?**
   ```


   ```

5. **What's the benefit of shared configurations (packages/config)?**
   ```


   ```

## Key Takeaways

### Common Patterns in Production Monorepos

1. **Package Organization**
   - `packages/` for shared libraries
   - `apps/` for deployable applications
   - Clear naming convention (`@org/package-name`)

2. **Workspace Configuration**
   - pnpm with `pnpm-workspace.yaml`
   - Turborepo for build orchestration
   - Shared configs in a config package

3. **Dependency Management**
   - `workspace:*` for internal packages
   - `peerDependencies` for framework deps
   - Single version of each dependency

4. **Build Pipeline**
   - Dependency-aware build order
   - Caching for faster rebuilds
   - Parallel execution where possible

### What Production Monorepos Often Add

Things you might add in a real project:

- **More packages**: eslint-config, prettier-config, types
- **CI/CD integration**: GitHub Actions, caching
- **Changesets**: Version management and changelogs
- **Documentation**: Storybook, docs site
- **Testing**: Shared test utilities
- **Release automation**: Publishing to npm

## Self-Check: Chapter 4 Complete

Verify you have:

- [ ] Root package.json with turbo scripts
- [ ] pnpm-workspace.yaml defining workspaces
- [ ] turbo.json with build pipeline
- [ ] packages/config with shared TypeScript configs
- [ ] packages/tokens with Style Dictionary
- [ ] packages/ui with React components
- [ ] apps/web consuming all packages
- [ ] `pnpm install` works
- [ ] `pnpm build` builds in correct order
- [ ] `pnpm dev` runs with hot reload
- [ ] Compared with Cal.com structure

## Files You Should Have

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

## Connecting to Previous Chapters

| Chapter | What You Built | How It Connects |
|---------|----------------|-----------------|
| Chapter 2 | Design tokens with Style Dictionary | `packages/tokens` in monorepo |
| Chapter 3 | UI components with CVA | `packages/ui` in monorepo |
| Chapter 4 | Monorepo structure | Wires everything together |

The monorepo is the **integration layer** that connects your tokens and components into a cohesive system.

## Next Steps

You now have a complete monorepo architecture! In Chapter 5, you'll add documentation with Storybook to showcase your components.
