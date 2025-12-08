# Lecture Notes: Monorepo Architecture (Part 1 - Theory)

**Duration:** 30-45 minutes
**Chapter:** 04 - Monorepo Architecture

---

## Lecture Outline

1. Opening Question
2. The Multi-Repo Pain
3. Monorepos: The Unified Solution
4. Workspace Dependencies Explained
5. Turborepo: The Build Orchestrator
6. The Package Resolution Journey
7. Key Takeaways

---

## 1. Opening Question (3 minutes)

> **Ask the class:** "You've built a UI library. Now you need to use it in your app. How do you share the code?"

**Expected answers:** npm publish, copy-paste, git submodules, symlinks...

**Instructor note:** Each answer has significant friction. npm publish requires versioning, publishing, waiting. Copy-paste loses sync. Submodules are complex. This pain motivates monorepos.

**Follow-up:** "What happens when you find a bug in your Button component and need to fix it while also updating the app that uses it?"

---

## 2. The Multi-Repo Pain (7 minutes)

### The Traditional Approach

In a traditional setup, your design system lives in a separate repository:

```
github.com/company/ui-library     ← Published to npm as @company/ui
github.com/company/web-app        ← npm install @company/ui
github.com/company/mobile-app     ← npm install @company/ui
```

### The Workflow Nightmare

Here's what happens when you need to change a Button:

```
┌────────────────────────────────────────────────────────────────┐
│                     THE CHANGE CYCLE                           │
├────────────────────────────────────────────────────────────────┤
│                                                                │
│  1. Fix bug in ui-library repo                                 │
│           ↓                                                    │
│  2. Run tests, update changelog                                │
│           ↓                                                    │
│  3. Bump version (1.2.3 → 1.2.4)                               │
│           ↓                                                    │
│  4. npm publish                        ⏱ 2-5 minutes          │
│           ↓                                                    │
│  5. Wait for npm registry             ⏱ 1-5 minutes           │
│           ↓                                                    │
│  6. In web-app: npm update @company/ui                        │
│           ↓                                                    │
│  7. Test that the fix works                                    │
│           ↓                                                    │
│  8. Realize you need another change                            │
│           ↓                                                    │
│  9. REPEAT FROM STEP 1                 🔄                      │
│                                                                │
│  Total time for one iteration: 15-30 minutes                   │
│                                                                │
└────────────────────────────────────────────────────────────────┘
```

### The Problems

| Problem | Impact |
|---------|--------|
| **Slow iteration** | 15-30 minutes per change cycle |
| **Version drift** | App stuck on old UI version |
| **Breaking changes** | Published before fully tested in app |
| **Context switching** | Different repos, different terminals |
| **Coordination overhead** | "Did you publish the new version?" |

> **Ask:** "Has anyone experienced this pain? How many publish cycles did your last design system update take?"

---

## 3. Monorepos: The Unified Solution (8 minutes)

### The Concept

A **monorepo** is a single repository containing multiple packages and applications:

```
my-product/
├── packages/           # Shared code (libraries)
│   ├── tokens/        # @myapp/tokens
│   ├── ui/            # @myapp/ui
│   └── config/        # @myapp/config
└── apps/              # Applications
    ├── web/           # Next.js app
    └── docs/          # Storybook
```

### The New Workflow

```
┌────────────────────────────────────────────────────────────────┐
│                     THE MONOREPO WORKFLOW                      │
├────────────────────────────────────────────────────────────────┤
│                                                                │
│  1. Fix bug in packages/ui/Button.tsx                          │
│           ↓                                                    │
│  2. Save file                                                  │
│           ↓                                                    │
│  3. Browser updates automatically              ⏱ 1-2 seconds  │
│           ↓                                                    │
│  4. Test in actual app context                                 │
│           ↓                                                    │
│  5. Commit both changes together                               │
│                                                                │
│  Total time: Instant                                           │
│                                                                │
└────────────────────────────────────────────────────────────────┘
```

### Side-by-Side Comparison

| Aspect | Multi-Repo | Monorepo |
|--------|-----------|----------|
| Change a component | 15-30 min cycle | Save → instant |
| Keep app updated | Manual npm update | Always current |
| Test in context | After publish | During development |
| Commit scope | Separate commits | Atomic commits |
| Clone to contribute | Multiple repos | One `git clone` |

### Who Uses Monorepos?

