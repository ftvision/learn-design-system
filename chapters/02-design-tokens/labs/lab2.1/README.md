# Lab 2.1: Project Setup - Initialize Your Token System

## Objective

Set up a tokens package using Style Dictionary to transform design tokens from JSON source files into platform-specific outputs (CSS, JS, TypeScript).

## Time Estimate

~20 minutes

## Prerequisites

- Node.js 18+ installed
- npm or pnpm available
- Completed Chapter 1 (understanding of design system layers)

## Setup

### Quick Setup

```bash
./setup.sh
```

This will:
1. Create the tokens package structure
2. Initialize npm with the correct package.json
3. Install Style Dictionary

### Manual Setup

If you prefer to do it manually:

```bash
# Navigate to the lab directory
cd chapters/02-design-tokens/labs/lab2.1

# Create the package structure
mkdir -p packages/tokens/src
cd packages/tokens

# Initialize npm
npm init -y

# Install Style Dictionary
npm install style-dictionary
```

## Exercises

### Exercise 1: Understand the Structure

After setup, examine the directory structure:

```bash
ls -la packages/tokens/
```

**Expected structure:**
```
packages/tokens/
├── src/           # Token source files go here
├── package.json   # Package configuration
└── node_modules/  # Dependencies
```

**Questions to answer:**
1. What does `package.json` contain after initialization?
2. What is Style Dictionary and why do we use it?

### Exercise 2: Examine package.json

Open `packages/tokens/package.json`:

```bash
cat packages/tokens/package.json
```

**Questions to answer:**
1. What is the package name?
2. What version of Style Dictionary is installed?
3. What scripts are defined?

### Exercise 3: Understand Style Dictionary

Read about Style Dictionary's purpose:

Style Dictionary transforms design tokens defined in JSON/YAML into multiple platform formats:
- CSS Custom Properties (variables)
- JavaScript/TypeScript constants
- iOS Swift enums
- Android XML resources

**Draw the flow:**
```
tokens/colors.json  ─┐
tokens/spacing.json ─┼─► Style Dictionary ─┬─► build/css/variables.css
tokens/fonts.json   ─┘                     ├─► build/js/tokens.js
                                           └─► build/json/tokens.json
```

**Questions to answer:**
1. Why is it useful to define tokens in one format and output to many?
2. What would happen if you had to manually maintain CSS, JS, and JSON versions of the same tokens?

## Key Concepts

### What Are Design Tokens?

Design tokens are the atomic values of your design system:
- Colors: `#2196F3`, `rgba(0, 0, 0, 0.1)`
- Spacing: `4px`, `8px`, `16px`
- Typography: `16px`, `1.5`, `'Inter'`
- Shadows: `0 1px 2px rgba(0, 0, 0, 0.05)`
- Border radii: `4px`, `8px`, `9999px`

### The Problem Tokens Solve

Without tokens:
```tsx
// File 1: Button.tsx
<button style={{ backgroundColor: '#2196F3' }}>Click me</button>

// File 2: Link.tsx
<a style={{ color: '#2196f3' }}>Learn more</a>  // Different case!

// File 3: Header.tsx
<header style={{ borderBottom: '1px solid #2196F3' }}>...</header>
```

With tokens:
```tsx
// Define once
:root { --color-primary: #2196F3; }

// Use everywhere
<button style={{ backgroundColor: 'var(--color-primary)' }}>Click me</button>
<a style={{ color: 'var(--color-primary)' }}>Learn more</a>
<header style={{ borderBottom: '1px solid var(--color-primary)' }}>...</header>
```

## Checklist

Before proceeding to Lab 2.2:

- [ ] The `packages/tokens` directory exists
- [ ] `package.json` is initialized with Style Dictionary
- [ ] You understand what design tokens are
- [ ] You understand the problem tokens solve
- [ ] You understand Style Dictionary's role

## Troubleshooting

### npm install fails

Ensure you have Node.js 18+ installed:
```bash
node --version
```

### Permission errors

Try running without sudo, or check your npm permissions:
```bash
npm config get prefix
```

## Next

Proceed to Lab 2.2 to create color tokens.
