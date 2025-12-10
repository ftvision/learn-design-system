# Lab 2.4: Build and Test Tokens

## Objective

Configure Style Dictionary to transform your JSON tokens into CSS, JavaScript, and other platform formats. Then test the generated tokens in an HTML file.

## Time Estimate

~30 minutes

## Prerequisites

- Completed Labs 2.1-2.3 (all token files created)

## Setup

### Quick Setup

```bash
./setup.sh
```

This will:
1. Ensure all previous labs are complete
2. Create the Style Dictionary configuration file
3. Build the tokens
4. Create a test HTML file

### Manual Setup

Navigate to your tokens package:
```bash
cd ../lab2.1/packages/tokens
```

## Exercises

### Exercise 1: Create Style Dictionary Configuration

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

**Understanding the config:**
- `source`: Where to find token JSON files
- `platforms`: Different output formats
- `transformGroup`: Predefined transformations (e.g., `css` converts colors, sizes)
- `buildPath`: Where to output files
- `files`: Output file configuration
- `outputReferences`: Keep references to other tokens in output

### Exercise 2: Build the Tokens

Run the build:

```bash
npm run build
```

**Expected output:**
```
css
✔︎ build/css/variables.css

js
✔︎ build/js/tokens.js

ts
✔︎ build/ts/tokens.ts

json
✔︎ build/json/tokens.json
```

### Exercise 3: Inspect the CSS Output

View the generated CSS:

```bash
cat build/css/variables.css
```

**Sample output:**
```css
:root {
  --color-primary-50: #E3F2FD;
  --color-primary-100: #BBDEFB;
  --color-primary-500: #2196F3;
  /* ... */
  --spacing-0: 0;
  --spacing-1: 4px;
  --spacing-2: 8px;
  /* ... */
  --font-size-base: 1rem;
  --font-weight-bold: 700;
  /* ... */
}
```

**Questions:**
1. How did Style Dictionary transform `color.primary.500` into `--color-primary-500`?
2. What naming convention does it use (kebab-case)?
3. Are the values transformed (e.g., colors, sizes)?

### Exercise 4: Inspect the JavaScript Output

View the generated JavaScript:

```bash
cat build/js/tokens.js
```

**Sample output:**
```javascript
export const ColorPrimary50 = "#e3f2fd";
export const ColorPrimary100 = "#bbdefb";
export const ColorPrimary500 = "#2196f3";
// ...
export const Spacing0 = "0";
export const Spacing1 = "4px";
// ...
```

**Questions:**
1. How are the variable names formatted (PascalCase)?
2. How would you import these in a React component?

### Exercise 5: Create a Test HTML File

Create `test.html` in the tokens package:

