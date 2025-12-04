# Chapter 2: Design Tokens

## Chapter Goal

By the end of this chapter, you will:
- Understand what design tokens are and why they're the foundation of a design system
- Know the difference between hardcoded values and tokenized values
- Build a token system using Style Dictionary
- Generate tokens for multiple platforms (CSS, JavaScript, iOS, Android)

## Prerequisites

- Completed Chapter 1
- Node.js installed (v18+)
- npm or pnpm package manager

## Key Concepts

### What Are Design Tokens?

Design tokens are **named design decisions**. Instead of using raw values, you use semantic names:

```css
/* Without tokens (bad) */
.button {
  background-color: #2196F3;
  padding: 16px;
  font-size: 14px;
}

/* With tokens (good) */
.button {
  background-color: var(--color-primary-500);
  padding: var(--spacing-md);
  font-size: var(--font-size-sm);
}
```

### Why Tokens Matter

| Problem | How Tokens Solve It |
|---------|---------------------|
| Inconsistent colors across the app | One source of truth for colors |
| Hard to implement dark mode | Swap token values, components stay the same |
| Web and mobile look different | Generate platform-specific tokens from one source |
| Designer says "make the blue slightly different" | Change one value, updates everywhere |

### Token Categories

| Category | Examples |
|----------|----------|
| **Colors** | `color.primary.500`, `color.neutral.100`, `color.error` |
| **Spacing** | `spacing.xs`, `spacing.md`, `spacing.2xl` |
| **Typography** | `font.size.sm`, `font.weight.bold`, `font.family.sans` |
| **Shadows** | `shadow.sm`, `shadow.md`, `shadow.lg` |
| **Borders** | `border.radius.md`, `border.width.thin` |

## What You'll Build

A complete token system that generates:
- CSS custom properties (`--color-primary-500`)
- JavaScript/TypeScript constants
- iOS Swift enums (preview)
- Android XML resources (preview)

## Time Estimate

- Theory: 20 minutes
- Lab exercises: 1.5 hours
- Reflection: 20 minutes

## Success Criteria

- [ ] Created a tokens package with colors, spacing, and typography
- [ ] Configured Style Dictionary to build tokens
- [ ] Generated CSS variables and verified they work
- [ ] Understood how tokens connect to components
- [ ] Compared your approach with Cal.com/Supabase

## Next Chapter

With tokens in place, Chapter 3 builds primitive components that consume these tokens.
