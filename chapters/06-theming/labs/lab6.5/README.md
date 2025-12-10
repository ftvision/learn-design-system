# Lab 6.5: Testing, Comparison & Reflection

## Objective

Test the theme system thoroughly, compare with real-world implementations, and reflect on theming concepts.

## Time Estimate

~30 minutes

## Prerequisites

- Completed Labs 6.1-6.4
- Theme toggle working
- Dev server running (`pnpm dev`)

## Setup

### Quick Setup

```bash
./setup.sh
```

This will:
1. Check that previous labs are complete
2. Display testing checklist
3. No new files created (testing lab)

### Start the Dev Server

```bash
cd ../../../04-monorepo-architecture/labs/lab4.1
pnpm dev
```

## Exercises

### Exercise 1: Manual Testing Checklist

Open the app in browser and verify each item:

**Theme Toggle:**
- [ ] Click toggle: light → dark → system → light
- [ ] Toggle shows correct icon (☀️ for light, 🌙 for dark)
- [ ] "System" mode shows "(light)" or "(dark)" suffix

**Visual Changes (Light → Dark):**
- [ ] Page background changes (white → dark gray)
- [ ] Text color changes (dark → light)
- [ ] Card backgrounds adapt
- [ ] Card borders visible in both themes
- [ ] Button variants all look correct
- [ ] Input backgrounds and borders adapt
- [ ] Focus rings visible in both themes
- [ ] Shadows visible (may be subtler in dark)

**Accessibility:**
- [ ] Sufficient contrast in both themes
- [ ] Focus indicators clearly visible
- [ ] No text becomes invisible

### Exercise 2: Test Persistence

1. Set theme to "Dark"
2. Refresh the page (Cmd/Ctrl + R)
3. Verify: Page loads directly in dark mode (no flash)
4. Set theme to "Light"
5. Refresh
6. Verify: Page loads in light mode
7. Set to "System"
8. Verify: Follows OS preference

### Exercise 3: Test Flash Prevention

1. Set theme to "Dark"
2. Open DevTools → Network → Throttling → Slow 3G
3. Refresh page
4. Watch carefully: Should load dark immediately, no white flash
5. If you see white flash, check layout.tsx script placement

### Exercise 4: Test System Preference

**On macOS:**
1. Set app theme to "System"
2. Open System Settings → Appearance
3. Switch between Light and Dark
4. App should update automatically

**On Windows:**
1. Set app theme to "System"
2. Settings → Personalization → Colors
3. Switch "Choose your color"
4. App should follow

### Exercise 5: Compare with Supabase

Examine how Supabase handles theming:

```bash
# Clone or browse: https://github.com/supabase/supabase
# Look at:
# - packages/ui/src/lib/theme/
# - packages/ui/tailwind.config.js
```

**Questions to answer:**
1. How does Supabase define theme colors?
2. Do they use CSS custom properties or Tailwind config?
3. How many theme variants do they support?
4. How do they handle the dark mode toggle?

### Exercise 6: Compare with Cal.com

Examine Cal.com's approach:

```bash
# Browse: https://github.com/calcom/cal.com
# Look at:
# - packages/config/tailwind-preset.js
# - apps/web/app/layout.tsx
```

**Questions to answer:**
1. How do they extend Tailwind for theming?
2. Do they use a similar flash prevention technique?
3. What's their approach to semantic tokens?

### Exercise 7: Written Reflection

Answer these questions thoughtfully:

1. **Why use CSS custom properties for theming?**
   ```
   Your answer:


   ```

2. **What's the difference between primitive and semantic tokens?**
   ```
   Your answer:


   ```

3. **How did you prevent the flash of wrong theme?**
   ```
   Your answer:


   ```

4. **When would you add more themes beyond light/dark?**
   ```
   Your answer:


   ```

5. **What would you change about this theming implementation?**
   ```
   Your answer:


   ```

## Key Concepts

### Testing Strategy Summary

| Test Type | What to Check |
|-----------|---------------|
| Visual | Colors, shadows, borders adapt |
| Functional | Toggle cycles correctly |
| Persistence | Survives refresh |
| Flash | No white flash on dark mode load |
| System | Responds to OS preference |
| Accessibility | Contrast, focus visibility |

### Common Production Enhancements

**1. High Contrast Theme:**
```css
.high-contrast {
  --color-text: var(--black);
  --color-bg: var(--white);
  --color-border: var(--black);
}
```

**2. Brand Color Customization:**
```tsx
// Allow users to customize primary color
document.documentElement.style.setProperty('--color-primary', userColor);
```

**3. Theme Context Provider:**
```tsx
// More React-idiomatic approach
<ThemeProvider defaultTheme="system">
  <App />
</ThemeProvider>
```

**4. Server-Side Theme:**
```tsx
// Cookie-based for zero flash
import { cookies } from 'next/headers';
const theme = cookies().get('theme')?.value || 'system';
```

## Checklist

Before completing Chapter 6:

- [ ] Theme toggle works correctly
- [ ] Theme persists across refreshes
- [ ] No flash of wrong theme on load
- [ ] System preference is detected and followed
- [ ] Compared with at least one real-world project
- [ ] Completed written reflection
- [ ] Understand when to use theming tokens vs hardcoded colors

## Extension Exercises

### Extension 1: Add High Contrast Theme

Create a high contrast theme for accessibility:

```css
.high-contrast {
  --color-text: var(--black);
  --color-bg: var(--white);
  --color-border: var(--black);
  --color-primary: #0000EE;  /* Classic link blue */
}
```

Update the toggle to include this option.

### Extension 2: Theme Selector Dropdown

Replace the toggle with a dropdown:

```tsx
<select value={theme} onChange={(e) => setTheme(e.target.value)}>
  <option value="light">Light</option>
  <option value="dark">Dark</option>
  <option value="system">System</option>
  <option value="high-contrast">High Contrast</option>
</select>
```

### Extension 3: Color Scheme Customization

Allow users to change the primary color:

```tsx
const [primaryColor, setPrimaryColor] = useState('#3B82F6');

useEffect(() => {
  document.documentElement.style.setProperty('--color-primary', primaryColor);
}, [primaryColor]);

// Add a color picker input
<input type="color" value={primaryColor} onChange={...} />
```

## Troubleshooting

### Theme not persisting

1. Check localStorage in DevTools → Application → Local Storage
2. Verify key is `theme` (not `color-theme` or similar)
3. Check for any console errors

### Flash still occurring

1. Verify script is inline in `<head>`
2. Check script syntax (no errors)
3. Ensure localStorage key matches in script and hook

### System preference not updating

1. Must be in "system" mode, not "light" or "dark"
2. Check that mediaQuery listener is active
3. Some browsers may not fire events immediately

## Next Chapter

In Chapter 7, you'll learn about component composition patterns and slots.