| Company | Structure |
|---------|-----------|
| **Google** | One repo for everything |
| **Meta** | Large monorepo for web |
| **Cal.com** | packages/ui, apps/web |
| **Supabase** | packages/ui, apps/studio |
| **Vercel** | All Next.js tools |

> **Key insight:** Monorepos are the industry standard for design systems because the alternative is too painful.

---

## 4. Workspace Dependencies Explained (8 minutes)

### The Magic of `workspace:*`

In a monorepo, packages reference each other with a special syntax:

```json
// apps/web/package.json
{
  "dependencies": {
    "@myapp/ui": "workspace:*",
    "@myapp/tokens": "workspace:*"
  }
}
```

### What Does `workspace:*` Mean?

| Part | Meaning |
|------|---------|
| `workspace:` | Look in this monorepo, not npm |
| `*` | Accept whatever version exists locally |

### How It Resolves

```
apps/web/package.json says:
    "@myapp/ui": "workspace:*"
           ↓
pnpm-workspace.yaml says:
    packages: ['packages/*']
           ↓
Look in packages/ for package.json with:
    "name": "@myapp/ui"
           ↓
Found: packages/ui/package.json
           ↓
Create symlink: node_modules/@myapp/ui → ../../packages/ui
```

### The Symlink Architecture

After `pnpm install`, your `node_modules` looks like this:

```
node_modules/
└── @myapp/
    ├── ui/        → ../../packages/ui       (symlink!)
    ├── tokens/    → ../../packages/tokens   (symlink!)
    └── config/    → ../../packages/config   (symlink!)
```

**Why symlinks matter:**
- No copying files
- Changes reflect immediately
- No need to reinstall after changes

### The pnpm-workspace.yaml File

```yaml
# pnpm-workspace.yaml
packages:
  - 'packages/*'    # All folders in packages/
  - 'apps/*'        # All folders in apps/
```

This tells pnpm: "These directories contain packages that can reference each other."

### Visual: The Dependency Graph

```
┌─────────────────────────────────────────────────────────────────┐
│                        MONOREPO                                  │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│   packages/tokens/              packages/ui/                     │
│   ┌──────────────┐              ┌──────────────┐                │
│   │ @myapp/tokens│              │ @myapp/ui    │                │
│   │              │◄─────────────│              │                │
│   │ (no deps)    │  depends on  │ depends on:  │                │
│   │              │              │ @myapp/tokens│                │
│   └──────────────┘              └──────┬───────┘                │
│                                        │                         │
│                    ┌───────────────────┘                         │
│                    │ depends on                                  │
│                    ▼                                             │
│              apps/web/                                           │
│              ┌──────────────┐                                    │
│              │ @myapp/web   │                                    │
│              │              │                                    │
│              │ depends on:  │                                    │
│              │ @myapp/ui    │                                    │
│              │ @myapp/tokens│                                    │
│              └──────────────┘                                    │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

## 5. Turborepo: The Build Orchestrator (10 minutes)

### The Problem Turborepo Solves

In a monorepo with dependencies:
- tokens has no dependencies
- ui depends on tokens
- web depends on ui and tokens

**Question:** When you run `build`, what order should things build?

**Answer:** tokens → ui → web

Turborepo figures this out automatically.

### The turbo.json Configuration

```json
{
  "$schema": "https://turbo.build/schema.json",
  "tasks": {
    "build": {
      "dependsOn": ["^build"],
      "outputs": ["dist/**", ".next/**", "build/**"]
    },
    "dev": {
      "cache": false,
      "persistent": true
    },
    "lint": {
      "dependsOn": ["^build"]
    }
  }
}
```

### Understanding `dependsOn: ["^build"]`

The `^` caret is critical:

| Syntax | Meaning |
|--------|---------|
| `^build` | Build dependencies **before** this package |
| `build` (no ^) | Build this package's other tasks first |

```
"build": { "dependsOn": ["^build"] }

When building @myapp/web:
  1. Find dependencies: @myapp/ui, @myapp/tokens
  2. Build @myapp/tokens first (no dependencies)
  3. Build @myapp/ui (depends on tokens ✓)
  4. Build @myapp/web (depends on ui ✓, tokens ✓)
```

### The Build Execution

```bash
$ pnpm build

