# Chapter 1: Understanding Design Systems

## Chapter Goal

By the end of this chapter, you will understand:
- What a design system actually is (beyond just "a component library")
- The 5-layer architecture that makes design systems work
- How real products structure their design systems
- The difference between UI libraries (Chakra, Radix) and product design systems (Cal.com, Supabase)

## Prerequisites

- Basic familiarity with React or any component-based framework
- Git installed on your machine
- A code editor (VS Code recommended)

## Key Concepts

### The 5-Layer Model

```
┌─────────────────────────────────────────────┐
│ Layer 5: Pages/Views                        │  ← /app/dashboard/page.tsx
├─────────────────────────────────────────────┤
│ Layer 4: App Components                     │  ← BookingCard, UserProfile
├─────────────────────────────────────────────┤
│ Layer 3: Pattern Components                 │  ← AuthForm, DataTable
├─────────────────────────────────────────────┤
│ Layer 2: Primitive Components               │  ← Button, Input, Card
├─────────────────────────────────────────────┤
│ Layer 1: Design Tokens                      │  ← colors, spacing, typography
└─────────────────────────────────────────────┘
```

### Why This Matters

Most tutorials only teach Layer 2 (building a Button component). But real products need all 5 layers working together. This chapter helps you see the complete picture before diving into implementation.

## What You'll Do

1. **Read** the theory about design system layers
2. **Clone** Cal.com and explore its structure
3. **Trace** a component through all 5 layers
4. **Compare** with Supabase's approach
5. **Reflect** on the patterns you observe

## Time Estimate

- Theory: 30 minutes
- Lab exercises: 1-2 hours
- Reflection: 30 minutes

## Success Criteria

You can answer these questions:
- [ ] What's the difference between `packages/ui/` and `apps/web/components/`?
- [ ] Why would you put a component in one vs the other?
- [ ] What are design tokens and why do they sit at the bottom of the stack?
- [ ] How does a page in `apps/web/` consume components from `packages/ui/`?

## Next Chapter

Once you understand the architecture, Chapter 2 dives into building the foundation: Design Tokens.
