# Lab 8.1: Configure Multi-Platform Build

## Objective

Configure Style Dictionary to generate design tokens for multiple platforms: CSS, JavaScript, TypeScript, iOS Swift, and Android XML.

## Time Estimate

~30 minutes

## Prerequisites

- Completed Chapter 2 (design tokens basics)
- Completed Chapter 4 (monorepo with tokens package)
- Style Dictionary installed in tokens package

## Setup

### Quick Setup

```bash
./setup.sh
```

This will:
1. Check that the tokens package exists
2. Create multi-platform Style Dictionary configuration
3. Show the platform configuration

### Manual Setup

Navigate to your tokens package:
```bash
cd ../../../04-monorepo-architecture/labs/lab4.1/packages/tokens
```

## Exercises

### Exercise 1: Understand the Cross-Platform Challenge

Different platforms have different ways of defining design values:

| Platform | Format | Example |
|----------|--------|---------|
| Web | CSS Variables | `--color-primary: #3B82F6;` |
| iOS | Swift | `static let primary = UIColor(red: 0.23, ...)` |
| Android | XML | `<color name="primary">#FF3B82F6</color>` |
| React Native | JS Object | `primary: '#3B82F6'` |

Without automation, you'd maintain separate files manually. Style Dictionary solves this by generating all formats from a single source.

### Exercise 2: Understand Transform Groups

Style Dictionary applies **transforms** to convert token values for each platform:

```
Token: { "value": "#3B82F6" }
                │
    ┌───────────┼───────────────┐
    ▼           ▼               ▼
  CSS         iOS Swift       Android
  #3B82F6     UIColor(        #FF3B82F6
              red: 0.23,      (with alpha)
              green: 0.51,
              blue: 0.96)
```

Built-in transform groups:

| Group | Transforms Applied |
|-------|-------------------|
| `css` | Name to kebab-case, colors to hex |
| `ios-swift-separate` | Name to camelCase, colors to UIColor |
| `android` | Name to snake_case, colors to 8-digit hex |
| `js` | Name to camelCase, keep values as strings |

### Exercise 3: Examine the Configuration

Open `packages/tokens/style-dictionary.config.js`:

```javascript
module.exports = {
  source: ["src/**/*.json"],
  platforms: {
    // CSS for web
    css: {
      transformGroup: "css",
      buildPath: "build/css/",
      files: [{
        destination: "variables.css",
        format: "css/variables",
      }],
    },

    // JavaScript ES6
    js: {
      transformGroup: "js",
      buildPath: "build/js/",
      files: [{
        destination: "tokens.js",
        format: "javascript/es6",
      }],
    },

    // TypeScript (for React Native)
    ts: {
      transformGroup: "js",
      buildPath: "build/ts/",
      files: [
        { destination: "tokens.ts", format: "javascript/es6" },
        { destination: "tokens.d.ts", format: "typescript/es6-declarations" },
      ],
    },

    // iOS Swift
    ios: {
      transformGroup: "ios-swift-separate",
      buildPath: "build/ios/",
      files: [{
        destination: "Colors.swift",
        format: "ios-swift/enum.swift",
        className: "Colors",
        filter: { type: "color" },
      }],
    },

    // Android
    android: {
      transformGroup: "android",
      buildPath: "build/android/",
      files: [{
        destination: "colors.xml",
        format: "android/colors",
        filter: { type: "color" },
      }],
    },
  },
};
```

### Exercise 4: Understand Platform Configuration

Each platform has:

| Property | Purpose |
|----------|---------|
| `transformGroup` | Predefined set of transforms |
| `buildPath` | Output directory |
| `files` | Array of output files |
| `files[].destination` | Output filename |
| `files[].format` | Output format |
| `files[].filter` | Which tokens to include |

### Exercise 5: Understand Filtering

The `filter` property selects which tokens go in each file:

```javascript
// Filter by type
filter: { type: "color" }

// Filter by path
filter: (token) => token.path[0] === "spacing"

// Filter by custom attribute
filter: (token) => token.attributes.category === "color"
```

This lets you split tokens into separate files (Colors.swift, Spacing.swift, etc.).

## Key Concepts

### Single Source of Truth

```
tokens/src/colors.json  ─────┐
tokens/src/spacing.json ─────┼──► Style Dictionary ──► build/css/
tokens/src/typography.json ──┘                    ──► build/ios/
                                                  ──► build/android/
                                                  ──► build/ts/
```

Change once, update everywhere.

### Build Path Organization

```
packages/tokens/build/
├── css/          # Web
│   └── variables.css
├── js/           # JavaScript
│   └── tokens.js
├── ts/           # TypeScript/React Native
│   ├── tokens.ts
│   └── tokens.d.ts
├── ios/          # iOS Swift
│   └── Colors.swift
└── android/      # Android
    └── colors.xml
```

### Platform-Specific Formats

| Platform | Format | Output |
|----------|--------|--------|
| CSS | `css/variables` | `:root { --color-primary: #3B82F6; }` |
| JS | `javascript/es6` | `export const colorPrimary = '#3B82F6';` |
| iOS | `ios-swift/enum.swift` | `public static let colorPrimary = UIColor(...)` |
| Android | `android/colors` | `<color name="color_primary">#FF3B82F6</color>` |

## Checklist

Before proceeding to Lab 8.2:

- [ ] Style Dictionary config created with multiple platforms
- [ ] Understand transformGroup concept
- [ ] Understand filter property for splitting files
- [ ] Understand buildPath organization
- [ ] Can identify which format is used for each platform

## Troubleshooting

### "style-dictionary: command not found"

Install Style Dictionary:
```bash
pnpm add -D style-dictionary
```

### Config syntax error

Check for:
- Missing commas between properties
- Proper module.exports syntax
- Valid JavaScript in filter functions

### Transform group not found

Use built-in groups:
- `css`, `js`, `ios`, `ios-swift`, `ios-swift-separate`, `android`

## Next

Proceed to Lab 8.2 to add token types and build all platforms.
