# Lab 1.3: Find the App (Layer 5)

## Objective

Explore Cal.com's web application to understand how pages (Layer 5) consume components from the UI package.

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

### Exercise 1: Explore the Web App Structure

Navigate to the web app:

```bash
ls cal.com/apps/web/
```

**Questions to answer:**
1. What's the overall structure of the web app?
2. Where are the pages located?
3. Do you see a `components/` directory?

### Exercise 2: Explore the Pages

Look at the app directory (Next.js App Router):

```bash
ls cal.com/apps/web/app/
```

**Questions to answer:**
1. What routes/pages can you identify?
2. How is the routing structured?

### Exercise 3: Find Pages Using UI Components

Search for pages that import from `@calcom/ui`:

```bash
grep -r "from \"@calcom/ui\"" cal.com/apps/web/app/ --include="*.tsx" | head -20
```

**Pick one file and answer:**
- [ ] What page is it?
- [ ] What components does it import from `@calcom/ui`?
- [ ] How does it use those components?

**Write your findings:**
```
Page file: ____________________
Imported components: ____________________
How they're used: ____________________
```

### Exercise 4: Trace Component Usage

Pick a specific component (e.g., Button) and trace its usage:

```bash
# Find all Button usages in the web app
grep -r "<Button" cal.com/apps/web/app/ --include="*.tsx" | head -10
```

**Questions to answer:**
1. How many places use Button?
2. What props are commonly passed to Button?
3. Is Button used directly or wrapped in other components?

## Key Observations

After completing this lab, you should understand:
- How a Next.js app structure looks in a monorepo
- How pages import and use components from `@calcom/ui`
- The relationship between Layer 5 (pages) and Layer 2 (primitives)

## Checklist

- [ ] I can navigate the web app structure
- [ ] I found pages that use `@calcom/ui` components
- [ ] I understand how imports work across packages
- [ ] I can trace a component from page to UI package

## Next

Proceed to Lab 1.4 to explore app-specific components (Layer 4).
