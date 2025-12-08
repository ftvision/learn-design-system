# Linaria: Zero-Runtime CSS-in-JS

This document explains where Linaria fits in the design system architecture and how it compares to the Tailwind + CVA approach used in the main course.

---

## What is Linaria?

Linaria is a **zero-runtime CSS-in-JS library**. It lets you write CSS-in-JS syntax that gets **extracted to static CSS files at build time**—no JavaScript runtime cost.

```tsx
import { styled } from '@linaria/react';
import { css } from '@linaria/core';

// Styled component (like styled-components, but zero runtime)
const Button = styled.button`
  background: var(--color-primary);
  padding: var(--spacing-md);
  border-radius: 8px;
`;

// Or just a class name
const buttonClass = css`
  background: var(--color-primary);
  padding: var(--spacing-md);
`;
```

### How It Works

```
Build Time:
┌──────────────────┐      ┌──────────────────┐      ┌──────────────────┐
│  Button.tsx      │      │  Linaria         │      │  Output          │
│                  │  →   │  Compiler        │  →   │                  │
│  styled.button`  │      │  (babel plugin)  │      │  Button.css      │
│    bg: blue;     │      │                  │      │  .abc123 {       │
│  `               │      │                  │      │    bg: blue;     │
│                  │      │                  │      │  }               │
└──────────────────┘      └──────────────────┘      └──────────────────┘

Runtime:
┌──────────────────┐
│  <button         │
│    class="abc123"│   ← Just a class name, no JS
│  />              │
└──────────────────┘
```

---

## Where Linaria Fits in the 5-Layer Model

Linaria is a **styling approach** for Layers 2-3. It doesn't change the architecture—it's an alternative to Tailwind for how you write component styles.

```
┌─────────────────────────────────────────────────────────────────┐
│  Layer 5: Pages                                                 │
├─────────────────────────────────────────────────────────────────┤
│  Layer 4: App Components                                        │
├─────────────────────────────────────────────────────────────────┤
│  Layer 3: Pattern Components      ← Linaria styles these        │
├─────────────────────────────────────────────────────────────────┤
│  Layer 2: Primitive Components    ← Linaria styles these        │
├─────────────────────────────────────────────────────────────────┤
│  Layer 1: Design Tokens           ← Linaria CONSUMES these      │
│           (CSS variables work perfectly with Linaria)           │
└─────────────────────────────────────────────────────────────────┘
```

**Key point:** Linaria doesn't replace design tokens. It **consumes** them via CSS custom properties.

---

## Linaria vs Other Styling Approaches

| Approach | Runtime Cost | CSS Variables | Co-location | Type Safety |
|----------|-------------|---------------|-------------|-------------|
| **Tailwind CSS** | Zero | Yes | Yes (inline) | No |
| **Linaria** | Zero | Yes | Yes | Yes (with TS) |
| **styled-components** | Runtime | Yes | Yes | Yes |
| **Emotion** | Runtime | Yes | Yes | Yes |
| **CSS Modules** | Zero | Yes | Separate file | No |
| **Vanilla CSS** | Zero | Yes | Separate file | No |

### Why Zero Runtime Matters

Runtime CSS-in-JS (styled-components, Emotion) has costs:
- JavaScript bundle size (library code)
- Style computation on every render
- Potential hydration mismatches in SSR

Linaria avoids all of these by extracting styles at build time.

---

## How Linaria Works with Design Tokens

Linaria works **perfectly** with CSS custom properties (design tokens):

```tsx
// packages/ui/src/components/Button.tsx
import { styled } from '@linaria/react';

export const Button = styled.button`
  /* Uses design tokens via CSS variables */
  background-color: var(--color-primary);
  color: var(--color-primary-text);
  padding: var(--spacing-sm) var(--spacing-md);
  border-radius: var(--border-radius-md);
  font-size: var(--font-size-sm);
  font-weight: var(--font-weight-medium);

  /* Transitions */
  transition: background-color 0.2s, box-shadow 0.2s;

  &:hover {
    background-color: var(--color-primary-hover);
  }

  &:focus-visible {
    outline: none;
    box-shadow: 0 0 0 2px var(--ring-offset-color), 0 0 0 4px var(--ring-color);
  }

  &:disabled {
    opacity: 0.5;
    cursor: not-allowed;
    pointer-events: none;
  }
`;
```

### Theming Works Automatically

Because Linaria uses CSS variables, theming works exactly like the course approach:

```css
/* Light theme */
:root {
  --color-primary: #3B82F6;
  --color-primary-hover: #2563EB;
}

/* Dark theme */
.dark {
  --color-primary: #60A5FA;
  --color-primary-hover: #3B82F6;
}
```

Toggle `.dark` on `<html>`, and all Linaria-styled components update automatically.

---

## Linaria vs Tailwind + CVA (Course Approach)

### Tailwind + CVA (Course Approach)

```tsx
import { cva, type VariantProps } from 'class-variance-authority';
import { cn } from '../lib/utils';

const buttonVariants = cva(
  // Base styles
  "inline-flex items-center justify-center rounded-md font-medium transition-colors",
  {
    variants: {
      variant: {
        primary: "bg-[var(--color-primary)] text-white hover:bg-[var(--color-primary-hover)]",
        secondary: "bg-[var(--color-bg-muted)] text-[var(--color-text)] hover:bg-[var(--color-bg-emphasis)]",
        destructive: "bg-[var(--color-error)] text-white hover:opacity-90",
      },
      size: {
        sm: "h-8 px-3 text-sm",
        md: "h-10 px-4 text-sm",
        lg: "h-12 px-6 text-base",
      },
    },
    defaultVariants: {
      variant: "primary",
      size: "md",
    },
  }
);

interface ButtonProps
  extends React.ButtonHTMLAttributes<HTMLButtonElement>,
    VariantProps<typeof buttonVariants> {}

export function Button({ variant, size, className, ...props }: ButtonProps) {
  return (
    <button
      className={cn(buttonVariants({ variant, size }), className)}
      {...props}
    />
  );
}
```

### Linaria Approach

```tsx
import { styled } from '@linaria/react';
import { css } from '@linaria/core';

// Base styles
const baseButton = css`
  display: inline-flex;
  align-items: center;
  justify-content: center;
  border-radius: var(--border-radius-md);
  font-weight: var(--font-weight-medium);
  transition: background-color 0.2s, opacity 0.2s;
  cursor: pointer;
  border: none;

  &:focus-visible {
    outline: none;
    box-shadow: 0 0 0 2px var(--ring-offset-color), 0 0 0 4px var(--ring-color);
  }

  &:disabled {
    opacity: 0.5;
    cursor: not-allowed;
    pointer-events: none;
  }
`;

// Variant styles
const variants = {
  primary: css`
    background-color: var(--color-primary);
    color: white;
    &:hover:not(:disabled) {
      background-color: var(--color-primary-hover);
    }
  `,
  secondary: css`
    background-color: var(--color-bg-muted);
    color: var(--color-text);
    &:hover:not(:disabled) {
      background-color: var(--color-bg-emphasis);
    }
  `,
  destructive: css`
    background-color: var(--color-error);
    color: white;
    &:hover:not(:disabled) {
      opacity: 0.9;
    }
  `,
};

// Size styles
const sizes = {
  sm: css`
    height: 2rem;
    padding: 0 0.75rem;
    font-size: var(--font-size-sm);
  `,
  md: css`
    height: 2.5rem;
    padding: 0 1rem;
    font-size: var(--font-size-sm);
  `,
  lg: css`
    height: 3rem;
    padding: 0 1.5rem;
    font-size: var(--font-size-base);
  `,
};

interface ButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: keyof typeof variants;
  size?: keyof typeof sizes;
}

export function Button({
  variant = 'primary',
  size = 'md',
  className,
  ...props
}: ButtonProps) {
  return (
    <button
      className={`${baseButton} ${variants[variant]} ${sizes[size]} ${className || ''}`}
      {...props}
    />
  );
}
```

### Alternative: Styled Components with Props

```tsx
import { styled } from '@linaria/react';

interface ButtonProps {
  variant?: 'primary' | 'secondary' | 'destructive';
  size?: 'sm' | 'md' | 'lg';
}

export const Button = styled.button<ButtonProps>`
  display: inline-flex;
  align-items: center;
  justify-content: center;
  border-radius: var(--border-radius-md);
  font-weight: var(--font-weight-medium);
  transition: background-color 0.2s;
  cursor: pointer;
  border: none;

  /* Size variants */
  height: ${({ size }) =>
    size === 'sm' ? '2rem' :
    size === 'lg' ? '3rem' : '2.5rem'};
  padding: ${({ size }) =>
    size === 'sm' ? '0 0.75rem' :
    size === 'lg' ? '0 1.5rem' : '0 1rem'};
  font-size: ${({ size }) =>
    size === 'lg' ? 'var(--font-size-base)' : 'var(--font-size-sm)'};

  /* Color variants */
  background-color: ${({ variant }) =>
    variant === 'secondary' ? 'var(--color-bg-muted)' :
    variant === 'destructive' ? 'var(--color-error)' :
    'var(--color-primary)'};
  color: ${({ variant }) =>
    variant === 'secondary' ? 'var(--color-text)' : 'white'};

  &:hover:not(:disabled) {
    background-color: ${({ variant }) =>
      variant === 'secondary' ? 'var(--color-bg-emphasis)' :
      variant === 'destructive' ? 'var(--color-error)' :
      'var(--color-primary-hover)'};
    opacity: ${({ variant }) => variant === 'destructive' ? '0.9' : '1'};
  }

  &:disabled {
    opacity: 0.5;
    cursor: not-allowed;
  }
`;
```

---

## Comparison Summary

| Aspect | Tailwind + CVA | Linaria |
|--------|---------------|---------|
| **Syntax** | Utility classes | Actual CSS |
| **Learning curve** | Learn Tailwind utilities | Know CSS |
| **Bundle size** | Tailwind CSS (purged) | Extracted CSS |
| **Runtime cost** | Zero | Zero |
| **Variant handling** | CVA (declarative) | Manual or props |
| **IDE support** | Tailwind IntelliSense | CSS IntelliSense |
| **Refactoring** | Find/replace classes | Standard CSS refactoring |
| **Complex selectors** | Limited | Full CSS power |
| **Animations** | Tailwind animate | Full @keyframes |

---

## When to Choose Linaria

### Choose Linaria When:

- You prefer writing actual CSS syntax
- You're coming from styled-components and want zero runtime
- You need complex CSS selectors, pseudo-elements, or animations
- You want component-scoped styles without runtime cost
- Your team is more comfortable with CSS than utility classes

### Choose Tailwind + CVA When:

- You prefer utility-first rapid development
- Your team already knows Tailwind
- You want a consistent constraint system
- You prefer declarative variant definitions
- You want extensive IDE autocomplete for utilities

---

## Setting Up Linaria in the Monorepo

### Installation

```bash
# In packages/ui
pnpm add @linaria/core @linaria/react
pnpm add -D @linaria/babel-preset @linaria/vite
```

### Vite Configuration

```typescript
// packages/ui/vite.config.ts
import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';
import linaria from '@linaria/vite';

export default defineConfig({
  plugins: [
    react(),
    linaria({
      include: ['**/*.{ts,tsx}'],
      babelOptions: {
        presets: ['@babel/preset-typescript', '@babel/preset-react'],
      },
    }),
  ],
});
```

### Next.js Configuration

```javascript
// apps/web/next.config.js
const withLinaria = require('next-with-linaria');

module.exports = withLinaria({
  // Next.js config
});
```

### Folder Structure (Same as Course)

```
my-product/
├── packages/
│   ├── tokens/              # CSS variables (unchanged)
│   │   └── build/css/variables.css
│   └── ui/                  # Components styled with Linaria
│       └── src/components/
│           ├── Button.tsx   # Uses styled() from Linaria
│           └── Button.stories.tsx
└── apps/
    └── web/                 # Imports from @myapp/ui
        └── app/
            └── layout.tsx   # Imports token CSS
```

---

## Linaria + Design Tokens: Complete Example

### Token Definition (Same as Course)

```json
// packages/tokens/src/colors.json
{
  "color": {
    "primary": {
      "DEFAULT": { "value": "#3B82F6", "type": "color" },
      "hover": { "value": "#2563EB", "type": "color" }
    },
    "bg": {
      "DEFAULT": { "value": "#FFFFFF", "type": "color" },
      "muted": { "value": "#F3F4F6", "type": "color" }
    },
    "text": {
      "DEFAULT": { "value": "#111827", "type": "color" },
      "muted": { "value": "#6B7280", "type": "color" }
    }
  }
}
```

### Generated CSS (Same as Course)

```css
/* packages/tokens/build/css/variables.css */
:root {
  --color-primary: #3B82F6;
  --color-primary-hover: #2563EB;
  --color-bg: #FFFFFF;
  --color-bg-muted: #F3F4F6;
  --color-text: #111827;
  --color-text-muted: #6B7280;
}

.dark {
  --color-primary: #60A5FA;
  --color-primary-hover: #3B82F6;
  --color-bg: #030712;
  --color-bg-muted: #1F2937;
  --color-text: #F9FAFB;
  --color-text-muted: #9CA3AF;
}
```

### Linaria Component Using Tokens

```tsx
// packages/ui/src/components/Card.tsx
import { styled } from '@linaria/react';

export const Card = styled.div`
  background-color: var(--color-bg);
  border: 1px solid var(--color-border);
  border-radius: var(--border-radius-lg);
  box-shadow: var(--shadow-sm);
  padding: var(--spacing-md);

  /* Theming works automatically via CSS variables */
`;

export const CardTitle = styled.h3`
  font-size: var(--font-size-lg);
  font-weight: var(--font-weight-semibold);
  color: var(--color-text);
  margin: 0 0 var(--spacing-sm) 0;
`;

export const CardDescription = styled.p`
  font-size: var(--font-size-sm);
  color: var(--color-text-muted);
  margin: 0;
`;
```

### Usage in App

```tsx
// apps/web/app/page.tsx
import { Card, CardTitle, CardDescription } from '@myapp/ui';
import '@myapp/tokens/css';  // Import token CSS

export default function Page() {
  return (
    <Card>
      <CardTitle>Welcome</CardTitle>
      <CardDescription>This card uses Linaria + design tokens</CardDescription>
    </Card>
  );
}
```

---

## Key Takeaways

1. **Linaria is a styling tool, not an architecture change** — The 5-layer model remains the same. Linaria is just a different way to write styles in Layers 2-3.

2. **Zero runtime, full CSS power** — Unlike styled-components/Emotion, Linaria extracts to static CSS. Unlike Tailwind, you write actual CSS syntax.

3. **Works perfectly with design tokens** — CSS custom properties work in Linaria just like any other CSS. Theming via `.dark` class works automatically.

4. **Choose based on team preference** — Both Tailwind + CVA and Linaria are valid choices. Pick based on whether your team prefers utility classes or CSS syntax.

---

## Resources

- [Linaria Documentation](https://linaria.dev/)
- [Linaria GitHub](https://github.com/callstack/linaria)
- [Linaria + Next.js](https://github.com/callstack/linaria/tree/master/examples/nextjs)
- [CSS-in-JS Performance Comparison](https://css-tricks.com/a-thorough-analysis-of-css-in-js/)
