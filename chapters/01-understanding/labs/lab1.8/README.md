# Lab 1.8: Find the Dashboard App

## Objective

Explore how Supabase's dashboard (Studio) uses both UI packages to understand the complete picture.

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

## Exercises

### Exercise 1: Explore the Studio App

```bash
ls supabase/apps/studio/
```

**Questions to answer:**
1. What's the structure of the Studio app?
2. Is it a Next.js app?
3. Where are the pages/routes located?

### Exercise 2: Find How Studio Uses Both UI Packages

Search for imports from `@supabase/ui`:

```bash
grep -r "from '@supabase/ui'" supabase/apps/studio/ --include="*.tsx" | head -10
```

Search for imports from `ui-patterns`:

```bash
grep -r "from 'ui-patterns'" supabase/apps/studio/ --include="*.tsx" | head -10
```

**Questions to answer:**
1. Does Studio import from both packages?
2. What components come from `@supabase/ui`?
3. What patterns come from `ui-patterns`?

### Exercise 3: Check the Package Dependencies

```bash
cat supabase/apps/studio/package.json | grep -E "@supabase/ui|ui-patterns" -A1 -B1
```

**Write your findings:**
```
@supabase/ui version: ____________________
ui-patterns reference: ____________________
```

### Exercise 4: Compare Cal.com vs Supabase Architecture

Now that you've explored both, fill in this comparison:

| Aspect | Cal.com | Supabase |
|--------|---------|----------|
| UI packages | 1 (`packages/ui/`) | 2 (`ui/` + `ui-patterns/`) |
| Primitives location | `packages/ui/components/` | `packages/ui/src/components/` |
| Patterns location | `packages/ui/components/` | `packages/ui-patterns/` |
| Main app | `apps/web/` | `apps/studio/` |
| App components | `apps/web/components/` | ? |

### Exercise 5: Final Reflection

**Which approach do you prefer and why?**

Cal.com's single-package approach:
- Pros: Simpler, fewer packages to manage
- Cons: Less clear boundaries between primitives and patterns

Supabase's two-package approach:
- Pros: Clear separation, can version independently
- Cons: More complexity, more packages to maintain

**Write your thoughts:**
```
I prefer the __________ approach because:




```

## Key Observations

After completing this lab, you should understand:
- How Supabase's Studio app consumes both UI packages
- The trade-offs between single-package and multi-package approaches
- How real-world products structure their design systems
- That there's no single "right" way—it depends on your needs

## Checklist

- [ ] I explored the Studio app structure
- [ ] I found imports from both `@supabase/ui` and `ui-patterns`
- [ ] I understand the dependency declarations
- [ ] I can articulate the trade-offs between approaches

## Summary

You've now explored two real-world design system architectures:

```
Cal.com:
  packages/ui/ → apps/web/

Supabase:
  packages/ui/ ──────┐
                     ├──→ apps/studio/
  packages/ui-patterns/ ─┘
```

Both are valid approaches. The key is understanding the 5-layer model and applying it consistently.

## Next

Proceed to Part 4: Reflection to consolidate your learning.
