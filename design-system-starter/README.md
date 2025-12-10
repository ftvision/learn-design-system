# Design System Starter

Copy this folder to bootstrap a design system with AI coding agents.

## Contents

| File | Purpose |
|------|---------|
| `AI_AGENT_PROMPT.md` | Copy-paste prompt for quick initialization |
| `BOOTSTRAP_GUIDE.md` | Detailed phase-by-phase implementation guide |
| `README_BOOTSTRAP.md` | Philosophy and architecture overview |

## Quick Decision Guide

| Your Goal | Use This File | How |
|-----------|---------------|-----|
| Initialize a new project FAST | `AI_AGENT_PROMPT.md` | Copy prompt → Paste to AI agent |
| Learn step-by-step with AI assistance | `BOOTSTRAP_GUIDE.md` | Reference each phase during development |
| Understand the overall approach | `README_BOOTSTRAP.md` | Read for context and philosophy |

---

## Method 1: Quick Initialization (Recommended)

**Best for:** Starting a new project quickly, experienced developers, AI-assisted development

### Steps

1. **Open your AI coding agent** (Claude Code, Cursor, Copilot Chat, etc.)

2. **Navigate to your target directory**
   ```bash
   cd /path/to/your/projects
   mkdir my-design-system
   cd my-design-system
   ```

3. **Copy the entire prompt** from `AI_AGENT_PROMPT.md` (everything inside the code block under "## The Prompt")

4. **Paste to your AI agent** with a prefix like:
   ```
   Please execute the following instructions to bootstrap a design system:

   [paste prompt here]
   ```

5. **Wait for completion** (typically 3-5 minutes)

6. **Verify the setup**
   ```bash
   pnpm install
   pnpm --filter @myapp/tokens build
   pnpm dev
   ```

7. **Open in browser**
   - Web app: http://localhost:3000
   - Storybook: http://localhost:6006

### What You Get

```
my-design-system/
├── packages/
│   ├── tokens/     # Design tokens (JSON → CSS/JS)
│   ├── ui/         # Button component + extension guide
│   └── config/     # Shared TypeScript & Tailwind configs
├── apps/
│   ├── web/        # Next.js demo app
│   └── docs/       # Storybook documentation
└── [configs]       # turbo.json, pnpm-workspace.yaml, etc.
```

---

## Method 2: Guided Learning

**Best for:** Learning design system concepts, understanding the "why", controlled step-by-step implementation

### Steps

1. **Read the overview** in `README_BOOTSTRAP.md` to understand the philosophy

2. **Start a conversation** with your AI agent:
   ```
   I want to build a design system step by step. I have a guide
   in BOOTSTRAP_GUIDE.md. Let's work through Phase 1 together.
   Please read BOOTSTRAP_GUIDE.md first.
   ```

3. **Work through phases** one at a time:
   - Phase 1: Monorepo Scaffolding
   - Phase 2: Design Tokens Foundation
   - Phase 3: Shared Config Package
   - Phase 4: UI Package Skeleton
   - Phase 5: Web Application Skeleton
   - Phase 6: Storybook Setup
   - Phase 7: Developer Documentation

4. **Validate each phase** before proceeding:
   ```
   Let's verify Phase 2 is complete:
   - Does pnpm --filter @myapp/tokens build succeed?
   - Are CSS variables generated in build/css/variables.css?
   - Are JS exports generated in build/js/tokens.js?
   ```

5. **Ask questions** as you go:
   ```
   Why do we use Style Dictionary instead of just writing CSS variables directly?
   ```

### Benefits

- Deeper understanding of design system architecture
- Opportunity to customize as you build
- Learn the 5-layer model through practice
- Catch issues early in each phase

---

## Method 3: Hybrid Approach

**Best for:** Quick start with selective deep-dives

1. **Initialize quickly** using Method 1 (AI_AGENT_PROMPT.md)

