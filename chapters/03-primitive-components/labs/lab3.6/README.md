# Lab 3.6: Compare with Real Projects

## Objective

Study how production design systems (Cal.com, Supabase) build their primitive components and compare with your implementation.

## Time Estimate

~20 minutes

## Prerequisites

- Completed Labs 3.1-3.5
- Chapter 1 completed (Cal.com reference available)

## Setup

### Quick Setup

```bash
./setup.sh
```

This will create symlinks to the reference projects.

## Exercises

### Exercise 1: Study Cal.com's Button

```bash
# Navigate to Cal.com's Button
cat cal.com/packages/ui/components/button/Button.tsx
```

**Questions to answer:**

1. **How do they define variants?**
   - Do they use CVA or another approach?
   - What variants are available?

2. **What additional features do they include?**
   - Loading state?
   - Icon support?
   - Size variants?

3. **How do they handle TypeScript?**
   - Props interface?
   - Variant types?

**Write your observations:**
```
Cal.com Button observations:
- Variant approach: _______________
- Loading state: _______________
- Notable features: _______________
```

### Exercise 2: Compare Button Implementations

| Feature | Your Button | Cal.com Button |
|---------|-------------|----------------|
| Variant system | CVA | ___ |
| Number of variants | 6 | ___ |
| Loading state | Yes | ___ |
| Icon support | leftIcon/rightIcon | ___ |
| forwardRef | Yes | ___ |
| TypeScript | VariantProps | ___ |

### Exercise 3: Study Cal.com's Input

```bash
# Find the Input component
ls cal.com/packages/ui/components/
cat cal.com/packages/ui/components/form/input.tsx
```

**Questions:**
1. How do they handle labels?
2. How do they handle errors?
3. Do they use `aria-*` attributes?

### Exercise 4: Study the Card Pattern

```bash
# Look for Card or similar container components
ls cal.com/packages/ui/components/
```

**Questions:**
1. Do they use composition pattern?
2. How many sub-components?
3. What props do they accept?

### Exercise 5: Reflection - Design Decisions

Compare the approaches:

**Your Approach:**
- CVA for variants
- Separate sub-components for Card
- Built-in accessibility
- TypeScript-first

**Cal.com's Approach:**
- _______________
- _______________
- _______________

**Questions to consider:**
1. What would you change in your implementation based on what you learned?
2. What did you do better?
3. What patterns would you adopt?

### Exercise 6: Written Reflection

Answer these questions:

1. **What's the difference between a primitive component and an app component?**
   ```


   ```

2. **Why use CVA instead of just conditional classnames?**
   ```


   ```

3. **What accessibility features did you implement in the Input component?**
   ```


   ```

4. **When would you add a new variant vs creating a new component?**
   ```


   ```

## Key Takeaways

### Common Patterns in Production Design Systems

1. **Variant Management**
   - Most use CVA or similar
   - Consistent naming (primary, secondary, destructive)
   - Default variants defined

2. **TypeScript**
   - Extend native HTML attributes
   - Export prop types for consumers
   - Use forwardRef for DOM access

3. **Accessibility**
   - ARIA attributes built-in
   - Keyboard navigation support
   - Focus management

4. **Composition**
   - Prefer composition over configuration
   - Sub-components for flexibility
   - className always accepted

### What Production Systems Often Add

Things you might add in a real project:
- **Polymorphic components** (`as` prop to change element type)
- **Compound components with Context** (Tabs, Accordion)
- **Animation support** (Framer Motion integration)
- **Theming** (CSS variables, theme context)
- **Documentation** (Storybook stories)

## Self-Check: Chapter 3 Complete

Verify you have:

- [ ] Button with 6+ variants and 4 sizes
- [ ] Input with label, error, hint, and ARIA attributes
- [ ] Card with 5 sub-components (Header, Title, Description, Content, Footer)
- [ ] Badge with 6 variants
- [ ] Avatar with 5 sizes and fallback support
- [ ] Barrel export (index.tsx)
- [ ] TypeScript compiles without errors
- [ ] Compared with real codebases

