# Lab 4.2: Shared Configurations

## Objective

Create the shared configuration package with TypeScript and Tailwind configurations that all packages will use.

## Time Estimate

~30 minutes

## Prerequisites

- Completed Lab 4.1 (monorepo structure)

## Setup

### Quick Setup

```bash
./setup.sh
```

This will:
1. Ensure Lab 4.1 is complete
2. Create the config package structure
3. Create base, react, and nextjs TypeScript configs
4. Create shared Tailwind config

### Manual Setup

Navigate to the config package:
```bash
cd ../lab4.1/packages/config
```

## Exercises

### Exercise 1: Create Config Package Structure

Verify the structure after setup:

```bash
ls -la packages/config/
ls -la packages/config/tsconfig/
```

**Expected structure:**
```
packages/config/
├── tsconfig/
│   ├── base.json      # Base TypeScript config
│   ├── react.json     # React-specific config
│   └── nextjs.json    # Next.js-specific config
├── tailwind.config.js # Shared Tailwind config
└── package.json
```

### Exercise 2: Understand the Config Package.json

Examine `packages/config/package.json`:

```json
{
  "name": "@myapp/config",
  "version": "0.0.0",
  "private": true,
  "exports": {
    "./tsconfig/base": "./tsconfig/base.json",
    "./tsconfig/react": "./tsconfig/react.json",
    "./tsconfig/nextjs": "./tsconfig/nextjs.json",
    "./tailwind": "./tailwind.config.js"
  }
}
```

**Key points:**
- `private: true`: Won't be published to npm
- `exports`: Defines what other packages can import
- Other packages will use: `"extends": "@myapp/config/tsconfig/react"`

### Exercise 3: Examine Base TypeScript Config

Open `packages/config/tsconfig/base.json`:

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "compilerOptions": {
    "target": "ES2020",
    "lib": ["ES2020"],
    "module": "ESNext",
    "moduleResolution": "bundler",
    "strict": true,
    "declaration": true,
    "declarationMap": true,
    "sourceMap": true,
    "esModuleInterop": true,
    "allowSyntheticDefaultImports": true,
    "forceConsistentCasingInFileNames": true,
    "skipLibCheck": true,
    "resolveJsonModule": true,
    "isolatedModules": true
  }
}
```

**Key settings explained:**

| Setting | Purpose |
|---------|---------|
| `target: "ES2020"` | Output JavaScript version |
| `moduleResolution: "bundler"` | Modern resolution for bundlers |
| `strict: true` | Enable all strict checks |
| `declaration: true` | Generate .d.ts type files |
| `isolatedModules: true` | Required for fast transpilers |

### Exercise 4: Understand Config Inheritance

**React config** extends base:

```json
{
  "extends": "./base.json",
  "compilerOptions": {
    "lib": ["ES2020", "DOM", "DOM.Iterable"],
    "jsx": "react-jsx",
    "noEmit": true
  }
}
```

Adds:
- DOM types for browser APIs
- JSX transform (React 17+)
- `noEmit` because bundler handles output

**Next.js config** extends react:

```json
{
  "extends": "./react.json",
  "compilerOptions": {
    "plugins": [{ "name": "next" }],
    "module": "ESNext",
    "moduleResolution": "bundler",
    "allowJs": true
  }
}
```

Adds:
- Next.js plugin for better IDE support
- Allows JavaScript files

### Exercise 5: Examine Shared Tailwind Config

Open `packages/config/tailwind.config.js`:

```javascript
/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    // Include all packages and apps
    "../../packages/ui/src/**/*.{js,ts,jsx,tsx}",
    "./src/**/*.{js,ts,jsx,tsx}",
    "./app/**/*.{js,ts,jsx,tsx}",
    "./components/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      // Custom theme values can be added here
      // Or import from tokens package
    },
  },
  plugins: [],
};
```

**Why this content pattern?**

The `content` array tells Tailwind where to look for class names:
- `../../packages/ui/src/**/*` - UI components (relative from an app)
- `./src/**/*`, `./app/**/*` - Local app files

### Exercise 6: How Packages Will Use These Configs

When you configure a package, you'll extend these configs:

**In packages/ui/tsconfig.json:**
```json
{
  "extends": "@myapp/config/tsconfig/react",
  "include": ["src/**/*"]
}
```

**In apps/web/tsconfig.json:**
```json
{
  "extends": "@myapp/config/tsconfig/nextjs",
  "include": ["**/*.ts", "**/*.tsx"]
}
```

**In apps/web/tailwind.config.ts:**
```typescript
import baseConfig from "@myapp/config/tailwind";

export default {
  ...baseConfig,
  content: [
    ...baseConfig.content,
    // Additional app-specific paths
  ],
};
```

## Key Concepts

### Why Shared Configurations?

| Problem | Solution |
|---------|----------|
| Duplicated tsconfig in every package | Single source of truth |
| Inconsistent TypeScript settings | Everyone uses same strict settings |
| Tailwind content paths scattered | Centralized content configuration |
| Config drift over time | One place to update |

### Config Inheritance Chain

```
base.json
   ↓
react.json (adds DOM, JSX)
   ↓
nextjs.json (adds Next.js plugins)
```

This allows packages to pick the right level:
- Utility libraries: `base`
- React component libraries: `react`
- Next.js applications: `nextjs`

### The exports Field

The `exports` field in package.json controls what can be imported:

```json
{
  "exports": {
    "./tsconfig/base": "./tsconfig/base.json"
  }
}
```

This allows:
```json
{ "extends": "@myapp/config/tsconfig/base" }
```

Without exports, Node wouldn't know how to resolve this path.

## Checklist

Before proceeding to Lab 4.3:

- [ ] Config package created at packages/config/
- [ ] package.json with exports field
- [ ] base.json TypeScript config
- [ ] react.json extending base
- [ ] nextjs.json extending react
- [ ] tailwind.config.js with content paths
- [ ] You understand config inheritance

## Troubleshooting

### "Cannot find module '@myapp/config/tsconfig/react'"

The exports field might be wrong. Check that package.json exports match the file paths:

```json
{
  "exports": {
    "./tsconfig/react": "./tsconfig/react.json"
  }
}
```

### TypeScript errors about DOM types

Make sure you're extending the right config:
- For Node.js: extend `base`
- For React/browser: extend `react` or `nextjs`

## Next

Proceed to Lab 4.3 to wire up the tokens and UI packages.
