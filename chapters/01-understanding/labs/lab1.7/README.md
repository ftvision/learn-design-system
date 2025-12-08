# Lab 1.7: Find the Two-Tier UI System

## Objective

Explore Supabase's two-tier UI system to understand how they separate primitives from patterns.

## Setup

Supabase is stored as a git submodule in `references/supabase` and symlinked into this lab directory.

### Quick Setup

```bash
./setup.sh
```

This will:
1. Initialize the Supabase submodule (if needed)
2. Checkout the pinned commit for reproducibility
3. Create a symlink at `supabase/` for easy access

## Background

Supabase has TWO UI packages:
- `packages/ui/` - Primitive components (Layer 2)
- `packages/ui-patterns/` - Composed patterns (Layer 3)

This is different from Cal.com, which has a single `packages/ui/` for both.

## Exercises

### Exercise 1: Explore the Primitives Package

```bash
ls supabase/packages/ui/
ls supabase/packages/ui/src/components/
```

**Questions to answer:**
1. What's the structure of the UI package?
2. What primitive components can you identify?
3. How does this compare to Cal.com's primitives?

### Exercise 2: Explore the Patterns Package

```bash
ls supabase/packages/ui-patterns/
```

**Questions to answer:**
1. What's in the ui-patterns package?
2. What patterns can you identify?
3. Why might Supabase separate these from primitives?

### Exercise 3: Compare a Primitive vs a Pattern

Pick a primitive from `packages/ui/`:

```bash
# Example: Look at Button
ls supabase/packages/ui/src/components/Button/
```

Pick a pattern from `packages/ui-patterns/`:

```bash
# Look for composed components
ls supabase/packages/ui-patterns/
```

**Compare:**
| Aspect | Primitive (ui/) | Pattern (ui-patterns/) |
|--------|-----------------|------------------------|
| Complexity | ? | ? |
| Dependencies | ? | ? |
| Business logic | ? | ? |

### Exercise 4: Understand the Separation

**Why two packages?**

Think about these benefits:
1. **Clear boundaries** - Primitives never depend on patterns
2. **Separate versioning** - Can update patterns without touching primitives
3. **Team ownership** - Different teams can own different packages
4. **Bundle size** - Apps can import only what they need

**Exercise:** Find how the dashboard imports from both packages:

```bash
grep -r "from '@supabase/ui'" supabase/apps/studio/ --include="*.tsx" | head -5
grep -r "from 'ui-patterns'" supabase/apps/studio/ --include="*.tsx" | head -5
```

## Key Observations

After completing this lab, you should understand:
- Supabase's two-tier approach (ui + ui-patterns)
- The difference between primitives and patterns
- Why separating them can be beneficial
- How this compares to Cal.com's single-package approach

## Checklist

- [ ] I explored the `packages/ui/` package
- [ ] I explored the `packages/ui-patterns/` package
- [ ] I understand why Supabase separates them
- [ ] I can compare this to Cal.com's approach

## Next

Proceed to Lab 1.8 to explore how the Supabase dashboard uses both UI packages.
