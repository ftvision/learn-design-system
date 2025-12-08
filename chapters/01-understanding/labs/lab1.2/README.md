# Lab 1.2: Find the Design System (Layer 2)

## Objective

Explore Cal.com's UI package to understand how primitive components (Layer 2) are structured.

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

## Exercises

### Exercise 1: Explore the UI Package

Navigate to the UI package:

```bash
ls cal.com/packages/ui/
```

**Questions to answer:**
1. What's the overall structure of the UI package?
2. Where are the components located?
3. Do you see any configuration files (package.json, tsconfig.json)?

### Exercise 2: List All Components

```bash
ls cal.com/packages/ui/components/
```

**Questions to answer:**
1. How many components are there?
2. Can you identify primitive components (Button, Input, Card, etc.)?
3. Can you identify pattern components (forms, tables, etc.)?

### Exercise 3: Deep Dive into Button

```bash
ls cal.com/packages/ui/components/button/
```

Open the Button component files and examine:
- [ ] How is the Button component structured?
- [ ] What files are in the button directory?
- [ ] What props does Button accept?

**Write your findings:**
```
Button component location: packages/ui/components/button/
Files in button directory: ____________________
Button variants: ____________________
Button sizes: ____________________
```

### Exercise 4: Understand the Export Structure

Look at how components are exported:

```bash
cat cal.com/packages/ui/components/button/index.ts
cat cal.com/packages/ui/index.tsx
```

**Questions to answer:**
1. How does the button directory export its component?
2. How does the main UI package re-export all components?

## Key Observations

After completing this lab, you should understand:
- How a UI package organizes its components
- The structure of a primitive component (Button)
- How components are exported for consumption by apps
- The difference between component implementation and public API

## Checklist

- [ ] I can navigate the UI package structure
- [ ] I understand how Button is implemented
- [ ] I know what variants and sizes Button supports
- [ ] I understand the export pattern used

## Next

Proceed to Lab 1.3 to explore how the web app (Layer 5) uses these components.
