# Chapter 7: Documentation with Storybook

## Chapter Goal

By the end of this chapter, you will:
- Set up Storybook for your design system
- Write stories that document component variants and states
- Use autodocs for automatic API documentation
- Create interactive controls for testing components
- Organize stories by category and component

## Prerequisites

- Completed Chapters 1-6
- Working monorepo with themed UI components
- Node.js and pnpm installed

## Key Concepts

### Why Storybook?

Storybook is the standard for design system documentation:

| Benefit | Description |
|---------|-------------|
| **Living docs** | Documentation updates when code updates |
| **Visual testing** | See components in isolation |
| **Interactive** | Play with props in real-time |
| **Developer onboarding** | New devs learn from stories |
| **Design review** | Designers verify implementations |

### What is a Story?

A story is a single state of a component:

```tsx
// Button has multiple stories
export const Primary: Story = { args: { variant: "primary" } };
export const Secondary: Story = { args: { variant: "secondary" } };
export const Loading: Story = { args: { loading: true } };
export const Disabled: Story = { args: { disabled: true } };
```

### Storybook Structure

```
apps/docs/                   # Storybook app
├── .storybook/
│   ├── main.ts             # Configuration
│   └── preview.ts          # Global decorators
└── stories/
    └── Introduction.mdx    # Welcome page

packages/ui/
└── src/components/
    ├── Button.tsx          # Component
    └── Button.stories.tsx  # Stories for component
```

## What You'll Build

- Storybook app in the monorepo
- Stories for all UI components
- Interactive controls
- Theme switching in Storybook
- Component documentation with MDX

## Time Estimate

- Theory: 15 minutes
- Lab exercises: 2 hours
- Reflection: 15 minutes

## Success Criteria

- [ ] Storybook runs without errors
- [ ] All UI components have stories
- [ ] Controls allow changing props interactively
- [ ] Theme toggle works in Storybook
- [ ] Stories are organized by category

## Next Chapter

Chapter 8 explores cross-platform token generation for iOS and Android.