```html
<!DOCTYPE html>
<html>
<head>
  <title>Design Token Test</title>
  <link rel="stylesheet" href="build/css/variables.css">
  <style>
    * {
      box-sizing: border-box;
      margin: 0;
      padding: 0;
    }

    body {
      font-family: var(--font-family-sans);
      padding: var(--spacing-6);
      background: var(--color-neutral-50);
      color: var(--color-neutral-900);
      line-height: var(--font-line-height-normal);
    }

    h1 {
      font-size: var(--font-size-2xl);
      font-weight: var(--font-weight-bold);
      margin-bottom: var(--spacing-4);
    }

    .card {
      background: var(--color-neutral-0);
      padding: var(--spacing-6);
      border-radius: var(--border-radius-lg);
      box-shadow: var(--shadow-md);
      margin-bottom: var(--spacing-4);
    }

    .button {
      display: inline-block;
      background: var(--color-primary-500);
      color: white;
      padding: var(--spacing-2) var(--spacing-4);
      border: none;
      border-radius: var(--border-radius-default);
      font-size: var(--font-size-sm);
      font-weight: var(--font-weight-medium);
      cursor: pointer;
      margin-right: var(--spacing-2);
    }

    .button:hover {
      background: var(--color-primary-600);
    }

    .button--success {
      background: var(--color-success-default);
    }

    .button--success:hover {
      background: var(--color-success-dark);
    }

    .button--error {
      background: var(--color-error-default);
    }

    .button--error:hover {
      background: var(--color-error-dark);
    }

    .text-muted {
      color: var(--color-neutral-600);
      font-size: var(--font-size-sm);
    }

    .spacing-demo {
      display: flex;
      gap: var(--spacing-2);
      margin-top: var(--spacing-4);
    }

    .spacing-box {
      background: var(--color-primary-100);
      padding: var(--spacing-2);
      border-radius: var(--border-radius-sm);
    }
  </style>
</head>
<body>
  <div class="card">
    <h1>Design Token Test</h1>
    <p class="text-muted" style="margin-bottom: var(--spacing-4);">
      This page demonstrates design tokens in action.
    </p>

    <h2 style="font-size: var(--font-size-lg); margin-bottom: var(--spacing-3);">Buttons</h2>
    <div style="margin-bottom: var(--spacing-4);">
      <button class="button">Primary</button>
      <button class="button button--success">Success</button>
      <button class="button button--error">Error</button>
    </div>

    <h2 style="font-size: var(--font-size-lg); margin-bottom: var(--spacing-3);">Spacing Scale</h2>
    <div class="spacing-demo">
      <div class="spacing-box" style="width: var(--spacing-4);">4</div>
      <div class="spacing-box" style="width: var(--spacing-8);">8</div>
      <div class="spacing-box" style="width: var(--spacing-12);">12</div>
      <div class="spacing-box" style="width: var(--spacing-16);">16</div>
    </div>
  </div>

  <div class="card">
    <h2 style="font-size: var(--font-size-lg); margin-bottom: var(--spacing-3);">Shadow Scale</h2>
    <div style="display: flex; gap: var(--spacing-4); flex-wrap: wrap;">
      <div style="padding: var(--spacing-4); background: white; box-shadow: var(--shadow-sm);">shadow-sm</div>
      <div style="padding: var(--spacing-4); background: white; box-shadow: var(--shadow-default);">shadow-default</div>
      <div style="padding: var(--spacing-4); background: white; box-shadow: var(--shadow-md);">shadow-md</div>
      <div style="padding: var(--spacing-4); background: white; box-shadow: var(--shadow-lg);">shadow-lg</div>
    </div>
  </div>
</body>
</html>
```

### Exercise 6: Test in Browser

Open `test.html` in your browser:

```bash
# macOS
open test.html

# Or use a simple server
npx serve .
```

**Verify:**
- [ ] The page renders correctly
- [ ] Colors match your token definitions
- [ ] Buttons have proper hover states
- [ ] Spacing looks consistent
- [ ] Shadows have different levels

### Exercise 7: Modify a Token and Rebuild

Try changing a token value:

1. Edit `src/colors.json` and change `primary.500` to a different color (e.g., `#9C27B0` for purple)
2. Rebuild: `npm run build`
3. Refresh `test.html`

**Observe:** All elements using `--color-primary-500` automatically update!

## Key Concepts

### Style Dictionary Transform Groups

**css transform group:**
- `attribute/cti`: Adds category/type/item attributes
- `name/cti/kebab`: Creates kebab-case names
- `color/css`: Formats colors for CSS

**js transform group:**
- `attribute/cti`: Adds category/type/item attributes
- `name/cti/pascal`: Creates PascalCase names
- `color/hex`: Formats colors as hex

### Output References

With `outputReferences: true`, tokens that reference other tokens keep those references:

```css
/* Without outputReferences */
--semantic-text-default: #212121;

/* With outputReferences */
--semantic-text-default: var(--color-neutral-900);
```

This is useful for:
- Easier debugging (see the reference chain)
- Dynamic theming (change the referenced value)

## Build Output Structure

After building, your directory should look like:

```
packages/tokens/
├── src/
│   ├── colors.json
│   ├── spacing.json
│   ├── typography.json
│   ├── shadows.json
│   └── borders.json
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

## Checklist

Before proceeding to Lab 2.5:

- [ ] Created `style-dictionary.config.js`
- [ ] Successfully ran `npm run build`
- [ ] Inspected CSS output and understand the naming convention
- [ ] Inspected JavaScript output
- [ ] Created and tested `test.html`
- [ ] Modified a token and verified the change

## Reflection Questions

1. What's the advantage of generating tokens for multiple platforms from one source?
2. How would you add a new platform output (e.g., SCSS variables)?
3. When would you use JavaScript tokens vs CSS custom properties?

## Next

Proceed to Lab 2.5 to compare your token system with real-world projects.
