# Lecture Notes: Design Tokens (Part 1 - Theory)

**Duration:** 30-45 minutes
**Chapter:** 02 - Design Tokens

---

## Lecture Outline

1. Opening Question
2. The Problem Tokens Solve (The Pain Before the Cure)
3. Anatomy of a Design Token
4. Token Categories and Hierarchies
5. Style Dictionary: The Build Pipeline
6. Multi-Platform Output
7. Key Takeaways

---

## 1. Opening Question (3 minutes)

> **Ask the class:** "How many times have you changed a color in one place, only to realize it's hardcoded in 47 other files?"

**Expected answers:** "All the time," nervous laughter, stories of find-and-replace nightmares...

**Instructor note:** This question surfaces the lived experience of inconsistency. Every developer has been burned by this. Use their frustration as the motivation for tokens.

**Follow-up:** "And how many of you have tried to implement dark mode, only to give up halfway through?"

---

## 2. The Problem Tokens Solve (8 minutes)

### The Hardcoded Nightmare

Show this code (or have students identify the problems):

```tsx
// Button.tsx
<button style={{ backgroundColor: '#2196F3', padding: '16px' }}>

// Link.tsx
<a style={{ color: '#2196f3' }}>  // Note: lowercase f3

// Header.tsx
<header style={{ borderBottom: '1px solid #2196F3' }}>

// Modal.tsx
<div style={{ background: '#2196F3' }}>  // Missing the 'Color' typo
```

> **Ask:** "What's wrong with this code?"

### Problems with Hardcoded Values

| Problem | Consequence |
|---------|-------------|
| **Inconsistency** | Same color written 3 different ways (`#2196F3` vs `#2196f3`) |
| **No single source of truth** | Change request means hunting through entire codebase |
| **Magic numbers** | What does `16px` mean? Why not `14px` or `18px`? |
| **Dark mode impossible** | No systematic way to swap values |
| **Designer-developer friction** | "Make the blue slightly different" = hours of work |

### The Token Solution

```css
/* Define once */
:root {
  --color-primary-500: #2196F3;
  --spacing-md: 16px;
}

/* Use everywhere */
.button {
  background-color: var(--color-primary-500);
  padding: var(--spacing-md);
}
```

**Result:** One value to rule them all. Change it once, and *everything* updates.

---

## 3. Anatomy of a Design Token (7 minutes)

### What IS a Design Token?

> **Definition:** A design token is a **named design decision**. It captures the *what* (the value) and the *why* (the semantic meaning) in a platform-agnostic format.

### The Three Parts of a Token

```json
{
  "color": {
    "primary": {
      "500": {
        "value": "#2196F3",
        "comment": "Default primary - used for CTAs and emphasis"
      }
    }
  }
}
```

| Part | Example | Purpose |
|------|---------|---------|
| **Name** | `color.primary.500` | Semantic identifier (the "why") |
| **Value** | `#2196F3` | The actual design value |
| **Metadata** | `comment`, `type`, etc. | Documentation and transformation hints |

### Raw Values vs. Tokens

**Raw value:** `#2196F3`
- What color is this?
- Why this specific hex?
- Is this the "right" blue?

**Token:** `--color-primary-500`
- This is our primary brand color
- It's in the middle of our primary scale (500)
- It's intentional and documented

> **Key insight:** Tokens add *meaning* to values. They transform "magic numbers" into deliberate design decisions.

---

## 4. Token Categories and Hierarchies (10 minutes)

### The Five Token Categories

```
┌─────────────────────────────────────────────────────┐
│                   DESIGN TOKENS                      │
├─────────────┬───────────┬────────────┬──────────────┤
│   Colors    │  Spacing  │ Typography │   Effects    │
│             │           │            │              │
│  primary    │   xs: 4   │  size: sm  │  shadow: sm  │
│  neutral    │   sm: 8   │  size: base│  shadow: md  │
│  success    │   md: 16  │  weight    │  shadow: lg  │
│  warning    │   lg: 24  │  family    │              │
│  error      │   xl: 32  │  leading   │  border-     │
│             │           │            │  radius      │
└─────────────┴───────────┴────────────┴──────────────┘
```

### Category Deep Dive

#### Colors

