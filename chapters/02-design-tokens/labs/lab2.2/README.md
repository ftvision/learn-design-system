# Lab 2.2: Color Tokens

## Objective

Create a comprehensive color token system including primary, neutral, and semantic colors (success, warning, error, info).

## Time Estimate

~25 minutes

## Prerequisites

- Completed Lab 2.1 (tokens package setup)
- Understanding of color scales (50-900 convention)

## Setup

### Quick Setup

```bash
./setup.sh
```

This will:
1. Ensure Lab 2.1 is complete
2. Create the color token files with starter content

### Manual Setup

Navigate to your tokens package from Lab 2.1:
```bash
cd ../lab2.1/packages/tokens
```

## Exercises

### Exercise 1: Create Primary Color Scale

Create `src/colors.json` with a primary color scale:

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
    }
  }
}
```

**Understanding the scale:**
- 50-100: Light tints (backgrounds, hover states)
- 200-400: Medium tints (borders, disabled states)
- 500: Default/base color
- 600-700: Darker shades (hover states on filled elements)
- 800-900: Darkest shades (text on light backgrounds)

### Exercise 2: Add Neutral Colors

Add neutral colors to `src/colors.json`:

```json
{
  "color": {
    "primary": { ... },
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
    }
  }
}
```

**Common uses for neutral colors:**
- 0: White backgrounds
- 50-100: Subtle backgrounds, alternating rows
- 200-300: Borders, dividers
- 400-500: Placeholder text, disabled text
- 600-700: Secondary text
- 800-900: Primary text
- 1000: Black (rarely used directly)

### Exercise 3: Add Semantic Colors

Add success, warning, and error colors:

```json
{
  "color": {
    "primary": { ... },
    "neutral": { ... },
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

### Exercise 4: Add Info Color (Your Turn!)

Add an `info` color to the semantic colors. Info colors are typically blue tones used for informational messages.

**Hint:** Use blue tones that are distinct from your primary color.

**Write your answer:**
```json
"info": {
  "light": { "value": "______" },
  "default": { "value": "______" },
  "dark": { "value": "______" }
}
```

**Suggested values:**
- Light: `#4FC3F7` (Light Blue 300)
- Default: `#03A9F4` (Light Blue 500)
- Dark: `#0288D1` (Light Blue 700)

### Exercise 5: Validate Your JSON

Check that your JSON is valid:

```bash
cd packages/tokens
cat src/colors.json | python3 -m json.tool > /dev/null && echo "Valid JSON!" || echo "Invalid JSON!"
```

Or use an online JSON validator.

## Key Concepts

### Color Scale Convention (50-900)

Most design systems use a 50-900 scale:
- **50-100**: Very light, for subtle backgrounds
- **200-400**: Light to medium, for borders and secondary elements
- **500**: The "base" or "default" shade
- **600-700**: Darker, for hover states on filled buttons
- **800-900**: Very dark, for text on light backgrounds

### Semantic vs Primitive Colors

**Primitive colors** are the raw values:
```json
"color": {
  "blue": { "500": { "value": "#2196F3" } }
}
```

**Semantic colors** have meaning:
```json
"color": {
  "primary": { "default": { "value": "#2196F3" } },
  "error": { "default": { "value": "#F44336" } }
}
```

Semantic colors are preferred because:
- They communicate intent (`error` vs `red`)
- They're easier to change (swap primary from blue to green)
- They support theming (dark mode can redefine `primary`)

## Complete colors.json

Your final `src/colors.json` should look like this:

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
    },
    "info": {
      "light": { "value": "#4FC3F7" },
      "default": { "value": "#03A9F4" },
      "dark": { "value": "#0288D1" }
    }
  }
}
```

## Checklist

Before proceeding to Lab 2.3:

- [ ] Created `src/colors.json`
- [ ] Added primary color scale (50-900)
- [ ] Added neutral color scale (0-1000)
- [ ] Added semantic colors (success, warning, error)
- [ ] Added info color
- [ ] JSON is valid (no syntax errors)

## Reflection Questions

1. Why do we use a numbered scale (50-900) instead of names (lightest, light, etc.)?
2. When would you use `neutral.600` vs `neutral.900` for text?
3. How would dark mode affect these color definitions?

## Next

Proceed to Lab 2.3 to create spacing and typography tokens.
