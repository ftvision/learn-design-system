# Chapter 6: Theming

## Chapter Goal

By the end of this chapter, you will:
- Understand how theming works with CSS custom properties
- Implement light and dark mode switching
- Create a theme system that components consume automatically
- Handle system preference detection and user overrides
- Build theme-aware components

## Prerequisites

- Completed Chapters 1-5
- Working monorepo with UI components
- Understanding of CSS custom properties

## Key Concepts

### What is Theming?

Theming allows the same components to render differently based on context:

```
Light Theme              Dark Theme
┌─────────────┐          ┌─────────────┐
│ ░░░░░░░░░░░ │          │ ▓▓▓▓▓▓▓▓▓▓▓ │
│ ░ Button  ░ │    →     │ ▓ Button  ▓ │
│ ░░░░░░░░░░░ │          │ ▓▓▓▓▓▓▓▓▓▓▓ │
└─────────────┘          └─────────────┘
Same component, different colors
```

### How It Works

```css
/* Define theme tokens */
:root {
  --color-bg: white;
  --color-text: black;
}

.dark {
  --color-bg: black;
  --color-text: white;
}

/* Components use tokens */
.card {
  background: var(--color-bg);
  color: var(--color-text);
}
```

When `.dark` is added to `<html>`, all components update automatically.

### The Theme Flow

```
User Preference → Theme State → CSS Class → Variable Values → Components
     │                │             │              │              │
System dark mode  "dark"     <html class="dark">  --color-bg: #000  renders
or manual toggle                                                    dark
```

## What You'll Build

- CSS theme tokens (light/dark values)
- Theme provider component
- Theme toggle button
- Persist preference to localStorage
- Detect system preference

## Time Estimate

- Theory: 20 minutes
- Lab exercises: 1.5 hours
- Reflection: 15 minutes

## Success Criteria

- [ ] Components respond to theme changes
- [ ] Theme persists across page refreshes
- [ ] System preference is detected on first visit
- [ ] Toggle switches between light/dark modes
- [ ] No flash of wrong theme on page load

## Next Chapter

Chapter 7 sets up Storybook for component documentation and testing.