```json
{
  "color": {
    "primary": {
      "50": { "value": "#E3F2FD" },   // Lightest
      "500": { "value": "#2196F3" },  // Default
      "900": { "value": "#0D47A1" }   // Darkest
    },
    "neutral": { /* grayscale */ },
    "success": { /* green family */ },
    "warning": { /* orange family */ },
    "error": { /* red family */ }
  }
}
```

**Why scales (50-900)?** They provide options for states:
- `primary-500`: Normal button
- `primary-600`: Hover state
- `primary-700`: Active/pressed state

#### Spacing

```json
{
  "spacing": {
    "0": { "value": "0" },
    "1": { "value": "4px" },
    "2": { "value": "8px" },
    "4": { "value": "16px" },
    "6": { "value": "24px" },
    "8": { "value": "32px" }
  }
}
```

**Why a scale?** Consistent spacing creates rhythm. Notice: `4 → 8 → 16 → 24 → 32` follows a predictable pattern.

> **Ask:** "What happens if everyone picks their own padding values?"
> **Answer:** Visual chaos. No rhythm. Everything looks slightly "off."

#### Typography

```json
{
  "font": {
    "family": {
      "sans": { "value": "Inter, system-ui, sans-serif" },
      "mono": { "value": "'JetBrains Mono', monospace" }
    },
    "size": {
      "sm": { "value": "0.875rem" },
      "base": { "value": "1rem" },
      "lg": { "value": "1.125rem" }
    },
    "weight": {
      "normal": { "value": "400" },
      "medium": { "value": "500" },
      "bold": { "value": "700" }
    }
  }
}
```

### Primitive vs. Semantic Tokens

This is a critical distinction:

#### Primitive (Global) Tokens

```json
{
  "color": {
    "blue": {
      "500": { "value": "#2196F3" }
    }
  }
}
```

These are **raw values** with simple names. Color-blue-500 is just "a blue."

#### Semantic (Alias) Tokens

```json
{
  "color": {
    "primary": { "value": "{color.blue.500}" },
    "background": {
      "default": { "value": "{color.neutral.0}" },
      "subtle": { "value": "{color.neutral.50}" }
    },
    "text": {
      "default": { "value": "{color.neutral.900}" },
      "muted": { "value": "{color.neutral.600}" }
    }
  }
}
```

These **reference other tokens** and add *meaning*.

> **Key insight:** Semantic tokens enable theming. In dark mode, `background.default` changes from white to dark gray—but the token name stays the same.

### Visual: Token Hierarchy

```
┌─────────────────────────────────────────────┐
│  SEMANTIC TOKENS (How it's used)            │
│  background.default  →  {color.neutral.0}   │
│  text.primary        →  {color.neutral.900} │
│  interactive.primary →  {color.primary.500} │
├─────────────────────────────────────────────┤
│  PRIMITIVE TOKENS (What the value is)       │
│  color.neutral.0   = #FFFFFF                │
│  color.neutral.900 = #212121                │
│  color.primary.500 = #2196F3                │
└─────────────────────────────────────────────┘
```

---

## 5. Style Dictionary: The Build Pipeline (8 minutes)

### The Problem with Manual Tokens

You *could* just write CSS variables by hand:

```css
:root {
  --color-primary-500: #2196F3;
  --spacing-md: 16px;
  /* ... 200 more lines ... */
}
```

But what about:
- JavaScript constants for your React components?
- Swift enums for your iOS app?
- XML resources for Android?
- TypeScript type definitions?

### Enter Style Dictionary

Style Dictionary transforms tokens from a single source into multiple platform outputs:

```
tokens/colors.json  ─┐
tokens/spacing.json ─┼─► Style Dictionary ─┬─► build/css/variables.css
tokens/fonts.json   ─┘                     ├─► build/js/tokens.js
                                           ├─► build/ios/Colors.swift
                                           └─► build/android/colors.xml
```

### How It Works

**1. Define tokens in JSON:**

```json
// tokens/colors.json
{
  "color": {
    "primary": {
      "500": { "value": "#2196F3" }
    }
  }
}
```

**2. Configure the build:**

