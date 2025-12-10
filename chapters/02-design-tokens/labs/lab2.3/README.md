# Lab 2.3: Spacing, Typography, Shadows & Borders

## Objective

Create a complete set of design tokens for spacing, typography, shadows, and borders. These tokens complement your color tokens to form the foundation of your design system.

## Time Estimate

~30 minutes

## Prerequisites

- Completed Lab 2.1 (tokens package setup)
- Completed Lab 2.2 (color tokens)

## Setup

### Quick Setup

```bash
./setup.sh
```

This will:
1. Ensure Labs 2.1 and 2.2 are complete
2. Create starter token files for spacing, typography, shadows, and borders

### Manual Setup

Navigate to your tokens package:
```bash
cd ../lab2.1/packages/tokens
```

## Exercises

### Exercise 1: Create Spacing Tokens

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

**Understanding the scale:**
- This follows Tailwind's spacing scale (4px base unit)
- `spacing-1` = 4px, `spacing-2` = 8px, `spacing-4` = 16px
- The pattern: `value = key × 4px`

**Alternative: Semantic naming:**
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

**Questions:**
1. When would you use numeric naming vs semantic naming?
2. What's the advantage of a consistent multiplier (4px)?

### Exercise 2: Create Typography Tokens

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

**Understanding typography tokens:**
- **font-family**: System font stacks with fallbacks
- **font-size**: Using `rem` for accessibility (respects user's browser settings)
- **font-weight**: Named weights map to numeric values
- **line-height**: Unitless values (multipliers of font-size)

**Questions:**
1. Why use `rem` instead of `px` for font sizes?
2. What's the benefit of unitless line-height?

### Exercise 3: Create Shadow Tokens

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

**Understanding shadow tokens:**
- Shadows create depth and hierarchy
- Multiple shadows (comma-separated) create more realistic effects
- Negative spread values prevent shadows from extending too far

**Common uses:**
- `shadow-sm`: Subtle depth for cards, inputs
- `shadow-default`: Standard card elevation
- `shadow-md`: Dropdowns, popovers
- `shadow-lg`: Modals, overlays
- `shadow-xl`: Large floating elements

### Exercise 4: Create Border Tokens

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

**Understanding border tokens:**
- **border-radius**: Controls roundedness
- **border-radius-full**: Creates circles (when applied to squares)
- **border-width**: Consistent border sizes

### Exercise 5: Verify All Files

Check that all files exist and are valid JSON:

```bash
cd ../lab2.1/packages/tokens/src
ls -la
```

You should have:
- `colors.json`
- `spacing.json`
- `typography.json`
- `shadows.json`
- `borders.json`

Validate all JSON files:
```bash
for f in *.json; do
  echo -n "Checking $f... "
  python3 -m json.tool "$f" > /dev/null && echo "OK" || echo "INVALID"
done
```

## Key Concepts

### Why These Categories?

Every UI can be built with these fundamental properties:
- **Color**: Visual identity, hierarchy, state indication
- **Spacing**: Layout rhythm, breathing room
- **Typography**: Readability, hierarchy, personality
- **Shadows**: Depth, elevation, focus
- **Borders**: Definition, separation, grouping

### Token Naming Conventions

**Numeric scale (0, 1, 2, 4, 8...):**
- Precise, mathematical
- Easy to interpolate
- Good for spacing, font sizes

**T-shirt sizes (xs, sm, md, lg, xl):**
- Intuitive, memorable
- Limited granularity
- Good for semantic groupings

**Semantic names (default, muted, subtle):**
- Meaningful, self-documenting
- Flexible for theming
- Good for colors, states

## Complete File Structure

After this lab, your `packages/tokens/src/` should contain:

```
src/
├── colors.json      # Primary, neutral, semantic colors
├── spacing.json     # 0-24 spacing scale
├── typography.json  # Fonts, sizes, weights, line-heights
├── shadows.json     # none-xl shadow scale
└── borders.json     # Radius and width tokens
```

## Checklist

Before proceeding to Lab 2.4:

- [ ] Created `spacing.json` with 0-24 scale
- [ ] Created `typography.json` with family, size, weight, lineHeight
- [ ] Created `shadows.json` with none-xl scale
- [ ] Created `borders.json` with radius and width
- [ ] All JSON files are valid
- [ ] You understand when to use each token category

## Reflection Questions

1. How would you decide between numeric spacing (`spacing-4`) vs semantic spacing (`spacing-md`)?
2. Why include fallback fonts in the font-family stack?
3. How might these tokens need to change for a "compact" mode?

## Next

Proceed to Lab 2.4 to configure Style Dictionary and build your tokens.
