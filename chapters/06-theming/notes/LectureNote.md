# Lecture Notes: Theming (Part 1 - Theory)

**Duration:** 30-45 minutes
**Chapter:** 06 - Theming

---

## Lecture Outline

1. Opening Question
2. The Two-Layer Token Architecture
3. How CSS Custom Properties Enable Theming
4. The Flash Problem (and Solution)
5. The Theme State Machine
6. Building Theme-Aware Components
7. Key Takeaways

---

## 1. Opening Question (3 minutes)

> **Ask the class:** "Your PM says 'We need dark mode by Friday.' What's your first reaction?"

**Expected answers:** "That's a lot of work," "Every component needs updating," "We should have planned for this," panic...

**Instructor note:** This question surfaces the fear of theming. Without proper architecture, dark mode IS a massive undertaking. With the right token structure, it's a CSS file and a toggle.

**Follow-up:** "What if I told you that with the right foundation, adding dark mode is less than 50 lines of CSS?"

---

## 2. The Two-Layer Token Architecture (10 minutes)

### The Secret to Easy Theming

Theming becomes trivial when you separate tokens into two layers:

```
┌─────────────────────────────────────────────────────────────────┐
│  SEMANTIC TOKENS (change per theme)                             │
│                                                                 │
│  --color-bg          → background of containers                 │
│  --color-text        → main text color                          │
│  --color-border      → border color                             │
│  --color-primary     → brand/action color                       │
├─────────────────────────────────────────────────────────────────┤
│  PRIMITIVE TOKENS (stay constant)                               │
│                                                                 │
│  --gray-50: #F9FAFB                                             │
│  --gray-900: #111827                                            │
│  --blue-500: #3B82F6                                            │
│  --white: #FFFFFF                                               │
│  --black: #000000                                               │
└─────────────────────────────────────────────────────────────────┘
```

### How They Connect

**Primitive tokens** are raw values—they never change:

```css
:root {
  --gray-50: #F9FAFB;
  --gray-900: #111827;
  --white: #FFFFFF;
}
```

**Semantic tokens** have meaning and REFERENCE primitives:

```css
/* Light theme (default) */
:root {
  --color-bg: var(--white);
  --color-text: var(--gray-900);
}

/* Dark theme */
.dark {
  --color-bg: var(--gray-900);
  --color-text: var(--gray-50);
}
```

### Why This Works

Components only use semantic tokens:

```css
.card {
  background: var(--color-bg);
  color: var(--color-text);
}
```

When `.dark` is added to `<html>`:
- `--color-bg` changes from white to dark gray
- `--color-text` changes from dark gray to light gray
- **The component CSS doesn't change at all**

### Visual: Token Flow

```
Light Theme:

  Primitive             Semantic              Component
  ─────────────────────────────────────────────────────
  --white: #FFF    →   --color-bg: var(--white)  →  .card { background: var(--color-bg) }
  --gray-900       →   --color-text: var(--gray-900)  →  .card { color: var(--color-text) }


Dark Theme (just swap semantic assignments):

  Primitive             Semantic              Component
  ─────────────────────────────────────────────────────
  --gray-900       →   --color-bg: var(--gray-900)  →  .card { background: var(--color-bg) }
  --gray-50        →   --color-text: var(--gray-50)  →  .card { color: var(--color-text) }

                   ↑
              ONLY THIS LAYER CHANGES
```

> **Key insight:** The primitive layer is your palette. The semantic layer assigns meaning. Components use meaning, not raw values.

---

## 3. How CSS Custom Properties Enable Theming (7 minutes)

### Why CSS Variables (Not JS)?

| Approach | Pros | Cons |
|----------|------|------|
| **CSS Variables** | Instant updates, no re-render, cascade naturally | Limited to CSS values |
| **JS Theme Object** | Full programmatic control | Requires re-render, flash possible |
| **CSS-in-JS Themes** | Type-safe, JS integration | Runtime overhead, flash possible |

