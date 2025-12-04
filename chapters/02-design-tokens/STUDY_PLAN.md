# Chapter 2 Study Plan: Design Tokens

## Part 1: Theory (20 minutes)

### 1.1 The Problem Tokens Solve

Imagine this scenario:

```tsx
// File 1: Button.tsx
<button style={{ backgroundColor: '#2196F3' }}>Click me</button>

// File 2: Link.tsx
<a style={{ color: '#2196f3' }}>Learn more</a>  // Slightly different!

// File 3: Header.tsx
<header style={{ borderBottom: '1px solid #2196F3' }}>...</header>
```

Problems:
1. The same "primary blue" is written 3 different ways
2. One has a typo (`#2196f3` vs `#2196F3`) - works but inconsistent
3. To change the brand color, you must find and replace everywhere
4. No way to have different colors for dark mode

### 1.2 The Token Solution

```tsx
// Define once
:root {
  --color-primary: #2196F3;
}

// Use everywhere
<button style={{ backgroundColor: 'var(--color-primary)' }}>Click me</button>
<a style={{ color: 'var(--color-primary)' }}>Learn more</a>
<header style={{ borderBottom: '1px solid var(--color-primary)' }}>...</header>
```

Now:
- One source of truth
- Change once, updates everywhere
- Easy dark mode (just redefine `--color-primary` in `.dark`)

### 1.3 Style Dictionary

Style Dictionary is a build tool that:
1. Reads token definitions (JSON/YAML)
2. Transforms them for different platforms
3. Outputs platform-specific files

```
tokens/colors.json  ─┐
tokens/spacing.json ─┼─► Style Dictionary ─┬─► build/css/variables.css
tokens/fonts.json   ─┘                     ├─► build/js/tokens.js
                                           ├─► build/ios/Colors.swift
                                           └─► build/android/colors.xml
```

---

## Part 2: Lab - Build Your Token System (1.5 hours)

### Lab 2.1: Project Setup

Create the project structure:

```bash
# Create the project directory
mkdir -p design-system-course/packages/tokens/src
cd design-system-course/packages/tokens

# Initialize npm
npm init -y

# Install Style Dictionary
npm install style-dictionary
```

Your structure should look like:
```
design-system-course/
└── packages/
    └── tokens/
        ├── src/           # Token source files go here
        ├── package.json
        └── (config file will go here)
```

### Lab 2.2: Create Color Tokens

Create `src/colors.json`:

```json
{
  "color": {
    "primary": {
      "50": { "value": "#E3F2FD", "comment": "Lightest primary" },
      "100": { "value": "#BBDEFB" },
      "200": { "value": "#90CAF9" },
      "300": { "value": "#64B5F6" },
      "400": { "value": "#42A5F5" },
      "500": { "value": "#2196F3", "comment": "Default primary" },
      "600": { "value": "#1E88E5" },
      "700": { "value": "#1976D2" },
      "800": { "value": "#1565C0" },
      "900": { "value": "#0D47A1", "comment": "Darkest primary" }
    },
    "neutral": {
      "0": { "value": "#FFFFFF" },
      "50": { "value": "#FAFAFA" },
      "100": { "value": "#F5F5F5" },
      "200": { "value": "#EEEEEE" },
      "300": { "value": "#E0E0E0" },
      "400": { "value": "#BDBDBD" },
      "500": { "value": "#9E9E9E" },
      "600": { "value": "#757575" },
      "700": { "value": "#616161" },
      "800": { "value": "#424242" },
      "900": { "value": "#212121" },
      "1000": { "value": "#000000" }
    },
    "success": {
      "light": { "value": "#81C784" },
      "default": { "value": "#4CAF50" },
      "dark": { "value": "#388E3C" }
    },
    "warning": {
      "light": { "value": "#FFB74D" },
      "default": { "value": "#FF9800" },
      "dark": { "value": "#F57C00" }
    },
    "error": {
      "light": { "value": "#E57373" },
      "default": { "value": "#F44336" },
      "dark": { "value": "#D32F2F" }
    }
  }
}
```

**Exercise:** Add an `info` color with light, default, and dark variants (use blue tones).

### Lab 2.3: Create Spacing Tokens

Create `src/spacing.json`:

```json
{
  "spacing": {
    "0": { "value": "0" },
    "px": { "value": "1px" },
    "0.5": { "value": "2px" },
    "1": { "value": "4px" },
    "2": { "value": "8px" },
    "3": { "value": "12px" },
    "4": { "value": "16px" },
    "5": { "value": "20px" },
    "6": { "value": "24px" },
    "8": { "value": "32px" },
    "10": { "value": "40px" },
    "12": { "value": "48px" },
    "16": { "value": "64px" },
    "20": { "value": "80px" },
    "24": { "value": "96px" }
  }
}
```