┌─────────────────────────────────────────────────────────────────┐
│  Turborepo execution plan:                                      │
│                                                                 │
│  @myapp/tokens:build ────────────┐                              │
│                                  ├──► @myapp/ui:build ──┐       │
│                                  │                      ├──► @myapp/web:build
│                                  └──────────────────────┘       │
│                                                                 │
│  • Parallel when possible                                       │
│  • Sequential when dependencies require                         │
└─────────────────────────────────────────────────────────────────┘
```

### Turborepo Caching

Turborepo caches build outputs. If nothing changed, it skips the build:

```bash
$ pnpm build

@myapp/tokens:build: cache hit, replaying logs  ← Skipped!
@myapp/ui:build: cache hit, replaying logs      ← Skipped!
@myapp/web:build: building...                   ← Only this runs

Time saved: 90%
```

### Dev Server Configuration

```json
"dev": {
  "cache": false,     // Don't cache dev servers
  "persistent": true  // Keep running (don't exit)
}
```

When you run `pnpm dev`:
- All dev servers start
- They keep running
- File changes trigger rebuilds

---

## 6. The Package Resolution Journey (5 minutes)

### Tracing an Import

When your app says:

```tsx
import { Button } from "@myapp/ui";
```

Here's the complete resolution journey:

```
┌─────────────────────────────────────────────────────────────────┐
│  Step 1: Resolve "@myapp/ui"                                    │
│                                                                 │
│  Node.js looks in node_modules/@myapp/ui                        │
│  → This is a symlink to ../../packages/ui                       │
├─────────────────────────────────────────────────────────────────┤
│  Step 2: Read package.json                                      │
│                                                                 │
│  packages/ui/package.json:                                      │
│  {                                                              │
│    "exports": {                                                 │
│      ".": "./src/index.tsx"    ← Entry point for "."           │
│    }                                                            │
│  }                                                              │
├─────────────────────────────────────────────────────────────────┤
│  Step 3: Load entry file                                        │
│                                                                 │
│  packages/ui/src/index.tsx:                                     │
│  export { Button } from "./components/Button";                  │
├─────────────────────────────────────────────────────────────────┤
│  Step 4: Follow the export                                      │
│                                                                 │
│  packages/ui/src/components/Button.tsx                          │
│  export function Button() { ... }                               │
│                                                                 │
│  ✓ Button component loaded!                                     │
└─────────────────────────────────────────────────────────────────┘
```

### The exports Field

The `exports` field in package.json is the modern way to define entry points:

```json
{
  "exports": {
    ".": "./src/index.tsx",           // import from "@myapp/ui"
    "./button": "./src/components/Button.tsx",  // import from "@myapp/ui/button"
    "./styles.css": "./src/styles.css"  // import "@myapp/ui/styles.css"
  }
}
```

This enables:

```tsx
// Full package import
import { Button, Input, Card } from "@myapp/ui";

// Individual component import (smaller bundle)
import { Button } from "@myapp/ui/button";

// CSS import
import "@myapp/ui/styles.css";
```

---

## 7. Key Takeaways (4 minutes)

### Summary Visual

```
Traditional Multi-Repo:

  ui-library repo          web-app repo
  ┌───────────┐            ┌───────────┐
  │ Fix bug   │            │           │
  │    ↓      │            │           │
  │ Publish   │───npm───→  │ Install   │
  │    ↓      │            │    ↓      │
  │ Wait...   │            │ Test      │
  └───────────┘            └───────────┘
        ⏱ 15-30 min per cycle


Monorepo:

  ┌─────────────────────────────────────┐
  │           One Repository            │
  │                                     │
  │  packages/ui/    →    apps/web/     │
  │  ┌──────────┐         ┌──────────┐  │
  │  │ Fix bug  │ symlink │ Instant  │  │
  │  │ Save     │────────→│ Update   │  │
  │  └──────────┘         └──────────┘  │
  │                                     │
  │        ⏱ 1-2 seconds               │
  └─────────────────────────────────────┘