2. **Study specific phases** from BOOTSTRAP_GUIDE.md that interest you:
   ```
   I've initialized a design system. Now explain Phase 2 (tokens)
   in detail. Why did you set up Style Dictionary this way?
   ```

3. **Reference documentation** when extending:
   ```
   I want to add an Input component. Walk me through the process
   following the patterns in packages/ui/README.md
   ```

---

## Common Workflows After Setup

### Adding Design Tokens

```bash
# 1. Edit token files
vim packages/tokens/src/colors.json

# Example: Add brand color
{
  "color": {
    "brand": {
      "primary": { "value": "#3B82F6" },
      "secondary": { "value": "#10B981" }
    }
  }
}

# 2. Rebuild tokens
pnpm --filter @myapp/tokens build

# 3. Use in components
# CSS: var(--color-brand-primary)
# JS: import { colorBrandPrimary } from '@myapp/tokens'
```

### Adding a UI Component

Ask your AI agent:
```
Add an Input component to packages/ui following the Button pattern.
Use CVA for variants, forwardRef for ref forwarding, and create
a Storybook story for it.
```

The agent will:
1. Create `packages/ui/src/components/Input.tsx`
2. Export from `packages/ui/src/index.tsx`
3. Create `apps/docs/stories/Input.stories.tsx`

### Adding an App Component

Ask your AI agent:
```
Create a UserCard component in apps/web/components that uses
Button and displays user name and avatar. This is a Layer 4
component with business logic.
```

---

## Best Practices for AI Agent Interaction

### DO

- **Be specific about file locations**
  ```
  Create the Input component at packages/ui/src/components/Input.tsx
  ```

- **Reference the architecture**
  ```
  This should be a Layer 2 primitive with no business logic
  ```

- **Ask for validation**
  ```
  After creating, verify Tailwind styles apply correctly
  ```

- **Request documentation updates**
  ```
  Also update the index.tsx exports and create a Storybook story
  ```

### DON'T

- **Don't ask for too many components at once**
  ```
  # Bad: Create Button, Input, Card, Badge, Avatar, Select, Modal...
  # Good: Create an Input component following the Button pattern
  ```

- **Don't skip the token build step**
  ```bash
  # Always run after token changes
  pnpm --filter @myapp/tokens build
  ```

- **Don't put business logic in packages/ui**
  ```
  # Bad: A UserCard component in packages/ui
  # Good: A generic Card in packages/ui, UserCard in apps/web
  ```

---

## Troubleshooting

### "Styles not applying to components"

```bash
# Check 1: Tailwind content paths in apps/web/tailwind.config.js
content: [
  './src/**/*.{ts,tsx}',
  '../../packages/ui/src/**/*.{ts,tsx}'  # Must include UI package
]

# Check 2: CSS import order in apps/web/app/globals.css
@import '@myapp/tokens/build/css/variables.css';  # Must be first
@tailwind base;
@tailwind components;
@tailwind utilities;

# Check 3: Next.js config includes transpile packages
# apps/web/next.config.js
module.exports = {
  transpilePackages: ['@myapp/ui', '@myapp/tokens']
};
```

### "Module not found: @myapp/..."

```bash
# Clear and reinstall
pnpm clean
pnpm install

# Verify workspace dependencies use workspace:*
# In package.json files:
"@myapp/ui": "workspace:*"  # Correct
"@myapp/ui": "^1.0.0"       # Wrong
```

### "Token build fails"

```bash
# Check Style Dictionary version
pnpm --filter @myapp/tokens list style-dictionary

# Verify JSON syntax in token files
pnpm exec jsonlint packages/tokens/src/colors.json
```

### "Storybook doesn't show styles"

```bash
# Check Storybook has Tailwind configured
# apps/docs/.storybook/preview.ts should import CSS
import '../src/styles.css';

# Verify styles.css includes Tailwind
# apps/docs/src/styles.css
@tailwind base;
@tailwind components;
@tailwind utilities;
```

