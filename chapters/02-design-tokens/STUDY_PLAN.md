# Chapter 2 Study Plan: Design Tokens

## Overview

**Total Time:** ~2.5 hours

| Part | Content | Time |
|------|---------|------|
| Part 1 | Theory | 20 min |
| Part 2 | Labs 2.1-2.5 | 1.5 hours |
| Part 3 | Reflection | 20 min |
| Part 4 | Extension Exercises | Optional |

---

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

## Part 2: Labs (1.5 hours)

### Lab 2.1: Project Setup (~20 min)

> **Location:** `labs/lab2.1/`

Set up the tokens package with Style Dictionary.

#### What You'll Do

1. Create the project structure:
   ```bash
   mkdir -p design-system-course/packages/tokens/src
   cd design-system-course/packages/tokens
   ```

2. Initialize npm and install Style Dictionary:
   ```bash
   npm init -y
   npm install style-dictionary
   ```

3. Verify the structure:
   ```
   design-system-course/
   └── packages/
       └── tokens/
           ├── src/           # Token source files go here
           ├── package.json
           └── (config file will go here)
   ```

#### Key Concepts

- What design tokens are (atomic design values)
- Why we use a build tool (multi-platform output)
- Style Dictionary's role in the token pipeline

---

### Lab 2.2: Color Tokens (~25 min)

> **Location:** `labs/lab2.2/`

Create a comprehensive color token system.

#### What You'll Do

1. Create `src/colors.json` with primary color scale (50-900)
2. Add neutral colors (0-1000)
3. Add semantic colors (success, warning, error)
4. **Exercise:** Add an `info` color with light, default, and dark variants

#### Token Structure

```json
{
  "color": {
    "primary": {
      "50": { "value": "#E3F2FD", "comment": "Lightest primary" },
      "500": { "value": "#2196F3", "comment": "Default primary" },
      "900": { "value": "#0D47A1", "comment": "Darkest primary" }
    },
    "neutral": {
      "0": { "value": "#FFFFFF" },
      "900": { "value": "#212121" }
    },
    "success": {
      "light": { "value": "#81C784" },
      "default": { "value": "#4CAF50" },
      "dark": { "value": "#388E3C" }
    }
  }
}
```

#### Key Concepts

- Color scale convention (50-900)
- Semantic vs primitive colors
- When to use which shade

---

### Lab 2.3: Spacing, Typography, Shadows & Borders (~30 min)

> **Location:** `labs/lab2.3/`

Create the remaining token categories.

#### What You'll Do

1. **Spacing tokens** (`src/spacing.json`)
   - Create 0-24 scale following Tailwind convention
   - Understand the 4px base unit pattern

2. **Typography tokens** (`src/typography.json`)
   - Font families with fallback stacks
   - Font sizes in rem (xs-4xl)
   - Font weights (normal, medium, semibold, bold)
   - Line heights (tight, normal, relaxed)

3. **Shadow tokens** (`src/shadows.json`)
   - Shadow scale (none, sm, default, md, lg, xl)
   - Multiple shadows for realistic depth

4. **Border tokens** (`src/borders.json`)
   - Border radius (none-full)
   - Border width (none, thin, default, thick)

#### Token Structures

**Spacing:**
```json
{
  "spacing": {
    "0": { "value": "0" },
    "1": { "value": "4px" },
    "2": { "value": "8px" },
    "4": { "value": "16px" }
  }
}
```

**Typography:**
```json
{
  "font": {
    "family": {
      "sans": { "value": "Inter, -apple-system, sans-serif" }
    },
    "size": {
      "base": { "value": "1rem", "comment": "16px" }
    }
  }
}
```

**Shadows:**
```json
{
  "shadow": {
    "md": { "value": "0 4px 6px -1px rgba(0, 0, 0, 0.1)" }
  }
}
```

**Borders:**
```json
{
  "border": {
    "radius": {
      "lg": { "value": "8px" },
      "full": { "value": "9999px" }
    }
  }
}
```

#### Key Concepts

- Numeric vs semantic naming conventions
- Why use rem for font sizes
- Unitless line-height values
- Shadow layering for depth

---

### Lab 2.4: Build and Test Tokens (~30 min)

> **Location:** `labs/lab2.4/`

Configure Style Dictionary and verify the output.

#### What You'll Do

1. **Configure Style Dictionary** - Create `style-dictionary.config.js`:
   ```javascript
   module.exports = {
     source: ['src/**/*.json'],
     platforms: {
       css: {
         transformGroup: 'css',
         buildPath: 'build/css/',
         files: [{
           destination: 'variables.css',
           format: 'css/variables'
         }]
       },
       js: {
         transformGroup: 'js',
         buildPath: 'build/js/',
         files: [{
           destination: 'tokens.js',
           format: 'javascript/es6'
         }]
       }
     }
   };
   ```

2. **Build the tokens:**
   ```bash
   npm run build
   ```

3. **Inspect the output:**
   ```bash
   cat build/css/variables.css
   cat build/js/tokens.js
   ```

4. **Test in HTML** - Create `test.html` that uses the CSS variables

5. **Modify and rebuild** - Change a token value and verify the update

#### Key Concepts

- Style Dictionary configuration
- Transform groups (css vs js naming conventions)
- Output references for debugging
- The build → test → iterate cycle

---

### Lab 2.5: Compare with Real Projects (~20 min)

> **Location:** `labs/lab2.5/`

Examine how production design systems handle tokens.

#### What You'll Do

1. **Explore Cal.com's Tailwind approach:**
   ```bash
   cat cal.com/packages/config/tailwind-preset.js
   ```

2. **Compare token structures:**

   | Aspect | Your Tokens | Cal.com |
   |--------|-------------|---------|
   | Source format | JSON | JavaScript |
   | Output formats | CSS, JS, TS | CSS utilities |
   | Multi-platform | Yes | No |

3. **Create semantic tokens** (optional extension):
   ```json
   {
     "semantic": {
       "background": {
         "default": { "value": "{color.neutral.0}" }
       }
     }
   }
   ```

4. **Complete reflection questions**

#### Key Concepts

- Trade-offs between different token approaches
- When to use Style Dictionary vs Tailwind config
- Semantic tokens that reference primitive tokens

---

## Part 3: Reflection (20 minutes)

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

## Part 4: Extension Exercises (Optional)

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

## Self-Check

Before moving to Chapter 3, verify:

- [ ] You can explain what design tokens are
- [ ] You created color, spacing, typography, shadow, and border tokens
- [ ] Style Dictionary builds without errors
- [ ] You understand the generated CSS variables
- [ ] You tested tokens in an HTML file
- [ ] You compared your approach with Cal.com

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
│   ├── ts/
│   │   └── tokens.ts
│   └── json/
│       └── tokens.json
├── style-dictionary.config.js
├── package.json
└── test.html
```