CSS custom properties win for theming because:
1. **No re-render needed** — browser updates instantly
2. **Cascade naturally** — `.dark` class flows to all children
3. **No flash** — can be set before first paint
4. **Zero runtime cost** — no JavaScript needed after initial setup

### The Cascade in Action

```html
<html class="dark">               ← Sets --color-bg: #111827
  <body>                          ← Inherits --color-bg
    <main>                        ← Inherits --color-bg
      <div class="card">          ← Uses var(--color-bg) = #111827
        <p>Hello</p>
      </div>
    </main>
  </body>
</html>
```

One class on `<html>` changes every component in the entire app.

### Scoped Theme Overrides

You can even override themes locally:

```html
<html class="dark">
  <body>
    <!-- Most of the app is dark -->
    <main class="light">
      <!-- This section stays light -->
      <div class="card">Light card in dark app</div>
    </main>
  </body>
</html>
```

This enables "island" theming—useful for embeds, previews, and admin panels.

---

## 4. The Flash Problem (and Solution) (8 minutes)

### The Problem

Without proper handling, users see a jarring flash:

```
Timeline:
─────────────────────────────────────────────────────────────────►

[0ms]     HTML loads, default styles applied (light theme)
[50ms]    Browser paints light theme to screen
[100ms]   JavaScript loads and executes
[150ms]   JS reads localStorage: "theme = dark"
[160ms]   JS adds .dark class to <html>
[170ms]   Browser repaints to dark theme
                              ↑
                        FLASH! User sees light → dark transition
```

### Why It Happens

1. CSS loads and applies before JavaScript
2. Default theme is light (no `.dark` class)
3. Browser paints as soon as it has HTML + CSS
4. JavaScript runs AFTER first paint
5. Theme switch causes visible repaint

### The Solution: Blocking Script

Add an inline script in `<head>` that runs **before** the body renders:

```html
<head>
  <script>
    // This runs synchronously, blocking render
    (function() {
      const theme = localStorage.getItem('theme');
      const prefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches;

      if (theme === 'dark' || (!theme && prefersDark)) {
        document.documentElement.classList.add('dark');
      }
    })();
  </script>
</head>
<body>
  <!-- Body renders with correct theme already applied -->
</body>
```

### Fixed Timeline

```
Timeline:
─────────────────────────────────────────────────────────────────►

[0ms]     HTML <head> loads
[10ms]    Inline script runs (blocking)
[11ms]    Script reads localStorage: "dark"
[12ms]    Script adds .dark class to <html>
[50ms]    CSS loads with .dark already applied
[100ms]   Browser paints DARK theme (correct!)
          ↑
     NO FLASH - theme is correct from first paint
```

### The `suppressHydrationWarning`

In React/Next.js, you need this attribute:

```tsx
<html lang="en" suppressHydrationWarning>
```

Why? The server renders without knowing the user's preference. The client-side script may add `.dark`, causing a mismatch. This attribute tells React "I know what I'm doing, don't warn me."

---

## 5. The Theme State Machine (7 minutes)

### Three States, Not Two

A proper theme system has three states:

| State | Meaning |
|-------|---------|
| `light` | User explicitly chose light |
| `dark` | User explicitly chose dark |
| `system` | Follow OS preference |

### The State Flow

```
┌─────────────────────────────────────────────────────────────────┐
│                    THEME STATE MACHINE                          │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│   ┌─────────┐      click       ┌─────────┐                     │
│   │  light  │ ───────────────► │  dark   │                     │
│   └────┬────┘                  └────┬────┘                     │
│        │                            │                          │
│        │ click                      │ click                    │
│        │                            │                          │
│        │      ┌─────────┐           │                          │
│        └────► │ system  │ ◄─────────┘                          │
│               └────┬────┘                                      │
│                    │                                           │
│                    │ OS changes                                │
│                    ▼                                           │
│            ┌───────────────┐                                   │
│            │ resolved theme│                                   │
│            │ (light/dark)  │                                   │
│            └───────────────┘                                   │
│                                                                │
└─────────────────────────────────────────────────────────────────┘
```