```

### Three Things to Remember

1. **Monorepos eliminate the publish cycle** — `workspace:*` creates symlinks so changes reflect instantly. No npm publish, no version bumps, no waiting.

2. **Turborepo orchestrates builds intelligently** — The `^build` syntax ensures dependencies build first. Caching skips unchanged packages.

3. **Package resolution follows a clear path** — Symlinks → package.json → exports → actual files. Understanding this helps debug "module not found" errors.

### The Architecture Connection

```
┌─────────────────────────────────────────────────────────────────┐
│                      MONOREPO STRUCTURE                          │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│   packages/                          apps/                       │
│   ┌─────────────────────┐            ┌─────────────────────┐    │
│   │ tokens/ (Layer 1)   │            │ web/                │    │
│   │ ├─ colors.json      │            │ ├─ app/page.tsx     │    │
│   │ ├─ spacing.json     │◄───────────│ │   (Layer 5)       │    │
│   │ └─ build/css/       │            │ └─ components/      │    │
│   ├─────────────────────│            │     (Layer 4)       │    │
│   │ ui/ (Layers 2-3)    │◄───────────│                     │    │
│   │ ├─ Button.tsx       │            └─────────────────────┘    │
│   │ ├─ Input.tsx        │                                       │
│   │ └─ Card.tsx         │            ┌─────────────────────┐    │
│   ├─────────────────────│            │ docs/               │    │
│   │ config/             │            │ └─ Storybook        │    │
│   │ └─ tsconfig/        │            └─────────────────────┘    │
│   └─────────────────────┘                                       │
│                                                                  │
│   pnpm-workspace.yaml: Links everything together                 │
│   turbo.json: Orchestrates build order                          │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

## Looking Ahead

In the **lab section**, you'll:
- Initialize a Turborepo monorepo from scratch
- Create shared TypeScript and Tailwind configurations
- Connect your tokens and UI packages to a Next.js app
- Experience the instant hot reload when editing packages
- Trace the import resolution path yourself
- Compare your structure with Cal.com and Supabase

In **Chapter 5**, we'll build app-specific components (Layer 4)—components that live in `apps/web/components/` and combine your UI primitives with business logic.

---

## Discussion Questions for Class

1. You're joining a company with a design system published to npm. Would you advocate for migrating to a monorepo? What are the trade-offs?

2. Your monorepo has 50 packages. A change to `tokens` triggers rebuilds of all 50. How does Turborepo's caching help?

3. A new developer says "I just want to work on the web app, not the UI library." How does a monorepo structure help or hinder this?

4. What happens if two packages in your monorepo depend on different versions of React?

---

## Common Misconceptions

### "Monorepos mean everyone works on everything"

**Correction:** You can still have code ownership and different teams working on different packages. The monorepo just makes collaboration easier when needed.

### "Monorepos are slow because everything builds together"

**Correction:** Turborepo's caching means only changed packages rebuild. A 50-package monorepo can build in seconds if only one package changed.

### "workspace:* means no versioning"

**Correction:** Internal packages can still have versions. When you publish to npm, `workspace:*` gets replaced with actual versions. Monorepos and npm publishing aren't mutually exclusive.

### "I need to learn everything about Turborepo"

**Correction:** The basic config (`dependsOn: ["^build"]`) handles 90% of use cases. Start simple, add complexity only when needed.

---

## Troubleshooting Guide

### "Cannot find module '@myapp/ui'"

1. Check `packages/ui/package.json` has correct `"name"` field
2. Run `pnpm install` from root
3. Verify symlink exists: `ls -la node_modules/@myapp/`

### "Build order is wrong"

Check `turbo.json`:
```json
{
  "tasks": {
    "build": {
      "dependsOn": ["^build"]  // The ^ is required!
    }
  }
}
```

### "Changes don't reflect in the app"

1. Check you're editing the correct file (packages/ui, not node_modules)
2. Verify `pnpm dev` is running
3. Check Tailwind config includes the package path

### "TypeScript errors in workspace packages"

Ensure `tsconfig.json` extends the shared config:
```json
{
  "extends": "@myapp/config/tsconfig/react"
}
```

---

## Additional Resources

- **Tool:** [Turborepo Documentation](https://turbo.build/repo/docs)
- **Tool:** [pnpm Workspaces](https://pnpm.io/workspaces)
- **Article:** "Monorepos: Please don't!" vs "Monorepos: Please do!" (read both)
- **Video:** Jared Palmer's "Turborepo in 10 Minutes"
- **Example:** [Cal.com GitHub Repository](https://github.com/calcom/cal.com)
- **Example:** [Supabase GitHub Repository](https://github.com/supabase/supabase)

---

## Preparation for Lab

Before the lab, ensure you have:
- [ ] pnpm installed globally (`npm install -g pnpm`)
- [ ] Node.js v18+ installed
- [ ] Completed Chapters 1-3 (tokens and UI packages)
- [ ] Git configured (for commits)
- [ ] A code editor with TypeScript support
