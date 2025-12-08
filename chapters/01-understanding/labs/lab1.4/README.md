# Lab 1.4: Find App Components (Layer 4)

## Objective

Explore Cal.com's app-specific components to understand the difference between generic UI components (Layer 2) and product-specific components (Layer 4).

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

### Exercise 1: Explore App Components Directory

Look at app-specific components:

```bash
ls cal.com/apps/web/components/
```

**Questions to answer:**
1. How many component directories/files are there?
2. What naming patterns do you notice?
3. Can you identify product-specific components (booking, calendar, etc.)?

### Exercise 2: Pick a Component to Analyze

Choose one component from `apps/web/components/` and examine it:

```bash
# Example: look at a booking-related component
ls cal.com/apps/web/components/booking/
```

**For your chosen component, answer:**
- [ ] Does it import from `@calcom/ui`?
- [ ] What UI components does it compose?
- [ ] Does it contain business logic (API calls, state management, form handling)?

**Write your findings:**
```
Component name: ____________________
Imports from @calcom/ui: ____________________
Contains business logic: Yes / No
Business logic type: ____________________
```

### Exercise 3: Compare Layer 2 vs Layer 4

Find a component that uses Button from `@calcom/ui`:

```bash
grep -r "from \"@calcom/ui\"" cal.com/apps/web/components/ --include="*.tsx" | grep -i button | head -5
```

**Questions to answer:**
1. How is the UI Button being used?
2. Is it wrapped with additional functionality?
3. What product-specific behavior is added?

### Exercise 4: Identify the Key Difference

**Key difference to understand:**

| Aspect | `packages/ui/` (Layer 2) | `apps/web/components/` (Layer 4) |
|--------|--------------------------|----------------------------------|
| Purpose | Generic, reusable | Product-specific |
| Business logic | None | Often contains it |
| Data fetching | Never | May fetch data |
| Domain knowledge | None | Knows about bookings, users, etc. |

**Exercise:** Find an example of each:

```bash
# A pure UI component (no business logic)
cat cal.com/packages/ui/components/button/Button.tsx | head -50

# An app component with business logic
# (look for hooks, API calls, tRPC, etc.)
grep -r "trpc\|useQuery\|useMutation" cal.com/apps/web/components/ --include="*.tsx" | head -5
```

## Key Observations

After completing this lab, you should understand:
- The distinction between generic UI and product-specific components
- How Layer 4 composes Layer 2 components
- Where business logic lives in a well-structured app
- Why this separation matters for maintainability

## Checklist

- [ ] I can identify app-specific components
- [ ] I understand where business logic belongs
- [ ] I can distinguish Layer 2 from Layer 4 components
- [ ] I found examples of components with business logic

## Next

Proceed to Lab 1.5 to trace the complete import path from pages to packages.
