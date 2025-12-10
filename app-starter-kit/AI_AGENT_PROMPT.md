# AI Agent Quick Start Prompt

Copy this prompt to any AI coding agent to bootstrap a design system foundation.

---

## The Prompt

```
Initialize a design system monorepo foundation following these specifications:

PHILOSOPHY: Scaffold structure and patterns, not a comprehensive component library.
The agent creates the foundation. The user extends it with their specific components.

TECH STACK:
- Turborepo + pnpm (monorepo orchestration)
- React 18 + TypeScript 5 (strict mode)
- Tailwind CSS 3 (utility-first styling)
- Style Dictionary (token transformation)
- Next.js 14 App Router (example app)
- Storybook 7 (documentation)
- CVA (component variants)

STRUCTURE:
design-system/
├── packages/
│   ├── tokens/      Design tokens (JSON → CSS/JS/iOS/Android)
│   ├── ui/          Component library (1-2 examples only)
│   └── config/      Shared TypeScript & Tailwind configs
├── apps/
│   ├── web/         Next.js app (demonstrating consumption)
│   └── docs/        Storybook (ready for component docs)
└── [root configs]   turbo.json, pnpm-workspace.yaml, package.json

WHAT TO CREATE:

1. MONOREPO SCAFFOLDING
   - Root package.json with scripts: dev, build, lint, clean
   - pnpm-workspace.yaml defining packages/*, apps/*
   - turbo.json with tasks for build (with dependsOn) and dev
   - .gitignore for node_modules, dist, build, .next, .turbo

2. TOKENS PACKAGE (@myapp/tokens)
   - Style Dictionary config generating CSS vars and JS exports
   - MINIMAL starter tokens (4 grays, 4 spacing values, 3 font sizes)
   - README guiding users to add their own brand tokens
   - package.json with build script
   - Do NOT create extensive color palettes or spacing scales

3. CONFIG PACKAGE (@myapp/config)
   - tsconfig/base.json (strict TypeScript)
   - tsconfig/react.json (extends base, adds DOM)
   - tsconfig/nextjs.json (extends react)
   - tailwind.config.js (base config for users to extend)
   - No build step needed

4. UI PACKAGE (@myapp/ui)
   - src/lib/utils.ts with cn() utility (clsx + tailwind-merge)
   - src/components/Button.tsx ONLY (demonstrates CVA pattern)
     * 2 variants: primary, secondary
     * 2 sizes: sm, md
     * Uses forwardRef, full TypeScript types
   - src/index.tsx exporting Button and cn
   - README with detailed guide on adding new components
   - Do NOT create Input, Card, Badge, Avatar, etc.
   - Users will create components as they need them

5. WEB APP (@myapp/web)
   - Next.js 14 with App Router
   - next.config.js with transpilePackages: ['@myapp/ui', '@myapp/tokens']
   - tailwind.config.js with content: ['./src/**/*.tsx', '../../packages/ui/src/**/*.tsx']
   - app/globals.css importing token CSS before Tailwind
   - app/page.tsx showing Button variants only
   - components/README.md explaining Layer 4 (app components) pattern
   - Do NOT create pre-built app components

6. DOCS APP (@myapp/docs)
   - Storybook 7 with Vite
   - stories/Button.stories.tsx with CSF 3 format
   - stories/README.md explaining how to add stories
   - Do NOT create stories for components that don't exist

7. COMPREHENSIVE DOCUMENTATION
   - Root README.md:
     * 5-layer architecture diagram
     * Getting started (install, build tokens, run dev)
     * Project structure
     * Links to package READMEs
   - CONTRIBUTING.md:
     * Architecture principles (5-layer model)
     * When to create tokens vs primitives vs app components
     * "Don't over-abstract" guidance
     * Component development workflow
   - Each package has README with extension guides

CRITICAL CONFIGURATIONS:

UI Package:
- dependencies: @myapp/tokens, CVA, clsx, tailwind-merge
- devDependencies: @myapp/config, react, tailwindcss, typescript
- peerDependencies: react ^18.2.0

Web App:
- MUST transpile @myapp/ui and @myapp/tokens in next.config.js
- MUST include UI package in Tailwind content paths
- MUST import token CSS before Tailwind in globals.css

All Packages:
- Use workspace:* for internal dependencies
- TypeScript strict mode enabled
- Follow 5-layer architecture principles

VALIDATION:
After creation, verify:
✓ pnpm install succeeds
✓ pnpm --filter @myapp/tokens build generates CSS and JS
✓ pnpm --filter @myapp/web dev starts on :3000
✓ pnpm --filter @myapp/docs dev starts on :6006
✓ pnpm dev runs both apps concurrently
✓ Button component renders with Tailwind styles
✓ Only Button component exists (not 20 components)
✓ READMEs guide extension, don't prescribe implementation

WHAT NOT TO DO:
❌ Do NOT create Input, Card, Badge, Avatar components
❌ Do NOT generate extensive token values (leave for users)
❌ Do NOT create app-specific business logic
❌ Do NOT make design decisions (colors, spacing)
❌ Do NOT create form patterns or validation
❌ Do NOT add auth/API integration examples

WHY THIS APPROACH:
Every app is different. Creating a bloated library wastes tokens and creates
components users won't use. Instead, create a solid foundation with ONE example
(Button) showing the pattern. Users extend it as needed for their app.

START IMPLEMENTATION:
Begin with Phase 1 (monorepo scaffolding) from BOOTSTRAP_GUIDE.md.
Follow all phases sequentially. Test each phase before proceeding.
```

---

## What You'll Get

A **minimal, production-ready foundation** with:

1. ✅ Working monorepo (Turborepo + pnpm)
2. ✅ Token transformation pipeline (Style Dictionary)
3. ✅ Button component demonstrating CVA pattern
4. ✅ Next.js app consuming the UI package
5. ✅ Storybook ready for documentation
6. ✅ Comprehensive guides for extension
7. ✅ 5-layer architecture documented

**Not included** (users add as needed):
- Additional components (Input, Card, etc.)
- Extensive design tokens
- Form patterns
- Business logic
- API integrations

---

## After Initialization

### 1. Customize Design Tokens
```bash
# Edit starter tokens
vim packages/tokens/src/colors.json
vim packages/tokens/src/spacing.json
vim packages/tokens/src/typography.json

# Rebuild
pnpm --filter @myapp/tokens build
```

### 2. Add Components as Needed
```bash
# Create Input component following Button pattern
# packages/ui/src/components/Input.tsx

# Export from index
# packages/ui/src/index.tsx

# Document in Storybook
# apps/docs/stories/Input.stories.tsx
```

### 3. Build App Components
```bash
# Create business-specific components
# apps/web/components/UserCard.tsx
# apps/web/components/ProductList.tsx

# These use UI primitives but have business logic
```

---

## Time Estimate

- **AI Agent**: 3-5 minutes
- **Human Following Guide**: 30-45 minutes

---

## Architecture Reference

```
Layer 5: Pages (apps/web/app/)
         Route handlers and full pages

Layer 4: App Components (apps/web/components/)
         Business logic, domain knowledge
         Example: UserCard, CheckoutSummary

Layer 3: Pattern Components (packages/ui/ - complex)
         Reusable patterns, no business logic
         Example: DataTable, Modal
         (Start empty, add as needed)

Layer 2: Primitive Components (packages/ui/ - basic)
         Generic UI elements, no business logic
         Example: Button (provided)
         Add: Input, Card, Badge as needed

Layer 1: Design Tokens (packages/tokens/)
         Single source of truth
         Minimal starters (customize to your brand)
```

**Key Rule**: Lower layers never import from higher layers.

---

## Extension Guides

After scaffolding, see these guides:

- **Add Tokens**: `packages/tokens/README.md`
- **Add UI Components**: `packages/ui/README.md`
- **Add App Components**: `apps/web/src/components/README.md`
- **Document Components**: `apps/docs/stories/README.md`
- **Architecture Principles**: `CONTRIBUTING.md`

---

## Troubleshooting

**Styles not applying:**
- Check Tailwind content includes `../../packages/ui/src/**/*.tsx`
- Verify globals.css imports tokens before Tailwind
- Confirm next.config.js transpiles packages

**Build fails:**
- Run `pnpm --filter @myapp/tokens build` first
- Clear cache: `rm -rf .turbo`
- Reinstall: `pnpm clean && pnpm install`

**Type errors:**
- Check workspace:* dependencies resolve
- Verify TypeScript configs extend correctly
- Ensure strict mode is enabled

---

## Comparison: Before vs After

### ❌ Old Approach (Bloated)
```
packages/ui/src/components/
├── Button.tsx (6 variants, 4 sizes)
├── Input.tsx (with validation)
├── Card.tsx (compound components)
├── Badge.tsx (6 variants)
├── Avatar.tsx (5 sizes, fallbacks)
├── Select.tsx (dropdown logic)
├── Modal.tsx (portal, focus trap)
├── Table.tsx (sorting, pagination)
├── Toast.tsx (queue management)
├── Tooltip.tsx (positioning)
... 20+ more components
```

**Problems:**
- 80% unused in typical app
- Makes assumptions about use cases
- Increases bundle size
- Harder to customize
- Forces design decisions

### ✅ New Approach (Scaffold)
```
packages/ui/src/components/
└── Button.tsx (demonstrates pattern)

+ READMEs explaining how to add:
  - Input (when you need forms)
  - Card (when you need containers)
  - Badge (when you need labels)
  - etc.
```

**Benefits:**
- Start small, grow as needed
- No unused code
- Users make design decisions
- Faster setup
- Clear patterns to follow

---

## Real-World Usage

### Startup Building MVP
```bash
# Day 1: Initialize
pnpm create design-system my-app

# Day 2-3: Add tokens matching brand
# Edit colors, spacing, typography

# Week 1: Add 5 components as needed
# Button (provided), Input, Card, Badge, Avatar

# Month 1: 10-15 components total
# Only what the app actually uses
```

### Enterprise Design System Team
```bash
# Sprint 1: Initialize foundation
# Sprint 2: Define comprehensive tokens
# Sprint 3-6: Build components iteratively
# Sprint 7+: Add pattern components (forms, tables)

# Result: 30-50 components built over time
# Each validated by real use cases
```

---

## Success Metrics

After using this approach, you should have:

1. ✅ **Clean foundation** in minutes, not hours
2. ✅ **Clear patterns** to follow for new components
3. ✅ **No unused code** in your bundles
4. ✅ **Design control** (you choose colors, spacing)
5. ✅ **Architecture understanding** (5-layer model)
6. ✅ **Fast onboarding** (guides, not guesswork)

---

## Related Files

- `BOOTSTRAP_GUIDE.md` - Detailed phase-by-phase guide
- `/chapters/` - Full design systems course
- `/references/cal.com` - Real-world monorepo example
- `/references/supabase` - Production design system example

---

## Feedback

Found issues or have suggestions? The scaffolding approach is intentionally
minimal. If you find yourself needing a component repeatedly, that's a good
signal it belongs in the guide as an example or reference.

---

**Version**: 2.0.0 (Scaffold-focused)
**Last Updated**: 2025-12-10
**Philosophy**: Give them the tools, not the toolbox
**Course**: Design Systems - Tallinn v2