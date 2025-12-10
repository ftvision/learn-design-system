# Bootstrap Your Design System

Quick links to get started with creating a design system foundation.

---

## 🚀 For AI Coding Agents

**Want to initialize a new design system project?**

👉 **Copy the prompt from [`AI_AGENT_PROMPT.md`](./AI_AGENT_PROMPT.md)**

This gives you:
- Monorepo foundation (Turborepo + pnpm)
- Token transformation pipeline (Style Dictionary)
- Button component showing CVA pattern
- Next.js app + Storybook ready to go
- Comprehensive extension guides

**Time: 3-5 minutes for AI agents**

---

## 📚 For Humans

**Want to understand the architecture and build it yourself?**

👉 **Read [`BOOTSTRAP_GUIDE.md`](./BOOTSTRAP_GUIDE.md)**

This explains:
- 7 implementation phases with exact configs
- 5-layer architecture principles
- When to create tokens vs primitives vs app components
- Common pitfalls and troubleshooting
- Extension patterns

**Time: 30-45 minutes to follow guide**

---

## 🎯 Philosophy: Scaffold, Don't Prescribe

Unlike typical "component library" tutorials that generate 20+ pre-built components, this approach:

### ✅ What We Create
- Monorepo structure and build tools
- Token transformation pipeline
- **ONE** Button component (demonstrates pattern)
- Clear guides on adding your own components
- Documentation on architecture decisions

### ❌ What We Don't Create
- Dozens of pre-built components you may not need
- Design decisions (your brand colors, spacing)
- Business logic or app-specific components
- Form validation patterns
- Auth/API integration examples

### 💡 Why This Approach?

**Every app is different.** Creating a bloated component library:
- Wastes AI tokens generating unused code
- Makes assumptions about your use cases
- Forces design decisions you'll override
- Increases bundle size unnecessarily
- Makes customization harder

**Instead:** Create a solid foundation with clear patterns, then users extend it with components they actually need.

---

## 📊 Comparison

### Old Approach (Bloated)
```bash
packages/ui/src/components/
├── Button.tsx (6 variants, 4 sizes)
├── Input.tsx (with validation)
├── Card.tsx (compound)
├── Badge.tsx (6 variants)
├── Avatar.tsx (5 sizes)
├── Select.tsx
├── Modal.tsx
├── Table.tsx
├── Toast.tsx
├── Tooltip.tsx
... 20+ more components

Result: 80% unused, hard to customize
```

### New Approach (Scaffold)
```bash
packages/ui/src/components/
└── Button.tsx (demonstrates pattern)

+ READMEs explaining how to add:
  - Input (when you need forms)
  - Card (when you need containers)
  - etc.

Result: Only what you need, easy to customize
```

---

## 🏗️ Architecture Overview

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

## 🎓 Learning Path

### If You're New to Design Systems
1. Start with [Chapter 1: Understanding Design Systems](./chapters/01-understanding/)
2. Learn about [Design Tokens](./chapters/02-design-tokens/)
3. Explore [Primitive Components](./chapters/03-primitive-components/)
4. Understand [Monorepo Architecture](./chapters/04-monorepo-architecture/)
5. Then use the bootstrap guide

### If You Just Want to Start Building
1. Copy prompt from [`AI_AGENT_PROMPT.md`](./AI_AGENT_PROMPT.md)
2. Paste to your AI coding agent
3. Customize tokens to match your brand
4. Add components as you need them

---

## 📦 What You Get After Bootstrap

### Working Monorepo
```bash
pnpm install           # Install dependencies
pnpm dev              # Start all apps
pnpm build            # Build everything
```

### Token System
```bash
# Edit your brand tokens
packages/tokens/src/colors.json
packages/tokens/src/spacing.json
packages/tokens/src/typography.json

# Rebuild
pnpm --filter @myapp/tokens build
```

### Component Pattern
```typescript
// packages/ui/src/components/Button.tsx
// Shows CVA pattern, forwardRef, TypeScript types
// Copy this pattern for new components
```

### Documentation
```bash
pnpm --filter @myapp/docs dev
# Visit http://localhost:6006
# Add stories for each new component
```

---

## 🛠️ Common Tasks After Setup

### Add a Design Token
```bash
# 1. Edit packages/tokens/src/colors.json
{
  "color": {
    "brand": {
      "primary": { "value": "#3B82F6" }
    }
  }
}

# 2. Rebuild
pnpm --filter @myapp/tokens build

# 3. Use in components
className="bg-blue-600"  # Or use CSS var --color-brand-primary
```

### Add a UI Component
```bash
# 1. Create packages/ui/src/components/Input.tsx
#    Follow Button.tsx pattern (CVA + forwardRef)

# 2. Export from packages/ui/src/index.tsx
export { Input } from './components/Input';

# 3. Create story apps/docs/stories/Input.stories.tsx

# 4. Use in app
import { Input } from '@myapp/ui';
```

