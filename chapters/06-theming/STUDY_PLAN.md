# Chapter 6 Study Plan: Theming

## Part 1: Theory (20 minutes)

### 1.1 Why CSS Custom Properties?

CSS custom properties (variables) enable theming because:
1. They cascade like regular CSS
2. They can be redefined in different contexts
3. JavaScript can read and modify them
4. No build step needed to switch themes

```css
/* Base theme */
:root {
  --color-primary: blue;
}

/* Override in dark mode */
.dark {
  --color-primary: lightblue;
}

/* Components just use the variable */
.button {
  background: var(--color-primary);
}
```

### 1.2 Semantic vs Primitive Tokens

**Primitive tokens** = Raw values:
```css
--blue-500: #3B82F6;
--blue-600: #2563EB;
--gray-900: #111827;
--white: #FFFFFF;
```

**Semantic tokens** = Meaning-based, reference primitives:
```css
--color-primary: var(--blue-500);
--color-background: var(--white);
--color-text: var(--gray-900);
```

For theming, you keep primitives constant and swap semantics:
```css
:root {
  --color-background: var(--white);
  --color-text: var(--gray-900);
}

.dark {
  --color-background: var(--gray-900);
  --color-text: var(--white);
}
```

### 1.3 The Flash Problem

Without proper handling, users see a flash of wrong theme:

```
1. Page loads with default (light) styles
2. JavaScript runs
3. JavaScript reads preference (dark)
4. Applies dark class
5. Page repaints to dark
      ↑
   FLASH!
```

**Solution:** Inline script in `<head>` that runs before render:

```html
<head>
  <script>
    // Runs before body renders
    if (localStorage.theme === 'dark' ||
        (!localStorage.theme && window.matchMedia('(prefers-color-scheme: dark)').matches)) {
      document.documentElement.classList.add('dark');
    }
  </script>
</head>
```

---

## Part 2: Lab - Create Theme Tokens (30 minutes)

### Lab 6.1: Create Theme CSS

Create `packages/ui/src/styles/theme.css`:

```css
/*
 * Design System Theme Tokens
 *
 * Primitive tokens stay constant.
 * Semantic tokens change per theme.
 */

/* ===== Primitive Tokens ===== */
:root {
  /* Gray scale */
  --gray-50: #F9FAFB;
  --gray-100: #F3F4F6;
  --gray-200: #E5E7EB;
  --gray-300: #D1D5DB;
  --gray-400: #9CA3AF;
  --gray-500: #6B7280;
  --gray-600: #4B5563;
  --gray-700: #374151;
  --gray-800: #1F2937;
  --gray-900: #111827;
  --gray-950: #030712;

  /* Primary (Blue) */
  --blue-50: #EFF6FF;
  --blue-100: #DBEAFE;
  --blue-500: #3B82F6;
  --blue-600: #2563EB;
  --blue-700: #1D4ED8;

  /* Success (Green) */
  --green-50: #F0FDF4;
  --green-500: #22C55E;
  --green-600: #16A34A;

  /* Warning (Amber) */
  --amber-50: #FFFBEB;
  --amber-500: #F59E0B;
  --amber-600: #D97706;

  /* Error (Red) */
  --red-50: #FEF2F2;
  --red-500: #EF4444;
  --red-600: #DC2626;

  /* White/Black */
  --white: #FFFFFF;
  --black: #000000;
}

/* ===== Semantic Tokens - Light Theme (Default) ===== */
:root {
  /* Backgrounds */
  --color-bg: var(--white);
  --color-bg-subtle: var(--gray-50);
  --color-bg-muted: var(--gray-100);
  --color-bg-emphasis: var(--gray-200);

  /* Foreground / Text */
  --color-text: var(--gray-900);
  --color-text-muted: var(--gray-600);
  --color-text-subtle: var(--gray-400);
  --color-text-on-emphasis: var(--white);

  /* Borders */
  --color-border: var(--gray-200);
  --color-border-muted: var(--gray-100);
  --color-border-emphasis: var(--gray-300);

  /* Primary */
  --color-primary: var(--blue-600);
  --color-primary-hover: var(--blue-700);
  --color-primary-subtle: var(--blue-50);
  --color-primary-text: var(--white);

  /* Success */
  --color-success: var(--green-500);
  --color-success-subtle: var(--green-50);

  /* Warning */
  --color-warning: var(--amber-500);
  --color-warning-subtle: var(--amber-50);

  /* Error */
  --color-error: var(--red-500);
  --color-error-subtle: var(--red-50);

  /* Shadows */
  --shadow-sm: 0 1px 2px 0 rgb(0 0 0 / 0.05);
  --shadow-md: 0 4px 6px -1px rgb(0 0 0 / 0.1), 0 2px 4px -2px rgb(0 0 0 / 0.1);
  --shadow-lg: 0 10px 15px -3px rgb(0 0 0 / 0.1), 0 4px 6px -4px rgb(0 0 0 / 0.1);

  /* Focus ring */
  --ring-color: var(--blue-500);
  --ring-offset-color: var(--white);
}

/* ===== Semantic Tokens - Dark Theme ===== */
.dark {
  /* Backgrounds */
  --color-bg: var(--gray-950);
  --color-bg-subtle: var(--gray-900);
  --color-bg-muted: var(--gray-800);
  --color-bg-emphasis: var(--gray-700);

  /* Foreground / Text */
  --color-text: var(--gray-50);
  --color-text-muted: var(--gray-400);
  --color-text-subtle: var(--gray-500);
  --color-text-on-emphasis: var(--white);

  /* Borders */
  --color-border: var(--gray-800);
  --color-border-muted: var(--gray-900);
  --color-border-emphasis: var(--gray-700);

  /* Primary */
  --color-primary: var(--blue-500);
  --color-primary-hover: var(--blue-600);
  --color-primary-subtle: rgba(59, 130, 246, 0.1);
  --color-primary-text: var(--white);

  /* Success */
  --color-success: var(--green-500);
  --color-success-subtle: rgba(34, 197, 94, 0.1);

  /* Warning */
  --color-warning: var(--amber-500);
  --color-warning-subtle: rgba(245, 158, 11, 0.1);

  /* Error */
  --color-error: var(--red-500);
  --color-error-subtle: rgba(239, 68, 68, 0.1);

  /* Shadows (more subtle in dark mode) */
  --shadow-sm: 0 1px 2px 0 rgb(0 0 0 / 0.3);
  --shadow-md: 0 4px 6px -1px rgb(0 0 0 / 0.4), 0 2px 4px -2px rgb(0 0 0 / 0.3);
  --shadow-lg: 0 10px 15px -3px rgb(0 0 0 / 0.5), 0 4px 6px -4px rgb(0 0 0 / 0.4);

  /* Focus ring */
  --ring-color: var(--blue-500);
  --ring-offset-color: var(--gray-950);
}
```