---

## FAQ

### Q: Why only one Button component?

**A:** Every app is different. Instead of generating 20+ components you might not use, we provide one example (Button) that demonstrates the pattern. You add components as you need them, ensuring:
- No unused code in your bundle
- Components match your actual needs
- You understand the pattern through practice

### Q: When should I use packages/ui vs apps/web/components?

**A:** Use this decision tree:

```
Does the component have business logic (users, products, orders)?
├── Yes → apps/web/components/ (Layer 4)
└── No → Is it reusable across multiple apps?
    ├── Yes → packages/ui/ (Layer 2 or 3)
    └── No → Keep it in the page that uses it (Layer 5)
```

### Q: Can I use a different component library (Radix, Shadcn)?

**A:** Yes! The scaffold is flexible. You can:
1. Replace CVA with Radix primitives
2. Copy Shadcn components into packages/ui
3. Mix approaches as needed

Just maintain the layer architecture (tokens → primitives → patterns → app components).

### Q: Should I commit the generated token outputs?

**A:** Usually no. Add to `.gitignore`:
```
packages/tokens/build/
```

Build tokens in CI/CD instead. However, if your team doesn't have CI/CD yet, committing build outputs is acceptable.

### Q: How do I add a new app (mobile, admin)?

```bash
# 1. Create the app
mkdir apps/admin

# 2. Initialize (copy web structure or use Next.js create)
# 3. Add workspace dependencies
{
  "name": "@myapp/admin",
  "dependencies": {
    "@myapp/ui": "workspace:*",
    "@myapp/tokens": "workspace:*"
  }
}

# 4. Configure Tailwind and Next.js like apps/web
# 5. Build tokens first, then run
pnpm --filter @myapp/tokens build
pnpm --filter @myapp/admin dev
```

---

## Quick Reference Card

### Initial Setup
```bash
# Copy AI_AGENT_PROMPT.md prompt to AI agent, then:
pnpm install
pnpm --filter @myapp/tokens build
pnpm dev
```

### Daily Development
```bash
pnpm dev                              # Start all apps
pnpm --filter @myapp/web dev          # Start only web app
pnpm --filter @myapp/docs dev         # Start only Storybook
```

### Adding Things
```bash
# Token: Edit packages/tokens/src/*.json → pnpm --filter @myapp/tokens build
# UI Component: Create in packages/ui/src/components/ → Export from index.tsx
# App Component: Create in apps/web/components/
# Story: Create in apps/docs/stories/
```

### Building
```bash
pnpm build                            # Build everything
pnpm --filter @myapp/tokens build     # Build only tokens
pnpm clean                            # Remove all build artifacts
```

### Key Files
```
packages/tokens/src/*.json           # Design tokens
packages/ui/src/components/*.tsx     # Reusable components
packages/ui/src/index.tsx            # UI exports
apps/web/app/page.tsx                # App pages
apps/web/components/*.tsx            # App-specific components
apps/docs/stories/*.stories.tsx      # Component documentation
```

---

## Architecture Overview

```
Layer 5: Pages/Views (apps/web/app/)
         Full pages and routes

Layer 4: App Components (apps/web/components/)
         Business logic, domain knowledge
         Example: UserCard, CheckoutSummary

Layer 3: Pattern Components (packages/ui/)
         Complex reusable patterns
         Example: DataTable, Modal
         (Add as needed)

Layer 2: Primitive Components (packages/ui/)
         Generic UI elements
         Example: Button (provided)
         Add: Input, Card, Badge as needed

Layer 1: Design Tokens (packages/tokens/)
         Single source of truth
         Minimal starters (customize to your brand)
```

**Key Rule:** Lower layers never import from higher layers.

---

## Philosophy

**Scaffold, don't prescribe.**

We create the foundation and one example component (Button). You add components as your app needs them.

---

Version: 2.0.0 | Course: Design Systems - Tallinn v2
