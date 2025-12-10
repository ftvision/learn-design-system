# Lab 2.5: Compare with Real Projects

## Objective

Examine how production design systems handle tokens. Compare your Style Dictionary approach with Tailwind-based systems and CSS-in-JS themes.

## Time Estimate

~20 minutes

## Prerequisites

- Completed Labs 2.1-2.4
- Chapter 1 completed (Cal.com reference available)

## Setup

### Quick Setup

```bash
./setup.sh
```

This will create symlinks to the reference projects from Chapter 1.

## Exercises

### Exercise 1: Cal.com's Tailwind Approach

Cal.com uses Tailwind CSS as their token system.

```bash
# Navigate to Cal.com's config
ls cal.com/packages/config/
cat cal.com/packages/config/tailwind-preset.js
```

**What to look for:**
1. How are colors defined?
2. How are they extended from Tailwind's defaults?
3. What custom values are added?

**Key patterns in Cal.com:**
```javascript
// tailwind-preset.js (simplified)
module.exports = {
  theme: {
    extend: {
      colors: {
        brand: {
          default: "#292929",
          emphasis: "#101010",
          subtle: "#9CA3AF",
          muted: "#E5E7EB",
        }
      },
      spacing: {
        // Custom spacing additions
      }
    }
  }
}
```

**Questions:**
1. How is this different from Style Dictionary?
2. What are the trade-offs?
3. When would you choose Tailwind config vs Style Dictionary?

### Exercise 2: Compare Token Structures

Compare your token structure with Cal.com's:

| Aspect | Your Tokens (Style Dictionary) | Cal.com (Tailwind) |
|--------|-------------------------------|-------------------|
| Source format | JSON | JavaScript |
| Output formats | CSS, JS, TS, JSON | CSS utilities |
| Color naming | `color.primary.500` | `brand-default` |
| Multi-platform | Yes | No (CSS only) |
| Type safety | Generated types | Tailwind IntelliSense |

### Exercise 3: Explore Semantic Token Patterns

Look at how Cal.com handles semantic naming:

```bash
# Search for color references
grep -r "brand" cal.com/packages/ui/components/button/ | head -20
```

**Observe:**
- Do they use semantic names (`brand-default`) or primitive names (`blue-500`)?
- How do they handle dark mode?

### Exercise 4: Create Semantic Tokens (Extension)

Add semantic tokens that reference your primitive tokens.

Create `src/semantic.json` in your tokens package:

```json
{
  "semantic": {
    "background": {
      "default": { "value": "{color.neutral.0}" },
      "subtle": { "value": "{color.neutral.50}" },
      "muted": { "value": "{color.neutral.100}" },
      "inverse": { "value": "{color.neutral.900}" }
    },
    "text": {
      "default": { "value": "{color.neutral.900}" },
      "muted": { "value": "{color.neutral.600}" },
      "subtle": { "value": "{color.neutral.400}" },
      "inverse": { "value": "{color.neutral.0}" }
    },
    "border": {
      "default": { "value": "{color.neutral.200}" },
      "strong": { "value": "{color.neutral.300}" },
      "focus": { "value": "{color.primary.500}" }
    },
    "action": {
      "primary": {
        "default": { "value": "{color.primary.500}" },
        "hover": { "value": "{color.primary.600}" },
        "active": { "value": "{color.primary.700}" }
      }
    }
  }
}
```

Rebuild and inspect the output:

```bash
cd ../lab2.1/packages/tokens
npm run build
cat build/css/variables.css | grep semantic
```

**Benefits of semantic tokens:**
- Components use meaningful names (`semantic-text-default` vs `color-neutral-900`)
- Easy to change the underlying value without updating components
- Supports theming (redefine `semantic-background-default` for dark mode)

### Exercise 5: Reflection - Different Approaches

**Style Dictionary (Your approach):**
- Pros:
  - Multi-platform output (CSS, JS, iOS, Android)
  - Clear separation of source and output
  - Supports complex transformations
- Cons:
  - Build step required
  - More setup overhead
  - Learning curve

**Tailwind Config (Cal.com's approach):**
- Pros:
  - Integrated with Tailwind's utility system
  - No extra build step
  - Great developer experience with IntelliSense
- Cons:
  - CSS only (no JS constants)
  - Tied to Tailwind ecosystem
  - Custom values mixed with framework config

**CSS-in-JS Themes:**
- Pros:
  - Full JavaScript power
  - Type safety with TypeScript
  - Component-level theming
- Cons:
  - Runtime overhead
  - Framework-specific (styled-components, Emotion)
  - No multi-platform output

### Exercise 6: Written Reflection

Answer these questions:

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

5. **When would you choose Tailwind's approach vs Style Dictionary?**
   ```


   ```

## Key Takeaways

### When to Use Style Dictionary

- Multi-platform projects (web, iOS, Android)
- Large teams with dedicated design systems
- Need for strict separation between design and implementation
- Complex token transformations or custom formats

### When to Use Tailwind Config

- Web-only projects
- Already using Tailwind CSS
- Smaller teams wanting quick setup
- Prefer configuration over separate build step

### When to Use CSS-in-JS Themes

- Heavy use of CSS-in-JS (styled-components, Emotion)
- Need for component-level theming
- TypeScript-first development
- Runtime theme switching requirements

## Checklist

Before completing Chapter 2:

- [ ] Examined Cal.com's Tailwind configuration
- [ ] Compared token structures between approaches
- [ ] Understand semantic vs primitive tokens
- [ ] (Optional) Created semantic tokens
- [ ] Completed reflection questions

## Self-Check: Chapter 2 Complete

Verify you can:

- [ ] Explain what design tokens are
- [ ] Create color, spacing, typography, shadow, and border tokens
- [ ] Configure and run Style Dictionary
- [ ] Understand the generated CSS variables and JS constants
- [ ] Test tokens in an HTML file
- [ ] Compare different token management approaches

## Next Steps

You now have a complete token system! In Chapter 3, you'll use these tokens to build primitive components (Button, Input, Card, etc.).

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
