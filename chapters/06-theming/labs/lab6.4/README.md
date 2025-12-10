# Lab 6.4: Flash Prevention & Layout Integration

## Objective

Prevent the "flash of wrong theme" on page load and integrate the theme toggle into the app layout.

## Time Estimate

~25 minutes

## Prerequisites

- Completed Lab 6.3 (useTheme hook and ThemeToggle created)
- Understanding of Next.js App Router layout
- Familiarity with `<script>` execution timing

## Setup

### Quick Setup

```bash
./setup.sh
```

This will:
1. Check that Lab 6.3 is complete
2. Update layout.tsx with flash prevention script
3. Update page.tsx to include the ThemeToggle

### Manual Setup

Navigate to your web app:
```bash
cd ../../../04-monorepo-architecture/labs/lab4.1/apps/web/app
```

## Exercises

### Exercise 1: Understand the Flash Problem

Without proper handling, users see a flash of wrong theme:

```
Timeline:
─────────────────────────────────────────────────────►

1. Browser requests page
2. HTML arrives (default light styles)
3. Page renders (LIGHT)         ← User sees light
4. CSS loads
5. JavaScript loads
6. JavaScript runs
7. JS reads localStorage (dark)
8. JS applies .dark class
9. Page repaints (DARK)         ← User sees dark
         ↑
       FLASH! (steps 3-9)
```

The user briefly sees the wrong theme before JavaScript corrects it.

### Exercise 2: Examine the Solution

Open `apps/web/app/layout.tsx`:

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

**Key points:**
1. Script is **inline** (not external file) - runs immediately
2. Script is in `<head>` - runs before body renders
3. Script is an IIFE - executes immediately, no waiting
4. Uses `dangerouslySetInnerHTML` - Next.js way to inline scripts

### Exercise 3: Understand suppressHydrationWarning

```tsx
<html lang="en" suppressHydrationWarning>
```

This is necessary because:
1. Server renders `<html>` without `.dark` class
2. Inline script may add `.dark` class before React hydrates
3. React would normally warn about the mismatch
4. `suppressHydrationWarning` tells React this is expected

**Without it:** Console warning about hydration mismatch
**With it:** Clean console, intended behavior

### Exercise 4: Examine the Updated Page

Open `apps/web/app/page.tsx`:

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
        {/* Component demos */}
      </div>
    </main>
  );
}
```

**Note the theme token usage:**
- `bg-[var(--color-bg)]` - Page background
- `text-[var(--color-text)]` - Text color
- `border-[var(--color-border)]` - Header border

### Exercise 5: Alternative Flash Prevention

Other approaches exist:

**A. Cookie-based (server-side):**
```tsx
// In middleware or server component
const theme = cookies().get('theme')?.value;
return <html className={theme === 'dark' ? 'dark' : ''}>
```
- Pro: No flash at all
- Con: More complex, requires middleware

**B. CSS-only (media query):**
```css
@media (prefers-color-scheme: dark) {
  :root { /* dark variables */ }
}
```
- Pro: No JavaScript needed
- Con: Can't persist user override

**C. Blocking script in `<head>`:**
```html
<script src="/theme.js"></script>  <!-- blocking -->
```
- Pro: Simple
- Con: Delays page load

The inline IIFE approach balances simplicity and effectiveness.

## Key Concepts

### Why Inline Script Works

```
With inline script in <head>:
─────────────────────────────────────────────────────►

1. Browser requests page
2. HTML arrives
3. <head> parses, inline script runs
4. Script checks localStorage
5. Script adds .dark if needed
6. <body> parses and renders (CORRECT theme)  ← User sees correct theme
7. CSS loads (variables already set)
8. React hydrates
```

The script runs **before** the body renders, so there's no flash.

### The IIFE Pattern

```javascript
(function() {
  // Code here runs immediately
})();
```

- Immediately Invoked Function Expression
- Creates scope (no global pollution)
- Executes synchronously as HTML parses

### Import Order Matters

```tsx
import "./globals.css";
import "@myapp/ui/styles";  // Theme variables must be available
```

Import theme CSS before components render to ensure variables are defined.

## Checklist

Before proceeding to Lab 6.5:

- [ ] layout.tsx has inline theme script
- [ ] layout.tsx imports theme CSS
- [ ] html element has suppressHydrationWarning
- [ ] page.tsx includes ThemeToggle
- [ ] page.tsx uses theme tokens for layout
- [ ] Understand why inline script prevents flash
- [ ] Understand suppressHydrationWarning purpose

## Troubleshooting

### Still seeing flash

1. Verify script is in `<head>`, not `<body>`
2. Verify script is inline (not external file)
3. Check script syntax - any error prevents execution
4. Verify localStorage key matches (`theme`)

### Hydration mismatch warnings

1. Ensure `suppressHydrationWarning` is on `<html>`
2. Not on `<body>` or other elements
3. Check for other potential mismatches

### Theme CSS not loading

1. Check import path: `import "@myapp/ui/styles"`
2. Verify package.json exports: `"./styles": "./src/styles/theme.css"`
3. Run `pnpm install` from monorepo root

### Script not running

1. Check browser console for syntax errors
2. Verify `dangerouslySetInnerHTML` syntax
3. Test script logic in browser console

## Next

Proceed to Lab 6.5 to test the theme system and compare with real-world projects.