### Lab 6.2: Export Theme CSS

Update `packages/ui/package.json` to export the CSS:

```json
{
  "exports": {
    ".": "./src/index.tsx",
    "./styles": "./src/styles/theme.css"
  }
}
```

---

## Part 3: Lab - Update Components to Use Theme (30 minutes)

### Lab 6.3: Update Button Component

Update `packages/ui/src/components/Button.tsx` to use theme tokens:

```tsx
import * as React from "react";
import { cva, type VariantProps } from "class-variance-authority";
import { cn } from "../lib/utils";

const buttonVariants = cva(
  // Base styles using theme tokens
  [
    "inline-flex items-center justify-center gap-2",
    "rounded-md font-medium",
    "transition-colors duration-200",
    "focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-[var(--ring-color)] focus-visible:ring-offset-2 focus-visible:ring-offset-[var(--ring-offset-color)]",
    "disabled:pointer-events-none disabled:opacity-50",
  ],
  {
    variants: {
      variant: {
        primary: [
          "bg-[var(--color-primary)] text-[var(--color-primary-text)]",
          "hover:bg-[var(--color-primary-hover)]",
        ],
        secondary: [
          "bg-[var(--color-bg-muted)] text-[var(--color-text)]",
          "hover:bg-[var(--color-bg-emphasis)]",
          "border border-[var(--color-border)]",
        ],
        destructive: [
          "bg-[var(--color-error)] text-white",
          "hover:opacity-90",
        ],
        outline: [
          "border border-[var(--color-border)] bg-transparent text-[var(--color-text)]",
          "hover:bg-[var(--color-bg-subtle)]",
        ],
        ghost: [
          "bg-transparent text-[var(--color-text)]",
          "hover:bg-[var(--color-bg-muted)]",
        ],
        link: [
          "bg-transparent text-[var(--color-primary)] underline-offset-4",
          "hover:underline",
        ],
      },
      size: {
        sm: "h-8 px-3 text-sm",
        md: "h-10 px-4 text-sm",
        lg: "h-12 px-6 text-base",
        icon: "h-10 w-10",
      },
    },
    defaultVariants: {
      variant: "primary",
      size: "md",
    },
  }
);

// ... rest of component stays the same
```

### Lab 6.4: Update Card Component

Update `packages/ui/src/components/Card.tsx`:

```tsx
import * as React from "react";
import { cn } from "../lib/utils";

interface CardProps extends React.HTMLAttributes<HTMLDivElement> {
  padding?: "none" | "sm" | "md" | "lg";
  hoverable?: boolean;
}

const paddingClasses = {
  none: "",
  sm: "p-3",
  md: "p-4",
  lg: "p-6",
};

export function Card({
  className,
  padding = "md",
  hoverable = false,
  children,
  ...props
}: CardProps) {
  return (
    <div
      className={cn(
        // Use theme tokens
        "rounded-lg border border-[var(--color-border)] bg-[var(--color-bg)] shadow-[var(--shadow-sm)]",
        paddingClasses[padding],
        hoverable && "transition-shadow hover:shadow-[var(--shadow-md)] cursor-pointer",
        className
      )}
      {...props}
    >
      {children}
    </div>
  );
}

export function CardTitle({ className, ...props }: React.HTMLAttributes<HTMLHeadingElement>) {
  return (
    <h3
      className={cn("text-lg font-semibold text-[var(--color-text)]", className)}
      {...props}
    />
  );
}

export function CardDescription({ className, ...props }: React.HTMLAttributes<HTMLParagraphElement>) {
  return (
    <p
      className={cn("text-sm text-[var(--color-text-muted)]", className)}
      {...props}
    />
  );
}

// ... rest of sub-components
```

### Lab 6.5: Update Input Component

Update `packages/ui/src/components/Input.tsx` to use theme tokens:

```tsx
// In the input className:
className={cn(
  "flex h-10 w-full rounded-md border px-3 py-2 text-sm",
  "bg-[var(--color-bg)] text-[var(--color-text)]",
  "border-[var(--color-border)]",
  "placeholder:text-[var(--color-text-subtle)]",
  "focus:outline-none focus:ring-2 focus:ring-[var(--ring-color)] focus:border-[var(--color-primary)]",
  "disabled:cursor-not-allowed disabled:opacity-50 disabled:bg-[var(--color-bg-muted)]",
  error
    ? "border-[var(--color-error)] focus:border-[var(--color-error)] focus:ring-[var(--color-error)]"
    : "",
  className
)}
```

---

## Part 4: Lab - Create Theme Toggle (30 minutes)

### Lab 6.6: Create useTheme Hook

Create `apps/web/hooks/useTheme.ts`:

```typescript
"use client";

import { useEffect, useState } from "react";

type Theme = "light" | "dark" | "system";

export function useTheme() {
  const [theme, setTheme] = useState<Theme>("system");
  const [resolvedTheme, setResolvedTheme] = useState<"light" | "dark">("light");

  // Initialize theme from localStorage or system preference
  useEffect(() => {
    const stored = localStorage.getItem("theme") as Theme | null;
    if (stored) {
      setTheme(stored);
    }

    // Get resolved theme (what's actually shown)
    const isDark = document.documentElement.classList.contains("dark");
    setResolvedTheme(isDark ? "dark" : "light");
  }, []);

  // Apply theme changes
  useEffect(() => {
    const root = document.documentElement;

    if (theme === "system") {
      localStorage.removeItem("theme");
      const systemDark = window.matchMedia("(prefers-color-scheme: dark)").matches;
      root.classList.toggle("dark", systemDark);
      setResolvedTheme(systemDark ? "dark" : "light");
    } else {
      localStorage.setItem("theme", theme);
      root.classList.toggle("dark", theme === "dark");
      setResolvedTheme(theme);
    }
  }, [theme]);

  // Listen for system preference changes
  useEffect(() => {
    if (theme !== "system") return;

    const mediaQuery = window.matchMedia("(prefers-color-scheme: dark)");
    const handler = (e: MediaQueryListEvent) => {
      document.documentElement.classList.toggle("dark", e.matches);
      setResolvedTheme(e.matches ? "dark" : "light");
    };

    mediaQuery.addEventListener("change", handler);
    return () => mediaQuery.removeEventListener("change", handler);
  }, [theme]);

  return {
    theme,
    setTheme,
    resolvedTheme,
  };
}
```

### Lab 6.7: Create ThemeToggle Component

Create `apps/web/components/ThemeToggle.tsx`:

```tsx
"use client";

import { Button } from "@myapp/ui";
import { useTheme } from "@/hooks/useTheme";

export function ThemeToggle() {
  const { theme, setTheme, resolvedTheme } = useTheme();

  const cycleTheme = () => {
    if (theme === "light") setTheme("dark");
    else if (theme === "dark") setTheme("system");
    else setTheme("light");
  };

  const icon = resolvedTheme === "dark" ? "🌙" : "☀️";
  const label =
    theme === "system"
      ? `System (${resolvedTheme})`
      : theme.charAt(0).toUpperCase() + theme.slice(1);

  return (
    <Button variant="ghost" size="sm" onClick={cycleTheme}>
      <span className="mr-2">{icon}</span>
      {label}
    </Button>
  );
}
```

