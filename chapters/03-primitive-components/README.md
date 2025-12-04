# Chapter 3: Primitive Components

## Chapter Goal

By the end of this chapter, you will:
- Understand what makes a good primitive component
- Master the variant pattern for flexible component APIs
- Build accessible, reusable components (Button, Input, Card)
- Use class-variance-authority (CVA) for variant management
- Know when to use primitives vs building from scratch

## Prerequisites

- Completed Chapters 1-2
- Design tokens package from Chapter 2
- Familiarity with React and TypeScript

## Key Concepts

### What Are Primitive Components?

Primitive components are the **atoms** of your design system:

| Characteristic | Description |
|---------------|-------------|
| **Generic** | No business logic, work for any use case |
| **Configurable** | Variants, sizes, states via props |
| **Accessible** | Keyboard navigation, ARIA attributes |
| **Composable** | Can be combined to build complex UIs |

### Examples

| Primitive | NOT Primitive |
|-----------|---------------|
| `<Button>` | `<SubmitOrderButton>` |
| `<Input>` | `<EmailInput>` (with validation) |
| `<Card>` | `<ProductCard>` |
| `<Avatar>` | `<UserProfileAvatar>` |
| `<Modal>` | `<ConfirmDeleteModal>` |

### The Variant Pattern

Instead of creating separate components:
```tsx
// Bad: Multiple components
<PrimaryButton />
<SecondaryButton />
<DangerButton />
<SmallButton />
<LargeButton />
```

Use variants:
```tsx
// Good: One component, many variants
<Button variant="primary" size="md" />
<Button variant="secondary" size="lg" />
<Button variant="destructive" size="sm" />
```

## What You'll Build

A `packages/ui` package containing:
- Button (with variants, sizes, loading state)
- Input (with label, error, hint)
- Card (with header, content, footer)
- Badge (with color variants)
- Avatar (with fallback)

## Time Estimate

- Theory: 20 minutes
- Lab exercises: 2-3 hours
- Reflection: 20 minutes

## Success Criteria

- [ ] Created a UI package with proper TypeScript setup
- [ ] Built Button with 5 variants and 3 sizes
- [ ] Built Input with label, error state, and accessibility
- [ ] Built Card with composable sub-components
- [ ] All components use design tokens
- [ ] Compared with Cal.com/Supabase implementations

## Next Chapter

Chapter 4 connects everything with monorepo architecture, so your app can import from `@myapp/ui`.