**Note:** These follow Tailwind's spacing scale. You can also use semantic names:

```json
{
  "spacing": {
    "xs": { "value": "4px" },
    "sm": { "value": "8px" },
    "md": { "value": "16px" },
    "lg": { "value": "24px" },
    "xl": { "value": "32px" },
    "2xl": { "value": "48px" }
  }
}
```

### Lab 2.4: Create Typography Tokens

Create `src/typography.json`:

```json
{
  "font": {
    "family": {
      "sans": { "value": "Inter, -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif" },
      "mono": { "value": "'JetBrains Mono', 'Fira Code', Consolas, monospace" }
    },
    "size": {
      "xs": { "value": "0.75rem", "comment": "12px" },
      "sm": { "value": "0.875rem", "comment": "14px" },
      "base": { "value": "1rem", "comment": "16px" },
      "lg": { "value": "1.125rem", "comment": "18px" },
      "xl": { "value": "1.25rem", "comment": "20px" },
      "2xl": { "value": "1.5rem", "comment": "24px" },
      "3xl": { "value": "1.875rem", "comment": "30px" },
      "4xl": { "value": "2.25rem", "comment": "36px" }
    },
    "weight": {
      "normal": { "value": "400" },
      "medium": { "value": "500" },
      "semibold": { "value": "600" },
      "bold": { "value": "700" }
    },
    "lineHeight": {
      "tight": { "value": "1.25" },
      "normal": { "value": "1.5" },
      "relaxed": { "value": "1.75" }
    }
  }
}
```

### Lab 2.5: Create Shadow Tokens

Create `src/shadows.json`:

```json
{
  "shadow": {
    "none": { "value": "none" },
    "sm": { "value": "0 1px 2px 0 rgba(0, 0, 0, 0.05)" },
    "default": { "value": "0 1px 3px 0 rgba(0, 0, 0, 0.1), 0 1px 2px -1px rgba(0, 0, 0, 0.1)" },
    "md": { "value": "0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -2px rgba(0, 0, 0, 0.1)" },
    "lg": { "value": "0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -4px rgba(0, 0, 0, 0.1)" },
    "xl": { "value": "0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 8px 10px -6px rgba(0, 0, 0, 0.1)" }
  }
}
```

### Lab 2.6: Create Border Tokens

Create `src/borders.json`:

```json
{
  "border": {
    "radius": {
      "none": { "value": "0" },
      "sm": { "value": "2px" },
      "default": { "value": "4px" },
      "md": { "value": "6px" },
      "lg": { "value": "8px" },
      "xl": { "value": "12px" },
      "2xl": { "value": "16px" },
      "full": { "value": "9999px" }
    },
    "width": {
      "none": { "value": "0" },
      "thin": { "value": "1px" },
      "default": { "value": "1px" },
      "thick": { "value": "2px" }
    }
  }
}
```

### Lab 2.7: Configure Style Dictionary

Create `style-dictionary.config.js` in the tokens package root:

```javascript
module.exports = {
  source: ['src/**/*.json'],
  platforms: {
    // CSS Custom Properties
    css: {
      transformGroup: 'css',
      buildPath: 'build/css/',
      files: [
        {
          destination: 'variables.css',
          format: 'css/variables',
          options: {
            outputReferences: true
          }
        }
      ]
    },

    // JavaScript ES6
    js: {
      transformGroup: 'js',
      buildPath: 'build/js/',
      files: [
        {
          destination: 'tokens.js',
          format: 'javascript/es6'
        }
      ]
    },

    // TypeScript
    ts: {
      transformGroup: 'js',
      buildPath: 'build/ts/',
      files: [
        {
          destination: 'tokens.ts',
          format: 'javascript/es6'
        }
      ]
    },

    // JSON (useful for other tools)
    json: {
      transformGroup: 'js',
      buildPath: 'build/json/',
      files: [
        {
          destination: 'tokens.json',
          format: 'json/nested'
        }
      ]
    }
  }
};
```

### Lab 2.8: Build the Tokens

Add a build script to `package.json`:

```json
{
  "name": "@myapp/tokens",
  "version": "0.0.1",
  "scripts": {
    "build": "style-dictionary build",
    "clean": "rm -rf build"
  },
  "devDependencies": {
    "style-dictionary": "^3.9.0"
  }
}
```

Run the build:

```bash
npm run build
```

### Lab 2.9: Inspect the Output

Look at what was generated:

```bash
# View CSS output
cat build/css/variables.css

# View JS output
cat build/js/tokens.js

# View JSON output
cat build/json/tokens.json
```

**Questions:**
1. How did Style Dictionary transform `color.primary.500` into a CSS variable name?
2. What's the JavaScript equivalent?
3. How would you use these in a component?

### Lab 2.10: Test in HTML