### Lab 6.8: Prevent Flash of Wrong Theme

Update `apps/web/app/layout.tsx`:

```tsx
import "./globals.css";
import "@myapp/ui/styles";  // Import theme CSS

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en" suppressHydrationWarning>
      <head>
        {/* Inline script to prevent flash */}
        <script
          dangerouslySetInnerHTML={{
            __html: `
              (function() {
                const theme = localStorage.getItem('theme');
                const prefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches;

                if (theme === 'dark' || (!theme && prefersDark)) {
                  document.documentElement.classList.add('dark');
                }
              })();
            `,
          }}
        />
      </head>
      <body>{children}</body>
    </html>
  );
}
```

### Lab 6.9: Add Toggle to Page

Update `apps/web/app/page.tsx` to include the toggle:

```tsx
import { ThemeToggle } from "@/components/ThemeToggle";

export default function Home() {
  return (
    <main className="min-h-screen bg-[var(--color-bg)] text-[var(--color-text)]">
      <header className="border-b border-[var(--color-border)] p-4">
        <div className="max-w-6xl mx-auto flex justify-between items-center">
          <h1 className="text-xl font-bold">Design System</h1>
          <ThemeToggle />
        </div>
      </header>

      <div className="max-w-6xl mx-auto p-8">
        {/* Rest of your content */}
      </div>
    </main>
  );
}
```

---

## Part 5: Lab - Test the Theme (15 minutes)

### Lab 6.10: Manual Testing

1. Run `pnpm dev`
2. Open the app in browser
3. Click the theme toggle
4. Verify:
   - [ ] Background color changes
   - [ ] Text color changes
   - [ ] Buttons look correct in both themes
   - [ ] Cards have proper borders in both themes
   - [ ] Focus rings are visible in both themes

### Lab 6.11: Test Persistence

1. Set theme to "Dark"
2. Refresh the page
3. Verify it stays dark (no flash)

### Lab 6.12: Test System Preference

1. Set theme to "System"
2. Change your OS appearance setting
3. Verify the app responds

---

## Part 6: Compare with Real Projects (15 minutes)

### Lab 6.13: Supabase Theming

```bash
# In supabase repo
ls packages/ui/src/lib/theme/
cat packages/ui/src/lib/theme/colors.ts
```

**Questions:**
1. How do they define theme colors?
2. How do they handle multiple themes beyond light/dark?

### Lab 6.14: Cal.com Theming

Look at Cal.com's Tailwind config for theme handling:
```bash
# In cal.com repo
cat packages/config/tailwind-preset.js
```

---

## Part 7: Reflection (15 minutes)

### Written Reflection

1. **Why use CSS custom properties for theming?**
   ```


   ```

2. **What's the difference between primitive and semantic tokens?**
   ```


   ```

3. **How did you prevent the flash of wrong theme?**
   ```


   ```

4. **When would you add more themes beyond light/dark?**
   ```


   ```

---

## Part 8: Self-Check

Before moving to Chapter 7, verify:

- [ ] Created theme CSS with light and dark tokens
- [ ] Updated components to use theme variables
- [ ] Theme toggle works correctly
- [ ] Theme persists across refreshes
- [ ] No flash of wrong theme on load
- [ ] System preference is detected

---

## Files You Should Have

```
packages/ui/
├── src/
│   ├── styles/
│   │   └── theme.css
│   └── components/
│       ├── Button.tsx  (updated)
│       ├── Card.tsx    (updated)
│       └── Input.tsx   (updated)

apps/web/
├── hooks/
│   └── useTheme.ts
├── components/
│   └── ThemeToggle.tsx
└── app/
    └── layout.tsx  (updated)
```

---

## Extension Exercises

### Exercise 6.1: Add More Theme Variants

Create a "high contrast" theme for accessibility:
```css
.high-contrast {
  --color-text: var(--black);
  --color-bg: var(--white);
  --color-border: var(--black);
}
```

### Exercise 6.2: Theme Selector Dropdown

Replace the toggle with a dropdown that shows all options:
- Light
- Dark
- System
- High Contrast

### Exercise 6.3: Color Scheme Customization

Add the ability to change the primary color:
- Store in localStorage
- Update `--color-primary` dynamically
- Create a color picker component