```javascript
// style-dictionary.config.js
module.exports = {
  source: ['tokens/**/*.json'],
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

**3. Run the build:**

```bash
npx style-dictionary build
```

**4. Get platform-specific output:**

```css
/* build/css/variables.css */
:root {
  --color-primary-500: #2196F3;
}
```

```javascript
// build/js/tokens.js
export const ColorPrimary500 = "#2196F3";
```

### Why This Matters

| Without Style Dictionary | With Style Dictionary |
|--------------------------|----------------------|
| Update CSS, then JS, then iOS, then Android | Update JSON once |
| Values drift apart over time | Single source of truth |
| No validation | Built-in validation |
| Manual naming conventions | Automated, consistent naming |

---

## 6. Multi-Platform Output (5 minutes)

### The Cross-Platform Challenge

Your design system isn't just for web. What about:
- React Native apps
- iOS native apps
- Android native apps
- Figma plugins
- Design documentation

### One Source, Many Outputs

Show the outputs from a single token:

**Source:**
```json
{
  "color": {
    "primary": {
      "500": { "value": "#2196F3" }
    }
  }
}
```

**CSS:**
```css
--color-primary-500: #2196F3;
```

**JavaScript:**
```javascript
export const ColorPrimary500 = "#2196F3";
```

**iOS Swift:**
```swift
public enum StyleDictionaryColor {
    public static let primary500 = UIColor(red: 0.129, green: 0.588, blue: 0.953, alpha: 1)
}
```

**Android XML:**
```xml
<color name="color_primary_500">#FF2196F3</color>
```

> **Key insight:** The designer changes one JSON value. Every platform gets updated. No manual synchronization. No drift.

---

## 7. Key Takeaways (4 minutes)

### Summary Visual

```
From This:                          To This:

#2196F3  #2196f3  #2196F3          color.primary.500 (defined once)
   ↓        ↓         ↓                    │
Button   Link     Header                   ├─► Button
                                           ├─► Link
(inconsistent, fragile,                    └─► Header
 impossible to theme)
                                    (consistent, maintainable,
                                     themeable)
```

### Three Things to Remember

1. **Design tokens are named design decisions** — they add meaning and consistency to raw values.

2. **Primitive tokens store values; semantic tokens store meaning** — and semantic tokens enable theming by referencing primitives.

3. **Style Dictionary transforms tokens into platform-specific code** — write once, deploy everywhere (CSS, JS, iOS, Android).

### The Foundation Metaphor

```
Your Design System:

     Components use tokens
            │
            ▼
    ┌───────────────┐
    │   Tokens      │  ← Chapter 2 (You are here)
    │   (Layer 1)   │
    └───────────────┘
            │
    Everything builds on this foundation
```

If your tokens are wrong, *everything* built on top is wrong. That's why we start here.

---

## Looking Ahead

In the **lab section**, you'll:
- Build a complete token system using Style Dictionary
- Create colors, spacing, typography, shadows, and border tokens
- Generate CSS and JavaScript outputs
- Test tokens in a real HTML file
- Compare your approach with Cal.com and Supabase

In **Chapter 3**, we'll use these tokens to build primitive components—buttons, inputs, cards—that consume the tokens you've just created.

---

## Discussion Questions for Class

1. Have you ever worked on a project where someone said "just make the blue darker" and it took hours to implement? What would have been different with tokens?

2. How would tokens help with accessibility? (Hint: contrast ratios, focus states)

3. If you had to support both light and dark mode, which approach is easier: hardcoded values or semantic tokens? Walk through the implementation.

4. What happens if different team members use different spacing values (12px vs 14px vs 16px)? How do tokens prevent this?

---

## Common Misconceptions

### "Tokens are just CSS variables"

**Correction:** CSS variables are *one output* of tokens. Tokens are the *source* that generates CSS variables, JS constants, Swift enums, Android XML, and more.

### "We don't need tokens for a small project"

**Correction:** Tokens add minimal overhead but provide immediate benefits. Even a small project benefits from consistency and the ability to change values globally.

### "Tokens are only for colors"

**Correction:** Spacing, typography, shadows, borders, animation timing, z-index layers—all of these benefit from tokenization.

---

## Additional Resources

- **Tool:** [Style Dictionary Documentation](https://amzn.github.io/style-dictionary/)
- **Article:** "Tokens in Design Systems" by Nathan Curtis
- **Specification:** [W3C Design Tokens Community Group](https://design-tokens.github.io/community-group/format/)
- **Tool:** [Figma Tokens Plugin](https://www.figma.com/community/plugin/843461159747178978/figma-tokens)

---

## Preparation for Lab

Before the lab, ensure you have:
- [ ] Node.js v18+ installed
- [ ] A code editor ready
- [ ] Familiarity with JSON syntax
- [ ] Completed Chapter 1 (understanding of the 5-layer model)
