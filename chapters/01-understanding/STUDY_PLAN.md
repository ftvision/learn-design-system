# Chapter 1 Study Plan: Understanding Design Systems

## Part 1: Theory (30 minutes)

### 1.1 What is a Design System?

A design system is **not** just a component library. It's a complete system with:

| Layer | What It Contains | Example |
|-------|-----------------|---------|
| Design Tokens | Colors, spacing, typography values | `--color-primary-500: #2196F3` |
| Primitive Components | Basic UI building blocks | `<Button>`, `<Input>`, `<Card>` |
| Pattern Components | Composed, reusable patterns | `<AuthForm>`, `<DataTable>` |
| App Components | Product-specific components | `<BookingCard>`, `<UserProfile>` |
| Pages | Complete screens | `/dashboard`, `/settings` |

### 1.2 The Key Insight

**Generic UI Libraries** (Chakra, Radix, shadcn):
- Provide Layers 1-3
- Published to npm
- Used by many different products
- You customize them for your needs

**Product Design Systems** (Cal.com's internal system):
- Include Layers 1-5
- Live in a monorepo with the app
- Specific to one product
- Consumed by the app in the same repo

### 1.3 Why Monorepos?

```
my-product/
├── packages/
│   └── ui/                 # Layers 1-3 (shared)
├── apps/
│   └── web/
│       ├── components/     # Layer 4 (app-specific)
│       └── app/            # Layer 5 (pages)
└── turbo.json
```

Benefits:
- Change `packages/ui/Button` → immediately available in `apps/web/`
- No npm publishing for internal packages
- Shared TypeScript types
- One `git clone` gets everything

---

## Part 2: Lab - Explore Cal.com (1 hour)

### Lab 1.1: Clone and Orient

```bash
# Clone the repository
git clone https://github.com/calcom/cal.com
cd cal.com

# Look at the top-level structure
ls -la
```

**Questions to answer:**
1. What directories do you see at the top level?
2. Find the `packages/` directory - what's inside?
3. Find the `apps/` directory - what's inside?

### Lab 1.2: Find the Design System (Layer 2)

```bash
# Navigate to the UI package
ls packages/ui/

# Look at the components
ls packages/ui/components/
```

**Exercise:** Open `packages/ui/components/button/` and examine:
- [ ] How is the Button component structured?
- [ ] What files are in the button directory?
- [ ] What props does Button accept?

**Write your findings here:**
```
Button component location: ____________________
Button accepts these variants: ____________________
Button accepts these sizes: ____________________
```

### Lab 1.3: Find the App (Layer 5)

```bash
# Navigate to the web app
ls apps/web/

# Look at the pages
ls apps/web/app/
```

**Exercise:** Find a page that uses `@calcom/ui` components:
```bash
# Search for imports from @calcom/ui
grep -r "from \"@calcom/ui\"" apps/web/app/ --include="*.tsx" | head -20
```

**Pick one file and answer:**
- [ ] What page is it?
- [ ] What components does it import from `@calcom/ui`?
- [ ] How does it use those components?

### Lab 1.4: Find App Components (Layer 4)

```bash
# Look at app-specific components
ls apps/web/components/
```

**Exercise:** Pick one component from `apps/web/components/` and examine:
- [ ] Does it import from `@calcom/ui`?
- [ ] What UI components does it compose?
- [ ] Does it contain business logic (data fetching, form handling)?

**Key difference to note:**
- `packages/ui/components/` = Generic, reusable, no business logic
- `apps/web/components/` = Product-specific, may have business logic

### Lab 1.5: Trace the Import Path

Open `apps/web/package.json` and find how it references the UI package:

```bash
cat apps/web/package.json | grep -A2 -B2 "calcom/ui"
```

**Answer:** How does the app reference the UI package?
```
Dependency declaration: ____________________
```

---

## Part 3: Compare with Supabase (30 minutes)

### Lab 1.6: Clone Supabase

```bash
cd ..
git clone https://github.com/supabase/supabase
cd supabase
```

### Lab 1.7: Find the Two-Tier UI System

Supabase has TWO UI packages:

```bash
ls packages/ui/
ls packages/ui-patterns/
```

**Answer these questions:**
1. What's in `packages/ui/`? (primitives)
2. What's in `packages/ui-patterns/`? (composed patterns)
3. Why might they separate these?

### Lab 1.8: Find the Dashboard App

```bash
ls apps/studio/
```

**Exercise:** Find how the dashboard uses both UI packages:
```bash
grep -r "from '@supabase/ui'" apps/studio/ --include="*.tsx" | head -10
grep -r "from 'ui-patterns'" apps/studio/ --include="*.tsx" | head -10
```

---

## Part 4: Reflection (30 minutes)

### Written Reflection

Answer these questions in your own words:

1. **What's the difference between a UI library and a product design system?**

   Your answer:
   ```



   ```

2. **Why do Cal.com and Supabase put their UI in `packages/` instead of `apps/web/components/`?**

   Your answer:
   ```



   ```

3. **When would you add a component to `packages/ui/` vs `apps/web/components/`?**

   Your answer:
   ```



   ```

4. **What did you notice that was similar between Cal.com and Supabase?**

   Your answer:
   ```



   ```

5. **What did you notice that was different?**

   Your answer:
   ```



   ```

---

## Part 5: Self-Check

Before moving to Chapter 2, verify you can:

- [ ] Explain the 5-layer model of a design system
- [ ] Navigate a monorepo and find the UI package
- [ ] Distinguish between primitive components and app components
- [ ] Understand how `apps/` packages reference `packages/` packages
- [ ] Explain why design tokens sit at the foundation

---

## Summary

You've learned that a design system is more than just components. It's a layered architecture:

```
Tokens → Primitives → Patterns → App Components → Pages
```

In the next chapter, you'll build Layer 1: Design Tokens.

---

## Additional Resources

- [Cal.com Handbook: Monorepo](https://handbook.cal.com/engineering/codebase/monorepo-turborepo)
- [Supabase UI Docs](https://supabase.com/ui)
- [Atomic Design by Brad Frost](https://atomicdesign.bradfrost.com/) (free online book)
