# Lab 1.1: Clone and Orient - Cal.com

## Objective

Explore Cal.com's codebase to understand the monorepo structure and identify the 5 layers of their design system.

## Setup

Cal.com is stored as a git submodule in `references/cal.com` and symlinked into this lab directory.

### Quick Setup

```bash
./setup.sh
```

This will:
1. Initialize the Cal.com submodule (if needed)
2. Checkout the pinned commit for reproducibility
3. Create a symlink at `cal.com/` for easy access

### Manual Setup

```bash
# From the course root directory
git submodule update --init references/cal.com

# Checkout the pinned commit
cd references/cal.com
git checkout 1182460d5c0733d126e77528daeb6fabc5d3ecc5
```

### Pinned Version

This lab uses Cal.com at commit `1182460d5c` to ensure exercises and answers remain consistent.

## Exercises

### Exercise 1: Top-Level Structure

Look at the top-level structure of Cal.com:

```bash
ls -la cal.com/
```

**Questions to answer:**
1. What directories do you see at the top level?
2. Which directory contains the shared packages?
3. Which directory contains the applications?

### Exercise 2: Find the UI Package (Layer 2)

Navigate to the UI package:

```bash
ls cal.com/packages/ui/
ls cal.com/packages/ui/components/
```

**Questions to answer:**
1. How are the components organized?
2. What primitive components can you identify?

### Exercise 3: Explore the Button Component

```bash
ls cal.com/packages/ui/components/button/
```

Open the Button component files and examine:
- [ ] How is the Button component structured?
- [ ] What variants does it support?
- [ ] What sizes are available?

**Write your findings:**
```
Button component location: packages/ui/components/button/
Button variants: ____________________
Button sizes: ____________________
```

### Exercise 4: Find How Apps Use the UI Package

Look at the web app's package.json:

```bash
cat cal.com/apps/web/package.json | grep -A2 -B2 "@calcom/ui"
```

**Answer:** How does the web app reference the UI package?

## Key Observations

After completing this lab, you should understand:
- The monorepo structure with `packages/` and `apps/`
- How `@calcom/ui` provides Layer 2 (primitives)
- How apps reference internal packages via workspace dependencies

## Next

Proceed to Lab 1.2 to trace a component through all 5 layers.
