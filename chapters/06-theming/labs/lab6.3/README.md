# Lab 6.3: Create Theme Toggle Hook & Component

## Objective

Create a `useTheme` hook for managing theme state and a `ThemeToggle` component for switching between light, dark, and system themes.

## Time Estimate

~30 minutes

## Prerequisites

- Completed Lab 6.2 (components use theme tokens)
- Understanding of React hooks and state
- Familiarity with localStorage and matchMedia APIs

## Setup

### Quick Setup

```bash
./setup.sh
```

This will:
1. Check that Lab 6.2 is complete
2. Create the `useTheme` hook
3. Create the `ThemeToggle` component

### Manual Setup

Navigate to your web app:
```bash
cd ../../../04-monorepo-architecture/labs/lab4.1/apps/web
```

## Exercises

### Exercise 1: Understand the Theme States

The theme system supports three states:

| Theme | Behavior |
|-------|----------|
| `light` | Always light mode |
| `dark` | Always dark mode |
| `system` | Follow OS preference |

The `resolvedTheme` is always either `light` or `dark` - it's what's actually displayed.

```tsx
const { theme, setTheme, resolvedTheme } = useTheme();

theme          // "light" | "dark" | "system"
resolvedTheme  // "light" | "dark" (what's shown)
```

### Exercise 2: Examine the useTheme Hook

Open `apps/web/hooks/useTheme.ts`:

```typescript
"use client";

import { useEffect, useState } from "react";

type Theme = "light" | "dark" | "system";

export function useTheme() {
  const [theme, setTheme] = useState<Theme>("system");
  const [resolvedTheme, setResolvedTheme] = useState<"light" | "dark">("light");

  // Initialize from localStorage
  useEffect(() => {
    const stored = localStorage.getItem("theme") as Theme | null;
    if (stored) {
      setTheme(stored);
    }
    // Get what's actually shown
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

  // Listen for OS preference changes
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

  return { theme, setTheme, resolvedTheme };
}
```

**Key patterns:**
1. `"use client"` - Required for hooks that use browser APIs
2. Initialize from localStorage on mount
3. Apply changes by toggling `.dark` class on `<html>`
4. Listen for system preference changes when in "system" mode

**Questions:**
1. Why check `document.documentElement.classList.contains("dark")` on init?
2. Why remove localStorage item when switching to "system"?
3. Why clean up the event listener when theme changes from "system"?

### Exercise 3: Examine the ThemeToggle Component

Open `apps/web/components/ThemeToggle.tsx`:

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

**Design decisions:**
- Cycles through: light → dark → system → light
- Shows icon based on resolved (visible) theme
- Shows label indicating current setting
- When in system mode, shows "System (dark)" or "System (light)"

### Exercise 4: Understand the Class Toggle Strategy

The hook uses `classList.toggle("dark", condition)`:

```typescript
root.classList.toggle("dark", theme === "dark");
```

This is cleaner than:
```typescript
if (theme === "dark") {
  root.classList.add("dark");
} else {
  root.classList.remove("dark");
}
```

The second argument to `toggle()` is a boolean that determines whether to add or remove.

### Exercise 5: Alternative Implementations

Consider these alternatives:

**A. Data attribute instead of class:**
```tsx
// In hook
root.dataset.theme = theme;

// In CSS
[data-theme="dark"] {
  --color-bg: var(--gray-950);
}
```

**B. CSS media query only (no JS toggle):**
```css
@media (prefers-color-scheme: dark) {
  :root {
    --color-bg: var(--gray-950);
  }
}
```

**Why class-based is preferred:**
- Allows user override of system preference
- Works with server-side rendering
- Can persist choice in localStorage
- More explicit control

## Key Concepts

### The Three-State Model

```
User Choice (theme)          Resolved (what shows)
─────────────────────────    ────────────────────
"light"                  →   "light"
"dark"                   →   "dark"
"system" + OS light      →   "light"
"system" + OS dark       →   "dark"
```

### localStorage Strategy

| Action | localStorage | DOM |
|--------|-------------|-----|
| Set "light" | `theme: "light"` | Remove `.dark` |
| Set "dark" | `theme: "dark"` | Add `.dark` |
| Set "system" | Remove `theme` | Add/remove `.dark` based on OS |

### System Preference Detection

```typescript
// Check current preference
window.matchMedia("(prefers-color-scheme: dark)").matches

// Listen for changes
window.matchMedia("(prefers-color-scheme: dark)")
  .addEventListener("change", (e) => {
    console.log("Dark mode:", e.matches);
  });
```

## Checklist

Before proceeding to Lab 6.4:

- [ ] useTheme hook created
- [ ] ThemeToggle component created
- [ ] Understand three theme states (light/dark/system)
- [ ] Understand localStorage persistence
- [ ] Understand system preference detection
- [ ] Can explain why `.dark` class on `<html>` element

## Troubleshooting

### "localStorage is not defined"

This happens during server-side rendering. The hook handles this by:
1. Using `"use client"` directive
2. Initializing state with safe defaults
3. Reading localStorage only in useEffect (client-side only)

### Theme not persisting

1. Check browser DevTools → Application → Local Storage
2. Verify `theme` key is being set
3. Check for any errors in console

### System preference changes not detected

1. Verify you're in "system" mode (not "light" or "dark")
2. Check that event listener is attached (no errors in console)
3. Test by changing OS appearance settings

## Next

Proceed to Lab 6.4 to prevent flash of wrong theme and integrate into the layout.
