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

## Part 2: Labs

### Lab 6.1: Create Theme CSS (~25 minutes)

**Objective:** Create a theme CSS file with primitive and semantic design tokens.

**Topics:**
- CSS custom properties for theming
- Primitive vs semantic tokens
- Light and dark theme definitions

**Key Concepts:**
- Why primitives stay constant across themes
- How semantic tokens reference primitives
- Class-based dark mode (`.dark`)

[→ Go to Lab 6.1](./labs/lab6.1/README.md)

---

### Lab 6.2: Update Components to Use Theme Tokens (~30 minutes)

**Objective:** Update Button, Card, and Input components to use CSS custom property tokens.

**Topics:**
- Tailwind arbitrary value syntax `[var(--token)]`
- Token mapping for backgrounds, text, borders
- Focus ring and shadow tokens

**Key Concepts:**
- Converting hardcoded colors to tokens
- Token categories (bg, text, border, shadow)
- How components automatically adapt to themes

[→ Go to Lab 6.2](./labs/lab6.2/README.md)

---

### Lab 6.3: Create Theme Toggle Hook & Component (~30 minutes)

**Objective:** Create `useTheme` hook and `ThemeToggle` component for theme switching.

**Topics:**
- Three theme states: light, dark, system
- localStorage persistence
- System preference detection with matchMedia

**Key Concepts:**
- Resolved vs selected theme
- Event listener for OS preference changes
- Client-side only hooks ("use client")

[→ Go to Lab 6.3](./labs/lab6.3/README.md)

---

### Lab 6.4: Flash Prevention & Layout Integration (~25 minutes)

**Objective:** Prevent flash of wrong theme and integrate toggle into app layout.

**Topics:**
- Inline script in `<head>` for early execution
- `suppressHydrationWarning` for server/client mismatch
- Theme CSS import order

**Key Concepts:**
- Why inline scripts prevent flash
- IIFE pattern for immediate execution
- Next.js hydration considerations

[→ Go to Lab 6.4](./labs/lab6.4/README.md)

---

### Lab 6.5: Testing, Comparison & Reflection (~30 minutes)

**Objective:** Test the theme system and compare with real-world implementations.

**Topics:**
- Manual testing checklist
- Persistence and flash testing
- Supabase and Cal.com theming comparison

**Key Concepts:**
- Testing theme persistence
- Accessibility considerations
- Production enhancement patterns

[→ Go to Lab 6.5](./labs/lab6.5/README.md)

---

## Part 3: Self-Check & Reflection

### Files You Should Have

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
    ├── layout.tsx  (updated)
    └── page.tsx    (updated)
```

### Self-Check

Before moving to Chapter 7, verify:

- [ ] Created theme CSS with light and dark tokens
- [ ] Updated components to use theme variables
- [ ] Theme toggle works correctly
- [ ] Theme persists across refreshes
- [ ] No flash of wrong theme on load
- [ ] System preference is detected

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

---

## Next Chapter

In Chapter 7, you'll learn about component composition patterns and slots.
