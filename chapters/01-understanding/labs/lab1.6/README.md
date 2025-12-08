# Lab 1.6: Clone Supabase

## Objective

Explore Supabase's codebase to compare its design system architecture with Cal.com's approach.

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

### Exercise 1: Explore Top-Level Structure

Look at the top-level structure:

```bash
ls supabase/
```

**Questions to answer:**
1. What directories do you see?
2. How does this compare to Cal.com's structure?
3. Where might the UI packages be located?

### Exercise 2: Find the Packages Directory

```bash
ls supabase/packages/
```

**Questions to answer:**
1. What packages are available?
2. Can you identify UI-related packages?
3. Do you see any pattern similar to Cal.com?

### Exercise 3: Find the Apps Directory

```bash
ls supabase/apps/
```

**Questions to answer:**
1. What applications does Supabase have?
2. Which one is likely the main dashboard/studio?

### Exercise 4: Compare with Cal.com

Create a mental map comparing the two structures:

| Aspect | Cal.com | Supabase |
|--------|---------|----------|
| UI package location | `packages/ui/` | ? |
| Main app location | `apps/web/` | ? |
| Package manager | ? | ? |

**Fill in the Supabase column based on your exploration.**

## Key Observations

After completing this lab, you should understand:
- Supabase's monorepo structure
- Where to find UI packages in Supabase
- Initial similarities and differences with Cal.com

## Checklist

- [ ] I explored the top-level Supabase structure
- [ ] I found the packages directory
- [ ] I found the apps directory
- [ ] I have an initial comparison with Cal.com

## Next

Proceed to Lab 1.7 to explore Supabase's two-tier UI system.