### Why "System" Matters

Users expect apps to respect their OS preference. The flow:

1. **First visit**: No localStorage → use system preference
2. **User toggles to dark**: Save `dark` to localStorage
3. **User toggles to system**: Remove from localStorage, follow OS
4. **OS changes** (when in system mode): App updates automatically

### Listening to System Changes

```typescript
// When theme is "system", listen for OS changes
useEffect(() => {
  if (theme !== "system") return;

  const mediaQuery = window.matchMedia("(prefers-color-scheme: dark)");

  const handler = (e: MediaQueryListEvent) => {
    document.documentElement.classList.toggle("dark", e.matches);
  };

  mediaQuery.addEventListener("change", handler);
  return () => mediaQuery.removeEventListener("change", handler);
}, [theme]);
```

This means: if a user has theme set to "system" and they change their OS to dark mode at 9pm, your app immediately switches.

---

## 6. Building Theme-Aware Components (5 minutes)

### The Simple Pattern

Components use semantic tokens, never primitives:

```tsx
// BAD: Using hardcoded or primitive values
<div className="bg-white text-gray-900 border-gray-200">

// GOOD: Using semantic tokens
<div className="bg-[var(--color-bg)] text-[var(--color-text)] border-[var(--color-border)]">
```

### With Tailwind CSS

If using Tailwind, you can map semantic tokens to Tailwind's config:

```javascript
// tailwind.config.js
module.exports = {
  theme: {
    extend: {
      colors: {
        background: 'var(--color-bg)',
        foreground: 'var(--color-text)',
        border: 'var(--color-border)',
        primary: {
          DEFAULT: 'var(--color-primary)',
          hover: 'var(--color-primary-hover)',
        },
      },
    },
  },
};
```

Then use natural Tailwind classes:

```tsx
<div className="bg-background text-foreground border-border">
<button className="bg-primary hover:bg-primary-hover">
```

### Component Token Mapping

| Component Part | Semantic Token |
|---------------|----------------|
| Page background | `--color-bg` |
| Card background | `--color-bg` |
| Primary text | `--color-text` |
| Secondary text | `--color-text-muted` |
| Borders | `--color-border` |
| Buttons (primary) | `--color-primary` |
| Focus rings | `--ring-color` |
| Errors | `--color-error` |
| Shadows | `--shadow-sm`, `--shadow-md` |

---

## 7. Key Takeaways (4 minutes)

### Summary Visual