## Files You Should Have

```
packages/ui/
├── src/
│   ├── components/
│   │   ├── Button.tsx    # 6 variants, 4 sizes, loading, icons
│   │   ├── Input.tsx     # label, error, hint, addons
│   │   ├── Card.tsx      # 5 sub-components
│   │   ├── Badge.tsx     # 6 variants
│   │   └── Avatar.tsx    # 5 sizes, fallback
│   ├── lib/
│   │   └── utils.ts      # cn() utility
│   └── index.tsx         # barrel export
├── package.json
└── tsconfig.json
```

## Connecting to Chapter 2: Design Tokens

You may have noticed that our components use **hardcoded Tailwind classes** like `bg-blue-600` instead of the **CSS variables** from Chapter 2 (`var(--color-primary-500)`).

This is intentional! Chapter 3 focuses on component patterns (CVA, composition, accessibility). The token integration happens in later chapters:

| Chapter | What Happens |
|---------|--------------|
| Chapter 4 | Monorepo wires `@myapp/tokens` + `@myapp/ui` together |
| Chapter 6 | Theming integrates CSS variables with components |

### Exercise 3.4: Connect Tokens to Components (Preview)

This exercise previews how you'll integrate tokens in Chapter 4 & 6.

**Step 1: Tailwind Config with CSS Variables**

Instead of Tailwind's default colors, map to your token variables:

```js
// tailwind.config.js
module.exports = {
  theme: {
    extend: {
      colors: {
        primary: {
          50: 'var(--color-primary-50)',
          500: 'var(--color-primary-500)',
          600: 'var(--color-primary-600)',
          700: 'var(--color-primary-700)',
        },
        neutral: {
          0: 'var(--color-neutral-0)',
          50: 'var(--color-neutral-50)',
          100: 'var(--color-neutral-100)',
          // ... etc
        },
      }
    }
  }
}
```

**Step 2: Import Token CSS**

Your app imports the generated CSS from Chapter 2:

```tsx
// App entry point
import '@myapp/tokens/build/css/variables.css';
```

**Step 3: Update Component Classes**

Components use token-backed classes:

```tsx
// Before (hardcoded Tailwind)
"bg-blue-600 text-white hover:bg-blue-700"

// After (token-backed)
"bg-primary-500 text-white hover:bg-primary-600"
```

The class names look similar, but `bg-primary-500` now resolves to `var(--color-primary-500)` from your tokens!

**Questions to consider:**
1. What's the benefit of this indirection through CSS variables?
2. How does this enable theming (light/dark mode)?
3. Why keep the Tailwind config as the integration point?

---

## Extension Exercises

### Exercise 3.1: Add a Textarea Component

Build a Textarea component similar to Input with:
- Label, error, hint support
- Proper accessibility
- Optional character count
- Resize options (none, vertical, both)

### Exercise 3.2: Add Icon Button Variant

Modify Button to better support icon-only buttons:
- Add `icon` size variant (already done)
- Add `aria-label` requirement for icon-only buttons
- Show warning in dev if no `aria-label` on icon button

### Exercise 3.3: Add Avatar Group

Create an AvatarGroup component that:
- Stacks multiple avatars with overlap
- Shows "+N" for overflow
- Has a `max` prop to limit visible avatars

```tsx
<AvatarGroup max={3}>
  <Avatar alt="User 1" />
  <Avatar alt="User 2" />
  <Avatar alt="User 3" />
  <Avatar alt="User 4" />
  <Avatar alt="User 5" />
</AvatarGroup>
// Shows 3 avatars + "+2" badge
```

## Next Steps

You now have a complete set of primitive components! In Chapter 4, you'll set up a monorepo architecture to share these components across multiple applications.
