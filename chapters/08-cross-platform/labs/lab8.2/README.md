# Lab 8.2: Add Token Types & Build

## Objective

Add type attributes to token definitions for proper platform filtering, then build all platform outputs.

## Time Estimate

~25 minutes

## Prerequisites

- Completed Lab 8.1 (multi-platform config)
- Token JSON files exist in tokens package

## Setup

### Quick Setup

```bash
./setup.sh
```

This will:
1. Check that Lab 8.1 is complete
2. Create/update token files with type attributes
3. Build all platforms
4. Display build output

### Manual Setup

Navigate to your tokens package:
```bash
cd ../../../04-monorepo-architecture/labs/lab4.1/packages/tokens
```

## Exercises

### Exercise 1: Understand Token Types

Style Dictionary uses `type` attribute to filter tokens into the right output files:

```json
{
  "color": {
    "primary": {
      "value": "#3B82F6",
      "type": "color"
    }
  }
}
```

Common types:
- `color` - Color values (#hex, rgb, etc.)
- `dimension` - Sizes (px, rem, etc.)
- `fontFamily` - Font names
- `fontWeight` - Font weights
- `fontSize` - Font sizes (can also use `dimension`)

### Exercise 2: Examine Updated Token Files

Open `packages/tokens/src/colors.json`:

```json
{
  "color": {
    "primary": {
      "50": { "value": "#EFF6FF", "type": "color" },
      "100": { "value": "#DBEAFE", "type": "color" },
      "500": { "value": "#3B82F6", "type": "color" },
      "600": { "value": "#2563EB", "type": "color" },
      "700": { "value": "#1D4ED8", "type": "color" }
    },
    "gray": {
      "50": { "value": "#F9FAFB", "type": "color" },
      "100": { "value": "#F3F4F6", "type": "color" },
      "500": { "value": "#6B7280", "type": "color" },
      "900": { "value": "#111827", "type": "color" }
    },
    "success": { "value": "#22C55E", "type": "color" },
    "warning": { "value": "#F59E0B", "type": "color" },
    "error": { "value": "#EF4444", "type": "color" }
  }
}
```

### Exercise 3: Examine Spacing Tokens

Open `packages/tokens/src/spacing.json`:

```json
{
  "spacing": {
    "0": { "value": "0", "type": "dimension" },
    "1": { "value": "4px", "type": "dimension" },
    "2": { "value": "8px", "type": "dimension" },
    "3": { "value": "12px", "type": "dimension" },
    "4": { "value": "16px", "type": "dimension" },
    "5": { "value": "20px", "type": "dimension" },
    "6": { "value": "24px", "type": "dimension" },
    "8": { "value": "32px", "type": "dimension" },
    "10": { "value": "40px", "type": "dimension" },
    "12": { "value": "48px", "type": "dimension" }
  }
}
```

### Exercise 4: Examine Typography Tokens

Open `packages/tokens/src/typography.json`:

```json
{
  "font": {
    "family": {
      "sans": { "value": "Inter, system-ui, sans-serif", "type": "fontFamily" },
      "mono": { "value": "Fira Code, monospace", "type": "fontFamily" }
    },
    "size": {
      "xs": { "value": "12px", "type": "dimension" },
      "sm": { "value": "14px", "type": "dimension" },
      "base": { "value": "16px", "type": "dimension" },
      "lg": { "value": "18px", "type": "dimension" },
      "xl": { "value": "20px", "type": "dimension" },
      "2xl": { "value": "24px", "type": "dimension" },
      "3xl": { "value": "30px", "type": "dimension" }
    },
    "weight": {
      "normal": { "value": "400", "type": "fontWeight" },
      "medium": { "value": "500", "type": "fontWeight" },
      "semibold": { "value": "600", "type": "fontWeight" },
      "bold": { "value": "700", "type": "fontWeight" }
    }
  }
}
```

### Exercise 5: Build All Platforms

Run the build:

```bash
cd packages/tokens
pnpm install
pnpm build
```

You should see output like:
```
css
✔ build/css/variables.css

js
✔ build/js/tokens.js

ts
✔ build/ts/tokens.ts
✔ build/ts/tokens.d.ts

ios
✔ build/ios/Colors.swift
✔ build/ios/Spacing.swift
✔ build/ios/Typography.swift

android
✔ build/android/colors.xml
✔ build/android/dimens.xml
✔ build/android/font_sizes.xml
```

### Exercise 6: Verify Build Output

Check the build directory:

```bash
ls -la build/
ls -la build/css/
ls -la build/ios/
ls -la build/android/
```

## Key Concepts

### Type-Based Filtering

The config filters tokens by type:

```javascript
// Only color tokens go to Colors.swift
{
  destination: "Colors.swift",
  filter: { type: "color" }
}

// Only dimension tokens go to Spacing.swift
{
  destination: "Spacing.swift",
  filter: { type: "dimension" }
}
```

### Token Path vs Type

Both can be used for filtering:

```javascript
// Filter by type
filter: { type: "color" }

// Filter by path
filter: (token) => token.path[0] === "font"

// Combined
filter: (token) => token.type === "dimension" && token.path[0] === "spacing"
```

### Build Process

```
1. Read all JSON files (source)
2. Merge into single token tree
3. For each platform:
   a. Apply transforms (name format, value format)
   b. Filter tokens per file
   c. Format output (CSS, Swift, XML)
   d. Write to buildPath
```

## Checklist

Before proceeding to Lab 8.3:

- [ ] All token files have type attributes
- [ ] Build completes successfully
- [ ] CSS output exists in build/css/
- [ ] iOS output exists in build/ios/
- [ ] Android output exists in build/android/
- [ ] Understand how type attribute enables filtering

## Troubleshooting

### "No tokens found"

Check that:
- Token files are in `src/` directory
- Files have `.json` extension
- JSON syntax is valid

### Filter not working

Verify:
- Token has `type` property
- Filter matches the type exactly
- Type is a string, not number

### Build errors

Run with verbose output:
```bash
npx style-dictionary build --verbose
```

## Next

Proceed to Lab 8.3 to examine the iOS Swift output.