```
┌─────────────────────────────────────────────────────────────────┐
│                    THEMING ARCHITECTURE                          │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│   PRIMITIVE TOKENS          SEMANTIC TOKENS           THEMES     │
│   (constant)                (meaningful)              (swap)     │
│                                                                  │
│   --gray-50: #F9FAFB        --color-bg                :root {}  │
│   --gray-900: #111827   →   --color-text          →   .dark {}  │
│   --blue-500: #3B82F6       --color-primary           .light {} │
│   --white: #FFFFFF          --color-border                      │
│                                                                  │
│                                                                  │
│   COMPONENTS                                                     │
│                                                                  │
│   .card {                                                       │
│     background: var(--color-bg);    ← Uses semantic tokens      │
│     color: var(--color-text);                                   │
│     border: 1px solid var(--color-border);                      │
│   }                                                              │
│                                                                  │
│   Component CSS never changes between themes!                    │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

### Three Things to Remember

1. **Two-layer tokens: primitives (raw) and semantics (meaningful)** — Primitives are your palette and never change. Semantic tokens have meaning and swap between themes. Components only use semantic tokens.

2. **Prevent flash with inline blocking script** — A script in `<head>` that runs before render can check localStorage and system preference, applying the correct class before the first paint.

3. **Three theme states: light, dark, system** — Respect user OS preference with "system" mode. Listen for system changes and update automatically.

### The Complete Flow

```
┌─────────────────────────────────────────────────────────────────┐
│                     THEME FLOW                                   │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  1. PAGE LOAD                                                    │
│     <head> script checks localStorage + system preference        │
│     Adds .dark class if needed (before paint)                   │
│                                                                  │
│  2. CSS LOADS                                                    │
│     :root { --color-bg: white }                                 │
│     .dark { --color-bg: #111827 }                               │
│     Correct values are set based on class                       │
│                                                                  │
│  3. COMPONENTS RENDER                                            │
│     .card { background: var(--color-bg) }                       │
│     All use semantic tokens → automatically themed              │
│                                                                  │
│  4. USER TOGGLES                                                 │
│     JavaScript toggles .dark class on <html>                    │
│     Saves preference to localStorage                            │
│     CSS variables update → instant repaint                      │
│                                                                  │
│  5. SYSTEM CHANGES (if theme === "system")                       │
│     OS preference changes (e.g., sunset triggers dark mode)     │
│     Event listener toggles class                                │
│     App updates automatically                                   │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

## Looking Ahead

In the **lab section**, you'll:
- Create theme CSS with primitive and semantic tokens
- Update Button, Card, and Input to use theme tokens
- Build a useTheme hook with three-state logic
- Create a theme toggle component
- Implement flash prevention with inline script
- Test persistence and system preference detection

In **Chapter 7**, we'll set up Storybook for component documentation—allowing you to see your themed components in isolation and create a living style guide.

---

## Discussion Questions for Class

1. Your designer wants a "sepia" theme for reading mode. How would you add it to the token system?

2. A component needs different shadows in light vs dark mode (darker shadows look weird on dark backgrounds). Where does this customization happen?

3. What happens if a user visits on a device with system dark mode, then switches to a device with system light mode? Should the app remember their preference or follow the new device?

4. How would you handle theming in an email template where CSS custom properties aren't supported?

---

## Common Misconceptions

### "Dark mode is just inverting colors"

**Correction:** Simple inversion creates accessibility issues and looks terrible. Dark mode requires intentional design: slightly different hues, adjusted contrast ratios, and rethought shadows.

### "We need JavaScript for theming"

**Correction:** The core theming mechanism is pure CSS. JavaScript is only needed for the toggle interaction and persistence. The actual theme switch is just adding/removing a class.

### "CSS variables are slow"

**Correction:** CSS custom properties are extremely fast. The browser optimizes them heavily. They're faster than CSS-in-JS runtime theme switches.

### "We should store the resolved theme (light/dark)"

**Correction:** Store the user's *choice* (light/dark/system), not the resolved value. This preserves the "system" option across devices and OS changes.

---

## Accessibility Considerations

### Contrast Ratios

Both themes must meet WCAG contrast requirements:
- Normal text: 4.5:1 minimum
- Large text: 3:1 minimum
- UI components: 3:1 minimum

### Respecting User Preference

The `prefers-color-scheme` media query exists because some users NEED dark mode (light sensitivity, migraines). Always support system preference.

### Motion Considerations

Theme transitions should respect `prefers-reduced-motion`:

```css
@media (prefers-reduced-motion: no-preference) {
  * {
    transition: background-color 0.2s, color 0.2s;
  }
}
```

---

## Additional Resources

- **Article:** "A Complete Guide to Dark Mode on the Web" (CSS-Tricks)
- **Spec:** [prefers-color-scheme MDN](https://developer.mozilla.org/en-US/docs/Web/CSS/@media/prefers-color-scheme)
- **Tool:** [Contrast Checker](https://webaim.org/resources/contrastchecker/)
- **Library:** [next-themes](https://github.com/pacocoursey/next-themes) (handles flash automatically)
- **Example:** [Tailwind CSS Dark Mode](https://tailwindcss.com/docs/dark-mode)

---

## Preparation for Lab

Before the lab, ensure you have:
- [ ] Completed Chapters 1-5 (working components)
- [ ] Understanding of CSS custom properties
- [ ] Browser DevTools open (to inspect computed styles)
- [ ] OS dark mode toggle accessible (to test system preference)