Create a test file `test.html`:

```html
<!DOCTYPE html>
<html>
<head>
  <link rel="stylesheet" href="build/css/variables.css">
  <style>
    body {
      font-family: var(--font-family-sans);
      padding: var(--spacing-6);
      background: var(--color-neutral-50);
    }

    .card {
      background: var(--color-neutral-0);
      padding: var(--spacing-4);
      border-radius: var(--border-radius-lg);
      box-shadow: var(--shadow-md);
    }

    .button {
      background: var(--color-primary-500);
      color: white;
      padding: var(--spacing-2) var(--spacing-4);
      border: none;
      border-radius: var(--border-radius-default);
      font-size: var(--font-size-sm);
      font-weight: var(--font-weight-medium);
      cursor: pointer;
    }

    .button:hover {
      background: var(--color-primary-600);
    }
  </style>
</head>
<body>
  <div class="card">
    <h1 style="color: var(--color-neutral-900); margin-bottom: var(--spacing-4);">
      Token Test
    </h1>
    <p style="color: var(--color-neutral-600); margin-bottom: var(--spacing-4);">
      This page uses design tokens for all styling.
    </p>
    <button class="button">Primary Button</button>
  </div>
</body>
</html>
```

Open in browser and verify the tokens are working.

---

## Part 3: Compare with Real Projects (20 minutes)

### Lab 2.11: Cal.com's Approach

Cal.com uses Tailwind CSS config as their token system:

```bash
cd ../../../cal.com  # If you cloned it in Chapter 1
cat packages/config/tailwind-preset.js
```

**Questions:**
1. How do they define colors?
2. How is this different from Style Dictionary?
3. What are the trade-offs?

### Lab 2.12: Supabase's Approach

Look at Supabase's token approach:

```bash
cd ../supabase
ls packages/ui/src/lib/
```

**Note:** Different projects handle tokens differently:
- Style Dictionary (JSON → multi-platform)
- Tailwind config (JS → CSS utilities)
- CSS-in-JS themes (JS objects)
- CSS custom properties directly

---

## Part 4: Reflection (20 minutes)

### Written Reflection

1. **What problem do design tokens solve?**
   ```


   ```

2. **What's the benefit of using Style Dictionary vs just writing CSS variables manually?**
   ```


   ```

3. **How would you add a new color to the token system?**
   ```


   ```

4. **How would tokens help if you needed to support both light and dark mode?**
   ```


   ```

---

## Part 5: Extension Exercises

### Exercise 2.1: Add Semantic Tokens

Semantic tokens reference other tokens to give them meaning:

Create `src/semantic.json`:

```json
{
  "semantic": {
    "background": {
      "default": { "value": "{color.neutral.0}" },
      "subtle": { "value": "{color.neutral.50}" },
      "muted": { "value": "{color.neutral.100}" }
    },
    "text": {
      "default": { "value": "{color.neutral.900}" },
      "muted": { "value": "{color.neutral.600}" },
      "subtle": { "value": "{color.neutral.400}" }
    },
    "border": {
      "default": { "value": "{color.neutral.200}" },
      "strong": { "value": "{color.neutral.300}" }
    }
  }
}
```

Rebuild and check how these reference other tokens.

### Exercise 2.2: Add iOS Platform

Add to `style-dictionary.config.js`:

```javascript
ios: {
  transformGroup: 'ios',
  buildPath: 'build/ios/',
  files: [
    {
      destination: 'StyleDictionaryColor.swift',
      format: 'ios-swift/enum.swift',
      className: 'StyleDictionaryColor',
      filter: {
        type: 'color'
      }
    }
  ]
}
```

Rebuild and examine `build/ios/StyleDictionaryColor.swift`.

---

## Part 6: Self-Check

Before moving to Chapter 3, verify:

- [ ] You can explain what design tokens are
- [ ] You created color, spacing, typography, shadow, and border tokens
- [ ] Style Dictionary builds without errors
- [ ] You understand the generated CSS variables
- [ ] You tested tokens in an HTML file
- [ ] You compared your approach with Cal.com or Supabase

---

## Summary

You built the foundation layer of your design system. Tokens provide:
- Single source of truth for design values
- Multi-platform output from one source
- Easy theming (swap values for dark mode)
- Consistency across the entire application

In Chapter 3, you'll use these tokens to build primitive components.

---

## Files You Should Have

```
packages/tokens/
├── src/
│   ├── colors.json
│   ├── spacing.json
│   ├── typography.json
│   ├── shadows.json
│   ├── borders.json
│   └── semantic.json (optional)
├── build/
│   ├── css/
│   │   └── variables.css
│   ├── js/
│   │   └── tokens.js
│   └── json/
│       └── tokens.json
├── style-dictionary.config.js
├── package.json
└── test.html
```