### Add an App Component
```bash
# 1. Create apps/web/components/UserCard.tsx
import { Card, Avatar, Button } from '@myapp/ui';
import type { User } from '@/types';

export function UserCard({ user }: { user: User }) {
  return (
    <Card>
      <Avatar src={user.avatar} />
      <h3>{user.name}</h3>
      <Button>Edit</Button>
    </Card>
  );
}

# 2. Use in pages
import { UserCard } from '@/components/UserCard';
```

---

## ⏱️ Time Estimates

| Task | AI Agent | Human |
|------|----------|-------|
| Initial scaffold | 3-5 min | 30-45 min |
| Add design tokens | 1 min | 5 min |
| Add UI component | 2 min | 10-15 min |
| Add app component | 1 min | 5-10 min |

---

## 🔍 Real-World Examples

### Startup MVP (Week 1)
```bash
Day 1: Bootstrap foundation
Day 2-3: Customize tokens (brand colors)
Day 4-5: Add 5 components (Button, Input, Card, Badge, Avatar)
Day 6-7: Build app components (UserCard, ProductCard)

Result: Minimal design system with only needed components
```

### Enterprise Team (Month 1)
```bash
Sprint 1: Bootstrap + define comprehensive tokens
Sprint 2: Build 10 primitive components
Sprint 3: Create 5 pattern components (forms, tables)
Sprint 4: Build app-specific components

Result: Production design system with 15-20 components
```

---

## 📖 Documentation Structure

After bootstrap, you'll have these guides:

```
/
├── README.md                           # Getting started
├── CONTRIBUTING.md                     # Architecture principles
├── packages/
│   ├── tokens/README.md               # How to add tokens
│   ├── ui/README.md                   # How to add UI components
│   └── config/README.md               # Shared configs
├── apps/
│   ├── web/src/components/README.md   # How to add app components
│   └── docs/stories/README.md         # How to document
```

Each README guides you on extending that part of the system.

---

## ✅ Validation Checklist

After bootstrap, verify:

- [ ] `pnpm install` succeeds
- [ ] `pnpm --filter @myapp/tokens build` generates CSS and JS
- [ ] `pnpm --filter @myapp/web dev` starts on localhost:3000
- [ ] `pnpm --filter @myapp/docs dev` starts on localhost:6006
- [ ] Button component renders with Tailwind styles
- [ ] Only Button component exists (not 20+ components)
- [ ] Each package has README with extension guide
- [ ] Root README explains architecture

---

## 🐛 Troubleshooting

### Styles Not Applying
```bash
# Check Tailwind content paths
# apps/web/tailwind.config.js must include:
content: [
  './src/**/*.{ts,tsx}',
  '../../packages/ui/src/**/*.{ts,tsx}'  # This line is critical
]

# Check CSS imports
# apps/web/app/globals.css must have:
@import '@myapp/tokens/build/css/variables.css';  # Before Tailwind
@tailwind base;
@tailwind components;
@tailwind utilities;
```

### Build Fails
```bash
# Build tokens first
pnpm --filter @myapp/tokens build

# Clear cache
rm -rf .turbo
rm -rf node_modules
pnpm install
```

### TypeScript Errors
```bash
# Check workspace dependencies
# All internal deps should use workspace:*
"@myapp/ui": "workspace:*"

# Verify TypeScript configs extend correctly
# packages/ui/tsconfig.json should extend @myapp/config
```

---

## 🎯 Success Metrics

You'll know the bootstrap succeeded when:

1. ✅ Foundation works in 5 minutes (AI) or 45 minutes (manual)
2. ✅ You can add a new token in 1 minute
3. ✅ You can add a new component in 10 minutes
4. ✅ No unused code in your bundles
5. ✅ Clear patterns to follow for everything
6. ✅ Documentation guides, doesn't prescribe

---

## 🔗 Related Resources

### In This Repo
- [`AI_AGENT_PROMPT.md`](./AI_AGENT_PROMPT.md) - Copy-paste prompt for agents
- [`BOOTSTRAP_GUIDE.md`](./BOOTSTRAP_GUIDE.md) - Detailed phase-by-phase guide
- [`chapters/`](./chapters/) - Full design systems course (9 chapters)
- [`references/cal.com`](./references/cal.com) - Real-world monorepo example
- [`references/supabase`](./references/supabase) - Production design system

### External
- [Turborepo Docs](https://turbo.build/repo/docs)
- [Style Dictionary](https://amzn.github.io/style-dictionary)
- [CVA Docs](https://cva.style/docs)
- [Tailwind CSS](https://tailwindcss.com/docs)

---

## 💬 Questions?

**For design system concepts:** See [chapters/](./chapters/)
**For bootstrap issues:** Check [BOOTSTRAP_GUIDE.md](./BOOTSTRAP_GUIDE.md) troubleshooting
**For architecture decisions:** Read [CONTRIBUTING.md](./CONTRIBUTING.md)

---

**Version**: 2.0.0
**Philosophy**: Scaffold, don't prescribe
**Course**: Design Systems - Tallinn v2